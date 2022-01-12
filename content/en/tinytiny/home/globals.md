+++
weight = 120
+++

{{% section %}}

# It's all about constraints 

---

The {{% calert c="value" %}} of CP lies 
### in the constraints

{{% fragment %}}We only saw two basic binary constraints{{% /fragment %}} 

{{% fragment %}}But there are hundreds of them{{% /fragment %}}

--- 

{{< slide id="gccat" background-iframe="http://sofdem.github.io/gccat/gccat/sec5.html" >}}

---

## Why are there so many of them?

Is it not possible to do with less?

{{% fragment %}}MILP and SAT are doing very well with **one** type of constraint{{% /fragment %}}

---

## Two main reasons

1. {{% calert c="Modeling" %}}: stronger expressive power
2. {{% calert c="Solving" %}}: increased filter quality

---

### At the modeling stage

- each constraint is semantically defined
- which also indicates the contract it guarantees

---

### Examples


| Name | Purpose |
|-----|-----|
|`alldifferent`| enforces all variables in its scope to take distinct values| 
| `increasing`| the variables in its scope are increasing |
| `maximum`| a variable is the maximum value of a collection of variables |
|...|
|

---

### Others are less obvious 😇

`subgraph_isomorphism`, `path`, `diffn`, `geost`, ...

but are documented

---

### At the modeling stage (2/2)

- A CSP model is a conjunction of constraints
- The model can be very compact
- It is easy to understand and modify a model

{{%fragment%}}Recall that there are modelling languages to do this{{%/fragment%}}

---

### At solving stage

But it is rather here that one can measure the interest of the constraints

---

A constraint captures a sub-problem

### and provides an efficient way to deal with it

thanks to an adapted filtering algorithm 

---

## On one example

---

### $\bigwedge_{x_i,x_j \in X, i\neq j} x_i \neq x_j$ 
### -vs- 
### $\texttt{allDifferent}(X)$


{{% fragment %}}Both modelings find the same solutions{{% /fragment %}}

{{% fragment %}}but the 2nd filters more {{% /fragment %}}
---

### With binary constraints

![Alt text.](/images/constraints/alldiff1.svg)

What can be deduced?{{% fragment %}}Nothing until a variable is set{{% /fragment %}}
---

{{< slide transition="fade-in none" >}}

### With a global constraint

![Alt text.](/images/constraints/alldiff1.svg) 

Rely on graph theory...

--- 

{{< slide transition="fade-in none" >}}

### With a global constraint

![Alt text.](/images/constraints/alldiff2.svg) 

pair variables and values in a bipartite graph...

--- 

{{< slide transition="none" transition-speed="fast" >}}

### With a global constraint

![Alt text.](/images/constraints/alldiff3.svg)

find maximum cardinality matchings...

--- 

{{< slide transition="none" transition-speed="fast" >}}

### With a global constraint

![Alt text.](/images/constraints/alldiff4.svg)

remove values which belong to none of them.

---

## Summary

| | $\bigwedge_{x_i,x_j \in X, i\neq j} x_i \neq x_j$ | $\texttt{allDifferent}(X)$ |
|-----|-----|-----|
|#cstrs | $\frac{\vert X \vert \times \vert X\vert -1}{2}$ | 1 | 
| Filtering | weak and late | _arc-consistency_ in polynomial time and space |
|Algorithm| straightforward | tricky* |

<small>*: but already done for you in libraries</small>


{{% note %}}

fix-point might be long

$$O(n\sqrt{\sum d})$$

{{% /note %}}

---

## Remarks about global constraints 

Many model {{% calert c="highly combinatorial problems" %}}
It is likely that:
- arc-consistency is not reached (_i.e., weaker filtering_)
- filtering is complex to achieve

Their expressive power remains strong

{{% /section %}}