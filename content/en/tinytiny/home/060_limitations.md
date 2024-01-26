+++
weight = 60
+++


{{% section %}}

# What are the _obvious_ limitations?
(of what we've done so far)

---

It panics when the problem has no solution.

```python
variables = {"x1": {3, 4},
             "x2": {2, 3}}
c1 = LessThan("x1", "x2")
print("it finds", enumerate(variables, c1), "solutions")
```

```python{}
Traceback (most recent call last):
  File "sandbox.py", line 54, in <module>
    print("it finds", enumerate(variables, c1), "solutions")
  File "sandbox.py", line 40, in enumerate
    constraint.filter(variables)
  File "sandbox.py", line 10, in filter
    d2 = [v for v in d2 if v > min(d1)]
  File "sandbox.py", line 10, in <listcomp>
    d2 = [v for v in d2 if v > min(d1)]
ValueError: min() arg is an empty sequence
```
---

It deals with a single constraint.

And 2 variables.

{{% /section %}}