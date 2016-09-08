#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load-sources ------------------------------------------------------------
base::source("http://www.ucl.ac.uk/~ucakadl/ELECT/ELECT.r") # load  ELECT functions
base::source("./scripts/ELECT-utility-functions.R") # ELECT utility functions
# ---- load-packages -----------------------------------------------------------
library(magrittr) #Pipes
library(msm)
requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) 
requireNamespace("testit", quietly=TRUE)

# ---- declare-globals ---------------------------------------------------------
pathSaveFolder <- "./data/shared/derived/models/model-a/"
digits = 2
cat("\n Save fitted models here : \n")
print(pathSaveFolder)


# ---- load-data ---------------------------------------------------------------
ds_clean <- readRDS("./data/unshared/ds_clean.rds")
# assemble the list object with the results of msm estimation
pathSaveFolder <- "./data/shared/derived/models/model-a/"
models <- list()
models[["age"]][["msm"]]    <- readRDS(paste0(pathSaveFolder,'mA1.rds'))
models[["age_bl"]][["msm"]] <- readRDS(paste0(pathSaveFolder,'mA2.rds'))
models[["male"]][["msm"]]   <- readRDS(paste0(pathSaveFolder,'mA3.rds'))
models[["educat"]][["msm"]] <- readRDS(paste0(pathSaveFolder,'mA4.rds'))
mA <- models

# assemble the list object with the results of msm estimation
pathSaveFolder <- "./data/shared/derived/models/model-b/"
models <- list()
models[["age"]][["msm"]]    <- readRDS(paste0(pathSaveFolder,'mB1.rds'))
models[["age_bl"]][["msm"]] <- readRDS(paste0(pathSaveFolder,'mB2.rds'))
models[["male"]][["msm"]]   <- readRDS(paste0(pathSaveFolder,'mB3.rds'))
models[["educat"]][["msm"]] <- readRDS(paste0(pathSaveFolder,'mB4.rds'))
mB <- models

# ---- inspect-data -------------------------------------------------------------
summary(ds_clean$age)
summary(ds_clean$age_bl)

#---- define-support-functions ----------------------

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


# ----- le-general-function ---------------------------
model <- models


le_spread <- function(
  msm_model, 
  age_min, 
  age_max, 
  ds_levels,
  condition_n
){
  # assemble the levels of the covariates
  covar_list <- list(
    age    = age_min,
    age_bl = ds_levels[condition_n,"age_bl"],
    male   = ds_levels[condition_n, "male"],
    educat = ds_levels[condition_n, "educat"]
  )
  # estimate Life Expectancies
  LE <- elect(
    model          = msm_model, # fitted msm model
    b.covariates   = covar_list, # list with specified covarites values
    statedistdata  = ds_alive, # data for distribution of living states
    time.scale.msm = time_scale, # time scale in multi-state model ("years", ...)
    h              = grid_par, # grid parameter for integration
    age.max        = age_max, # assumed maximum age in years
    S              = replication_n # number of simulation cycles
  )
  return(LE)
}


# ---- assemble-covariate-levels ----------------------
age_bl_possible <- seq(from=-20, to=20, by= 5) 
male_possible <- c(0, 1)
educat_possible <- c(-1,0,1)

ds_levels <- as.data.frame(tidyr::crossing(
  age_bl   =   age_bl_possible, 
  male   =   male_possible ,  
  educat =   educat_possible 
)) 

age_bl <- ds_levels[1,"age_bl"]
male   <- ds_levels[1,"male"]
educat <- ds_levels[1,"educat"]


# ---- specify-elect-options --------------------------
alive_states <- c(1,2,3)
ds_alive <- ds[ds$state %in% alive_states,]
fixedpars <- fixedpars_


summary(ds_clean$age)
summary(ds_clean$age_bl)

# age centered at 75
# age_bl centered at 75 

age_min <- 0 # 75
age_max <- 35 # 110
age_bl <- -20 # 55
male <- 0
educat <- 0


replication_n <- 1000
time_scale <- "years"
grid_par <- .5

covar_list = list(age=age_min, age_bl=age_bl, male=male, educat=educat)

LE <- elect(
  model          = msm_model, # fitted msm model
  b.covariates   = covar_list, # list with specified covarites values
  statedistdata  = ds_alive, # data for distribution of living states
  time.scale.msm = time_scale, # time scale in multi-state model ("years", ...)
  h              = grid_par, # grid parameter for integration
  age.max        = age_max, # assumed maximum age in years
  S              = replication_n # number of simulation cycles
)












A <- models

msm <- models$educat$msm
m <- les$`1`

summary.elect(
  m, # life expectancy estimated by elect()
  probs = c(.025, .5, .975), # numeric vector of probabilities for quantiles
  digits=2, # number of decimals places in output
  print = TRUE # print toggle
)


conditions <- list()
conditions[["levels"]] <- ds_levels

one_le <- function(msm_model, age_min, age_max, ds_levels, condition_n){
  # assemble the levels of the covariates
  covar_list <- list(
    age    = age_min,
    age_bl = ds_levels[condition_n,"age_bl"],
    male   = ds_levels[condition_n, "male"],
    educat = ds_levels[condition_n, "educat"]
  )
  # estimate Life Expectancies
  LE <- elect(
    model          = msm_model, # fitted msm model
    b.covariates   = covar_list, # list with specified covarites values
    statedistdata  = ds_alive, # data for distribution of living states
    time.scale.msm = time_scale, # time scale in multi-state model ("years", ...)
    h              = grid_par, # grid parameter for integration
    age.max        = age_max, # assumed maximum age in years
    S              = replication_n # number of simulation cycles
  )
  return(LE)
}

les <- list()
les[["levels"]] <- ds_levels
for(i in 1:nrow(ds_levels)){
  
  les[[paste0(as.character(i))]] <- one_le(models$educat$msm, 0, 35, ds_levels, i)  

}




# ---- elect-general-function ---------------


# ---- compute-life-expectancies -------------------
# turn this chunk OFF when printing the report
for(model_ in names(models) ){
  # determine covariate list
  # if(model_=="age"){covar_list    = list(age=age_min)}
  # if(model_=="age_bl"){covar_list = list(age=age_min, age_bl=age_bl)}
  # if(model_=="male"){covar_list   = list(age=age_min, age_bl=age_bl, male=male)}
  if(model_=="educat"){covar_list = list(age=age_min, age_bl=age_bl, male=male, educat=educat)}
  # compute LE
  models[[model_]][["LE"]] <- elect(
    model          = models[[model_]][["msm"]], # fitted msm model
    b.covariates   = covar_list, # list with specified covarites values
    statedistdata  = ds_alive, # data for distribution of living states
    time.scale.msm = time_scale, # time scale in multi-state model ("years", ...)
    h              = grid_par, # grid parameter for integration
    age.max        = age_max, # assumed maximum age in years
    S              = replication_n # number of simulation cycles
  )
}
#save models estimated by elect() in a external object for faster access in the future
saveRDS(models, paste0(pathSaveFolder,"models.rds"))




# ---- compute-life-expectancies -------------------
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




