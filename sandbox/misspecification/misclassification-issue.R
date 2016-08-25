# subset sample for quicker estimation
# set.seed(42)
# ids <- sample(unique(ds_clean$id), 200)
# clean data after encoding multistates
# each person has at least two data points
# and non-missing age at all time points
# object ds_clean is produced by 2-estimate-models-2.R
# ds <- readRDS("./data/unshared/ds_small.rds")
ds <- readRDS("./data/unshared/ds_clean.rds")
head(ds)
# state frequencies
table(ds$state)
# observed transitions
knitr::kable(msm::statetable.msm(state,id,ds))
# define matrix with starting values for transition
q <- .01
# Q <- rbind( c(0,  q,  q,  q), 
#             c(q,  0,  q,  q),
#             c(0,  q,  0,  q), 
#             c(0,  0,  0,  0)) 

Q <- rbind( c(0,  q,  q,  q),
            c(q,  0,  q,  q),
            c(q,  q,  0,  q),
            c(0,  0,  0,  0))

# misclassification matrix
E <- rbind( c(0,  0,  0,  0),  
            c(0,  0,  0,  0), 
            c(.01,  0,  0,  0),
            c(0,  0,  0,  0) )
# transition names
# qnames = c(
#   "Healthy - Mild",  # q12
#   "Health - Severe", # q13
#   "Healthy - Dead",  # q14
#   "Mild - Healthy",  # q21  
#   "Mild - Severe",   # q23
#   "Mild - Dead",     # q24
#   "Severe - Healthy",# q31
#   "Severe - Mild",   # q32
#   "Severe - Dead"    # q34
# )
# set estimation options 
digits = 2
cov_names  = "age"   # string with covariate names
method_    = "Nelder-Mead"  # alternatively, if does not converge "Nedler-Mead" or "BFGS", “CG”, “L-BFGS-B”, “SANN”, “Brent”
constraint = NULL    # additional model constraints
fixedpars  = NULL    # fixed parameters
# construct covariate list
covariates <- as.formula(paste0("~",cov_names))
# estimate model
model <- msm(
  formula       = state ~ age, 
  subject       = id, 
  data          = ds, 
  center        = FALSE,
  qmatrix       = Q, 
  ematrix       = E,
  death         = TRUE, 
  covariates    = covariates,
  censor        = c(-1,-2), 
  censor.states = list(c(1,2,3), c(1,2,3)), 
  method        = method_,
  constraint    = constraint,
  fixedpars     = fixedpars,
  control       = list(trace=0,REPORT=1,maxit=1000,fnscale=10000)
)
# summary(model) 
examine_multistate(model)

msm::summary.msm(model)
summary.elect(
  model, # life expectancy estimated by elect()
  probs = c(.025, .5, .975), # numeric vector of probabilities for quantiles
  digits=2, # number of decimals places in output
  print = TRUE # print toggle
)