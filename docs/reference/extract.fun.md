# Extract functions, libraries and global variables to be loaded onto a compute cluster

Automatic extraction of functions, libraries and global variables
employed passed functions. Designed for `peperr` call, see Details
section there.

## Usage

``` r
extract.fun(funs = NULL)
```

## Arguments

- funs:

  list of function names.

## Value

list containing

- packages:

  vector containing quoted names of libraries

- functions:

  vector containing quoted names of functions

- variables:

  vector containing quoted names of global variables

## Details

This function is necessary for compute cluster situations where for
computation on nodes required functions, libraries and variables have to
be loaded explicitly on each node. Avoids loading of whole global
environment which might include the unnecessary loading of huge data
sets.

It might have problems in some cases, especially it is not able to
extract the library of a function that has no namespace. Similarly, it
can only extract a required library if it is loaded, or if the function
contains a require or library call.

## See also

`peperr`

## Examples

``` r
# 1. Simplified example for illustration
if (FALSE) { # \dontrun{
library(CoxBoost)
a <- function(){
# some calculation
}

b<-function(){
# some other calculation
x <- cv.CoxBoost()
# z is global variable
y <- a(z)
}

# list with packages, functions and variables required for b:
extract.fun(list(b))

# 2. As called by default in peperr example
extract.fun(list(fit.CoxBoost, aggregation.pmpec))
} # }
```
