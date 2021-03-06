---
title: "Designing a search strategy"
date: 2020-01-07T16:06:55+01:00
weight: 53
math: "true"
description: >
  How to design search strategies?
---


### Designing your own search strategy

#### Using selectors

To design your own strategy using `Search.intVarSearch`, you simply have to implement
your own variable and value selectors:

```java
public static IntStrategy intVarSearch(VariableSelector<IntVar> varSelector,
                                    IntValueSelector valSelector,
                                    IntVar... vars)
```

For instance, to select the first non instantiated variable and assign it to its lower bound:

```java
Solver s = model.getSolver();
s.setSearch(intVarSearch(
        // variable selector
        (VariableSelector<IntVar>) variables -> {
            for(IntVar v:variables){
                if(!v.isInstantiated()){
                    return v;
                }
            }
            return null;
        },
        // value selector
        (IntValueSelector) var -> var.getLB(),
        // variables to branch on
        x, y
));
```

**NOTE**: When all variables are instantiated, a `VariableSelector` must return `null`.

#### From scratch

You can design your own strategy by creating `Decision` objects directly as follows:

```java
s.setSearch(new AbstractStrategy<IntVar>(x,y) {
    // enables to recycle decision objects (good practice)
    PoolManager<IntDecision> pool = new PoolManager();
    @Override
    public Decision getDecision() {
        IntDecision d = pool.getE();
        if(d==null) d = new IntDecision(pool);
        IntVar next = null;
        for(IntVar v:vars){
            if(!v.isInstantiated()){
                next = v; break;
            }
        }
        if(next == null){
            return null;
        }else {
            // next decision is assigning nextVar to its lower bound
            d.set(next,next.getLB(), DecisionOperator.int_eq);
            return d;
        }
    }
});
```

### Making a decision greedy

You can make a decision non-refutable by using `decision.setRefutable(false)` inside your 

To make an entire search strategy greedy, use:

```java
Solver s = model.getSolver();
s.setSearch(greedySearch(inputOrderLBSearch(x,y,z)));
```



### Large Neighborhood Search (LNS)


##### Defining its own neighborhoods

A presentation of the [functioning of LNS]({{< ref "/docs/Solving/LNS.md" >}}) was given earlier. It is said that anyone can define its own neighbor, dedicated to the problem solved.
This is achieved by extending either the abstract class `IntNeighbor` or by implementing the interface `INeighbor`. 
The former implements all methods from the latter but `void fixSomeVariables() throws ContradictionException;` that defines which variables should be fixed to their value in the last solution. 


`INeighbor` forces to implements the following methods:

```java
/**
 * Action to perform on a solution. 
 * Typically, storing the current variables’ value.
 */
public void recordSolution() {
    // where `values` and `variables` are class instances
    for (int i = 0; i < variables.length; i++) {
        values[i] = variables[i].getValue();
    }
}  
```


```java
/**
 * Fix some variables to their value in the last solution.
 */
public void fixSomeVariables() throws ContradictionException{
    // An example of random neighbor where a coin is tossed
    // for each variable to choose if it is fixed or not in the current fragment
    for (int i = 0; i < variables.length; i++) {
        if(Math.random() < .9){
            variables[i].instantiateTo(values[i], this);
            // alternatively call: `this.freeze(i);`    
        }
    }
}

```

```java
/**
 * Relax the number of variables fixed. 
 * Called when no solution was found during a LNS run 
 * (i.e., trapped into a local optimum).
 * if the fragment is based on a class instance (e.g, number of fixed variables)
 * it may be updated there
 */
void restrictLess()
// for instance, the threshold (0.9) previously declare in `fixSomeVariables()`
// can be reduced here
```

```java
/** 
 * Indicates whether the neighbor is complete, that is, can end.
 * Most of the time, this is related to `restrictLess()`
 */
boolean isSearchComplete()`
// for instance, if the threshold is 0. after a certain number of attempts.
```




