

ids <- sample(unique(ds$id),900)
d_temp <- ds %>% 
  dplyr::filter(id %in% ids)
  cov_names = "age"        # string with covariate names
  method_ = "BFGS"  # alternatively, if does not converge "Nedler-Mead"
  constraint = NULL # additional model constraints
  fixedpars = NULL   # fixed parameters

  covariates <- as.formula(paste0("~",cov_names))
  model <- msm(
    formula       = state ~ age, 
    subject       = id, 
    data          = d_temp, 
    center        = FALSE,
    qmatrix       = Q, 
    # ematrix       = E,
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
  