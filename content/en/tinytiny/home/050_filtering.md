+++
weight = 50
+++

{{% section %}}

# Filtering is not enough

---

It didn't build a solution
{{% fragment %}}although all impossible values were removed{{% /fragment %}}

---

It seems that we need to dive into the
### search space 🤿

in a DFS way.



---

## Adapting the DFS

- If all variables are fixed, stop the search
- If inconsistency detected, then {{% warn c="backtrack" %}}
- Expand the tree by making a {{% warn c="decision$^*$" %}}

</br>
</br>
<small>*: 2-way branching</small>

{{% note %}}
- Expand the tree = create a decision or refute the last one
- Two way decision = more flexible but n-way possible
{{% /note %}}

---

![Alt text.](/images/tinytiny/filtering/bintree.svg)

{{% note %}}
The search space can be seen as a tree
where a node corresponds to a decision (here I labeled edge for clarity reason)
and a leaf is either a solution or a dead-end.
{{% /note %}}

---

<section data-noprocess>

<h2>Backtracking</h2

For this, we need <span style="color:deepskyblue;">to retrieve the state of the domains</span> before a decision is applied.

<span class="fragment">And therefore it must have been registered beforehand.</span>

<span class="fragment">And we must be able to rebut a decision.</span>

---

## Search strategy

How to select the next decision to apply?

```AsciiDoc{1|2|3|}
select an uninstantiated variable
pick a value in its domain (e.g., the lower bound)
```

---

### A recursive approach should simplify our task
Let's break down the needs into 4 functions.


```python
def make_decision(variables):``
    pass

def copy_domains(variables):
    pass

def apply_decision(variables, var, val, apply, constraint):
    pass

def enumerate(variables, constraint):
    pass
```

<h2><a href="https://moodle.caseine.org/mod/vpl/view.php?id=69653" target="_blank" rel="noopener noreferrer"> >>🥛<<</a></h2>


---

```python{1|2|3|4-6|7-10|11|}
def dfs(variables, constraint):
  constraint.filter(variables)
  dec = make_decision(variables)
  if dec is None:
      print(variables)  # prints the solution
      return 1
  else:
      var, val = dec
      n = apply_decision(variables, var, val, True, constraint)
      n += apply_decision(variables, var, val, False, constraint)
  return n
```

---

```python{2-4|5-7|8-10}
def make_decision(variables):
    var, dom = next(
        filter(lambda x: len(x[1]) > 1, variables.items()),
        (None, None))
    if var is not None:
        # if true, returns the decision
        return (var, min(dom))
    else:
        # otherwise, all variables are instantiated
        return None
```


---

```python{}
def copy_domains(variables):
    # returns a deep copy of the dictionnary
    return {var: dom.copy() for var, dom in variables.items()}
```

---


```python{1|2-3|4-6|7-8|}
def apply_decision(variables, var, val, apply, constraint):
  # copy the domains
  c_variables = copy_domains(variables)
  # applies the decision or rebuts is
  c_variables[var] = {x for x in c_variables[var] \
                      if apply is (x == val)}
  # explore the sub-branch
  return dfs(c_variables, constraint)
```



---


```python
variables = {"x1": {1, 2, 3},
             "x2": {1, 2, 3}}
c1 = LessThan("x1", "x2")

print("There are", dfs(variables, c1), "solutions")
```
should output:
```
{'x1': {1}, 'x2': {2}}
{'x1': {1}, 'x2': {3}}
{'x1': {2}, 'x2': {3}}
There are 3 solutions
```

---

# We did it !

Well almost, but still you can pat yourself back !


---

{{< slide id="imp2" background="#b4c6d0" >}}

## :rocket: Managing backups

<small>📄"Comparing trailing and copying for constraint programming", C. Schulte, ICLP'99.</small>

- **Copying**: An identical copy of S is created before S is changed.
- **Trailing**: Changes to S are recorded such that they can be undone later.
- **Recomputation**: If needed, S is recomputed from scratch.
- **Adaptive recomputation**: Compromise between Copying and Recomputation.



---

{{< slide id="imp3" background="#b4c6d0" >}}

## :rocket: Making decisions

- Dynamic criteria for variable selection
- And value selection (_min_, _max_, _mid_, _rnd_)
- Different operators ($=, \neq, \leq, \geq$)
- Depth-first, limited-discrepancy, large neighborhood  



{{% /section %}}
