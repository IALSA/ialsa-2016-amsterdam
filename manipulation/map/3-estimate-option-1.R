# knitr::stitch_rmd(script="./manipulation/map/3-estimate-option-1.R", output="./manipulation/map/3-estimate-option-1.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
# rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load-rerequisites ------------------------------------------------------------
base::source("./manipulation/map/2-prepare-for-estimation.R") # load  ELECT functions

cat("\n Save fitted models here:")
pathSaveFolder <- "./data/shared/derived/models/option-1/"

# ----- define-estimation-function --------------------------
estimate_multistate <- function(
  model_name 
  ,ds                   # data object 
  ,Q                    # Q-matrix of transitions
  ,E                    # misspecification matrix
  ,qnames               # names of the rows in the Q matrix
  ,cov_names            # string with covariate names
){
  covariates_ <- as.formula(paste0("~",cov_names))
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
    initprobs     = initprobs_,# c(.67,.16,.11,.07), # initprobs_
    est.initprobs = TRUE,
    control       = list(trace=0,REPORT=1,maxit=1000,fnscale=10000)
  )
  # model <- paste0("test", covariates_)
  saveRDS(model, paste0(pathSaveFolder,model_name,".rds"))
  return(model)
} 

# ---- specify-model --------------------------
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

# ---- specify-msm-options --------------------------
digits = 2
method_  = "BFGS"     # alternatively, if does not converge "Nedler-Mead" 
constraint_ = NULL    # additional model constraints
fixedpars_ = NULL     # fixed parameters
initprobs_ = initial_probabilities 

# ---- estimate-msm-models ------------------------
# compile model objects with msm() call
estimate_multistate("mA1", ds, Q, E, qnames,cov_names = "age")
estimate_multistate("mA2", ds, Q, E, qnames,cov_names = "age + age_bl")
estimate_multistate("mA3", ds, Q, E, qnames,cov_names = "age + age_bl + male")
estimate_multistate("mA4", ds, Q, E, qnames,cov_names = "age + age_bl + male + educat")
estimate_multistate("mA5", ds, Q, E, qnames,cov_names = "age + age_bl + male + edu")


# ---- specify-elect-options --------------------------
alive_states <- c(1,2,3)
ds_alive <- ds[ds$state %in% alive_states,]

age_min <- 0
age_max <- 35
age_bl <- 0
male <- 0
educat <- 0
edu <- 11

replication_n <- 100
time_scale <- "years"
grid_par <- .5

# ---- compute-life-expectancies -------------------

models <- list()
models[["msm"]][["age"]]    <- readRDS(paste0(pathSaveFolder,'mA1.rds'))
models[["msm"]][["age_bl"]] <- readRDS(paste0(pathSaveFolder,'mA2.rds'))
models[["msm"]][["male"]]   <- readRDS(paste0(pathSaveFolder,'mA3.rds'))
models[["msm"]][["educat"]] <- readRDS(paste0(pathSaveFolder,'mA4.rds'))
models[["msm"]][["edu"]]    <- readRDS(paste0(pathSaveFolder,'mA5.rds'))

for(model_ in names(models)){
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
}
  
# save models estimated by elect() in a external object for faster access in the future 
saveRDS(models, paste0(pathSaveFolder,"models.rds")) 
models <- readRDS(paste0(pathSaveFolder,"models.rds"))
lapply(models, names)








