---
title: "Description"
date: 2020-02-03T13:41:20+01:00
type: docs
weight: 41
description: >
  A description of the problem to model and solve.
---

Given a set of planes and runways, the objective is to minimize the
total (weighted) deviation from the target landing time for each plane.

There are costs associated with landing either earlier or later than a
target landing time for each plane.

Each plane has to land on one of the runways within its predetermined
time windows such that separation criteria between all pairs of planes
are satisfied.

This type of problem is a large-scale optimization problem, which occurs
at busy airports where making optimal use of the bottleneck resource
(the runways) is crucial to keep the airport operating smoothly.

See [this
page](http://people.brunel.ac.uk/~mastjjb/jeb/orlib/airlandinfo.html)
for more details.

Input data
----------

We consider here the following input (in java):

{{< tabpane langEqualsHeader=true >}} 
{{< tab "Java" >}}
// number of planes
int N = 10;
// Times per plane: {earliest landing time, target landing time, latest landing time}
int[][] LT = {
    {129, 155, 559},
    {195, 258, 744},
    {89, 98, 510},
    {96, 106, 521},
    {110, 123, 555},
    {120, 135, 576},
    {124, 138, 577},
    {126, 140, 573},
    {135, 150, 591},
    {160, 180, 657}};
// penalty cost penalty cost per unit of time per plane: {for landing before target, after target}
int[][] PC = {
    {10, 10},
    {10, 10},
    {30, 30},
    {30, 30},
    {30, 30},
    {30, 30},
    {30, 30},
    {30, 30},
    {30, 30},
    {30, 30}};

// Separation time required after i lands before j can land
int[][] ST = {
    {99999, 3, 15, 15, 15, 15, 15, 15, 15, 15},
    {3, 99999, 15, 15, 15, 15, 15, 15, 15, 15},
    {15, 15, 99999, 8, 8, 8, 8, 8, 8, 8},
    {15, 15, 8, 99999, 8, 8, 8, 8, 8, 8},
    {15, 15, 8, 8, 99999, 8, 8, 8, 8, 8},
    {15, 15, 8, 8, 8, 99999, 8, 8, 8, 8},
    {15, 15, 8, 8, 8, 8, 99999, 8, 8, 8},
    {15, 15, 8, 8, 8, 8, 8, 99999, 8, 8},
    {15, 15, 8, 8, 8, 8, 8, 8,  99999, 8},
    {15, 15, 8, 8, 8, 8, 8, 8,  8, 99999}};
{{< /tab >}}
{{< /tabpane >}}



