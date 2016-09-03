



This report was automatically generated with the R package **knitr**
(version 1.14).

knitr::stitch_rmd(script="./manipulation/map/3-estimate-option-1.R", output="./manipulation/map/3-estimate-option-1.md")## 
## 
## processing file: 3-estimate-option-1.Rmd
## Error in parse_block(g[-1], g[1], params.src): duplicate label 'load-rerequisites'
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!# rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
base::source("./manipulation/map/2-prepare-for-estimation.R") # load  ELECT functions## Before ms encoding: 
##            id   age_bl  male edu age_at_visit mmse age_death
## 7589 75507759 77.51403 FALSE   8     77.51403   30        NA
## 7590 75507759 77.51403 FALSE   8     78.86927   -1        NA
## 7591 75507759 77.51403 FALSE   8     79.75086   30        NA
## 7592 75507759 77.51403 FALSE   8     80.25188   29        NA
## 7593 75507759 77.51403 FALSE   8     81.42094   29        NA
## 7594 75507759 77.51403 FALSE   8     82.66393   -2        NA
## 7595 75507759 77.51403 FALSE   8     83.54552   -2        NA
##      presumed_alive
## 7589           TRUE
## 7590           TRUE
## 7591           TRUE
## 7592           TRUE
## 7593           TRUE
## 7594           TRUE
## 7595           TRUE
## 
## After ms encoding 
##            id   age_bl  male edu      age state presumed_alive
## 7589 75507759 77.51403 FALSE   8 77.51403     1           TRUE
## 7590 75507759 77.51403 FALSE   8 78.86927    -1           TRUE
## 7591 75507759 77.51403 FALSE   8 79.75086     1           TRUE
## 7592 75507759 77.51403 FALSE   8 80.25188     1           TRUE
## 7593 75507759 77.51403 FALSE   8 81.42094     1           TRUE
## 7594 75507759 77.51403 FALSE   8 82.66393    -2           TRUE
## 7595 75507759 77.51403 FALSE   8 83.54552    -2           TRUE
## 
## First observation indicator is added.
##      id   age_bl  male edu      age state presumed_alive educat   educatF
## 1  9121 79.96988 FALSE  12 79.96988     1           TRUE      1 >11 years
## 2  9121 79.96988 FALSE  12 81.08145     1           TRUE      1 >11 years
## 3  9121 79.96988 FALSE  12 81.61259     1           TRUE      1 >11 years
## 4  9121 79.96988 FALSE  12 82.59548     1           TRUE      1 >11 years
## 5  9121 79.96988 FALSE  12 83.62218     1           TRUE      1 >11 years
## 6 33027 81.00753 FALSE  14 81.00753     1           TRUE      1 >11 years
##   firstobs
## 1        1
## 2        0
## 3        0
## 4        0
## 5        0
## 6        1
## 
##  Subject count
##   unique_ids
## 1       1576
## 
##  Frequency of states
## # A tibble: 6 × 3
##   state count   pct
##   <dbl> <int> <dbl>
## 1    -2    78  0.01
## 2    -1   142  0.01
## 3     1  6629  0.65
## 4     2  1584  0.15
## 5     3  1155  0.11
## 6     4   680  0.07
## 
## State table:
##     to
## from   -2   -1    1    2    3    4
##   -2   32    0    0    0    0    0
##   -1    0   25   27   13   27   50
##   1    32   59 4855  715  120  251
##   2     8   20  534  478  257  146
##   3     6   34   24   97  649  233
cat("\n Save fitted models here:")## 
##  Save fitted models here:
pathSaveFolder <- "./data/shared/derived/models/option-1/"
estimate_multistate <- function(
  model_name 
  ,ds                   # data object 
  ,Q                    # Q-matrix of transitions
  ,E                    # misspecification matrix
  ,qnames               # names of the rows in the Q matrix
  ,cov_names            # string with covariate names
){
  covariates_ <- as.formula(paste0("~",cov_names))
  # model <- msm(
  #   formula       = state ~ age, 
  #   subject       = id, 
  #   data          = ds, 
  #   center        = FALSE,
  #   qmatrix       = Q, 
  #   ematrix       = E,
  #   death         = TRUE, 
  #   covariates    = covariates_,
  #   censor        = c(-1,-2), 
  #   censor.states = list(c(1,2,3), c(1,2,3)), 
  #   method        = method_,
  #   constraint    = constraint_,
  #   fixedpars     = fixedpars_,
  #   initprobs     = initprobs_,# c(.67,.16,.11,.07), # initprobs_
  #   est.initprobs = TRUE,
  #   control       = list(trace=0,REPORT=1,maxit=1000,fnscale=10000)
  # )
  model <- paste0("test", covariates_)
  saveRDS(model, paste0(pathSaveFolder,model_name,".rds"))
  return(model)
} 
# transition matrixQ <- rbind( c(0, q, 0, q), 
            c(q, 0, q, q),
            c(0, 0, 0, q), 
            c(0, 0, 0, 0)) # misclassification matrixE <- rbind( c( 0,  0,  0, 0),  
            c( 0,  0, .1, 0), 
            c( 0,  0,  0, 0),
            c( 0,  0,  0, 0) )# transition namesqnames = c(
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
# set estimation options that would be common for all modelsdigits = 2method_  = "BFGS"     # alternatively, if does not converge "Nedler-Mead" constraint_ = NULL    # additional model constraintsfixedpars_ = NULL     # fixed parametersinitprobs_ = initial_probabilities 
# compile model objects with msm() callestimate_multistate("mA1", ds, Q, E, qnames,cov_names = "age")## [1] "test~"   "testage"
estimate_multistate("mA2", ds, Q, E, qnames,cov_names = "age + age_bl")## [1] "test~"            "testage + age_bl"
estimate_multistate("mA3", ds, Q, E, qnames,cov_names = "age + age_bl + male")## [1] "test~"                   "testage + age_bl + male"
estimate_multistate("mA4", ds, Q, E, qnames,cov_names = "age + age_bl + male + educat")## [1] "test~"                            "testage + age_bl + male + educat"
estimate_multistate("mA5", ds, Q, E, qnames,cov_names = "age + age_bl + male + edu")## [1] "test~"                         "testage + age_bl + male + edu"

alive_states <- c(1,2,3)ds_alive <- ds[ds$state %in% alive_states,]age_min <- 0age_max <- 30age_bl <- 0male <- 0edu <- 0replication_n <- 100time_scale <- "years"grid_par <- .5
models <- list()models[["msm"]][["age"]]    <- readRDS(paste0(pathSaveFolder,'mA1.rds'))models[["msm"]][["age_bl"]] <- readRDS(paste0(pathSaveFolder,'mA2.rds'))models[["msm"]][["male"]]   <- readRDS(paste0(pathSaveFolder,'mA3.rds'))models[["msm"]][["educat"]] <- readRDS(paste0(pathSaveFolder,'mA4.rds'))models[["msm"]][["edu"]]    <- readRDS(paste0(pathSaveFolder,'mA5.rds'))for(model_ in names(models)){
  # determine covariate list
  if(model_=="age"){covar_list    = list(age=age_min)}
  if(model_=="age_bl"){covar_list = list(age=age_min, age_bl=age_bl)}
  if(model_=="male"){covar_list   = list(age=age_min, age_bl=age_bl, male=male)}
  if(model_=="educat"){covar_list = list(age=age_min, age_bl=age_bl, male=male, educat=educat)}
  if(model_=="edu"){covar_list    = list(age=age_min, age_bl=age_bl, male=male, edu=edu)}
  # compute LE
  models[[model_]][["LE"]] <- elect(
    model          = models[["msm"]][[model_]], # fitted msm model
    b.covariates   = covar_list, # list with specified covarites values
    statedistdata  = ds_alive, # data for distribution of living states
    time.scale.msm = time_scale, # time scale in multi-state model ("years", ...)
    h              = grid_par, # grid parameter for integration
    age.max        = age_max, # assumed maximum age in years
    S              = replication_n # number of simulation cycles
  )
  # models[[model_]][["LE"]] <- models[["msm"]][[model_]] 
}## Error in if (model$center == TRUE) {: argument is of length zero
# save models estimated by elect() in a external object for faster access in the future saveRDS(models, paste0(pathSaveFolder,"models.rds")) models <- readRDS(paste0(pathSaveFolder,"models.rds"))lapply(models, names)## $msm
## [1] "age"    "age_bl" "male"   "educat" "edu"


The R session information (including the OS info, R version and all
packages used):

sessionInfo()## R version 3.3.1 (2016-06-21)
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
## [1] magrittr_1.5 nnet_7.3-12  msm_1.6.1   
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.6        knitr_1.14         splines_3.3.1     
##  [4] MASS_7.3-45        munsell_0.4.3      testit_0.5        
##  [7] colorspace_1.2-6   lattice_0.20-33    R6_2.1.3          
## [10] minqa_1.2.4        stringr_1.1.0      car_2.1-3         
## [13] plyr_1.8.4         dplyr_0.5.0        tools_3.3.1       
## [16] parallel_3.3.1     pbkrtest_0.4-6     grid_3.3.1        
## [19] gtable_0.2.0       nlme_3.1-128       mgcv_1.8-14       
## [22] quantreg_5.26      DBI_0.5            MatrixModels_0.4-1
## [25] survival_2.39-5    lme4_1.1-12        lazyeval_0.2.0    
## [28] assertthat_0.1     tibble_1.2         Matrix_1.2-7.1    
## [31] formatR_1.4        nloptr_1.0.4       ggplot2_2.1.0     
## [34] evaluate_0.9       stringi_1.1.1      scales_0.4.0      
## [37] SparseM_1.7        expm_0.999-0       mvtnorm_1.0-5     
## [40] markdown_0.7.7
Sys.time()## [1] "2016-09-03 14:37:31 PDT"


