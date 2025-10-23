---
title: "Explanations"
date: 2024-01-17T16:06:55+01:00
weight: 55
math: "true"
description: >
  Using explanations.
---

From version 5.0.0, Choco-solver supports [Lazy Clause Generation](https://people.eng.unimelb.edu.au/pstuckey/papers/lazy.pdf) (LCG), even though it is not enabled by default.

### Principle

Inspired by the [Chuffed CP solver](https://github.com/chuffed/chuffed), the implemented LCG framework results in the hybrization of a SAT solver and discrete constraint solver to benefit from the well-known SAT [CDCL algorithm](https://en.wikipedia.org/wiki/Conflict-driven_clause_learning).

In practice, literals are associated with variables' domain and inferences made by the solver (domain reductions) are stored.
On failure, the CDCL algorithm is applied in order to extract the logical chain of inferences made by the solver during propagation.
It is turned into a new clause which prevents the same issue to be encountered again in the future and makes possible to “backjump” (non-chronological backtrack) to the appropriate decision in the decision path.

{{%alert title="Info"%}}
When applied to CP, the CDCL algorithm requires that each constraint of a problem explain inference. 
Even though a default explanation function exists for any constraint, dedicated functions offers better performances.
In Choco-solver, some constraints are explained with dedicated functions, others are decomposed into explained ones, and still others are neither explained nor decomposed (for the moment). In the latter case, an exception is raised to inform the user of the situation.
{{%/alert%}}

### Explanations for the system

Explanations for the system, which try to reduce the search space, differ from the ones giving feedback to a user about the unsatisfiability of its model.
Both rely on the capacity of the explanation engine to motivate a failure, during the search form system explanations and once the search is complete for user ones.

**API**:

```java
Model model = new Model(
    "My problem", 
    Settings.init().setLCG(true)
                   .setWarnUser(true));
```

- `Settings.init()`: initializes the settings. 
- `setLCG(true)`: enables the LCG framework.
- `setWarnUser(true)`: enables the warning message to inform the user of the non-explained constraints.


### How to equip a propagator with explanations?

By default, any propagator inherits a basic explanation function.
This function considers that a variable modification is explained by the current state of other variables involved in the propagator.
It must be seen as an implication: when all variables but the modified one are in their current state, then the same modification will be made again.

For example, consider the following problem with three integer variables $X$, $Y$ and $Z$ with domains $\\{1,3\\}$, $\\{2,3\\}$ and $\\{3,4,5,6,7,8\\}$ respectively
 and the constraint $Z = X + Y$.

At the beginning, the upper bound of $\overline{Z}$ is $8$.
When the propagator for the constraint $Z = X + Y$ is launched, it will notice that the maximum of $X + Y$ is $3 + 3 = 6$, which is lower than the current upper bound of $Z$.
The upper bound of $\overline{Z}$ can be updated to $6$ because the maximum of $\overline{X} + \overline{Y}$ is $3 + 3 = 6$.

Without further information, the explanation engine will use the basic explanation function of the propagator to explain why the upper bound of $Z$ has been updated.
The basic explanation function will be blind to the semantics of the constraint and will return the following explanation based on the current state of the variables:
$$ (X \ge 1) \land (X \neq 2) \land (X \le 3) \land (Y \ge 2) \land (Y \le 3)  \Rightarrow (Z \leq 6) $$

However, a more concise yet correct explanation would be:
$$ (X \le 3) \land (Y \le 3)  \Rightarrow (Z \leq 6) $$

To provide such an explanation, the call to `Z.updateUpperBound(6, this)` in the propagator must be replaced by:
```java
Reason r = lcg() ? Reason.r(X.getMaxLit(), Y.getMaxLit()) : Reason.undef();
Z.updateUpperBound(6, this, r);
```

The `Reason.r(...)` method creates a reason object based on the literals passed as arguments.
In this case, the reason is based on the upper bound literals of $X$ and $Y$.
The `lcg()` method returns `true` if the LCG framework is enabled.
The `Reason.undef()` method creates an undefined reason object, which is used when the LCG framework is disabled.

### How to use literals?
Literals are specific boolean variables that represent the state of a variable's domain.

The basic method to get a literal from a variable is `getLit(int value, int type)`, where `type` can be one of the following:
- `IntVar.LR_EQ`: for equality literals, $(X = value)$,
- `IntVar.LR_NE`: for inequality literals, $(X \neq value)$,
- `IntVar.LR_LE`: for less than or equal literals, $(X \leq value)$,
- `IntVar.LR_GE`: for greater than or equal literals, $(X \geq value)$.

But, to make the code more readable, there are dedicated methods for each type of literal:
- `getEQLit(int value)`: represents the literal $(X = value)$.
- `getNELit(int value)`: represents the literal $(X \neq value)$.
- `getLELit(int value)`: represents the literal $(X \leq value)$.
- `getGELit(int value)`: represents the literal $(X \geq value)$.

There are also methods to get the literals corresponding to the current bounds of the variable and to the current instantiation:
- `getMinLit()`: represents the literal $\neg(X \geq min)$.
- `getMaxLit()`: represents the literal $\neg(X \leq max)$.
- `getValLit()`: represents the literal $\neg(X = value)$ only if $X$ is instantiated to `value`, otherwise it throws an exception.


The symbol $\neg$ represents the negation of a literal (which can be also done by calling the static method `MiniSat.neg(literal)`).
Indeed, the explanation engine manages clauses, which are disjunctions of literals.
In the example above, the explanation was written as an implication.
But, any implication can be rewritten into a clause: 
$$A \Rightarrow B \Leftrightarrow \neg A \lor B$$.
If the premise $A$ is a conjunction of literals, like $A_1 \land A_2 \land \ldots \land A_n$, then $\neg A$ is a disjunction of the negation of each literal in $A$: $\neg A_1 \lor \neg A_2 \lor \ldots \lor \neg A_n$.

