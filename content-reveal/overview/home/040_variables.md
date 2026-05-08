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


If ABCDE times 4 equals EDCBA, and each letter is a different digit from 0 to 9, 

what is the value of each letter?

[source](https://mindyourdecisions.com/blog/2023/11/22/abcde-times-4-equals-edcba/) 

---

{{< slide background="#76bde8"  >}}

### A Model

- __Variables__: 
  - $\forall i \in \\{a,b,c,d,e\\}, l_i \in [\\![ 0,9]\\!]$

- __Constraints__ : 
  - $\forall i\neq j \in \\{a,b,c,d,e\\}, l_i \neq l_j$
  - $39999l_a + 3990l_b + 300l_c - 960l_d - 9996l_e = 0$

---


{{< slide background="#76bde8"  >}}

### Choco-solver code

```java
// Create a model
Model model = new Model("ABCDE x 4 = EDCBA");

// Declare the variables with their initial domain
IntVar A = model.intVar("A", 0, 9);
IntVar B = model.intVar("B", 0, 9);
IntVar C = model.intVar("C", 0, 9);
IntVar D = model.intVar("D", 0, 9);
IntVar E = model.intVar("E", 0, 9);

// Constraint 1:
// "each letter is a different digit from 0 to 9"
// the second part of the constraint is defined
// by the domain of each variable
model.allDifferent(A, B, C, D, E).post();

// Constraint 2:
// "org.step1.ABCDE times 4 equals EDCBA"
// 40000 A + 4000 B + 400 C + 40 D + 4 E = 10000 E + 1000 D + 100 C + 10 B + A
// <=> 39999 A + 3990 B + 300 C + -960 D - 9996 E = 0
model.scalar(
        new IntVar[]{A, B, C, D, E},
        new int[]{39_999, 3_990, 300, -960, -9_996},
        "=", 0).post();

// Find a solution and print it
if (model.getSolver().solve()) {
      int[] sol = new int[]{A.getValue(), B.getValue(), C.getValue(), D.getValue(), E.getValue()};
      System.out.printf(" %d%d%d%d%d\nx    4\n------\n %d%d%d%d%d\n",
        sol[0], sol[1], sol[2], sol[3], sol[4],
        sol[4], sol[3], sol[2], sol[1], sol[0]);
}else{
      System.out.println("No solution found");
}        
```

---
{{< slide background="#76bde8"  >}}

### Output

```shell{}
 21978
x    4
------
 87912
 ```


---




{{< slide background="#76bde8"  >}}

###  Can you guess his year of birth?

Someone comes up to you and says:

> On my birthday in 2025, my age will be equal to the sum of the digits of my birth year. I am less than 100 years old. What could my birth year be?

Can you model this as a CP problem?

[source](https://mindyourdecisions.com/blog/2023/07/03/age-equals-sum-of-birth-year-digits/) 

---

{{< slide background="#76bde8"  >}}

### A Model

- **Parameters**
  - $input$: the current year
- **Variables**
  - $\forall i \in \\{th,hu,te,on\\}, x_i \in [\\![0,9]\\!]$
  - $age \in [\\![0,99]\\!]$
- **Constraints**
  - $x_{th} + x_{hu} + x_{te} + x_{on} = {age}$
  - $1000x_{th} + 100x_{hu} + 10x_{te} + x_{on} + age = input$

---

{{< slide background="#76bde8"  >}}

### Hints

```java
model.sum(IntVar[], String, int)
model.scalar(IntVar[], int[], String, int)
```

---

{{< slide background="#76bde8"  >}}

### A Choco-solver code

```java
Model model = new Model("Age equals sum of birth year digits");

IntVar th = model.intVar("th", 0, 9);
IntVar hu = model.intVar("hu", 0, 9);
IntVar te = model.intVar("te", 0, 9);
IntVar on = model.intVar("on", 0, 9);

IntVar age = model.intVar("age", 0, 99);

model.sum(new IntVar[]{th, hu, te, on}, "=", age).post();
model.scalar(
        new IntVar[]{th, hu, te, on, age},
        new int[]{1_000, 100, 10, 1, 1},
        "=", 2025).post();

while (model.getSolver().solve()) {
    int[] sol = new int[]{th.getValue(), hu.getValue(), te.getValue(), on.getValue()};
    System.out.printf("I was born in %d%d%d%d, I am %d years old\n", sol[0], sol[1], sol[2], sol[3], age.getValue());
}
if(model.getSolver().getSolutionCount() == 0) {
    System.out.println("No solution found");
}

```

--- 

{{< slide background="#76bde8"  >}}

### Output

```shell{}
I was born in 1998, I am 27 years old
I was born in 2016, I am 9 years old
 ```


{{% /section %}}
