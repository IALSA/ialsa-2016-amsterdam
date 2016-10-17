#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load-packages -----------------------------------------------------------
library(magrittr) #Pipes
library(msm)
requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) 
requireNamespace("testit", quietly=TRUE)

# ---- load-sources ------------------------------------------------------------
# base::source("http://www.ucl.ac.uk/~ucakadl/ELECT/ELECT.r") # load  ELECT functions
base::source("./scripts/ELECT.r") # load  ELECT functions
base::source("./scripts/ELECT-utility-functions.R") # ELECT utility functions
base::source("./scripts/common-functions.R") # used in multiple reports
base::source("./scripts/graph-presets.R") # fonts, colors, themes 
base::source("./scripts/general-graphs.R")
base::source("./scripts/specific-graphs.R")
# ---- declare-globals ---------------------------------------------------------
path_folder <- "./data/shared/derived/models/model-b"
digits = 2
cat("\n Save fitted models here : \n")
print(path_folder)

# ---- load-data ---------------------------------------------------------------
# first, the script `0-ellis-island.R` imports and cleans the raw data
# second, the script `1-encode-multistate.R` augments the data with multi-states
# load this data transfer object (dto)
# dto <- readRDS("./data/unshared/derived/dto.rds") # original, prepared data
# ds_clean <- readRDS("./data/unshared/ds_clean.rds") # data used for estimation
# ds <- readRDS("./data/unshared/ds_estimation.rds") # same ids but fewer variables

# import simulation objects
(path_files <- list.files(file.path(path_folder),full.names=T, pattern="mB_v1_"))
models <- list()
for(i in seq_along(path_files)){
  (min_age <- strsplit(path_files[i], split = "_")[[1]][3])
  models[[paste0("age_",min_age)]] <- readRDS(path_files[i])
}

# ---- inspect-data -------------------------------------------------------------
lapply(models, names)

model <- models$age_60
le    <- model$le[[1]]
summary.elect(le)
plot.elect(le)
print_hazards(model$msm)

# ---- create-pooled-dataset -----------------------
desc <- list()
for(i in names(models)){
  desc[[i]] <- models[[i]]$descriptives
}
lapply(desc, names) # inspect
results <- plyr::ldply(desc, data.frame)
# groom
results <- results %>% 
  dplyr::rename(
    min_age = .id
    ,q_025  = X0.025q
    ,q_5    = X0.5q
    ,q_975  = X0.975q
    ) %>% 
  dplyr::mutate(
    min_age = as.numeric(gsub("(\\w+)_(\\d+)", "\\2", min_age))
    ,male  = factor(male)
    ,pnt   = as.numeric(pnt)
    ,mn    = as.numeric(mn)
    ,se    = as.numeric(se)
    ,q_025 = as.numeric(q_025)
    ,q_5   = as.numeric(q_5)
    ,q_975 = as.numeric(q_975)
  )
str(results)

# ----- graph-development ------------------
unique(results$e_name)
table(results$e_name)
ds <- results %>% 
   dplyr::filter(
     e_name == "e12"
     # , condition_n == 1
    ) 
temp <- ds

g <- ggplot2::ggplot(data=ds,aes(x = min_age, y=pnt, color=male) ) +
  geom_point(aes(shape=factor(sescat)), size = 3) +
  # geom_line()+
  # geom_point(aes(y=mn), color = "red") +
  # geom_point(aes(y=q_5), color = "blue")
  # facet_grid(sescat ~ educat)+
  # facet_grid(edu_low_med ~ edu_low_high)+
  facet_grid(. ~ educat)+
  # scale_y_continuous(limits = c(0,25), breaks = seq(0,25,by=5)) +
  main_theme
g
















