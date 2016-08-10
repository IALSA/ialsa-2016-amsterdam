# knitr::stitch_rmd(script="./manipulation/rename-classify.R", output="./manipulation/rename-classify.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) #Pipes

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit", quietly=TRUE)
# requireNamespace("plyr", quietly=TRUE)

# ---- declare-globals ---------------------------------------------------------
path_input <- "./data/unshared/derived/dto.rds"
path_output <- "data/unshared/derived/dto.rds"

# ---- load-data ---------------------------------------------------------------
# load the product of 0-ellis-island.R,  a list object containing data and metad
dto <- readRDS(path_input)

# ---- inspect-data -------------------------------------------------------------
names(dto)
# 1st element - unit(person) level data
dplyr::tbl_df(dto[["unitData"]])
# 2nd element - meta data, info about variables
dto[["metaData"]]



# ---- tweak-data --------------------------------------------------------------
ds <- dto[["unitData"]]

# table(ds$fu_year, ds$dementia)

# ---- look-up-pattern-for-single-id --------------------------------------------------------------
# if died==1, all subsequent focal_outcome==DEAD.
# during debuggin/testing use only a few ids, for manipulation use all
set.seed(43)
ids <- sample(unique(ds$id),3)
ids <- c(33027) #,33027, 50101073, 6804844, 83001827 , 56751351, 13485298, 30597867)

# ---- into-long-format -------------------------
ds_long <- ds %>% 
  # dplyr::filter(id %in% ids) %>% # turn this off when using the entire sample
  dplyr::mutate(
    age_bl    = as.numeric(age_bl),
    age_death = as.numeric(age_death), 
    male      = as.logical(ifelse(!is.na(msex), msex=="1", NA_integer_)),
    edu       = as.numeric(educ)
  ) %>% 
  dplyr::select_(
    "id",
    # "fu_year",
    "age_bl",
    "male",
    "edu",
    "age_death",
    "age_at_visit",
    "mmse") 
# save to disk for direct examination
# write.csv(d,"./data/shared/musti-state-dementia.csv")  


# inspect crated data object
ds_long %>% 
  dplyr::filter(id %in% ids) %>% 
  print()



# ---- encode-missing-states ---------------------------
# x <- c(NA, 5, NA, 7)
determine_censor <- function(x, is_right_censored){
  ifelse(is_right_censored, -2,
         ifelse(is.na(x), -1, x)
  )
}
(N <- length(unique(ds_long$id))) # sample size
(subjects <- as.numeric(unique(ds_long$id))) # list the ids

for(i in 1:N){
# for(i in unique(ds$id)){  # use this line for testing
  # Get the individual data:
  (dta.i <- ds_long[ds_long$id==subjects[i],]) # select a single individual
  # (dta.i <- ds_long[ds_long$id==6804844,]) # select a single individual # use this line for testing
  (dta.i <- as.data.frame(dta.i %>% dplyr::arrange(-age_at_visit))) # enforce sorting
  (dta.i$missed_last_wave = (cumsum(!is.na(dta.i$mmse))==0L)) # is the last obs missing?
  (dta.i$presumed_alive      =  is.na(any(dta.i$age_death))) # can we presume subject alive?
  (dta.i$right_censored   = dta.i$missed_last_wave & dta.i$presumed_alive) # right-censored?
  # dta.i$mmse_recoded     = determine_censor(dta.i$mmse, dta.i$right_censored) # use when tracing
  (dta.i$mmse     <- determine_censor(dta.i$mmse, dta.i$right_censored)) # replace in reality
  (dta.i <- as.data.frame(dta.i %>% dplyr::arrange(age_at_visit)))
  (dta.i <- dta.i %>% dplyr::select(-missed_last_wave, -right_censored ))
  # Rebuild the data:
  if(i==1){ds_miss <- dta.i}else{ds_miss <- rbind(ds_miss,dta.i)}
}
# inspect crated data object
ds_miss %>% 
  dplyr::filter(id %in% ids) %>% 
  print()

# ---- encode-multi-states ------------------------------
encode_multistates <- function(
  d, # data frame in long format 
  outcome_name, # measure to compute live states
  age_name, # age at each wave
  age_death_name, # age of death
  dead_state_value # value to represent dead state
){
  # declare arguments for debugging
  # d = d,
  # outcome_name = "mmse";age_name = "age_at_visit";age_death_name = "age_death";dead_state_value = 4
  (subjects <- sort(unique(d$id))) # list subject ids
  (N <- length(subjects)) # count subject ids
  # standardize names
  colnames(d)[colnames(d)==outcome_name] <- "state" # ELECT requires this name
  colnames(d)[colnames(d)==age_name] <- "age" # ELECT requires this name
  # for(i in unique(ds$id)){  # use this line for testing
  for(i in 1:N){
    # Get the individual data: i = 1
    (dta.i <- d[d$id==subjects[i],])
    # (dta.i <- ds_long[ds_long$id==6804844,]) # select a single individual # use this line for testing
    # Encode live states
    dta.i$state <- ifelse( 
      dta.i$state > 26, 1, ifelse( # healthy
        dta.i$state <= 26 &  dta.i$state >= 23, 2, ifelse( # mild CI
          dta.i$state < 23 & dta.i$state >= 0, 3, dta.i$state))) # mod-sever CI
    # Is there a death? If so, add a record:
    (death <- !is.na(dta.i[,age_death_name][1]))
    if(death){
      (record <- dta.i[1,])
      (record$state <- dead_state_value)
      (record$age   <- dta.i[,age_death_name][1])
      (ddta.i <- rbind(dta.i,record))
    }else{ddta.i <- dta.i}
    # Rebuild the data:
    if(i==1){dta1 <- ddta.i}else{dta1 <- rbind(dta1,ddta.i)}
  }
  dta1[,age_death_name] <- NULL
  return(dta1)
}

ds_ms <- encode_multistates(
  d = ds_miss,
  outcome_name = "mmse",
  age_name = "age_at_visit",
  age_death_name = "age_death",
  dead_state_value = 4
)

ds_ms %>% 
  dplyr::filter(id %in% ids) %>% 
  print()

# simple frequencies of states
table(ds_ms$state)
# examine transition matrix
# msm::statetable.msm(state,id,ds_ms)
knitr::kable(msm::statetable.msm(state,id,ds_ms))

# ---- save-to-disk ------------------------------------------------------------
# Save as a compress, binary R dataset.  It's no longer readable with a text editor, but it saves metadata (eg, factor information).

# at this point there exist two relevant data sets:
# ds_miss - missing states are encoded
# ds_ms   - multi   states are encoded
# it is useful to have access to both while understanding/verifying encodings

names(dto)
dto[["ms_mmse"]][["missing"]] <- ds_miss
dto[["ms_mmse"]][["multi"]] <- ds_ms
saveRDS(dto, file="./data/unshared/derived/dto.rds", compress="xz")

# ---- object-verification ------------------------------------------------
# the production of the dto object is now complete
# we verify its structure and content:
dto <- readRDS("./data/unshared/derived/dto.rds")
names(dto)
# 1st element - unit(person) level data
dplyr::tbl_df(dto[["unitData"]])
# 2nd element - meta data, info about variables
dto[["metaData"]]
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
view_id(ds_miss, ds_ms, ids)























