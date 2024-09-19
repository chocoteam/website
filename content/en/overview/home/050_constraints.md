+++
weight = 50
+++

{{% section %}}
# Constraints
## (and propagators)

---

<section data-noprocess >
<h2>A constraint </h2>

<ul>
<li class="fragment">represents a problem's <span style="color:deepskyblue;">requirements or limitations</span>,</li>
<li class="fragment">defines a <span style="color:deepskyblue;">relationships among variables,</span> </li>
<li class="fragment">expresses <span style="color:deepskyblue;">conditions</span> that must be satisfied by the values assigned to the variables,</li>
<li class="fragment">is equipped with a <span style="color:deepskyblue;">filtering</span> algorithm.</li>
</ul>

<p class="fragment">For example: $X < Y$</p>


<!--</section> to bind to the next section tag-->


---
<script src="dist/reveal.js"></script>

The goal of constraint programming is to find a combination of variable assignments that {{% calert c="simultaneously" %}} satisfies {{% calert c="all" %}} the specified constraints.

---

## Basic constraints

---

<small>

| Constraint | Syntax | Comment |
|-----|-----|-----|
|
$x + y = z$ | {{% ccode c=m.arithm(x,"+",y,"=",z) %}} | Up to 3 variables |
$\sum_i C_i\cdot X_i = 11$ | {{% ccode c=m.scalar(X,C,"=",11) %}} | See also {{% ccode c=m.sum(x,op,c) %}} |
$x\times y = z$ | {{% ccode c=m.times(x,y,z) %}}| Alt. Euclidean division |
$y = \|x\|$ | {{% ccode c="m.absolute(y,x)" %}} | Or view: {{% ccode c="y = m.abs(x)" %}}  |
$ \|x-y \| > 3$ | {{% ccode c="m.distance(x,y,\">\", 3)" %}} ||
$z = \max(x,y)$ | {{% ccode c="m.max(z,x,y)" %}} | Alt. $\min$ |
$\bigvee_i B_i$ | {{% ccode c="m.or(B)" %}} | Alt. {{% ccode c="m.and(B)" %}} |
|


</br>
Arrays of variables are designated by capital letters</small>

---

### Adding a constraint to the model

<small>

Once a constraint has been created, it must be {{% calert c="activated or reified" %}}


<table>  
	<tr>
		<th>Action</th>
		<th>Syntax</th>
	</tr>
	<tr><td></td><td></td></tr>
	<tr>
		<td rowspan="1">Activate $c$</td>
		<td>{{% ccode c="c.post();" %}}</td>
	</tr>
	<tr>
		<td>$c \iff b$</td>
		<td>{{% ccode c="c.reifyWith(b);"%}}</br>{{% ccode c="BoolVar b = c.reify();"%}}</td>
	</tr>  
	<tr>
		<td rowspan="1">$c \implies  b$</td>
		<td>{{% ccode c="c.implies(b);" %}}</td>
	</tr>
	<tr>
		<td rowspan="1">$b \implies c$</td>
		<td>{{% ccode c="c.impliedBy(b);" %}}</td>
	</tr>
	<tr/>
</table>


</br>
</small>

---

### What if you want to express such a a non-linear constraint 🔋 ?

<figure>
    <img src="/images/overview/battery.svg" alt="This is an alt" width="70%" >
</figure>

---

## In extension

---


This can be achieved with a <em style="font-variant: small-caps">Table</em>  constraint

```java{|4-10|11}
Model m = new Model();
IntVar c = m.intVar("SoC", 0, 100);
IntVar v = m.intVar("cV", 1140, 1280);
Tuples tuples = new Tuples();
tuples.add(100, 1273);
tuples.add(90, 1240);
tuples.add(80, 1235);
//...
tuples.add(20, 1195);
tuples.add(10, 1151);
m.table(c, v, tuples).post();
```

---

### Types of <em style="font-variant: small-caps">Table</em> constraints

---


Allowed tuples

```java
Model m = new Model();
IntVar[] xs = m.intVarArray("x", 3, 1, 3);

// all equal
Tuples tuples = new Tuples();
tuples.add(1, 1, 1);
tuples.add(2, 2, 2);
tuples.add(3, 3, 3);

m.table(xs, tuples).post();
```

---

{{% calert c="Forbidden" %}} tuples

```java{4-5|}
Model m = new Model();
IntVar[] xs = m.intVarArray("x", 3, 1, 3);

// *not* all equal
Tuples tuples = new Tuples(false);
tuples.add(1, 1, 1);
tuples.add(2, 2, 2);
tuples.add(3, 3, 3);

m.table(xs, tuples).post();
```

---

{{% calert c="Universal value" %}}
<small>Like `'*'` symbol in regular expression.</small>

```java{5-7|}
Model model = new Model();
IntVar[] xs = m.intVarArray("x", 3, 0, 3);

Tuples ts = new Tuples();
int star = 99;
ts.setUniversalValue(star);
ts.add(3, star, 1);
ts.add(1, 2, 3);
ts.add(2, 3, 2);
model.table(xs, ts).post();
```

---

{{% calert c="Hybrid" %}} tuples

```java{4-8|}
Model model = new Model();
IntVar[] xs = m.intVarArray("x", 3, 1, 3);

HybridTuples tuples = new HybridTuples();
tuples.add(ne(1), any(), eq(3));
tuples.add(eq(3), le(2), ne(1));
tuples.add(lt(3), eq(2), ne(b));
tuples.add(gt(2), ge(2), any());

model.table(xs, tuples).post();
```

---

It is also possible to express a constraint from a variable


---

### Expressions

---

<small>

| Family | Syntax |
|-----|-----|
|||
| Arithmetic 	| {{% ccode c="x.neg() x.abs() x.sqr()" %}}<br/>{{% ccode c="x.add(i, ...) x.sub(i, ...)" %}} <br/> {{% ccode c="x.div(i) x.mod(i) x.pow(i) x.dist(i)" %}} <br> {{% ccode c="x.max(i, ...) x.min(i, ...)" %}}|
| Relational 	| {{% ccode c="x.eq(i) x.ne(i) x.in(i, ...) x.nin(i, ...)" %}}<br/>{{% ccode c="x.lt(i) x.le(i) x.gt(i) x.ge(i)" %}} |
| Logical 		| {{% ccode c="x.not() x.imp(r) x.iff(r) x.ift(r1, r2)" %}} <br> {{% ccode c="x.and(r, ...) x.or(r, ...) x.xor(r, ...)" %}} |
|

<br/>
$i$ is either an {{% ccode c="int" %}}, a {{% ccode c="IntVar" %}} or an arithmetical expression,
<br/>$r$ is a relational expression.

</small>

---

### Example

$(x = y + 1) \lor (x+2 \leq 6)$

```java{|3}
IntVar x = //...
IntVar y = //...
x.eq(y.add(1)).or(x.add(2).le(6)).post();
```

---

### Adding an expression to the model


<small>
Here again, there are different ways to work with an expression $e$, depending on its type:

| Syntax | Ar. | Re. | Lo. |
|--|--|--|--|
|{{% ccode c="e.post();" %}}|❌|✅|✅|
|{{% ccode c="c = e.decompose();" %}} <br/>{{% ccode c="c = e.extension();" %}}|❌<br/>❌|✅<br/>✅|✅<br/>✅|
|{{% ccode c="x = e.intVar();" %}}<br/>{{% ccode c="b = e.boolVar();" %}}|✅<br/>❌|❌<br/>✅|❌<br/>✅|


</small>

---

{{< slide background="#76bde8"  >}}

###  Sujiko

The puzzle takes place on a 3x3 grid with four circled number clues at the centre of each quadrant which indicate the sum of the four numbers in that quadrant.

The numbers 1-9 must be placed in the grid, in accordance with the circled clues, to complete the puzzle.

---
{{< slide background="#76bde8"  >}}

###  Empty grid

<figure>
    <img src="/images/overview/sujiko.png" alt="This is an alt" width="50%" >
</figure>


--- 


{{< slide background="#76bde8"  >}}

### A Model

- **Parameters**
	- $S_0, S_1, S_2, S_3$: the four circled number clues
	- $f_{i,j}$: some fixed cells
- **Variables**
	- $\forall i,j \in [\\![0,2]\\!]^2, x_{i,j} \in [\\![1,9]\\!]$
- **Constraints**
	- $\forall i, i', j, j'  \in [\\![0,2]\\!]^4, (i,j)\neq(i',j'), x_{i,j} \neq x_{i',j'}$
	- $\forall i \in [\\![0,3]\\!], k = \frac{i}{2}, \ell = i \mod 2,$
$x_{k,\ell} + x_{k + 1,\ell} + x_{k,\ell + 1} + x_{k + 1,\ell +1} = S_i$
 	- \+clues

--- 

{{< slide background="#76bde8"  >}}

### Hints

```java
model.allDifferent(IntVar[])
model.sum(IntVar[], String, int)
model.arithm(IntVar, String, int)
```

```java
int[] circles = new int[]{10, 21, 18, 20};
int[] clues = new int[]{0, 0, 0, 0, 0, 0, 8, 0, 7};
```

```java
private IntVar[] quadrant(IntVar[][] grid, int i) {
	int x = i / 2;
	int y = i % 2;
	return new IntVar[]{grid[x][y], grid[x + 1][y], grid[x][y + 1], grid[x + 1][y + 1]};
}
```

--- 

{{< slide background="#76bde8"  >}}

### A Choco-solver code

```java
Model model = new Model("Sujiko");

IntVar[][] grid = model.intVarMatrix("x", 3, 3, 1, 9);

// Constraint: "The numbers 1-9 must be placed in the grid"
// implies that all values must be different
model.allDifferent(ArrayUtils.flatten(grid)).post();

// Constraint: "each quadrant which indicate the sum of the four numbers in that quadrant"
for (int i = 0; i < 4; i++) {
	IntVar[] cells = quadrant(grid, i);
	model.sum(cells, "=", circles[i]).post();
}

// Constraint: "the clues"
for (int i = 0; i < 3; i++) {
	for (int j = 0; j < 3; j++) {
		if (clues[i * 3 + j] != 0) {
			model.arithm(grid[i][j], "=", clues[i * 3 + j]).post();
		}
	}
}

while (model.getSolver().solve()) {
	System.out.println("Solution:");
	for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
			System.out.print(grid[i][j].getValue() + " ");
		}
		System.out.println();
	}
}
if (model.getSolver().getSolutionCount() == 0) {
	System.out.println("No solution found");
}
```

---

{{< slide background="#76bde8"  >}}

### Output

```shell{}
Solution:
1 4 9 
3 2 6 
8 5 7 
 ```



{{% /section %}}
