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
# path_input_map <- "./data-shared/raw/mhsu-service-types/mhsu-service-type-mapping-2016-09-02.csv"
path_input          <- "./data/shared/raw/results.xlsx"
testit::assert("File does not exist", base::file.exists(path_input))

lvl_predictors <- c(
  "Age"                = "age"                                 
  ,"Sex"               = "sex"                 
  ,"Edu: Med vs Low"   = "edu_med_low"                     
  ,"Edu: High vs Low"  = "edu_high_low"                     
  ,"SES"               = "ses"                 
)
lvl_transitions <- c(
  "1-->2" = "1-->2"
  ,"1-->4" = "1-->4"
  ,"2-->1" = "2-->1"
  ,"2-->3" = "2-->3"
  ,"2-->4" = "2-->4"
  ,"3-->4" = "3-->4"
)
lvl_studies <- c(
  "OCTO-Twin"    = "octo"                
  ,"LASA"        = "lasa"          
  ,"Whitehall"   = "whitehall"               
  ,"H70"         = "h70"         
  ,"LBC1921"     = "lbc"             
  ,"MAP"         = "map"         
)


# ---- load-data ---------------------------------------------------------------
# point to the SQL return to which compressors were added
ds0_odds <-  readxl::read_excel(path_input, sheet = "odds")
ds0_le <-  readxl::read_excel(path_input, sheet = "le")


# ----- groom-odds --------------------------
# regex_estimator <- "^(-?\\d+.\\d+)\\s*\\((\\d+.\\d+),\\s*(-?\\d+.\\d+)\\)$"
# regex_state <- "^\\s*State (\\d).*State (\\d)$"
# ds_odds <- ds0_odds %>% tidyr::gather('study',"value", 3:8) %>% 
#   dplyr::mutate(
#     est      = as.numeric(gsub(regex_estimator,"\\1",value,perl=T)), 
#     low      = as.numeric(gsub(regex_estimator,"\\2",value,perl=T)), 
#     high     = as.numeric(gsub(regex_estimator,"\\3",value,perl=T)), 
#     outgoing = as.numeric(gsub(regex_state,"\\1",transition,perl=T)), 
#     incoming = as.numeric(gsub(regex_state,"\\2",transition,perl=T)), 
#     trans = paste0(outgoing,"-->",incoming)
#   ) %>% 
#   # prepare factors
#   # dplyr::mutate(
#   #   trans = factor(trans, levels = levels_transitions),
#   #   trans = factor(trans, levels = rev(levels(trans))),
#   #   study = factor(study, levels = names(levels_studies),labels = levels_studies),
#   #   predictor = factor(predictor, levels = names(levels_predictors), label = levels_predictors)
#   # )
#   # prepar factors manual 
#   dplyr::mutate(
#     predictor = factor(predictor, levels = c("age",
#                                              "sex", 
#                                              "edu_med_low",
#                                              "edu_high_low",
#                                              "ses")),
#     predictor = factor(predictor, levels = rev(levels(predictor))),
#     trans      = factor(trans,      levels = c("1-->2",
#                                                "1-->4",
#                                                "2-->1",
#                                                "2-->3",
#                                                "2-->4",
#                                                "3-->4")),
#     trans      = factor(trans, levels = rev(levels(trans))),
#     study      = factor(study,      levels = c("octo",
#                                                "lasa",
#                                                "whitehall",
#                                                "h70",
#                                                "lbc",
#                                                "map"))
#     
#   )
# # dplyr::select(-value) 
# head(ds_odds)




# ----- groom-life-expectancies ---------------------
regex_estimator <- "^(-?\\d+.\\d+)\\s*\\((\\d+.\\d+),\\s*(-?\\d+.\\d+)\\)$"
regex_state <- "^\\s*State (\\d).*State (\\d)$"
ds_le <- ds0_le %>% tidyr::gather_('study',"value", c("octo","lasa","h70","lbc1921","map")) %>%
  dplyr::mutate(
    est      = as.numeric(gsub(regex_estimator,"\\1",value,perl=T)),
    low      = as.numeric(gsub(regex_estimator,"\\2",value,perl=T)),
    high     = as.numeric(gsub(regex_estimator,"\\3",value,perl=T))
    # outgoing = as.numeric(gsub(regex_state,"\\1",transition,perl=T)),
    # incoming = as.numeric(gsub(regex_state,"\\2",transition,perl=T)),
    # trans = paste0(outgoing,"--->",incoming)
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
# dplyr::select(-value)
x <- ds_le
head(ds_le)
levels(ds_le$group_tertile)

# ---- plotting-expectancies ------------------
plot_le_2 <- function(
  x
){
  x <- ds_le
  # yaxis = "condition"
  # yaxis = "group_sex"
  # yaxis = "sex_group"
  # group_ = "total"
  
  # d <- x
  d <- x %>%
  # dplyr::filter(edu=="high") %>% 
  # dplyr::filter(ses=="high")
  # dplyr::filter(group == group_) %>%
  dplyr::filter(age == 80)
  
  # study_ = levels_studies["octo"]
  # predictor_ = levels_predictors["age"]
  
  g <-  ggplot2::ggplot(d,aes_string(y     = "group_tertile" 
                                     ,x     = "est"
                                     # ,color = "age"
                                     # ,color = "edu"
                                     # ,fill  = "edu"
                                     # , color = "sex"
                                     # , fill = "sex"
                                     # , shape = "edu"
                                     # ,shape = "ses"
                                     # , shape = "sex"
  ))  
  g <- g + geom_errorbarh(aes_string(xmin = "low", xmax = "high"),
                          color    = "gray25", 
                          height   = .3, 
                          linetype = "solid", 
                          size     = 0.5) 
  g <- g + geom_point(size = 3) 
  # g <- g + facet_grid(edu~ses)
  # g <- g + facet_grid(condition~group)
  g <- g + facet_grid(sex~study)
  g <- g + main_theme
  # g
  # g <- g + scale_shape_manual(values = c("male"=24,"female"=25))
  g <- g + scale_shape_manual(values = c("low"=25,"medium"=21,"high"=24))
  # g <- g + scale_color_manual(values = c("male"="","FALSE"=NA))
  # g <- g + scale_fill_manual(values = c("TRUE"="black","FALSE"="white"))
  # g <- g + main_theme
  # g <- g + labs(shape = "", color="p < .05", fill = "p < .05")
  # g <- g + theme(axis.text.y = element_text(size=baseSize))
  g
  # if(label_=="(R)-Error"){
  #   g + guides(fill=FALSE, color=FALSE)
  # }else{
  #   g + guides(fill=FALSE, color=FALSE, shape=FALSE)
  #   
  # }
  
} 

ds_le %>% plot_le_1()



plot_le_1 <- function(
  x
){
  # x <- ds_le
  # yaxis = "condition"
  # yaxis = "group_sex"
  # yaxis = "sex_group"
  # group_ = "total"
  
  d <- x
  # d <- x %>%
    # dplyr::filter(edu=="high") %>% 
    # dplyr::filter(ses=="high")
    # dplyr::filter(group == group_) %>%
    # dplyr::filter(age == 80)

  # study_ = levels_studies["octo"]
  # predictor_ = levels_predictors["age"]

  g <-  ggplot2::ggplot(d,aes_string(y     = "condition" 
                                     ,x     = "est"
                                     # ,color = "age"
                                     # ,color = "edu"
                                     # ,fill  = "edu"
                                     , color = "sex"
                                     , fill = "sex"
                                     , shape = "edu"
                                     # ,shape = "ses"
                                     # , shape = "sex"
  ))  
  g <- g + geom_errorbarh(aes_string(xmin = "low", xmax = "high"),
                          color    = "gray25", 
                          height   = .3, 
                          linetype = "solid", 
                          size     = 0.5) 
  g <- g + geom_point(size = 3) 
  # g <- g + facet_grid(edu~ses)
  # g <- g + facet_grid(condition~group)
  g <- g + facet_grid(age_group~study)
  g <- g + main_theme
  # g
  # g <- g + scale_shape_manual(values = c("male"=24,"female"=25))
  g <- g + scale_shape_manual(values = c("low"=25,"medium"=21,"high"=24))
  # g <- g + scale_color_manual(values = c("male"="","FALSE"=NA))
  # g <- g + scale_fill_manual(values = c("TRUE"="black","FALSE"="white"))
  # g <- g + main_theme
  # g <- g + labs(shape = "", color="p < .05", fill = "p < .05")
  # g <- g + theme(axis.text.y = element_text(size=baseSize))
  g <- g + labs(shape = "Tertile", color = "Gender", x= "Estimate")
  g <- g + guides(fill=FALSE)
  g
  # if(label_=="(R)-Error"){
  #   g + guides(fill=FALSE, color=FALSE)
  # }else{
  #   g + guides(fill=FALSE, color=FALSE, shape=FALSE)
  #   
  # }
  
} 

ds_le %>% plot_le_1() %>% quick_save("table-3-display", 900, 600, 70)

quick_save <- function(g,name,width=550,height=400,dpi=100){
  ggplot2::ggsave(
    filename= paste0(name,".png"), 
    plot=g,
    device = png,
    path = "./reports/model-summaries/graphs/",
    width = width,
    height = height,
    # units = "cm",
    dpi = dpi,
    limitsize = FALSE
  )
}

# ---- plotting-odds ------------------
# trans - study - predictor
# study - trans - predictor
# predictor - study - trans
# ds_odds %>% plot_odds("trans", "octo", "age")
# ds_odds %>% plot_odds("study", "1-->4","age")
# ds_odds %>% plot_odds("predictor", "octo","1-->4")

# matrix_odds(ds_odds,"predictor",lvl_studies,"1-->2")
# matrix_odds(ds_odds,"predictor",lvl_studies,"1-->4")
# matrix_odds(ds_odds,"predictor",lvl_studies,"2-->1")
# matrix_odds(ds_odds,"predictor",lvl_studies,"2-->3")
# matrix_odds(ds_odds,"predictor",lvl_studies,"2-->4")
# matrix_odds(ds_odds,"predictor",lvl_studies,"3-->4")
# 
# matrix_odds(ds_odds,"trans",lvl_studies,"age")
# matrix_odds(ds_odds,"trans",lvl_studies,"sex")
# matrix_odds(ds_odds,"trans",lvl_studies,"edu_med_low")
# matrix_odds(ds_odds,"trans",lvl_studies,"edu_high_low")
# matrix_odds(ds_odds,"trans",lvl_studies,"ses")
# 
# matrix_odds(ds_odds,"study",lvl_transitions,"age")
# matrix_odds(ds_odds,"study",lvl_transitions,"sex")
# matrix_odds(ds_odds,"study",lvl_transitions,"edu_med_low")
# matrix_odds(ds_odds,"study",lvl_transitions,"edu_high_low")
# matrix_odds(ds_odds,"study",lvl_transitions,"ses")

folder <- "./reports/model-summaries/graphs/"
title <- "Hazard ratios and 95% confidence intervals"

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

# ---- plotting-expectancies ------------------------
