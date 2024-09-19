+++
title = "CP in a nutshell"
outputs = ["Reveal"]

[reveal_hugo]
theme = "simple"
slide_number = true
highlight_theme = "github"
+++

## CP in a Nutshell

</br>
Charles Prud'homme, Sept. 2025

IMT Atlantique, LS2N, TASC

<br/>
<small style="color:#C70039">< press [N] / [P] to go the next / previous slide ></small>

---

## Constraint Programming 

CP is a powerful paradigm for solving combinatorial problems.  

Originated from AI and operations research.

Widely used in scheduling, planning, and resource allocation.

---

{{% section %}}

## Techniques for Solving Combinatorial Problems

### Exact methods
Linear Programming, Integer Programming, SAT, {{% calert c="CP" %}}, ...

### Approximation methods
Heuristics, Metaheuristics, Local Search, ...

--- 

## Exact Method

CP is an exact method, meaning it guarantees to find a solution if one exists or proves no solution is possible. 

Typically it involves searching the solution space exhaustively but with intelligent pruning.


---

## Similarities with Linear Programming (LP)
- Both CP and LP are used to solve optimization problems.
- They both define variables, domains, and constraints.
- Both use systematic search techniques for exploring solutions.

---

## Differences with LP
- **LP**: Problems are expressed using linear constraints and an objective function.
- **CP**: Can handle non-linear and logical constraints without requiring an objective function.

CP is more flexible in expressing combinatorial relationships.


{{% /section %}}

---

{{% section %}}

# P = (V,D,C)

--- 

## What is a Variable?
A variable represents an unknown value that needs to be determined.  

--- 

### Examples
- In a Sudoku puzzle, each cell can be a variable representing its value.
- In a scheduling problem, each task can be a variable representing its start time.
- In a routing problem, each node can be a variable representing its successor.
- In a packing problem, each item can be a variable representing its bin.

---

## What is a Domain?
The domain of a variable is the set of possible values that the variable can take.  

---

### Examples
- For a Sudoku cell, the domain might be the set of possible values: {1, 2, 3, 4, 5, 6, 7, 8, 9}.
- For a scheduling task, the domain might be the set of possible start times: [1, 999].
- For a routing problem, the domain might be the set of possible successors: {A, B, C, D}.

---

## What is a Constraint?
A constraint defines a condition that must be satisfied by the variables in its scope.

---

### Examples
- In Sudoku, "each row must contain all numbers from 1 to 9" is a constraint.
- In scheduling, "no two tasks can happen at the same time" is a constraint.
- In routing, "each node must be visited exactly once" is a constraint.
- In packing, "the sum of weights in each bin must not exceed the bin capacity" is a constraint.

---


## What is a Solution?
A solution is an assignment of values to all variables such that all constraints are satisfied.  

CP problems may have one, many, or no solutions.

{{% /section %}}

---

{{% section %}}

## Constraint Propagation
Constraint propagation is a core technique in CP to reduce the domain of variables.  
- Propagates the impact of constraints throughout the problem, reducing search space.
- Pruning infeasible values from domains.

---

## Example of Propagation
Consider two variables `X` and `Y` with domain `{1, 2, 3}` and a constraint `X > Y`.  

After propagation:
- the domain of `X` becomes `{2,3}`.
- the domain of `Y` becomes `{1,2}`.

---

## Propagation in Practice

_Global constraints_ are used to capture common patterns and enable efficient propagation.

In real-world problems, propagation can significantly reduce the time it takes to find a solution.  


{{% /section %}}

---

{{% section %}}

## Search Space

CP solvers alternate between **Depth-First Search (DFS)** and constraint propagation to find a solution.

DFS explores one possible solution at a time and backtracks whenever a constraint is violated.

---

## Search Strategies

CP solvers explore possible assignments of values to variables.  

Each node in the search tree represents a partial assignment, validated through constraint propagation.

---


## Backtracking in CP
When a conflict arises, CP solvers backtrack.  
- This means undoing the most recent variable assignment and trying an alternative.
- This is crucial for ensuring that all potential solutions are explored.

{{% /section %}}

---

## Benefits of Constraint Programming

- **Expressive**: Can handle complex relationships and constraints.
- **Flexible**: Easily adapts to various domains like scheduling, routing, and resource allocation.

---

## Applications of CP
- Scheduling (e.g., airline crew scheduling).
- Resource allocation (e.g., production planning).
- Routing problems (e.g., vehicle routing).

---

## Conclusion
Constraint Programming is a versatile and powerful tool for solving complex combinatorial problems.  

Ideal for problems with rich, non-linear constraints.
