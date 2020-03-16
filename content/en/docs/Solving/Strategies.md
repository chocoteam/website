---
title: "Search Strategies"
date: 2020-01-07T16:06:55+01:00
weight: 33
math: "true"
description: >
  How to define search strategies?
---

The search space induced by variable domains is equal to $S=|d_1|\times|d_2|\times\cdots\times|d_n|$ where $d_i$ is the domain of the $i^{th}$ variable.
Most of the time (not to say always), constraint propagation is not sufficient to build a solution, that is, to remove all values but one from variable domains.
Thus, the search space needs to be explored using one or more *search strategies*.
A search strategy defines how to explore the search space by computing *decisions*.
A decision involves a variables, a value and an operator, e.g. $x = 5$, and triggers new constraint propagation.
Decisions are computed and applied until all the variables are instantiated, that is, a solution has been found, or a failure has been detected (backtrack occurs).
Choco 4.10.2 builds a binary search tree: each decision can be refuted (if $x = 5$ leads to no solution, then $x \neq 5$ is applied).
The classical search is based on [Depth First Search](http://en.wikipedia.org/wiki/Depth-first_search).

**NOTE**: There are many ways to explore the search space and this steps should not be overlooked.
Search strategies or heuristics have a strong impact on resolution performances.
Thus, it is strongly recommended to adapt the search space exploration to the problem treated.

### Default search strategy

If no search strategy is specified to the resolver, Choco 4 will rely on the default one (defined by a `defaultSearch` in `Search`).
In many cases, this strategy will not be sufficient to produce satisfying performances and it will be necessary to specify a dedicated strategy, using `solver.setSearch(...)`.
The default search strategy splits variables according to their type and defines specific search strategies for each type that are sequentially applied:


1. integer variables and boolean variables : `intVarSearch(ivars)` (calls `domOverWDegSearch`)


2. set variables: `setVarSearch(svars)`


3. real variables `realVarSearch(rvars)`


4. objective variable, if any: lower bound or upper bound, depending on the optimization direction

Note that lastConflict is also plugged-in.

### Specifying a search strategy

You may specify a search strategy to the resolver by using `solver.setSearch(...)` method as follows:

```java
import static org.chocosolver.solver.search.strategy.Search.*;

// to use the default SetVar search on mySetVars
Solver s = model.getSolver();
s.setSearch(setVarSearch(mySetVars));

// to use activity based search on myIntVars
Solver s = model.getSolver();
s.setSearch(activityBasedSearch(myIntVars));

// to use activity based search on myIntVars
// then the default SetValSelectorFactoryVar search on mySetVars
Solver s = model.getSolver();
s.setSearch(activityBasedSearch(myIntVars), setVarSearch(mySetVars));
```

**NOTE**: Search strategies generally hold on some particular variable kinds only (e.g. integers, sets, etc.).

#### Example

Let us consider we have two integer variables `x` and `y` and we want our strategy to select
the variable of smallest domain and assign it to its lower bound.
There are several ways to achieve this:

```java
// 1) verbose approach using usual imports

import org.chocosolver.solver.search.strategy.Search;
import org.chocosolver.solver.search.strategy.assignments.DecisionOperator;
import org.chocosolver.solver.search.strategy.selectors.values.*;
import org.chocosolver.solver.search.strategy.selectors.variables.*;


    Solver s = model.getSolver();
    s.setSearch(Search.intVarSearch(
                    // selects the variable of smallest domain size
                    new FirstFail(model),
                    // selects the smallest domain value (lower bound)
                    new IntDomainMin(),
                    // apply equality (var = val)
                    DecisionOperator.int_eq,
                    // variables to branch on
                    x, y
    ));
```

```java
// 2) Shorter approach : Use a static import for Search
// and do not specify the operator (equality by default)

import static org.chocosolver.solver.search.strategy.Search.*;

import org.chocosolver.solver.search.strategy.assignments.DecisionOperator;
import org.chocosolver.solver.search.strategy.selectors.values.*;
import org.chocosolver.solver.search.strategy.selectors.variables.*;


    Solver s = model.getSolver();
    s.setSearch(intVarSearch(
                    // selects the variable of smallest domain size
                    new FirstFail(model),
                    // selects the smallest domain value (lower bound)
                    new IntDomainMin(),
                    // variables to branch on
                    x, y
    ));


// 3) Shortest approach using built-in strategies imports

import static org.chocosolver.solver.search.strategy.Search.*;

    Solver s = model.getSolver();
    s.setSearch(minDomLBSearch(x, y));
```

### List of available search strategy

Most available search strategies are listed in `Search`.
This factory enables you to create search strategies using static methods.
Most search strategies rely on :
- variable selectors (see package `org.chocosolver.solver.search.strategy.selectors.values`)
- value selectors (see package `org.chocosolver.solver.search.strategy.selectors.variables`)
- operators (see `DecisionOperator`)

`Search` is not exhaustive, look at the selectors package to see learn more search possibilities.

{{% alert title="Info" color="primary" %}}
Note that some strategies are *dynamic* and might work more efficiently when combined with a [restart policy]({{< ref "Restarts.md" >}}).
{{%/alert%}}

