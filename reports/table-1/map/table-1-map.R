# knitr::stitch_rmd(script="./reports/review-variables/map/review-variables-map.R", output="./reports/review-variables/map/review-variables-map.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 
source("./scripts/general-graphs.R")
source("./scripts/specific-graphs.R")
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
# requireNamespace("readr") # data input
requireNamespace("tidyr") # data manipulation
requireNamespace("dplyr") # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")# For asserting conditions meet expected patterns.
# requireNamespace("car") # For it's `recode()` function.

# ---- declare-globals ---------------------------------------------------------

# ---- load-data ---------------------------------------------------------------
# # load the object prepared by ./manipulation/map/2-estimate-models.R en route estimation
# ds <- readRDS("./data/unshared/derived/ds_clean-map.rds")

# load the product of 0-ellis-island.R,  a list object containing data and metadata
# data_path_input  <- "../MAP/data-unshared/derived/ds0.rds" # original 
dto <- readRDS("./data/unshared/derived/dto.rds") # local copy
# each element this list is another list:
names(dto)
# 3rd element - data set with unit data. Inspect the names of variables:
names(dto[["unitData"]])
# 4th element - dataset with augmented names and labels of the unit data
knitr::kable(head(dto[["metaData"]]))
# assing aliases
ds0 <- dto[["unitData"]]



# ---- tweak-data --------------------------------------------------------------
ds <- ds0 %>%  # to leave a clean copy of the ds, before any manipulation takes place
  dplyr::mutate(
    age_bl    = as.numeric(age_bl),
    age_death = as.numeric(age_death), 
    male      = as.logical(ifelse(!is.na(msex), msex=="1", NA_integer_)),
    edu       = as.numeric(educ)
  ) %>% 
  dplyr::select_(
    "id",
    "fu_year",
    "died",
    "age_bl",
    "male",
    "edu",
    "age_death",
    "age_at_visit",
    "mmse") 

# ---- remove-missing-age --------------------------------------------------------------
# remove the observation with missing age
sum(is.na(ds$age_at_visit)) # count obs with missing age
# ds_miss %>% 
ds %>% 
  dplyr::group_by(id) %>% 
  dplyr::summarize(n_data_points = n()) %>% 
  dplyr::group_by(n_data_points) %>% 
  dplyr::summarize(n_people=n())
# remove ids with a single data point
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

# ---- split-education ----------------------
ds_clean$educat <- cut(
  ds_clean$edu, 
  breaks = c(0, 9, 11, Inf), 
  labels = c("0-9 years", "10-11 years", ">11 years")
)

# ---- split-mmse ----------------------------
ds_clean$impairment <- cut(
  ds_clean$mmse,
  breaks = c(0, 23, 26, Inf),
  labels = c("Moderate to severe", "Mild Impairment", "No Impairment")
)

# ---- define-functions ----------------

basic_stats <- function(ds,measure_name, precision=1, remove_na = T){
  a <- lazyeval::interp(~ round(mean(var, na.rm=remove_na),precision) , var = as.name(measure_name))
  b <- lazyeval::interp(~ round(sd(var, na.rm=remove_na),precision),   var = as.name(measure_name))
  c <- lazyeval::interp(~ n())
  (dots <- list(a,b,c))
  cat("Descriptives for:", measure_name,"\n\n")
  cat("Entire sample: \n\n")
  d <- ds %>% 
    dplyr::filter(fu_year == 0) # select obs at baseline
  
  d1 <- d %>% 
    dplyr::select_(measure_name) %>% 
    dplyr::summarize_(.dots = setNames(dots, c("mean","sd","count")))
  print(d1)
  cat("\n Split up by eductaion:")
  d2 <- d %>% 
    dplyr::select_(measure_name, "educat") %>% 
    dplyr::group_by(educat) %>% 
    dplyr::summarize_(.dots = setNames(dots, c("mean","sd","count")))
  print(knitr::kable(d2), showEnv = F)
}
# basic_stats(ds,"age_bl")

basic_freqs <- function(ds, measure_name, precision = 2){ 
  # ds <- ds_clean
  (counts <- table(ds[ds$fu_year==0,measure_name], useNA = "always")) 
  (sample_size <- length(unique(ds$id)))
  (percent <- round(counts/sample_size*100,precision)) 
  (t <- cbind(counts, percent))
  (t <-stats::addmargins(t))
  # (t <- t[!rownames(t) == "Sum", ]) 
  (t <- t[,!colnames(t) == "Sum"])
  print(knitr::kable(t))
} 
# basic_freqs(ds_clean,"male")

split_freqs <- function(ds, measure_name, precision = 4){
  d <- ds[ds$fu_year==0,]
  head(d)
  (counts <- table(d[,"educat"],d[,measure_name], useNA = "always")) 
  (sample_size <- length(unique(ds$id)))
  (percent <- round(counts/sample_size*100, precision))
  (t <- cbind(counts, percent))
  (t <-stats::addmargins(t))
  (t <- t[,!colnames(t) == "Sum"])
  print(knitr::kable(t))
}
# split_freqs(ds_clean, "male")


# ---- age -------------------------------------------------------
basic_stats(ds_clean,"age_bl",precision = 1, remove_na = T)

# ---- sex ---------------------
basic_freqs(ds_clean, "male", precision = 2)
split_freqs(ds_clean, "male", precision = 2)

# ---- education ------------------------
# basic_stats(ds_clean, "edu", precision = 2, remove_na = T)
basic_freqs(ds_clean, "educat", precision = 2)

# ---- mmse ----------------
# basic_stats(ds_clean, "mmse", precision = 2, remove_na = T)
basic_freqs(ds_clean, "impairment", precision = 2)
split_freqs(ds_clean, "impairment", precision = 2)

# ---- reproduce ---------------------------------------
rmarkdown::render(
  input = "./reports/review-variables/map/review-variables.Rmd" ,
  output_format="html_document", clean=TRUE
)