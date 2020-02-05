---
title: "Constraints over integer variables"
date: 2020-01-07T16:07:15+01:00
weight: 23
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
For the first type of *times* constraint, one might prefer to use a view: `z = model.intOffsetView(x, a);`.
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

### `Task` variables


### `cumulative` constraint



## Table constraints


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

