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
- Variables :  the start time of various tasks
- Domains : the set of possible start time slots

<figure>
    <img src="/images/overview/scheduling.svg" alt="This is an alt" width="40%" >
</figure>

--- 

### In a packing problem
- Variables : the assignment of items to bins
- Domains : the set of possible bins

<figure>
    <img src="/images/overview/binpacking.svg" alt="" width="20%" >
</figure>

--- 

### In a routing problem
- Variables :  the start time of various tasks
- Domains : the set of possible start time slots

<figure>
    <img src="/images/overview/routing.svg" alt="" width="30%" >
</figure>

--- 

### Different types of variables are available:

- {{% ccode c="IntVar" %}} has its values in $\mathbb{Z}^1$
- {{% ccode c="IntView" %}}s relies on an {{% ccode c="IntVar" %}}, like {{% ccode c="IntAffineView" %}}
- {{% ccode c="BoolVar" %}} ({{% ccode c="BoolView" %}}) has its values in {$0,1$}
	- sub-type of {{% ccode c="IntVar" %}}

</br>
</br>
<small>$1$ : But it is always necessary to declare at least one value interval.</small>


--- 

- {{% ccode c="Task" %}} to manage with task/interval
- {{% ccode c="SetVar" %}} and {{% ccode c="SetView" %}}
- {{% ccode c="(Un)DirectedGraphVar" %}} and  {{% ccode c="GraphView" %}}
- and also {{% ccode c="RealVar" %}}.

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
BoolVar n = m.boolNotView(b); // n = !b    
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

{{% fragment %}} Only once instantiated can the value be retrieved by calling `x.getValue()` {{% /fragment %}}


---

{{< slide id="ex2" background="#76bde8"  >}}

## Now it's your turn

- TODO

{{% /section %}}