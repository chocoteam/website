---
title: "Code"
date: 2020-06-03T11:18:39+02:00
type: docs
math: "true"
weight: 73
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
Model model = new Model("TSP");

// VARIABLES
// For each city, the next one visited in the route
IntVar[] succ = model.intVarArray("succ", C, 0, C - 1);
// For each city, the distance to the next visited one
IntVar[] dist = model.intVarArray("dist", C, 0, max);
// Total distance of the route
IntVar totDist = model.intVar("Total distance", 0, max * C);

// CONSTRAINTS
for (int i = 0; i < C; i++) {
    // For each city, the distance to the next one should be maintained
    // this is achieved, here, with a TABLE constraint
    // Such table is inputed with a Tuples object
    // that stores all possible combinations
    Tuples tuples = new Tuples(true);
    for (int j = 0; j < C; j++) {
        // For a given city i
        // a couple is made of a city j and the distance i and j 
        if(j!=i)tuples.add(j, D[i][j]);
    }
    // The Table constraint ensures that one combination holds 
    // in a solution
    model.table(succ[i], dist[i], tuples).post();
}
// The route forms an Hamiltonian path.
// That is, a single circuit of size C, visiting all cities
model.subCircuit(succ, 0, model.intVar(C)).post();
// Defining the total distance
model.sum(dist, "=", totDist).post();
{{< /tab >}}
{{< /tabpane >}}

The `table` constraints maintain the distance metric when the sub-set of cities to be visited from a given one is refined.
In order to limit tuples, those expressing a loop over a city (when `i = j`) are not added to `tuples`.

In this example, we declare a `table` constraint over two variables, but another API exists to input an array of variables. Obviously, the tuples declaration should be adapted.
The underlying algorithm used to filter inconsistent values in such constraint can also be defined manually but the default one should work well in any case. More details are available in the Javadoc.

There exists some specific cases wherein one wants to define a *universal value*, meaning that some variables can take any values from their domain.
This is achieved calling `tuples.setUniversalValue(star)`, where `star` is the universal value (for example, -1).

Alternatively in the TSP, table constraints can be replaced by element constraints:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
for (int i = 0; i < C; i++) {
    model.element(dist[i], D[i], succ[i]).post();
}   
{{< /tab >}}
{{< /tabpane >}}

The `subCircuit` constraint ensures that `next` variables form a circuit of size `C`.

A search strategy
-----------------

Since the problem is hard to solve, defining an adapted strategy is a
key to success. 
Here, the `dist` variables hold the problem, we want the sum of them to be minimized.
So, we will assigned each of them to their lower bound.
To choose the distance variable to be fixed, we will consider the difference between the two smallest values in each variables domain.
And select the one that maximizes this difference.
Doing so, we try to favour variables whose non-selection could increase the objective function too much. 

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
Solver solver = model.getSolver();
solver.setSearch(
    Search.intVarSearch(
        new MaxRegret(), 
        new IntDomainMin(), 
        dist)
);
{{< /tab >}}
{{< /tabpane >}}

The resolution objective
------------------------

The objective is to minimize 'totDist'.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// Find a solution that minimizes 'totDist'
Solution best = solver.findOptimalSolution(totDist, false);
{{< /tab >}}
{{< /tabpane >}}

This method attempts to find the optimal solution.

Pretty solution output
----------------------

We can define a function that prints any solutions in a pretty way.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
int current = 0;
System.out.printf("C_%d ", current);
for (int j = 0; j < C; j++) {
    System.out.printf("-> C_%d ", succ[current].getValue());
    current = succ[current].getValue();
}
System.out.printf("\nTotal distance = %d\n", totDist.getValue());
{{< /tab >}}
{{< /tabpane >}}

Calling this method is made easy with the unfold resolution instruction.

The entire code
---------------

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// GR17 is a set of 17 cities, from TSPLIB. The minimal tour has length 2085.
// number of cities
int C = 17;
// matrix of distances
int[][] D = new int[][]{
            {0, 633, 257, 91, 412, 150, 80, 134, 259, 505, 353, 324, 70, 211, 268, 246, 121},
            {633, 0, 390, 661, 227, 488, 572, 530, 555, 289, 282, 638, 567, 466, 420, 745, 518},
            {257, 390, 0, 228, 169, 112, 196, 154, 372, 262, 110, 437, 191, 74, 53, 472, 142},
            {91, 661, 228, 0, 383, 120, 77, 105, 175, 476, 324, 240, 27, 182, 239, 237, 84},
            {412, 227, 169, 383, 0, 267, 351, 309, 338, 196, 61, 421, 346, 243, 199, 528, 297},
            {150, 488, 112, 120, 267, 0, 63, 34, 264, 360, 208, 329, 83, 105, 123, 364, 35},
            {80, 572, 196, 77, 351, 63, 0, 29, 232, 444, 292, 297, 47, 150, 207, 332, 29},
            {134, 530, 154, 105, 309, 34, 29, 0, 249, 402, 250, 314, 68, 108, 165, 349, 36},
            {259, 555, 372, 175, 338, 264, 232, 249, 0, 495, 352, 95, 189, 326, 383, 202, 236},
            {505, 289, 262, 476, 196, 360, 444, 402, 495, 0, 154, 578, 439, 336, 240, 685, 390},
            {353, 282, 110, 324, 61, 208, 292, 250, 352, 154, 0, 435, 287, 184, 140, 542, 238},
            {324, 638, 437, 240, 421, 329, 297, 314, 95, 578, 435, 0, 254, 391, 448, 157, 301},
            {70, 567, 191, 27, 346, 83, 47, 68, 189, 439, 287, 254, 0, 145, 202, 289, 55},
            {211, 466, 74, 182, 243, 105, 150, 108, 326, 336, 184, 391, 145, 0, 57, 426, 96},
            {268, 420, 53, 239, 199, 123, 207, 165, 383, 240, 140, 448, 202, 57, 0, 483, 153},
            {246, 745, 472, 237, 528, 364, 332, 349, 202, 685, 542, 157, 289, 426, 483, 0, 336},
            {121, 518, 142, 84, 297, 35, 29, 36, 236, 390, 238, 301, 55, 96, 153, 336, 0}
    };

// A new model instance
Model model = new Model("TSP");

// VARIABLES
// For each city, the next one visited in the route
IntVar[] succ = model.intVarArray("succ", C, 0, C - 1);
// For each city, the distance to the succ visited one
IntVar[] dist = model.intVarArray("dist", C, 0, max);
// Total distance of the route
IntVar totDist = model.intVar("Total distance", 0, max * C);

// CONSTRAINTS
for (int i = 0; i < C; i++) {
    // For each city, the distance to the next one should be maintained
    // this is achieved, here, with a TABLE constraint
    // Such table is inputed with a Tuples object
    // that stores all possible combinations
    Tuples tuples = new Tuples(true);
    for (int j = 0; j < C; j++) {
        // For a given city i
        // a couple is made of a city j and the distance i and j 
        if(j!=i)tuples.add(j, D[i][j]);
    }
    // The Table constraint ensures that one combination holds 
    // in a solution
    model.table(succ[i], dist[i], tuples).post();
}
// The route forms a single circuit of size C, visiting all cities
model.subCircuit(succ, 0, model.intVar(C)).post();
// Defining the total distance
model.sum(dist, "=", totDist).post();

model.setObjective(Model.MINIMIZE, totDist);
Solver solver = model.getSolver();
solver.setSearch(
    Search.intVarSearch(
        new MaxRegret(), 
        new IntDomainMin(), 
        dist)
);
solver.showShortStatistics();
while(solver.solve()){
    int current = 0;
    System.out.printf("C_%d ", current);
    for (int j = 0; j < C; j++) {
        System.out.printf("-> C_%d ", succ[current].getValue());
        current = succ[current].getValue();
    }
    System.out.printf("\nTotal distance = %d\n", totDist.getValue());
}
{{< /tab >}}
{{< /tabpane >}}

The best solution found is:

```
Model[TSP], 11 Solutions, MINIMIZE Total distance = 2085, Resolution time 1,426s, Time to best solution 1,426s, 6038 Nodes (4 233,4 n/s), 12022 Backtracks, 0 Backjumps, 6007 Fails, 0 Restarts
C_0 -> C_3 -> C_12 -> C_6 -> C_7 -> C_5 -> C_16 -> C_13 -> C_14 -> C_2 -> C_10 -> C_9 -> C_1 -> C_4 -> C_8 -> C_11 -> C_15 -> C_0 
Total distance = 2085
```

Things to remember
------------------

-   The *table* constraint can be very expressive. It is not restricted to couple of variables but may be extended to an array of variables.
- The *table* constraint can easily encode non linear expressions.
- The *subCircuit* constraint is used to ensure that `next` variables form an Hamiltonian path. Knowing existence of such global constraints is the key to a compact model which benefit from CP's strength. 
