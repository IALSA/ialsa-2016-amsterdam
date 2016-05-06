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

# ---- declare-globals ----------------------------------------------
data_path_input  <- "./data/unshared/derived/dto.rds"
metadata_path_input <- "./data/meta/map/meta-data-map.csv" # input file with your manual classification

# ---- load-data ------------------------------------------------
dto <- readRDS(data_path_input)
names(dto)
ds <- dto[["unitData"]] %>% 
  dplyr::select_(
    "id", 
    "fu_year", # follow-up year, wave indicator
    "age_at_visit", "age_death", 
    "msex", # Gender
    "educ", # Years of education
    "smoke_bl", # Smoking at baseline
    "alco_life", # Lifetime daily alcohol intake -baseline
    "mmse" # Mini Mental State Exam 
  ) %>% 
  dplyr::filter(!(is.na(age_death) & is.na(age_at_visit)))

i <- 1
head(ds) 

# ---- transform-to-wide-time ----------------------------------------
# wave_counter <- 0:17
wave_counter <- unique(ds$fu_year)
(ms_outcome_wide_names <- paste0("mmse_",wave_counter))
(ms_age_at_visit_wide_names <- paste0("age_", wave_counter))
(not_long_stem <- c( "age_at_visit", "mmse"))
(long_stem <- setdiff(names(ds),not_long_stem))
# ds_wide <- ds_no_duplicates %>%
# ds_wide <- ds %>%
#   tidyr::spread_(key="fu_year", value %in% c("age_at_visit", "mmse") )

library(data.table) ## v >= 1.9.6
ds_wide <- data.table::dcast(
  data.table::setDT(ds),
  id + age_death + msex + educ + smoke_bl + alco_life ~ fu_year, value.var = c(
    "age_at_visit", "mmse")) 

# ---- recognize-NAs-----------------------------------------------
dsf <- dto[["unitData"]]
sum(is.na(dsf$age_bl))
sum(is.na(dsf$age_death))
sum(is.na(dsf$age_at_visit))

# ---- recode-1-------------------------------------------------------
d <- as.data.frame(ds_wide )
for(w in wave_counter){
  # define varnames at waves
  state_w <- paste0("state_",w)
  age_w <- paste0("age_at_visit_",w)
  var_w <- paste0("mmse_",w)
  
  d[,var_w] <- 1 # presumed alive and healthy
  
  for(i in nrow(d)){
    # if(is.na(d[i,"age_death"])){ # i'm not dead yet!
    if(
      !is.na(d[i,"age_death"]) # age of death is not missing
      | # or
      d[i,"age_death"] < d[i,age_w] # respondent is not dead yet
      ){ # in this case, compute alive state
      d[i,state_w] <- ifelse(
        d[i,var_w] >= 27, 1, ifelse( # no impairment
          d[i,var_w] >= 23 & d[i,var_w] < 27, 2, ifelse( # mild impairment
            d[i,var_w] < 23, 3, NA)))  # sever imparement 
    }else{
      d[i,state_w] <- 4 # dead
    } 

    }
  }
}