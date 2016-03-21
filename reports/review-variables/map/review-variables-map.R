# knitr::stitch_rmd(script="./review-variable/review-variable-map.R", output="./review-variable/stitched-output/review-variable-map.md")
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
ds <- readRDS(data_path_input)
nl <- read.csv(metadata_path_input, stringsAsFactors = F, header = T)
nl$X <- NULL # remove automatic variable
dplyr::tbl_df(nl)


t <- table(ds$race, ds$fu_year, useNA="always"); t[t==0]<-".";t
d <- ds[c("id", "fu_year", "race")]

# ---- assemble-data-object ----------------------------------------------------
# create a data object that will be used for subsequent analyses
# select variables you will need for modeling
selected_items <- c(
  "id", # personal identifier
  "age_bl", # Age at baseline
  "age_death", # Age at death
  "died", # Indicator of death
  "msex", # Gender
  "race", # Participant's race
  "educ", # Years of education

  # time-invariant above
  "fu_year", # Follow-up year ------------------------------------------------
  # time-variant below
  
  "age_at_visit", #Age at cycle - fractional
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

d <- ds[ , selected_items]
table(d$fu_year)


# ---- inspect-data -------------------------------------------------------------

# ---- tweak-data --------------------------------------------------------------


# ---- sample-composition -------------------------------------------------------
# who are these people? 
# basic demographic variables
length(unique(ds$id)) # there are this many of them
ds %>% dplyr::group_by_("msex") %>% dplyr::summarise(count = n())
ds %>% dplyr::group_by_("race") %>% dplyr::summarise(count = n())
table(ds$msex, ds$race)
table(ds["educ"])
histogram_discrete(ds, variable_name = "educ") 
d <- ds %>% dplyr::group_by_("educ") %>% dplyr::summarize(count = n())
print(d, n=nrow(d))

histogram_continuous(ds, variable_name = "age_at_visit", bin_width = 1)
histogram_continuous(ds, variable_name = "educ",bin_width = 1)
