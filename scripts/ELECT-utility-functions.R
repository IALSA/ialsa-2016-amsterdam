# this script provide some utility functions to facilitate the use of ELECT
# note that in the current state is covers ONLY the case with 4 categories
  
#---- msm-estimation -----------------
estimate_multistate <- function(
   model_name 
  ,ds                   # data object 
  ,Q                    # Q-matrix of transitions
  ,E                    # misspecification matrix
  ,qnames               # names of the rows in the Q matrix
  ,cov_names            # string with covariate names
  # ,method  = "BFGS"     # alternatively, if does not converge "Nedler-Mead" 
  # ,constraint = NULL    # additional model constraints
  # ,fixedpars = NULL     # fixed parameters
  # ,initprobs = NULL     # initial probabilities
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
  saveRDS(model, paste0("./data/shared/derived/models/version-3/",model_name,".rds"))
  return(model)
} 

# use of the function
# note: make sure to center age and other predictors before running
# m1 <- estimate_multistate(
#   ds = ds,
#   Q = Q,
#   qnames = qnames,
#   cov_names = "age",
#   method = "BFGS"
# )

# ---- msm-examination ----------------------
examine_multistate <- function(model, digits=3){
  # Generate output:
  cat("---------------------------------------")
  cat("\nModel","---"," with covariates: "); print(model$covariates, showEnv=F)
  cat("and constraints:\n"); print(model$constraint)
  cat("and fixedpars:\n"); print(model$fixedpars)
  cat("Convergence code =", model$opt$convergence,"\n")
  minus2LL <-  model$minus2loglik
  AIC <- minus2LL + 2*length(model$opt$par)
  cat("\n-2loglik =", minus2LL,"\n")
  cat("AIC =", AIC,"\n")
  p <- as.numeric(round(model$estimates, digits))
  p.se <- as.numeric(round(sqrt(diag(model$covmat)),digits))
  # Univariate Wald tests:
  wald <- round((p/p.se)^2,digits)
  pvalue <- round(1-pchisq((p/p.se)^2,df=1),digits)
  # Do not test intercepts:
  wald[1:sum(names(p)=="qbase")] <- wald
  pvalue[1:sum(names(p)=="qbase")] <- pvalue
  # Results to screen:
  # model_results <- cbind(q=qnames,p=round(p,digits),
  #                        se=round(p.se,digits),"Wald ChiSq"=wald,
  #                        "Pr>ChiSq"=pvalue)
  model_results <- data.frame(
    q=qnames,p=round(p,digits),
    se=round(p.se,digits),"Wald ChiSq"=wald,
    "Pr>ChiSq"=pvalue
  )
  cat("\nParameter estimats and SEs:\n")
  cat("--------------------------------------- \n")
  # print(model_results, quote = FALSE)
  # print(knitr::kable(model_results))
  return(model_results)
}
# (a <- examine_multistate(m1))

examine_multistate_simple <- function(model, digits=3){
  # Generate output:
  cat("---------------------------------------")
  cat("\nModel","---"," with covariates: "); print(model$covariates, showEnv=F)
  cat("and constraints:\n"); print(model$constraint)
  cat("and fixedpars:\n"); print(model$fixedpars)
  cat("Convergence code =", model$opt$convergence,"\n")
  minus2LL <-  model$minus2loglik
  AIC <- minus2LL + 2*length(model$opt$par)
  cat("\n-2loglik =", minus2LL,"\n")
  cat("AIC =", AIC,"\n")
  # ardo's version
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
  cat("\nParameter estimats and SEs:\n")
  cat("--------------------------------------- \n")
  # print(model_results, quote = FALSE)
  # print(knitr::kable(model_results))
  return(model_results)
}


# ----- print-LE ---------------------
print_LE_results <- function(models, covar){
  model <- models[[covar]]
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
  
}
