



This report was automatically generated with the R package **knitr**
(version 1.12.3).


```r
# knitr::stitch_rmd(script="./reports/practical-1/elect-practical-1.R", output="./reports/practical-1/elect-practical-1.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 
```



```r
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
base::source("./scripts/common-functions.R") # used in multiple reports
base::source("./scripts/graph-presets.R") # fonts, colors, themes 
base::source("http://www.ucl.ac.uk/~ucakadl/ELECT.r") # load  ELECT functions
```

```r
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
library("msm") # multistate modeling (cannot be declared silently)
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
requireNamespace("tidyr") # data manipulation
requireNamespace("dplyr") # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")# For asserting conditions meet expected patterns.
# requireNamespace("car") # For it's `recode()` function.

requireNamespace("flexsurv") # parameteric survival and multi-state
requireNamespace("mstate") # multistate modeling
requireNamespace("foreign") # data input
```

```r
# point to the data file used in Example 1 of the official ELECT vignette
path_data_example_i <- "./libs/materials/R/Practical1/dataEx1.RData"
# Define rounding in output:
digits <- 3
```

```r
load(path_data_example_i)
ds <- dplyr::tbl_df(dta)
```

```r
head(ds) # top few rows
```

```
## Source: local data frame [6 x 4]
## 
##      id state   age     x
##   (dbl) (dbl) (dbl) (dbl)
## 1     1     1  77.9     1
## 2     1     1  79.9     1
## 3     1     1  81.9     1
## 4     1     2  83.9     1
## 5     1     1  85.9     1
## 6     1     1  87.9     1
```

```r
subjects <- as.numeric(names(table(dta$id)))
N <- length(subjects)
cat("\nSample size:",N,"\n")
```

```
## 
## Sample size: 200
```

```r
cat("\nFrequencies observed state:"); print(table(dta$state))
```

```
## 
## Frequencies observed state:
```

```
## 
##  -2   1   2   3 
##  82 637 224 118
```

```r
cat("\nFrequencies number of observations:"); print(table(table(dta$id)))
```

```
## 
## Frequencies number of observations:
```

```
## 
##  2  3  4  5  6  7 
## 27 20 23 19 17 94
```

```r
cat("\nState table:"); print(statetable.msm(state,id,data=dta))
```

```
## 
## State table:
```

```
##     to
## from  -2   1   2   3
##    1  59 434  84  60
##    2  23  28 115  58
```

```r
ds %>% dplyr::filter(id %in% c("4","5")) # a few specific ids
```

```
## Source: local data frame [14 x 4]
## 
##       id state   age     x
##    (dbl) (dbl) (dbl) (dbl)
## 1      4     1  72.7     0
## 2      4     1  74.7     0
## 3      4     1  76.7     0
## 4      4     1  78.7     0
## 5      4     1  80.7     0
## 6      4     1  82.7     0
## 7      4    -2  84.7     0
## 8      5     1  78.0     0
## 9      5     1  80.0     0
## 10     5     1  82.0     0
## 11     5     1  84.0     0
## 12     5     1  86.0     0
## 13     5     1  88.0     0
## 14     5    -2  90.0     0
```

```r
# NOTE: 
ds %>% dplyr::summarise(unique_ids = n_distinct(id)) # subject count
```

```
## Source: local data frame [1 x 1]
## 
##   unique_ids
##        (int)
## 1        200
```

```r
ds %>% dplyr::group_by(state) %>% dplyr::summarize(count = n()) # basic frequiencies
```

```
## Source: local data frame [4 x 2]
## 
##   state count
##   (dbl) (int)
## 1    -2    82
## 2     1   637
## 3     2   224
## 4     3   118
```

```r
# NOTE: -2 is a right censored value, indicating being alive but in an unknown living state.
```

```r
# Add first observation indicator
# this creates a new dummy variable "firstobs" with 1 for the frist wave
cat("\nFirst observation indicator is added.\n")
```

```
## 
## First observation indicator is added.
```

```r
offset <- rep(NA,N)
for(i in 1:N){offset[i] <- min(which(dta$id==subjects[i]))}
firstobs <- rep(0,nrow(dta))
firstobs[offset] <- 1
dta <- cbind(dta,firstobs=firstobs)
head(dta)
```

```
##   id state  age x firstobs
## 1  1     1 77.9 1        1
## 2  1     1 79.9 1        0
## 3  1     1 81.9 1        0
## 4  1     2 83.9 1        0
## 5  1     1 85.9 1        0
## 6  1     1 87.9 1        0
```

```r
# Time intervals in data:
# the age difference between timepoint for each individual
intervals <- matrix(NA,nrow(dta),2)
for(i in 2:nrow(dta)){
  if(dta$id[i]==dta$id[i-1]){
    intervals[i,1] <- dta$id[i]
    intervals[i,2] <- dta$age[i]-dta$age[i-1]
  }
}
head(intervals)
```

```
##      [,1] [,2]
## [1,]   NA   NA
## [2,]    1    2
## [3,]    1    2
## [4,]    1    2
## [5,]    1    2
## [6,]    1    2
```

```r
# the age difference between timepoint for each individual
# Remove the N NAs:
intervals <- intervals[!is.na(intervals[,2]),]
cat("\nTime intervals between observations within individuals:\n")
```

```
## 
## Time intervals between observations within individuals:
```

```r
print(round(quantile(intervals[,2]),digits))
```

```
##   0%  25%  50%  75% 100% 
## 0.11 2.00 2.00 2.00 2.00
```

```r
# Info on age and time between observations:
opar<-par(mfrow=c(1,3), mex=0.8,mar=c(5,5,3,1))
hist(dta$age[dta$firstobs==1],col="red",xlab="Age at baseline in years",main="")
hist(dta$age,col="blue",xlab="Age in data in years",main="") 
hist(intervals[,2],col="green",xlab="Time intervals in data in years",main="") 
```

<img src="figure/elect-practical-1-Rmdexplore-data-1-a-4-1.png" title="plot of chunk explore-data-1-a-4" alt="plot of chunk explore-data-1-a-4" style="display: block; margin: auto;" />

```r
opar<-par(mfrow=c(1,1), mex=0.8,mar=c(5,5,2,1))
```

```r
# Choose model (0/1/2):
Model <- 2
# Generator matrix Q:
q <- 0.01; Q <- rbind(c(0,q,q), c(q,0,q),c(0,0,0))
qnames <- c("q12","q21","q13","q23")
# Optimisation method ("BFGS" or "Nelder-Mead"):
method <- "BFGS"

# Model formulation:
if(Model==0){
  # Covariates:
  covariates <- as.formula("~1")
  constraint <- NULL 
  fixedpars <- NULL
}
if(Model==1){
  # Covariates:
  covariates <- as.formula("~age")
  constraint <- NULL 
  fixedpars <- NULL
}
if(Model==2){
  # Covariates:
  covariates <- as.formula("~age+x")
  constraint <- NULL 
  fixedpars <- NULL
}

# Model fit:
if(1){
  model <- msm(state~age, subject=id, data=dta, center=FALSE, 
               qmatrix=Q, death=TRUE, covariates=covariates,
               censor= -2, censor.states=c(1,2), method=method,
               constraint=constraint,fixedpars=fixedpars, 
               control=list(trace=0,REPORT=1,maxit=1000,fnscale=10000))
}
```

```r
# For the fitting of the model it is essential that consecutive records for one individual do not contain the same age. 
# This would imply that no time has passed between the two observations. 
# For this reason rounding age to whole years is not recommended 

# compose an algorythm for testing this
```


```r
cat("Sample size:"); print(length(table(data$id)))
```

```
## Sample size:
```

```
## Error in data$id: object of type 'closure' is not subsettable
```

```r
cat("Frequencies observed state:"); print(table(data$state))
```

```
## Frequencies observed state:
```

```
## Error in data$state: object of type 'closure' is not subsettable
```

```r
cat("State table:"); print(msm::statetable.msm(state,id,data=data))
```

```
## State table:
```

```
## Error in eval(substitute(state), data, parent.frame()): invalid 'envir' argument of type 'closure'
```

The R session information (including the OS info, R version and all
packages used):


```r
sessionInfo()
```

```
## R version 3.2.4 Revised (2016-03-16 r70336)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows >= 8 x64 (build 9200)
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] msm_1.6.1     magrittr_1.5  nnet_7.3-12   ggplot2_2.1.0
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.4        formatR_1.3        RColorBrewer_1.1-2
##  [4] plyr_1.8.3         tools_3.2.4        extrafont_0.17    
##  [7] digest_0.6.9       evaluate_0.8.3     gtable_0.2.0      
## [10] lattice_0.20-33    Matrix_1.2-4       DBI_0.3.1         
## [13] parallel_3.2.4     mvtnorm_1.0-5      expm_0.999-0      
## [16] Rttf2pt1_1.3.3     stringr_1.0.0      dplyr_0.4.3       
## [19] knitr_1.12.3       htmlwidgets_0.6    grid_3.2.4        
## [22] DT_0.1.40          deSolve_1.13       mstate_0.2.9      
## [25] R6_2.1.2           survival_2.38-3    foreign_0.8-66    
## [28] rmarkdown_0.9.5    tidyr_0.4.1        extrafontdb_1.0   
## [31] scales_0.4.0       htmltools_0.3.5    splines_3.2.4     
## [34] rsconnect_0.4.2.1  assertthat_0.1     dichromat_2.0-0   
## [37] testit_0.5         colorspace_1.2-6   flexsurv_0.7.1    
## [40] quadprog_1.5-5     stringi_1.0-1      muhaz_1.2.6       
## [43] lazyeval_0.1.10    munsell_0.4.3
```

```r
Sys.time()
```

```
## [1] "2016-04-14 02:58:59 PDT"
```

