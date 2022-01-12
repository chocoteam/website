+++
weight = 80
+++

{{% section %}}

# Many constraints
of the same type

```python
variables = {"x1": {1, 2, 3},
             "x2": {1, 2, 3},
             "x3": {1, 2, 3}}
c1 = LessThan("x1", "x2")
c2 = LessThan("x2", "x3")
```

---

We will create a method to iterate on the constraints:

```python
def fix_point(variables, constraints):
    for c in constraints:
        if c.filter(variables) is False:
            return False
    return True
```

---
A call to this method will replace the first line of the `enumerate(_,_)` function:

```python
def enumerate(variables, constraints):
    # if constraint.filter(variables) is False:
    if not fix_point(variables, constraints):
        return 0 # at least one constraint is not satisfied
    # ...        
```

--- 


```python
variables = {"x1": {1, 2, 3},
             "x2": {1, 2, 3},
             "x3": {1, 2, 3}}
c1 = LessThan("x1", "x2")
c2 = LessThan("x2", "x3")
print("it finds", enumerate(variables, {c1, c2}), "solutions")
```
outputs:
```
{'x1': [1], 'x2': [2], 'x3': [3]}
it finds 1 solutions
```

--- 

### Does `fix_point(_,_)` work properly?

```python
variables = {"x1": {1, 2, 3},
             "x2": {1, 2, 3},
             "x3": {1, 2, 3}}
c1 = LessThan("x1", "x2")
c2 = LessThan("x2", "x3")
fix_point(variables, {c1, c2})
print(variables)
```
goes:
```
{'x1': [1, 2], 'x2': [2], 'x3': [3]}
```
### <p class="fragment">No, it doesn't</p>

---
Indeed:
1. `c1` is called first and bounds `"x1"` and `"x2"`,
2. `c2` is called and bounds `"x2"` and  `"x3"`,
3. and the loops ends.

But `c1` wasn't _informed_ that `"x2"` was modified by `c2`.

---

So, as long as a constraint filters values,</br>
<b><u>all</u></b> the other ones must be checked.

</br>
<p class="fragment">
<small>💡 This could be refined.</small>
</p>

---

```python
def fix_point(variables, constraints):
    while True:
        fltrs = False
        for c in constraints:
            flt = c.filter(variables)
            if flt is False: # in case of failure
                return False
            elif flt is True: # in case of filtering
                fltrs |= True # keep on looping 
        if not fltrs : # to break the while-loop
            return True
```
---
```python [1-2|3|4]
variables = {"x1": {1, 2, 3},
             "x2": {1, 2, 3},
             "x3": {1, 2, 3}}
c1 = LessThan("x1", "x2")
c2 = LessThan("x2", "x3")
fix_point(variables, {c1, c2})
print(variables)
```
now prints:
```
{'x1': [1], 'x2': [2], 'x3': [3]}
```

{{% /section %}}
