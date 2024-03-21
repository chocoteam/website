+++
weight = 100
+++

{{% section %}}

Now, we are able to
# solve a basic problem

---

<h1>The 8 queens puzzle</h1>

<blockquote>The eight queens puzzle is the problem of placing eight chess queens on an 8×8  chessboard so that no two queens threaten each other;  thus, a solution requires that no two queens share the same row, column, or diagonal.</blockquote>

[Wikipedia](https://en.wikipedia.org/wiki/Eight_queens_puzzle)

---

<figure>
    <img src="/images/tinytiny/nqueens/8queens.png" alt="This is an alt" width="40%" >
    <figcaption>Src: <a href="https://en.wikipedia.org/wiki/Eight_queens_puzzle">Wikipedia</a></figcaption>
</figure>


---

A first idea is to indicate by a <span style="color:deepskyblue;">Boolean</span> variable if a cell is occupied by a queen or not.

{{% fragment %}}But we wouldn't be able to use our constraints.{{% /fragment %}}

{{% fragment %}}Also, it is very MILP-like or SAT-like.{{% /fragment %}}

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

<h2><a href="https://moodle.caseine.org/mod/vpl/view.php?id=69930" target="_blank" rel="noopener noreferrer"> >>🥛<<</a></h2>



---

## 6 Queens puzzle in Python

```python{2-4|6-11|13-15|17}
n = 8
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

### 46 solutions

```python
{'x1': [1], 'x2': [5], 'x3': [8], 'x4': [6], 'x5': [3], 'x6': [7], 'x7': [2], 'x8': [4], 'cst': [5]}
{'x1': [1], 'x2': [6], 'x3': [8], 'x4': [3], 'x5': [7], 'x6': [4], 'x7': [2], 'x8': [5], 'cst': [5]}
...
{'x1': [4], 'x2': [8], 'x3': [1], 'x4': [5], 'x5': [7], 'x6': [2], 'x7': [6], 'x8': [3], 'cst': [5]}
{'x1': [4], 'x2': [8], 'x3': [5], 'x4': [3], 'x5': [1], 'x6': [7], 'x7': [2], 'x8': [6], 'cst': [5]}
it finds 46 solutions
```

There are 92 solutions without the (simple) symmetry breaking constraint, 46 otherwise.

---

## We did it 🍾
We build a minimalist CP solver :
- based on integer variables,
- using two different types of constraints,
    - each equipped with a filtering algorithm,
- exploring the search space in DFS way.

And we were able to enumerate solutions</br>
on a puzzle !

{{% /section %}}
