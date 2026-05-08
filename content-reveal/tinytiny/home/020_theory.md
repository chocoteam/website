+++
weight = 20
+++

{{% section %}}

# A little bit of theory

---

We are talking about {{% calert c = "Constraint Satisfaction Problem" %}}.

A CSP $\mathcal{P}$ is a triple $\left<\mathcal{X},\mathcal{D},\mathcal{C}\right>$
where:
- $\mathcal{X} = \\{X_1, \ldots, X_n\\}$ is a set of variables,
- $\mathcal{D}$ is a function associating a domain to each variable,
- $\mathcal{C}$ is a set of constraints.

_It can be turn into a COP quite easily_

---

{{< slide id="ex1" background="#C6D0B4" >}}

Let's consider the following CSP $\mathcal{P}$:
- $\mathcal{X} = \\{X_1, X_2, X_3\\}$
- $\mathcal{D} = \\{D(X_1)=D(X_2)=[1,2], D(X_3)=[1,3]\\}$
- $\mathcal{C} = \\{X_1\leq X_2,X_2\leq X_3,AtMost(1,[X_1, X_2, X_3],2)\\}$

---

A constraint defines a {{% calert c="relation between variables." %}}

It is said to be {{% calert c="satisfied" %}} if :
- its variables are _instantiated_ to a single value*
- and the relation holds 

</br>
</br>
*: $x_{i_k} \in \mathcal{D}(X_{i_k})$

---

{{< slide id="ex2" background="#C6D0B4" >}}

In $\mathcal{P}$, the constraint $AtMost(1,[X_1, X_2, X_3],2)$ holds iff <u>at most</u> 1 variable among $X_1, X_2, X_3$ is assigned to the value 2.

- $(1,1,1)$ and $(1,2,3)$ satisfy the constraint,
- $(2,2,1)$ does not. 

---

The constraints can be defined in {{% calert c ="intension" %}} or in {{% calert c ="extension" %}}.

For $X_1$, $X_2$ on domains $\\{1,2\\}$:
- intension: 
	- expression in a higher level language
	- _e.g._, $X_1+X_2\le3$
- extension: 
	- allowed combinations
	- _e.g._, $\{(1,1),(1,2),(2,1)\}$

---

## Less formally
---

What we know about a {{% calert c="variable" %}} is that :
- it takes its values from a {{% calert c="domain" %}}*, _e.g._, `{1,2,3,5}`, 
- it is linked to other variables using {{% calert c="constraints" %}}, 
- and it must be _instantiated_ in a {{% calert c="solution" %}}.

</br>
</br>
*: discrete domain in our case.

---

On the other hand, a {{% calert c="constraint" %}} :
- defines a {{% calert c="contract" %}} between its variables,
- must be {{% calert c="satisfied" %}} in every solutions,
- and is more than just a checker.

---

Choose your favourite programming language 

(I chose [Python](https://www.python.org/))

# and let's get started

{{% /section %}}