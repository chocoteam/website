+++
weight = 110
+++

{{% section %}}

# Analogy with Sudoku

---
## We reached the Sudoku point

When trying to explain how constraint programming works, 
it is common to draw a parallel with sudoku.

---
### Modelling

- A cell takes its values in $\[1,9\]$
	- ➡️ a variable and a domain
- Each digit shoudl be used exactly once per {{% calert c="row" %}}, per {{% calert c="column" %}} and per {{% calert c="square" %}}
	- ➡️ sets of $\neq$ constraints
---
### Solving



---

### A 4x4 sudoku example

```python
n = 4
variables = {}
for i in range(1, n + 1):
    for j in range(1, n + 1):
        variables["x" + str(i) + str(j)] = {k for k in range(1, n + 1)}
# fix values
variables["x12"] = [2]
variables["x21"] = [3]
variables["x31"] = [2]
variables["x32"] = [1]
variables["x33"] = [3]
variables["x41"] = [4]
variables["x43"] = [2]

zones = []
# rows
zones.append(["x11", "x12", "x13", "x14"])
zones.append(["x21", "x22", "x23", "x24"])
zones.append(["x31", "x32", "x33", "x34"])
zones.append(["x41", "x42", "x43", "x44"])
# columns
zones.append(["x11", "x21", "x31", "x41"])
zones.append(["x12", "x22", "x32", "x42"])
zones.append(["x13", "x23", "x33", "x43"])
zones.append(["x14", "x24", "x34", "x44"])
# square
zones.append(["x11", "x12", "x21", "x22"])
zones.append(["x13", "x14", "x23", "x24"])
zones.append(["x31", "x32", "x41", "x42"])
zones.append(["x33", "x34", "x43", "x44"])

cs = []
for z in zones:
    for j in range(0, n):
        for k in range(j + 1, n):
            cs.append(NotEqual(z[j], z[k]))

print("it finds", enumerate(variables, cs), "solutions")
```


{{% /section %}}