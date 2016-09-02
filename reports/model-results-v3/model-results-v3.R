# knitr::stitch_rmd(script="./manipulation/rename-classify.R", output="./manipulation/rename-classify.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load-sources ------------------------------------------------------------
base::source("http://www.ucl.ac.uk/~ucakadl/ELECT/ELECT.r") # load  ELECT functions
base::source("./scripts/ELECT-utility-functions.R") # ELECT utility functions
# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) #Pipes
library(msm)
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit", quietly=TRUE)
# requireNamespace("plyr", quietly=TRUE)

# ---- declare-globals ---------------------------------------------------------
path_input <- "./data/unshared/ds_clean.rds"

# ---- load-data ---------------------------------------------------------------
# load the data objects passed to estimation routine
ds <- readRDS(path_input)

models_A <- readRDS("./data/shared/derived/models/version-3/models_A.rds")
models_B <- readRDS("./data/shared/derived/models/version-3/models_B.rds")
models_C <- readRDS("./data/shared/derived/models/version-3/models_C.rds")



# ---- inspect-data -------------------------------------------------------------
head(ds)
models <- models_A
lapply(models, names)


# ---- describe-age-composition -----------
(N <- length(unique(ds_clean$id)))
subjects <- as.numeric(unique(ds_clean$id))


# Time intervals in data:
# the age difference between timepoint for each individual
intervals <- matrix(NA,nrow(ds_clean),2)
for(i in 2:nrow(ds_clean)){
  if(ds_clean$id[i]==ds$id[i-1]){
    intervals[i,1] <- ds$id[i]
    intervals[i,2] <- ds$age[i]-ds$age[i-1]
  }
  intervals <- as.data.frame(intervals)
  colnames(intervals) <- c("id", "interval")
}
head(intervals)

# the age difference between timepoint for each individual
# Remove the N NAs:
intervals <- intervals[!is.na(intervals[,2]),]
cat("\nTime intervals between observations within individuals:\n")
print(round(quantile(intervals[,2]),digits))

# Info on age and time between observations:
opar<-par(mfrow=c(1,3), mex=0.8,mar=c(5,5,3,1))
hist(ds$age[ds$firstobs==1],col="red",xlab="Age at baseline in years",main="")
hist(ds$age,col="blue",xlab="Age in data in years",main="")
hist(intervals[,2],col="green",xlab="Time intervals in data in years",main="")
opar<-par(mfrow=c(1,1), mex=0.8,mar=c(5,5,2,1))


# ---- model-specification-object --------------------------
source("./manipulation/map/model-specification-v3.R")
mspec <- model_specification
names(mspec)
mspec$A



# ---- msm-options -------------------
# set estimation options that would be common for all models
digits = 2
# cov_names  = "age"   # string with covariate names
method_    = "BFGS"  # alternatively, if does not converge "Nedler-Mead" or "BFGS", “CG”, “L-BFGS-B”, “SANN”, “Brent”
constraint_ = NULL    # additional model constraints
fixedpars_  = NULL       # fixed parameters
# covariates_ <- as.formula(paste0("~",cov_names)) # construct covariate list
initprobs_ # initial probabilities, observed freqs, computed above

# ---- estimate-models-A ------------------------
# define specification matrices
(Q      <- model_specification[["A"]][["Q"]])
(E      <- model_specification[["A"]][["E"]])
(qnames <- model_specification[["A"]][["qnames"]])
# compile model objects with msm() call
mA1 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age")
mA2 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl")
mA3 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl + male")
mA4 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl + male + educat")
mA4_edu <- estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl + male + edu")

# save models estimated by msm() in a external object for faster access in the future
models_A <- list("age"    = mA1, 
                 "age_bl" = mA2, 
                 "male"   = mA3, 
                 "educat" = mA4, 
                 "edu"    = mA4_edu) # turn of after estimation
saveRDS(models_A,     "./data/shared/derived/models/version-3/models_A.rds")           # turn of after estimation
models_A <- readRDS("./data/shared/derived/models/version-3/models_A.rds")
lapply(models_A, names)


# ---- estimate-models-B ------------------------
# define specification matrices
(Q      <- model_specification[["B"]][["Q"]])
(E      <- model_specification[["B"]][["E"]])
(qnames <- model_specification[["B"]][["qnames"]])
# compile model objects with msm() call
mB1 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age")
mB2 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl")
mB3 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl + male")
mB4 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl + male + educat")
mB4_edu <- estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl + male + edu")

# save models estimated by msm() in a external object for faster access in the future
models_B <- list("age"    = mB1, 
                 "age_bl" = mB2, 
                 "male"   = mB3, 
                 "educat" = mB4, 
                 "edu"    = mB4_edu) # turn of after estimation
saveRDS(models_B,     "./data/shared/derived/models/version-3/models_B.rds")           # turn of after estimation
models_B <- readRDS("./data/shared/derived/models/version-3/models_B.rds")
lapply(models_B, names)

# ---- estimate-models-C ------------------------
# define specification matrices
(Q      <- model_specification[["C"]][["Q"]])
(E      <- model_specification[["C"]][["E"]])
(qnames <- model_specification[["C"]][["qnames"]])
# compile model objects with msm() call
mC1 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age")
mC2 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl")
mC3 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl + male")
mC4 <-     estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl + male + educat")
mC4_edu <- estimate_multistate(ds, Q, E, qnames,cov_names = "age + age_bl + male + edu")

# save models estimated by msm() in a external object for faster access in the future
models_C <- list("age"    = mC1, 
                 "age_bl" = mC2, 
                 "male"   = mC3, 
                 "educat" = mC4, 
                 "edu"    = mC4_edu) # turn of after estimation
saveRDS(models_C,     "./data/shared/derived/models/version-3/models_C.rds")           # turn of after estimation
models_C <- readRDS("./data/shared/derived/models/version-3/models_C.rds")
lapply(models_C, names)




# ---- compute-LE-1 -------------------
alive_states <- c(1,2,3)
ds_alive <- ds[ds$state %in% alive_states,]

age_min <- 0
age_max <- 30
age_bl <- 0
male <- 0
edu <- 0

replication_n <- 100
time_scale <- "years"
grid_par <- .5

# turn off estimation lines after the first run 

for(model_ in names(models)){
  # determine covariate list
  if(model_=="age"){covar_list= list(age=age_min)}
  if(model_=="age_bl"){covar_list = list(age=age_min, age_bl=age_bl)}
  if(model_=="male"){covar_list = list(age=age_min, age_bl=age_bl, male=male)}
  if(model_=="edu"){covar_list = list(age=age_min, age_bl=age_bl, male=male, edu=edu)}
  # compute LE
  models[[model_]][["LE"]] <- elect(
    model=models[[model_]][["msm"]], # fitted msm model
    b.covariates=covar_list, # list with specified covarites values
    statedistdata=ds_alive, # data for distribution of living states
    time.scale.msm=time_scale, # time scale in multi-state model ("years", ...)
    h=grid_par, # grid parameter for integration
    age.max=age_max, # assumed maximum age in years
    S=replication_n # number of simulation cycles
  )
}

# save models estimated by elect() in a external object for faster access in the future 
# saveRDS(models, "./data/shared/derived/models_LE.rds")
models <- readRDS("./data/shared/derived/models_LE.rds")
lapply(models, names)


# ---- compute-LE-2 -------------------
alive_states <- c(1,2,3)
ds_alive <- ds[ds$state %in% alive_states,]

age_min <- 0
age_max <- 50
age_bl <- 0
male <- 0
edu <- 9

replication_n <- 50
time_scale <- "years"
grid_par <- .5

# turn off estimation lines after the first run 

# for(model_ in names(models)){
#   # determine covariate list
#   if(model_=="age"){covar_list= list(age=age_min)}
#   if(model_=="age_bl"){covar_list = list(age=age_min, age_bl=age_bl)}
#   if(model_=="male"){covar_list = list(age=age_min, age_bl=age_bl, male=male)}
#   if(model_=="edu"){covar_list = list(age=age_min, age_bl=age_bl, male=male, edu=edu)}
#   # compute LE
#   models[[model_]][["LE"]] <- elect(
#     model=models[[model_]][["msm"]], # fitted msm model
#     b.covariates=covar_list, # list with specified covarites values
#     statedistdata=ds_alive, # data for distribution of living states
#     time.scale.msm=time_scale, # time scale in multi-state model ("years", ...)
#     h=grid_par, # grid parameter for integration
#     age.max=age_max, # assumed maximum age in years
#     S=replication_n # number of simulation cycles
#   )
# }
# 
# # save models estimated by elect() in a external object for faster access in the future 
# saveRDS(models, "./data/shared/derived/models_LE-2.rds")
models <- readRDS("./data/shared/derived/models_LE-2.rds")
lapply(models, names)

# ---- results-1-1 ----------------
model <- models[["age"]]
examine_multistate(model$msm)
# ---- results-1-2 ----------------
print(model$msm, showEnv= F)

# ---- results-1-3 ----------------
summary.elect(
  model$LE, # life expectancy estimated by elect()
  probs = c(.025, .5, .975), # numeric vector of probabilities for quantiles
  digits=2, # number of decimals places in output
  print = TRUE # print toggle
)
# ---- results-1-4 ----------------
plot.elect(
  model$LE, # life expectancy estimated by elect()
  kernel = "gaussian", #character string for smoothing kernal ("gaussian",...)
  col = "red", # color of the curve
  lwd = 2, # line width of the curve
  cex.lab = 1 # magnification to be used for axis-labels
)


# ---- results-2-1 ----------------
model <- models[["age_bl"]]
examine_multistate(model$msm)
# ---- results-2-2 ----------------
print(model$msm, showEnv= F)

# ---- results-2-3 ----------------
summary.elect(
  model$LE, # life expectancy estimated by elect()
  probs = c(.025, .5, .975), # numeric vector of probabilities for quantiles
  digits=2, # number of decimals places in output
  print = TRUE # print toggle
)
# ---- results-2-4 ----------------
plot.elect(
  model$LE, # life expectancy estimated by elect()
  kernel = "gaussian", #character string for smoothing kernal ("gaussian",...)
  col = "red", # color of the curve
  lwd = 2, # line width of the curve
  cex.lab = 1 # magnification to be used for axis-labels
)



# ---- results-3-1 ----------------
model <- models[["male"]]
examine_multistate(model$msm)
# ---- results-3-2 ----------------
print(model$msm, showEnv= F)

# ---- results-3-3 ----------------
summary.elect(
  model$LE, # life expectancy estimated by elect()
  probs = c(.025, .5, .975), # numeric vector of probabilities for quantiles
  digits=2, # number of decimals places in output
  print = TRUE # print toggle
)
# ---- results-3-4 ----------------
plot.elect(
  model$LE, # life expectancy estimated by elect()
  kernel = "gaussian", #character string for smoothing kernal ("gaussian",...)
  col = "red", # color of the curve
  lwd = 2, # line width of the curve
  cex.lab = 1 # magnification to be used for axis-labels
)



# ---- results-4-1 ----------------
model <- models[["edu"]]
examine_multistate(model$msm)
# ---- results-4-2 ----------------
print(model$msm, showEnv= F)

# ---- results-4-3 ----------------
summary.elect(
  model$LE, # life expectancy estimated by elect()
  probs = c(.025, .5, .975), # numeric vector of probabilities for quantiles
  digits=2, # number of decimals places in output
  print = TRUE # print toggle
)
# ---- results-4-4 ----------------
plot.elect(
  model$LE, # life expectancy estimated by elect()
  kernel = "gaussian", #character string for smoothing kernal ("gaussian",...)
  col = "red", # color of the curve
  lwd = 2, # line width of the curve
  cex.lab = 1 # magnification to be used for axis-labels
)






























# ---- print-model-results ----------------

for(model_ in names(models)){
  # model_ <- "age_bl"
  model <- models[[model_]]
  
  cat("\n## ", model_,"\n")
  print(model$msm$covariates, showEnv = F)
  cat("\n### summary msm()\n")
  examine_multistate(model$msm)
  cat("\n### solution\n")
  print(model$msm, showEnv= F)
  cat("\n### summary elect()\n")
  summary.elect(
    model$LE, # life expectancy estimated by elect()
    probs = c(.025, .5, .975), # numeric vector of probabilities for quantiles
    digits=2, # number of decimals places in output
    print = TRUE # print toggle
  )
  cat("\n### plots\n")
  plot.elect(
    model$LE, # life expectancy estimated by elect()
    kernel = "gaussian", #character string for smoothing kernal ("gaussian",...)
    col = "red", # color of the curve
    lwd = 2, # line width of the curve
    cex.lab = 1 # magnification to be used for axis-labels
  )
  
}
# ---- individual-inspection ------------------

model <- models$age_bl$msm # object produced by msm
model_LE <- models$age_bl$LE # object produced by elect
# examine 
examine_multistate(model$msm)
print(model$msm)
summary.elect(
  model$LE, # life expectancy estimated by elect()
  probs = c(.025, .5, .975), # numeric vector of probabilities for quantiles
  digits=2, # number of decimals places in output
  print = TRUE # print toggle
)

plot.elect(
  model$LE, # life expectancy estimated by elect()
  kernel = "gaussian", #character string for smoothing kernal ("gaussian",...)
  col = "red", # color of the curve
  lwd = 2, # line width of the curve
  cex.lab = 1 # magnification to be used for axis-labels
)










