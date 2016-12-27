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
source("./scripts/graph-presets.R")
source("./scripts/graphs-specific.R")

# ---- declare-globals ---------------------------------------------------------
lvl_predictors <- c(
  "Age"                = "age"                                 
  ,"Sex"               = "sex"                 
  ,"Edu: Med vs Low"   = "edu_med_low"                     
  ,"Edu: High vs Low"  = "edu_high_low"                     
  ,"SES"               = "ses"                 
)
# lvl_transitions <- c(
#    "1-->2" = "State 1 - State 2"
#   ,"1-->4" = "State 1 - State 4"
#   ,"2-->1" = "State 2 - State 1"
#   ,"2-->3" = "State 2 - State 3"
#   ,"2-->4" = "State 2 - State 4"
#   ,"3-->4" = "State 3 - State 4"
# )
lvl_transitions <- c(
    "State 1 - State 2" = "1-->2"
  , "State 1 - State 4" = "1-->4"
  , "State 2 - State 1" = "2-->1"
  , "State 2 - State 3" = "2-->3"
  , "State 2 - State 4" = "2-->4"
  , "State 3 - State 4" = "3-->4"
)
lvl_studies <- c(
  "OCTO-Twin"    = "octo"                
  ,"LASA"        = "lasa"          
  ,"Whitehall"   = "wh"               
  ,"H70"         = "h70"         
  ,"LBC1921"     = "lbc"             
  ,"MAP"         = "map"         
)

# ---- load-data -----------------------------
# input list objects with estimated models from all studies
ls_models <- readRDS("./data/unshared/derived/ls_models.rds")
# input long data.frame of hazard ratios
ds_odds_long <- readRDS("./data/shared/derived/summary-tables/table-2-odds.rds")
# input wide data.frame with life expectancies
ds_le_wide <-  readxl::read_excel("./data/shared/raw/misc/results.xlsx", sheet = "le")

# extract sample size
sample_size <- c()
for(i in names(ls_models)){
  sample_size[i] = length(unique(ls_models[[i]]$data$mf$`(subject)`))
}

 
# ----- tweek-data --------------------------

# groom hazard ratios
regex_estimator <- "^(-?\\d+.\\d+)\\s*\\((\\d+.\\d+),\\s*(-?\\d+.\\d+)\\)$"
regex_state <- "^\\s*State (\\d).*State (\\d)$"
ds_odds <- ds_odds_long %>%
  dplyr::mutate(
    outgoing = as.numeric(gsub(regex_state,"\\1",transition,perl=T)),
    incoming = as.numeric(gsub(regex_state,"\\2",transition,perl=T)),
    trans = paste0(outgoing,"-->",incoming)
  ) %>%
  # prepare factors
  dplyr::mutate(
    trans = factor(trans, levels = lvl_transitions),
    trans = factor(trans, levels = rev(levels(trans))),
    study = factor(study, levels = lvl_studies,labels = names(lvl_studies)),
    predictor = factor(predictor, levels =lvl_predictors, label = names(lvl_predictors))
  )
head(ds_odds)
   

# groom life expectancies
regex_estimator <- "^(-?\\d+.\\d+)\\s*\\((\\d+.\\d+),\\s*(-?\\d+.\\d+)\\)$"
ds_le <- ds_le_wide %>% tidyr::gather_('study',"value", c("octo","lasa","h70","lbc1921","map")) %>%
  dplyr::mutate(
    est      = as.numeric(gsub(regex_estimator,"\\1",value,perl=T)),
    low      = as.numeric(gsub(regex_estimator,"\\2",value,perl=T)),
    high     = as.numeric(gsub(regex_estimator,"\\3",value,perl=T))
  ) %>% 
  dplyr::mutate(
    age = factor(age),
    condition = factor(condition, levels = c(
      "Female, Educ(H), SES(H)",
      "Female, Educ(M), SES(M)",
      "Female, Educ(L), SES(L)",
      "Male, Educ(H), SES(H)",
      "Male, Educ(M), SES(M)",
      "Male, Educ(L), SES(L)"
    )),
    edu       = factor(edu, levels = c("high","medium","low")),
    condition = factor(condition, levels = rev(levels(condition))),
    sex_group = factor(paste0(sex,"-",group)),
    group_sex = factor(paste0(group,"-",sex)),
    group_age = factor(paste0(group,"-",age)), 
    age_group = factor(paste0(age,"-",group)),
    age_group = factor(age_group, levels = c(
      "80-total" , "80-non-impaired","85-total","85-non-impaired" 
    )),
    age_sex   = factor(paste0(age,"-",sex)),
    sex_age   = factor(paste0(sex,"-",age)),
    group_tertile = factor(paste0(group,"-",edu)),
    group_tertile = factor(group_tertile, levels = c(
      "non-impaired-low","non-impaired-medium", "non-impaired-high",
      "total-low", "total-medium","total-high"
      
    ))
  )

# ---- prepare-odds-tables -------------------------
# spread into a wide format
ds_odds_wide <- ds_odds_long %>% 
  dplyr::select(-HR,-U,-L) %>% 
  tidyr::spread(key = study, value = dense) %>% 
  dplyr::mutate(
    predictor = factor(predictor, 
                       levels = c("age","male","edu_med_low","edu_high_low", "ses"),
                       labels = c("Age","Sex","Med vs Low Education","High vs Low Education", "SES"))
  ) 
ds_odds_wide[is.na(ds_odds_wide)] <- "---"
ds_odds_wide <- ds_odds_wide %>% 
  dplyr::mutate(
    include = ifelse(octo =="---" &
                       lasa =="---" &
                       lbc =="---" &
                       h70 =="---" &
                       map =="---" &
                       wh =="---", FALSE,TRUE)
  ) %>% 
  dplyr::filter(include==TRUE) %>% 
  dplyr::arrange(predictor, transition) %>% 
  dplyr::select(-include)



# ---- print-dynamic-table-2 --------------------------
ds_odds_wide %>% 
  DT::datatable()
# ---- print-static-table-2 ---------------------------
col_header <- c("Transition", "Predictor",names(lvl_studies)) %>% as.character()
ds_odds_wide %>% knitr::kable(col.names=col_header, format="pandoc") %>% print()

for(i in levels(ds_odds_wide$predictor)){
  # i <- "Age"
  cat("\n",i)
  ds_odds_wide %>% 
    dplyr::filter(predictor==i) %>% 
    dplyr::select(-predictor)%>% 
    knitr::kable(
      col.names = rep("",ncol(ds_odds_wide)-1),
      format="pandoc"
      # col.names = setdiff(col_header,"Predictor")
    ) %>% 
    print()
  cat("\n")
}


# ---- print-plot-odds --------------------
head(ds_odds)
ds_odds %>% 
  dplyr::rename(est=HR,low=L,high=U) %>% 
  dplyr::mutate(study = unclass(study))
head(ds_odds)
  plot_odds("trans", "OCTO-Twin", "Age")
# ds_odds %>% plot_odds("study", "1-->4","age")
# ds_odds %>% plot_odds("predictor", "octo","1-->4")


name <- "transition-by-predictor"
supermatrix_odds(
  ls_graphs = list(
    matrix_odds(ds_odds,"study",lvl_transitions,"age")
    , matrix_odds(ds_odds,"study",lvl_transitions,"sex")
    , matrix_odds(ds_odds,"study",lvl_transitions,"edu_med_low")
    , matrix_odds(ds_odds,"study",lvl_transitions,"edu_high_low")
    , matrix_odds(ds_odds,"study",lvl_transitions,"ses")
  ),
  folder_name = folder,
  plot_name = name,
  main_title = title,
  width = 1200,
  height= 1200,
  res = 120
)

name <- "study-by-predictor"
supermatrix_odds(
  ls_graphs = list(
    matrix_odds(ds_odds,"trans",lvl_studies,"age")
    , matrix_odds(ds_odds,"trans",lvl_studies,"sex")
    , matrix_odds(ds_odds,"trans",lvl_studies,"edu_med_low")
    , matrix_odds(ds_odds,"trans",lvl_studies,"edu_high_low")
    , matrix_odds(ds_odds,"trans",lvl_studies,"ses")
  ),
  folder_name = folder,
  plot_name = name,
  main_title = title,
  width = 1200,
  height= 1200,
  res = 120
)

name <- "study-by-transition"
supermatrix_odds(
  ls_graphs = list(
    matrix_odds(ds_odds,"predictor",lvl_studies,"1-->2")
    ,matrix_odds(ds_odds,"predictor",lvl_studies,"1-->4")
    ,matrix_odds(ds_odds,"predictor",lvl_studies,"2-->1")
    ,matrix_odds(ds_odds,"predictor",lvl_studies,"2-->3")
    ,matrix_odds(ds_odds,"predictor",lvl_studies,"2-->4")
    ,matrix_odds(ds_odds,"predictor",lvl_studies,"3-->4")
  ),
  folder_name = folder,
  plot_name = name,
  main_title = title,
  width = 1200,
  height= 1200,
  res = 120
)

# ----- publisher --------------------
path <- "./reports/model-summaries/table-2.Rmd"

rmarkdown::render(
  input = path ,
  output_format=c(
    # "html_document" 
    "word_document"
    # ,"pdf_document"
  ),
  clean=TRUE
)

