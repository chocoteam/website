+++
weight = 60
+++

{{% section %}}

# Global Constraints

--- 


---

### Some cardinality constraints

<small>


<br/>
<br/>

|Syntax | Definition|
|--|--|
| {{% ccode c="m.allDifferent(X)" %}} | $X_i\neq X_j, \forall i< j$ |
| {{% ccode c="m.among(n, X, v)" %}} | $\|x_i : x_i \cap v\neq \emptyset \| = n$ |
| {{% ccode c="m.count(y, X, n)" %}} | $ \| \\{ x_i : x_i = y \\} \| = n$ |
| {{% ccode c="m.nValues(X, n)" %}} | $\|x_i\| = n$ |
|

<br/>

**Notations**
- Arrays: $X=\langle x_0, x_1,\ldots\rangle$
- Index: $ 0 \leq i < |X|$

</small>	

---

### Some connection constraints

<small>


|Syntax | Definition|
|--|--|
| {{% ccode c="m.argmax(i, o, X)" %}} | $i \in \\{j - o : x_j = \max\\{x_k\\}\\}$ |
| {{% ccode c="m.argmin(i, o, X)" %}} | $i \in \\{j - o : x_j = \max\\{x_k\\}\\}$ |
| {{% ccode c="m.max(m, X)" %}} | $m = \max\\{x_i\\}$ |
| {{% ccode c="m.min(m, X)" %}} | $m = \min\\{x_i\\}$ |
| {{% ccode c="m.element(v, X, i, o)" %}} | $\exists i : v = x_{i - o}$ |
| {{% ccode c="m.inverseChanneling(X, Y)" %}} | $ \forall i: x_i = j \iff y_j = i \quad (\|X\| = \|Y\|)$|
|


<br/>

**Notations**
- Arrays: $X=\langle x_0, x_1,\ldots\rangle$
- Index: $ 0 \leq i < |X|$

</small>	


---

### Some Packing and Scheduling constraints

<small>

|Syntax | Definition|
|--|--|
| {{% ccode c="m.binPacking(X, S, L, o)" %}} | $ \forall b \in \\{x_i\\},\sum_{i : x_i = b} S_i \leq L_b$
| {{% ccode c="m.cumulative(A, H, c)" %}} | $ \forall t \in \mathcal{N},\sum\\{h_i : a^s_i \leq t < a^e_i\\} \leq c$
| {{% ccode c="m.diffN(X, Y, W, H, true)" %}} | $\forall i<j, x_{i} + w_{i} \leq x_{j} \lor x_{j} + h_{j} ≤ x_{i}$<br/>$\quad\quad\quad \lor y_{i} + h_{i} \leq y_{j} \lor y_{j} + w_{j} ≤ y_{i}$
| {{% ccode c="m.knapsack(O, w, e, W, E)" %}} | $\sum_{i} w_i \times O_i = W \land \sum_{i} e_i \times O_i = E$
|


<br/>

**Notations**
- Arrays: $X=\langle x_0, x_1,\ldots\rangle$
- Index: $ 0 \leq i < |X|$
- Task (or activity): $a^s + a^d = a^e$

</small>	

---

### Some Graph-based constraints

<small>

|Syntax | Definition|
|--|--|
| {{% ccode c="m.circuit(X) " %}} |    $\\{(i, x_i) : i \neq x_i\\}$ forms a circuit of size $> 1$
| {{% ccode c="m.path(X, s, e)" %}} |    $\\{(i, x_i) : i \neq x_i\\}$ forms a path from $s$ to $e$
| {{% ccode c="m.tree(X, n)" %}} |    $\\{(i, x_i) : i \neq x_i\\}$ is partitioned into $n$ anti-arborescences
|

<br/>

**Notations**
- Arrays: $X=\langle x_0, x_1,\ldots\rangle$
- Index: $ 0 \leq i < |X|$
- A pair $(i, x_i)$ represents an arc in a graph induced by $X$

</small>	

---

{{< slide id="ex4" background="#76bde8"  >}}

## Now it's your turn

- TODO 


{{% /section %}}