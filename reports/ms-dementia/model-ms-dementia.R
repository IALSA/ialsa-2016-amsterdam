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
# path_input  <- "./data-phi-free/raw/results-physical-cognitive.csv"
# path_input <- paste0("./data/shared/parsed-results-pc-",study,".csv")
# path_input  <- "./data/shared/parsed-results.csv"
path_input <- "./data/unshared/derived/ms-dementia-3-states.rds"
# path_output <- "data/unshared/derived/dto.rds"

# ---- load-data ---------------------------------------------------------------
# load the product multi-state computation
ds <- readRDS(path_input)

# ---- inspect-data -------------------------------------------------------------
head(ds)
msm::statetable.msm(state,id,ds)

# ---- tweak_data --------------------------------------------------------------


# ---- look-up-pattern-for-single-id --------------------------------------------------------------
# if died==1, all subsequent focal_outcome==DEAD.
set.seed(1)
ids <- sample(unique(ds$id),3)
d <- ds %>% 
  dplyr::filter(id %in% ids) %>%
  dplyr::select_("id","fu_point","age","msex", "educ")
d
# d




# ---- basic-model -----------------------------
simple_multistate <- function(ds, Q, qnames, cov_names, method){
  covariates <- as.formula(paste0("~",cov_names))
  constraint <- NULL
  fixedpars <- NULL
  # Q <- rbind(c(0,q,q), c(q,0,q),c(0,0,0))
  model <- msm(state~age, subject=id, data=ds, center=FALSE,
               qmatrix=Q, death=TRUE, covariates=covariates,
               censor= -2, censor.states=c(1,2), method=method,
               constraint=constraint,fixedpars=fixedpars,
               control=list(trace=0,REPORT=1,maxit=1000,fnscale=10000))
  # Generate output:
  cat("\n---------------------------------------\n")
  cat("\nModel with covariates: "); print(covariates)
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


# ---- look-up-pattern-for-single-id --------------------------------------------------------------
set.seed(1)
ids <- sample(unique(ds$id),300)
d <- ds %>% 
  dplyr::filter(id %in% ids) # turn off for all observations
d


# ---- explore-msm-a ------------------------------
digits <- 3
q = .01
Q <- rbind(c(0,q,q), c(q,0,q),c(0,0,0))
qnames = c("q12","q21","q13","q23")
method = "BFGS"
cov_names = "msex + educ" 
simple_multistate(d, Q, qnames,cov_names, method )















