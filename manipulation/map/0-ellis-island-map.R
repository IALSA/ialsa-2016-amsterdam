# the purpose of this script is to create a data object (dto) which will hold all data and metadata from each candidate study of the exercise
# run the line below to stitch a basic html output. For elaborated report, run the corresponding .Rmd file
# knitr::stitch_rmd(script="./manipulation/map/0-ellis-island-map.R", output="./manipulation/map/stitched-output/0-ellis-island-map.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 
# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) #Pipes
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2")
requireNamespace("tidyr")
requireNamespace("dplyr") #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit") #For asserting conditions meet expected patterns.

# ---- declare-globals ---------------------------------------------------------
data_path_input  <- "../MAP/data-unshared/derived/ds0.rds"
metadata_path_input <- "./data/meta/map/meta-data-map.csv" # input file with your manual classification

# ---- load-data ---------------------------------------------------------------
ds0 <- readRDS(data_path_input)
nl <- read.csv(metadata_path_input, stringsAsFactors = F, header = T)
nl$X <- NULL # remove automatic variable
dplyr::tbl_df(nl)


# ---- dto-1 ---------------------------------------------------------
#
# There will be a total of (2) elements in (dto)
dto <- list() # creates empty list object to populate with script to follow 
#

# ---- assemble-data-object-dto-1 ----------------------------------------------------
dto <- list() # creates empty list object to populate with script to follow 
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
  "cogn_global", # Global cognitive score 
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
dto[["unitData"]] <- ds

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

# ---- collect-meta-data -----------------------------------------
# prepare metadata to be added to the dto
# we begin by extracting the names and (hopefuly their) labels of variables from each dataset
# and combine them in a single rectanguar object, long/stacked with respect to study names
save_csv <- names_labels(ds)
write.csv(save_csv,"./data/meta/map/names-labels-live.csv",row.names = T)

# ----- import-meta-data-dead-dto-2 -----------------------------------------
# after the final version of the data files used in the excerside have been obtained
# we made a dead copy of `./data/shared/derived/meta-raw-live.csv` and named it `./data/shared/meta-data-map.csv`
# decisions on variables' renaming and classification is encoded in this map
# reproduce ellis-island script every time you make changes to `meta-data-map.csv`
dto[["metaData"]] <- read.csv("./data/meta/map/meta-data-map.csv")
dto[["metaData"]]["X"] <- NULL # remove native counter variable, not needed

# ----- view-metadata-1 ---------------------------------------------
meta_data <- dto[["metaData"]] %>%
  dplyr::filter(type %in% c('substance')) %>%
  # dplyr::select(name, name_new, type, label, construct) %>%
  dplyr::arrange(name)
knitr::kable(meta_data)

# ----- apply-meta-data-1 -------------------------------------
# rename variables

d_rules <- dto[["metaData"]] %>%
  dplyr::filter(name %in% names(ds)) %>% 
  dplyr::select(name, name_new ) # leave only collumn, which values you wish to append
names(ds) <- d_rules[,"name_new"]

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



















