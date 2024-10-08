---
title: "First Model"
date: 2020-01-31T11:47:58+01:00
type: docs
math: "true"
weight: 11
description: >
  Let's start with the famous 8-queen problem.
---

First of all, let's consider the eight queen puzzle, frequently used to
introduce constraint programming.

[Wikipedia](https://en.wikipedia.org/wiki/Eight_queens_puzzle) told us
that:

> The eight queens puzzle is the problem of placing eight chess queens
> on an 8x8 chessboard so that no two queens threaten each other. Thus,
> a solution requires that no two queens share the same row, column, or
> diagonal.

The problem can be generalized to the *n*-queens problem (placing *n*
queens on a nxn chessboard).

There are many ways to model this problem with Choco-solver, we will start with
a basic one:

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
int n = 8;
Model model = new Model(n + "-queens problem");
IntVar[] vars = new IntVar[n];
for(int q = 0; q < n; q++){
    vars[q] = model.intVar("Q_"+q, 1, n);
}
for(int i  = 0; i < n-1; i++){
    for(int j = i + 1; j < n; j++){
        model.arithm(vars[i], "!=",vars[j]).post();
        model.arithm(vars[i], "!=", vars[j], "-", j - i).post();
        model.arithm(vars[i], "!=", vars[j], "+", j - i).post();
    }
}
Solution solution = model.getSolver().findSolution();
if(solution != null){
    System.out.println(solution.toString());
}
{{< /tab >}} 
{{< /tabpane >}}

If you copy/paste the this code and execute it, it prints the value that
each variable takes in the solution on the console :

	Solution: Q_0=7, Q_1=4, Q_2=2, Q_3=5, Q_4=8, Q_5=1, Q_6=3, Q_7=6,

Now, let's discuss the code itself.

### The model

On line 2, a `Model` instance is declared. It is the key component of the library
and needed to describe any problem.

### The variables

A queen position is defined by its coordinates on the chessboard.
Naturally, we don't know yet where to put queens on the chessboard, but
we can give indications. To do so, we need to declare *variables*.

A variable is an *unknown* which has to be assigned to value in a
solution. The values a variable can take is defined by its domain.

Here, in a solution, there will be exactly one queen per row (and per
column). So, a modelling trick is to fix the row a queen can go to and
only question on their column. Thus, there will be *n* queens (one per
row), each of them to be assigned to one column, among $\[1,n\]$.

Lines 3 and 5 managed to create variables and their domain.

### The constraints

The queens' position must follow some rules. We already encoded that
there can only be one queen per row. Now, we have to ensure that, on any
solution, no two queens share the same column and diagonal.

First, the columns conditions: if the queen *i* is on column *k*, then
any other queens cannot take the value *k*. So, for each pair of queens,
the two related variables cannot be assigned to the same value. This is
expressed by the *constraint* on line 9. To activate the constraint, it
has to be *posted*.

Second, the diagonals: we have to consider the two orthogonal diagonals.
If the queen *i* is on column *k*, then, the queen *i+1* cannot be
assigned to *k+1*. More generally, the queen *i+m* cannot be assigned to
*k+m*. The same goes with the other diagonal. This is declared on line
10 and 11.

### Solving the problem

Once the problem has been described into a model using variables and
constraints, its satisfaction can be evaluated, by trying to *solve* it.

This is achieved on line 14 by calling the getSolver().findSolution()
method from the model. If a solution exists, it is printed on the
console

What to do next ?
-----------------

We are going to use and extend this small problem in the future. But
before, we will have a look at the different objects we can manipulate.