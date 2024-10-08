---
title: "Code"
date: 2020-02-03T13:35:26+01:00
type: docs
math: "true"
weight: 33
description: >
  A bunch of code.
---

A model
-------

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// load parameters
// ...
// A new model instance
Model model = new Model("WarehouseLocation");

// VARIABLES
// a warehouse is either open or closed
BoolVar[] open = model.boolVarArray("o", W);
// which warehouse supplies a store
IntVar[] supplier = model.intVarArray("supplier", S, 1, W, false);
// supplying cost per store
IntVar[] cost = model.intVarArray("cost", S, 1, 96, true);
// Total of all costs
IntVar tot_cost = model.intVar("C", 0, 99999, true);

// CONSTRAINTS
for (int j = 0; j < S; j++) {
    // a warehouse is 'open', if it supplies to a store
    model.element(model.intVar(1), open, supplier[j], 1).post();
    // Compute 'cost' for each store
    model.element(cost[j], P[j], supplier[j], 1).post();
}
for (int i = 0; i < W; i++) {
    // additional variable 'occ' is created on the fly
    // its domain includes the constraint on capacity
    IntVar occ = model.intVar("occur_" + i, 0, K[i], true);
    // for-loop starts at 0, warehouse index starts at 1
    // => we count occurrences of (i+1) in 'supplier'
    model.count(i+1, supplier, occ).post();
    // redundant link between 'occ' and 'open' for better propagation
    occ.ge(open[i]).post();
}
// Prepare the constraint that maintains 'tot_cost'
int[] coeffs = new int[W + S];
Arrays.fill(coeffs, 0, W, C);
Arrays.fill(coeffs, W, W + S, 1);
// then post it
model.scalar(ArrayUtils.append(open, cost), coeffs, "=", tot_cost).post();
{{< /tab >}}
{{< /tabpane >}}

The last parameter of the element constraints (line 19 and 21) indicates
an offset. It enables to adapt the index range wrt to the domain of the
variable: here supplier variables lower bound is 1. But, open array
index starts at 0 and an offset is needed to match supplier with open
array. In other words, first *element* constraint states that
$open[supplier[s] - o] = 1$ where $o$ is set to 1.

A search strategy
-----------------

Since the problem is hard to solve, defining an adapted strategy is a
key to success. Among all declared variables, the ones that holds the
problem are 'open' and 'supplier': deciding on these variables has a
great effect on the size of the search space reduction. They are named
after that effect as *decision variables*.

A good strategy for that problem is to select, among decisions
variables, the one with the smallest domain first. If two variables or
more have the smallest domain size, *ties* are broken randomly. Then,
the value in the middle of the domain of the selected variable is
assigned to it, with a floor rounding policy (the closest value greater
or equal to the middle value is returned).

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
Solver solver = model.getSolver();
solver.setSearch(Search.intVarSearch(
    new VariableSelectorWithTies<>(
        new FirstFail(model),
        new Smallest()),
    new IntDomainMiddle(false),
    ArrayUtils.append(supplier, cost, open))
);
{{< /tab >}}
{{< /tabpane >}}

The resolution objective
------------------------

The objective is to minimize 'tot\_cost'.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// Find a solution that minimizes 'tot_cost'
Solution best = solver.findOptimalSolution(tot_cost, false);
{{< /tab >}}
{{< /tabpane >}}

This method attempts to find the optimal solution.

{{% alert title="Hint" color="primary" %}}
Finding an optimal solution goes like this: anytime a solution is
found, a *cut* is posted on the objective variable to forbid worst or
same value solutions to be found. When a cut is so strong that no
better solution is found, the last one is the optimal one (if we
consider that no search limits was defined). The cut process is
entirely managed by the solver.
{{%/alert%}}

Alternatively, the search loop can be unfold.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
model.setObjective(false, tot_cost);
while(solver.solve()){
    // do something on solution
}
{{< /tab >}}
{{< /tabpane >}}

The objective variable and criteria should be declared, but there is no
need to post the cut manually, the solver manages this. When the unfold
search process is used, one can modify the way the cut is handled:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// Walking cut: allow same value solutions
solver.getObjectiveManager().<Integer>setCutComputer(obj -> obj);
model.setObjective(false, tot_cost);
while(solver.solve()){
    // do something on solution
}
{{< /tab >}}
{{< /tabpane >}}

Unfold search process allows you to execute code on solution easily.

One can add a limit to the resolution process. For example, a 10
second-limit can be defined like this:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
solver.limitTime("10s");
// then run the resolution
Solution best = solver.findOptimalSolution(tot_cost, false);
{{< /tab >}}
{{< /tabpane >}}

The search should be configured **before** being called. There can be
multiple limitations, in that case, the first reached stops the search.

Pretty solution output
----------------------

We can define a function that prints any solutions in a pretty way.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
private void prettyPrint(Model model, IntVar[] open, int W, IntVar[] supplier, int S, IntVar tot_cost) {
    StringBuilder st = new StringBuilder();
    st.append("Solution #").append(model.getSolver().getSolutionCount()).append("\n");
    for (int i = 0; i < W; i++) {
        if (open[i].getValue() > 0) {
            st.append(String.format("\tWarehouse %d supplies customers : ", (i + 1)));
            for (int j = 0; j < S; j++) {
                if (supplier[j].getValue() == (i + 1)) {
                    st.append(String.format("%d ", (j + 1)));
                }
            }
            st.append("\n");
        }
    }
    st.append("\tTotal C: ").append(tot_cost.getValue());
    System.out.println(st.toString());
}
{{< /tab >}}
{{< /tabpane >}}

Calling this method is made easy with the unfold resolution instruction.

The entire code
---------------

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// load parameters
// number of warehouses
int W = 5;
// number of stores
int S = 10;
// maintenance cost
int C = 30;
// capacity of each warehouse
int[] K = new int[]{1, 4, 2, 1, 3};
// matrix of supply costs, store x warehouse
int[][] P = new int[][]{
    {20, 24, 11, 25, 30},
    {28, 27, 82, 83, 74},
    {74, 97, 71, 96, 70},
    {2, 55, 73, 69, 61},
    {46, 96, 59, 83, 4},
    {42, 22, 29, 67, 59},
    {1, 5, 73, 59, 56},
    {10, 73, 13, 43, 96},
    {93, 35, 63, 85, 46},
    {47, 65, 55, 71, 95}};

// A new model instance
Model model = new Model("WarehouseLocation");

// VARIABLES
// a warehouse is either open or closed
BoolVar[] open = model.boolVarArray("o", W);
// which warehouse supplies a store
IntVar[] supplier = model.intVarArray("supplier", S, 1, W, false);
// supplying cost per store
IntVar[] cost = model.intVarArray("cost", S, 1, 96, true);
// Total of all costs
IntVar tot_cost = model.intVar("tot_cost", 0, 99999, true);

// CONSTRAINTS
for (int j = 0; j < S; j++) {
    // a warehouse is 'open', if it supplies to a store
    model.element(model.intVar(1), open, supplier[j], 1).post();
    // Compute 'cost' for each store
    model.element(cost[j], P[j], supplier[j], 1).post();
}
for (int i = 0; i < W; i++) {
    // additional variable 'occ' is created on the fly
    // its domain includes the constraint on capacity
    IntVar occ = model.intVar("occur_" + i, 0, K[i], true);
    // for-loop starts at 0, warehouse index starts at 1
    // => we count occurrences of (i+1) in 'supplier'
    model.count(i+1, supplier, occ).post();
    // redundant link between 'occ' and 'open' for better propagation
    occ.ge(open[i]).post();
}
// Prepare the constraint that maintains 'tot_cost'
int[] coeffs = new int[W + S];
Arrays.fill(coeffs, 0, W, C);
Arrays.fill(coeffs, W, W + S, 1);
// then post it
model.scalar(ArrayUtils.append(open, cost), coeffs, "=", tot_cost).post();

model.setObjective(Model.MINIMIZE, tot_cost);
Solver solver = model.getSolver();
solver.setSearch(Search.intVarSearch(
    new VariableSelectorWithTies<>(
        new FirstFail(model),
        new Smallest()),
    new IntDomainMiddle(false),
    ArrayUtils.append(supplier, cost, open))
);
solver.showShortStatistics();
while(solver.solve()){
    prettyPrint(model, open, W, supplier, S, tot_cost);
}
{{< /tab >}}
{{< /tabpane >}}

The best solution found is:

```
Solution #23
    Warehouse 1 supplies customers : 4
    Warehouse 2 supplies customers : 2 6 7 9
    Warehouse 3 supplies customers : 8 10
    Warehouse 5 supplies customers : 1 3 5
    Total C: 383
Model[Model-0], 23 Solutions, Minimize tot_cost = 383, Resolution time 0,069s, 76 Nodes (1 098,9 n/s), 93 Backtracks, 26 Fails, 0 Restarts
```

Things to remember
------------------

-   The *element* constraint can be very helpful, one can have more
    details on it on the [Global Constraint
    Catalog](http://sofdem.github.io/gccat/gccat/Celement.html).
-   The *count* constraint is also part of the must-have constraints
    ([Global Constraint
    Catalog](http://sofdem.github.io/gccat/gccat/Ccount.html)).
-   Besides pre-defined search strategies, one can also constructed a
    specific one. Most of the time, it is worth the time spent on it.
-   The resolution process can be unfold and limited. It allows
    interacting with solution state without building default solution
    object.
-   Cut process is managed by the solver, but it can be modified when
    using the unfold resolution process.