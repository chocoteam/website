+++
weight = 40
+++

{{% section %}}
# Constraints



### $X_1 < X_2$  

{{% note %}}
Let's roll up our sleeves and tackle the case of the binary _"strictly less"_ constraint:
{{% /note %}}

---

{{< slide id="ex3" background="#C6D0B4" >}}

Such a constraint will take {{% calert c="two variables" %}} as argument and makes sure that the former one takes a value less than the latter one in any solution.

{{% fragment %}}$(1,2)$ and $(2,5)$ satisfy the constraint,{{% /fragment %}}
{{% fragment %}}$(2,2)$ and $(5,3)$ do not.{{% /fragment %}}

---

We will first create a class to declare the behaviour of this constraint:

```python{1|2-4}
class LessThan:
    def __init__(self, v1, v2):
        self.v1 = v1
        self.v2 = v2
```

---

We can impose that $X_1$ is strictly less than $X_2$:

```python{3|}
variables = {"x1": {1, 2, 3},
             "x2": {1, 2, 3}}
c1 = LessThan("x1", "x2") # means that x1 < x2 should hold
```

{{% note %}}
After doing that we didn't do much...
{{% /note %}}

---

##  What can such a constraint do?

---
### In CP, we remove

The basic behaviour of a constraint is to remove from the variable domain those values {{% calert c="that cannot be extended" %}} to any solution

(_according to its own contract_)

---

We will create an empty function called `filter` as follow:

```python
def filter(self,variables):
	pass
```

---

<section data-noprocess>
<h2>The 2 rules of $X_1 < X_2$</h2>
<p class="fragment">1. removing from $X_1$ values <span style="color:deepskyblue;">greater or equal to the largest value</span> in $X_2$,</p>
<p class="fragment">2. removing from $X_2$ values <span style="color:deepskyblue;">smaller or equal to the smallest value</span> in $X_1$.</p>

<p class="fragment">Otherwise, in both cases, we could break the contract established between the 2 variables.</p>

<!--</section> to bind to the next section tag-->

---
{{< slide id="ex4" background="#C6D0B4" >}}

$X_1 = \\{1,2,3,4\\}$, $X_2 = \\{1,2,3,4\\}$ and $X_1 < X_2$

Then
- 4 is removed from $X_1$
- 1 is removed from $X_2$

---
{{< slide id="ex4" background="#C6D0B4" >}}

In other words:

- $max(X_2)$ and larger are removed from $X_1$
- $min(X_1)$ and smaller are removed from $X_2$

---
## Deal with dead ends

We can tell that the constraint should return :

- `True` : if some values were filtered
- `False` : if a domain becomes empty
- `None` : if nothing was filtered

---

### `LessThan` filtering algorithm

```python{}
class LessThan:
    def __init__(self, v1, v2):
        self.v1 = v1
        self.v2 = v2

    def filter(self, variables):
        """
        Filter the domain of the variables declared in 'vars'.
        The method directly modifies the entries of 'vars'.
        It returns True if some values were filtered,
        False if a domain becomes empty,
        None otherwise.
        """
        pass

```

<h2><a href="https://moodle.caseine.org/mod/vpl/view.php?id=69645"> >>🥛<<</a></h2>


---
### `LessThan` filtering algorithm
```python{|2-3|4-7|8-11|12-13|14-15}
def filter(self, variables):
    cd1 = variables[self.v1] # get current domain of "x1"
    cd2 = variables[self.v2] # get current domain of "x2"
    # filtering according to the 1st rule
    nd1 = {v for v in cd1 if v < max(cd2)}
    if len(nd1) == 0: # "x1" becomes empty...
        return False
    # filtering according to the 2nd rule
    nd2 = {v for v in cd2 if v > min(cd1)}
    if len(nd2) == 0: # "x2" becomes empty...
        return False
    variables[self.v1] = nd1 # update the domain of "x1"
    variables[self.v2] = nd2 # update the domain of "x2"
    modif = cd1 > nd1 or cd2 > nd2 # reduction of a domain
    return modif or None
```

---

### Does that work?

```python{1-10|1-4|5-6|7-10}
# declare a CSP
variables = {"x1": {1, 2, 3},
             "x2": {1, 2, 3}}
c1 = LessThan("x1", "x2")
# call the filtering algorithm
modif = c1.filter(variables)
# check everything works fine
assert variables["x1"] == {1, 2}
assert variables["x2"] == {2, 3}
assert modif == True
```

---

### Yes, it does !



{{% /section %}}
