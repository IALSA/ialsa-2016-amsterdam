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
path_input <- "./data/unshared/derived/dto.rds"
path_output <- "data/unshared/derived/dto.rds"

# ---- load-data ---------------------------------------------------------------
# load the product of 0-ellis-island.R,  a list object containing data and metad
dto <- readRDS("./data/unshared/derived/dto.rds")

# ---- inspect-data -------------------------------------------------------------
names(dto)
# 1st element - unit(person) level data
dplyr::tbl_df(dto[["unitData"]])
# 2nd element - meta data, info about variables
dto[["metaData"]]



# ---- tweak_data --------------------------------------------------------------
ds <- dto[["unitData"]]

# table(ds$fu_year, ds$dementia)

# ---- look-up-pattern-for-single-id --------------------------------------------------------------
# if died==1, all subsequent focal_outcome==DEAD.
set.seed(1)
ids <- sample(unique(ds$id),3)
dta0 <- ds %>% 
  dplyr::filter(id %in% ids) %>%
  dplyr::mutate(
    age_death = as.numeric(age_death), 
    male      = as.logical(ifelse(!is.na(msex), msex=="1", NA_integer_)),
    edu       = as.numeric(educ)
  ) %>% 
  dplyr::select_(
    "id",
    # "fu_year",
    "male",
    "age_death",
    "age_at_visit",
    "mmse") 
dta0 # in long format
# d$id <- substring(d$id,1,1)
# write.csv(d,"./data/shared/musti-state-dementia.csv")  

d <- dta0
encode_multistates <- function(
  d, # data frame in long format 
  outcome_name, # measure to compute live states
  age_name, # age at each wave
  age_death_name, # age of death
  dead_state_value # value to represent dead state
){
  # d = dta0; outcome_name = "mmse"; age_name = "age_at_visit"; age_death_name = "age_death"; dead_state_value = 5
  (subjects <- sort(unique(d$id))) # list subject ids
  (N <- length(subjects)) # count subject ids
  # standardize names
  colnames(d)[colnames(d)==outcome_name] <- "state"
  colnames(d)[colnames(d)==age_name] <- "age"
  for(i in 1:N){
  # Get the individual data: i = 1
  (dta.i <- d[d$id==subjects[i],])
  # 1 - healthy
  # 2 - mild cognitive impairment
  # 3 - moderate to severe cognitive impairment  
  # dta.i$state <- car::recode(dta.i$state, "
  #             27:hi = '1';
  #             23:26 = '2';
  #             lo:22 = '3' 
  #            ")
  dta.i$state <- ifelse( 
    dta.i$state > 26, 1, ifelse( # healthy
      dta.i$state <= 26 &  dta.i$state >= 23, 2, ifelse( # mild CI
        dta.i$state < 23, 3,NA))) # mod-sever CI
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
  d = ds,
  outcome_name = "mmse",
  age_name = "age_at_visit",
  age_death_name = "age_death",
  dead_state_value = 4
)
# ds_ms

# examine transition matrix
msm::statetable.msm(state,id,ds_ms)


# ---- save-to-disk ------------------------------------------------------------

# Save as a compress, binary R dataset.  It's no longer readable with a text editor, but it saves metadata (eg, factor information).
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



















