Correlation Matrix in Shiny with *corrplot*
===========

This [Shiny](http://shiny.rstudio.com/) application aims to provide an interactive experience to the awesome [corrplot](http://cran.r-project.org/web/packages/corrplot) R package. [Correlation](http://en.wikipedia.org/wiki/Correlation_and_dependence) is one of the most commonly used metrics to depict statistical relationships between two variables. It's often used in exploratory analysis, feature selection and many other modelling steps.

## Overview

### Data Input
Currently we provide a list of built-in datasets sourced from various R packages. You can also upload your own in any delimited flat file format.

### Correlation
The `cor` function in `stats` package is used thus you have the freedom to choose from *pearson*, *kendall*, and *spearman* correlation and some control over how to treat NA values.

### Corrplot
We have include abilities to generate most examples in [corrplot vignette](http://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html). In addition, you can make [statstical inference](http://en.wikipedia.org/wiki/Pearson_product-moment_correlation_coefficient#Inference) on correlation significance and/or confidence intervals.

## Credits
Thanks goes to [corrplot](http://cran.r-project.org/web/packages/corrplot) for inspiration, and [Developing Data Products](https://class.coursera.org/devdataprod-005) on Coursera for motivation and opportunity.

## LICENSE
MIT
