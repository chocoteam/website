---
title: "Description"
date: 2020-02-03T13:26:51+01:00
type: docs
weight: 31
description: >
  A description of the problem to model and solve.
---

In the Warehouse Location problem (WLP), a company considers opening
warehouses at some candidate locations in order to supply its existing
stores.

Each possible warehouse has the same maintenance cost, and a capacity
designating the maximum number of stores that it can supply.

Each store must be supplied by exactly one open warehouse. The supply
cost to a store depends on the warehouse.

The objective is to determine which warehouses to open, and which of
these warehouses should supply the various stores, such that the sum of
the maintenance and supply costs is minimized.

See [this page](http://csplib.org/Problems/prob034/) for more details.

Input data
----------

We consider here the following input (in java):

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// number of warehouses
int W = 5;
// number of stores
int S = 10;
// maintenance cost
int C = 30;
// capacity of each warehouse
int[] K = new int[]{1, 4, 2, 1, 3};
// matrix of supply costs, store x warehouse
int[][] P = new int[][]{
    {20, 24, 11, 25, 30},
    {28, 27, 82, 83, 74},
    {74, 97, 71, 96, 70},
    {2, 55, 73, 69, 61},
    {46, 96, 59, 83, 4},
    {42, 22, 29, 67, 59},
    {1, 5, 73, 59, 56},
    {10, 73, 13, 43, 96},
    {93, 35, 63, 85, 46},
    {47, 65, 55, 71, 95}};
{{< /tab >}}
{{< /tabpane >}}