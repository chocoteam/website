+++
weight = 70
+++


{{% section %}}

# Back to work
## deal with failures

---
### Let's fix the code
```python{}

def dfs(variables, constraint):
    # manage filtering failure
```


<h2><a href="https://moodle.caseine.org/mod/vpl/view.php?id=69913"> >>🥛<<</a></h2>

---

### Let's fix the code

```python{2-3|}
def dfs(variables, constraint):
    if constraint.filter(variables) is False:
        return 0
    var, val = make_decision(variables)
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
### This code

```python
variables = {"x1": {3, 4},
             "x2": {2, 3}}
c1 = LessThan("x1", "x2")

print("There are", dfs(variables, c1), "solutions")
```
outputs:
```
There are 0 solutions
```

---

{{< slide id="imp4" background="#b4c6d0" >}}

## :rocket: Possible improvements

- Explaining failures (LCG)
- Adapting the research strategy:
  - dom/wdeg, pick-on-dom, ABS, etc
  - last conflict, COS

{{% /section %}}
