---
title: "Multi-thread resolution"
date: 2020-03-06T15:39:27+01:00
weight: 36
description: >
  How to use several threads to solve a problem?
---


Choco 4 provides a simple way to use several threads to treat a problem. The main idea of that driver is to solve the *same* model with different search strategies and to share few information to make these threads help each others.

To use a portfolio of solvers in parallel, use `ParallelPortfolio` as follows:

```java
ParallelPortfolio portfolio = new ParallelPortfolio();
int nbModels = 5;
for(int s=0;s<nbModels;s++){
    portfolio.addModel(makeModel());
}
portfolio.solve();
```

In this example, `makeModel()` is a method you have to implement to create a `Model` of the problem.
Here all models are the same and the portfolio will change the search heuristics of all models but the first one.
This means that the first thread will run according to your settings whereas the others will have a different configuration.

### Auto-configuration

In order to specify yourself the configuration of each thread, you need to create the portfolio by setting the optional
boolean argument `searchAutoConf` to false as follows:

```java
ParallelPortfolio portfolio = new ParallelPortfolio(false);
```

In this second example, the parameter `s` enables you to change the search strategy within the `makeModel` method (e.g. using a `switch(s)`).

When dealing with multithreading resolution, very few data is shared between threads:
everytime a solution has been found its value is shared among solvers. Moreover,
when a solver ends, it communicates an interruption instruction to the others.
This enables to explore the search space in various way, using different model settings such as search strategies
(this should be done in the dedicated method which builds the model, though).

### Sharing no-goods

Some of the default search strategies are based on a restart policy.
In such case, one can allow no-goods when those threads restart.

```java
portfolio.stealNogoodsOnRestarts();
```

Doing so, anytime a thread restarts, it records not only no-goods based on the search space it has explored since last restart, but also ones of other threads (restricted to those equipepd with a restart policy). 