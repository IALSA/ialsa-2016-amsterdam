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
# load the product of 0-ellis-island.R,  a list object containing data and metadata
# data_path_input  <- "../MAP/data-unshared/derived/ds0.rds" # original 
dto <- readRDS("./data/unshared/derived/dto.rds") # local copy
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

# ---- basic-graphs --------------------------------------------------------------
# this is how we can interact with the `dto` to call and graph data and metadata
dto[["metaData"]] %>% 
  dplyr::filter(type=="demographic") %>% 
  dplyr::select(name,name_new,label)

dto[["unitData"]]%>%
  histogram_continuous("age_death", bin_width=1)

dto[["unitData"]] %>%
  histogram_discrete("msex")


set.seed(1)
ids <- sample(ds$id,100)
d <- dto[["unitData"]] %>% dplyr::filter(id %in% ids)
g <- basic_line(d, "cogn_global", "fu_year", "salmon", .9, .1, T)
g

raw_smooth_lines(d, "cogn_global")



# ---- B-1-N-at-each-wave -------------------------------------------------------
dto[["metaData"]] %>% dplyr::filter(name=="fu_year")
ds %>% 
  dplyr::group_by_("fu_year") %>%
  dplyr::summarize(sample_size=n())

# ----- B-2-cognitive-1 -----------------------
dto[["metaData"]] %>% 
  dplyr::filter(type=="cognitive") %>% 
  dplyr::select(-name,-type,-name_new, -include) %>%
  dplyr::arrange(construct)

# ----- B-2-cognitive-2 -----------------------
dto[["metaData"]] %>% 
  dplyr::filter(type=="cognitive", include==TRUE) %>% 
  dplyr::select(-type,-name_new, - include) %>%
  dplyr::arrange(construct)

# ----- B-2-cognitive-3 -----------------------
dto[["unitData"]] %>% 
  dplyr::select(id,fu_year, cogn_global) %>% 
  dplyr::filter(!is.na(cogn_global)) %>%
  dplyr::group_by(fu_year) %>% 
  dplyr::summarize(average_global_cognition = round(mean(cogn_global),3),
                   sd = sprintf("%0.2f",sd(cogn_global)), 
                   observed =n()) 

# ----- B-2-cognitive-4 -----------------------
set.seed(1)
ids <- sample(ds$id,100)
d <- dto[["unitData"]] %>% dplyr::filter(id %in% ids)
g <- basic_line(d, "cogn_global", "fu_year", "salmon", .9, .1, T)
g


# ----- B-2-cognitive-5-cogn_global -----------------------
raw_smooth_lines(d, "cogn_global")

# ----- B-2-cognitive-5-cogn_se -----------------------
raw_smooth_lines(d, "cogn_se")

# ----- B-2-cognitive-5-cogn_ep -----------------------
raw_smooth_lines(d, "cogn_ep") 

# ----- B-2-cognitive-5-cogn_wo -----------------------
raw_smooth_lines(d, "cogn_wo") 

# ----- B-2-cognitive-5-cogn_po -----------------------
raw_smooth_lines(d, "cogn_po")

# ----- B-2-cognitive-5-cogn_ps -----------------------
raw_smooth_lines(d, "cogn_ps")

# ----- B-2-cognitive-5-cogn_ps -----------------------
raw_smooth_lines(d, "cogn_ps")

# ----- B-2-cognitive-5-mmse -----------------------
raw_smooth_lines(d, "mmse")





# ----- B-3-dementia-diagnosis -------------------------------------------------
dto[["metaData"]] %>% dplyr::filter(name=="dementia")

ds <- dto[["unitData"]] %>% 
  dplyr::filter(!is.na(dementia)) %>% 
  dplyr::group_by_("fu_year") %>% 
  dplyr::summarize(percent_diagnosed=mean(dementia),
                   observed_n = n()) 
ds

g <- ggplot2::ggplot(ds, aes_string(x="fu_year",y="percent_diagnosed")) 
g <- g + geom_line(na.rm = T)
g <- g + main_theme
g
  
ds <- dto[["unitData"]] %>% 
  dplyr::filter(!is.na(dementia)) %>% 
  dplyr::mutate(age_cat = cut(age_at_visit,breaks = 10)) %>% 
  dplyr::group_by_("age_cat") %>%
  dplyr::summarize(percent_diagnosed=mean(dementia),
                   observed_n = n())  
ds

  
  g <- ggplot2::ggplot(ds, aes_string(x="age_cat",y="percent_diagnosed")) 
  g <- g + geom_bar(stat="identity")
  g <- g + main_theme
  g
  

# ---- B-4-education -----------------------------------------------------------
dto[["metaData"]] %>% dplyr::filter(name=="educ")
# shows attrition in each education group
dto[["unitData"]] %>% 
  dplyr::filter(!is.na(educ)) %>% 
  dplyr::group_by_("fu_year") %>% 
  dplyr::summarize(average_years_edu=mean(educ),
                   SD=sd(educ),
                   observed_n = n())


# ---- B-5-social-class -----------------------------------------------------------

# ---- B-6-bmi -----------------------------------------------------------

dto[["metaData"]] %>% dplyr::filter(name %in% c("bmi","wtkg", "htm"))
# descriptives by follow-up year
dto[["unitData"]] %>% 
  dplyr::filter(!is.na(bmi)) %>% 
  dplyr::group_by_("fu_year") %>% 
  dplyr::summarize(average_bmi=mean(bmi),
                   SD=sd(bmi),
                   observed_n = n())

# ---- B-7-smoking -----------------------------------------------------------
dto[["metaData"]] %>% dplyr::filter(construct %in% c("smoking"))
t <- dto[["unitData"]] %>% 
  dplyr::filter(!is.na(q3smo_bl)) %>% 
  dplyr::group_by_("q3smo_bl") %>% 
  dplyr::summarize(n=n()) 
t 
t  %>% histogram_continuous("q3smo_bl")
  
dto[["unitData"]] %>% 
  dplyr::filter(!is.na(q3smo_bl)) %>% 
  dplyr::group_by_("fu_year") %>% 
  dplyr::summarize(average_smoking_quantity=mean(q3smo_bl),
                   SD=sd(q3smo_bl),
                   observed_n = n())

table(ds$iadlsum)

# ---- reproduce ---------------------------------------
rmarkdown::render(
  input = "./reports/review-variables/map/review-variables.Rmd" ,
  output_format="html_document", clean=TRUE
)