# ---- load-data ------------------
ds_clean <- readRDS("./data/unshared/ds_clean.rds")
head(ds_clean)
# base::source("http://www.ucl.ac.uk/~ucakadl/ELECT/ELECT.r") # load  ELECT functions
base::source("./scripts/ELECT-utility-functions.R") # ELECT utility functions
base::source("./scripts/ELECT.R")

# ---- prepare-for-estimation --------------------
set.seed(42)
ids <- sample(unique(ds_clean$id), 100)
ds <- ds_clean %>% 
  # dplyr::filter(id %in% ids) %>%
  dplyr::mutate(
    male = as.numeric(male), 
    # age      = age,
    # age_bl   = age_bl
    # age    = (age - 80)/20,
    # age_bl = (age_bl - 80)/20
    age    = (age - 75),
    age_bl = (age_bl - 75)
    # age    = age/20,
    # age_bl = age_bl/20
  )
head(ds)

# ---- exclude-persons -----------------------



# ---- msm-options -------------------
# set estimation options 
digits = 2
cov_names  = "age"   # string with covariate names
method_    = "BFGS"  # alternatively, if does not converge "Nedler-Mead" or "BFGS", “CG”, “L-BFGS-B”, “SANN”, “Brent”
constraint = NULL    # additional model constraints
fixedpars  = NULL    # fixed parameters

q <- .01
# transition matrix
Q <- rbind( c(0, q, q, q), 
            c(q, 0, q, q),
            c(q, q, 0, q), 
            c(0, 0, 0, 0)) 
# misclassification matrix
E <- rbind( c(0, 0, 0, 0),  
            c(0, 0, 0, 0), 
            c(0, 0, 0, 0),
            c(0, 0, 0, 0) )
# transition names
qnames = c(
  "Healthy - Mild",  # q12
  "Healthy - Severe", # q13
  "Healthy - Dead",  # q14
  "Mild - Healthy",  # q21  
  "Mild - Severe",   # q23
  "Mild - Dead",     # q24
  "Severe - Healthy",# q31
  "Severe - Mild",   # q32
  "Severe - Dead"    # q34
)
# construct covariate list
covariates <- as.formula(paste0("~",cov_names))

# ---- msm-estimation --------------------------
# estimate model
msm_model <- msm(
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
# summary(msm_model) 
examine_multistate(msm_model)
msm::summary.msm(msm_model)
print(msm_model)

# ---- LE-options ---------------------------
alive_states <- c(1,2,3)
ds_alive <- ds[ds$state %in% alive_states,]

age_min <- 0
age_max <- 50 
age_bl <- 0
male <- 0
edu <- 9

replication_n <- 50 # keep low (50-100) during testing stage
time_scale <- "years"
grid_par <- .5

covar_list <- list(age=age_min)

# ---- LE-estimation ----------------------------
LE <- elect(
  model          = msm_model,    # fitted msm model
  b.covariates   = covar_list,   # list with specified covarites values
  statedistdata  = ds_alive,     # data for distribution of living states
  time.scale.msm = time_scale,   # time scale in multi-state model ("years", ...)
  h              = grid_par,     # grid parameter for integration
  age.max        = age_max,      # assumed maximum age in years
  S              = replication_n # number of simulation cycles
)

# ----- examine-LE-object -----------------
summary.elect(
  LE, # life expectancy estimated by elect()
  probs = c(.025, .5, .975), # numeric vector of probabilities for quantiles
  digits=2, # number of decimals places in output
  print = TRUE # print toggle
)

plot.elect(
  LE, # life expectancy estimated by elect()
  kernel = "gaussian", #character string for smoothing kernal ("gaussian",...)
  col = "red", # color of the curve
  lwd = 2, # line width of the curve
  cex.lab = 1 # magnification to be used for axis-labels
)


