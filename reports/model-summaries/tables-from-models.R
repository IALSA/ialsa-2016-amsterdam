rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
#Load any source files that contain/define functions, but that don't load any other types of variables
#   into memory.  Avoid side effects and don't pollute the global environment.
# source("./SomethingSomething.R")

# ---- load-packages -----------------------------------------------------------
library(ggplot2) #For graphing
library(magrittr) #Pipes
requireNamespace("readxl")

requireNamespace("knitr", quietly=TRUE)
requireNamespace("scales", quietly=TRUE) #For formating values in graphs
requireNamespace("RColorBrewer", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE)

# ---- load-sources ------------------------------------------------------------
base::source("./scripts/ELECT-utility-functions.R") # ELECT utility functions

# ---- declare-globals ---------------------------------------------------------
path_commong <- "./data/shared/raw/models/msm-model-"
# ---- load-data ---------------------------------------------------------------
lasa <- readRDS("./data/shared/raw/models/msm-model-lasa.rds")
lbc  <- readRDS("./data/shared/raw/models/msm-model-lbc1921.rds")
map  <- readRDS("./data/shared/raw/models/msm-model-map.rds")
wh   <- readRDS("./data/shared/raw/models/msm-model-whitehall.rds")
# create list objects containing models with full msm estimation info
ls_model <- list(
  "lasa" = lasa,
  "lbc"  = lbc,
  "map"  = map,
  "wh"   = wh
)
# create list object with tables of hazard ratios
ls_odds <- list()
for(i in names(ls_model)){
  # i <- 1
  ls_odds[[i]] <- print_hazards( ls_model[[i]], dense = F)
}

# ---- tweak-data -----------------------------
# review the spellings of covariates 
unique(ls_odds$lasa$predictor) %>% as.character()
unique(ls_odds$lbc$predictor)%>% as.character()
unique(ls_odds$map$predictor)%>% as.character()
unique(ls_odds$wh$predictor)%>% as.character()
# construct listing of possible names for each predictor
covar_age          <- c("age")
covar_male         <- c("male","gender")
covar_edu_med_low  <- c("edu_low_med", "edumed","dummy2", "edu_cat_dum2")
covar_edu_high_low <- c("edu_low_high", "eduhigh","dummy1", "edu_cat_dum1")
covar_ses          <- c("inkomen", "ses","sescat")
# force all models to have the same spelling of covariates
for(i in names(ls_odds)){
  ls_odds[[i]] <- ls_odds[[i]] %>% 
    dplyr::mutate(
      predictor = ifelse(predictor %in% covar_age,          "age",
                  ifelse(predictor %in% covar_male,         "male",
                  ifelse(predictor %in% covar_edu_high_low, "edu_high_low",
                  ifelse(predictor %in% covar_edu_med_low,  "edu_med_low",
                  ifelse(predictor %in% covar_ses,          "ses", NA )))))
    )
}
# combine into a single dataset
ds_odds <- plyr::ldply(ls_odds, .id = "study")
# create a dense column
ds_long <- ds_odds %>% 
  dplyr::mutate(
    hr    = sprintf("%0.2f", HR),
    lo    = sprintf("%0.2f", L),
    hi    = sprintf("%0.2f", U),
    dense = sprintf("%4s (%4s,%5s)", hr, lo, hi),
    dense = ifelse(dense =="1.00 (1.00, 1.00)", NA, dense)
  ) %>% 
  dplyr::select(
    study, transition, predictor, dense
  )
# spread into a wide format
ds_wide <- ds_long %>% 
  tidyr::spread(key = study, value = dense) %>% 
  dplyr::arrange(predictor, transition)

# ---- print-table-2 --------------------------
ds_wide %>% 
  knitr::kable()


# ----- publisher --------------------
path <- "./reports/model-summaries/table-2.Rmd"
rmarkdown::render(
  input = path ,
  output_format=c(
    "html_document" 
    ,"word_document"
  ),
  clean=TRUE
)



# ---- dummy ----------------
### todo


# remove rows on which all studies have NA
row_to_keep = which(all( is.na(ds_wide[col_names]) ))
is.na(ds_wide[col_names])


rows_to_keep <- rep(NA,nrow(ds_wide))
col_names <- setdiff(names(ds_wide),c("transition","predictor"))
for(i in nrow(ds_wide)){
 # i <- 6
 rows_to_keep[i] <-  all(is.na(ds_wide[6,col_names]))
}

d <- ds_wide
unique(ls_odds$lasa$predictor) %>% as.character()
unique(ls_odds$lbc$predictor)%>% as.character()
unique(ls_odds$map$predictor)%>% as.character()
unique(ls_odds$wh$predictor)%>% as.character()



















