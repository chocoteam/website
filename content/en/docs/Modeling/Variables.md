---
title: "Declaring variables"
date: 2020-01-07T16:06:55+01:00
weight: 21
description: >
  How to declare variables?
math: "true"  
---


A variable is an *unknown*, mathematically speaking.
The goal of a resolution is to *assign* a *value* to each variable.
The *domain* of a variable –(super)set of values it may take– must be defined in the model.

Choco-solver includes several types of variables: `BoolVar`, `IntVar`, `SetVar` and `RealVar`.
Variables are created using the `Model` object.
When creating a variable, the user can specify a name to help reading the output.

## Integer variables

An integer variable is an unknown whose value should be an integer. Therefore, the domain of an integer variable is a set of integers (representing possible values).
To create an integer variable, the `Model` should be used:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// Create a constant variable equal to 42
IntVar v0 = model.intVar("v0", 42);
// Create a variable taking its value in [1, 3] (the value is 1, 2 or 3)
IntVar v1 = model.intVar("v1", 1, 3);
// Create a variable taking its value in {1, 3} (the value is 1 or 3)
IntVar v2 = model.intVar("v2", new int[]{1, 3});
{{< /tab >}}
{{< tab "Python" >}}
# Create a constant variable equal to 42
v0 = model.intvar(42, name="v0")
# Create a variable taking its value in [1, 3] (the value is 1, 2 or 3)
v1 = model.intvar(1, 3, name="v1")
# Create a variable taking its value in {1, 3} (the value is 1 or 3)
v2 = model.intvar([1, 3], name="v2")
{{< /tab >}} 
{{< /tabpane >}}

It is then possible to build directly arrays and matrices of variables having the same initial domain with:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// Create an array of 5 variables taking their value in [-1, 1]
IntVar[] vs = model.intVarArray("vs", 5, -1, 1);
// Create a matrix of 5x6 variables taking their value in [-1, 1]
IntVar[][] vs = model.intVarMatrix("ws", 5, 6, -1, 1);
{{< /tab >}} 
{{< tab "Python" >}}
# Create an array of 5 variables taking their value in [-1, 1]
vs = model.intvars(5, -1, 1,name="vs")
# Create a matrix of 5x6 variables taking their value in [-1, 1]
ws = [ model.intvars(6, -1, 1, name="ws_"+str(i)) for i in range(5) ]
{{< /tab >}} 
{{< /tabpane >}}

There exists different ways to encode the domain of an integer variable: bounded domain or enumerated domain.

### Bounded domain

When the domain of an integer variable is said to be *bounded*, it is represented through
an interval of the form $[\\![a,b]\\!]$ where $a$ and $b$ are integers such that $a \leq b$.
This representation is pretty light in memory (it requires only two integers) but it cannot represent *holes* in the domain.
For instance, if we have a variable whose domain is $[\\![0,10]\\!]$ and a constraint enables to detect that
values 2, 3, 7 and 8 are infeasible, then this learning will be lost as it cannot be encoded in the domain (which remains the same).
However, whenever the values 9 and 10 are removed from the variable's domain, the upper bound of the variable will be set to 6 by such a constraint.

To specify you want to use bounded domains, set the `boundedDomain` argument to `true` when creating variables:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
IntVar v = model.intVar("v", 1, 12, true);
{{< /tab >}} 
{{< /tabpane >}}

{{% alert title="Info" color="primary" %}}
When using bounded domains, branching decisions must either be domain splits or bound assignments/removals.
Indeed, assigning a bounded variable to a value strictly comprised between its bounds may results in infinite loop
because such branching decisions will not be refutable.
{{% /alert %}}

### Enumerated domains

When the domain of an integer variable is said to be *enumerated*, it is represented through
the set of possible values, in the form:
- $[\\![a,b]\\!]$ where $a$ and $b$ are integers such that $a \leq b$
- $\{a,b,c,..,z\}$, where $a < b < c ... < z$.
Enumerated domains provide more information than bounded domains but are heavier in memory (the domain usually requires a bitset).

To specify you want to use enumerated domains, either set the `boundedDomain` argument to `false` when creating variables by specifying two bounds
or use the signature that specifies the array of possible values:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
IntVar v = model.intVar("v", 1, 4, false);
IntVar v = model.intVar("v", new int[]{1,2,3,4});
{{< /tab >}} 
{{< tab "Python" >}}
v = model.intvar([1,2,3,4], name="2")
{{< /tab >}} 
{{< /tabpane >}}


{{% alert title="Info" color="primary" %}}
If the API without the `boundedDomain` argument is used, the engine will select the more accurate representation 
depending on the domain's cardinality. 
{{% /alert %}}

## Boolean variables

Boolean variables, `BoolVar`, are specific `IntVar` that take their value in $[\\![0,1]\\!]$.
The avantage of `BoolVar` is twofold:
- They can be used to say whether or not constraint should be satisfied (reification)
- Their domain, and some filtering algorithms, are optimized

To create a new boolean variable:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
BoolVar b = model.boolVar("b");
// A Boolean variable fixed to True
BoolVar b = model.boolVar(true);
{{< /tab >}} 
{{< tab "Python" >}}
b = model.boolVar(name="b")
# A Boolean variable fixed to True
t = model.boolvar(True)
{{< /tab >}} 
{{< /tabpane >}}

## Set variables

A set variable, `SetVar`, represents a set of integers, i.e. its value is a set of integers.
Its domain is defined by a set interval $[\\![m,o]\\!]$ where:


* the lower bound, $m$, is an `ISet` object which contains integers that figure in every solution.


* the upper bound, $o$, is an `ISet` object which contains integers that potentially figure in at least one solution,

Initial values for both $m$ and $o$ should be such that $m \subseteq o$.
Then, decisions and filtering algorithms will remove integers from $o$ and add some others to $m$.
A set variable is instantiated if and only if $m = o$.

A set variable can be created as follows:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// Constant SetVar equal to {2,3,12}
SetVar x = model.setVar("x", new int[]{2,3,12});

// SetVar representing a subset of {1,2,3,5,12}
SetVar y = model.setVar("y", new int[]{}, new int[]{1,2,3,5,12});
// possible values: {}, {2}, {1,3,5} ...

// SetVar representing a superset of {2,3} and a subset of {1,2,3,5,12}
SetVar z = model.setVar("z", new int[]{2,3}, new int[]{1,2,3,5,12});
// possible values: {2,3}, {2,3,5}, {1,2,3,5} ...
{{< /tab >}} 
{{< tab "Python" >}}
# Constant SetVar equal to {2,3,12}, with a list
x1 = model.setvar([2,3,12], name="x1")
# or with a set
x2 = model.setvar({4,5,13}, name="x2")

# SetVar representing a subset of {1,2,3,5,12}
y = model.setvar({}, {1,2,3,5,12}, name="y")
# possible values: {}, {2}, {1,3,5} ...

# SetVar representing a superset of {2,3} and a subset of {1,2,3,5,12}
z = model.setvar([2,3], {1,2,3,5,12})
# possible values: {2,3}, {2,3,5}, {1,2,3,5} ...
{{< /tab >}} 
{{< /tabpane >}}

## Graph Variables

A graph variable $G$ is a variable which takes its values in a finite set of graphs. The domain of a graph variable $G$ is a graph interval $[\underline{G}, \overline{G}]$, with $\underline{G}$ a graph called the _kernel_ (or _lower bound_) of $G$ and $\overline{G}$ the _envelope_ (or _upper bound_) of $G$. Any instantiation $v_G$ of $G$ is such that $\underline{G} \subseteq v_G \subseteq \overline{G}$.

The lower bound is composed of two sets: the set of nodes  and the set of edges that belong to all instantiation of $G$.

The upper bound is composed of two sets: the set of nodes and the set of edges that potentially figure in at least one solution.

A graph variable is instantiated if and only if $\underline{G} = \overline{G}$.

A graph variable can be created as follows:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// A directed graph
// first declare the lower bound
DirectedGraph LB = GraphFactory.makeStoredDirectedGraph(model, 3, SetType.BITSET, SetType.BITSET);
// then declare the upper bound
DirectedGraph UB = GraphFactory.makeStoredAllNodesDirectedGraph(model, 3, SetType.BITSET, SetType.BITSET, false);
UB.addEdge(0, 1);
UB.addEdge(1, 2);
UB.addEdge(2, 0);
// finally declare the graph variable
DirectedGraphVar g = model.digraphVar("g", LB, UB);

// An undirected graph
UndirectedGraph LB = GraphFactory.makeStoredUndirectedGraph(model, 3, SetType.BITSET, SetType.BITSET);
// the last parameter indicates that a complete graph is required
UndirectedGraph UB = GraphFactory.makeCompleteStoredUndirectedGraph(model, 3, SetType.BITSET, SetType.BITSET, true);
UndirectedGraphVar g = model.graphVar("g", LB, UB);
{{< /tab >}} 
{{< tab "Python" >}}
from pychoco.objects.graphs.directed_graph import create_directed_graph
# A directed graph
# first declare the lower bound
lb = create_directed_graph(model, n, [], [])
# then declare the upper bound
ub = create_directed_graph(model, n, [0,1,2],[[0,1], [1,2], [2,0]])
# finally declare the graph variable
g = model.digraphvar(lb, ub, "g")

from pychoco.objects.graphs.undirected_graph import create_undirected_graph, create_complete_undirected_graph
lb = create_undirected_graph(model, n, [], [])
ub = create_complete_undirected_graph(model, 3)
g = model.graphvar(lb, ub, "g")
{{< /tab >}} 
{{< /tabpane >}}


## Real variables

The domain of a real variable is an interval of doubles. Conceptually, the value of a real variable is a double.
However, it uses a precision parameter for floating number computation,
so its actual value is generally an interval of doubles, whose size is constrained by the precision parameter.
Real variables have a specific status in Choco 4, which uses [Ibex solver](http://www.ibex-lib.org/) to define constraints.

A real variable is declared with three doubles defining its bound and a precision:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
RealVar x = model.realVar("x", 0.2d, 3.4d, 0.001d);
{{< /tab >}} 
{{< /tabpane >}}


{{% alert title="Info" color="primary" %}}
`pychoco` version does not support `realvar`.
{{% /alert %}}

## Views: Creating variables from constraints

When a variable is defined as a function of another variable, views can be
used to make the model shorter. In some cases, the view has a specific (optimized) domain representation.
Otherwise, it is simply a modeling shortcut to create a variable and post a constraint at the same time.

### Arithmetical views

An arithmetical view requires an integer variable. 

#### $x = y + 2$ :

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
IntVar x = model.intOffsetView(y, 2);
{{< /tab >}} 
{{< tab "Python" >}}
x = model.int_offset_view(y, 2)
{{< /tab >}} 
{{< /tabpane >}}

#### $x = -y$ :

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
IntVar x = model.intMinusView(y);
{{< /tab >}}
{{< tab "Python" >}}
x = model.int_minus_view(y)
{{< /tab >}}  
{{< /tabpane >}}

#### $x = 3\times y$ :

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
IntVar x = model.intScaleView(y, 3);
{{< /tab >}} 
{{< tab "Python" >}}
x = model.int_scale_view(y, 3)
{{< /tab >}} 
{{< /tabpane >}}

### Logical views

A logical view is based on an integer variable, a basic arithmetical relation ($=,\neq,\leq,\geq$) and a constant. The resulting view states whether or not the relation holds.

#### $b \Leftrightarrow (x = 4)$ :

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
BoolVar b = model.intEqView(x, 4);
{{< /tab >}} 
{{< tab "Python" >}}
b = model.int_eq_view(x, 4)
{{< /tab >}} 
{{< /tabpane >}}

#### $b \Leftrightarrow (x \neq 4)$ :

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
BoolVar b = model.intNeView(x, 4);
{{< /tab >}} 
{{< tab "Python" >}}
b = model.int_ne_view(x, 4)
{{< /tab >}} 
{{< /tabpane >}}


#### $b \Leftrightarrow (x \leq 4)$ :

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
BoolVar b = model.intLeView(x, 4);
{{< /tab >}} 
{{< tab "Python" >}}
b = model.int_le_view(x, 4)
{{< /tab >}} 
{{< /tabpane >}}

#### $b \Leftrightarrow (x \geq 4)$ :

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
BoolVar b = model.intGeView(x, 4);
{{< /tab >}} 
{{< tab "Python" >}}
b = model.int_ge_view(x, 4)
{{< /tab >}} 
{{< /tabpane >}}

#### $d \Leftrightarrow \neg b$
This is a specific case, related to the negation of a `BoolVar`.
No additional variable is needed, a view based on the variable to refute is enough. 

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
BoolVar d = model.boolNotView(b);
{{< /tab >}} 
{{< tab "Python" >}}
d = model.bool_not_view(b)
{{< /tab >}} 
{{< /tabpane >}}

{{% alert title="Info" color="primary" %}}
The same result can be obtained in shorted version (in Java only):

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
BoolVar d = b.not();
{{< /tab >}} 
{{< /tabpane >}}


{{% /alert %}}



### Composition 

Views can be combined together, e.g. $x = 2\times y + 5$ is:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
IntVar x = model.intOffsetView(model.intScaleView(y,2),5);
{{< /tab >}} 
{{< tab "Python" >}}
x = model.int_offset_view(model.int_scale_view(y,2),5)
{{< /tab >}} 
{{< /tabpane >}}

### View over real variable  
We can also use a view mecanism to link an integer variable with a real variable.

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
IntVar ivar = model.intVar("i", 0, 4);
double precision = 0.001d;
RealVar rvar = model.realIntView(ivar, precision);
{{< /tab >}} 
{{< /tabpane >}}

This code enables to embed an integer variable in a constraint that is defined over real variables.
