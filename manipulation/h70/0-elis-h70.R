# knitr::stitch_rmd(script="./___/___.R", output="./___/stitched-output/___.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 
source("http://www.ucl.ac.uk/~ucakadl/ELECT.r") # load  ELECT functions

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
path_file <- "./data/unshared/raw/h70/Koh1930Vars_70_75_79_short.sav"
# ---- load-data ---------------------------------------------------------------
ds <- Hmisc::spss.get(path_file, use.value.labels = TRUE, datevars = "avldat" )
head(ds)
# ---- inspect-data -------------------------------------------------------------
names_labels(ds)

# ---- tweak-data --------------------------------------------------------------
length(unique(ds$lopnr))
table(ds$sex)
table(ds$far)
summary(ds$avl)
