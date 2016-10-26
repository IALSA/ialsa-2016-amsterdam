



This report was automatically generated with the R package **knitr**
(version 1.14).


```r
# The purpose of this script is to create a data object (dto) which will hold all data and metadata.
# Run the lines below to stitch a basic html output. 
# knitr::stitch_rmd(
#   script="./manipulation/map/0-ellis-island-map.R",
#   output="./manipulation/map/stitched-output/0-ellis-island-map.md"
# )
# The above lines are executed only when the file is run in RStudio, !! NOT when an Rmd/Rnw file calls it !!

############################
##  Land on Ellis Island  ##
############################

rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 
```



```r
# Call `base::source()` on any repo file that defines functions needed below.  
# Ideally, no real operations are performed in these sourced scripts. 
source("./scripts/common-functions.R") # used in multiple reports
```

```r
# Attach packages so their functions don't need to be qualified when used
# See more : http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # Pipes
library(ggplot2) # Graphs
# Functions of these packages will need to be qualified when used
# See more: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("tidyr") #  data manipulation
requireNamespace("dplyr") # f() names conflict with other packages (esp. base, stats, and plyr).
requireNamespace("testit") # for asserting conditions meet expected patterns.
```

```r
# reach out to the curator for a dataset prepared for general consumption
data_path_input  <- "../MAP/data-unshared/derived/dto.rds"
# point to the local metadata to be used for this project (specific consumption)
# metadata_path_input <- "./data/shared/meta/map/meta-data-map.csv" 
metadata_path_input <- "./data/shared/meta/map/meta-data-map-2016-09-09.csv" 
```

```r
# load data objects
dto      <- readRDS(data_path_input)
# dto already contains meta data, but you should load a local one for greater control
metaData <- read.csv(metadata_path_input, stringsAsFactors=F, header=T)
```

```r
# inspect loaded data objects (using basic demographic variables )
ds <- as.data.frame(dto$unitData) # assing alias
length(unique(ds$id))  # sample size, number of respondents
```

```
## [1] 1853
```

```r
# t <- table(ds[,"fu_year"], ds[,"died"]); t[t==0]<-".";t 
# t <- table(ds[,"msex"], ds[,"race"], useNA = "always"); t[t==0]<-".";t 
# t <- table(ds[,"educ"], ds[,"race"]); t[t==0]<-".";t 
```

```r
# reconstruct the dto to be used in this project
dto <- list()
# the first element of data transfer object contains unit data
dto[["unitData"]] <- ds
# the second element of data transfer object contains meta data
dto[["metaData"]] <-  metaData # new, local meta-data!!
# verify and glimpse
# dto[["unitData"]] %>% dplyr::glimpse()
# dto[["metaData"]] %>% dplyr::glimpse()
```

```r
meta_data <- dto[["metaData"]] %>%
  dplyr::filter(include == TRUE) %>%
  # dplyr::select(name, name_new, type, label, construct) %>%
  dplyr::arrange(type, construct, name) %>% 
  dplyr::select(name, name_new, label, construct, longitudinal)
knitr::kable(meta_data)
```



|name                  |name_new         |label                                                     |construct              |longitudinal |
|:---------------------|:----------------|:---------------------------------------------------------|:----------------------|:------------|
|apoe_genotype         |apoe_genotype    |Apolipoprotein E genotype                                 |apoe                   |FALSE        |
|chf_cum               |chf_cum          |Medical Conditions - congestive heart failure -cumulative |cardio                 |TRUE         |
|dcfdx                 |dcfdx            |Clinical dx summary                                       |cognition              |TRUE         |
|r_stroke              |r_stroke         |Clinical stroke dx                                        |stroke                 |TRUE         |
|cogdx                 |cogdx            |Final consensus cognitive diagnosis                       |NA                     |FALSE        |
|cts_mmse30            |mmse             |MMSE - 2014                                               |dementia               |TRUE         |
|dementia              |dementia         |Dementia diagnosis                                        |dementia               |TRUE         |
|cogn_ep               |cogn_ep          |Calculated domain score-episodic memory                   |episodic memory        |TRUE         |
|cogn_global           |cogn_global      |Global cognitive score                                    |global cognition       |TRUE         |
|cogn_po               |cogn_po          |Calculated domain score - perceptual orientation          |perceptual orientation |TRUE         |
|cogn_ps               |cogn_ps          |Calculated domain score - perceptual speed                |perceptual speed       |TRUE         |
|cogn_se               |cogn_se          |Calculated domain score - semantic memory                 |semantic memory        |TRUE         |
|cogn_wo               |cogn_wo          |Calculated domain score - working memory                  |working memory         |TRUE         |
|chd_cogact_freq       |cogact_chd       |Cognitive actifity - child                                |NA                     |NA           |
|ma_adult_cogact_freq  |cogact_midage    |Codnitive activity - middle age                           |NA                     |NA           |
|past_cogact_freq      |cogact_past      |Cognitive actifity - past                                 |NA                     |NA           |
|age_at_visit          |age_at_visit     |Age at cycle - fractional                                 |age                    |TRUE         |
|age_bl                |age_bl           |Age at baseline                                           |age                    |FALSE        |
|age_death             |age_death        |Age at death                                              |age                    |FALSE        |
|educ                  |educ             |Years of education                                        |education              |FALSE        |
|race                  |race             |Participant's race                                        |race                   |FALSE        |
|msex                  |msex             |Gender                                                    |sex                    |FALSE        |
|q40inc                |income_40        |Income level at age 40                                    |NA                     |NA           |
|cogdate               |date_at_baseline |Date of the interview at baseline                         |                       |FALSE        |
|fu_year               |fu_year          |Follow-up year                                            |time                   |TRUE         |
|projid                |id               |Subject identifier                                        |NA                     |NA           |
|late_life_cogact_freq |cogact_old       |Codnitive activity - late life                            |                       |TRUE         |
|late_life_soc_act     |socact_old       |Social activity - late life                               |                       |TRUE         |
|soc_net               |soc_net          |Social network size                                       |NA                     |NA           |
|social_isolation      |social_isolation |Percieved social isolation                                |NA                     |NA           |
|iadlsum               |iadlsum          |Instrumental activities of daily liviing                  |physact                |TRUE         |
|phys5itemsum          |phys5itemsum     |Physical activity (summary of 5 items)                    |physact                |TRUE         |
|fev                   |fev              |forced expiratory volume                                  |physcap                |TRUE         |
|gait_speed            |gait_speed       |Gait Speed - MAP                                          |physcap                |TRUE         |
|gripavg               |gripavg          |Extremity strength                                        |physcap                |TRUE         |
|katzsum               |katzsum          |Katz measure of disability                                |physcap                |TRUE         |
|mep                   |mep              |maximal expiratory pressure                               |physcap                |TRUE         |
|mip                   |mip              |maximal inspiratory pressure                              |physcap                |TRUE         |
|pvc                   |pvc              |pulmonary vital capacity                                  |physcap                |TRUE         |
|rosbscl               |rosbscl          |Rosow-Breslau scale                                       |physcap                |TRUE         |
|rosbsum               |rosbsum          |Rosow-Breslau scale                                       |physcap                |TRUE         |
|bmi                   |bmi              |Body mass index                                           |physique               |TRUE         |
|htm                   |htm              |Height(meters)                                            |physique               |TRUE         |
|wtkg                  |wtkg             |Weight (kg)                                               |physique               |TRUE         |
|cesdsum               |cesdsum          |Measure of depressive symptoms (Modified CESD)            |depression             |TRUE         |
|negsocexchange        |negsocexchange   |Negative social exchange                                  |NA                     |NA           |
|rejection             |rejection        |Negative social exchange - rejection-MAP                  |NA                     |NA           |
|alcohol_g_bl          |alcohol_g_bl     |Grams of alcohol used per day at baseline                 |alcohol                |FALSE        |
|ldai_bl               |alco_life        |Lifetime daily alcohol intake -baseline                   |alcohol                |FALSE        |
|q3smo_bl              |q3smo_bl         |Smoking quantity-baseline                                 |smoking                |FALSE        |
|q4smo_bl              |q4smo_bl         |Smoking duration-baseline                                 |smoking                |FALSE        |
|smoking               |smoking          |Smoking                                                   |smoking                |FALSE        |
|ya_adult_cogact_freq  |cogact_young     |Cognitive actifity - young adult                          |NA                     |NA           |

```r
# # ----- apply-meta-data-1 -------------------------------------
# # rename variables
# d_rules <- dto[["metaData"]] %>%
#   dplyr::filter(name %in% names(ds)) %>% 
#   dplyr::select(name, name_new ) # leave only collumn, which values you wish to append
# names(ds) <- d_rules[,"name_new"]
# # transfer changes to dto
# ds <- ds %>% dplyr::filter(study == "MAP ")
# table(ds$study)
# dto[["unitData"]] <- ds 
```

```r
# Save as a compressed, binary R dataset.  
# It's no longer readable with a text editor, but it saves metadata (eg, factor information).
saveRDS(dto, file="./data/unshared/derived/dto.rds", compress="xz")
```

```r
# the production of the dto object is now complete
# we verify its structure and content:
dto <- readRDS("./data/unshared/derived/dto.rds")
names(dto)
```

```
## [1] "unitData" "metaData"
```

```r
# 1st element - unit(person) level data
# 2nd element - meta data, info about variables
knitr::kable(names_labels(dto$unitData))
```



|name                  |label                                                     |
|:---------------------|:---------------------------------------------------------|
|id                    |Subject identifier                                        |
|study                 |The particular RADC study (MAP/ROS/RMM)                   |
|scaled_to             |Scaled parameter                                          |
|agreeableness         |NEO agreeableness-ROS                                     |
|conscientiousness     |Conscientiousness-ROS/MAP                                 |
|neo_altruism          |NEO altruism scale-MAP                                    |
|neo_conscientiousness |NEO conscientiousness-MAP                                 |
|neo_trust             |NEO trust-MAP                                             |
|neuroticism_12        |Neuroticism - 12 item version-RMM                         |
|openness              |NEO openess-ROS                                           |
|anxiety_10items       |Anxiety-10 item version - ROS and MAP                     |
|neuroticism_6         |Neuroticism - 6 item version - RMM                        |
|cogdx                 |Final consensus cognitive diagnosis                       |
|age_bl                |Age at baseline                                           |
|age_death             |Age at death                                              |
|educ                  |Years of education                                        |
|msex                  |Gender                                                    |
|race                  |Participant's race                                        |
|spanish               |Spanish/Hispanic origin                                   |
|apoe_genotype         |Apolipoprotein E genotype                                 |
|alcohol_g_bl          |Grams of alcohol used per day at baseline                 |
|alco_life             |Lifetime daily alcohol intake -baseline                   |
|q3smo_bl              |Smoking quantity-baseline                                 |
|q4smo_bl              |Smoking duration-baseline                                 |
|smoking               |Smoking                                                   |
|cogact_chd            |Cognitive actifity - child                                |
|cogact_midage         |Codnitive activity - middle age                           |
|cogact_past           |Cognitive actifity - past                                 |
|cogact_young          |Cognitive actifity - young adult                          |
|lostcons_ever         |NA                                                        |
|ad_reagan             |Dicotomized NIA-Reagan score                              |
|braaksc               |Semiquantitative measure of neurofibrillary tangles       |
|ceradsc               |Semiquantitative measure of neuritic plaques              |
|niareagansc           |NA                                                        |
|income_40             |Income level at age 40                                    |
|fu_year               |Follow-up year                                            |
|scaled_to.y           |Scaled parameter                                          |
|cesdsum               |Measure of depressive symptoms (Modified CESD)            |
|r_depres              |Major depression dx-clinic rating                         |
|intrusion             |Negative social exchange-intrusion-MAP                    |
|neglifeevents         |Negative life events                                      |
|negsocexchange        |Negative social exchange                                  |
|nohelp                |Negative social exchange-help-MAP                         |
|panas                 |Panas score                                               |
|perceivedstress       |Perceived stress                                          |
|rejection             |Negative social exchange - rejection-MAP                  |
|unsympathetic         |Negative social exchange-unsymapathetic-MAP               |
|dcfdx                 |Clinical dx summary                                       |
|dementia              |Dementia diagnosis                                        |
|r_stroke              |Clinical stroke dx                                        |
|cogn_ep               |Calculated domain score-episodic memory                   |
|cogn_po               |Calculated domain score - perceptual orientation          |
|cogn_ps               |Calculated domain score - perceptual speed                |
|cogn_se               |Calculated domain score - semantic memory                 |
|cogn_wo               |Calculated domain score - working memory                  |
|cogn_global           |Global cognitive score                                    |
|cts_animals           |Category fluence - Animals                                |
|cts_bname             |Boston naming - 2014                                      |
|catfluency            |Category fluency - 2014                                   |
|cts_db                |Digits backwards - 2014                                   |
|cts_delay             |Logical memory IIa - 2014                                 |
|cts_df                |Digits forwards - 2014                                    |
|cts_doperf            |Digit ordering - 2014                                     |
|cts_ebdr              |East Boston story - delayed recall - 2014                 |
|cts_ebmt              |East Boston story - immediate - 2014                      |
|cts_fruits            |Category fluency - Fruits                                 |
|cts_idea              |Complex ideas - 2014                                      |
|cts_lopair            |Line orientation - 2014                                   |
|mmse                  |MMSE - 2014                                               |
|cts_nccrtd            |Number comparison - 2014                                  |
|cts_pmat              |Progressive Matrices - 2014                               |
|cts_pmsub             |NA                                                        |
|cts_read_nart         |Reading test-NART-2014                                    |
|cts_read_wrat         |Reading test - WRAT - 2014                                |
|cts_sdmt              |Symbol digit modalitities - 2014                          |
|cts_story             |Logical memory Ia - immediate - 2014                      |
|cts_stroop_cname      |NA                                                        |
|cts_stroop_wread      |NA                                                        |
|cts_wli               |Word list I- immediate- 2014                              |
|cts_wlii              |Word list II - delayed - 2014                             |
|cts_wliii             |Word list III - recognition - 2014                        |
|age_at_visit          |Age at cycle - fractional                                 |
|iadlsum               |Instrumental activities of daily liviing                  |
|katzsum               |Katz measure of disability                                |
|rosbscl               |Rosow-Breslau scale                                       |
|rosbsum               |Rosow-Breslau scale                                       |
|vision                |Vision acuity                                             |
|visionlog             |Visual acuity                                             |
|bun                   |Blood urea nitrogen                                       |
|ca                    |Calcium                                                   |
|cholesterol           |Cholesterol                                               |
|cloride               |Chloride                                                  |
|co2                   |Carbon Dioxide                                            |
|crn                   |Creatinine                                                |
|fasting               |Whether blood was collected on fasting participant        |
|glucose               |Glucose                                                   |
|hba1c                 |Hemoglobin A1c                                            |
|hdlchlstrl            |HDL cholesterol                                           |
|hdlratio              |HDL ratio                                                 |
|k                     |Potassium                                                 |
|ldlchlstrl            |LDL cholesterol                                           |
|na                    |Sodium                                                    |
|cogact_old            |Codnitive activity - late life                            |
|bmi                   |Body mass index                                           |
|htm                   |Height(meters)                                            |
|phys5itemsum          |Physical activity (summary of 5 items)                    |
|wtkg                  |Weight (kg)                                               |
|socact_old            |Social activity - late life                               |
|soc_net               |Social network size                                       |
|social_isolation      |Percieved social isolation                                |
|bp_sit_1              |Blood pressure measurement- sitting - trial 1             |
|bp_sit_2              |Blood pressure measurement- sitting - trial 2             |
|bp_meds               |Hx of Meds for HTN                                        |
|bp_stand_3            |Blood pressure measurement- standing                      |
|hypertension_cum      |Medical conditions - hypertension - cumulative            |
|cancer_cum            |Medical Conditions - cancer - cumulative                  |
|dm_cum                |Medical history - diabetes - cumulative                   |
|headinjrloc_cum       |NA                                                        |
|thyroid_cum           |Medical Conditions - thyroid disease - cumulative         |
|chf_cum               |Medical Conditions - congestive heart failure -cumulative |
|claudication_cum      |Medical conditions - claudication -cumulative             |
|heart_cum             |Medical Conditions - heart - cumulative                   |
|stroke_cum            |Clinical Diagnoses - Stroke - cumulative                  |
|vasc_3dis_sum         |Vascular disease burden (3 items w/o chf) ROS/MAP/MARS  |
|vasc_4dis_sum         |Vascular disease burden (4 items) - MAP/MARS only       |
|vasc_risks_sum        |Vascular disease risk factors                             |
|gait_speed            |Gait Speed - MAP                                          |
|gripavg               |Extremity strength                                        |
|total_smell_test      |NA                                                        |
|fev                   |forced expiratory volume                                  |
|mep                   |maximal expiratory pressure                               |
|mip                   |maximal inspiratory pressure                              |
|pvc                   |pulmonary vital capacity                                  |
|firstobs              |NA                                                        |
|month                 |Date of the interview at baseline                         |
|year                  |Date of the interview at baseline                         |
|date_at_bl            |NA                                                        |
|age_at_bl             |NA                                                        |
|birth_date            |NA                                                        |
|birth_year            |NA                                                        |
|date_at_visit         |Age at cycle - fractional                                 |
|died                  |NA                                                        |

The R session information (including the OS info, R version and all
packages used):


```r
sessionInfo()
```

```
## R version 3.3.1 (2016-06-21)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows >= 8 x64 (build 9200)
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] ggplot2_2.1.0 nnet_7.3-12   msm_1.6.4     magrittr_1.5 
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.7        highr_0.6          formatR_1.4       
##  [4] nloptr_1.0.4       RColorBrewer_1.1-2 plyr_1.8.4        
##  [7] tools_3.3.1        extrafont_0.17     digest_0.6.10     
## [10] lme4_1.1-12        evaluate_0.10      nlme_3.1-128      
## [13] tibble_1.2         gtable_0.2.0       lattice_0.20-34   
## [16] mgcv_1.8-15        Matrix_1.2-7.1     DBI_0.5-1         
## [19] parallel_3.3.1     SparseM_1.72       mvtnorm_1.0-5     
## [22] expm_0.999-0       Rttf2pt1_1.3.4     dplyr_0.5.0       
## [25] stringr_1.1.0      knitr_1.14         MatrixModels_0.4-1
## [28] grid_3.3.1         R6_2.2.0           survival_2.39-5   
## [31] minqa_1.2.4        tidyr_0.6.0        reshape2_1.4.1    
## [34] extrafontdb_1.0    car_2.1-3          scales_0.4.0      
## [37] splines_3.3.1      MASS_7.3-45        rsconnect_0.5     
## [40] assertthat_0.1     dichromat_2.0-0    pbkrtest_0.4-6    
## [43] testit_0.5         colorspace_1.2-7   quantreg_5.29     
## [46] labeling_0.3       stringi_1.1.2      lazyeval_0.2.0    
## [49] munsell_0.4.3      markdown_0.7.7
```

```r
Sys.time()
```

```
## [1] "2016-10-24 14:56:58 EDT"
```

