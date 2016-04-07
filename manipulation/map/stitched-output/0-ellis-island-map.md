



This report was automatically generated with the R package **knitr**
(version 1.12.3).


```r
# the purpose of this script is to create a data object (dto) which will hold all data and metadata from each candidate study of the exercise
# run the line below to stitch a basic html output. For elaborated report, run the corresponding .Rmd file
# knitr::stitch_rmd(script="./manipulation/map/0-ellis-island-map.R", output="./manipulation/map/stitched-output/0-ellis-island-map.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 
```



```r
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 
```

```r
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) #Pipes
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2")
requireNamespace("tidyr")
requireNamespace("dplyr") #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit") #For asserting conditions meet expected patterns.
```

```r
data_path_input  <- "../MAP/data-unshared/derived/ds0.rds"
metadata_path_input <- "../MAP/data-phi-free/raw/nl_augmented.csv" # input file with your manual classification
```

```r
ds0 <- readRDS(data_path_input)
nl <- read.csv(metadata_path_input, stringsAsFactors = F, header = T)
nl$X <- NULL # remove automatic variable
dplyr::tbl_df(nl)
```

```
## Source: local data frame [113 x 3]
## 
##                     name                     label        type
##                    (chr)                     (chr)       (chr)
## 1                     id                        NA      design
## 2                  study                        NA      design
## 3            scaled_to.x                        NA      design
## 4          agreeableness     NEO agreeableness-ROS personality
## 5      conscientiousness Conscientiousness-ROS/MAP personality
## 6           extraversion  NEO extraversion-ROS/MAP personality
## 7           neo_altruism    NEO altruism scale-MAP personality
## 8  neo_conscientiousness NEO conscientiousness-MAP personality
## 9              neo_trust             NEO trust-MAP personality
## 10              openness           NEO openess-ROS personality
## ..                   ...                       ...         ...
```

```r
#
# There will be a total of (2) elements in (dto)
dto <- list() # creates empty list object to populate with script to follow 
#
```

```r
dto <- list() # creates empty list object to populate with script to follow 
# create a data object that will be used for subsequent analyses
# select variables you will need for modeling
ds <- ds0 %>%
  # dplyr::rename_("fu_point" = "fu_year") %>% 
  dplyr::select_(
# 
# selected_items <- c(
  "id", # personal identifier
  "age_bl", # Age at baseline
  "msex", # Gender
  "race", # Participant's race
  "educ", # Years of education

  # time-invariant above
  "fu_year", # Follow-up year ------------------------------------------------
  # time-variant below
  
  "age_death", # Age at death
  "died", # Indicator of death  
  "age_at_visit", #Age at cycle - fractional
  #
  "iadlsum", # Instrumental activities of daily liviing
  "cts_mmse30", # MMSE - 2014
  "cts_catflu", # Category fluency - 2014
  "dementia", # Dementia diagnosis
  "bmi", # Body mass index
  "phys5itemsum", # Summary of self reported physical activity measure (in hours) ROS/MAP
  "q3smo_bl",  # Smoking quantity-baseline (VERIFY)
  "q4smo_bl", # Smoking duration-baseline (VERIFY)
  "smoke_bl", # Smoking at baseline (VERIFY)
  "smoking", # Smoking (VERIFY)
  "ldai_bl", # Grams of alcohol per day
  "dm_cum", # Medical history - diabetes - cumulative
  "hypertension_cum", # Medical conditions - hypertension - cumulative
  "stroke_cum", # Clinical Diagnoses - Stroke - cumulative
  "r_stroke", # 	Clinical stroke dx
  "katzsum", # Katz measure of disability
  "rosbscl" # 	Rosow-Breslau scale
) 
ds %>% dplyr::glimpse()
```

```
## Observations: 9,708
## Variables: 26
## $ id               (int) 9121, 9121, 9121, 9121, 9121, 33027, 33027, 2...
## $ age_bl           (dbl) 79.96988, 79.96988, 79.96988, 79.96988, 79.96...
## $ msex             (int) 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, ...
## $ race             (int) 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
## $ educ             (int) 12, 12, 12, 12, 12, 14, 14, 8, 8, 8, 8, 8, 8,...
## $ fu_year          (int) 0, 1, 2, 3, 4, 0, 1, 0, 2, 3, 4, 5, 6, 0, 1, ...
## $ age_death        (dbl) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ died             (int) 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
## $ age_at_visit     (dbl) 79.96988, 81.08145, 81.61259, 82.59548, 83.62...
## $ iadlsum          (int) 0, 0, 0, 0, 0, 5, 3, 0, 0, 0, 0, 0, 0, 1, 0, ...
## $ cts_mmse30       (dbl) 29, 29, 30, 30, 29, 29, NA, 27, 25, 28, 28, 2...
## $ cts_catflu       (int) 40, 43, 48, 49, 45, 20, NA, 31, 27, 26, 25, 3...
## $ dementia         (int) 0, 0, 0, 0, NA, 0, NA, 0, 0, 0, 0, 0, 0, 0, 0...
## $ bmi              (dbl) 26.83177, 27.61514, 26.97526, 26.40132, 35.14...
## $ phys5itemsum     (dbl) 1.7500000, 4.0416667, 0.6250000, 0.4583333, 2...
## $ q3smo_bl         (int) 20, 20, 20, 20, 20, NA, NA, NA, NA, NA, NA, N...
## $ q4smo_bl         (int) 31, 31, 31, 31, 31, NA, NA, NA, NA, NA, NA, N...
## $ smoke_bl         (int) 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
## $ smoking          (int) 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
## $ ldai_bl          (dbl) 0.2, 0.2, 0.2, 0.2, 0.2, 0.0, 0.0, 0.0, 0.0, ...
## $ dm_cum           (int) 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, ...
## $ hypertension_cum (int) 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, ...
## $ stroke_cum       (int) NA, NA, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ r_stroke         (int) NA, NA, 4, 4, NA, 4, NA, 4, NA, 4, NA, NA, 4,...
## $ katzsum          (int) 6, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, ...
## $ rosbscl          (int) 1, 3, 3, 3, 3, 0, 0, 3, 3, 3, 3, 2, 3, 2, 3, ...
```

```r
dto[["unitData"]] <- ds
```

```r
# basic demographic variables
length(unique(ds$id)) # there are this many of them
```

```
## [1] 1696
```

```r
table(ds[,"msex"], ds[,"race"], useNA = "always")
```

```
##       
##           1    2    3    6 <NA>
##   0    6796  443   13   34    0
##   1    2310   94    8   10    0
##   <NA>    0    0    0    0    0
```

```r
t <- table(ds[,"educ"], ds[,"race"]); t[t==0]<-".";t
```

```
##     
##      1    2   3  6 
##   0  4    .   .  . 
##   2  8    .   .  . 
##   3  7    .   2  . 
##   4  16   1   .  . 
##   5  17   4   .  . 
##   6  42   3   .  . 
##   7  26   .   .  . 
##   8  141  25  .  . 
##   9  63   8   .  . 
##   10 134  22  .  5 
##   11 186  23  .  . 
##   12 2103 126 .  10
##   13 727  79  .  6 
##   14 1042 92  .  . 
##   15 473  36  .  13
##   16 1949 66  14 2 
##   17 459  .   .  . 
##   18 847  41  5  8 
##   19 239  7   .  . 
##   20 265  4   .  . 
##   21 194  .   .  . 
##   22 58   .   .  . 
##   23 34   .   .  . 
##   24 26   .   .  . 
##   25 10   .   .  . 
##   28 21   .   .  .
```

```r
# age variables
t <- table(ds[,"fu_year"], ds[,"died"]); t[t==0]<-".";t
```

```
##     
##      0    1  
##   0  1014 681
##   1  873  594
##   2  739  527
##   3  632  446
##   4  539  369
##   5  427  313
##   6  407  259
##   7  360  198
##   8  327  139
##   9  249  93 
##   10 176  61 
##   11 94   39 
##   12 32   24 
##   13 27   17 
##   14 22   6  
##   15 19   2  
##   16 2    .
```

```r
# histogram_continuous(ds, variable_name = "age_death", bin_width = 1)
# histogram_continuous(ds, variable_name = "age_bl", bin_width = 1)
# histogram_continuous(ds, variable_name = "age_at_visit", bin_width = 1)
```


```r
# prepare metadata to be added to the dto
# we begin by extracting the names and (hopefuly their) labels of variables from each dataset
# and combine them in a single rectanguar object, long/stacked with respect to study names
save_csv <- names_labels(ds)
write.csv(save_csv,"./data/meta/map/names-labels-live.csv",row.names = T)
```

```r
# after the final version of the data files used in the excerside have been obtained
# we made a dead copy of `./data/shared/derived/meta-raw-live.csv` and named it `./data/shared/meta-data-map.csv`
# decisions on variables' renaming and classification is encoded in this map
# reproduce ellis-island script every time you make changes to `meta-data-map.csv`
dto[["metaData"]] <- read.csv("./data/meta/map/meta-data-map.csv")
dto[["metaData"]]["X"] <- NULL # remove native counter variable, not needed
```

```r
meta_data <- dto[["metaData"]] %>%
  dplyr::filter(type %in% c('substance')) %>%
  # dplyr::select(name, name_new, type, label, construct) %>%
  dplyr::arrange(name)
knitr::kable(meta_data)
```



|name      |label                                   |type      |name_new  |construct |self_reported |longitudinal |unit             |include |
|:---------|:---------------------------------------|:---------|:---------|:---------|:-------------|:------------|:----------------|:-------|
|alcohol_g |Grams of alcohol per day                |substance |alcohol_g |alcohol   |TRUE          |FALSE        |grams            |TRUE    |
|ldai_bl   |Lifetime daily alcohol intake -baseline |substance |alco_life |alcohol   |TRUE          |FALSE        |drinks / day     |TRUE    |
|q3smo_bl  |Smoking quantity-baseline               |substance |q3smo_bl  |smoking   |TRUE          |FALSE        |cigarettes / day |TRUE    |
|q4smo_bl  |Smoking duration-baseline               |substance |q4smo_bl  |smoking   |TRUE          |FALSE        |years            |TRUE    |
|smoke_bl  |Smoking at baseline                     |substance |smoke_bl  |smoking   |TRUE          |FALSE        |category         |TRUE    |
|smoking   |Smoking                                 |substance |smoking   |smoking   |TRUE          |FALSE        |category         |TRUE    |

```r
# rename variables

d_rules <- dto[["metaData"]] %>%
  dplyr::filter(name %in% names(ds)) %>% 
  dplyr::select(name, name_new ) # leave only collumn, which values you wish to append
names(ds) <- d_rules[,"name_new"]
```

```r
# Save as a compress, binary R dataset.  It's no longer readable with a text editor, but it saves metadata (eg, factor information).
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
dplyr::tbl_df(dto[["unitData"]])
```

```
## Source: local data frame [9,708 x 26]
## 
##        id   age_bl  msex  race  educ fu_year age_death  died age_at_visit
##     (int)    (dbl) (int) (int) (int)   (int)     (dbl) (int)        (dbl)
## 1    9121 79.96988     0     1    12       0        NA     0     79.96988
## 2    9121 79.96988     0     1    12       1        NA     0     81.08145
## 3    9121 79.96988     0     1    12       2        NA     0     81.61259
## 4    9121 79.96988     0     1    12       3        NA     0     82.59548
## 5    9121 79.96988     0     1    12       4        NA     0     83.62218
## 6   33027 81.00753     0     1    14       0        NA     0     81.00753
## 7   33027 81.00753     0     1    14       1        NA     0     82.13552
## 8  204228 65.21561     1     1     8       0        NA     0     65.21561
## 9  204228 65.21561     1     1     8       2        NA     0     68.30116
## 10 204228 65.21561     1     1     8       3        NA     0     69.35524
## ..    ...      ...   ...   ...   ...     ...       ...   ...          ...
## Variables not shown: iadlsum (int), cts_mmse30 (dbl), cts_catflu (int),
##   dementia (int), bmi (dbl), phys5itemsum (dbl), q3smo_bl (int), q4smo_bl
##   (int), smoke_bl (int), smoking (int), ldai_bl (dbl), dm_cum (int),
##   hypertension_cum (int), stroke_cum (int), r_stroke (int), katzsum (int),
##   rosbscl (int)
```

```r
# 2nd element - meta data, info about variables
dto[["metaData"]]
```

```
##                      name
## 1                      id
## 2                   study
## 3             scaled_to.x
## 4           agreeableness
## 5       conscientiousness
## 6            extraversion
## 7            neo_altruism
## 8   neo_conscientiousness
## 9               neo_trust
## 10               openness
## 11        anxiety_10items
## 12         neuroticism_12
## 13          neuroticism_6
## 14                 age_bl
## 15              age_death
## 16                   died
## 17                   educ
## 18                   msex
## 19                   race
## 20                spanish
## 21          apoe_genotype
## 22                ldai_bl
## 23               q3smo_bl
## 24               q4smo_bl
## 25               smoke_bl
## 26                smoking
## 27                fu_year
## 28            scaled_to.y
## 29                cesdsum
## 30               r_depres
## 31              intrusion
## 32          neglifeevents
## 33         negsocexchange
## 34                 nohelp
## 35                  panas
## 36        perceivedstress
## 37              rejection
## 38          unsympathetic
## 39                  dcfdx
## 40               dementia
## 41               r_stroke
## 42                cogn_ep
## 43            cogn_global
## 44                cogn_po
## 45                cogn_ps
## 46                cogn_se
## 47                cogn_wo
## 48              cts_bname
## 49             cts_catflu
## 50                 cts_db
## 51              cts_delay
## 52                 cts_df
## 53             cts_doperf
## 54               cts_ebdr
## 55               cts_ebmt
## 56               cts_idea
## 57             cts_lopair
## 58             cts_mmse30
## 59             cts_nccrtd
## 60               cts_pmat
## 61          cts_read_nart
## 62          cts_read_wrat
## 63               cts_sdmt
## 64              cts_story
## 65                cts_wli
## 66               cts_wlii
## 67              cts_wliii
## 68           age_at_visit
## 69                iadlsum
## 70                katzsum
## 71                rosbscl
## 72                rosbsum
## 73                 vision
## 74              visionlog
## 75                    fev
## 76                    mep
## 77                    mip
## 78                    pvc
## 79                    bun
## 80                     ca
## 81                chlstrl
## 82                     cl
## 83                    co2
## 84                    crn
## 85                fasting
## 86                glucose
## 87                  hba1c
## 88             hdlchlstrl
## 89               hdlratio
## 90                      k
## 91             ldlchlstrl
## 92                     na
## 93              alcohol_g
## 94                    bmi
## 95                    htm
## 96           phys5itemsum
## 97                   wtkg
## 98                   bp11
## 99                    bp2
## 100                   bp3
## 101                  bp31
## 102      hypertension_cum
## 103                dm_cum
## 104           thyroid_cum
## 105               chf_cum
## 106      claudication_cum
## 107             heart_cum
## 108            stroke_cum
## 109         vasc_3dis_sum
## 110         vasc_4dis_sum
## 111        vasc_risks_sum
## 112            gait_speed
## 113               gripavg
##                                                                      label
## 1                                                                     <NA>
## 2                                                                     <NA>
## 3                                                                     <NA>
## 4                                                    NEO agreeableness-ROS
## 5                                                Conscientiousness-ROS/MAP
## 6                                                 NEO extraversion-ROS/MAP
## 7                                                   NEO altruism scale-MAP
## 8                                                NEO conscientiousness-MAP
## 9                                                            NEO trust-MAP
## 10                                                         NEO openess-ROS
## 11                                   Anxiety-10 item version - ROS and MAP
## 12                                       Neuroticism - 12 item version-RMM
## 13                                      Neuroticism - 6 item version - RMM
## 14                                                         Age at baseline
## 15                                                            Age at death
## 16                                                      Indicator of death
## 17                                                      Years of education
## 18                                                                  Gender
## 19                                                      Participant's race
## 20                                                 Spanish/Hispanic origin
## 21                                                           ApoE genotype
## 22                                 Lifetime daily alcohol intake -baseline
## 23                                               Smoking quantity-baseline
## 24                                               Smoking duration-baseline
## 25                                                     Smoking at baseline
## 26                                                                 Smoking
## 27                                                          Follow-up year
## 28                                              No label found in codebook
## 29                                     CESD-Measure of depressive symptoms
## 30                                       Major depression dx-clinic rating
## 31                                  Negative social exchange-intrusion-MAP
## 32                                                    Negative life events
## 33                                                Negative social exchange
## 34                                       Negative social exchange-help-MAP
## 35                                                             Panas score
## 36                                                        Perceived stress
## 37                                Negative social exchange - rejection-MAP
## 38                             Negative social exchange-unsymapathetic-MAP
## 39                                                     Clinical dx summary
## 40                                                      Dementia diagnosis
## 41                                                      Clinical stroke dx
## 42                                 Calculated domain score-episodic memory
## 43                                                  Global cognitive score
## 44                        Calculated domain score - perceptual orientation
## 45                              Calculated domain score - perceptual speed
## 46                               Calculated domain score - semantic memory
## 47                                Calculated domain score - working memory
## 48                                                    Boston naming - 2014
## 49                                                 Category fluency - 2014
## 50                                                 Digits backwards - 2014
## 51                                               Logical memory IIa - 2014
## 52                                                  Digits forwards - 2014
## 53                                                   Digit ordering - 2014
## 54                               East Boston story - delayed recall - 2014
## 55                                    East Boston story - immediate - 2014
## 56                                                    Complex ideas - 2014
## 57                                                 Line orientation - 2014
## 58                                                             MMSE - 2014
## 59                                                Number comparison - 2014
## 60                                             Progressive Matrices - 2014
## 61                                                  Reading test-NART-2014
## 62                                              Reading test - WRAT - 2014
## 63                                        Symbol digit modalitities - 2014
## 64                                    Logical memory Ia - immediate - 2014
## 65                                            Word list I- immediate- 2014
## 66                                           Word list II - delayed - 2014
## 67                                      Word list III - recognition - 2014
## 68                                               Age at cycle - fractional
## 69                                Instrumental activities of daily liviing
## 70                                              Katz measure of disability
## 71                                                     Rosow-Breslau scale
## 72                                                     Rosow-Breslau scale
## 73                                                           Vision acuity
## 74                                                           Visual acuity
## 75                                                forced expiratory volume
## 76                                             maximal expiratory pressure
## 77                                            maximal inspiratory pressure
## 78                                                pulmonary vital capacity
## 79                                                     Blood urea nitrogen
## 80                                                                 Calcium
## 81                                                             Cholesterol
## 82                                                                Chloride
## 83                                                          Carbon Dioxide
## 84                                                              Creatinine
## 85                      Whether blood was collected on fasting participant
## 86                                                                 Glucose
## 87                                                          Hemoglobin A1c
## 88                                                         HDL cholesterol
## 89                                                               HDL ratio
## 90                                                               Potassium
## 91                                                         LDL cholesterol
## 92                                                                  Sodium
## 93                                                Grams of alcohol per day
## 94                                                         Body mass index
## 95                                                          Height(meters)
## 96  Summary of self reported physical activity\nmeasure (in hours) ROS/MAP
## 97                                                             Weight (kg)
## 98                           Blood pressure measurement- sitting - trial 1
## 99                           Blood pressure measurement- sitting - trial 2
## 100                                                     Hx of Meds for HTN
## 101                                   Blood pressure measurement- standing
## 102                         Medical conditions - hypertension - cumulative
## 103                                Medical history - diabetes - cumulative
## 104                      Medical Conditions - thyroid disease - cumulative
## 105            Medical Conditions - congestive heart failure -\ncumulative
## 106                          Medical conditions - claudication -cumulative
## 107                                Medical Conditions - heart - cumulative
## 108                               Clinical Diagnoses - Stroke - cumulative
## 109                Vascular disease burden (3 items w/o chf)\nROS/MAP/MARS
## 110                     Vascular disease burden (4 items) - MAP/MARS\nonly
## 111                                          Vascular disease risk factors
## 112                                                       Gait Speed - MAP
## 113                                                     Extremity strength
##              type              name_new              construct
## 1          design                    id                     id
## 2          design                 study                       
## 3          design           scaled_to.x                       
## 4     personality         agreeableness                       
## 5     personality     conscientiousness                       
## 6     personality          extraversion                       
## 7     personality          neo_altruism                       
## 8     personality neo_conscientiousness                       
## 9     personality             neo_trust                       
## 10    personality              openness                       
## 11    personality       anxiety_10items                       
## 12    personality        neuroticism_12                       
## 13    personality         neuroticism_6                       
## 14    demographic                age_bl                    age
## 15    demographic             age_death                    age
## 16    demographic                  died                    age
## 17    demographic                  educ              education
## 18    demographic                  msex                    sex
## 19    demographic                  race                   race
## 20    demographic               spanish                   race
## 21       clinical         apoe_genotype                   apoe
## 22      substance             alco_life                alcohol
## 23      substance              q3smo_bl                smoking
## 24      substance              q4smo_bl                smoking
## 25      substance              smoke_bl                smoking
## 26      substance               smoking                smoking
## 27         design               fu_year                   time
## 28         design           scaled_to.y                       
## 29  psychological               cesdsum                       
## 30  psychological              r_depres                       
## 31  psychological             intrusion                       
## 32  psychological         neglifeevents                       
## 33  psychological        negsocexchange                       
## 34  psychological                nohelp                       
## 35  psychological                 panas                       
## 36  psychological       perceivedstress                       
## 37  psychological             rejection                       
## 38  psychological         unsympathetic                       
## 39       clinical                 dcfdx              cognition
## 40      cognitive              dementia               dementia
## 41       clinical              r_stroke                 stroke
## 42      cognitive               cogn_ep        episodic memory
## 43      cognitive           cogn_global                 global
## 44      cognitive               cogn_po perceptual orientation
## 45      cognitive               cogn_ps       perceptual speed
## 46      cognitive               cogn_se        semantic memory
## 47      cognitive               cogn_wo         working memory
## 48      cognitive             cts_bname        semantic memory
## 49      cognitive            catfluency        semantic memory
## 50      cognitive                cts_db         working memory
## 51      cognitive             cts_delay        episodic memory
## 52      cognitive                cts_df         working memory
## 53      cognitive            cts_doperf         working memory
## 54      cognitive              cts_ebdr        episodic memory
## 55      cognitive              cts_ebmt        episodic memory
## 56      cognitive              cts_idea   verbal comprehension
## 57      cognitive            cts_lopair perceptual orientation
## 58      cognitive                  mmse               dementia
## 59      cognitive            cts_nccrtd       perceptual speed
## 60      cognitive              cts_pmat perceptual orientation
## 61      cognitive         cts_read_nart        semantic memory
## 62      cognitive         cts_read_wrat        semantic memory
## 63      cognitive              cts_sdmt       perceptual speed
## 64      cognitive             cts_story        episodic memory
## 65      cognitive               cts_wli        episodic memory
## 66      cognitive              cts_wlii        episodic memory
## 67      cognitive             cts_wliii        episodic memory
## 68    demographic          age_at_visit                       
## 69       physical               iadlsum                physact
## 70       physical               katzsum                physcap
## 71       physical               rosbscl                physcap
## 72       physical               rosbsum                physcap
## 73       physical                vision                physcap
## 74       physical             visionlog                physcap
## 75       physical                   fev                physcap
## 76       physical                   mep                physcap
## 77       physical                   mip                physcap
## 78       physical                   pvc                physcap
## 79       clinical                   bun                       
## 80       clinical                    ca                       
## 81       clinical               chlstrl                       
## 82       clinical                    cl                       
## 83       clinical                   co2                       
## 84       clinical                   crn                       
## 85       clinical               fasting                       
## 86       clinical               glucose                       
## 87       clinical                 hba1c                       
## 88       clinical            hdlchlstrl                       
## 89       clinical              hdlratio                       
## 90       clinical                     k                       
## 91       clinical            ldlchlstrl                       
## 92       clinical                    na                       
## 93      substance             alcohol_g                alcohol
## 94       physical                   bmi               physique
## 95       physical                   htm               physique
## 96       physical          phys5itemsum                physact
## 97       physical                  wtkg               physique
## 98       clinical                  bp11           hypertension
## 99       clinical                   bp2           hypertension
## 100      clinical                   bp3           hypertension
## 101      clinical                  bp31           hypertension
## 102      clinical      hypertension_cum           hypertension
## 103      clinical                dm_cum               diabetes
## 104      clinical           thyroid_cum                       
## 105      clinical               chf_cum                 cardio
## 106      clinical      claudication_cum                       
## 107      clinical             heart_cum                       
## 108      clinical            stroke_cum                 stroke
## 109      clinical         vasc_3dis_sum                       
## 110      clinical         vasc_4dis_sum                       
## 111      clinical        vasc_risks_sum                       
## 112      physical            gait_speed                physcap
## 113      physical               gripavg                physcap
##     self_reported longitudinal             unit include
## 1           FALSE        FALSE           person    TRUE
## 2              NA           NA                       NA
## 3              NA           NA                       NA
## 4              NA           NA                       NA
## 5              NA           NA                       NA
## 6              NA           NA                       NA
## 7              NA           NA                       NA
## 8              NA           NA                       NA
## 9              NA           NA                       NA
## 10             NA           NA                       NA
## 11             NA           NA                       NA
## 12             NA           NA                       NA
## 13             NA           NA                       NA
## 14          FALSE        FALSE             year    TRUE
## 15          FALSE        FALSE             year    TRUE
## 16          FALSE        FALSE         category    TRUE
## 17           TRUE        FALSE            years    TRUE
## 18          FALSE        FALSE         category    TRUE
## 19           TRUE        FALSE         category    TRUE
## 20           TRUE        FALSE         category    TRUE
## 21          FALSE        FALSE            scale    TRUE
## 22           TRUE        FALSE     drinks / day    TRUE
## 23           TRUE        FALSE cigarettes / day    TRUE
## 24           TRUE        FALSE            years    TRUE
## 25           TRUE        FALSE         category    TRUE
## 26           TRUE        FALSE         category    TRUE
## 27          FALSE         TRUE       time point    TRUE
## 28             NA           NA                       NA
## 29             NA           NA                       NA
## 30             NA           NA                       NA
## 31             NA           NA                       NA
## 32             NA           NA                       NA
## 33             NA           NA                       NA
## 34             NA           NA                       NA
## 35             NA           NA                       NA
## 36             NA           NA                       NA
## 37             NA           NA                       NA
## 38             NA           NA                       NA
## 39          FALSE         TRUE         category    TRUE
## 40          FALSE         TRUE             0, 1    TRUE
## 41          FALSE         TRUE         category    TRUE
## 42          FALSE         TRUE        composite    TRUE
## 43          FALSE         TRUE        composite    TRUE
## 44          FALSE         TRUE        composite    TRUE
## 45          FALSE         TRUE        composite    TRUE
## 46          FALSE         TRUE        composite    TRUE
## 47          FALSE         TRUE        composite    TRUE
## 48          FALSE         TRUE          0 to 15      NA
## 49          FALSE         TRUE          0 to 75      NA
## 50          FALSE         TRUE          0 to 12      NA
## 51          FALSE         TRUE          0 to 25      NA
## 52          FALSE         TRUE          0 to 12      NA
## 53          FALSE         TRUE          0 to 14      NA
## 54          FALSE         TRUE          0 to 12      NA
## 55          FALSE         TRUE          0 to 12      NA
## 56          FALSE         TRUE           0 to 8      NA
## 57          FALSE         TRUE          0 to 15      NA
## 58           TRUE         TRUE          0 to 30    TRUE
## 59          FALSE         TRUE          0 to 48      NA
## 60          FALSE         TRUE          0 to 16      NA
## 61          FALSE         TRUE          0 to 10      NA
## 62          FALSE         TRUE          0 to 15      NA
## 63          FALSE         TRUE         0 to 110      NA
## 64          FALSE         TRUE          0 to 25      NA
## 65          FALSE         TRUE          0 to 30      NA
## 66          FALSE         TRUE          0 to 10      NA
## 67          FALSE         TRUE          o to 10      NA
## 68             NA           NA                       NA
## 69           TRUE         TRUE            scale    TRUE
## 70           TRUE         TRUE            scale    TRUE
## 71           TRUE         TRUE            scale    TRUE
## 72           TRUE         TRUE            scale    TRUE
## 73          FALSE         TRUE            scale    TRUE
## 74          FALSE         TRUE            scale    TRUE
## 75          FALSE         TRUE           liters    TRUE
## 76          FALSE         TRUE           cm H20    TRUE
## 77          FALSE         TRUE           cm H20    TRUE
## 78          FALSE         TRUE           liters    TRUE
## 79             NA           NA                       NA
## 80             NA           NA                       NA
## 81             NA           NA                       NA
## 82             NA           NA                       NA
## 83             NA           NA                       NA
## 84             NA           NA                       NA
## 85             NA           NA                       NA
## 86             NA           NA                       NA
## 87             NA           NA                       NA
## 88             NA           NA                       NA
## 89             NA           NA                       NA
## 90             NA           NA                       NA
## 91             NA           NA                       NA
## 92             NA           NA                       NA
## 93           TRUE        FALSE            grams    TRUE
## 94          FALSE         TRUE           kg/msq    TRUE
## 95          FALSE         TRUE           meters    TRUE
## 96           TRUE           NA                       NA
## 97          FALSE         TRUE            kilos    TRUE
## 98          FALSE         TRUE                       NA
## 99          FALSE         TRUE                       NA
## 100          TRUE         TRUE                       NA
## 101         FALSE         TRUE                       NA
## 102          TRUE         TRUE                       NA
## 103          TRUE         TRUE                       NA
## 104            NA           NA                       NA
## 105          TRUE         TRUE         category    TRUE
## 106            NA           NA                       NA
## 107            NA           NA                       NA
## 108         FALSE         TRUE         category    TRUE
## 109            NA           NA                       NA
## 110            NA           NA                       NA
## 111            NA           NA                       NA
## 112         FALSE         TRUE          min/sec    TRUE
## 113         FALSE         TRUE              lbs    TRUE
```

The R session information (including the OS info, R version and all
packages used):


```r
sessionInfo()
```

```
## R version 3.2.4 Revised (2016-03-16 r70336)
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
## [1] ggplot2_2.1.0 magrittr_1.5 
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.4        Rttf2pt1_1.3.3     knitr_1.12.3      
##  [4] munsell_0.4.3      testit_0.5         colorspace_1.2-6  
##  [7] R6_2.1.2           highr_0.5.1        stringr_1.0.0     
## [10] plyr_1.8.3         dplyr_0.4.3        tools_3.2.4       
## [13] parallel_3.2.4     dichromat_2.0-0    DT_0.1.40         
## [16] grid_3.2.4         gtable_0.2.0       DBI_0.3.1         
## [19] extrafontdb_1.0    htmltools_0.3.5    lazyeval_0.1.10   
## [22] yaml_2.1.13        assertthat_0.1     digest_0.6.9      
## [25] formatR_1.3        RColorBrewer_1.1-2 tidyr_0.4.1       
## [28] htmlwidgets_0.6    rsconnect_0.4.2.1  evaluate_0.8.3    
## [31] rmarkdown_0.9.5    labeling_0.3       stringi_1.0-1     
## [34] scales_0.4.0       extrafont_0.17     jsonlite_0.9.19
```

```r
Sys.time()
```

```
## [1] "2016-04-07 10:14:50 PDT"
```

