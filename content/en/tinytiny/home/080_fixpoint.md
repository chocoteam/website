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
We need to adapt the `dfs(_,_)` function:

```python{2-4}
def dfs(variables, constraints):
    # if constraint.filter(variables) is False:
    if not fix_point(variables, constraints):
        return 0 # at least one constraint is not satisfied
    # ...        
```

and ensure that a {{% calert c="fix point"%}} is reached.

---

## Fixpoint reasoning

Iteratively applying constraint propagation until
</br>no more improvements are possible
</br> or a failure is detected.

So, as long as a constraint filters values,</br>
<b><u>all</u></b> the other ones must be checked.

<small>:rocket: This could be refined.</small>


---

<table>
          <thead>
            <tr>
              <th>step</th>
              <th>x1</th>
              <th>x2</th>
              <th>x3</th>
              <th>To check</th>
              <th>Consistent</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>0</td>
              <td>[1,3]</td>
              <td>[1,3]</td>
              <td>[1,3]</td>
              <td>{c1,c2}</td>
              <td>{}</td>
            </tr>
            <tr class="fragment">
              <td>1</td>
              <td>[1,<span style="color:#3BAFDA">2</span>]</td>
              <td>[<span style="color:#3BAFDA">2</span>,3]</td>
              <td>-</td>
              <td>{<span style="color:#3BAFDA">c1</span>,c2}</td>
              <td>{}</td>
            </tr>
            <tr class="fragment">
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td>{c2}</td>
              <td>{<span style="color:#3BAFDA">c1</span>}</td>
            </tr>
            <tr class="fragment">
              <td>2</td>
              <td>-</td>
              <td>[2,<span style="color:#3BAFDA">2</span>]</td>
              <td>[<span style="color:#3BAFDA">3</span>,3]</td>
              <td>{<span style="color:#3BAFDA">c2</span>}</td>
              <td>{c1}</td>
            </tr>
            <tr class="fragment">
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td>{<span style="color:#ED5565">c1</span>}</td>
              <td>{<span style="color:#3BAFDA">c2</span>}</td>
            </tr>
            <tr class="fragment">
              <td>3</td>
              <td>[1,<span style="color:#3BAFDA">1</span>]</td>
              <td>-</td>
              <td>-</td>
              <td>{<span style="color:#3BAFDA">c1</span>}</td>
              <td>{c2}</td>
            </tr>
            <tr class="fragment">
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td>{<span style="color:#ED5565">c2</span>}</td>
              <td>{<span style="color:#3BAFDA">c1</span>}</td>
            </tr>
            <tr class="fragment">
              <td>4</td>
              <td>-</td>
              <td>-</td>
              <td>-</td>
              <td>{<span style="color:#3BAFDA">c2</span>}</td>
              <td>{c1}</td>
            </tr>
            <tr class="fragment">
              <td></td>
              <td></td>
              <td></td>
              <td></td>
              <td>{}</td>
              <td>{<span style="color:#3BAFDA">c1, c2</span>}</td>
            </tr>
          </tbody>
        </table>

---


We will create a method to iterate on the constraints:

```python
def fix_point(variables, constraints):
    """Reach a fix point.
    If a failure is raised, returns False,
    otherwise guarantees that all events are propagated.
    """
```


<h2><a href="https://moodle.caseine.org/mod/vpl/view.php?id=69914" target="_blank" rel="noopener noreferrer"> >>🥛<<</a></h2>



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
outputs:
```
{'x1': [1], 'x2': [2], 'x3': [3]}
```

---

{{< slide id="imp6" background="#b4c6d0" >}}

## :rocket: Propagation engine

- Event-based reasoning, advisors, watch literals
- Scheduling and propagating
- Variable-oriented or Constraint-oriented
- Iterating on constraints by considering their complexity

{{% /section %}}
