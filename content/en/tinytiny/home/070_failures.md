+++
weight = 70
+++


{{% section %}}

# Don't panic 
## and tell what's going on

--- 

We can tell that the constraint should return :

- `None` : if nothing was filtered
- `True` : if some values were filtered
- `False` : if a domain becomes empty

--- 
### Let's fix the code (1/2)
```python{4,11,14|6-7,9-10|}
def filter(self, vars):
    d1 = vars[self.v1]
    d2 = vars[self.v2]			
    diff = len(d1) + len(d2) # stores current length
    d1 = [v for v in d1 if v < max(d2)]
    if len(d1) == 0: # "x1" becomes empty...
        return False
    d2 = [v for v in d2 if v > min(d1)]
    if len(d2) == 0: # "x2" becomes empty...
        return False
    diff -= len(d1) + len(d2) # difference in length
    vars[self.v1] = d1
    vars[self.v2] = d2	
    return diff > 0 or None # reduction of a domain or ...
```

---

### Let's fix the code (2/2)

```python{2-3|}
def enumerate(variables, constraint):
    if constraint.filter(variables) is False:
        return 0
    var, val = select_decision(variables)
    if var is None:
        print(variables)
        return 1
    else:
        n = propagate(variables, var, val, True, constraint)
        n += propagate(variables, var, val, False, constraint)
        return n

```
`None` and `True` will be used later.

---
### It's fine

```python
variables = {"x1": {3, 4},
             "x2": {2, 3}}
c1 = LessThan("x1", "x2")

print("it finds", enumerate(variables, c1), "solutions")
```
outputs:
```
it finds 0 solutions
```

{{% /section %}}