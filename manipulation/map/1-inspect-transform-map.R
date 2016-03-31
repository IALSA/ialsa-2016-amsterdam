# knitr::stitch_rmd(script="./reports/review-variables/map/review-variables-map.R", output="./reports/review-variables/map/stitched-output/review-variable-map.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
requireNamespace("tidyr") # data manipulation
requireNamespace("dplyr") # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")# For asserting conditions meet expected patterns.
# requireNamespace("car") # For it's `recode()` function.

# ---- declare-globals ---------------------------------------------------------
data_path_input  <- "../MAP/data-unshared/derived/ds0.rds"
metadata_path_input <- "../MAP/data-phi-free/raw/nl_augmented.csv" # input file with your manual classification

# ---- load-data ---------------------------------------------------------------
ds0 <- readRDS(data_path_input)
nl <- read.csv(metadata_path_input, stringsAsFactors = F, header = T)
nl$X <- NULL # remove automatic variable
dplyr::tbl_df(nl)


# ---- assemble-data-object ----------------------------------------------------
# create a data object that will be used for subsequent analyses
# select variables you will need for modeling
ds <- ds0 %>%
  # dplyr::rename_("fu_point" = "fu_year") %>% 
  dplyr::select_(
# 
# selected_items <- c(
  "id", # personal identifier
  "age_bl", # Age at baseline
  "msex", # Gender
  "race", # Participant's race
  "educ", # Years of education

  # time-invariant above
  "fu_year", # Follow-up year ------------------------------------------------
  # time-variant below
  
  "age_death", # Age at death
  "died", # Indicator of death  
  "age_at_visit", #Age at cycle - fractional
  #
  "iadlsum", # Instrumental activities of daily liviing
  "cts_mmse30", # MMSE - 2014
  "cts_catflu", # Category fluency - 2014
  "dementia", # Dementia diagnosis
  "bmi", # Body mass index
  "phys5itemsum", # Summary of self reported physical activity measure (in hours) ROS/MAP
  "q3smo_bl",  # Smoking quantity-baseline (VERIFY)
  "q4smo_bl", # Smoking duration-baseline (VERIFY)
  "smoke_bl", # Smoking at baseline (VERIFY)
  "smoking", # Smoking (VERIFY)
  "ldai_bl", # Grams of alcohol per day
  "dm_cum", # Medical history - diabetes - cumulative
  "hypertension_cum", # Medical conditions - hypertension - cumulative
  "stroke_cum", # Clinical Diagnoses - Stroke - cumulative
  "r_stroke", # 	Clinical stroke dx
  "katzsum", # Katz measure of disability
  "rosbscl" # 	Rosow-Breslau scale
) 
ds %>% dplyr::glimpse()
# ---- inspect-data -------------------------------------------------------------
# basic demographic variables
length(unique(ds$id)) # there are this many of them
table(ds[,"msex"], ds[,"race"], useNA = "always")
t <- table(ds[,"educ"], ds[,"race"]); t[t==0]<-".";t
# age variables
t <- table(ds[,"fu_year"], ds[,"died"]); t[t==0]<-".";t
# histogram_continuous(ds, variable_name = "age_death", bin_width = 1)
# histogram_continuous(ds, variable_name = "age_bl", bin_width = 1)
# histogram_continuous(ds, variable_name = "age_at_visit", bin_width = 1)



# ---- tweak-data --------------------------------------------------------------
# if died==1, all subsequent focal_outcome==DEAD.
set.seed(1)
ids <- sample(unique(ds$id),3)
d <- ds0 %>% 
  dplyr::filter(id %in% ids) %>%
  dplyr::select_("id","fu_year","age_death","age_at_visit", "dementia") %>%
  dplyr::mutate(
    age_death = as.numeric(age_death)
  )
d 
# d$id <- substring(d$id,1,1)
# write.csv(d,"./data/shared/musti-state-dementia.csv")  

# ---- ms_dementia -------------------------------------------------------------
ds_alive <- d %>% 
  dplyr::rename(
    dementia_now=dementia, 
    fu_point = fu_year) %>% 
  dplyr::group_by(id) %>% 
  dplyr::mutate(
    dead_now = FALSE,
    dementia_now   = as.logical(dementia_now),
    dementia_ever  = any(dementia_now)
  ) %>% 
  dplyr::ungroup()
ds_alive
# str(ds_alive )
ds_dead <- ds_alive %>% 
  dplyr::filter(!is.na(age_death)) %>% 
  dplyr::group_by(id) %>% 
  dplyr::arrange(fu_point) %>% 
  dplyr::summarize(
    dead_now = TRUE,
    fu_point       = max(fu_point) + 1L,
    age_death      = max(age_death),
    age_at_visit   = NA_real_,
    dementia_last  = dplyr::last(dementia_now),
    dementia_now   = ifelse(dementia_last, TRUE, NA),
    dementia_ever  = any(dementia_now)
  ) %>% 
  dplyr::ungroup() %>% 
  dplyr::select(-dementia_last)
ds_dead
# str(ds_dead)
ds <- ds_alive %>%
  dplyr::union(ds_dead) %>%
  dplyr::arrange(id, fu_point)
ds

ds <- ds %>%
  dplyr::mutate(
    state = ifelse( (!dead_now & !dementia_now),1,
                    ifelse(!dead_now & dementia_now, 2, 
                           ifelse(dead_now,3, NA)))
  ) 
ds
ds$state <- ordered(ds$state, levels = c(1,2,3),
                    labels = c("Healthy","Sick","Dead"))
str(ds)



# ---- sample-composition -------------------------------------------------------
#################################
#     Who are these people?     #
################################





















