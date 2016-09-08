# Model B : Estimation Results

<!-- These two chunks should be added in the beginning of every .Rmd that you want to source an .R script -->
<!--  The 1st mandatory chunck  -->
<!--  Set the working directory to the repository's base directory -->


<!--  The 2nd mandatory chunck  -->
<!-- Set the report-wide options, and point to the external code file. -->


Estimation results of **Model B**, specified by the following input:

```r
q <- .01
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
  "Healthy - Mild",   # q12
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



# Load environmet
<!-- Load the sources.  Suppress the output when loading sources. --> 

```r
base::source("http://www.ucl.ac.uk/~ucakadl/ELECT/ELECT.r") # load  ELECT functions
base::source("./scripts/ELECT-utility-functions.R") # ELECT utility functions
```

<!-- Load 'sourced' R files.  Suppress the output when loading packages. --> 

```r
library(magrittr) #Pipes
library(msm)
requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) 
requireNamespace("testit", quietly=TRUE)
```

<!-- Load any Global functions and variables declared in the R file.  Suppress the output. --> 

```

 Save fitted models here : 
```

```
[1] "./data/shared/derived/models/model-b-mod-1/"
```

# Load data
<!-- Load the datasets.   -->

```r
# first, the script `0-ellis-island.R` imports and cleans the raw data
# second, the script `1-encode-multistate.R` augments the data with multi-states
# load this data transfer object (dto)
dto <- readRDS("./data/unshared/derived/dto.rds")
```

<!-- Inspect the datasets.   -->

```r
names(dto)
names(dto[["unitData"]])       # 1st element - unit(person) level data
names(dto[["metaData"]])       # 2nd element - meta data, info about variables
names(dto[["ms_mmse"]])        # 3rd element - data for MMSE outcome
ds_miss <- dto$ms_mmse$missing # data after encoding missing states (-1, -2)
ds_ms <- dto$ms_mmse$multi     # data after encoding multistates (1,2,3,4)
```



```r
# compare before and after ms encoding
view_id <- function(ds1,ds2,id){
  cat("Before ms encoding:","\n")
  print(ds1[ds1$id==id,])
  cat("\nAfter ms encoding","\n")
  print(ds2[ds2$id==id,])
}
ids <- sample(unique(ds_miss$id),1) # view a random person for sporadic inspections
# 50402431 , 37125649, 50101073, 6804844, 83001827 , 56751351, 13485298, 56751351, 75507759)
ids <- c(50402431)
view_id(ds_miss, ds_ms, ids)
```

```
Before ms encoding: 
           id fu_year died   age_bl  male edu age_death age_at_visit mmse presumed_alive
5120 50402431       0    1 91.41136 FALSE  16  94.82272     91.41136   19          FALSE
5121 50402431       1    1 91.41136 FALSE  16  94.82272     92.33402   12          FALSE
5122 50402431       2    1 91.41136 FALSE  16  94.82272     93.34702    5          FALSE
5123 50402431       3    1 91.41136 FALSE  16  94.82272     94.34634    0          FALSE

After ms encoding 
            id fu_year died   age_bl  male edu      age state presumed_alive mmse firstobs
5120  50402431       0    1 91.41136 FALSE  16 91.41136     3          FALSE   19        1
5121  50402431       1    1 91.41136 FALSE  16 92.33402     3          FALSE   12        0
5122  50402431       2    1 91.41136 FALSE  16 93.34702     3          FALSE    5        0
5123  50402431       3    1 91.41136 FALSE  16 94.34634     3          FALSE    0        0
51201 50402431      NA    1 91.41136 FALSE  16 94.82272     4          FALSE   NA        0
```

# Remove cases

```r
#### 1) Remove observations with missing age
# Initial number of observations with missing age : 
sum(is.na(ds_ms$age))
```

```
[1] 1
```

```r
ds_clean <- ds_ms %>% 
  dplyr::filter(!is.na(age))
# Resultant number of observations with missing age
sum(is.na(ds_clean$age))
```

```
[1] 0
```

```r
#### 3) Remove subjects with only ONE observed data point
# Initial number of subjects who have *n* observed data points
ds_clean %>% 
  dplyr::group_by(id) %>% 
  dplyr::summarize(n_data_points = n()) %>% 
  dplyr::group_by(n_data_points) %>% 
  dplyr::summarize(n_people=n()) %>% 
  print()
```

```
# A tibble: 17 × 2
   n_data_points n_people
           <int>    <int>
1              1      119
2              2      205
3              3      184
4              4      180
5              5      190
6              6      104
7              7      108
8              8      113
9              9      127
10            10      116
11            11      110
12            12       71
13            13       21
14            14       14
15            15       13
16            16       17
17            17        3
```

```r
# Determine which ids have only a single observation
remove_ids <- ds_clean %>% 
  dplyr::group_by(id) %>% 
  dplyr::summarize(n_data_points = n()) %>% 
  dplyr::arrange(n_data_points) %>% 
  dplyr::filter(n_data_points==1) %>% 
  dplyr::select(id)
remove_ids <- remove_ids$id
# How many subjects to be removed from the data set: 
length(remove_ids)
```

```
[1] 119
```

```r
ds_clean <- ds_clean %>% 
  dplyr::filter(!(id %in% remove_ids))
# Resultant number of subjects who have *n* observed data points
ds_clean %>% 
  dplyr::group_by(id) %>% 
  dplyr::summarize(n_data_points = n()) %>% 
  dplyr::group_by(n_data_points) %>% 
  dplyr::summarize(n_people=n()) %>% 
  print()
```

```
# A tibble: 16 × 2
   n_data_points n_people
           <int>    <int>
1              2      205
2              3      184
3              4      180
4              5      190
5              6      104
6              7      108
7              8      113
8              9      127
9             10      116
10            11      110
11            12       71
12            13       21
13            14       14
14            15       13
15            16       17
16            17        3
```

```r
#### 3) Remove subjects with IMS at the first observation
# Initial view of subjects with intermediate missing state at first observation:
ids_firstobs_ims <- ds_clean %>% 
  dplyr::filter(firstobs == TRUE & state == -1) %>% 
  dplyr::select(id) %>% print()
```

```
        id
1 80333458
2 90214403
3 90447310
4 91804757
```

```r
ids_firstobs_ims <- ids_firstobs_ims[,"id"]
ds_clean <- ds_clean %>% 
  dplyr::filter(!id %in% ids_firstobs_ims)
# Resultant view of subjects with intermediate missing state at first observation:
ds_clean %>% 
  dplyr::filter(firstobs == TRUE & state == -1) %>% 
  dplyr::select(id) %>% print()
```

```
[1] id
<0 rows> (or 0-length row.names)
```

# Categorize covariates

```r
ds_clean$educat <- car::Recode(ds_clean$edu,
                               " 0:9   = '-1'; 
                               10:11 = '0';
                               12:30 = '1';
                               ")
ds_clean$educatF <- factor(
  ds_clean$educat, 
  levels = c(-1,             0,             1), 
  labels = c("0-9 years", "10-11 years", ">11 years"))
cat("\n How education was categorized: \n")
```

```

 How education was categorized: 
```

```r
ds_clean %>% 
  dplyr::group_by(educatF, edu) %>% 
  dplyr::summarize(n = n()) %>% 
  as.data.frame() %>% 
  print(nrow=100)
```

```
       educatF edu    n
1    0-9 years   0    4
2    0-9 years   2    6
3    0-9 years   3   10
4    0-9 years   4   17
5    0-9 years   5   20
6    0-9 years   6   48
7    0-9 years   7   27
8    0-9 years   8  178
9    0-9 years   9   76
10 10-11 years  10  167
11 10-11 years  11  225
12   >11 years  12 2400
13   >11 years  13  862
14   >11 years  14 1199
15   >11 years  15  554
16   >11 years  16 2132
17   >11 years  17  486
18   >11 years  18  942
19   >11 years  19  255
20   >11 years  20  286
21   >11 years  21  207
22   >11 years  22   61
23   >11 years  23   37
24   >11 years  24   26
25   >11 years  25   11
26   >11 years  28   21
```

```r
cat("\n Frequencies of categorized education :")
```

```

 Frequencies of categorized education :
```

```r
ds_clean %>% 
  dplyr::group_by(educatF) %>% 
  dplyr::summarize(n = n())
```

```
# A tibble: 3 × 2
      educatF     n
       <fctr> <int>
1   0-9 years   386
2 10-11 years   392
3   >11 years  9479
```

```r
# save clean data object for records and faster access
saveRDS(ds_clean, "./data/unshared/ds_clean.rds")
```

# Age diagnostic

```r
# Time intervals in data:
# the age difference between timepoint for each individual
intervals <- matrix(NA,nrow(ds_clean),2)
for(i in 2:nrow(ds_clean)){
  if(ds_clean$id[i]==ds_clean$id[i-1]){
    intervals[i,1] <- ds_clean$id[i]
    intervals[i,2] <- ds_clean$age[i]-ds_clean$age[i-1]
  }
  intervals <- as.data.frame(intervals)
  colnames(intervals) <- c("id", "interval")
}
cat("\n Minimum interval length : ",min(intervals[,2], na.rm=T)) 
```

```

 Minimum interval length :  0.00273785
```

```r
cat("\n Maximum interval length : ", max(intervals[,2], na.rm=T))
```

```

 Maximum interval length :  11.86858
```

```r
# the age difference between timepoint for each individual
intervals <- intervals[!is.na(intervals[,2]),] # Remove NAs:
cat("\nTime intervals between observations within individuals:\n")
```

```

Time intervals between observations within individuals:
```

```r
print(round(quantile(intervals[,2]),digits))
```

```
   0%   25%   50%   75%  100% 
 0.00  0.96  1.00  1.03 11.87 
```

```r
# Info on age and time between observations:
cat("\n Graphs of age distribution :\n")
```

```

 Graphs of age distribution :
```

```r
opar<-par(mfrow=c(1,3), mex=0.8,mar=c(5,5,3,1))
hist(ds_clean$age[ds_clean$firstobs==1],col="red",xlab="Age at baseline in years",main="")
hist(ds_clean$age,col="blue",xlab="Age in data in years",main="")
hist(intervals[,2],col="green",xlab="Time intervals in data in years",main="")
```

<img src="figure_rmd/describe-age-composition-1.png" width="900px" height="300px" />

```r
opar<-par(mfrow=c(1,1), mex=0.8,mar=c(5,5,2,1))
```

# Estimation prep

```r
# list ids with intermidiate missing (im) or right censored (rc) states
ids_with_im    <- unique(ds_clean[ds_clean$state == -1, "id"]) 
cat("\n Number of subjects with intermediate missing state (-1) : ",length(ids_with_im) )
```

```

 Number of subjects with intermediate missing state (-1) :  104
```

```r
ids_with_rc     <- unique(ds_clean[ds_clean$state == -2, "id"])
cat("\n Number of subjects with right censored state (-2) : ",length(ids_with_rc) )
```

```

 Number of subjects with right censored state (-2) :  46
```

```r
ids_with_either <- unique(c(ids_with_im, ids_with_rc))
cat("\n Number of subjects with either IMS or RC state(s) : ",length(ids_with_either) )
```

```

 Number of subjects with either IMS or RC state(s) :  149
```

```r
ids_with_both   <- dplyr::intersect(ids_with_im, ids_with_rc)
cat("\n Number of subjects with both IMS and RC state(s) : ",length(ids_with_both) )
```

```

 Number of subjects with both IMS and RC state(s) :  1
```

```r
# subset a random sample of individuals if needed
set.seed(42)
ids <- sample(unique(ds_clean$id), 100)


# centering decisions
cat("\n Centering decisions :")
```

```

 Centering decisions :
```

```r
age_center = 75
age_bl_center = 75

cat("\n The variable `age` is centered at :", age_center)
```

```

 The variable `age` is centered at : 75
```

```r
cat("\n The variable `age_bl` is centered at :", age_bl_center)
```

```

 The variable `age_bl` is centered at : 75
```

```r
cat("\n\n The following dataset will be passed to msm call (view for one person): \n")
```

```


 The following dataset will be passed to msm call (view for one person): 
```

```r
# define the data object to be passed to the estimation call
ds <- ds_clean %>% 
  # dplyr::filter(id %in% ids) %>% # make sample smaller if needed 
  # exclude individuals with missing states
  # dplyr::filter(!id %in% ids_with_im) %>%
  # dplyr::filter(!id %in% ids_with_rc) %>%
  dplyr::mutate(
    male = as.numeric(male), 
    age    = (age - 75), # centering
    age_bl = (age_bl - 75) # centering
) %>% 
  dplyr::select(id, age_bl,male, edu, educat, educatF,firstobs, fu_year, age, state)
# view data object to be passed to the estimation call
set.seed(42)
ids <- sample(unique(ds$id), 1)
ds %>% dplyr::filter(id %in% ids)
```

```
         id   age_bl male edu educat   educatF firstobs fu_year       age state
1  90544686 7.696783    0  12      1 >11 years        1       0  7.696783     1
2  90544686 7.696783    0  12      1 >11 years        0       1  8.682409     1
3  90544686 7.696783    0  12      1 >11 years        0       2  9.731006     1
4  90544686 7.696783    0  12      1 >11 years        0       3 10.689254     1
5  90544686 7.696783    0  12      1 >11 years        0       4 11.691307     1
6  90544686 7.696783    0  12      1 >11 years        0       5 12.709788     1
7  90544686 7.696783    0  12      1 >11 years        0       6 13.665298     1
8  90544686 7.696783    0  12      1 >11 years        0       7 14.678303     2
9  90544686 7.696783    0  12      1 >11 years        0       8 15.680356     1
10 90544686 7.696783    0  12      1 >11 years        0       9 16.709788     1
```

```r
cat("\n Subject count : ",length(unique(ds$id)),"\n")
```

```

 Subject count :  1572 
```

```r
cat("\n Frequency of states at baseline\n")
```

```

 Frequency of states at baseline
```

```r
sf <- ds %>% 
  dplyr::filter(firstobs==TRUE) %>% 
  dplyr::group_by(state) %>% 
  dplyr::summarize(count = n()) %>%  # basic frequiencies
  dplyr::mutate(pct = round(count/sum(count),2)) %>%  # percentages, use for starter values
  print()
```

```
# A tibble: 3 × 3
  state count   pct
  <dbl> <int> <dbl>
1     1  1189  0.76
2     2   281  0.18
3     3   102  0.06
```

```r
cat("\n State table: \n") 
```

```

 State table: 
```

```r
print(msm::statetable.msm(state,id,data=ds)) # transition frequencies
```

```
    to
from   -2   -1    1    2    3    4
  -2   32    0    0    0    0    0
  -1    0   25   27   13   26   47
  1    32   59 4855  715  120  251
  2     8   20  534  478  256  146
  3     6   34   24   96  649  232
```

```r
# these will be passed as starting values
initial_probabilities <- as.numeric(as.data.frame(sf[!sf$state %in% c(-1,-2),"pct"])$pct) 
initial_probabilities <- c(initial_probabilities,0) # no death state at first observation
cat('\n The inital values for estimation : ', initial_probabilities)
```

```

 The inital values for estimation :  0.76 0.18 0.06 0
```

```r
# save the object to be used during estimation
saveRDS(ds, "./data/unshared/ds_estimation.rds")
```

# Specifications

## Fitting functions

```r
estimate_multistate <- function(
  model_name 
  ,ds                   # data object 
  ,Q                    # Q-matrix of transitions
  ,E                    # misspecification matrix
  ,qnames               # names of the rows in the Q matrix
  ,cf                   # string with covariate names for forward transitions
  ,cb                   # string with covariate names for backward transitions
  ,cd                   # string with covariate names for death transitions
){
  cov_forward  <- as.formula(paste0("~",cf))
  cov_backward <- as.formula(paste0("~",cb))
  cov_death    <- as.formula(paste0("~",cd))
  # covariates_ <- as.formula(paste0("~",cov_names))
  covariates_    = list(
    "1-2"       = cov_forward,
    "2-3"       = cov_forward,
    "2-1"       = cov_backward,
    "1-4"       = cov_death,
    "2-4"       = cov_death,
    "3-4"       = cov_death
  )  
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
  # model <- paste0("test", covariates_)
  saveRDS(model, paste0(pathSaveFolder,model_name,".rds"))
  return(model)
} 
```

## Support functions

```r
get_crude_Q <- function(ds, Q, cov_names){
  formula_ <- as.formula(paste0("state ~ ",cov_names))
  Q_crude <- crudeinits.msm(
    formula = formula_, 
    subject = id, 
    qmatrix = Q, 
    data = ds,     
    censor        = c(-1,-2),
    censor.states = list(c(1,2,3), c(1,2,3)) 
  )
  return(Q_crude)
}

msm_summary <- function(model){
cat("\n-2loglik =", model$minus2loglik,"\n")
cat("Convergence code =", model$opt$convergence,"\n")
p    <- model$opt$par
p.se <- sqrt(diag(solve(1/2*model$opt$hessian)))
print(cbind(p=round(p,digits),
            se=round(p.se,digits),"Wald ChiSq"=round((p/p.se)^2,digits),
            "Pr>ChiSq"=round(1-pchisq((p/p.se)^2,df=1),digits)),
      quote=FALSE)
}

msm_details <- function(model){ 
  # intensity matrix
  cat("\n Intensity matrix : \n")
  print(qmatrix.msm(model)) 
  # qmatrix.msm(model, covariates = list(male = 0))
  # transition probability matrix
  t_ <- 2
  cat("\n Transition probability matrix for t = ", t_," : \n")
  print(pmatrix.msm(model, t = t_)) # t = time, in original metric
  # misclassification matrix
  cat("\n Misclassification matrix : \n")
  suppressWarnings(print(ematrix.msm(model), warnings=F))
  # mean sojourn times
  cat("\n Mean sojourn times : \n")
  print(sojourn.msm(model))
  # probability that each state is next
  cat("\n Probability that each state is next : \n")
  suppressWarnings(print(pnext.msm(model)))
  # total length of stay
  cat("\n  Total length of stay : \n")
  print(totlos.msm(model))
  # expected number of visits to the state
  cat("\n Expected number of visits to the state : \n")
  suppressWarnings(print(envisits.msm(model)))
  # ratio of transition intensities
  # qratio.msm(model,ind1 = c(2,1), ind2 = c(1,2))

}
```

## Model

```r
q <- .01
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
  "Healthy - Mild",   # q12
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

## `msm` options

```r
digits = 2
method_  = "BFGS"     # alternatively, if does not converge "Nedler-Mead" 
constraint_ = NULL    # additional model constraints
fixedpars_ = NULL     # fixed parameters
initprobs_ = initial_probabilities 
```


```r
# turn this chunk OFF when printing the report
# compile model objects with msm() call
# each model will be saved in the specified folder, namely pathSaveFolder
(Q_crude <- get_crude_Q(ds, Q, "age"))
```

```
           [,1]       [,2]       [,3]       [,4]
[1,] -0.1569916  0.1141470  0.0000000 0.04284465
[2,]  0.3504402 -0.6212645  0.1696731 0.10115125
[3,]  0.0000000  0.0000000 -0.2434208 0.24342081
[4,]  0.0000000  0.0000000  0.0000000 0.00000000
```

```r
# estimate_multistate("mB_mod1_1", ds, Q_crude, E, qnames, 
#                     cf = "age + male + educat",
#                     cb = "age",
#                     cd = "age + male") 
                    
# estimate_multistate("mB_mod1_2", ds, Q_crude, E, qnames, 
#                     cf = "age + age_bl + male + educat",
#                     cb = "age + age_bl",
#                     cd = "age + age_bl + male") 
```


```r
# assemble the list object with the results of msm estimation
models <- list()
models[["mB_mod1_1"]][["msm"]] <- readRDS(paste0(pathSaveFolder,'mB1.rds'))
models[["mB_mod1_2"]][["msm"]] <- readRDS(paste0(pathSaveFolder,'mB2.rds'))
```

<!-- ## `elect` options -->

```r
alive_states <- c(1,2,3)
ds_alive <- ds[ds$state %in% alive_states,]
fixedpars <- fixedpars_
age_min <- 0
age_max <- 35
age_bl <- 0
male <- 0
educat <- 0


replication_n <- 1000
time_scale <- "years"
grid_par <- .5
```


```r
# turn this chunk OFF when printing the report
# for(model_ in names(models) ){
#   # determine covariate list
#   if(model_=="age"){covar_list    = list(age=age_min)}
#   if(model_=="age_bl"){covar_list = list(age=age_min, age_bl=age_bl)}
#   if(model_=="male"){covar_list   = list(age=age_min, age_bl=age_bl, male=male)}
#   if(model_=="educat"){covar_list = list(age=age_min, age_bl=age_bl, male=male, educat=educat)}
#   # compute LE
#   models[[model_]][["LE"]] <- elect(
#     model          = models[[model_]][["msm"]], # fitted msm model
#     b.covariates   = covar_list, # list with specified covarites values
#     statedistdata  = ds_alive, # data for distribution of living states
#     time.scale.msm = time_scale, # time scale in multi-state model ("years", ...)
#     h              = grid_par, # grid parameter for integration
#     age.max        = age_max, # assumed maximum age in years
#     S              = replication_n # number of simulation cycles
#   )
# }
# #save models estimated by elect() in a external object for faster access in the future
# saveRDS(models, paste0(pathSaveFolder,"models.rds"))

models <- readRDS(paste0(pathSaveFolder,"models.rds"))
# inspect created object
lapply(models, names)
```


# Model results

## model 1

The model was fitted using the following specification of covariates:
```
# Forward transitions:
  "1-2"       = "age + male + educat"
  "2-3"       = "age + male + educat"
# Backward transitions:
  "2-1"       = "age"
# Death transitions: 
  "1-4"       = "age + male"
  "2-4"       = "age + male"
  "3-4"       = "age + male"
```

### summary

```r
model <- readRDS(paste0(pathSaveFolder,'mB_mod1_1.rds'))
msm_summary(model)
```

```

-2loglik = 15002.69 
Convergence code = 0 
          p   se Wald ChiSq Pr>ChiSq
qbase -1.94 0.10     343.06     0.00
qbase -4.21 0.18     525.95     0.00
qbase -0.27 0.08      10.85     0.00
qbase -2.07 0.19     122.48     0.00
qbase -3.44 0.42      65.48     0.00
qbase -2.28 0.20     131.33     0.00
qcov   0.08 0.01     157.35     0.00
qcov   0.08 0.01      31.04     0.00
qcov  -0.02 0.01       7.72     0.01
qcov   0.05 0.01      23.03     0.00
qcov   0.07 0.03       6.72     0.01
qcov   0.07 0.01      34.90     0.00
qcov   0.29 0.08      13.12     0.00
qcov   0.43 0.22       3.90     0.05
qcov  -0.17 0.16       1.21     0.27
qcov   0.71 0.29       6.28     0.01
qcov   0.35 0.14       6.56     0.01
qcov  -0.28 0.08      12.00     0.00
qcov  -0.08 0.13       0.34     0.56
p     -2.15 0.09     590.86     0.00
initp -1.33 0.06     432.96     0.00
initp -2.84 0.13     482.04     0.00
```

### details

```r
msm_details(model)
```

```

 Intensity matrix : 
        State 1                      State 2                      State 3                     
State 1 -0.25699 (-0.27607,-0.23923)  0.22528 ( 0.20769, 0.24436) 0                           
State 2  0.64404 ( 0.58425, 0.70995) -0.88419 (-0.95762,-0.81639)  0.17404 ( 0.14775, 0.20500)
State 3 0                            0                            -0.19433 (-0.23957,-0.15763)
State 4 0                            0                            0                           
        State 4                     
State 1  0.03172 ( 0.02584, 0.03893)
State 2  0.06611 ( 0.04269, 0.10237)
State 3  0.19433 ( 0.15763, 0.23957)
State 4 0                           

 Transition probability matrix for t =  2  : 
          State 1   State 2    State 3   State 4
State 1 0.7224876 0.1684461 0.03517298 0.0738933
State 2 0.4815688 0.2535146 0.13991778 0.1249988
State 3 0.0000000 0.0000000 0.67796367 0.3220363
State 4 0.0000000 0.0000000 0.00000000 1.0000000

 Misclassification matrix : 
        State 1 State 2 State 3                 State 4
State 1 1.0000  0       0                       0      
State 2 0       0       0.1039 (0.08883,0.1213) 0      
State 3 0       0       1.0000                  0      
State 4 0       0       0                       1.0000 

 Mean sojourn times : 
        estimates         SE        L        U
State 1  3.891149 0.14217843 3.622228 4.180034
State 2  1.130981 0.04603661 1.044256 1.224908
State 3  5.145865 0.54946461 4.174158 6.343777

 Probability that each state is next : 
        State 1                  State 2                  State 3                  State 4                 
State 1 0                        0.87658 (0.85020,0.8995) 0                        0.12342 (0.10053,0.1498)
State 2 0.72840 (0.69041,0.7610) 0                        0.19683 (0.16643,0.2266) 0.07477 (0.04868,0.1150)
State 3 0                        0                        0                        1.00000 (1.00000,1.0000)
State 4 0                        0                        0                        0                       

  Total length of stay : 
  State 1   State 2   State 3   State 4 
10.763910  2.742463  2.456092       Inf 

 Expected number of visits to the state : 
  State 1   State 2   State 3   State 4 
1.7662553 2.4248529 0.4772942 1.0000000 
```


## model 2

The model was fitted using the following specification of covariates:
```
# Forward transitions:
  "1-2"       = "age + age_bl + male + educat"
  "2-3"       = "age + age_bl + male + educat"
# Backward transitions:
  "2-1"       = "age + age_bl"
# Death transitions: 
  "1-4"       = "age + age_bl + male"
  "2-4"       = "age + age_bl + male"
  "3-4"       = "age + age_bl + male"
```

### summary

```r
model <- readRDS(paste0(pathSaveFolder,'mB_mod1_2.rds'))
msm_summary(model)
```

```

-2loglik = 14968.52 
Convergence code = 0 
          p   se Wald ChiSq Pr>ChiSq
qbase -1.84 0.11     291.66     0.00
qbase -4.38 0.21     443.15     0.00
qbase -0.18 0.09       4.20     0.04
qbase -2.16 0.19     126.47     0.00
qbase -3.34 0.39      73.46     0.00
qbase -2.46 0.21     132.02     0.00
qcov   0.03 0.01       6.68     0.01
qcov   0.13 0.03      16.23     0.00
qcov  -0.07 0.02      16.29     0.00
qcov   0.09 0.02      14.56     0.00
qcov   0.09 0.05       4.13     0.04
qcov   0.11 0.02      27.53     0.00
qcov   0.05 0.01      12.83     0.00
qcov  -0.05 0.03       2.30     0.13
qcov   0.06 0.02      10.13     0.00
qcov  -0.04 0.02       2.48     0.12
qcov  -0.04 0.05       0.83     0.36
qcov  -0.05 0.02       5.74     0.02
qcov   0.29 0.08      12.61     0.00
qcov   0.43 0.23       3.66     0.06
qcov  -0.17 0.16       1.18     0.28
qcov   0.67 0.28       5.58     0.02
qcov   0.43 0.14       8.99     0.00
qcov  -0.27 0.08      11.42     0.00
qcov  -0.08 0.13       0.33     0.57
p     -2.15 0.09     589.00     0.00
initp -1.33 0.06     434.17     0.00
initp -2.84 0.13     485.99     0.00
```

### details

```r
msm_details(model)
```

```

 Intensity matrix : 
        State 1                      State 2                      State 3                     
State 1 -0.25383 (-0.27272,-0.23624)  0.22304 ( 0.20556, 0.24200) 0                           
State 2  0.62394 ( 0.56441, 0.68975) -0.87084 (-0.94446,-0.80295)  0.17356 ( 0.14719, 0.20467)
State 3 0                            0                            -0.18472 (-0.22930,-0.14881)
State 4 0                            0                            0                           
        State 4                     
State 1  0.03079 ( 0.02487, 0.03812)
State 2  0.07333 ( 0.04913, 0.10945)
State 3  0.18472 ( 0.14881, 0.22930)
State 4 0                           

 Transition probability matrix for t =  2  : 
          State 1   State 2    State 3    State 4
State 1 0.7224250 0.1685856 0.03524712 0.07374225
State 2 0.4716115 0.2560511 0.14211103 0.13022640
State 3 0.0000000 0.0000000 0.69111910 0.30888090
State 4 0.0000000 0.0000000 0.00000000 1.00000000

 Misclassification matrix : 
        State 1 State 2 State 3                 State 4
State 1 1.0000  0       0                       0      
State 2 0       0       0.1042 (0.08908,0.1216) 0      
State 3 0       0       1.0000                  0      
State 4 0       0       0                       1.0000 

 Mean sojourn times : 
        estimates         SE        L        U
State 1  3.939720 0.14429121 3.666826 4.232923
State 2  1.148322 0.04755186 1.058804 1.245409
State 3  5.413553 0.59714750 4.361037 6.720090

 Probability that each state is next : 
        State 1                  State 2                  State 3                  State 4                 
State 1 0                        0.87871 (0.85048,0.9021) 0                        0.12129 (0.09790,0.1495)
State 2 0.71648 (0.67781,0.7473) 0                        0.19931 (0.17053,0.2309) 0.08421 (0.05815,0.1223)
State 3 0                        0                        0                        1.00000 (1.00000,1.0000)
State 4 0                        0                        0                        0                       

  Total length of stay : 
  State 1   State 2   State 3   State 4 
10.635804  2.724037  2.559504       Inf 

 Expected number of visits to the state : 
  State 1   State 2   State 3   State 4 
1.6996345 2.3721879 0.4727955 1.0000000 
```




# Session Info

```r
sessionInfo()
```

```
R version 3.3.1 (2016-06-21)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 14393)

locale:
[1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252    LC_MONETARY=English_United States.1252
[4] LC_NUMERIC=C                           LC_TIME=English_United States.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] msm_1.6.1    magrittr_1.5 nnet_7.3-12  knitr_1.14  

loaded via a namespace (and not attached):
 [1] Rcpp_0.12.6        formatR_1.4        nloptr_1.0.4       plyr_1.8.4         tools_3.3.1        digest_0.6.10     
 [7] lme4_1.1-12        evaluate_0.9       tibble_1.2         gtable_0.2.0       nlme_3.1-128       lattice_0.20-33   
[13] mgcv_1.8-14        Matrix_1.2-7.1     DBI_0.5            yaml_2.1.13        parallel_3.3.1     SparseM_1.7       
[19] mvtnorm_1.0-5      expm_0.999-0       dplyr_0.5.0        stringr_1.1.0      MatrixModels_0.4-1 grid_3.3.1        
[25] R6_2.1.3           survival_2.39-5    rmarkdown_1.0      minqa_1.2.4        ggplot2_2.1.0      car_2.1-3         
[31] scales_0.4.0       htmltools_0.3.5    splines_3.3.1      MASS_7.3-45        assertthat_0.1     pbkrtest_0.4-6    
[37] testit_0.5         colorspace_1.2-6   quantreg_5.26      stringi_1.1.1      lazyeval_0.2.0     munsell_0.4.3     
```





