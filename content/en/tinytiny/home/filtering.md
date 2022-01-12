+++
weight = 50
+++

{{% section %}}

# Filtering is not enough

---

Indeed, we remove impossible values
{{% fragment %}}but no variable is <u>instantiated</u>.{{% /fragment %}} 

{{% fragment %}}And we can't do more filtering.{{% /fragment %}}

---

It seems that we need to dive into the 
### search space 🤿

---

Since we need variables to take <u>single value</u>, we can:

```AsciiDoc{1|2|3|4|5}
select an uninstantiated variable (e.g., the first)
pick a value in its domain (e.g., the lowest bound)
fix the selected variable to the selected value
and see what is going on !
```



---

We created our first **decision**!

{{% fragment %}} Wait, one decision may not be enough...{{% /fragment %}}

{{% fragment %}}... but still, we defined an _enumeration strategy_ 🥳{{% /fragment %}}

---

```python{3-9|3|4-5|5-7|8-9|10-12}
# ...
c1.filter(variables)
for v, d in variables.items():
    # if one variable is not *instantiated* yet
    if len(d) > 1:
    	# then fix it to its lower bound
        variables[v] = {min(d)}
        # and filter
        c1.filter(variables)
# check everything is fine        
assert variables["x1"] == [1]
assert variables["x2"] == [2]
```

---

## What if...
we want to find another solution?

Or enumerate all solutions?

---
<section data-noprocess>

For this, we need <span style="color:deepskyblue;">to retrieve the state of the domains</span> before a decision is applied.

<span class="fragment">And therefore it must have been registered beforehand.</span>

<span class="fragment">And we must be able to rebut a decision.</span>

---

![Alt text.](/images/tinytiny/filtering/bintree.svg)

---

### A recursive approach should simplify our task
Let's break down the needs into 4 functions.

---

```python{1|2-4|5-7|9-10|1-10}
def create_decision(variables):
    # find a variable with at least two values in its domain
    var, dom = next(filter(lambda x: len(x[1]) > 1, \
			variables.items()), (None, None))
    if var is not None:
        # it true, returns the decision
        return var, min(dom)
    else:
        # otherwise, all variables are instantiated
        return None, None
```

--- 

```python{}
def copy_domains(variables):
    # returns a deep copy of the dictionnary
    return {var: dom.copy() for var, dom in variables.items()}
```

--- 


```python{1|2-3|4-6|7|}
def propagate(variables, var, val, apply, constraint):
    # makes a backup of the variables
    c_variables = copy_domains(variables)
    # applies the decision or rebuts is
    c_variables[var] = [x for x in c_variables[var] \
				if apply is (x == val)]
    return enumerate(c_variables, constraint)
```

--- 

```python{1|2|3|4-6|7-10|}
def enumerate(variables, constraint):
    constraint.filter(variables)
    var, val = create_decision(variables)
    if var is None:
        print(variables) # prints the solution
        return 1
    else:
        n = propagate(variables, var, val, True, constraint)
        n += propagate(variables, var, val, False, constraint)
    return n
```

---

```python
variables = {"x1": {1, 2, 3},
             "x2": {1, 2, 3}}
c1 = LessThan("x1", "x2")

print("it finds", enumerate(variables, c1), "solutions")
```
should output:
```
{'x1': [1], 'x2': [2]}
{'x1': [1], 'x2': [3]}
{'x1': [2], 'x2': [3]}
it finds 3 solutions
```

---

# We did it !

Well almost, but still you can pat yourself back !


{{% /section %}}