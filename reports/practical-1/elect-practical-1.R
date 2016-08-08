# knitr::stitch_rmd(script="./reports/practical-1/elect-practical-1.R", output="./reports/practical-1/elect-practical-1.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
base::source("./scripts/common-functions.R") # used in multiple reports
base::source("./scripts/graph-presets.R") # fonts, colors, themes 
base::source("http://www.ucl.ac.uk/~ucakadl/ELECT/ELECT.r") # load  ELECT functions

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
library("msm") # multistate modeling (cannot be declared silently)
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
requireNamespace("tidyr") # data manipulation
requireNamespace("dplyr") # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")# For asserting conditions meet expected patterns.
# requireNamespace("car") # For it's `recode()` function.

requireNamespace("flexsurv") # parameteric survival and multi-state
requireNamespace("mstate") # multistate modeling
requireNamespace("foreign") # data input

# ---- declare-globals ---------------------------------------------------------
# point to the data file used in Example 1 of the official ELECT vignette
path_data_example_i <- "./libs/materials/R/Practical1/dataEx1.RData"
# Define rounding in output:
digits <- 3


# ---- load-data ---------------------------------------------------------------
load(path_data_example_i)
ds <- dplyr::tbl_df(dta)

# ---- explore-data-a ----------------------------------------------
head(ds) # top few rows
ds %>% dplyr::filter(id %in% c("4","5")) # a few specific ids

subjects <- as.numeric(names(table(dta$id))) 
N <- length(subjects) 
cat("\nSample size:",N,"\n")

# ---- explore-data-b ----------------------------------------------
cat("\nFrequencies observed state:"); print(table(dta$state))
cat("\nFrequencies number of observations:"); print(table(table(dta$id)))

# ---- explore-data-c ----------------------------------------------
cat("\nState table:"); print(statetable.msm(state,id,data=dta))

# NOTE: 
ds %>% dplyr::summarise(unique_ids = n_distinct(id)) # subject count
ds %>% dplyr::group_by(state) %>% dplyr::summarize(count = n()) # basic frequiencies
# NOTE: -2 is a right censored value, indicating being alive but in an unknown living state.


# ---- explore-data-de-1 -----------
# Add first observation indicator
# this creates a new dummy variable "firstobs" with 1 for the frist wave
cat("\nFirst observation indicator is added.\n")
offset <- rep(NA,N)
for(i in 1:N){offset[i] <- min(which(dta$id==subjects[i]))}
firstobs <- rep(0,nrow(dta))
firstobs[offset] <- 1
dta <- cbind(dta,firstobs=firstobs)
head(dta)

# ---- explore-data-de-2 -----------
# Time intervals in data:
# the age difference between timepoint for each individual
intervals <- matrix(NA,nrow(dta),2)
for(i in 2:nrow(dta)){
  if(dta$id[i]==dta$id[i-1]){
    intervals[i,1] <- dta$id[i]
    intervals[i,2] <- dta$age[i]-dta$age[i-1]
  }
}
head(intervals)

# ---- # ---- explore-data-de-3 ---------------------------------------------
# the age difference between timepoint for each individual
# Remove the N NAs:
intervals <- intervals[!is.na(intervals[,2]),]
cat("\nTime intervals between observations within individuals:\n")
print(round(quantile(intervals[,2]),digits))

# Info on age and time between observations:
opar<-par(mfrow=c(1,3), mex=0.8,mar=c(5,5,3,1))
hist(dta$age[dta$firstobs==1],col="red",xlab="Age at baseline in years",main="")
hist(dta$age,col="blue",xlab="Age in data in years",main="") 
hist(intervals[,2],col="green",xlab="Time intervals in data in years",main="") 
opar<-par(mfrow=c(1,1), mex=0.8,mar=c(5,5,2,1))




# ---- explore-msm -----------------------------------------------
# define function for getting a simple multistate output
# Choose model (0/1/2):
# Model <- 2
  q = .01
  qnames = c("q12","q21","q13","q23")
  method = "BFGS"
  
simple_multistate <- function(ds, Model, q, qnames, method, cov_names){
  covariates <- as.formula(paste0("~",cov_names))
  constraint <- NULL
  fixedpars <- NULL
  Q <- rbind(c(0,q,q), c(q,0,q),c(0,0,0))
  model <- msm(state~age, subject=id, data=ds, center=FALSE,
                 qmatrix=Q, death=TRUE, covariates=covariates,
                 censor= -2, censor.states=c(1,2), method=method,
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
  return(model)
}
# 

# ---- explore-msm-a ------------------------------
model <- simple_multistate(ds = dta, Model=0,q, qnames, method,  cov_names = "1")


# ---- explore-msm-b ------------------------------

# ---- explore-msm-c ------------------------------


# ---- explore-msm-d ------------------------------
simple_multistate(ds = dta, Model=0,q, qnames, method,  cov_names = "age")


# ---- explore-msm-d ------------------------------


# ---- explore-msm-f ------------------------------
simple_multistate(ds = dta, Model=0,q, qnames, method,  cov_names = "age+x")




# ---- explore-ELECT -------------------------------


# Life expectancies for Model 2:
if(Model==2){
  
  
  # Point-estimate life expectancies:
  sddata <- dta[dta$state%in%c(1,2),]
  age0 <- 65
  age.max <- 115
  x0 <- 0
  LEs.pnt <- elect(model=model, b.covariates=list(age=age0,x=x0),
                   statedistdata=sddata, time.scale.msm="years",
                   h=0.5, age.max=age.max, S=0)
  summary.elect(LEs.pnt, digits=2)
  
  
  # Plot LEs for an age range with CIs:
  age.range <- 65:95
  probs <- c(.025,.5,.975)
  L <- length(age.range)
  LEs <- array(NA,c(L,length(LEs.pnt$pnt),length(probs)))
  for(i in 1:L){
    age0 <- age.range[i]
    x0 <- 0
    cat("Running simulation for age = ",age0,"and x = ",x0,"\n")
    results<-elect(model=model, b.covariates=list(age=age0,x=x0),
                   statedistdata=sddata, time.scale.msm="years",
                   h=0.5, age.max=age.max, S=50,setseed=12345)
    for(j in 1:7){
      for(k in 1:length(probs)){
        LEs[i,j,k] <- quantile(results$sim[,j],probs=probs[k])
      } 
    }
  }
  x.axis <- c(min(age.range),max(age.range))
  y.axis <- c(0,20)
  plot(x.axis,y.axis,ylab="Life Expectancy",xlab="Age",type="n",cex.lab=1.5)
  # LEs e11:
  lines(age.range,LEs[,1,1],col="red",lwd=1)
  lines(age.range,LEs[,1,2],col="red",lwd=3)
  lines(age.range,LEs[,1,3],col="red",lwd=1)
  # LEs e12:
  lines(age.range,LEs[,2,1],col="blue",lwd=1,lty=2)
  lines(age.range,LEs[,2,2],col="blue",lwd=3,lty=2)
  lines(age.range,LEs[,2,3],col="blue",lwd=1,lty=2)
  
}

# ---- tweak-data --------------------------------------------------------------



# ---- section-2.2 ------------------------------------------------------------
cat("Sample size:"); print(length(table(data$id)))
cat("Frequencies observed state:"); print(table(data$state))
cat("State table:"); print(msm::statetable.msm(state,id,data=data))










