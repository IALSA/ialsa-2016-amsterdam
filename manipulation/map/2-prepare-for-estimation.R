# knitr::stitch_rmd(script="./manipulation/rename-classify.R", output="./manipulation/rename-classify.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
# rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
  
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
ds_miss <- dto$ms_mmse$missing # data after encoding missing states (-1, -2)
ds_ms <- dto$ms_mmse$multi # data after encoding multistates (1,2,3,4)

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
ids <- c(75507759) #, 50101073, 6804844, 83001827 , 56751351, 13485298, 56751351, 75507759)
view_id(ds_miss, ds_ms, ids)


# ---- remove-missing-age --------------------------------------------------------------
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
length(remove_ids) # number of ids to remove
ds_clean <- ds_ms %>% 
  dplyr::filter(!(id %in% remove_ids))

# ---- split-education ----------------------
ds_clean$educat <- car::Recode(ds_clean$edu,
" 1:9   = '-1'; 
  10:11 = '0';
  12:30 = '1';
")
ds_clean$educatF <- factor(ds_clean$educat, levels = c(-1, 0, 1), 
                           labels = c("0-9 years", "10-11 years", ">11 years"))
saveRDS(ds_clean, "./data/unshared/ds_clean.rds")

# ---- prepare-for-estimation --------------------
(N <- length(unique(ds_clean$id)))
subjects <- as.numeric(unique(ds_clean$id))
# Add first observation indicator
# this creates a new dummy variable "firstobs" with 1 for the first wave
cat("\nFirst observation indicator is added.\n")
offset <- rep(NA,N)
for(i in 1:N){offset[i] <- min(which(ds_clean$id==subjects[i]))}
firstobs <- rep(0,nrow(ds_clean))
firstobs[offset] <- 1
ds_clean <- cbind(ds_clean ,firstobs=firstobs)
print(head(ds_clean))

# list ids with intermidiate missing states (ims), right censors (rs), or with both
ids_with_ims  <- unique(ds_clean[ds_clean$state == -1, "id"]); length(ids_with_ims)
ids_with_rs   <- unique(ds_clean[ds_clean$state == -2, "id"]); length(ids_with_rs)
ids_with_both <- unique(ds_clean[ds_clean$state == -2 | ds_clean$state == -1, "id"]); length(ids_with_both)


# subset a random sample of individuals if needed
set.seed(42)
ids <- sample(unique(ds_clean$id), 100)
ds <- ds_clean %>% 
  # dplyr::filter(id %in% ids) %>% # make sample smaller if needed 
  # exclude individuals with some missing states
  # dplyr::filter(!id %in% ids_with_ims) %>%
  # dplyr::filter(!id %in% ids_with_rs) %>%
  # dplyr::filter(!id %in% ids_with_both) %>%
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
# view data object to be passed to the estimation call
head(ds)
cat("\n Subject count\n")
ds %>% dplyr::summarise(unique_ids = n_distinct(id)) %>% print()# subject count
cat("\n Frequency of states\n")
sf <- ds %>% 
  dplyr::group_by(state) %>% 
  dplyr::summarize(count = n()) %>%  # basic frequiencies
  dplyr::mutate(pct = round(count/sum(count),2)) %>%  # percentages, use for starter values
  print()
cat("\nState table:\n"); print(msm::statetable.msm(state,id,data=ds)) # transition frequencies
# these will be passed as starting values
(initial_probabilities <- as.numeric(as.data.frame(sf[!sf$state %in% c(-1,-2),"pct"])$pct)) 
# save the object to be used during estimation
saveRDS(ds, "./data/unshared/ds_estimation.rds")


  








