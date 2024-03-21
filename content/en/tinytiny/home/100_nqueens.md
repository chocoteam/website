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

```python{4-6|8-13|15-17|19-23}
import model as m

n = 8
vs = {}
for i in range(1, n + 1):
    vs["x" + str(i)] = {k for k in range(1, n + 1)}

cs = []
for i in range(1, n):
    for j in range(i + 1, n + 1):
        cs.append(m.NotEqual("x" + str(i), "x" + str(j)))
        cs.append(m.NotEqual("x" + str(i), "x" + str(j), c=(j - i)))
        cs.append(m.NotEqual("x" + str(i), "x" + str(j), c=-(j - i)))

# mirror symm. breaking
vs["cst"] = {int(n / 2) + 1}
cs.append(m.LessThan("x1", "cst"))

# search for all solutions
sols = []
m.dfs(vs, cs, sols, nos=0)
print(len(sols), "solution(s) found")
print(sols)
```
---

### 46 solutions

```bash
46 solution(s) found
[[1, 5, 8, 6, 3, 7, 2, 4, 5], ..., [4, 8, 5, 3, 1, 7, 2, 6, 5]]
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
