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
path_input <- "./data/unshared/raw/2016-08-17-emiel/LASA IALSA cognition2.sav"


digits = 2

# ---- load-data ---------------------------------------------------------------
# load the product of 0-ellis-island.R,  a list object 
# after it had been augmented by 1-encode-multistate.R script.
# dto <- readRDS(path_input)
ds <- Hmisc::spss.get(path_input, use.value.labels = TRUE)
# ---- inspect-data -------------------------------------------------------------
head(ds)
ds <- ds %>% 
  dplyr::rename(
    index = Index1,
    edu = educationlevel,
    network = netwerkgrootte,
    income = inkomen,
    age_at_visit = x.state.age
  ) %>% 
  dplyr::select(-sex)
head(ds)
 

# ---- inspect-created-multistates ----------------------------------
# compare before and after ms encoding
view_id <- function(d,id){
  print(d[d$id==id,])
}
# view a random person for sporadic inspections
ids <- sample(unique(ds$id),1)
ids <- c(13257) #
# problematic : 13257, 16986
view_id(ds, ids)


# ---- remove-missing-age --------------------------------------------------------------
# remove the observation with missing age
sum(is.na(ds$age)) # count obs with missing age
# ds_miss %>% 
ds %>% 
  dplyr::group_by(id) %>% 
  dplyr::summarize(n_data_points = n()) %>% 
  dplyr::group_by(n_data_points) %>% 
  dplyr::summarize(n_people=n())

remove_ids <- ds %>% 
  dplyr::group_by(id) %>% 
  dplyr::summarize(n_data_points = n()) %>% 
  dplyr::arrange(n_data_points) %>% 
  dplyr::filter(n_data_points==1) %>% 
  dplyr::select(id)
remove_ids <- remove_ids$id
length(remove_ids) # number of ids to remove
ds_clean <- ds %>% 
  dplyr::filter(!(id %in% remove_ids))

# ---- inspect-clean-data ------------------------------------------------
# ds <- ds_clean
ds_clean %>% dplyr::summarise(unique_ids = n_distinct(id)) # subject count
ds_clean %>% dplyr::group_by(state) %>% dplyr::summarize(count = n()) # basic frequiencies
cat("\nState table:"); print(msm::statetable.msm(state,id,data=ds)) # transition frequencies
# NOTE: -2 is a right censored value, indicating being alive but in an unknown living state.

# ---- describe-age-composition -----------


(N <- length(unique(ds_clean$id)))
subjects <- as.numeric(unique(ds_clean$id))
# Add first observation indicator
# this creates a new dummy variable "firstobs" with 1 for the first wave
cat("\nFirst observation indicator is added.\n")
offset <- rep(NA,N)
for(i in 1:N){offset[i] <- min(which(ds_clean$id==subjects[i]))}
firstobs <- rep(0,nrow(ds))
firstobs[offset] <- 1
ds_clean <- cbind(ds_clean,firstobs=firstobs)
head(ds_clean)

# Time intervals in data:
# the age difference between timepoint for each individual
intervals <- matrix(NA,nrow(ds),2)
for(i in 2:nrow(ds)){
  if(ds_clean$id[i]==ds_clean$id[i-1]){
    intervals[i,1] <- ds_clean$id[i]
    intervals[i,2] <- ds_clean$age[i]-ds_clean$age[i-1]
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
hist(ds_clean$age[ds_clean$firstobs==1],col="red",xlab="Age at baseline in years",main="")
hist(ds_clean$age,col="blue",xlab="Age in data in years",main="")
hist(intervals[,2],col="green",xlab="Time intervals in data in years",main="")

# ---- compute-baseline-age -----------------
i <- 13257
for(i in unique(ds_clean$id)){
  ds_clean[ ds_clean$id==i,"age_bl"] <- ds_clean[ds_clean$id==i & ds_clean$firstobs==1,"age_at_visit"]
}


# ---- estimate-msm-1 -----------------------------------------------
# load utility functions
source("./scripts/ELECT-utility-functions.R")

ds <- ds_clean %>% 
  dplyr::mutate(
    male = as.numeric(male),
    age    = age_at_visit - 75,
    age_bl = age_bl - 75
  )
head(ds)
q = .01
# qnames <- c("q12", "q13","q14","q21", "q23", "q24","q32", "q34")
qnames = c(
  "Healthy - Mild",  # q12
  "Health - Severe", # q13
  "Healthy - Dead",  # q14
  "Mild - Healthy",  # q21  
  "Mild - Severe",   # q23
  "Mild - Dead",     # q24
  "Severe - Mild",   # q32
  "Severe - Dead"    # q34
  )
(Q <- rbind(c(0,q,q,q), 
            c(q,0,q,q),
            c(0,q,0,q), 
            c(0,0,0,0))) # verify structure

# turn off estimation lines after the first run 

models <- list()

m1 <- estimate_multistate(ds, Q, qnames,cov_names = "age")
m2 <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl")
m3 <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male")
m4 <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu")
m5 <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu + income") 
m6 <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu + income + network")


# models[["age"]][["msm"]]     <- estimate_multistate(ds, Q, qnames,cov_names = "age")
# models[["age_bl"]][["msm"]]  <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl")
# models[["male"]][["msm"]]    <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male")
# models[["edu"]][["msm"]]     <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu")
# models[["income"]][["msm"]]   <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu + income") 
# models[["network"]][["msm"]] <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu + income + network")

# save models estimated by msm() in a external object for faster access in the future

# saveRDS(models, "./data/shared/derived/models.rds")
models <- readRDS("./data/shared/derived/models.rds")
lapply(models, names)

# ---- estimate-msm-2 -----------------------------------------------
# add misspecification conditions to the model

(E <- rbind(c(0,   0,   0,  0),  
            c(0,   0,   0,  0), 
            c(0.1, 0,   0,  0),
            c(0,   0,   0,  0))) 



# turn off estimation lines after the first run 

m1e <- estimate_multistate(ds, Q, E, qnames,cov_names = "age")
m2e <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl")
m3e <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male")
m4e <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu")
m5e <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu + income") 
m6e <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu + income + network")


# models_e <- list()
models_e[["age"]][["msm"]]     <- estimate_multistate(ds, Q, qnames,cov_names = "age")
models_e[["age_bl"]][["msm"]]  <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl")
models_e[["male"]][["msm"]]    <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male")
models_e[["edu"]][["msm"]]     <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu")
models_e[["income"]][["msm"]]  <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu + income") 
models_e[["network"]][["msm"]] <- estimate_multistate(ds, Q, qnames,cov_names = "age + age_bl + male + edu + income + network")

# # save models estimated by msm() in a external object for faster access in the future
# 
# saveRDS(models, "./data/shared/derived/models-2.rds")
models <- readRDS("./data/shared/derived/models-2.rds")
lapply(models, names)


# ---- compute-LE-1 -------------------
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

  








