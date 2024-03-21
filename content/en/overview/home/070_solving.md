+++
weight = 70
+++

{{% section %}}

# Solving

---

{{< slide id="code3" transition="none-out" >}}

## CSP

<small>The solving process is managed by a unique {{% ccode c="Solver" %}} instance attached to a {{% ccode c="model" %}}.</small>

```java{|5-6}
Model model = new Model();

// ... problem description ...

Solver solver = model.getSolver();
if(solver.solve()){
	// here you can read the variables' value
	System.out.printf("%s is fixed to %d\n",
						x.getName(), x.getValue());
}
```

A call to {{% ccode c="solver.solve()" %}} returns {{% ccode c="true" %}} if a solution exists, {{% ccode c="false" %}} otherwise.


---

{{< slide id="code4" transition="in-out" >}}

## CSP

<small>The solving process is managed by a unique {{% ccode c="Solver" %}} instance attached to a {{% ccode c="model" %}}.</small>

```java{7-9}
Model model = new Model();

// ... problem description ...

Solver solver = model.getSolver();
if(solver.solve()){
	// here you can read the variables' value
	System.out.printf("%s is fixed to %d\n",
						x.getName(), x.getValue());
}
```


Since the {{% ccode c="solver" %}} stops on a solution,
<br/>
all the variables are fixed and their value can be read.



---

{{< slide id="code5" transition="none-in" >}}

## CSP

<small>The solving process is managed by a unique {{% ccode c="Solver" %}} instance attached to a {{% ccode c="model" %}}.</small>

```java{6}
Model model = new Model();

// ... problem description ...

Solver solver = model.getSolver();
while(solver.solve()){
	// here you can read the variables' value
	System.out.printf("%s is fixed to %d\n",
						x.getName(), x.getValue());
}
```

Enumerating solutions can be done in a {{% ccode c="while-loop" %}}.
<br/>
<br/>


---


{{< slide id="code6" transition="none-out" >}}

## Solution

We can capture the current state of variables in a {{% ccode c="Solution" %}}.

```java{1,3}
List<Solution> solutions = new ArrayList<>();
while(solver.solve()){
	solutions.add(new Solution(model).record());
}
```

---

{{< slide id="code7" transition="none-in" >}}

## Solution

This can also be achieved in one line of code
<br/>

```java
Solution solution = solver.findSolution();
```
```java
List<Solution> solutions = solver.findAllSolutions();
```
<br/>

---
## COP

An {{% ccode c="IntVar" %}} to maximize/minimize    .

```java{1|2}
Solution bSol = solver.findOptimalSolution(obj, maximize);
List<Solution> bSols = solver.findAllOptimalSolutions(obj, max);
```

---

## Solving is reducing

---

### Backtracking algorithm
- recursive traversal of the search tree
- make/cancel decisions
- backtrack on failure
- incremental construction of a solution

_Branch and Propagate_

---

![Alt text.](/images/tinytiny/filtering/bintree.svg)

:warning: 2-way branching

---

## Making decisions

<p class="fragment" data-fragment-index="1"><em>Can't we just leave it to the solver?</em></p>

<p class="fragment" data-fragment-index="2">Bring business knowledge</p>
<p class="fragment" data-fragment-index="3">Help moving towards a solution</p>
<!--<p class="fragment" data-fragment-index="4">or proving unsat</p>-->

{{% fragment %}} _but Yes, we can_ {{% /fragment %}}

---

## Making decisions

- choose a free variable (how?)
- select an operator (very often $=$)
- determine a value (how?)

Continue as as long as necessary

{{% note %}}
A decision is validated through propagation
{{% \note %}}



---

### Select the next variable

- `input_order`, `first_fail`, `smallest`,...
- `dom/wdeg`, `FBA`, `CHS`, `ABS`, ...

<br/>
<br/>

### Choose a value

- `min`, `max`, `med`, ...

---

## Topping

- Combining searches
- Restarting: `geo`, `luby`
- Meta-strategy: `lc`, `cos`
- Phase saving,
- Best

---

### Define your own

```java{}
solver.setSearch(Search.intVarSearch(
    variables -> Arrays.stream(variables)
          .filter(v -> !v.isInstantiated())
          .min((v1, v2) -> closest(v2, map) - closest(v1, map))
          .orElse(null),
    v -> closest(v, map),
    DecisionOperator.int_eq,
    planes
));
```
[[aircraft landing]](https://choco-solver.org/tutos/aircraft-landing-problem/code/)


---

## Turnkey enumeration strategies

```java{2,4|3|5-6|7|}
// Override the default search strategy
solver.setSearch(
	Search.lastConflict(
		Search.domOverWDegSearch(vars)));
// possibly combined with restarts
solver.setLubyRestart(2, new FailCounter(model, 2), 25000);
solver.findSolution();
```
Have a look at the {{%ccode c="Search" %}} factory.

---

{{< slide background-iframe="https://choco-solver.org/docs/solving/strategies/" >}}

---

# Monitoring

---

## Information on research

It is possible to have insights on the search process

```java
solver.showShortStatistics();
while(solver.solve()){};
```

Or to execute code on solutions using _monitors_:
```java
solver.plugMonitor((IMonitorSolution) () -> {
    // do something here
});
```

---
## Limits

The search space exploration can be limited.

```java
solver.limitTime("10s");
solver.limitSolution(5);
solver.findAllSolutions();
```
The first limit reached stops the search.

---

{{< slide background="#76bde8"  >}}

## Warehouse Location

<h2><a href="https://moodle.caseine.org/mod/vpl/view.php?id=70539" target="_blank" rel="noopener noreferrer"> >>🥛<<</a></h2>



{{% /section %}}
