---
title: "Code"
date: 2020-02-03T13:41:29+01:00
type: docs
math: "true"
weight: 43
description: >
  A bunch of code.
---

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// load parameters
// ...
// A new model instance
Model model = new Model("Aircraft landing");
// Variables declaration
IntVar[] planes = IntStream
        .range(0, N)
        .mapToObj(i -> model.intVar("plane #" + i, LT[i][0], LT[i][2], false))
        .toArray(IntVar[]::new);
IntVar[] earliness = IntStream
        .range(0, N)
        .mapToObj(i -> model.intVar("earliness #" + i, 0, LT[i][1] - LT[i][0], false))
        .toArray(IntVar[]::new);
IntVar[] tardiness = IntStream
        .range(0, N)
        .mapToObj(i -> model.intVar("tardiness #" + i, 0, LT[i][2] - LT[i][1], false))
        .toArray(IntVar[]::new);

IntVar tot_dev = model.intVar("tot_dev", 0, IntVar.MAX_INT_BOUND);

// Constraint posting
// one plane per runway at a time:
model.allDifferent(planes).post();
// for each plane 'i'
for(int i = 0; i < N; i++){
    // maintain earliness
    earliness[i].eq((planes[i].neg().add(LT[i][1])).max(0)).post();
    // and tardiness
    tardiness[i].eq((planes[i].sub(LT[i][1])).max(0)).post();
    // disjunctions: 'i' lands before 'j' or 'j' lands before 'i'
    for(int j = i+1; j < N; j++){
        Constraint iBeforej = model.arithm(planes[i], "<=", planes[j], "-", ST[i][j]);
        Constraint jBeforei = model.arithm(planes[j], "<=", planes[i], "-", ST[j][i]);
        model.addClausesBoolNot(iBeforej.reify(), jBeforei.reify());
    }
}
// prepare coefficients of the scalar product
int[] cs = new int[N*2];
for(int i = 0 ; i < N; i++){
    cs[i] = PC[i][0];
    cs[i + N] = PC[i][1];
}
model.scalar(ArrayUtils.append(earliness, tardiness), cs, "=", tot_dev).post();
{{< /tab >}}
{{< /tabpane >}}

Note that all variables could be bounded, since no constraint makes
holes in the domain. However, turning them into enumerated ones will be
required to design an efficient search strategy.

The objective variable, 'tot\_dev' is declared with an arbitrary large
upper bound. Instead of using `Integer.MAX\_VALUE`, we call
`IntVar.MAX\_INT\_BOUND` a pre-defined parameter not too big to limit
overflow. A better solution would be to compute the real bounds of the
variable, based on LT and PC. In our case $[\\![0,117790]\\!]$ is the
smallest interval that eliminates no solution.

The *alldifferent* constraint (line 23) is redundant with disjunction
constraints (lines 31-35). But it provides stronger filtering.

The declaration of the disjunction (line 34) does not require to post
the constraint. Calling method like 'addClause\*' add clauses to a
specific clause store which acts as specific singleton constraint. The
code can however replaced by :

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
model.or(iBeforej,jBeforei).post();
{{< /tab >}}
{{< /tabpane >}}

In that case, the logical expression will be transformed into a sum
constraint. Yet, $\frac{N \times (N-1)}{2}$ constraints will be added to
the solver.

A search strategy
-----------------

Intuitively, a good strategy to solve the problem is to select first the
variable whom distance to the target landing time and the closest
possible landing time is the biggest. It tends to avoid letting a plane
with already late (resp. early) being even more late (resp. early).

Then, for a given plane, we want to minimize the distance to the target
landing time. So we simply choose the value in its domain closest to the
target landing time.

First, we map each plane with its target landing time:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
Map<IntVar, Integer> map =
    IntStream.range(0, N)
             .boxed()
             .collect(Collectors.toMap(i -> planes[i], i -> LT[i][1]));
{{< /tab >}}
{{< /tabpane >}}

Then, for a given plane, a function is created to look for the possible
landing time closest to the target landing time:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
private static int closest(IntVar var, Map<IntVar, Integer> map) {
    int target = map.get(var);
    if (var.contains(target)) {
        return target;
    } else {
        int p = var.previousValue(target);
        int n = var.nextValue(target);
        return Math.abs(target - p) < Math.abs(n - target) ? p : n;
    }
}
{{< /tab >}}
{{< /tabpane >}}

Note that, `var.previousValue(target)` can return `Integer.MIN\_VALUE` which
indicates that there is no value before target in the domain of var
(same goes with `var.nextValue(target)` and `Integer.MAX\_VALUE)`. That's
why the absolute difference is computed, and the minimum is returned.

Finally, the search strategy is defined:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
solver.setSearch(Search.intVarSearch(
    variables -> Arrays.stream(variables)
          .filter(v -> !v.isInstantiated())
          .min((v1, v2) -> closest(v2, map) - closest(v1, map))
          .orElse(null),
    var -> closest(var, map),
    DecisionOperator.int_eq,
    planes
));
{{< /tab >}}
{{< /tabpane >}}

Lines 2-7: non-instantiated variables are filtered and the more distant
to the target landing time is returned. Note that if all variables are
instantiated, null is expected to indicate that the strategy runs dry.
Line 8: the closest possible landing time for a given variable is
returned. Line 9: the decision is based on the assignment operator. Left
decision branch is assignment, right decision branch (refutation) is
value removal. That is why the domain of planes must be enumerated. Line
10: the scope variables is defined.

The three instructions (Lines2-10) are input in
`SearchStrategyFactory.intVarSearch(VariableSelector<IntVar>,IntValueSelector,IntVar...)` which builds in return a integer
variable search strategy.

The resolution objective
------------------------

The objective is to minimize 'tot\_dev'.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// Find a solution that minimizes 'tot_dev'
Solution best = solver.findOptimalSolution(tot_dev, false);
{{< /tab >}}
{{< /tabpane >}}

This method attempts to find the optimal solution.

If one wants to interact with each solution without using the unfold
resolution process, she/he can plug a solution monitor to the solver.
Such monitor implements an one-method interface called on each solution:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
solver.plugMonitor((IMonitorSolution) () -> {
    for (int i = 0; i < N; i++) {
        System.out.printf("%s lands at %d (%d)\n",
                planes[i].getName(),
                planes[i].getValue(),
                planes[i].getValue() - LT[i][1]);
    }
    System.out.printf("Deviation cost: %d\n", tot_dev.getValue());
});
{{< /tab >}}
{{< /tabpane >}}

We print here the real landing time and the distance to the target
landing time for each plane and the total deviation cost.

The entire code
---------------

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// number of planes
int N = 10;
// Times per plane:
// {earliest landing time, target landing time, latest landing time}
int[][] LT = {
        {129, 155, 559},
        {195, 258, 744},
        {89, 98, 510},
        {96, 106, 521},
        {110, 123, 555},
        {120, 135, 576},
        {124, 138, 577},
        {126, 140, 573},
        {135, 150, 591},
        {160, 180, 657}};
// penalty cost penalty cost per unit of time per plane:
// {for landing before target, after target}
int[][] PC = {
        {10, 10},
        {10, 10},
        {30, 30},
        {30, 30},
        {30, 30},
        {30, 30},
        {30, 30},
        {30, 30},
        {30, 30},
        {30, 30}};
// Separation time required after i lands before j can land
int[][] ST = {
        {99999, 3, 15, 15, 15, 15, 15, 15, 15, 15},
        {3, 99999, 15, 15, 15, 15, 15, 15, 15, 15},
        {15, 15, 99999, 8, 8, 8, 8, 8, 8, 8},
        {15, 15, 8, 99999, 8, 8, 8, 8, 8, 8},
        {15, 15, 8, 8, 99999, 8, 8, 8, 8, 8},
        {15, 15, 8, 8, 8, 99999, 8, 8, 8, 8},
        {15, 15, 8, 8, 8, 8, 99999, 8, 8, 8},
        {15, 15, 8, 8, 8, 8, 8, 999999, 8, 8},
        {15, 15, 8, 8, 8, 8, 8, 8, 99999, 8},
        {15, 15, 8, 8, 8, 8, 8, 8, 8, 99999}};

Model model = new Model("Aircraft landing");
// Variables declaration
IntVar[] planes = IntStream
        .range(0, N)
        .mapToObj(i -> model.intVar("plane #" + i, LT[i][0], LT[i][2], false))
        .toArray(IntVar[]::new);
IntVar[] earliness = IntStream
        .range(0, N)
        .mapToObj(i -> model.intVar("earliness #" + i, 0, LT[i][1] - LT[i][0], false))
        .toArray(IntVar[]::new);
IntVar[] tardiness = IntStream
        .range(0, N)
        .mapToObj(i -> model.intVar("tardiness #" + i, 0, LT[i][2] - LT[i][1], false))
        .toArray(IntVar[]::new);
IntVar tot_dev = model.intVar("tot_dev", 0, IntVar.MAX_INT_BOUND);
// Constraint posting
// one plane per runway at a time:
model.allDifferent(planes).post();
// for each plane 'i'
for (int i = 0; i < N; i++) {
    // maintain earliness
    earliness[i].eq((planes[i].neg().add(LT[i][1])).max(0)).post();
    // and tardiness
    tardiness[i].eq((planes[i].sub(LT[i][1])).max(0)).post();
    // disjunctions: 'i' lands before 'j' or 'j' lands before 'i'
    for (int j = i + 1; j < N; j++) {
        Constraint iBeforej = model.arithm(planes[i], "<=", planes[j], "-", ST[i][j]);
        Constraint jBeforei = model.arithm(planes[j], "<=", planes[i], "-", ST[j][i]);
        model.addClausesBoolNot(iBeforej.reify(), jBeforei.reify()); // no need to post
    }
}
// prepare coefficients of the scalar product
int[] cs = new int[N * 2];
for (int i = 0; i < N; i++) {
    cs[i] = PC[i][0];
    cs[i + N] = PC[i][1];
}
model.scalar(ArrayUtils.append(earliness, tardiness), cs, "=", tot_dev).post();
// Resolution process
Solver solver = model.getSolver();
solver.plugMonitor((IMonitorSolution) () -> {
    for (int i = 0; i < N; i++) {
        System.out.printf("%s lands at %d (%d)\n",
                planes[i].getName(),
                planes[i].getValue(),
                planes[i].getValue() - LT[i][1]);
    }
    System.out.printf("Deviation cost: %d\n", tot_dev.getValue());
});
Map<IntVar, Integer> map = IntStream
        .range(0, N)
        .boxed()
        .collect(Collectors.toMap(i -> planes[i], i -> LT[i][1]));
solver.setSearch(Search.intVarSearch(
    variables -> Arrays.stream(variables)
          .filter(v -> !v.isInstantiated())
          .min((v1, v2) -> closest(v2, map) - closest(v1, map))
          .orElse(null),
    var -> closest(var, map),
    DecisionOperatorFactory.makeIntEq(),
    planes
));
solver.showShortStatistics();
solver.findOptimalSolution(tot_dev, false);
{{< /tab >}}
{{< /tabpane >}}

The best solution found is:

```
plane #0 lands at 165 (10)
plane #1 lands at 258 (0)
plane #2 lands at 98 (0)
plane #3 lands at 106 (0)
plane #4 lands at 118 (-5)
plane #5 lands at 134 (-1)
plane #6 lands at 126 (-12)
plane #7 lands at 142 (2)
plane #8 lands at 150 (0)
plane #9 lands at 180 (0)
Deviation cost: 700
Model[Aircraft landing], 7 Solutions, Minimize tot_dev = 700, Resolution time 0,326s, 906 Nodes (2 781,1 n/s), 1756 Backtracks, 883 Fails, 0 Restarts
Model[Aircraft landing], 7 Solutions, Minimize tot_dev = 700, Resolution time 12,608s, 246096 Nodes (19 519,6 n/s), 492179 Backtracks, 246083 Fails, 0 Restarts
```

The second to last line of the console sums up the resolution statistics
when the last solution was found :

-   this is the twelfth solution, its cost is 700 ('tot\_dev'), it took
    326ms and 906 nodes were opened to find it.

The last line of the console sums up to resolution statistics of the
entire resolution, including optimality proof:

- 7 solutions were found, 12,608s seconds and 246096 nodes were needed
to explore the entire search space and prove the optimality of the last
solution found.

If the plane selection is turned upside down (less late (early) plane is
selected first) the resolution statistics change a bit:

```
Model[Aircraft landing], 12 Solutions, Minimize tot_dev = 700, Resolution time 0,514s, 2147 Nodes (4 180,8 n/s), 4222 Backtracks, 2119 Fails, 0 Restarts
Model[Aircraft landing], 12 Solutions, Minimize tot_dev = 700, Resolution time 4,505s, 71596 Nodes (15 892,4 n/s), 143169 Backtracks, 71573 Fails, 0 Restarts
```

We can see that more intermediate solutions were found (12 vs. 7) and
that it took more time to find the best solution (514ms and 2147 nodes
vs. 326ms and 906 nodes) but the optimality is proven faster (4,505s and
71596 nodes vs. 12,608s and 246096 nodes).

This demonstrates that a strategy that is quick to produce the best
solution may be unable to prove its optimality efficiently.

Things to remember
------------------

-   A good estimation of the variables domain is important to limit
    overflow and reduce the induce search space.
-   Redundant constraints can reduce the search space too, but can also
    slow down the propagation loop. Their benefit should be evaluated.
-   Most of the time adding clauses instead of logical constraints
    limits the memory footprint and provide an equivalent filtering
    quality.
-   A decision, result of a search strategy, is a combination of a
    variable, a value and an operator.
-   Monitors can be plugged to the solver to interact with the search,
    specifically on solution.
-   Accurate search strategy design is the key to efficient resolution.