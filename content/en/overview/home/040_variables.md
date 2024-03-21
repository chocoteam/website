+++
weight = 40
+++

{{% section %}}

# Variables and domains

---


<section data-noprocess >
<h2>A variable </h2>
<ul>
<li class="fragment">is a symbolic representation of an <span style="color:deepskyblue;">unknown</span> quantity/decision,</li>
<li class="fragment">comes with potential values that the solver can assign to it, a.k.a. its <span style="color:deepskyblue;">domain</span>,</li>
<li class="fragment">to be determined/<span style="color:deepskyblue;">assigned</span> during the problem-solving process.</li>
</ul>


<!--</section> to bind to the next section tag-->

---

### In a scheduling problem
- {{% calert c="Variables" %}} :  the start time of various tasks
- {{% calert c="Domains" %}} : the set of possible start time slots

<figure>
    <img src="/images/overview/scheduling.svg" alt="This is an alt" width="40%" >
</figure>

---

### In a packing problem
- {{% calert c="Variables" %}} : the assignment of items to bins
- {{% calert c="Domains" %}} : the set of possible bins

<figure>
    <img src="/images/overview/binpacking.svg" alt="" width="20%" >
</figure>

---

### In a routing problem
- {{% calert c="Variables" %}} : the nodes visited on a tour
- {{% calert c="Domains" %}} : the potential successors of each node

<figure>
    <img src="/images/overview/routing.svg" alt="" width="30%" >
</figure>

---

### Different types of variables are available:

- {{% ccode c="IntVar" %}} has its values in $\mathbb{Z}^1$
- {{% ccode c="IntView" %}}s relies on an {{% ccode c="IntVar" %}}
  - like {{% ccode c="IntAffineView" %}}
- {{% ccode c="BoolVar" %}} (and {{% ccode c="BoolView" %}}) has its values in {$0,1$}
	- sub-type of {{% ccode c="IntVar" %}}

</br>
</br>
<small>$1$ : But it is always necessary to declare at least an interval.</small>


---

- {{% ccode c="Task" %}} to manage with task/interval: $s+d = e$
- {{% ccode c="SetVar" %}} and {{% ccode c="SetView" %}}
- {{% ccode c="(Un)DirectedGraphVar" %}} and  {{% ccode c="GraphView" %}}
- and also {{% ccode c="RealVar" %}}

---

### Ways to declare integer variables

```java{|2-3|4|5}
Model m = new Model();
IntVar x = m.intVar("x", 0, 4);
IntVar y = m.intVar("y", new int[]{1,3,5});
IntVar[] vs = m.intVarArray("v", 4, 1, 3);
IntVar[][] ws = m.intVarMatrix("w", 2, 2, 1, 2);
```

---

### Ways to declare Boolean variables

```java{|2-3|4}
Model m = new Model();
BoolVar b = m.boolVar("b");
BoolVar[] bs = m.boolVarArray("bs", 10);
BoolVar[][] bss = m.boolVarMatrix("bss", 4, 3);
```

Similar APIs for other types of variables.

---

### Some views declaration

```java{|3|4|5}
Model m = new Model();                        
IntVar x = m.intVar("x", 0, 5);               
IntVar v = m.intView(2, x, -3); // v = 2.x - 3
BoolVar b = m.isEq(x, 2); // b = (x == 2)     
BoolVar n = b.not(); // n = !b    
```

</br>

<small>And also {{% ccode c="abs(x), mu(x, 2), neg(x), isLeq(x, 3)," %}} ...</small>

---

### Reading a variable


```java{|4|6}
Model m = new Model();                                    
IntVar x = m.intVar("x", 0, 4);                           
System.out.printf("Variable : %s = [%d, %d]\n",           
        x.getName(), x.getLB(), x.getUB());               
System.out.printf("%s is %s instantiated\n",              
        x.getName(), x.isInstantiated() ? "" : "not");   
```

outputs
```shell{}
Variable : x = [0, 4]
x is not instantiated   
```

{{% fragment %}} If instantiated, a variable can return its assignment value with `x.getValue()`. {{% /fragment %}}


---

{{< slide background="#76bde8"  >}}

###  ABCDE x 4 = EDCBA

<h2><a href="https://moodle.caseine.org/mod/vpl/view.php?id=68997" target="_blank" rel="noopener noreferrer"> >>🥛<<</a></h2>


<small>_This clickable logo indicates that a workshop is available at [Caseine](https://moodle.caseine.org/)_ </small>

---

{{< slide background="#76bde8"  >}}

###  Can you guess his year of birth?

<h2><a href="https://moodle.caseine.org/mod/vpl/view.php?id=69633" target="_blank" rel="noopener noreferrer"> >>🥛<<</a></h2>




{{% /section %}}
