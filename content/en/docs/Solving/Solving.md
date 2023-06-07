---
title: "Lauching the resolution process"
date: 2020-01-07T16:06:55+01:00
weight: 31
description: >
  How to look for solutions?
---

## Finding one solution

A call to `solver.solve()` launches a resolution which stops on the first solution found, if any:

```java
if(solver.solve()){
    // do something, e.g. print out variable values
}else if(solver.hasReachedLimit()){
    System.out.println("The solver could not find a solution
                        nor prove that none exists in the given limits");
}else {
    System.out.println("The solver has proved the problem has no solution");
}
```

If `solver.solve()` returns `true`, then a solution has been found and each variable is instantiated to a value.
Otherwise, two cases must be considered:


* A limit has been declared and reached (`solver.hasReachedLimit()` returns true).
There may be a solution, but the solver has not been able to find it in the given limit
or there is no solution but the solver has not been able to prove it (i.e., to close to search tree) in the given limit.
The resolution process stops in no particular place in the search tree.


* No limit has been declared or reached: The problem has no solution and the solver has proved it.

## Enumerating all solutions

You can enumerate all solutions of a problem with a simple while loop as follows:

```java
while(solver.solve()){
    // do something, e.g. print out variable values
}
```

After the enumeration, the solver closes the search tree and variables are no longer instantiated to a value.

## Optimization

In Constraint-Programming, optimization is done by computing improving solutions, until reaching an optimum.
Therefore, it can be seen as solving multiple times the model while adding constraints on the fly to prevent the solver from computing dominated solutions.

### Mono-objective optimization

The optimization process is the following: anytime a solution is found, the value of the objective variable is stored and a *cut* is posted.
The cut is an additional constraint which states that the next solution must be (strictly) better than the current one.
To solve an optimization problem, you must specify which variable to optimize and in which direction:

```java
// to maximize X
model.setObjective(Model.MAXIMIZE, X);
// or model.setObjective(Model.MINIMIZE, X); to minimize X
while(solver.solve()){
    // an improving solution has been found
}
// the last solution found was optimal (if search completed)
```

You can use custom cuts by overriding the default cut behavior.
The *cut computer* function defines how the cut should bound the objective variable.
The input *number* is the best solution value found so far, the output *number* define the new bound.
When maximizing (resp. minimizing) a problem, the cut limits the lower bound (resp. upper bound) of the objective variable.
For instance, one may want to indicate that the value of the objective variable is the next solution should be
greater than or equal to the best value + 10

```java
ObjectiveManager<IntVar, Integer> oman = solver.getObjectiveManager();
oman.setCutComputer(n -> n - 10);
```

### Multi-objective optimization

If you have multiple objective to optimize, you have several options. First, you may aggregate them in a function so that you end up with only one objective variable. Second, you can solve the problem multiple times, each one optimizing one variable and possibly fixing some bounds on the other. Third, you can enumerate solutions (without defining any objective) and add constraints on the fly to prevent search from finding dominated solutions. This is done by the ParetoOptimizer object which does the following:
Anytime a solution is found, a constraint is posted which states that at least one of the objective variables must be strictly better:
Such as $(X_0 < b_0 \lor X_1 < b_1 \lor \ldots \lor X_n < b_n)$ where $X_i$ is the ith objective variable and $b_i$ its value.

Here is a simple example on how to use the `findParetoFront(...)` API to optimize two variables (a and b):

```java
// simple model
Model model = new Model();
IntVar a = model.intVar("a", 0, 2, false);
IntVar b = model.intVar("b", 0, 2, false);
IntVar c = model.intVar("c", 0, 2, false);
model.arithm(a, "+", b, "=", c).post();

Solver solver = model.getSolver();
// create an object that will store the best solutions and remove dominated ones
List<Solution> front = solver.findParetoFront(new IntVar[]{a,b},Model.MAXIMIZE); 
System.out.println("The pareto front has "+paretoFront.size()+" solutions : ");
for(Solution s:paretoFront){
        System.out.println("a = "+s.getIntVal(a)+" and b = "+s.getIntVal(b));
}
```

**NOTE**: All objectives must be optimized on the same direction (either minimization or maximization).

## Propagation

One may want to propagate all constraints without search for a solution.
This can be achieved by calling `solver.propagate()`.
This method runs, in turn, the domain reduction algorithms of the constraints until it reaches a fix point.
It may throw a `ContradictionException` if a contradiction occurs.
In that case, the propagation engine must be flushed calling `solver.getEngine().flush()`
to ensure there is no pending events.

**WARNING**: If there are still pending events in the propagation engine, the propagation may results in unexpected results.
