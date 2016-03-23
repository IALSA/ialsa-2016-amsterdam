# knitr::stitch_rmd(script="./reports/vignette-ELECT/vignette-ELECT.R", output="./reports/vignette-ELECT/vignette-ELECT.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
base::source("./scripts/common-functions.R") # used in multiple reports
base::source("./scripts/graph-presets.R") # fonts, colors, themes 
base::source("http://www.ucl.ac.uk/~ucakadl/ELECT.r") # load  ELECT functions

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
requireNamespace("tidyr") # data manipulation
requireNamespace("dplyr") # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")# For asserting conditions meet expected patterns.
# requireNamespace("car") # For it's `recode()` function.
requireNamespace("msm") # multistate modeling
requireNamespace("flexsurv") # parameteric survival and multi-state
requireNamespace("mstate") # multistate modeling
requireNamespace("foreign") # data input

# ---- declare-globals ---------------------------------------------------------
# point to the data file used in Example 1 of the official ELECT vignette
path_data_example_i <- "./data/shared/raw/dataExample1.RData"

# ---- load-data ---------------------------------------------------------------
load(path_data_example_i)
ds <- dplyr::tbl_df(data)

# ---- inspect-data -------------------------------------------------------------
head(ds) # top few rows
ds %>% dplyr::filter(id %in% c("4","5")) # specific ids
# NOTE: 
ds %>% dplyr::summarise(unique_ids = n_distinct(id)) # subject count
ds %>% dplyr::group_by(state) %>% dplyr::summarize(count = n()) # basic frequiencies
# NOTE: -2 is a right censored value, indicating being alive but in an unknown living state.
lapply(ds[, c("age","ybirth")], summary) # basic stats 
histogram_discrete(ds,"state")
histogram_continuous(ds, "ybirth", bin_width = 1)
histogram_continuous(ds, "age", bin_width = 1)


# ---- quality-check-1 ---------------------------------------------------------
# For the fitting of the model it is essential that consecutive records for one individual do not contain the same age. 
# This would imply that no time has passed between the two observations. 
# For this reason rounding age to whole years is not recommended 

# compose an algorythm for testing this


# ---- tweak-data --------------------------------------------------------------



# ---- section-2.2 ------------------------------------------------------------
cat("Sample size:"); print(length(table(data$id)))
cat("Frequencies observed state:"); print(table(data$state))
cat("State table:"); print(msm::statetable.msm(state,id,data=data))










