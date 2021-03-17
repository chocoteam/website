---
title: "Constraints over integer variables"
date: 2020-01-07T16:07:15+01:00
weight: 23
math: "true" 
description: >
  Overview of constraints based on boolean and integer variables.
---

## Arithmetical constraints
These constraints are used to express arithmetical relationships between two or three variables, or between one or two variables and an integer constant.
For instance, a threshold constraint can be posted as following:

```java
model.arithm(x, ">=", 3).post();
```

Accepted mathematical operators for these constraints are `>=`, `>`, `<=`, `<`, `=` and `!=`. When more than one variable is constrained, one can use the following methods:

```java
String op = ">="; // among ">=", ">", "<=", "<", "=" and "!="
model.arithm(x, op, y).post();
// with x an IntVar and y either an IntVar or an int

String op2 = "+"; // either "+" or "-"
model.arithm(x, op2, y, op, z).post();
// with x and y IntVar, and z is either an int or an IntVar
```

## Other mathematical constraints
Choco-solver also supports other mathematical constraints than arithmetical ones, such as *times*, *div*, *modulo*... In this section, we will consider `x`, `y` and `z` to be `IntVar` and `a` and `b` to be `int`.

### Binary and ternary constraints

*times* constraints are posted as following:

```java
model.times(x, a, z).post(); // x * a = z
model.times(x, y, a).post(); // x * y = a
model.times(x, y, z).post(); // x * y = z
```

{{% alert title="Info" color="primary" %}}
For the first type of *times* constraint, one might prefer to use a view: `z = model.intScaleView(x, a);`.
{{% /alert %}}

A *div* constraint corresponds to a euclidean division. It is posted as following:

```java
model.div(x, y, z).post(); // x / y = z
// it assures that y != 0, and z is rounding towards 0.
```

*modulo* constraints are of three types:

```java
model.mod(x, a, b).post(); // x % a = b
model.mod(x, a, z).post(); // x % a = z
model.mod(x, y, z).post(); // x % y = z
```

An *absolute* constraint is posted like this:

```java
model.absolute(x, y).post(); // x = |y|
```


### Global constraints

Let `min` and `max` be `IntVar` and let `vars` be an array of `IntVar`. One can post the following mathematical constraints to assure that `min` is the
minimum of the variables in `vars` and `max` the maximum of them:

```java
model.min(min, vars).post();
model.max(max, vars).post();
```

Similarly, one can want to sum some variables. For such an operation, one should use the `sum` constraint:

```java
String op = ">="; // among ">=", ">", "<=", "<", "=" and "!="
model.sum(vars, op, x).post(); // here, it gives sum(vars) >= x
```

And, finally, for weighted sums, one should use the `scalar` constraint:

```java
String op = ">="; // among ">=", ">", "<=", "<", "=" and "!="
model.sum(vars, coefs, op, x).post(); // coefs being an array of int
// here, it gives sum(vars[i]*coefs[i]) >= x
```

## Cardinality constraints

allDifferent, allEqual, nvalues, element

## Scheduling constraints

Scheduling problems can be modelled using Task variables and the cumulative constraint.  
A task represents the entity that should be scheduled, where it is unknown when the task starts and optionally how long it lasts.  
The cumulative constraint limits the number of concurrent tasks.  

### `Task` variables

A task needs a start `IntVar` and an int duration.

```java
Task task = new Task(start, duration);
```

Optionally and end `IntVar` can be supplied. Task will ensure that start + duration = end, end being an offset view of start + duration.

```java
Task task = new Task(start, duration, end);
```

A task can have an unknown duration. In this case create the task with 3 `IntVar`: start, varDuration and end. Task will ensure that start + duration = end, end being an offset view of start + duration.

```java
Task task = new Task(start, varDuration, end);
```

Finally, a task can be created based on the `Model` and 5 ints: earliestStart, latestStart, duration, earliestEnd, latestEnd.  
A start `IntVar` will be created with a domain of $[earliestStart, latestStart]$.  
An end `IntVar` will be created with a domain of $[earliestEnd, latestEnd]$.  
Task will ensure that start + duration = end, end being an offset view of start + duration.

```java
Task task = new Task(model, earliestStart, latestStart, duration, earliestEnd, latestEnd);
```

### `Cumulative` constraint

The cumulative constraint ensures that at any point in time, the cumulated heights of a set of overlapping `Tasks` does not exceed a given capacity.  
Let tasks be an array of `Task`, heights an array of `IntVar` and capacity an `IntVar`.  
Make sure $|tasks| = |heights|$  

```java
model.cumulative(tasks, heights, capacity).post();
```

If only one task can happen concurrently, set the heights fixed equal to the capacity, either by setting fixed values or posting constraints between the variables.  
Other combinations of concurrently (or not) planned tasks can be modelled by setting different values for the heights and the capacity, or by defining different constraints between these variables.   

Simple example: 4 tasks with a set height that cannot happen at the same time by setting fixed a capacity:

```java
Task[] tasks = new Task[4];
Arrays.fill(tasks, new Task(start, duration));
IntVar[] heights = new IntVar[4];
Arrays.fill(heights, model.intVar(1));
IntVar capacity = model.intVar(1);

model.cumulative(tasks, heights, capacity).post();
```
Solving this will result in all 4 tasks happening consecutively so:
$start[i] + duration[i] \leq start[j]$

The cumulative constraint does not enforce a specific order of tasks. Define other constraints between the variables for this if needed.


## Table constraints

Table constraints are really useful and make it possible to encode any relationships. 
Table constraints expect an array of variables as input and a `Tuples` object. 
The latter stores a list of allowed (resp. forbidden) tuples, each of them expresses an allowed (resp. forbidden) combination  for the variables.

Consider an ordered set of variables $X=\\{X_i \mid i\in I\\}$ and an allowed combination $t\in T$, which defined an ordered set of integer values. The ith value in $t$ is denoted $t_i$.

A Table constraint ensures that :
$$Table(X,T)\equiv \bigvee_{t \in T}\bigwedge_{i \in I}(X_i = t_i)$$

*When dealing with forbidden combinations, the `$=$` operator below is replaced by a `$\neq$` operator.*

Table constraints are also known as constraints *in extension* since all possible (or impossible) combinations are needed as input. 

Table constraints usually provide domain consistency filtering algorithm, with diverse spatial and temporal complexities which depend on the number of variables involved and the number of tuples.

### Allowed combinations 

Let's take the example of four variables $X_i = [\\![0,3]\\!], i \in [1,4]$, that **must** all be equal. This relationship can be expressed with a Table constraint as follow:

```java
Tuples allEqual = new Tuples(true); // true stands for 'allowed' combinations
allEqual.add({0,0,0,0});
allEqual.add({1,1,1,1});
allEqual.add({2,2,2,2});
allEqual.add({3,3,3,3});
model.table(X, allEqual, "CT+").post();
```

Only defined combinations are solutions.

The parameter `"CT+"` is optional and defines the filtering algorithm to use. `"CT+"` is a really good default choice.

### Forbidden combinations 

Let's take the previous example but in that case, all variables **must not** be all be equal. This relationship can be expressed with a Table constraint as follow, with a little difference in the `Tuples` declaration:

```java
Tuples allEqual = new Tuples(false); // false stands for 'forbidden' combinations
allEqual.add({0,0,0,0});
allEqual.add({1,1,1,1});
allEqual.add({2,2,2,2});
allEqual.add({3,3,3,3});
model.table(X, allEqual, "CT+").post();
```

All undefined combinations are solution, for example `{0,0,0,1}` or `{0,1,2,3}`.


### Universal value
Under certain conditions, the number of tuples can be reduced by introducing a *universal value*. 
Consider $X_i = [\\![0,99]\\!], i \in [1,3]$, and the following relationship: 

1. *if $X_1 = 0$ then $X_2 = 0$ and $X_3$ can take any value;*
2. *else if $X_1 = 3$ then $X_2 = 2$ and $X_3 = 1$.*

The allowed tuples are:
```
{0, 0, 0}
{0, 0, 1}
...
{0, 0, 98}
{0, 0, 99}
{3, 2, 1}
```
We can see that this relation requires 100 combinations to be expressed and 99 of them are needed to capture *$X_3$ can take any value*.
It's a use case of universal value.
```java
int STAR = -1;
Tuples rel = new Tuples(true); 
rel.setUniversalValue(STAR);
rel.add({0,0,STAR});
rel.add({3,2,1});
model.table(X, rel).post();
```
`STAR` represents the universal value, here $-1$.
The value must be taken outside variables domain.

## SAT constraints

A SAT solver is embedded in Choco-solver. It is not  designed to be accessed directly.
The SAT solver is internally managed as a constraint (and a propagator), that’s why it is referred to as SAT constraint in the following.

Clauses can be added with the `Model` thanks to methods whose name begins with `addClause*`.
There exists two type of clauses declaration: pre-defined ones (such as `addClausesBoolLt` or `addClausesAtMostNMinusOne`) or more free ones by specifying a `LogOp` that represents a clause expression:

```java
model.addClauses(LogOp.and(LogOp.nand(LogOp.nor(a, b), LogOp.or(c, d)), e));
// with static import of LogOp
model.addClauses(and(nand(nor(a, b), or(c, d)), e));
```

## Automaton-based Constraints

`regular`, `costRegular` and `multiCostRegular` rely on an automaton, declared either implicitly or explicitly.
There are two kinds of `IAutomaton` :
- `FiniteAutomaton`, needed for `regular`,
- `CostAutomaton`, required for `costRegular` and `multiCostRegular`.

`FiniteAutomaton` embeds an `Automaton` object provided by the `dk.brics.automaton` library.
Such an automaton accepts fixed-size words made of multiple `char`, but the regular constraints rely on `IntVar`,
so a mapping between `char` (needed by the underlying library) and `int` (declared in `IntVar`) has been made.
The mapping enables declaring regular expressions where a symbol is not only a digit between 0 and 9 but any **positive** number.
Then to distinct, in the word 101, the symbols 0, 1, 10 and 101, two additional `char` are allowed in a regexp: < and > which delimits numbers.

In summary, a valid regexp for the automaton-based constraints is a combination of **digits** and Java Regexp special characters.

`CostAutomaton` is an extension of `FiniteAutomaton` where costs can be declared for each transition.

