+++
weight = 30
+++

{{% section %}}

# Modelling

---

## Creation of a {{% ccode c="Model" %}} instance

---

{{% ccode c="Model" %}} is the {{% calert c="central object" %}} in the Choco-solver library


- Creating a model is the {{% calert c="first essential step" %}} in declaring and
solving a problem.
- Variables are declared via the model
- Constraints too

In fact, almost anything can be done via a {{% ccode c="Model" %}} instance$^1$.

<small>$1$: So you don’t have to know all the objects in advance.</small>

---

### Several builders
```java{|1-2}
Model m = new Model();								 							 // 1
Model m = new Model(String name);					 					 // 2
Model m = new Model(settings settings);				 			 // 3
Model m = new Model(String name, Settings settings); // 4
```

Prefer choices 1 and 2 to start with.

---

{{< slide id="code1" transition="none-out" >}}

```java{}
package apetizer;



public class Example{

    public static void main(String[] args){

    }
}
```


---

{{< slide id="code2" transition="none-in" >}}



```java{3,8}
package apetizer;

import org.chocosolver.solver.Model;

public class Example{

    public static void main(String[] args){
        Model myModel = new Model("My first model");
    }
}
```


{{% /section %}}
