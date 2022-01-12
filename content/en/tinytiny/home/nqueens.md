+++
weight = 100
+++

{{% section %}}

Now, we are able to
# solve a basic problem

---

<h1>The 6 queens puzzle</h1>

<blockquote>The six queens puzzle is the problem of placing six chess queens on an 6×6 chessboard so that no two queens threaten each other;  thus, a solution requires that no two queens share the same row, column, or diagonal.</blockquote>

[Wikipedia](https://en.wikipedia.org/wiki/Eight_queens_puzzle)

--- 

TODO: image


---

A first idea is to indicate by a <span style="color:deepskyblue;">boolean</span> variable if a cell is occupied by a queen or not.

{{% fragment %}}But we wouldn't be able to use our constraints.{{% /fragment %}}

{{% fragment %}}Also, it is very MILP or SAT.{{% /fragment %}}

---

## A more CP way to model it

A <span style="color:deepskyblue;">variable</span> per column.

Each <span style="color:deepskyblue;">domain</span> encodes the row where the queen is set.

Four groups of inequality <span style="color:deepskyblue;">constraints</span> are posed:
1. no two queens share the same row
2. no two queens share the same column (➡️ _handled by the model_ 🤘)
3. no two queens share the same upward diagonal 
4. no two queens share the same downward diagonal 

---

## 6 Queens puzzle in Python

```python{2-4|6-11|13-15|17}
n = 6
variables = {}
for i in range(1, n + 1):
    variables["x" + str(i)] = {k for k in range(1, n + 1)}

cs = []
for i in range(1, n):
    for j in range(i + 1, n + 1):
        cs.append(NotEqual("x" + str(i), "x" + str(j)))
        cs.append(NotEqual("x"+str(i),"x"+str(j), c=(j-i)))
        cs.append(NotEqual("x"+str(i),"x"+str(j), c=-(j-i)))

# mirror symm. breaking
variables["cst"] = {int(n / 2) + 1}
cs.append(LessThan("x1", "cst"))

print("it finds", enumerate(variables, cs), "solutions")
```
---

### 2 solutions

```python
{'x1': [2], 'x2': [4], 'x3': [6], 'x4': [1], 'x5': [3], 'x6': [5], 'cst': {4}}
{'x1': [3], 'x2': [6], 'x3': [2], 'x4': [5], 'x5': [1], 'x6': [4], 'cst': {4}}
it finds 2 solutions
```

There are 4 solutions without the symmetry breaking constraint, 2 otherwise.

---

## We did it 🍾
We build a minimalist CP solver :
- based on integer variables,
- using two different types of constraints,
    - each equipped with a filtering algorithm,
- exploring the search space in DFS way.

And we were able to enumerate solutions</br> 
on a basic problem !

{{% /section %}}