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
<p class="fragment">2. if $X_1$ is instantied to $v_1$, </br>then $v_1-c$ must be removed from $X_2$ values.</p>


---
### Let's fix the code
```python{}

  class NotEqual:
      def __init__(self, v1, v2, c=0):
          pass

      def filter(self, vars):
          pass
```


<h2><a href="https://moodle.caseine.org/mod/vpl/view.php?id=71050"> >>🥛<<</a></h2>

<!--</section> to bind to the next section tag-->

---

### The `NotEqual` class
```python{1-5|6-8|9-14|15-20|21-22}
class NotEqual:
    def __init__(self, v1, v2, c=0):
        self.v1 = v1
        self.v2 = v2
        self.c = c

    def filter(self, vars):
      size = len(vars[self.v1]) + len(vars[self.v2])
      if len(vars[self.v2]) == 1:
          f = min(vars[self.v2]) + self.c
          nd1 = {v for v in vars[self.v1] if v != f}
          if len(nd1) == 0:
            return False
          vars[self.v1] = nd1
      if len(vars[self.v1]) == 1:
          f = min(vars[self.v1]) - self.c
          nd2 = {v for v in vars[self.v2] if v != f}
          if len(nd2) == 0:
            return False
          vars[self.v2] = nd2
      modif = size > len(vars[self.v1]) + len(vars[self.v2])
      return modif or None
```

---

{{< slide id="imp7" background="#b4c6d0" >}}

## :rocket: Constraints

- Different level of inconsistency
- Global reasoning vs decomposition
- Explain domain modifications
- Reification, entailment, ...

{{% /section %}}
