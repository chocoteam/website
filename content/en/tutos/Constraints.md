---
title: "Designing a constraint"
date: 2020-02-05
type: docs
math: "true"
weight: 80
description: >
  Steps to follow to create your own constraint.
---


In this part, we are going to see how to create a constraint to be used
by Choco-solver. The work will be based on the sum constraint, more
specifically: $\sum_{i = 1}^{n} x_i \leq b$ where
$x_i = [\underline{x_i},\overline{x_i}]$ are distinct variables and
where $b$ is a constant.

[Bounds Consistency Techniques for Long Linear
Constraint](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.8.8962)
by W.Harvey and J.Schimpf described in details how such a constraint is
implemented and will serve as a basis of this tutorials.

{{% alert title="Important" color="secondary"%}}
The implementation presented here can be improved in many ways but 
that is not the goal this tutorial to discuss improvements but to show
 what is important to know when creating a constraint.
{{%/alert%}}


The first filtering algorithm they depicted in the article is roughly
the following:

-   First, compute $F = b - \sum_{i = 1}^{n} \underline{x_i}$
-   then, update variables domain,
    $\forall i \in [1,n], x_i \leq F + \underline{x_i}$

Note that if $F < 0$ the constraint is unsatisfiable.

A first implementation
----------------------

When one needs to declare its own constraint, actually, he needs to
create a propagator. Indeed, in Choco-solver, a constraint is a container which
is composed of propagators, and each propagator can
eliminate values from domain variables. So the first step will be to
create a java class that extends `Propagator<IntVar>`. The generic
parameter `<IntVar>` indicates that the propagator only manages integer
variable. Set it to BoolVar, SetVar or Variable are possible
alternatives.

Once the class is created, a constructor is needed plus two methods :

-   `public void propagate(int evtmask) throws ContradictionException`
    where the filtering algorithm will be applied,
-   `public ESat isEntailed()` where the entailment/satisfaction of the
    propagator is checked.

We now describe how these two methods can be implemented, plus an
optional yet important method and the constructor parametrization.

### Entailment

For debugging purpose or to enable constraint reification, a method
named `isEntailed()` has to be implemented. The former is mainly used when
implementing the constraint to make sure that found solutions respect
the constraint specifications. The latter is called to valuate the
boolean variable attached to a propagator when it is reified. The method
returns `ESat.TRUE`, `ESat.FALSE` or `ESat.UNDEFINED` when respectively with
respect to the current domain of the variables, the propagator can
always be satisfied however they are instantiated, the propagator can
never be satisfied and nothing can be deduced.

For example, consider the constraint $c = (x_1 + x_2 \leq 10)$ and the
three following states:

-   $x_1 = [1,2], x_2 = [1,2]$ : the method returns `ESat.TRUE` since all
    combinations satisfy c,
-   $x_1 = [22,23], x_2 = [10,12]$ : the method returns `ESat.FALSE` since
    no combination satisfies c and
-   $x_1 = [1,10], x_2 = [1,10]$ : the method returns `ESat.UNDEFINED`
    since some combinations satisfy $c$, other don't.

{{%alert title="Info" color="primary"%}}>
When an instance of a propagator is created, an array of its variables
is automatically created and named vars. The order of elements of
'vars' shouldn't be modified: each variable knows its position in each
of its propagators, modifying a position is only made by the solver
itself.
{{%/alert%}}

The entailment method can be implemented as is:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
Override
public ESat isEntailed() {
   int sumUB = 0, sumLB = 0;
   for (int i = 0; i < vars.length; i++) {
       sumLB += vars[i].getLB();
       sumUB += vars[i].getUB();
   }
   if (sumUB <= b) {
       return ESat.TRUE;
   }
   if (sumLB > b) {
       return ESat.FALSE;
   }
   return ESat.UNDEFINED;
}
{{< /tab >}} 
{{< /tabpane>}}

### Filtering algorithm

A propagator's first objective is to remove, from its variables domain,
values that cannot belong to any solutions. This is the role of the
propagate(int m) method. This method bases its deductions on the current
domain of the variables and can update their domain on the fly. The
expected state of this method exit is called a 'fix-point'.

{{% alert title="Info" color="primary" %}}
A local fix-point (wrt to a propagator) is reached when no more deductions can be done by a propagator on its variables.
A global fix point (*wrt* to a model) is reached when no more deductions can be done by any propagator on all variables.
{{%/alert%}}

Indeed, a propagator 'p' is not notified of its modifications but only
those triggered by other propagators which modified at least one
variable of 'p'. Each time one, at least, of its variable is modified,
the satisfaction of a propagator need to check along with some
filtering, if any, based on earlier modification.

Applying filtering rules can lead to a contradiction. In that case, the
solver resumes after the filtering algorithm is stopped and manages to
undo domain modification. Since restoring previous states is managed by
the solver, it can safely be ignored when creating a propagator.

In the case of the sum constraint, $F$ is computed first, then fast check
of $F$ is made to check obvious unsatisfaction and eventually a loop is
operated over the variables to make sure that each upper bound is
correct wrt to $F$. A simple loop is enough since $F$ is computed reading
$\overline{x_i}$ and writing $\underline{x_i}$.

Note that the method can throw an exception. An exception denotes that a
failure is detected and the execution has to be stopped. In our case, if
$F < 0$ an exception should be thrown. In other cases, the methods that
modify the variables domain can thrown such an exception too, when for
example, the domain becomes empty.

The filtering method can be implemented as is:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
@Override
public void propagate(int evtmask) throws ContradictionException {
    int sumLB = 0;
    for (int i  = 0; i < vars.length; i++) {
        sumLB += vars[i].getLB();
    }
    int F = b - sumLB;
    if (F < 0) {
        fails();
    }
    for (int i  = 0; i < vars.length; i++) {
        int lb = vars[i].getLB();
        int ub = vars[i].getUB();
        if (ub - lb > F) {
            vars[i].updateUpperBound(F + lb, this);
        }
    }
}
{{< /tab >}} 
{{< /tabpane>}}

The parameter of the method is ignored for now. On line 9, since the
condition of unsatisfaction is met, a `ContradictionException` is thrown
by calling `fails()`. On line 16, the $i^{th}$ variable upper bound is
updated. If the new value is greater or equal to than the current upper
bound of the variable, nothing happens. If not, the variable is
modified. If the new upper bound is lesser than the current lower bound,
a `ContradictionException` is thrown automatically. Otherwise, the old
upper bound is stored (for future restoration), the new upper bound is
set and the propagators' list of the variable is iterated to inform each
of them (except the one that triggers the event) that the variable
domain has changed which can question their local fix-point.


{{% alert title="Important" color="secondary" %}}
An `IntVar` can be modified in many ways: instantiation, upper bound
 modification, lower bound modification or value removal(s). These
 modifications can be achieved calling :
 `instantiateTo(...)`,`updateUpperBound(...)`, `updateLowerBound(...)`, `removeValue(...)`,
 `removeValues(...)`, ...
{{%/alert%}}

{{%alert title="Some events can be promoted" color="primary"%}}

For instance, when the new upper bound of a variable becomes equal
to its current lower bound, the upper bound modification is
promoted to an instantiation. The same goes with the new lower
bound being equal to the current upper bound. Or when a value
removal affects one bound, it is promoted to a bound modification
(which in turn can be promoted to instantiation).

When the term 'value removal' is used it qualifies a hole in the
middle of a variable domain, otherwise, due to promotion, the most
accurate term is used.
{{%/alert%}}

### Propagation conditions (optional)

When a variables is modified, the type of *event* the modification
corresponds is declared. For example when the upper bound of a variables
is decreased, the event indicates `DEC_UPP`.

Not all types of event is relevant for all propagators and each of them
can give its filtering conditions. By default, a propagator is informed
of all type of modifications.

In our case, nothing can be done on value removal nor on upper bound
modification. Thus, the following method can be override (note that is
optional but leads to better performances):

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
@Override
public int getPropagationConditions(int vIdx) {
    return IntEventType.combine(IntEventType.INSTANTIATE, IntEventType.INCLOW);
}
{{< /tab >}} 
{{< /tabpane>}}

Note that this method is called statically on each of its variables
(denoted by `vIdx`) when posting the constraint to the model. Some
propagators can thus declare distinct propagation conditions for each
variable.

### Constructor

Finally, any propagator should extends Propagator which is an abstract
class and a call to super is expected as first instruction of the
constructor.

`Propagator` abstract class provides three constructors but we will only
depict one, the most important:
`Propagator(V[] vars, PropagatorPriority priority, boolean reactToFineEvt)`.

The first argument is the list of variables, here an array of `IntVar`.
The list of all variables the propagator can react on should be passed
here. Consider that, with few exceptions, all variables of the
propagator are expected.

The second parameter considers the filtering algorithm arity or
complexity. There are seven ordered levels of priority, the three first
ones (arity levels) are `UNARY`, `BINARY` and `TERNARY`. The three following
ones (complexity levels) are `LINEAR`, `QUADRATIC`, `CUBIC`. Actually a
`TERNARY` priority propagator is expected to run faster than a `QUADRATIC`
priority one. So, considering the complexity instead of the arity may be
more relevant when the filtering algorithm is very costly even if the
propagator relies on only three variables.

The third parameter indicates if the propagator is able to react on fine
events. This parameter will be presented in more details later on.

In our case, the input parameters are the array of IntVar 'x', the
priority is based on the complexity which is linear in the number of
variables and false. In addition, the constant 'b' needs to be stored
too.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
/**
 * Constructor of the specific sum propagator : x1 + x2 + ... + xn <= b
 * @param x array of integer variables
 * @param b a constant
 */
public MyPropagator(IntVar[] x, int b) {
    super(x, PropagatorPriority.LINEAR, false);
    this.b = b;
}
{{< /tab >}}
{{< /tabpane >}}

### MyPropagator

A basic yet sound propagator which ensures that the sum of all variables
is less than or equal to a constant is declared below.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
public class MyPropagator extends Propagator<IntVar> {

 /**
  * The constant the sum cannot be greater than
  */
 final int b;

 /**
  * Constructor of the specific sum propagator : x1 + x2 + ... + xn <= b
  * @param x array of integer variables
  * @param b a constant
  */
 public MyPropagator(IntVar[] x, int b) {
     super(x, PropagatorPriority.LINEAR, false);
     this.b = b;
 }

 @Override
 public int getPropagationConditions(int vIdx) {
     return IntEventType.combine(IntEventType.INSTANTIATE, IntEventType.INCLOW);
 }

 @Override
 public void propagate(int evtmask) throws ContradictionException {
    int sumLB = 0;
    for (IntVar var : vars) {
        sumLB += var.getLB();
    }
    int F = b - sumLB;
    if (F < 0) {
        fails();
    }
    for (IntVar var : vars) {
        int lb = var.getLB();
        int ub = var.getUB();
        if (ub - lb > F) {
            var.updateUpperBound(F + lb, this);
        }
    }
 }

 @Override
 public ESat isEntailed() {
    int sumUB = 0, sumLB = 0;
    for (IntVar var : vars) {
        sumLB += var.getLB();
        sumUB += var.getUB();
    }
    if (sumUB <= b) {
        return ESat.TRUE;
    }
    if (sumLB > b) {
        return ESat.FALSE;
    }
    return ESat.UNDEFINED;
 }
}
{{< /tab >}} 
{{< /tabpane>}}

This first implementation outlines key concepts a propagator required.
The entailment method should not ignored since it is helpful (even
essential) to check the correctness of the implementation. The optional
one which describes the propagation conditions can sometimes reduce the
number of times a propagator is called without deducing new information
(domain modifications or failure).

A more complex version
----------------------

Based on [Bounds Consistency Techniques for Long Linear
Constraint](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.8.8962),
the first version can be improved in some ways.

We will consider first to desactivate the propagator when some
conditions are satisfied, then we will show how backtrackable structures
can be used and finally how a propagator can react to fine events.

### Reduce to silence

An interesting feature available by default is the capacity to set
passive a propagator that is entailed (i.e., is always true). Indeed, if
all variables domain are in such state that any combinations satisfy the
constraint, the propagator can be ignored in the propagation loop since
it will not filter values nor fail.

In our case, this happens when the sum of the upper bounds is equal to
or less than 'b'. If so, the propagator can safely be set to a passivate
state in which it will not be informed of any new modifications
occurring **in the current search sub-tree** (i.e., the propagator will
be reactivated automatically on backtrack).

The filtering method can be modified like that:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
@Override
public void propagate(int evtmask) throws ContradictionException {
    int sumLB = 0;
    for (int i  = 0; i < vars.length; i++) {
        sumLB += vars[i].getLB();
    }
    int F = b - sumLB;
    if (F < 0) {
        fails();
    }
    int sumUB = 0;
    for (int i  = 0; i < vars.length; i++) {
        int lb = vars[i].getLB();
        int ub = vars[i].getUB();
        if (ub - lb > F) {
            vars[i].updateUpperBound(F + lb, this);
        }
        sumUB += vars[i].getUB();
    }
    int E = sumUB - b;
    if (E <= 0) {
        this.setPassive();
    }
}
{{< /tab >}} 
{{< /tabpane>}}

Line 18, a counter is updated with the sharpest upper bound of each
variables. Line 21-23, if the condition is satisfied, the propagator is
entailed and set to a passive state.

{{%alert title="Info" color="primary"%}}
We could also consider updating the propagation conditions to
integrate upper bound modifications. Doing so, when one variable upper
bound is modified, the entailment condition could be checked earlier.
{{%/alert%}}

### Incrementally updating $F$

One may have noted that F is always computed as first step of
`propagate(int evtmask)` method. On cases where few bounds are updated,
there could be a benefit to incrementally compute $F$.

To compute $F$ in an incremental way, three steps are needed: 
1. creating a *backtrackable* `int` to record $F$ but also variables' lower bound 
2. initializing it on `propagate(int evtmask)` first call 
3. anytime a variable is being modified, maintaining $F$

First, a `IStateInt` object and an `IStateInt` array are declared as class
variables. In the propagator's constructor, through the `Model`, the
objects are initialized:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
/**
 * The constant the sum cannot be greater than
 */
final int b;

/**
 * object to store F in an incremental way.
 * Corresponds to a backtrackable int.
 */
final IStateInt F;

/**
 * array to store variables' previous lower bound.
 * each cell is a backtrackable int.
 */
final IStateInt[] prev_lbs;

/**
 * Constructor of the specific sum propagator : x1 + x2 + ... + xn <= b
 * @param x array of integer variables
 * @param b a constant
 */
public MyPropagator(IntVar[] x, int b) {
    super(x, PropagatorPriority.LINEAR, false);
    this.b = b;
    this.F = this.model.getEnvironment().makeInt(0);
    this.prev_lbs = new IStateInt[x.length];
    for(int i = 0 ; i < x.length; i++){
        prev_lbs[i] = this.model.getEnvironment().makeInt(0);
    }
}
{{< /tab >}} 
{{< /tabpane>}}

$F$ is created with value 0; its correct value will be set on the first call
to `propagate(int evtmask)` method. Same goes with prev\_ubs. Any
backtrackable primitive or operation is created thanks to the
*environment* attached to the model. This ensures the integrity of the
structure when backtracks occur.

The role of prev\_ubs is to store the value of each variable lower
bound. Then, anytime a variable lower bound is modified, its value can
be retrieved and substracted from the current value to update $F$.

Second, $F$ is initialized in the first call to `propagate(int evtmask)`
method. This is where the value of evtmask is helpful. It can take 2
distinct values: one is dedicated to a full propagation, the other to a
custom propagation. A full propagation is run on the initial propagation
call, when each propagator is awaken by the solver. Then, if the
propagator was declared not reacting to fine events (last parameter of
the super constructor), full propagation is always run. On the other
hand, if the propagator reacts to fine events, which will be the case
for now, the initial propagation is kept full but then the main entry
point of the filtering algorithm will be
`propagate(int vIdx, int evtmask)` method (with **two** arguments). This
method reacts to fine events, that means all variables modifications
will be given as input thanks to the variable's index in vars (`vIdx`) and
the event mask which is can be a combination of event types, like in
propagation conditions.

Most of the time, this method is decomposed into a fast but naive
filtering algorithm and a delayed call to a custom, presumably not fast,
filtering algorithm. But it can be made of no filtering at all (that's
the case here) or no delayed call to custom filtering algorithm.

In our case, we will only incrementally maintain $F$ and then delegate the
filtering to the custom propagation.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
private void prepare(){
    int sumLB = 0;
    for(int i = 0 ; i < vars.length; i++){
        sumLB += vars[i].getLB();
        // set the current lower bound in 'prev_lbs'
        prev_lbs[i].set(vars[i].getLB());
    }
    // set the value of F
    F.set(b - sumLB);
}

@Override
public void propagate(int vIdx, int mask) throws ContradictionException {
    // 1. get the current lower bound of the modified variable
    int lb = vars[vIdx].getLB();
    // 2. update F with the difference between old and new lower bound
    F.add(lb - prev_lbs[vIdx].get());
    // 3. set the new lower bound
    prev_lbs[vIdx].set(lb);
    // 4. delegate the filtering later on
    forcePropagate(PropagatorEventType.CUSTOM_PROPAGATION);
}

@Override
public void propagate(int evtmask) throws ContradictionException {
    if(PropagatorEventType.isFullPropagation(evtmask)){
        // First call to the filtering algorithm, F is not up-to-date
        // so prepare initialize its value and 'prev_lbs'
        prepare();
    }
    if (F.get() < 0) {
        fails();
    }
    for (IntVar var : vars) {
        int lb = var.getLB();
        int ub = var.getUB();
        if (ub - lb > F.get()) {
            var.updateUpperBound(F.get() + lb, this);
        }
    }
}
{{< /tab >}} 
{{< /tabpane>}}

A call to `forcePropagate(int evtmask)` will call `propagate(int evtmask)`
only when all fine events are received. This ensures that F is set to
the correct value before filtering forbidden values.
