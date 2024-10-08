---
title: "Code"
date: 2020-01-31T14:26:13+01:00
type: docs
math: "true"
weight: 23
description: >
  A bunch of code.
---

Model with a global interpretation
----------------------------------

The first model is based on the global interpretation of the equation.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
Model model = new Model("SEND+MORE=MONEY");
IntVar S = model.intVar("S", 1, 9, false);
IntVar E = model.intVar("E", 0, 9, false);
IntVar N = model.intVar("N", 0, 9, false);
IntVar D = model.intVar("D", 0, 9, false);
IntVar M = model.intVar("M", 1, 9, false);
IntVar O = model.intVar("0", 0, 9, false);
IntVar R = model.intVar("R", 0, 9, false);
IntVar Y = model.intVar("Y", 0, 9, false);

model.allDifferent(new IntVar[]{S, E, N, D, M, O, R, Y}).post();

IntVar[] ALL = new IntVar[]{
    S, E, N, D,
    M, O, R, E,
    M, O, N, E, Y};
int[] COEFFS = new int[]{
    1000, 100, 10, 1,
    1000, 100, 10, 1,
    -10000, -1000, -100, -10, -1};
model.scalar(ALL, COEFFS, "=", 0).post();

Solver solver = model.getSolver();
solver.showStatistics();
solver.showSolutions();
solver.findSolution();
{{< /tab >}}
{{< /tabpane >}}

The solution found is:

```
** Choco 3.3.3 (2015-12) : Constraint Programming Solver, Copyleft (c) 2010-2015
- Model[Model-0] features:
    Variables : 9
    Constraints : 4
    Default search strategy : no
    Completed search strategy : no
- Solution #1 found. Model[Model-0], 1 Solutions, Resolution time 0,004s, 3 Nodes (742,4 n/s), 1 Backtracks, 1 Fails, 0 Restarts
    S = 9 E = 5 N = 6 D = 7 M = 1 0 = 0 R = 8 Y = 2 .
- Complete search - 1 solution found.
    Model[Model-0]
    Solutions: 1
    Building time : 0,000s
    Resolution time : 0,008s
    Nodes: 3 (383,5 n/s)
    Backtracks: 1
    Fails: 1
    Restarts: 0
```

The *alldifferent* constraint (line 11) makes sure all letters are
distinct.

Then, instead of using expressions, which tend to be too verbose, we
directly declare a scalar product and post it (lines 13-21). Thus, the
expression is not decomposed on posting (no additional variables are
introduced) and it ensures a better filtering. Alternatively, the
expression could have been post in extension, providing an even better
filtering algorithm, but at high pre-process time.

Finally, we rely on the capacity of the solver to output data on console
(lines 24-25). Basic search statistics (time, nodes, etc) are reported
but also a pre-defined solution format: each variable's name is followed
a "=" sign and the value of the variable in the solution. This avoids
getting a solution object and reads it.

Another alternative would be to call solver.solve() which looks for the
first solution (if any) and stops *on it*, that is, on a state wherein
each variable is assigned to a single value. Their value can then be
read calling S.getValue():

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
model.getSolver().showStatistics();
if (model.getSolver().solve()) {
    System.out.printf("%s = %d\n", S.getName(), S.getValue());
    System.out.printf("%s = %d\n", E.getName(), E.getValue());
    // ...
}
{{< /tab >}}
{{< /tabpane >}}

{{% alert title="Hint" color="primary" %}}
Simply replace the `if` statement by a `while` statement to look for all solutions and print
them all. However, this problem has only one solution.
{{% /alert %}}


Model with a local interpretation
---------------------------------

The second model requires to introduces 3 additional variables.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// additional variables: the carries
BoolVar[] r = model.boolVarArray(3);
// declare local equations
D.add(E).eq(Y.add(r[0].mul(10))).post();
r[0].add(N).add(R).eq(E.add(r[1].mul(10))).post();
r[1].add(E).add(O).eq(N.add(r[2].mul(10))).post();
r[2].add(S).add(M).eq(O.add(M.mul(10))).post();
{{< /tab >}}
{{< /tabpane >}}

Doing so, we increase the number of variables and constraints and
introduce some search noise. Indeed, without indication on how to
explore the search, the solver will consider all variables as decisions
ones, that is as search leader. But, we may want only to branch on
letters and ignoring other ones (basically, the carries which are
assigned by propagation.

To do so, we can precise the *decision variables* and how to branch on
it:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
solver.setSearch(Search.inputOrderLBSearch(S, E, N, D, M, O, R, Y));
{{< /tab >}}
{{< /tabpane >}}

Here, we consider the variables in the input order (`S` is selected first,
then `E`, then `N`, ...) and each of them are, in turn, assigned to their
current lower bound.

Things to remember
------------------

-   There exists multiple ways to declare expressions. Specific ones,
    like sum or scalar product, should be considered when modeling a
    problem.
-   Extension constraints provide a powerful filtering algorithm but may
    come at a high pre-process time.
-   The Solver enables having access to a solution by calling the
    solve() method. This is also an easy way to loop over all solutions.
-   Defining a (dedicated) search strategy is a good habit to help the
    solver exploring the search space.