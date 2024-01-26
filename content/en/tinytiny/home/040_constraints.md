+++
weight = 40
+++

{{% section %}}
# Constraints

Let's roll up our sleeves and tackle the case of the binary _"strictly less"_ constraint: 

### $X_1 < X_2$  


--- 

{{< slide id="ex3" background="#8CC152" >}}

Such a constraint will take {{% calert c="two variables" %}} as argument and makes sure that the former one takes a value less than the latter one in any solution.

- $(1,2)$ and $(2,5)$ satisfy the constraint,
- $(2,2)$ and $(5,3)$ do not. 

---

We will first create a class to declare the behaviour of this constraint:

```python[1|2-4]
class LessThan:
    def __init__(self, v1, v2):
        self.v1 = v1
        self.v2 = v2
```

---

We can impose that $X_1$ is strictly less than $X_2$:

```python{3}
variables = {"x1": {1, 2, 3},
             "x2": {1, 2, 3}}
c1 = LessThan("x1", "x2") # means that x1 < x2 should hold
```
After doing that we didn't do much...

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
{{< slide id="ex4" background="#8CC152" >}}

$X_1 = \\{1,2,3,4\\}$, $X_2 = \\{1,2,3,4\\}$ and $X_1 < X_2$

Then
- 4 is removed from $X_1$
- 1 is removed from $X_2$

---
{{< slide id="ex4" background="#8CC152" >}}

In other words:

- $max(X_2)$ is removed from $X_1$
- $min(X_1)$ is removed from $X_2$

---
### `LessThan` filtering algorithm
```python{1|2-3|4-5|6-7|8-9|1-9}
def filter(self, variables):
    d1 = variables[self.v1] # get current domain of "x1"
    d2 = variables[self.v2] # get current domain of "x2"
    # filtering according to the 1st rule
    d1 = [v for v in d1 if v < max(d2)] 
    # filtering according to the 2nd rule
    d2 = [v for v in d2 if v > min(d1)]
    variables[self.v1] = d1 # update the domain of "x1"
    variables[self.v2] = d2 # update the domain of "x2"	
```

---

### Does that work? 

```python{1-9|1-4|5-6|7-9}
# declare a CSP
variables = {"x1": {1, 2, 3},
             "x2": {1, 2, 3}}
c1 = LessThan("x1", "x2")
# call the filtering algorithm
c1.filter(variables)
# check everything works fine
assert variables["x1"] == [1, 2]
assert variables["x2"] == [2, 3]
```

<a href="https://colab.research.google.com/drive/1nF0Rf58i4a2uHEIzbVjyWB94uIEUzLL9#scrollTo=h6zZB5EIbytb&line=9&uniqifier=1" target="_blank">Run it</a>

---

### Yes, it does !

{{% /section %}}