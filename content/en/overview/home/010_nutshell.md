+++
weight = 10
+++

{{% section %}}

# Choco-solver

---

## Features

- Since the early 2000s
- Open-source (BSD-License)
- Java-based (jdk8)
- Python binding available (_WIP_)
- Available on [MCR](https://mvnrepository.com/artifact/org.choco-solver/choco-solver) and [pypi](https://pypi.org/project/pychoco/)
- Hosted on [Github](https://github.com/chocoteam/choco-solver)


---

- Parsers for [XCSP$^3$](https://xcsp.org/), [MiniZinc](https://www.minizinc.org/index.html) and [DIMACS CNF](https://jix.github.io/varisat/manual/0.2.0/formats/dimacs.html) files
- Included in PyCSP3 (`-solver=choco`)
- As tier 3 solver in CPMpy (since 0.9.17)

---

- About 3 releases per year
- {{< calert c="4.10.14" >}} is the current version
- $\approx5,860$ downloads per month, according to MCR
- 5 types of variable available
- $> 200$  propagators
- State-of-the-art search strategies
- _Almost_ LCG-ready

---

Visit the website for more documentation, tutorials, javadoc , etc

---

{{< slide background-iframe="https://choco-solver.org/" >}}


{{% /section %}}
