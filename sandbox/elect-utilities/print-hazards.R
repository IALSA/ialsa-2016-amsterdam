#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load-sources ------------------------------------------------------------
base::source("http://www.ucl.ac.uk/~ucakadl/ELECT/ELECT.r") # load  ELECT functions
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
list.files(pathSaveFolder)
# ---- load-data ----------------------


# ---- define-custom-functions -------------------
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
  # hazard ratios
  cat("\n Hazard ratios : \n")
  print(hazard.msm(model))
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

# ----- -----------------

# model <- readRDS("./data/shared/derived/models/model-b-mod-2/mB_mod2_1.rds")
# msm_summary(model)


print_hazards <- function(model, dense=T){
  hz <- hazard.msm(model)
  a <- plyr::ldply(hz, .id = "predictor") 
  b <- a %>% 
    dplyr::mutate(
      transition = rep(rownames(hz[[1]]), length(hz)),
      hr    = sprintf("%0.2f", HR),
      lo    = sprintf("%0.2f", L),
      hi    = sprintf("%0.2f", U),
      dense = sprintf("%4s (%4s,%5s)", hr, lo, hi)
    )
  if(dense){
     c <- b %>% 
    dplyr::select(transition, predictor, dense)
  }
  if(!dense){
    c <- b %>% 
      dplyr::select(transition, predictor, HR, L, U)
  }
  return(c)
}
hz <- print_hazards(model, dense=T) %>% print()
hz <- print_hazards(model, dense=F) %>% print()

















