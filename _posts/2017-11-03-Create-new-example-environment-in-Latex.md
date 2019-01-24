---
title: "Create new example environment in Latex"
author: Alberto Torres Barrán
tags: latex
---

The following code can be used to create a new Example environment that ends with a triangle instead of a square.

```latex
\theoremstyle{definition}
\newtheorem{examplex}{Example}
\newenvironment{example}
  {\pushQED{\qed}\renewcommand{\qedsymbol}{$\triangle$}\examplex}
  {\popQED\endexamplex}
```
