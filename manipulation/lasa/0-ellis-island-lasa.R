# The purpose of this script is to create a data object (dto) which will hold all data and metadata.
# Run the lines below to stitch a basic html output. 
# knitr::stitch_rmd(
#   script="./manipulation/lasa/0-ellis-island-lasa.R",
#   output="./manipulation/lasa/stitched-output/0-ellis-island-lasa.md"
# )
# The above lines are executed only when the file is run in RStudio, !! NOT when an Rmd/Rnw file calls it !!

############################
##  Land on Ellis Island  ##
############################

rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-sources ------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  
# Ideally, no real operations are performed in these sourced scripts. 
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/lasa-functions.R")

# ---- load-packages ----------------------------------------------
# Attach packages so their functions don't need to be qualified when used
# See more : http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # Pipes
library(ggplot2) # Graphs
# Functions of these packages will need to be qualified when used
# See more: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("tidyr") #  data manipulation
requireNamespace("dplyr") # f() names conflict with other packages (esp. base, stats, and plyr).
requireNamespace("testit") # for asserting conditions meet expected patterns.

# ---- declare-globals ----------------------------------------------
# reach out to the curator for a dataset prepared for general consumption
data_path_input  <- "../LASA/data-unshared/derived/datas.rds"
# point to the local metadata to be used for this project (specific consumption)
# metadata_path_input <- "./data/shared/meta/lasa/meta-data-lasa.csv" 

# ---- load-data ------------------------------------------------
# load data objects
datas <- readRDS(data_path_input) 
# metaData <- read.csv(metadata_path_input, stringsAsFactors=F, header=T)


# ---- examine-structure-of-input-object ---------------------
# Level 1
lapply(datas, names) # view domains, level 1 in the list
# Level 2
lapply(datas$cognitive, names) # view filenumber, level 2, many filenumbers in a domain
# Level 3
names(datas$cognitive[["035"]])

names_labels_datas("cognitive","035", "H") %>% dplyr::slice(1:10)
names_labels(datas$cognitive$`035`$H)%>% dplyr::slice(1:10)

# ---- combine-items --------------------------
# age
demo_1 <- merge_lasa_files(datas[["demographic"]][["008"]]) 
head(demo_1)
# gender, birth year, birth cohort, education
demo_2 <- datas[["demographic"]][["004"]][["Z"]] %>%  
  dplyr::mutate(
    id            = respnr,
    male          = as.logical(ifelse(!is.na(sex), sex=="male", NA_integer_)),
    edu           = as.numeric(aedu)
  ) %>%
  dplyr::select(respnr,male, byear, bycohort, edu)
head(demo_2)
mmse_items <- merge_lasa_files(datas[["cognitive"]][["021"]])
mmse_score <- merge_lasa_files(datas[["cognitive"]][["221"]])


# ---- extract-raw-meta-data ---------------------
extract_meta_data <- function(d, name){
  meta <- names_labels(d)
  filePath <- paste0("./data/shared/meta/lasa/live/",name,"-live.csv")
  write.csv(meta, filePath)
}

extract_meta_data(demo_1, "age")
# no need to export demo_2 metadata: it contains no longitudinal variables
extract_meta_data(mmse_items, "mmse_items")
extract_meta_data(mmse_score, "mmse_score")
# ----- augment-meta-data -----------------------

# this step occurs outside of RStudio
# for each save file
# save a dead copy of the file and then add columns containing meta-data




# ----- elongate-age -------------------------------
metaData <- read.csv("./data/shared/meta/lasa/meta-age-dead.csv", stringsAsFactors = F)
# create clean wide data
ds_wide <- demo_1 %>%
  dplyr::select_(.dots = metaData$name[!is.na(metaData$include)])
colnames(ds_wide) <- plyr::mapvalues(
  x      = colnames(ds_wide),
  from   = metaData$name[!is.na(metaData$include)],
  to     = metaData$name_new[!is.na(metaData$include)]
)
# list time-invariant(static) and time-variant(longitudinal) variables
variables_static <- as.data.frame(
  metaData %>% 
    dplyr::filter(longitudinal == FALSE) %>% 
    dplyr::select(name_new)
)$name_new
variables_longitudinal <- setdiff(colnames(ds_wide),variables_static)  # not static
# define regex rule for splitting up the names of variables
regex <- "(\\w+)_(\\d+)"
# elongate with respect to wave of measurement
ds_long <- ds_wide %>%
  tidyr::gather_(key="variable", value="value", variables_longitudinal) %>%
  dplyr::mutate( 
    wave     = as.integer(gsub(regex,"\\2", variable)),
    variable        = gsub(regex, "\\1",variable) 
  )  %>% 
  tidyr::spread(variable, value)
head(ds_long)
ds_long_age <- ds_long


# ----- elongate-mmse_score -------------------------------
metaData <- read.csv("./data/shared/meta/lasa/meta-mmse_score-dead.csv", stringsAsFactors = F)
# create clean wide data
ds_wide <- mmse_score %>%
  dplyr::select_(.dots = metaData$name[!is.na(metaData$include)])
colnames(ds_wide) <- plyr::mapvalues(
  x      = colnames(ds_wide),
  from   = metaData$name[!is.na(metaData$include)],
  to     = metaData$name_new[!is.na(metaData$include)]
)
# list time-invariant(static) and time-variant(longitudinal) variables
variables_static <- as.data.frame(
  metaData %>% 
    dplyr::filter(longitudinal == FALSE) %>% 
    dplyr::select(name_new)
)$name_new
variables_longitudinal <- setdiff(colnames(ds_wide),variables_static)  # not static
# define regex rule for splitting up the names of variables
regex <- "(\\w+)_(\\d+)"
# elongate with respect to wave of measurement
ds_long <- ds_wide %>%
  tidyr::gather_(key="variable", value="value", variables_longitudinal) %>%
  dplyr::mutate( 
    wave     = as.integer(gsub(regex,"\\2", variable)),
    variable        = gsub(regex, "\\1",variable) 
  )  %>% 
  tidyr::spread(variable, value)
head(ds_long)
ds_long_mmse <- ds_long


# ----- merge-long-data ----------------
# todo: implement, currently not working
dtos <- list(ds_long_age,demo_2, ds_long_mmse)
head(ds_long_age)
head(demo_2)
head(ds_long_mmse)
names(dtos)

ds <- plyr::ldply(list_to_combine, data.frame)




#####################################################
# below is code inherited from 0-ellis-island-map.R
#####################################################

# ---- inspect-data ----------------------------------------------
# inspect loaded data objects (using basic demographic variables )
ds <- unitData # assing alias
length(unique(ds$id)) # there are this many of subjects
t <- table(ds[,"fu_year"], ds[,"died"]); t[t==0]<-".";t
t <- table(ds[,"msex"], ds[,"race"], useNA = "always"); t[t==0]<-".";t
t <- table(ds[,"educ"], ds[,"race"]); t[t==0]<-".";t

# ---- assemble-data-object-dto-1 --------------------------------------
dto <- list()
# the first element of data transfer object contains unit data
dto[["unitData"]] <- unitData
# the second element of data transfer object contains meta data
dto[["metaData"]] <-  metaData
# verify and glimpse
dto[["unitData"]] %>% dplyr::glimpse()
dto[["metaData"]] %>% dplyr::glimpse()


# ----- view-metadata-1 ---------------------------------------------
meta_data <- dto[["metaData"]] %>%
  dplyr::filter(include == TRUE) %>%
  # dplyr::select(name, name_new, type, label, construct) %>%
  dplyr::arrange(type, construct, name)
knitr::kable(meta_data)

# ----- apply-meta-data-1 -------------------------------------
# rename variables
d_rules <- dto[["metaData"]] %>%
  dplyr::filter(name %in% names(ds)) %>% 
  dplyr::select(name, name_new ) # leave only collumn, which values you wish to append
names(ds) <- d_rules[,"name_new"]
# transfer changes to dto
ds <- ds %>% dplyr::filter(study == "MAP ")
table(ds$study)
dto[["unitData"]] <- ds 

# ---- save-to-disk ------------------------------------------------------------

# Save as a compressed, binary R dataset.  
# It's no longer readable with a text editor, but it saves metadata (eg, factor information).
saveRDS(dto, file="./data/unshared/derived/dto.rds", compress="xz")

# ---- object-verification ------------------------------------------------
# the production of the dto object is now complete
# we verify its structure and content:
dto <- readRDS("./data/unshared/derived/dto.rds")
names(dto)
# 1st element - unit(person) level data
names(dto[["unitData"]])
# 2nd element - meta data, info about variables
names(dto[["metaData"]])













