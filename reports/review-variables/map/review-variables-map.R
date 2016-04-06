# knitr::stitch_rmd(script="./___/___.R", output="./___/___/___.md")
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

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
# requireNamespace("readr") # data input
requireNamespace("tidyr") # data manipulation
requireNamespace("dplyr") # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")# For asserting conditions meet expected patterns.
# requireNamespace("car") # For it's `recode()` function.

# ---- declare-globals ---------------------------------------------------------

# ---- load-data ---------------------------------------------------------------
# load the product of 0-ellis-island.R,  a list object containing data and metadata
dto <- readRDS("./data/unshared/derived/dto.rds")
# each element this list is another list:
names(dto)
# 3rd element - data set with unit data
dplyr::tbl_df(dto[["unitData"]]) 
# 4th element - dataset with augmented names and labels of the unit data
dplyr::tbl_df(dto[["metaData"]])
# assing aliases
ds0 <- dto[["unitData"]]
ds <- ds0

# ---- meta-table --------------------------------------------------------
dto[["metaData"]] %>%  
  DT::datatable(
    class   = 'cell-border stripe',
    caption = "This is a dynamic table of the metadata file. Edit at `./data/meta/map/meta-data-map.csv",
    filter  = "top",
    options = list(pageLength = 6, autoWidth = TRUE)
  )


# ---- inspect-data -------------------------------------------------------------

# ---- tweak-data --------------------------------------------------------------

# ---- basic-table --------------------------------------------------------------

# ---- basic-graph --------------------------------------------------------------
# this is how we can interact with the `dto` to call and graph data and metadata
dto[["metaData"]] %>% 
  dplyr::filter(type=="demo") %>% 
  dplyr::select(name,name_new,label)

dto[["unitData"]]%>%
  histogram_continuous("age_death", bin_width=1)

# ---- B-1-N-at-baseline -------------------------------------------------------
dto[["metaData"]] %>% dplyr::filter(name=="fu_year")
ds %>% 
  dplyr::group_by_("fu_year") %>%
  dplyr::summarize(n=n())

# ----- B-2-cognitive-outcomes -------------------------------------------------
dto[["metaData"]] %>% dplyr::filter(type=="cognitive")

# ----- B-3-dementia-diagnosis -------------------------------------------------
dto[["metaData"]] %>% dplyr::filter(name=="dementia")

dto[["unitData"]] %>% 
  dplyr::group_by_("fu_year","dementia") %>% 
  dplyr::summarize(count=n())
dto[["unitData"]] %>% 
  dplyr::filter(!is.na(dementia)) %>% 
  dplyr::group_by_("fu_year") %>% 
  dplyr::summarize(percent_diagnosed=mean(dementia),
                   observed_n = n())


# ---- B-4-education -----------------------------------------------------------
dto[["metaData"]] %>% dplyr::filter(name=="educ")
# shows attrition in each education group
t <- table(ds$educ, ds$fu_year); t[t==0]<-".";t
# response categories
dto[["unitData"]] %>% 
  dplyr::group_by_("educ") %>% 
  dplyr::summarize(count=n())
# descriptives by follow-up year
dto[["unitData"]] %>% 
  dplyr::filter(!is.na(educ)) %>% 
  dplyr::group_by_("fu_year") %>% 
  dplyr::summarize(average_years_edu=mean(educ),
                   SD=sd(educ),
                   observed_n = n())


# ---- B-4-social-class -----------------------------------------------------------

# ---- B-5-bmi -----------------------------------------------------------

dto[["metaData"]] %>% dplyr::filter(name %in% c("bmi","wtkg", "htm"))
# descriptives by follow-up year
dto[["unitData"]] %>% 
  dplyr::filter(!is.na(bmi)) %>% 
  dplyr::group_by_("fu_year") %>% 
  dplyr::summarize(average_years_edu=mean(bmi),
                   SD=sd(bmi),
                   observed_n = n())

# ---- B-6-smoking -----------------------------------------------------------
dto[["metaData"]] %>% dplyr::filter(construct %in% c("smoking"))


# ---- reproduce ---------------------------------------
rmarkdown::render(
  input = "./reports/review-variables/map/review-variables.Rmd" ,
  output_format="html_document", clean=TRUE
)