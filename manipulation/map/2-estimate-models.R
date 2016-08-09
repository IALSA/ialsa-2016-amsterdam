# knitr::stitch_rmd(script="./manipulation/rename-classify.R", output="./manipulation/rename-classify.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load_sources ------------------------------------------------------------
base::source("http://www.ucl.ac.uk/~ucakadl/ELECT/ELECT.r") # load  ELECT functions
# ---- load_packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) #Pipes
library(msm)
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit", quietly=TRUE)
# requireNamespace("plyr", quietly=TRUE)

# ---- declare_globals ---------------------------------------------------------
path_input <- "./data/unshared/derived/dto.rds"
path_output <- "data/unshared/derived/dto.rds"

digits = 2

# ---- load-data ---------------------------------------------------------------
# load the product of 0-ellis-island.R,  a list object 
# after it had been augmented by 1-encode-multistate.R script.
dto <- readRDS(path_input)

# ---- inspect-data -------------------------------------------------------------
names(dto)
# 1st element - unit(person) level data
names(dto[["unitData"]])
# 2nd element - meta data, info about variables
names(dto[["metaData"]])
# 3rd element - data for MMSE outcome
names(dto[["ms_mmse"]])
ds_miss <- dto$ms_mmse$missing
ds_ms <- dto$ms_mmse$multi

# ---- inspect-created-multistates ----------------------------------
# compare before and after ms encoding
view_id <- function(ds1,ds2,id){
  cat("Before ms encoding:","\n")
  print(ds1[ds1$id==id,])
  cat("\nAfter ms encoding","\n")
  print(ds2[ds2$id==id,])
}
# view a random person for sporadic inspections
ids <- sample(unique(ds_miss$id),1)
ids <- c(30597867) #, 50101073, 6804844, 83001827 , 56751351, 13485298, 56751351)
view_id(ds_miss, ds_ms, ids)


# ---- tweak_data --------------------------------------------------------------
# remove the observation with missing age
sum(is.na(ds_ms$age)) # count obs with missing age
# ds_miss %>% 
ds_ms %>% 
  dplyr::group_by(id) %>% 
  dplyr::summarize(n_data_points = n()) %>% 
  dplyr::group_by(n_data_points) %>% 
  dplyr::summarize(n_people=n())

remove_ids <- ds_ms %>% 
  dplyr::group_by(id) %>% 
  dplyr::summarize(n_data_points = n()) %>% 
  dplyr::arrange(n_data_points) %>% 
  dplyr::filter(n_data_points==1) %>% 
  dplyr::select(id)
remove_ids <- remove_ids$id

ds_clean <- ds_ms %>% 
  dplyr::filter(!(id %in% remove_ids))

# ---- modeling-1 ------------------------------------------------

# begin modeling
ds <- ds_clean
cat("\nState table:"); print(msm::statetable.msm(state,id,data=ds))
ds %>% dplyr::summarise(unique_ids = n_distinct(id)) # subject count
ds %>% dplyr::group_by(state) %>% dplyr::summarize(count = n()) # basic frequiencies
# NOTE: -2 is a right censored value, indicating being alive but in an unknown living state.

(N <- length(unique(ds$id)))
subjects <- as.numeric(unique(ds$id))

# Add first observation indicator
# this creates a new dummy variable "firstobs" with 1 for the first wave
cat("\nFirst observation indicator is added.\n")
offset <- rep(NA,N)
for(i in 1:N){offset[i] <- min(which(ds$id==subjects[i]))}
firstobs <- rep(0,nrow(ds))
firstobs[offset] <- 1
ds <- cbind(ds,firstobs=firstobs)
head(ds)

# Time intervals in data:
# the age difference between timepoint for each individual
intervals <- matrix(NA,nrow(ds),2)
for(i in 2:nrow(ds)){
  if(ds$id[i]==ds$id[i-1]){
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


# ---- explore-msm -----------------------------------------------
# define function for getting a simple multistate output
# Choose model (0/1/2):
# Model <- 2
q = .01
qnames = c("q12","q21","q13","q14","q24", "q34", "q23", "q31")
method = "BFGS"
# cov_names = "1 + age_bl"

simple_multistate <- function(ds, q, qnames, method, cov_names){
  covariates <- as.formula(paste0("~",cov_names))
  constraint <- NULL
  fixedpars <- NULL
  (Q <- rbind(c(0,q,q,q), c(q,0,q,q),c(q,q,0,0), c(0,0,0,0)))
  model <- msm(
    formula       = state ~ age, 
    subject       = id, 
    data          = ds, 
    center        = FALSE,
    qmatrix       = Q, 
    death         = TRUE, 
    covariates    = covariates,
    censor        = c(-1,-2), 
    censor.states = list(c(1,2,3), c(1,2,3)), 
    method        = method,
    constraint    = constraint,
    fixedpars     = fixedpars,
    control       = list(trace=0,REPORT=1,maxit=1000,fnscale=10000)
  )
  return(model)
    # Generate output:
  cat("\n---------------------------------------\n")
  cat("\nModel","---"," with covariates: "); print(covariates)
  cat("and constraints:\n"); print(constraint)
  cat("and fixedpars:\n"); print(fixedpars)
  cat("Convergence code =", model$opt$convergence,"\n")
  minus2LL <-  model$minus2loglik
  AIC <- minus2LL + 2*length(model$opt$par)
  cat("\n-2loglik =", minus2LL,"\n")
  cat("AIC =", AIC,"\n")
  p <- round(model$estimates, 2)
  p.se <- round(sqrt(diag(model$covmat)),2)
  # Univariate Wald tests:
  wald <- round((p/p.se)^2,digits)
  pvalue <- round(1-pchisq((p/p.se)^2,df=1),digits)
  # Do not test intercepts:
  wald[1:sum(names(p)=="qbase")] <- wald
  pvalue[1:sum(names(p)=="qbase")] <- pvalue
  # Results to screen:
  cat("\nParameter estimats and SEs:\n")
  print(cbind(q=qnames,p=round(p,digits),
              se=round(p.se,digits),"Wald ChiSq"=wald,
              "Pr>ChiSq"=pvalue),quote=FALSE)
  cat("\n---------------------------------------\n")
  
}

ds <- ds %>% 
  dplyr::mutate(
    # male = as.numeric(male),
    age    = age - 75,
    age_bl = age_bl - 75
  )

# m0 <- simple_multistate(ds, q, qnames, method,  cov_names = "1")
# m1 <- simple_multistate(ds, q, qnames, method,  cov_names = "age")
# m2 <- simple_multistate(ds, q, qnames, method,  cov_names = "age + age_bl")
# m3 <- simple_multistate(ds, q, qnames, method,  cov_names = "age + age_bl + male")
# m4 <- simple_multistate(ds, q, qnames, method,  cov_names = "age + age_bl + male + edu")
# 


# models 3 and 4 produced the following warning message:
# Optimisation has probably not converged to the maximum likelihood - Hessian is not positive definite.
models <- list(
  "empty"  = m0,
  "age"    = m1,
  "age_bl" = m2,
  "male"   = m3,
  "edu"    = m4
)

# saveRDS(models, "./data/shared/derived/models.rds")
models <- readRDS("./data/shared/derived/models.rds")

# ---- compute-LE -------------------

# ---- three-functions-of-ELECT -------------
dta = ds; model = models$age
# graph_LE <- function(dta, model){
  # Point-estimate life expectancies:
  sddata <- dta[dta$state%in%c(1,2,3),]
  age_0 <- -0
  ageMax <- 50

  LE.pnt <- elect(
    model=model, # fitted msm model
    b.covariates=list(age=age_0), # list with specified covarites values
    statedistdata=sddata, # data for distribution of living states
    time.scale.msm="years", # time scale in multi-state model ("years", ...)
    h=0.5, # grid parameter for integration
    age.max=ageMax, # assumed maximum age in years
    S=500 # number of simulation cycles
  )
  
  summary.elect(
    LE.pnt, # life expectancy estimated by elect()
    probs = c(.025, .5, .975), # numeric vector of probabilities for quantiles
    digits=2, # number of decimals places in output
    print = TRUE # print toggle
  )
  
  plot.elect(
    LE.pnt, # life expectancy estimated by elect()
    kernel = "gaussian", #character string for smoothing kernal ("gaussian",...)
    col = "red", # color of the curve
    lwd = 2, # line width of the curve
    cex.lab = 1 # magnification to be used for axis-labels
  )
  
# }







