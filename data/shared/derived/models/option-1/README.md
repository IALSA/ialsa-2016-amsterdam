`./data/shared/derived/models/option-1` folder contains model objects obtained by fitting msm() and elect() calls. 

## Fitting options
```r

digits = 2
method_  = "BFGS"     
constraint_ = NULL                   # additional model constraints
fixedpars_ = NULL                    # fixed parameters
initprobs_ = initial_probabilities #c(.67,.16,.11,.07),

 model <- msm(
    formula       = state ~ age,
    subject       = id,
    data          = ds,
    center        = FALSE,
    qmatrix       = Q,
    ematrix       = E,
    death         = TRUE,
    covariates    = covariates_,
    censor        = c(-1,-2),
    censor.states = list(c(1,2,3), c(1,2,3)),
    method        = method_,
    constraint    = constraint_,
    fixedpars     = fixedpars_,
    initprobs     = initprobs_,
    est.initprobs = TRUE,
    control       = list(trace=0,REPORT=1,maxit=1000,fnscale=10000)
 )
 ```

## Model Specification

```r
# transition matrix
Q <- rbind( c(0, q, 0, q), 
            c(q, 0, q, q),
            c(0, 0, 0, q), 
            c(0, 0, 0, 0)) 

# misclassification matrix
E <- rbind( c( 0,  0,  0, 0),  
            c( 0,  0, .1, 0), 
            c( 0,  0,  0, 0),
            c( 0,  0,  0, 0) )

# transition names
qnames = c(
  "Healthy - Mild",  # q12
  # "Healthy - Severe", # q13
  "Healthy - Dead",  # q14
  "Mild - Healthy",  # q21  
  "Mild - Severe",   # q23
  "Mild - Dead",     # q24
  # "Severe - Healthy",# q31
  # "Severe - Mild",   # q32
  "Severe - Dead"    # q34
)
```

## ELECT options
```r
age_min <- 0
age_max <- 35
age_bl <- 0
male <- 0
educat <- 0
edu <- 11

replication_n <- 100
time_scale <- "years"
grid_par <- .5
```