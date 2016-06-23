# knitr::stitch_rmd(script="./manipulation/rename-classify.R", output="./manipulation/rename-classify.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load_sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.

# ---- load_packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) #Pipes

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit", quietly=TRUE)
# requireNamespace("plyr", quietly=TRUE)

# ---- declare_globals ---------------------------------------------------------
digits = 2
# ---- load-data ---------------------------------------------------------------
# load the product of 1-encode-multistate.R
ds <- readRDS("./data/unshared/derived/multistate_mmse.rds")



# ---- inspect-data -------------------------------------------------------------
# names(dto)
# 1st element - unit(person) level data
# dplyr::tbl_df(dto[["unitData"]])
# 2nd element - meta data, info about variables
# dto[["metaData"]]



# ---- tweak_data --------------------------------------------------------------
# remove the observation with missing age



# ---- object-verification ------------------------------------------------

# begin modeling


cat("\nState table:"); print(statetable.msm(state,id,data=ds))
ds %>% dplyr::summarise(unique_ids = n_distinct(id)) # subject count
ds %>% dplyr::group_by(state) %>% dplyr::summarize(count = n()) # basic frequiencies
# NOTE: -2 is a right censored value, indicating being alive but in an unknown living state.

(N <- length(unique(ds$id)))
subjects <- as.numeric(unique(ds$id))

# Add first observation indicator
# this creates a new dummy variable "firstobs" with 1 for the frist wave
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
ds <- ds %>% dplyr::filter(!id %in% c(1738075, 3060782, 3335936, 4406282, 4886978, 5274286))
# define function for getting a simple multistate output
# Choose model (0/1/2):
# Model <- 2
q = .01
qnames = c("q12","q21","q13","q14","q24", "q34", "q23", "q31")
method = "BFGS"

simple_multistate <- function(ds, Model, q, qnames, method, cov_names){
  covariates <- as.formula(paste0("~",cov_names))
  constraint <- NULL
  fixedpars <- NULL
  (Q <- rbind(c(0,q,q,q), c(q,0,q,q),c(q,q,0,0), c(0,0,0,0)))
  model <- msm(state~age, subject=id, data=ds, center=FALSE,
               qmatrix=Q, death=TRUE, covariates=covariates,
               censor= c(-1,-2), censor.states=list(c(1,2,3), c(1,2,3)), method=method,
               constraint=constraint,fixedpars=fixedpars,
               control=list(trace=0,REPORT=1,maxit=1000,fnscale=10000))
  # Generate output:
  cat("\n---------------------------------------\n")
  cat("\nModel",Model," with covariates: "); print(covariates)
  cat("and constraints:\n"); print(constraint)
  cat("and fixedpars:\n"); print(fixedpars)
  cat("Convergence code =", model$opt$convergence,"\n")
  minus2LL <-  model$minus2loglik
  AIC <- minus2LL + 2*length(model$opt$par)
  cat("\n-2loglik =", minus2LL,"\n")
  cat("AIC =", AIC,"\n")
  p <- model$estimates
  p.se <- sqrt(diag(model$covmat))
  # Univariate Wald tests:
  wald <- round((p/p.se)^2,digits)
  pvalue <- round(1-pchisq((p/p.se)^2,df=1),digits)
  # Do not test intercepts:
  wald[1:sum(names(p)=="qbase")] <- "-"
  pvalue[1:sum(names(p)=="qbase")] <- "-"
  # Results to screen:
  cat("\nParameter estimats and SEs:\n")
  print(cbind(q=qnames,p=round(p,digits),
              se=round(p.se,digits),"Wald ChiSq"=wald,
              "Pr>ChiSq"=pvalue),quote=FALSE)
  cat("\n---------------------------------------\n")
}

simple_multistate(ds = ds, Model=0,q, qnames, method,  cov_names = "1 + age")

ds = ds; Model=0,q, qnames, method,  cov_names = "1"












