#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load-sources ------------------------------------------------------------
# base::source("http://www.ucl.ac.uk/~ucakadl/ELECT/ELECT.r") # load  ELECT functions
base::source("./scripts/ELECT.r") # load  ELECT functions
base::source("./scripts/ELECT-utility-functions.R") # ELECT utility functions
# ---- load-packages -----------------------------------------------------------
library(magrittr) #Pipes
library(msm)
requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) 
requireNamespace("testit", quietly=TRUE)

# ---- declare-globals ---------------------------------------------------------
pathSaveFolder <- "./data/shared/derived/models/model-b-mod-2/"
digits = 2
cat("\n Save fitted models here : \n")
print(pathSaveFolder)


# ---- load-data ---------------------------------------------------------------
ds_clean <- readRDS("./data/unshared/ds_clean.rds")
ds <- readRDS("./data/unshared/ds_estimation.rds") # same ids but fewer variables

# assemble the list object with the results of msm estimation
pathSaveFolder <- "./data/shared/derived/models/model-b-mod-2/"
# models <- list()
# assing each model a code name, limit to a few models, see specs in 2-estimate-models.R
# models[["m1"]][["msm"]] <- readRDS(paste0(pathSaveFolder,'mB_mod2_1.rds'))
# models[["m2"]][["msm"]] <- readRDS(paste0(pathSaveFolder,'mB_mod2_2.rds'))
# models[["m3"]][["msm"]] <- readRDS(paste0(pathSaveFolder,'mB_mod2_3.rds'))
# models[["m4"]][["msm"]] <- readRDS(paste0(pathSaveFolder,'mB_mod2_4.rds'))

# model <- models[["educat"]][["msm"]]
# model <- models[["m3"]][["msm"]]

# for use with a single model:
# model_name <- "mB_mod2_3"
# model <- list()
# model[["msm"]] <- readRDS(paste0(pathSaveFolder,model_name,'.rds'))


# ---- inspect-data -------------------------------------------------------------

# ---- define-support-functions ----------------------

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

# ---- define-le-functions ---------------

# wrapper function to compute a single conditional Life Expectancy
compute_one_condition <- function(msm_model, age_min, age_max,ds_, alive,  ds_levels, condition_n){
  # assemble the levels of the covariates
  covar_list <- list(
    age    = age_min
    # ,age_bl = ds_levels[condition_n,"age_bl"] 
    ,male   = ds_levels[condition_n, "male"]
    ,educat = ds_levels[condition_n, "educat"]
    ,sescat = ds_levels[condition_n, "sescat"] 
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

# wrapper function to compute ALL conditional LEs for a given set of covariate conditions
compute_conditional_les <- function(
  folder,
  model_name,
  age_min,
  age_max,
  ds_levels,
  condition_n = "all"
){
  model_path_in  <- paste0(folder,model_name,   '.rds') # msm object
  model_path_out <- paste0(folder,model_name,'_le.rds') # msm + elect objects
  model <- list() # initiate the list object
  model[["msm"]] <- readRDS(model_path_in) # import msm model object
  # store conditional levels of covariates for future reference
  model[["levels"]] <- ds_levels
  # loop through all conditional values of covariates
  if(condition_n == "all"){
    tested_conditions <- 1:nrow(ds_levels) 
  }else{
    tested_conditions <- condition_n
  }
  for(i in tested_conditions){  
    condition_number <- paste0(as.character(i))
    model[["le"]][[condition_number]] <- compute_one_condition(
      msm_model   = model[["msm"]], 
      age_min     = age_min, 
      age_max     = age_max,
      ds_levels   = ds_levels, 
      condition_n = i
    ) 
  }
  # return(model)
  saveRDS(model,model_path_out)
}

# ---- assemble-covariate-levels ----------------------
# age_bl_possible <- seq(from=-10, to=10, by=10) 
male_possible <- c(0, 1)
educat_possible <- c(-1,0,1)
sescat_possible <- c(-1,0,1)

ds_levels <- tidyr::crossing(
  # age_bl = age_bl_possible 
  male   = male_possible   
  ,educat = educat_possible
  ,sescat = sescat_possible
) %>% as.data.frame() 

ds_levels %>% print()

# ---- specify-elect-options --------------------------
alive_states <- c(1,2,3)
ds_alive <- ds[ds$state %in% alive_states,]

grid_par <- .5
time_scale <- "years"
replication_n <- 1000

# ---- compute-life-expectancies -------------------
compute_conditional_les(
  folder =  "./data/shared/derived/models/model-b-mod-2/",
  model_name = "mB_mod2_3",
  age_min = 0,
  age_max = 35,
  ds_levels = ds_levels,
  condition_n = "all"
)

# ---- inspect-computed-le -----------------------
model <- readRDS("./data/shared/derived/models/model-b-mod-2/mB_mod2_3_le.rds")
lapply(model, names)
model$levels

le <- model$le[[1]]

summary.elect(le)
plot.elect(le)
print_hazards(model$msm)

############# code for testing and re-learning below ------------
# ---- simple-le-review ---------------

model <- readRDS(paste0(pathSaveFolder,'mB_mod2_3.rds'))
# model <- readRDS(paste0(pathSaveFolder,'mB_mod2_4.rds'))


msm_model <- model
msm_summary(msm_model)
msm_details(msm_model)
print_hazards(msm_model,T)

# elect options
age_min <- 0 # 75
age_max <- 35 # 110
# age_bl <- -20 # 55
male <- 0
educat <- 0
sescat <- 0

covar_list = list(age=age_min, male=male, educat=educat, sescat=sescat)

LE <- elect(
  model          = msm_model, # fitted msm model
  b.covariates   = covar_list, # list with specified covarites values
  statedistdata  = ds_alive, # data for distribution of living states
  time.scale.msm = time_scale, # time scale in multi-state model ("years", ...)
  h              = grid_par, # grid parameter for integration
  age.max        = age_max, # assumed maximum age in years
  S              = replication_n # number of simulation cycles
)

summary.elect(
  LE, # life expectancy estimated by elect()
  probs = c(.025, .5, .975), # numeric vector of probabilities for quantiles
  digits=2, # number of decimals places in output
  print = TRUE # print toggle
)

plot.elect(LE)

# ---- open-function-to-compute-le ---------------------
model_name <- "mB_mod2_3"
model_path_in  <- paste0(pathSaveFolder,model_name,   '.rds') # msm object
model_path_out <- paste0(pathSaveFolder,model_name,'_le.rds') # msm + elect objects

model <- list()
model[["msm"]] <- readRDS(model_path_in)
print_hazards(model[["msm"]]) # verify class
model %>% names() ; model %>% class()

# store conditional levels of covariates for future reference
model[["LE"]][["levels"]] <- ds_levels
# loop through all conditional values of covariates
for(i in 1:nrow(ds_levels)){
  # for(i in 1:3 ){
  condition_number <- paste0(as.character(i))
  model[["LE"]][[condition_number]] <- compute_one_le(
    msm_model   = model[["msm"]], 
    age_min     = 0, 
    age_max     = 35,
    ds_levels   = ds_levels, 
    condition_n = i
  )  
}
