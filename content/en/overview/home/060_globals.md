+++
weight = 60
+++

{{% section %}}

# Global Constraints

---

## Definition(s)

> an expressive and concise condition involving a non-fixed number of variables

[[GCCAT]](https://sofdem.github.io/gccat/gccat/preface.html)

<p class="fragment">allDifferent($x_1,x_2,\dots$)</p>

---

## Definition(s)

> a constraint C is often called "global" when "processing" as a whole gives better results than "processing" any conjunction of constraints that is "semantically equivalent" to C

[[BvH03]](https://www.lirmm.fr/~bessiere/Site/stock/cp03-glob.pdf)

<p class="fragment">allDifferent($x_1,x_2,x_3$) $\iff (x_1\neq x_2) \land (x_2\neq x_3) \land (x_3\neq x_1)$</p>

---

### Example of constraints

{{% warn c="cumulative(starts, durations, heights, capacity)" %}}

<figure>
    <img src="/images/overview/scheduling.svg" alt="This is an alt" width="40%" >
    <figcaption>Solution for a <em style="font-variant: small-caps">Cumulative</em> constraint. </figcaption>
</figure>

---

### Example of constraints

{{% warn c="binpacking(bins, weigths, capacity)" %}}

<figure>
    <img src="/images/overview/binpacking.svg" alt="" width="20%" >
    <figcaption>Solution for a <em style="font-variant: small-caps">BinPacking</em> constraint. </figcaption>
</figure>

---

### Example of constraints

{{% warn c="circuit(successors)" %}}

<figure>
    <img src="/images/overview/routing.svg" alt="" width="30%" >
    <figcaption>Solution for a <em style="font-variant: small-caps">Circuit</em> constraint. </figcaption>
</figure>

---

### Some cardinality constraints

<small>


<br/>
<br/>

|Syntax | Definition|
|--|--|
| {{% ccode c="m.allDifferent(X)" %}} | $x_i\neq x_j, \forall i< j$ |
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
| {{% ccode c="m.element(v, X, i, o)" %}} | $\exists i : v = x_{i - o}$ |
| {{% ccode c="m.argmax(i, o, X)" %}} | $i \in \\{j - o : x_j = \max\\{x_k\\}\\}$ |
| {{% ccode c="m.argmin(i, o, X)" %}} | $i \in \\{j - o : x_j = \max\\{x_k\\}\\}$ |
| {{% ccode c="m.max(m, X)" %}} | $m = \max\\{x_i\\}$ |
| {{% ccode c="m.min(m, X)" %}} | $m = \min\\{x_i\\}$ |
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
| {{% ccode c="m.knapsack(O, W, E, w, e)" %}} | $\sum_{i} w_i \times O_i = w \land \sum_{i} e_i \times O_i = e$
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

{{< slide background="#76bde8"  >}}

## Magic Sequence

A magic series of length $n$ is a sequence of integers $[x_0, ..., x_{n-1}]$  between $0$ and $n-1$, such that for all $i \in \\{0 , ..., n-1\\}$, the number $i$ occurs exactly $x_i$ times in the sequence. 

For instance, $[1,2,1,0]$ is a magic series of length $4$ : 
- value 0 occurs once 
- value 1 occurs twice 
- value 2 occurs once 
- value 3 does not occur 

Write a CP model in java using the Choco solver to find magic series for any given n.




{{% /section %}}
