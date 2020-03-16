---
title: "Explanations"
date: 2020-01-07T16:06:55+01:00
weight: 55
math: "true"
description: >
  Using explanations.
---

Choco-solver natively support explanations. 
However, no explanation engine is plugged-in by default.

### Principle

Nogoods and explanations have long been used in various paradigms for improving search.
An explanation records some sufficient information to justify an inference made by the solver (domain reduction, contradiction, etc.).
It is made of a subset of the original propagators of the problem and a subset of decisions applied during search.
Explanations represent the logical chain of inferences made by the solver during propagation in an efficient and usable manner.
In a way, they provide some kind of a trace of the behavior of the solver as any operation needs to be explained.

The implemented explanation framework is an adapation of the well-konw SAT [CDCL algorithm](https://en.wikipedia.org/wiki/Conflict-driven_clause_learning) to discrete constraint solver.
By exploiting the implication graph (that records events, i.e. variables’ modifications), this algorithm is able to derive a new constraint from the events that led to a contradiction.
Once added to the constraint network, this constraint makes possible to “backjump” (non-chronological backtrack) to the appropriate decision in the decision path.

In CP, learned constraints are denoted “signed-clauses” which is a disjunction of signed-literals, i.e. membership unary constraints : $\bigvee_{i=0}^{n}X_i \in D_i$
where $X_i$ are variables and $D_i$ a set of values.
A signed-clause is satisfied when at least one signed-literal is satisfied.

The current explanation engine is coded to be *Asynchronous, Reverse, Low-intrusive and Lazy*:

Asynchronous:

    Explanations are not computed during the propagation.

Reverse:

    Explanations are computed in a bottom-up way, from the conflict to the first event generated, *keeping* only relevant events to compute the explanation of the conflict.

Low-intrusive:

    Basically, propagators need to implement only one method to furnish a convenient explanation schema.

Lazy:

    Explanations are computed on request.

To do so, all events are stored during the descent to a conflict/solution, and are then evaluated and kept if relevant, to get the explanation.

{{%alert title="Info"%}}
In CP, CDCL algorithm requires that each constraint of a problem can be explained. Even though a default explanation function for any constraint, dedicated functions offers better performances.
In Choco-solver a few set of constraints is equipped with dedicated explanation function (unary constraints, binary and ternary, sum and scalar).
{{%/alert%}}


### Computing explanations

When a contradiction occurs during propagation, it can only be thrown by:


* a propagator which detects unsatisfiability, based on the current domain of its variables;


* or a variable whom domain became empty.

Consequently, in addition to causes, variables can also explain the current state of their domain.
Computing the explanation of a failure consists in going up in the stack of all events generated in the current branch of the search tree and filtering the one relative to the conflict.
The entry point is either the not satisfiable propagator or the empty variable.

Each propagator embeds its own explanation algorithm which relies on the relation it defines over variables.

### Explanations for the system

Explanations for the system, which try to reduce the search space, differ from the ones giving feedback to a user about the unsatisfiability of its model.
Both rely on the capacity of the explanation engine to motivate a failure, during the search form system explanations and once the search is complete for user ones.

#### Learning signed-clauses

When learning is plugged-in, the search is hacked in the following way.
On a failure, the implication graph is analyzed in order to build a signed-clause and to define the decision to jump back to it.
Decisions from the current one to the return decision (excluded) are erased.
Then, the signed-clause is added to the constraint network and automatically dominates decision refutation; then the search goes on.
If the explanation jumps back to the root node, the problem is proven to have no solution and search stops.

**API**:

```java
solver.setLearningSignedClauses();
```


* *solver*: the solver to explain.

See Settings to configure learning algorithm.

