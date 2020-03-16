---
title: "Ibex"
date: 2020-01-07T16:06:55+01:00
weight: 56
math: "true"
description: >
  Using Ibex.
---

To manage continuous constraints with Choco, an interface with [Ibex](http://www.ibex-lib.org/) has been done.
It needs this library to be installed on your system.

> “IBEX is a C++ library for constraint processing over real numbers.
> It provides reliable algorithms for handling non-linear constraints.
> In particular, round off errors are also taken into account.
> It is based on interval arithmetic and affine arithmetic.”
> – [http://www.ibex-lib.org/](http://www.ibex-lib.org/)

### Installing Ibex

See the [installation instructions](http://www.ibex-lib.org/doc/install.html) of Ibex to complied Ibex on your system.
More specially, take a look at [Installation as a dynamic library](http://www.ibex-lib.org/doc/install.html#installation-as-a-dynamic-library)
Do not forget to add the `--with-java-package=org.chocosolver.solver.constraints.real` configuration option.

### Using Ibex

Once the installation is completed, the JVM needs to know where Ibex is installed to fully benefit from the Choco-Ibex bridge and declare real variables and constraints.
This can be done either with an environment variable of by adding `-Djava.library.path=path/to/ibex/lib` to the JVM arguments.
The path /path/to/ibex/lib points to the lib directory of the Ibex installation directory.
