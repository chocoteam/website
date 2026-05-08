+++
title = "Tiny Tiny Constraint Solver"
outputs = ["Reveal"]

[reveal_hugo]
theme = "league"
slide_number = true
highlight_theme = "github"
+++

# The Very Tiny </br> Constraint Solver
</br>
Charles Prud'homme, March 2024

IMT Atlantique, LS2N, TASC


<small style="color:#C70039">< press [N] / [P] to go the next / previous slide ></small>

{{% note %}}
Don't forget disable `codeFences` in `config.toml`.
{{% /note %}}

---

In this presentation, we are going to code {{< frag class="highlight-blue" c="from scratch" >}} a minimalist constraint solver.

The aim is nothing but {{< frag class="highlight-blue" c="understanding" >}} the internal mechanics.
