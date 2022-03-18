+++
weight = 90
+++


{{% section %}}

# Many constraints
of the different type

---

## Adding the constraint 

### $X_1\neq X_2 + c$
where $c$ is a constant
## should be quite easy

{{% fragment %}}It requires to define the `filter` function. {{% /fragment %}}

---

<section data-noprocess>
<h2>The 2 rules of $X_1\neq X_2 + c$</h2>
<p class="fragment">1. if $X_2$ is instantied to $v_2$, </br>then $v_2+c$ must be removed from $X_1$ values,</p>
<p class="fragment">2. if $X_1$ is instantied to $v_1$, </br>then $v_1-c$ must be removed from $X_1$ values.</p>


<!--</section> to bind to the next section tag-->

---

### The `NotEqual` class
```python{1-5|7-9|11-13|14-16|18,19|10,17,20}
class NotEqual:
    def __init__(self, v1, v2, c=0):
        self.v1 = v1
        self.v2 = v2
        self.c = c

    def filter(self, vars):
        d1 = vars[self.v1]
        d2 = vars[self.v2]
        size = len(d1) + len(d2)
        if len(d2) == 1:
            d1 = [v for v in d1 if v != (d2[0] + self.c)]
            if len(d1) == 0: return False
        if len(d1) == 1:
            d2 = [v for v in d2 if v != (d1[0] - self.c)]
            if len(d2) == 0: return False
        size -= (len(d1) + len(d2))
        vars[self.v1] = d1
        vars[self.v2] = d2
        return size > 0 or None
```

{{% /section %}}