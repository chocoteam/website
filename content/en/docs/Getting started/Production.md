---
title: "Choco-solver in Production"
date: 2021-04-28T11:11:15+02:00
weight: 11
description: >
  Considerations when using Choco-solver in Production.
---

Technical considerations aside, if you are going to evaluate Choco-solver for production use, it is important to keep the following in mind.

{{% pageinfo %}}

[IMT Atlantique](https://www.imt-atlantique.fr/), holder of the economic rights of Choco-solver, offers dedicated services, ranging from support to expertise. 

For more information, [please contact us](mailto:choco-solver@imt-atlantique.fr?subject=Contact).

{{% /pageinfo %}}

# Licence

Choco is a Free Open-Source Java library distributed under BSD 4-Clause license. It is therefore important to know the different aspects that make up this licence. It is of course necessary to contact a legal department, but consulting the [Wikipedia page of the licence](https://en.wikipedia.org/wiki/BSD_licenses) is a good start.

# The project

The first version of Choco-solver in Java was released in 2003. Since then, it has undergone several major redesigns, the last of which was in 2013. Since then, the modelling API has been stabilised (i.e. what concerns the declaration of variables and constraints). Occasionally, the signature of certain methods change but rarely without first deprecating the old usages. However, Choco-solver is an active library.

Most bugs are fixed within a few days and patches included in the next release. On average, there are 2 releases per year and the changes made are reported in a file called `CHANGES.md` (which can be found on GitHub).

There are few regular contributors but there are several thousand downloads per month from Maven Central Repository.


# Test coverage

We pay particular attention to testing. They come in two forms: unit and regression tests and performance tests. The latter evaluate the performance of Choco-solver on MiniZinc, XCSP3, MPS and DIMACS instances and evaluate different statistics (time, failures, ...). The tests are executed at each commit and the results are available from GitHub. Regularly, performance is evaluated on a larger set of instances (MiniZinc and XCSP3 mainly), but because of the time consuming nature of this, they have not been automated. 


# Support

There are different ways to get help. Firstly, you should visit the [Community](/community/) page, which lists the different entry points. Of course, this does not guarantee the response time.
