---
title: "Code"
date: 2020-02-05T16:01:13+01:00
type: docs
math: "true"
weight: 63
description: >
  A bunch of code.
---

A model
-------

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
int m = 10;
// A new model instance
Model model = new Model("Golomb ruler");

// VARIABLES
// set of marks that should be put on the ruler
IntVar[] ticks = model.intVarArray("a", m, 0, 999, false);
// set of distances between two distinct marks
IntVar[] diffs = model.intVarArray("d", (m * (m - 1)) / 2, 0, 999, false);

// CONSTRAINTS
// the first mark is set to 0
model.arithm(ticks[0], "=", 0).post();

for (int i = 0, k = 0 ; i < m - 1; i++) {
    // // the mark variables are ordered
    model.arithm(ticks[i + 1], ">", ticks[i]).post();
    for (int j = i + 1; j < m; j++, k++) {
        // declare the distance constraint between two distinct marks
        model.scalar(new IntVar[]{ticks[j], ticks[i]}, new int[]{1, -1}, "=", diffs[k]).post();
        // redundant constraints on bounds of diffs[k]
        model.arithm(diffs[k], ">=", (j - i) * (j - i + 1) / 2).post();
        model.arithm(diffs[k], "<=", ticks[m - 1], "-", ((m - 1 - j + i) * (m - j + i)) / 2).post();
    }
}
// all distances must be distinct
model.allDifferent(diffs, "BC").post();
//symmetry-breaking constraints
model.arithm(diffs[0], "<", diffs[diffs.length - 1]).post();
{{< /tab >}}
{{< /tabpane >}}

A search strategy
-----------------

A simple but efficient strategy to guide the search is to select the
mark variable in lexicographical order and to instantiate each of them
to its lower bound.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
Solver solver = model.getSolver();
solver.setSearch(Search.inputOrderLBSearch(ticks));
{{< /tab >}}
{{< /tabpane >}}

The resolution objective
------------------------

The objective is to minimize the last mark.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// Find a solution that minimizes the last mark
solver.findOptimalSolution(ticks[m - 1], false);
{{< /tab >}}
{{< /tabpane >}}

This method attempts to find the optimal solution.

The entire code
---------------

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
int m = 10;
// A new model instance
Model model = new Model("Golomb ruler");

// VARIABLES
// set of marks that should be put on the ruler
IntVar[] ticks = ticks = model.intVarArray("a", m, 0, 999, false);
// set of distances between two distinct marks
IntVar[] diffs = model.intVarArray("d", (m * (m - 1)) / 2, 0, 999, false);

// CONSTRAINTS
// the first mark is set to 0
model.arithm(ticks[0], "=", 0).post();

for (int i = 0, k = 0 ; i < m - 1; i++) {
    // // the mark variables are ordered
    model.arithm(ticks[i + 1], ">", ticks[i]).post();
    for (int j = i + 1; j < m; j++, k++) {
        // declare the distance constraint between two distinct marks
        model.scalar(new IntVar[]{ticks[j], ticks[i]}, new int[]{1, -1}, "=", diffs[k]).post();
        // redundant constraints on bounds of diffs[k]
        model.arithm(diffs[k], ">=", (j - i) * (j - i + 1) / 2).post();
        model.arithm(diffs[k], "<=", ticks[m - 1], "-", ((m - 1 - j + i) * (m - j + i)) / 2).post();
    }
}
// all distances must be distinct
model.allDifferent(diffs, "BC").post();
//symmetry-breaking constraints
model.arithm(diffs[0], "<", diffs[diffs.length - 1]).post();

Solver solver = model.getSolver();
solver.setSearch(Search.inputOrderLBSearch(ticks));
// show resolution statistics
solver.showShortStatistics();
// Find a solution that minimizes the last mark
solver.findOptimalSolution(ticks[m - 1], false);
{{< /tab >}}
{{< /tabpane >}}

The trace of the execution is roughly:

```
Model[Golomb ruler], 1 Solutions, MINIMIZE a[9] = 80, Resolution time 0,017s, 10 Nodes (593,7 n/s), 0 Backtracks, 0 Fails, 0 Restarts
Model[Golomb ruler], 2 Solutions, MINIMIZE a[9] = 75, Resolution time 0,026s, 18 Nodes (696,8 n/s), 14 Backtracks, 7 Fails, 0 Restarts
Model[Golomb ruler], 3 Solutions, MINIMIZE a[9] = 73, Resolution time 0,032s, 30 Nodes (949,9 n/s), 36 Backtracks, 17 Fails, 0 Restarts
Model[Golomb ruler], 4 Solutions, MINIMIZE a[9] = 72, Resolution time 0,040s, 53 Nodes (1 324,0 n/s), 80 Backtracks, 40 Fails, 0 Restarts
Model[Golomb ruler], 5 Solutions, MINIMIZE a[9] = 70, Resolution time 0,054s, 95 Nodes (1 773,2 n/s), 162 Backtracks, 79 Fails, 0 Restarts
Model[Golomb ruler], 6 Solutions, MINIMIZE a[9] = 68, Resolution time 0,065s, 161 Nodes (2 487,9 n/s), 292 Backtracks, 144 Fails, 0 Restarts
Model[Golomb ruler], 7 Solutions, MINIMIZE a[9] = 66, Resolution time 0,082s, 288 Nodes (3 529,9 n/s), 546 Backtracks, 269 Fails, 0 Restarts
Model[Golomb ruler], 8 Solutions, MINIMIZE a[9] = 62, Resolution time 0,092s, 374 Nodes (4 075,8 n/s), 712 Backtracks, 353 Fails, 0 Restarts
Model[Golomb ruler], 9 Solutions, MINIMIZE a[9] = 60, Resolution time 0,210s, 1354 Nodes (6 435,1 n/s), 2670 Backtracks, 1331 Fails, 0 Restarts
Model[Golomb ruler], 10 Solutions, MINIMIZE a[9] = 55, Resolution time 0,531s, 7997 Nodes (15 050,6 n/s), 15951 Backtracks, 7972 Fails, 0 Restarts
Model[Golomb ruler], 10 Solutions, MINIMIZE a[9] = 55, Resolution time 0,940s, 15981 Nodes (16 999,3 n/s), 31943 Backtracks, 15962 Fails, 0 Restarts
```

Things to remember
------------------

-   adding redundant constraints is about reinforcing the propagation
    and attempting to detect earlier impossible combinations
-   adding symmetry-breaking constraint avoid finding new solutions that
    are symmetric to previously found ones.