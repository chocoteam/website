---
title: "Parsing"
date: 2020-01-07T16:08:22+01:00
weight: 4
description: >
  What does your user need to know to parse a model?
---

In addition to the modelling language, Choco-solver can parse files in [XCSP3](https://xcsp.org/competitions/), [MiniZinc (flatzinc)](https://www.minizinc.org/) and [DIMACS](https://jix.github.io/varisat/manual/0.2.0/formats/dimacs.html) formats.

The standard practice is to call the choco JAR directly with the instance as an argument, such as:
```bash
java -jar choco-parsers-4.10.13-light.jar /path/to/the/instance
```

XCSP3 and DIMACS files do not require any preliminary steps and can therefore be read and resolved directly.
Instructions can be founds [here](https://github.com/chocoteam/choco-solver/blob/master/parsers/XCSP3.md) and [here](https://github.com/chocoteam/choco-solver/blob/master/parsers/DIMACS.md).

But MiniZinc models must be turned into Flatzinc models with the right set of constraints, the ones supported by Choco-solver.
The easiest way, in that case, is to rely on MinizincIDE and add Choco-solver as additional solver.
Instructions can be found on [here](https://github.com/chocoteam/choco-solver/blob/master/parsers/MINIZINC.md).
