



This report was automatically generated with the R package **knitr**
(version 1.13).


```r
# knitr::stitch_rmd(script="./manipulation/rename-classify.R", output="./manipulation/rename-classify.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
```

```r
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
```

```r
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) #Pipes

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit", quietly=TRUE)
# requireNamespace("plyr", quietly=TRUE)
```

```r
path_input <- "./data/unshared/derived/dto.rds"
path_output <- "data/unshared/derived/dto.rds"
```

```r
# load the product of 0-ellis-island.R,  a list object containing data and metad
dto <- readRDS(path_input)
```

```r
names(dto)
```

```
## [1] "unitData" "metaData" "ms_mmse"
```

```r
# 1st element - unit(person) level data
dplyr::tbl_df(dto[["unitData"]])
```

```
## Source: local data frame [9,708 x 113]
## 
##        id study scaled_to.x agreeableness conscientiousness extraversion
##     (int) (chr)       (chr)         (int)             (int)        (int)
## 1    9121  MAP         MAP             NA                35           34
## 2    9121  MAP         MAP             NA                35           34
## 3    9121  MAP         MAP             NA                35           34
## 4    9121  MAP         MAP             NA                35           34
## 5    9121  MAP         MAP             NA                35           34
## 6   33027  MAP         MAP             NA                NA           30
## 7   33027  MAP         MAP             NA                NA           30
## 8  204228  MAP         MAP             NA                NA           32
## 9  204228  MAP         MAP             NA                NA           32
## 10 204228  MAP         MAP             NA                NA           32
## ..    ...   ...         ...           ...               ...          ...
## Variables not shown: neo_altruism (int), neo_conscientiousness (int),
##   neo_trust (int), openness (int), anxiety_10items (dbl), neuroticism_12
##   (int), neuroticism_6 (int), age_bl (dbl), age_death (dbl), died (int),
##   educ (int), msex (int), race (int), spanish (int), apoe_genotype (int),
##   alco_life (dbl), q3smo_bl (int), q4smo_bl (int), smoke_bl (int), smoking
##   (int), fu_year (int), scaled_to.y (chr), cesdsum (int), r_depres (int),
##   intrusion (dbl), neglifeevents (int), negsocexchange (dbl), nohelp
##   (dbl), panas (dbl), perceivedstress (dbl), rejection (dbl),
##   unsympathetic (dbl), dcfdx (int), dementia (int), r_stroke (int),
##   cogn_ep (dbl), cogn_global (dbl), cogn_po (dbl), cogn_ps (dbl), cogn_se
##   (dbl), cogn_wo (dbl), cts_bname (int), catfluency (int), cts_db (int),
##   cts_delay (int), cts_df (int), cts_doperf (int), cts_ebdr (int),
##   cts_ebmt (int), cts_idea (int), cts_lopair (int), mmse (dbl), cts_nccrtd
##   (int), cts_pmat (int), cts_read_nart (int), cts_read_wrat (int),
##   cts_sdmt (int), cts_story (int), cts_wli (int), cts_wlii (int),
##   cts_wliii (int), age_at_visit (dbl), iadlsum (int), katzsum (int),
##   rosbscl (int), rosbsum (int), vision (int), visionlog (dbl), fev (dbl),
##   mep (dbl), mip (dbl), pvc (dbl), bun (int), ca (dbl), chlstrl (int), cl
##   (int), co2 (int), crn (dbl), fasting (int), glucose (int), hba1c (dbl),
##   hdlchlstrl (int), hdlratio (dbl), k (dbl), ldlchlstrl (int), na (int),
##   alcohol_g (dbl), bmi (dbl), htm (dbl), phys5itemsum (dbl), wtkg (dbl),
##   bp11 (chr), bp2 (chr), bp3 (int), bp31 (chr), hypertension_cum (int),
##   dm_cum (int), thyroid_cum (int), chf_cum (int), claudication_cum (int),
##   heart_cum (int), stroke_cum (int), vasc_3dis_sum (dbl), vasc_4dis_sum
##   (dbl), vasc_risks_sum (dbl), gait_speed (dbl), gripavg (dbl)
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
## 43      cognitive           cogn_global       global cognition
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
## 22           TRUE        FALSE       drinks/day    TRUE
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

```r
ds <- dto[["unitData"]]

# table(ds$fu_year, ds$dementia)
```

```r
# if died==1, all subsequent focal_outcome==DEAD.
set.seed(43)
ids <- sample(unique(ds$id),3)
ds_long <- ds %>% 
  # dplyr::filter(id %in% ids) %>%
  dplyr::mutate(
    age_death = as.numeric(age_death), 
    male      = as.logical(ifelse(!is.na(msex), msex=="1", NA_integer_)),
    edu       = as.numeric(educ)
  ) %>% 
  dplyr::select_(
    "id",
    # "fu_year",
    "male",
    "age_death",
    "age_at_visit",
    "mmse") 
ds_long # in long format
```

```
##            id  male age_death age_at_visit      mmse
## 1        9121 FALSE        NA     79.96988 29.000000
## 2        9121 FALSE        NA     81.08145 29.000000
## 3        9121 FALSE        NA     81.61259 30.000000
## 4        9121 FALSE        NA     82.59548 30.000000
## 5        9121 FALSE        NA     83.62218 29.000000
## 6       33027 FALSE        NA     81.00753 29.000000
## 7       33027 FALSE        NA     82.13552        NA
## 8      204228  TRUE        NA     65.21561 27.000000
## 9      204228  TRUE        NA     68.30116 25.000000
## 10     204228  TRUE        NA     69.35524 28.000000
## 11     204228  TRUE        NA     70.49966 28.000000
## 12     204228  TRUE        NA     71.42505 27.000000
## 13     204228  TRUE        NA     72.49281 29.000000
## 14     246264 FALSE        NA     89.99042 27.000000
## 15     246264 FALSE        NA     91.04449 29.000000
## 16     246264 FALSE        NA     92.07940 27.000000
## 17     246264 FALSE        NA     93.03491 26.000000
## 18     246264 FALSE        NA     94.06160 27.000000
## 19     246264 FALSE        NA     95.09651 29.000000
## 20     246264 FALSE        NA     96.03559        NA
## 21     246264 FALSE        NA     96.97467        NA
## 22     246264 FALSE        NA     98.03422        NA
## 23     285563 FALSE        NA     84.70363 28.000000
## 24     285563 FALSE        NA     85.48392 30.000000
## 25     285563 FALSE        NA     86.49966 30.000000
## 26     285563 FALSE        NA     87.47981 30.000000
## 27     285563 FALSE        NA     89.47296 27.000000
## 28     285563 FALSE        NA     90.46680 25.000000
## 29     285563 FALSE        NA     91.46338 28.000000
## 30     285563 FALSE        NA     92.44901 20.000000
## 31     285563 FALSE        NA     93.45380 23.000000
## 32     402800 FALSE        NA     78.69131 17.000000
## 33     402800 FALSE        NA     79.70157 13.000000
## 34     482428 FALSE  83.69062     81.37988 30.000000
## 35     482428 FALSE  83.69062     82.32170 30.000000
## 36     617643 FALSE        NA     65.36345 29.000000
## 37     617643 FALSE        NA     66.30253 30.000000
## 38     617643 FALSE        NA     67.29637 30.000000
## 39     617643 FALSE        NA     68.31211 30.000000
## 40     617643 FALSE        NA     69.27584 30.000000
## 41     617643 FALSE        NA     70.34086 29.000000
## 42     617643 FALSE        NA     71.32101 30.000000
## 43     617643 FALSE        NA     72.30116 30.000000
## 44     617643 FALSE        NA     73.30048 30.000000
## 45     617643 FALSE        NA     74.31622 29.000000
## 46     617643 FALSE        NA     75.32375 28.000000
## 47     668310  TRUE  92.61875     88.16427 26.000000
## 48     668310  TRUE  92.61875     88.63518 18.000000
## 49     668310  TRUE  92.61875     89.52225 12.000000
## 50     668310  TRUE  92.61875     90.52156  6.000000
## 51     668310  TRUE  92.61875     91.51266  9.000000
## 52     668310  TRUE  92.61875     92.51472  8.000000
## 53     696418 FALSE        NA     83.76454 25.000000
## 54     696418 FALSE        NA     84.52841 30.000000
## 55     696418 FALSE        NA     85.73580 26.000000
## 56     696418 FALSE        NA     86.84463 28.000000
## 57     696418 FALSE        NA     87.76728 30.000000
## 58     696418 FALSE        NA     88.84326 27.000000
## 59     696418 FALSE        NA     89.76044 28.000000
## 60     696418 FALSE        NA     90.82820 29.000000
## 61     696418 FALSE        NA     91.71253 30.000000
## 62     701662 FALSE        NA     66.79535 26.000000
## 63     701662 FALSE        NA     67.72074 23.000000
## 64     701662 FALSE        NA     68.43532 26.000000
## 65     701662 FALSE        NA     69.44285 29.000000
## 66     701662 FALSE        NA     70.64750 28.000000
## 67     701662 FALSE        NA     71.48255 29.000000
## 68     701662 FALSE        NA     72.87064 28.000000
## 69     709354  TRUE        NA     69.27858 29.000000
## 70     709354  TRUE        NA     70.17112 28.000000
## 71     709354  TRUE        NA     71.19233 29.000000
## 72     709354  TRUE        NA     72.20808 30.000000
## 73     709354  TRUE        NA     73.43463 29.000000
## 74     807897 FALSE        NA     83.67693 28.000000
## 75     807897 FALSE        NA     84.68720 28.000000
## 76     807897 FALSE        NA     85.66735 28.000000
## 77     807897 FALSE        NA     86.70773 29.000000
## 78    1172523 FALSE        NA     86.13005 29.000000
## 79    1172523 FALSE        NA     86.75975 30.000000
## 80    1179886 FALSE        NA     76.01369 25.000000
## 81    1179886 FALSE        NA     77.81246 29.000000
## 82    1179886 FALSE        NA     80.01095 28.000000
## 83    1243685 FALSE  90.38467     86.70773 30.000000
## 84    1243685 FALSE  90.38467     87.72895 28.000000
## 85    1243685 FALSE  90.38467     88.72553 29.000000
## 86    1243685 FALSE  90.38467     89.72211 17.727273
## 87    1250710 FALSE        NA     67.81656 30.000000
## 88    1250710 FALSE        NA     68.75838 29.000000
## 89    1250710 FALSE        NA     70.05613 30.000000
## 90    1266704 FALSE        NA     80.22724 29.000000
## 91    1266704 FALSE        NA     81.20192 28.000000
## 92    1266704 FALSE        NA     82.31348 29.000000
## 93    1266704 FALSE        NA     83.23066 28.000000
## 94    1393350  TRUE  94.25325     93.83710 25.000000
## 95    1626306 FALSE        NA     69.15264 30.000000
## 96    1626306 FALSE        NA     70.11636 30.000000
## 97    1626306 FALSE        NA     71.14305 29.000000
## 98    1634158 FALSE        NA           NA        NA
## 99    1674624 FALSE  76.93634     76.49555 26.000000
## 100   1738075 FALSE        NA     94.03970 22.000000
## 101   1797756 FALSE        NA     82.45038 25.000000
## 102   1797756 FALSE        NA     83.41410 24.000000
## 103   1797756 FALSE        NA     84.40520 24.000000
## 104   1797756 FALSE        NA     85.42368 22.000000
## 105   1797756 FALSE        NA     86.38741 19.000000
## 106   1797756 FALSE        NA     87.47707 19.000000
## 107   1797756 FALSE        NA     88.41889 20.000000
## 108   1797756 FALSE        NA     89.43737 15.000000
## 109   1797756 FALSE        NA     90.56810  8.000000
## 110   1797756 FALSE        NA     92.46270  0.000000
## 111   1809849  TRUE  98.23956     96.81314 22.000000
## 112   1809849  TRUE  98.23956     98.03696 16.000000
## 113   1841461 FALSE        NA     72.60507 30.000000
## 114   1841461 FALSE        NA     73.52498 30.000000
## 115   1841461 FALSE        NA     74.53525 29.000000
## 116   1841461 FALSE        NA     75.38672 29.000000
## 117   1878130 FALSE        NA     75.92882 30.000000
## 118   1878130 FALSE        NA     76.78303 25.000000
## 119   2108769 FALSE        NA     82.68036 30.000000
## 120   2108769 FALSE        NA     83.66324 28.000000
## 121   2108769 FALSE        NA     84.66256 28.000000
## 122   2108769 FALSE        NA     85.69747 28.000000
## 123   2136155 FALSE        NA     73.86995 30.000000
## 124   2136155 FALSE        NA     74.72416 28.000000
## 125   2136155 FALSE        NA     75.67967 30.000000
## 126   2136155 FALSE        NA     76.82136 30.000000
## 127   2136155 FALSE        NA     77.84257 29.000000
## 128   2136155 FALSE        NA     78.85558 30.000000
## 129   2136155 FALSE        NA     79.79740 30.000000
## 130   2136155 FALSE        NA     80.83231 30.000000
## 131   2136155 FALSE        NA     82.02053 29.000000
## 132   2136155 FALSE        NA     83.63039 29.000000
## 133   2136155 FALSE        NA     84.64613 29.000000
## 134   2188675 FALSE        NA     83.19507 28.000000
## 135   2188675 FALSE        NA     84.47091 26.000000
## 136   2188675 FALSE        NA     85.30048 25.000000
## 137   2188675 FALSE        NA     87.21150 29.000000
## 138   2188675 FALSE        NA     88.55852 25.000000
## 139   2188675 FALSE        NA     89.57700 28.000000
## 140   2188675 FALSE        NA     91.08282 27.000000
## 141   2518573 FALSE        NA     54.33812 29.000000
## 142   2518573 FALSE        NA     55.10198 30.000000
## 143   2518573 FALSE        NA     56.13963 28.000000
## 144   2518573 FALSE        NA     57.30869 30.000000
## 145   2518573 FALSE        NA     58.24230 29.000000
## 146   2518573 FALSE        NA     59.58111 30.000000
## 147   2518573 FALSE        NA     60.61875 29.000000
## 148   2518573 FALSE        NA     61.80424 29.000000
## 149   2525608 FALSE 101.19097     96.93087 30.000000
## 150   2525608 FALSE 101.19097     98.07803 23.000000
## 151   2525608 FALSE 101.19097     99.07734 26.000000
## 152   2525608 FALSE 101.19097    100.11225 28.000000
## 153   2525608 FALSE 101.19097    101.07050 26.000000
## 154   2657173 FALSE        NA     80.75565 29.000000
## 155   2657173 FALSE        NA     81.47844 29.000000
## 156   2657173 FALSE        NA     82.68309 29.000000
## 157   2657173 FALSE        NA     83.77823 30.000000
## 158   2657173 FALSE        NA     84.71732 29.000000
## 159   2657173 FALSE        NA     85.77687 30.000000
## 160   2657173 FALSE        NA     86.71321 30.000000
## 161   2657173 FALSE        NA     87.78097 30.000000
## 162   2657173 FALSE        NA     88.71184 30.000000
## 163   2673641  TRUE        NA     85.21834 29.000000
## 164   2673641  TRUE        NA     86.10267 29.000000
## 165   2673641  TRUE        NA     87.12115 30.000000
## 166   2673641  TRUE        NA     88.07392 30.000000
## 167   2673641  TRUE        NA     89.07324 29.000000
## 168   2673641  TRUE        NA     90.07529 30.000000
## 169   2673641  TRUE        NA     91.50171 29.000000
## 170   2695917 FALSE        NA     79.37303 27.000000
## 171   2695917 FALSE        NA     80.15606 30.000000
## 172   2695917 FALSE        NA     81.27036 30.000000
## 173   2695917 FALSE        NA     82.01780 29.000000
## 174   2817047  TRUE  92.30664     89.51677 21.000000
## 175   2817047  TRUE  92.30664     90.57084 17.000000
## 176   2817047  TRUE  92.30664     91.49076 12.000000
## 177   2899847  TRUE  74.45038     71.52909 29.000000
## 178   2899847  TRUE  74.45038     72.48460 28.000000
## 179   2899847  TRUE  74.45038     73.48939 27.000000
## 180   2904677 FALSE        NA     75.19781 30.000000
## 181   2904677 FALSE        NA     76.27379 29.000000
## 182   2904677 FALSE        NA     77.01848 30.000000
## 183   2904677 FALSE        NA     78.00684 30.000000
## 184   2904677 FALSE        NA     79.02806 30.000000
## 185   2950975 FALSE        NA     76.98015 29.000000
## 186   2950975 FALSE        NA     77.68925 28.000000
## 187   2950975 FALSE        NA     78.93498 29.000000
## 188   2950975 FALSE        NA     79.64682 28.000000
## 189   2959960 FALSE        NA     90.33539 30.000000
## 190   2959960 FALSE        NA     91.32923 30.000000
## 191   2959960 FALSE        NA     92.33676 29.000000
## 192   2967974 FALSE  87.35934     84.86516 25.000000
## 193   2967974 FALSE  87.35934     85.99863 20.000000
## 194   2967974 FALSE  87.35934     86.83641 23.000000
## 195   3052480 FALSE        NA     85.99863 30.000000
## 196   3052480 FALSE        NA     86.97604 28.000000
## 197   3052480 FALSE        NA     88.01916 28.000000
## 198   3060782 FALSE        NA     75.93977 29.000000
## 199   3227207 FALSE        NA     81.77139 29.000000
## 200   3227207 FALSE        NA     82.76523 30.000000
## 201   3227207 FALSE        NA     83.77276 29.000000
## 202   3227207 FALSE        NA     84.78576 28.000000
## 203   3227207 FALSE        NA     85.77687 29.000000
## 204   3227207 FALSE        NA     86.76249 29.000000
## 205   3227207 FALSE        NA     87.77002 26.000000
## 206   3227207 FALSE        NA     88.76386 29.000000
## 207   3227207 FALSE        NA     89.75222 30.000000
## 208   3227207 FALSE        NA     90.75702 27.000000
## 209   3227207 FALSE        NA     91.75633 27.000000
## 210   3227207 FALSE        NA     92.75565 27.000000
## 211   3283241  TRUE  77.45927     72.45996 29.000000
## 212   3283241  TRUE  77.45927     73.45654 29.000000
## 213   3283241  TRUE  77.45927     74.45311 30.000000
## 214   3283241  TRUE  77.45927     75.47159 29.000000
## 215   3283241  TRUE  77.45927     76.44627 30.000000
## 216   3326467  TRUE        NA     67.88775 28.000000
## 217   3326467  TRUE        NA     68.88159 29.000000
## 218   3335936 FALSE        NA     86.87748 29.000000
## 219   3380931 FALSE        NA     84.67077 23.000000
## 220   3380931 FALSE        NA     85.68378 22.000000
## 221   3380931 FALSE        NA     86.65572 24.000000
## 222   3380931 FALSE        NA     87.66324 15.000000
## 223   3430444 FALSE  84.91170     76.49829 29.000000
## 224   3430444 FALSE  84.91170     77.49760 29.000000
## 225   3430444 FALSE  84.91170     78.51608 28.000000
## 226   3430444 FALSE  84.91170     79.50719 27.000000
## 227   3430444 FALSE  84.91170     80.53388 30.000000
## 228   3430444 FALSE  84.91170     82.00958 27.000000
## 229   3430444 FALSE  84.91170     82.53525 29.000000
## 230   3430444 FALSE  84.91170     83.49897 27.000000
## 231   3430444 FALSE  84.91170     84.51745 17.000000
## 232   3700779  TRUE  84.49829     83.12389 29.000000
## 233   3700779  TRUE  84.49829     84.22724 27.000000
## 234   3713990  TRUE  87.92882     87.66872 30.000000
## 235   3806878  TRUE        NA     87.77550 26.000000
## 236   3806878  TRUE        NA     88.35044 28.000000
## 237   3889845 FALSE  95.58932     87.74538 26.000000
## 238   3889845 FALSE  95.58932     88.81862 22.000000
## 239   3889845 FALSE  95.58932     89.84805 23.000000
## 240   3889845 FALSE  95.58932     90.83094 27.000000
## 241   3889845 FALSE  95.58932     91.82204 22.000000
## 242   3889845 FALSE  95.58932     93.12526 27.000000
## 243   3889845 FALSE  95.58932     93.79603 27.000000
## 244   3889845 FALSE  95.58932     94.77892 22.000000
## 245   3902977 FALSE        NA     72.53388 30.000000
## 246   3902977 FALSE        NA     73.62628 29.000000
## 247   3902977 FALSE        NA     74.80356 29.000000
## 248   3902977 FALSE        NA     75.65503 29.000000
## 249   3902977 FALSE        NA     76.69268 30.000000
## 250   3902977 FALSE        NA     77.88912 29.000000
## 251   3902977 FALSE        NA     79.15400 26.000000
## 252   3902977 FALSE        NA     79.81656 29.000000
## 253   3902977 FALSE        NA     80.94456 29.000000
## 254   3902977 FALSE        NA     81.87269 30.000000
## 255   3971682  TRUE  83.89870     83.10746 25.000000
## 256   4127190 FALSE  88.63792     79.72074 26.000000
## 257   4127190 FALSE  88.63792     80.76386 30.000000
## 258   4127190 FALSE  88.63792     81.94114 30.000000
## 259   4127190 FALSE  88.63792     82.75428 28.000000
## 260   4127190 FALSE  88.63792     83.76454 28.000000
## 261   4127190 FALSE  88.63792     84.89528 30.000000
## 262   4127190 FALSE  88.63792     85.85626 26.000000
## 263   4127190 FALSE  88.63792     86.73511 27.000000
## 264   4127190 FALSE  88.63792     87.75086 29.000000
## 265   4319814 FALSE        NA     79.64408 30.000000
## 266   4319814 FALSE        NA     80.68720 30.000000
## 267   4319814 FALSE        NA     81.64819 29.000000
## 268   4319814 FALSE        NA     82.66119 29.000000
## 269   4330337  TRUE        NA     86.52430 30.000000
## 270   4330337  TRUE        NA     87.51266 30.000000
## 271   4330337  TRUE        NA     88.54483 29.000000
## 272   4330337  TRUE        NA     89.54689 29.000000
## 273   4330337  TRUE        NA     90.54073 29.000000
## 274   4330337  TRUE        NA     91.51540 30.000000
## 275   4330337  TRUE        NA     92.56947 29.000000
## 276   4330337  TRUE        NA     93.52772 30.000000
## 277   4330337  TRUE        NA     94.51608 28.000000
## 278   4330337  TRUE        NA     95.42779 29.000000
## 279   4330337  TRUE        NA     96.52293 29.000000
## 280   4330337  TRUE        NA     97.51677 29.000000
## 281   4406282 FALSE        NA     72.37782 30.000000
## 282   4493359 FALSE        NA     79.59754 29.000000
## 283   4493359 FALSE        NA     80.61875        NA
## 284   4493359 FALSE        NA     81.59343        NA
## 285   4493359 FALSE        NA     86.10267        NA
## 286   4493359 FALSE        NA     87.34565        NA
## 287   4493359 FALSE        NA     88.60507        NA
## 288   4493359 FALSE        NA     89.77139        NA
## 289   4576591 FALSE  94.43669     88.74470 27.000000
## 290   4576591 FALSE  94.43669     89.73580 22.000000
## 291   4576591 FALSE  94.43669     90.74880 30.000000
## 292   4576591 FALSE  94.43669     91.77002 27.000000
## 293   4576591 FALSE  94.43669     92.76386 23.000000
## 294   4576591 FALSE  94.43669     93.77687 18.000000
## 295   4767750  TRUE        NA     76.33402 30.000000
## 296   4767750  TRUE        NA     77.35250 30.000000
## 297   4767750  TRUE        NA     78.32444 28.000000
## 298   4767750  TRUE        NA     79.30732 28.000000
## 299   4767750  TRUE        NA     80.34497 29.000000
## 300   4862682 FALSE        NA     75.66872 29.000000
## 301   4862682 FALSE        NA     76.81588 30.000000
## 302   4862682 FALSE        NA     77.63997 26.000000
## 303   4862682 FALSE        NA     78.66393        NA
## 304   4879843 FALSE  95.39767     92.64339 29.000000
## 305   4879843 FALSE  95.39767     93.62902 30.000000
## 306   4879843 FALSE  95.39767     94.57906 28.000000
## 307   4886978  TRUE        NA     83.80835 29.000000
## 308   4941596 FALSE        NA     78.68036 29.000000
## 309   4941596 FALSE        NA     79.69336 28.000000
## 310   4947970  TRUE  90.52156     87.75907 28.000000
## 311   4947970  TRUE  90.52156     88.82136 30.000000
## 312   4947970  TRUE  90.52156     89.82615 28.000000
## 313   4968529  TRUE        NA     73.35524 30.000000
## 314   4968529  TRUE        NA     74.13279 29.000000
## 315   4968529  TRUE        NA     74.87748 28.000000
## 316   4981936 FALSE        NA     82.86927 29.000000
## 317   4981936 FALSE        NA     83.87680 30.000000
## 318   4981936 FALSE        NA     84.83504 30.000000
## 319   4981936 FALSE        NA     85.83984 27.000000
## 320   4981936 FALSE        NA     86.84189 30.000000
## 321   4981936 FALSE        NA     87.86037 26.000000
## 322   4981936 FALSE        NA     88.84052 29.000000
## 323   4981936 FALSE        NA     89.82615 29.000000
## 324   4981936 FALSE        NA     90.82546 30.000000
## 325   4981936 FALSE        NA     91.82478 29.000000
## 326   4981936 FALSE        NA     92.82409 30.000000
## 327   4981936 FALSE        NA     93.83436 30.000000
## 328   4981936 FALSE        NA     94.83641 26.000000
## 329   4984547  TRUE        NA     77.52498 27.000000
## 330   4984547  TRUE        NA     78.53525 30.000000
## 331   4984547  TRUE        NA     79.54004 29.000000
## 332   4984547  TRUE        NA     80.51472 29.000000
## 333   5001777 FALSE        NA     69.23477 30.000000
## 334   5001777 FALSE        NA     70.14648 30.000000
## 335   5001777 FALSE        NA     71.01985 30.000000
## 336   5001777 FALSE        NA     72.01643 28.000000
## 337   5001777 FALSE        NA     73.02396 30.000000
## 338   5001777 FALSE        NA     74.16290 30.000000
## 339   5001777 FALSE        NA     75.02259 29.000000
## 340   5001777 FALSE        NA     76.01095 29.000000
## 341   5001777 FALSE        NA     77.00753 30.000000
## 342   5102083 FALSE        NA     87.42779 29.000000
## 343   5102083 FALSE        NA     88.30664 28.000000
## 344   5102083 FALSE        NA     89.24572 28.000000
## 345   5102083 FALSE        NA     90.26694 28.000000
## 346   5102083 FALSE        NA     91.21697 29.000000
## 347   5102083 FALSE        NA     92.23546 28.000000
## 348   5218242 FALSE        NA     82.92129 30.000000
## 349   5218242 FALSE        NA     83.99726 29.000000
## 350   5218242 FALSE        NA     85.02669 28.000000
## 351   5218242 FALSE        NA     86.00958 28.000000
## 352   5218242 FALSE        NA     86.98973 30.000000
## 353   5218242 FALSE        NA     88.06571 29.000000
## 354   5218242 FALSE        NA     88.96099 29.000000
## 355   5218242 FALSE        NA     89.93566 30.000000
## 356   5218242 FALSE        NA     90.97604 29.000000
## 357   5218242 FALSE        NA     91.96988 29.000000
## 358   5218242 FALSE        NA     92.94730 29.000000
## 359   5274286 FALSE        NA     78.68309 30.000000
## 360   5331374 FALSE        NA     87.95619 27.000000
## 361   5331374 FALSE        NA     89.02396 27.000000
## 362   5331374 FALSE        NA     90.00411 26.000000
## 363   5331374 FALSE        NA     91.05544 27.000000
## 364   5331374 FALSE        NA     92.05749 27.000000
## 365   5331374 FALSE        NA     93.02943 25.000000
## 366   5331374 FALSE        NA     94.03149 26.000000
## 367   5331374 FALSE        NA     95.04175 29.000000
## 368   5331374 FALSE        NA     96.02738 24.000000
## 369   5331374 FALSE        NA     97.00479 23.000000
## 370   5331374 FALSE        NA     99.03628 22.000000
## 371   5375330 FALSE        NA     78.00137 26.000000
## 372   5375330 FALSE        NA     78.99247 28.965517
## 373   5375330 FALSE        NA     80.19986 28.000000
## 374   5375330 FALSE        NA     81.40452 25.000000
## 375   5375330 FALSE        NA     82.01780 27.600000
## 376   5427601 FALSE        NA     79.17591 28.000000
## 377   5427601 FALSE        NA     80.27652 28.000000
## 378   5427601 FALSE        NA     80.93908 26.000000
## 379   5427601 FALSE        NA     82.28884 30.000000
## 380   5427601 FALSE        NA     83.13758 26.000000
## 381   5498462  TRUE  92.16701     86.72964 29.000000
## 382   5498462  TRUE  92.16701     87.62765 30.000000
## 383   5498462  TRUE  92.16701     88.68172 28.000000
## 384   5498462  TRUE  92.16701     89.64271 29.000000
## 385   5498462  TRUE  92.16701     90.62286 28.000000
## 386   5498462  TRUE  92.16701     91.65503 27.000000
## 387   5522533 FALSE        NA     76.46817 29.000000
## 388   5522533 FALSE        NA     77.48665 30.000000
## 389   5522533 FALSE        NA     78.46680 30.000000
## 390   5522533 FALSE        NA     79.48255 30.000000
## 391   5522533 FALSE        NA     81.78508 21.428571
## 392   5522533 FALSE        NA     82.48871 20.689655
## 393   5522533 FALSE        NA     83.49897 19.000000
## 394   5522533 FALSE        NA     84.49008 15.000000
## 395   5522533 FALSE        NA     85.74401 19.000000
## 396   5522533 FALSE        NA     86.51882 16.000000
## 397   5537936 FALSE        NA     80.10951 28.000000
## 398   5537936 FALSE        NA     81.73854 29.000000
## 399   5577538 FALSE        NA     71.22519 26.000000
## 400   5577538 FALSE        NA     72.42437 22.000000
## 401   5577538 FALSE        NA     73.43737 24.000000
## 402   5577538 FALSE        NA     74.42847 25.000000
## 403   5577538 FALSE        NA     75.46338 27.000000
## 404   5577538 FALSE        NA     76.45996 27.000000
## 405   5577538 FALSE        NA     77.42642 27.000000
## 406   5577538 FALSE        NA     78.47502 25.000000
## 407   5577538 FALSE        NA     79.63860 26.000000
## 408   5577538 FALSE        NA     80.63518 28.000000
## 409   5632732  TRUE        NA     75.60027 26.000000
## 410   5632732  TRUE        NA     76.63518 30.000000
## 411   5632732  TRUE        NA     77.61807 24.000000
## 412   5632732  TRUE        NA     78.62286 24.000000
## 413   5632732  TRUE        NA     79.72621 26.000000
## 414   5632732  TRUE        NA     80.60780 29.000000
## 415   5632732  TRUE        NA     81.63176 28.000000
## 416   5632732  TRUE        NA     82.61465 25.000000
## 417   5632732  TRUE        NA     83.59754 27.000000
## 418   5632732  TRUE        NA     84.61328 26.000000
## 419   5689621 FALSE  88.75017     84.90897 26.000000
## 420   5689621 FALSE  88.75017     85.92471 23.000000
## 421   5689621 FALSE  88.75017     86.93224 24.000000
## 422   5689621 FALSE  88.75017     87.95072 26.000000
## 423   5779736 FALSE  89.18001     86.53799 24.000000
## 424   5779736 FALSE  89.18001     87.55647 18.000000
## 425   5779736 FALSE  89.18001     88.58864  3.000000
## 426   5859529 FALSE        NA     79.52635 26.000000
## 427   5931594 FALSE        NA     80.66256 26.000000
## 428   5931594 FALSE        NA     81.40999 29.000000
## 429   5931594 FALSE        NA     82.42300 27.000000
## 430   6073025 FALSE  85.40726     81.85626 29.000000
## 431   6073025 FALSE  85.40726     82.92402 29.000000
## 432   6073025 FALSE  85.40726     83.91239 24.827586
## 433   6073025 FALSE  85.40726     84.95551 27.000000
## 434   6107196  TRUE  94.06982     92.69815 22.000000
## 435   6129174  TRUE        NA     71.95072 27.000000
## 436   6129174  TRUE        NA     73.19918 25.000000
## 437   6129174  TRUE        NA     74.19302 27.000000
## 438   6129174  TRUE        NA     75.42779 28.000000
## 439   6129174  TRUE        NA     76.22998 23.000000
## 440   6129174  TRUE        NA     77.19370 29.000000
## 441   6129174  TRUE        NA     78.18480 25.000000
## 442   6129174  TRUE        NA     79.19507 27.000000
## 443   6129174  TRUE        NA     80.23272 25.862069
## 444   6129174  TRUE        NA     81.23203 25.000000
## 445   6131380 FALSE        NA     78.77618 29.000000
## 446   6138931 FALSE        NA     66.71869 30.000000
## 447   6138931 FALSE        NA     68.02190 29.000000
## 448   6152191 FALSE        NA     77.15264 30.000000
## 449   6152191 FALSE        NA     78.50787 28.000000
## 450   6152191 FALSE        NA     79.08282 30.000000
## 451   6152191 FALSE        NA     80.29569 30.000000
## 452   6152191 FALSE        NA     81.82888 27.000000
## 453   6152191 FALSE        NA     83.12115 30.000000
## 454   6272612 FALSE        NA     85.10609 29.000000
## 455   6272612 FALSE        NA     86.15469 28.000000
## 456   6272612 FALSE        NA     87.11294 28.000000
## 457   6272612 FALSE        NA     88.24914 29.000000
## 458   6272612 FALSE        NA     89.05681 29.000000
## 459   6272612 FALSE        NA     90.05065 29.000000
## 460   6272612 FALSE        NA     91.08282 28.000000
## 461   6272612 FALSE        NA     92.11773 30.000000
## 462   6272612 FALSE        NA     93.13347 29.000000
## 463   6625341  TRUE        NA     75.36208 29.000000
## 464   6702361 FALSE        NA     82.14648 29.000000
## 465   6702361 FALSE        NA     83.14853 30.000000
## 466   6764103 FALSE        NA     83.89049 29.000000
## 467   6764103 FALSE        NA     84.88159 28.000000
## 468   6769734 FALSE        NA     73.37440 30.000000
## 469   6769734 FALSE        NA     75.32101 30.000000
## 470   6769734 FALSE        NA     76.34223 29.000000
## 471   6769734 FALSE        NA     78.12183 30.000000
## 472   6769734 FALSE        NA     78.57906 30.000000
## 473   6769734 FALSE        NA     79.38672 28.000000
## 474   6769734 FALSE        NA     81.35524 30.000000
## 475   6769734 FALSE        NA     82.33812 28.000000
## 476   6804844  TRUE  86.97331     77.33607 29.000000
## 477   6804844  TRUE  86.97331     78.30801 28.000000
## 478   6804844  TRUE  86.97331     79.28816 26.000000
## 479   6804844  TRUE  86.97331     80.30116 28.000000
## 480   6804844  TRUE  86.97331     81.83436 28.000000
## 481   6804844  TRUE  86.97331     82.27515 28.000000
## 482   6804844  TRUE  86.97331     83.34839 29.000000
## 483   6804844  TRUE  86.97331     84.32580 28.000000
## 484   6804844  TRUE  86.97331     85.32238 28.000000
## 485   6804844  TRUE  86.97331     86.72142        NA
## 486   6881437  TRUE        NA     77.33881 29.000000
## 487   6881437  TRUE        NA     78.31896 29.000000
## 488   6881437  TRUE        NA     79.23888 29.000000
## 489   6881437  TRUE        NA     80.27652 30.000000
## 490   6881437  TRUE        NA     81.21834 29.000000
## 491   6881437  TRUE        NA     82.27242 29.000000
## 492   6881437  TRUE        NA     83.23340 28.000000
## 493   6881437  TRUE        NA     84.22177 29.000000
## 494   6881437  TRUE        NA     85.22108 28.000000
## 495   6881437  TRUE        NA     86.24230 29.000000
## 496   7042636 FALSE        NA     64.45448 29.000000
## 497   7042636 FALSE        NA     65.08966 29.000000
## 498   7042636 FALSE        NA     65.85900 29.000000
## 499   7042636 FALSE        NA     66.69405 29.000000
## 500   7042636 FALSE        NA     68.01643 30.000000
## 501   7042636 FALSE        NA     68.73374 29.000000
## 502   7042636 FALSE        NA     69.75222 30.000000
## 503   7053099 FALSE        NA     76.44901 30.000000
## 504   7053099 FALSE        NA     77.44832 30.000000
## 505   7096040 FALSE        NA     74.20123 22.000000
## 506   7117738 FALSE        NA     82.27789 28.000000
## 507   7117738 FALSE        NA     83.28542 27.000000
## 508   7117738 FALSE        NA     84.28747 29.000000
## 509   7117738 FALSE        NA     85.47844 26.000000
## 510   7117738 FALSE        NA     86.45038 28.000000
## 511   7117738 FALSE        NA     87.47159 26.000000
## 512   7117738 FALSE        NA     88.47639 24.000000
## 513   7142937  TRUE  93.14442     86.02601 30.000000
## 514   7142937  TRUE  93.14442     87.01985 26.000000
## 515   7142937  TRUE  93.14442     87.87680 29.000000
## 516   7142937  TRUE  93.14442     89.14990 28.000000
## 517   7142937  TRUE  93.14442     90.36824        NA
## 518   7142937  TRUE  93.14442     91.04723 24.000000
## 519   7142937  TRUE  93.14442     91.84942 23.000000
## 520   7142937  TRUE  93.14442     92.86242 18.000000
## 521   7253015 FALSE  88.52841     84.84873 27.000000
## 522   7253015 FALSE  88.52841     85.60164 25.000000
## 523   7253015 FALSE  88.52841     86.65572 24.000000
## 524   7253015 FALSE  88.52841     87.64956 23.000000
## 525   7265221 FALSE 101.60712     90.73238 28.000000
## 526   7265221 FALSE 101.60712     91.75359 26.000000
## 527   7265221 FALSE 101.60712     92.73374 22.000000
## 528   7265221 FALSE 101.60712     93.73032 23.000000
## 529   7265221 FALSE 101.60712     94.71869 22.000000
## 530   7265221 FALSE 101.60712     95.72348 20.000000
## 531   7265221 FALSE 101.60712     96.71732 21.000000
## 532   7265221 FALSE 101.60712     97.71389 20.000000
## 533   7265221 FALSE 101.60712     98.71321 20.000000
## 534   7265221 FALSE 101.60712     99.73169 20.000000
## 535   7265221 FALSE 101.60712    100.72827 14.000000
## 536   7287209 FALSE 101.47296     96.44901 28.000000
## 537   7287209 FALSE 101.47296     97.36893 24.000000
## 538   7287209 FALSE 101.47296     98.41752 22.000000
## 539   7287209 FALSE 101.47296     99.37577 21.000000
## 540   7287209 FALSE 101.47296    100.72005 16.000000
## 541   7287209 FALSE 101.47296    101.39357        NA
## 542   7311370  TRUE  89.46749     82.38193 30.000000
## 543   7311370  TRUE  89.46749     83.61123 29.000000
## 544   7311370  TRUE  89.46749     84.42437 26.000000
## 545   7311370  TRUE  89.46749     85.51129 25.000000
## 546   7311370  TRUE  89.46749     86.58727 27.000000
## 547   7311370  TRUE  89.46749     87.46338 27.000000
## 548   7311370  TRUE  89.46749     88.68994 22.000000
## 549   7570491 FALSE        NA     72.96372 28.000000
## 550   7570491 FALSE        NA     73.71389 26.000000
## 551   7570491 FALSE        NA     74.67214 24.000000
## 552   7570491 FALSE        NA     75.66872 26.000000
## 553   7761236  TRUE        NA     84.86242 26.000000
## 554   7761236  TRUE        NA     85.80424 28.000000
## 555   7803023  TRUE        NA     63.70705 28.000000
## 556   7803023  TRUE        NA     64.90623 30.000000
## 557   7803023  TRUE        NA     66.03696 22.000000
## 558   7883803 FALSE  88.65982     82.78439 26.000000
## 559   7883803 FALSE  88.65982     83.83847 23.000000
## 560   7883803 FALSE  88.65982     84.73374 27.000000
## 561   7883803 FALSE  88.65982     85.94387 23.000000
## 562   7883803 FALSE  88.65982     86.76523 18.000000
## 563   8109170 FALSE  88.08761     82.26968 30.000000
## 564   8109170 FALSE  88.08761     83.32923 30.000000
## 565   8109170 FALSE  88.08761     84.35592 28.000000
## 566   8109170 FALSE  88.08761     85.37166 27.000000
## 567   8109170 FALSE  88.08761     86.31896 26.000000
## 568   8109170 FALSE  88.08761     87.61944 27.000000
## 569   8132197 FALSE  92.61054     88.53662 28.000000
## 570   8132197 FALSE  92.61054     89.60986 27.000000
## 571   8132197 FALSE  92.61054     90.59001 28.000000
## 572   8132197 FALSE  92.61054     91.64134 27.000000
## 573   8245033 FALSE        NA     78.03422 30.000000
## 574   8245033 FALSE        NA     79.03354        NA
## 575   8245033 FALSE        NA     80.03012 29.000000
## 576   8323356  TRUE  82.82820     76.53388 24.000000
## 577   8323356  TRUE  82.82820     77.58795 29.000000
## 578   8323356  TRUE  82.82820     78.52430 25.000000
## 579   8323356  TRUE  82.82820     79.83573 23.000000
## 580   8323356  TRUE  82.82820     80.73101 20.000000
## 581   8337320 FALSE        NA     64.99658 29.000000
## 582   8337320 FALSE        NA     66.01780 29.000000
## 583   8337320 FALSE        NA     66.95140 29.000000
## 584   8390339 FALSE        NA     77.01848 29.000000
## 585   8464714 FALSE        NA     60.84326 29.000000
## 586   8464714 FALSE        NA     61.76318 30.000000
## 587   8481297  TRUE        NA     72.81314 29.000000
## 588   8481297  TRUE        NA     73.80972 30.000000
## 589   8481297  TRUE        NA     74.80630 29.000000
## 590   8481297  TRUE        NA     75.85489 29.000000
## 591   8481297  TRUE        NA     76.79945 27.000000
## 592   8481297  TRUE        NA     77.79603 30.000000
## 593   8481297  TRUE        NA     78.81451        NA
## 594   8481297  TRUE        NA     79.80561 27.000000
## 595   8536593 FALSE        NA     76.67077 28.000000
## 596   8536593 FALSE        NA     77.84805 29.000000
## 597   8536593 FALSE        NA     78.77618 28.000000
## 598   8536593 FALSE        NA     80.19165 30.000000
## 599   8536593 FALSE        NA     80.72827 30.000000
## 600   8536593 FALSE        NA     81.79603 29.000000
## 601   8536593 FALSE        NA     82.69952 29.000000
## 602   8536593 FALSE        NA     83.65777 27.000000
## 603   8536593 FALSE        NA     84.71184        NA
## 604   8536593 FALSE        NA     85.46749 29.000000
## 605   8536593 FALSE        NA     86.67214 28.000000
## 606   8558869 FALSE        NA     78.51608 25.000000
## 607   8558869 FALSE        NA     79.22245 26.000000
## 608   8558869 FALSE        NA     80.03833 26.000000
## 609   8558869 FALSE        NA     81.01848 27.000000
## 610   8558869 FALSE        NA     81.97673 27.600000
## 611   8604620  TRUE  84.83504     80.17248 29.000000
## 612   8637647  TRUE  89.53867     81.18275 28.000000
## 613   8637647  TRUE  89.53867     81.63723 29.000000
## 614   8637647  TRUE  89.53867     82.63381 27.000000
## 615   8637647  TRUE  89.53867     83.59206 28.000000
## 616   8637647  TRUE  89.53867     84.60780 28.000000
## 617   8637647  TRUE  89.53867     85.62081 24.000000
## 618   8637647  TRUE  89.53867     86.60096 29.000000
## 619   8637647  TRUE  89.53867     87.62218 27.000000
## 620   8637647  TRUE  89.53867     88.58042 25.000000
## 621   8682642 FALSE        NA     83.93977 30.000000
## 622   8682642 FALSE        NA     84.88980 29.000000
## 623   8682642 FALSE        NA     86.25599 26.000000
## 624   8682642 FALSE        NA     86.94319 27.000000
## 625   8682642 FALSE        NA     87.94251 29.000000
## 626   8682642 FALSE        NA     88.93361 28.000000
## 627   8682642 FALSE        NA     89.98494 26.000000
## 628   8682642 FALSE        NA     90.92402 26.000000
## 629   8682642 FALSE        NA     91.92608 29.000000
## 630   8682642 FALSE        NA     92.88980 26.000000
## 631   8682642 FALSE        NA     93.91650 28.000000
## 632   8891975 FALSE        NA     65.59617 30.000000
## 633   8891975 FALSE        NA     66.60917 28.000000
## 634   8891975 FALSE        NA     67.63860 30.000000
## 635   8891975 FALSE        NA     68.71732        NA
## 636   8891975 FALSE        NA     69.85900        NA
## 637   8891975 FALSE        NA     71.19233        NA
## 638   8891975 FALSE        NA     72.05476        NA
## 639   8891975 FALSE        NA     73.25667        NA
## 640   8891975 FALSE        NA     74.57358        NA
## 641   9032080 FALSE  80.85695     78.99795 29.000000
## 642   9061779 FALSE        NA     89.95209 26.000000
## 643   9061779 FALSE        NA     91.08556 28.000000
## 644   9061779 FALSE        NA     92.03833 28.000000
## 645   9108223  TRUE        NA     73.99589 30.000000
## 646   9108223  TRUE        NA     74.88569 30.000000
## 647   9108223  TRUE        NA     75.45517 30.000000
## 648   9108223  TRUE        NA     76.41889 30.000000
## 649   9108223  TRUE        NA     77.47296 29.000000
## 650   9248090 FALSE        NA     90.08350 26.000000
## 651   9351224  TRUE        NA     84.38330 18.000000
## 652   9351224  TRUE        NA     85.28405 19.000000
## 653   9351224  TRUE        NA     86.24504 14.000000
## 654   9391376 FALSE  84.41615     82.43395 28.000000
## 655   9391376 FALSE  84.41615     83.42231 27.600000
## 656   9391790  TRUE  84.21355     81.63723 25.000000
## 657   9391790  TRUE  84.21355     83.10472 23.000000
## 658   9508427  TRUE        NA     81.08966 29.000000
## 659   9508427  TRUE        NA     82.12457 28.000000
## 660   9508427  TRUE        NA     83.11020 28.000000
## 661   9508427  TRUE        NA     84.10678 30.000000
## 662   9508427  TRUE        NA     85.12252 29.000000
## 663   9508427  TRUE        NA     86.13279 28.000000
## 664   9508427  TRUE        NA     87.11020 27.000000
## 665   9508427  TRUE        NA     88.09309 27.000000
## 666   9508427  TRUE        NA     89.11978 25.000000
## 667   9508427  TRUE        NA     90.13552 24.000000
## 668   9536237 FALSE  74.20945     71.35661 26.000000
## 669   9536237 FALSE  74.20945     72.17522 29.000000
## 670   9650662 FALSE 106.49966    100.47091 25.862069
## 671   9650662 FALSE 106.49966    101.54141 28.928571
## 672   9650662 FALSE 106.49966    102.46407 25.555556
## 673   9650662 FALSE 106.49966    104.49281  2.000000
## 674   9650662 FALSE 106.49966    106.45038  0.000000
## 675   9841821  TRUE  82.85558     78.91034 23.000000
## 676   9841821  TRUE  82.85558     79.92334 16.000000
## 677   9841821  TRUE  82.85558     80.92266  1.000000
## 678   9841821  TRUE  82.85558     81.94114  0.000000
## 679   9892462 FALSE        NA     72.71184 29.000000
## 680   9892462 FALSE        NA     73.93292 29.000000
## 681   9892462 FALSE        NA     75.08282 28.000000
## 682   9892462 FALSE        NA     75.73443 30.000000
## 683   9896826 FALSE        NA     67.89596 30.000000
## 684   9896826 FALSE        NA     69.00205 30.000000
## 685   9896826 FALSE        NA     69.97673 30.000000
## 686   9896826 FALSE        NA     71.07461 30.000000
## 687   9896826 FALSE        NA     73.12526 29.000000
## 688   9896826 FALSE        NA     74.25051 30.000000
## 689   9896826 FALSE        NA     75.36756 29.000000
## 690   9896826 FALSE        NA     76.76112 30.000000
## 691   9986931 FALSE        NA     75.72348 26.000000
## 692   9986931 FALSE        NA     76.81040 28.000000
## 693   9986931 FALSE        NA     77.82888 27.000000
## 694   9986931 FALSE        NA     78.79535 27.000000
## 695   9986931 FALSE        NA     79.80561 30.000000
## 696   9986931 FALSE        NA     80.86242 28.000000
## 697   9986931 FALSE        NA     81.88912 29.000000
## 698   9986931 FALSE        NA     83.10746 28.000000
## 699   9986931 FALSE        NA     83.77276 27.000000
## 700   9986931 FALSE        NA     84.76934 28.000000
## 701   9986931 FALSE        NA     85.74949 27.000000
## 702  10002167 FALSE        NA     90.22587 28.000000
## 703  10002167 FALSE        NA     91.22245 28.000000
## 704  10029352 FALSE        NA     77.85079 28.000000
## 705  10042633 FALSE        NA     70.60917 30.000000
## 706  10042633 FALSE        NA     71.64956 30.000000
## 707  10042633 FALSE        NA     73.79055 28.000000
## 708  10042633 FALSE        NA     74.55989 28.000000
## 709  10042633 FALSE        NA     75.57290 30.000000
## 710  10042633 FALSE        NA     76.60780 29.000000
## 711  10042633 FALSE        NA     77.62902 22.000000
## 712  10042633 FALSE        NA     78.62560 28.000000
## 713  10093562  TRUE        NA     80.12047 29.000000
## 714  10093562  TRUE        NA     81.15537 27.000000
## 715  10093562  TRUE        NA     82.13826 29.000000
## 716  10093562  TRUE        NA     83.29911 30.000000
## 717  10093562  TRUE        NA     84.08761 29.000000
## 718  10093562  TRUE        NA     85.10335 30.000000
## 719  10093562  TRUE        NA     86.12457 27.000000
## 720  10093562  TRUE        NA     87.15127 25.000000
## 721  10093562  TRUE        NA     88.15058 29.000000
## 722  10371937 FALSE        NA     76.27652 30.000000
## 723  10371937 FALSE        NA     77.45927 27.000000
## 724  10371937 FALSE        NA     78.22587 27.000000
## 725  10665684 FALSE        NA     74.22861 30.000000
## 726  10665684 FALSE        NA     75.20329 30.000000
## 727  10665684 FALSE        NA     76.25188 30.000000
## 728  10665684 FALSE        NA     77.23203 28.000000
## 729  10788554 FALSE        NA     59.52909 30.000000
## 730  10788554 FALSE        NA     60.72827 29.000000
## 731  10788554 FALSE        NA     61.86721 23.000000
## 732  10989297 FALSE        NA     77.21287 29.000000
## 733  10989297 FALSE        NA     79.22519 26.000000
## 734  11291338  TRUE        NA     85.74401 26.000000
## 735  11291338  TRUE        NA     86.87201 26.000000
## 736  11291338  TRUE        NA     87.86311 28.000000
## 737  12317427 FALSE        NA     66.49144 30.000000
## 738  12317427 FALSE        NA     67.50992 30.000000
## 739  12317427 FALSE        NA     68.54209 29.000000
## 740  12317427 FALSE        NA     69.70568 30.000000
## 741  12317427 FALSE        NA     70.54073 30.000000
## 742  12317427 FALSE        NA     71.62218 30.000000
## 743  12317427 FALSE        NA     72.85147 30.000000
## 744  12317427 FALSE        NA     73.59617 29.000000
## 745  12317427 FALSE        NA     74.51608 29.000000
## 746  12317427 FALSE        NA     75.52361 30.000000
## 747  12317427 FALSE        NA     76.53662 30.000000
## 748  12337359 FALSE        NA     78.08898 29.000000
## 749  12337359 FALSE        NA     79.23340 30.000000
## 750  12365619  TRUE  87.41958     84.03833  6.000000
## 751  12365619  TRUE  87.41958     85.01300  0.000000
## 752  12365619  TRUE  87.41958     86.12183        NA
## 753  12368518 FALSE        NA     66.94319 28.000000
## 754  12368518 FALSE        NA     68.30938 27.000000
## 755  12368518 FALSE        NA     69.03217 29.000000
## 756  12368518 FALSE        NA     69.58795 29.000000
## 757  12368518 FALSE        NA     70.80082 29.000000
## 758  12368518 FALSE        NA     72.65161 26.000000
## 759  12766954 FALSE        NA     60.34223 30.000000
## 760  12766954 FALSE        NA     61.02122 28.000000
## 761  12766954 FALSE        NA     61.97947 28.000000
## 762  12788806 FALSE        NA     84.41068 29.000000
## 763  12788806 FALSE        NA     85.49487 30.000000
## 764  12788806 FALSE        NA     86.52156 26.000000
## 765  12788806 FALSE        NA     87.50719 28.000000
## 766  12788806 FALSE        NA     88.48186 30.000000
## 767  12788806 FALSE        NA     89.54962 30.000000
## 768  12788806 FALSE        NA     90.47502 28.000000
## 769  12788806 FALSE        NA     91.42779 28.000000
## 770  12788806 FALSE        NA     92.46817 27.000000
## 771  12799845 FALSE        NA     84.17248 28.000000
## 772  12799845 FALSE        NA     85.18549 28.000000
## 773  12799845 FALSE        NA     86.18207 27.000000
## 774  12799845 FALSE        NA     87.19781 28.000000
## 775  12799845 FALSE        NA     88.19439 27.000000
## 776  12799845 FALSE        NA     89.16906 28.000000
## 777  12799845 FALSE        NA     90.19028        NA
## 778  12799845 FALSE        NA     91.18960 30.000000
## 779  12799845 FALSE        NA     92.18070 28.000000
## 780  12799845 FALSE        NA     93.18549 28.888889
## 781  12799845 FALSE        NA     95.17591 28.965517
## 782  12850397 FALSE        NA     90.91034 25.000000
## 783  12850397 FALSE        NA     91.92334 23.000000
## 784  12850397 FALSE        NA     92.93634 19.000000
## 785  12850397 FALSE        NA     93.91923 16.000000
## 786  13026999 FALSE        NA     78.68309 28.000000
## 787  13064995 FALSE        NA     71.15948 30.000000
## 788  13064995 FALSE        NA     72.11225 29.000000
## 789  13064995 FALSE        NA     73.05955 28.000000
## 790  13064995 FALSE        NA     74.09172 29.000000
## 791  13258503 FALSE        NA     78.38467 24.000000
## 792  13258503 FALSE        NA     80.18344 27.000000
## 793  13269830  TRUE        NA     82.48597 25.000000
## 794  13269830  TRUE        NA     83.53457 24.000000
## 795  13269830  TRUE        NA     84.32307 24.000000
## 796  13269830  TRUE        NA     85.68652 28.000000
## 797  13269830  TRUE        NA     86.48871 23.000000
## 798  13346850 FALSE        NA     81.27858 28.965517
## 799  13346850 FALSE        NA     81.75770 28.000000
## 800  13346850 FALSE        NA     82.74059 26.000000
## 801  13346850 FALSE        NA     83.77276 26.000000
## 802  13346850 FALSE        NA     84.73922 28.000000
## 803  13346850 FALSE        NA     85.78782 27.000000
## 804  13346850 FALSE        NA     86.72964 25.000000
## 805  13346850 FALSE        NA     87.74812 27.931034
## 806  13346850 FALSE        NA     88.72279 27.000000
## 807  13346850 FALSE        NA     89.71663 26.000000
## 808  13346850 FALSE        NA     90.73238 26.000000
## 809  13360984 FALSE        NA     67.79466 30.000000
## 810  13360984 FALSE        NA     69.18549 26.000000
## 811  13360984 FALSE        NA     71.33196 29.000000
## 812  13360984 FALSE        NA     72.10130 30.000000
## 813  13360984 FALSE        NA     74.28611 30.000000
## 814  13380780 FALSE        NA     79.58111 29.000000
## 815  13380780 FALSE        NA     80.60507 28.000000
## 816  13380780 FALSE        NA     81.59069 29.000000
## 817  13380780 FALSE        NA     82.58727 28.000000
## 818  13380780 FALSE        NA     83.60301 29.000000
## 819  13380780 FALSE        NA     84.61328 26.000000
## 820  13380780 FALSE        NA     85.59069 28.000000
## 821  13380780 FALSE        NA     86.59274 29.000000
## 822  13380780 FALSE        NA     87.60027 28.000000
## 823  13380780 FALSE        NA     88.61602 29.000000
## 824  13419518 FALSE        NA     85.40999 26.000000
## 825  13419518 FALSE        NA     86.47775 28.000000
## 826  13419518 FALSE        NA     87.42231 30.000000
## 827  13419518 FALSE        NA     88.42163 28.000000
## 828  13419518 FALSE        NA     89.45106 26.000000
## 829  13419518 FALSE        NA     90.40383 29.000000
## 830  13419518 FALSE        NA     91.42505 29.000000
## 831  13419518 FALSE        NA     92.40246 28.000000
## 832  13419518 FALSE        NA     93.41821 29.000000
## 833  13419518 FALSE        NA     94.39562 30.000000
## 834  13419518 FALSE        NA     95.39493 28.000000
## 835  13419518 FALSE        NA     96.40246 28.000000
## 836  13432899 FALSE        NA     86.93498 28.000000
## 837  13432899 FALSE        NA     87.91239 28.000000
## 838  13432899 FALSE        NA     88.94456 29.000000
## 839  13447030 FALSE        NA     65.95756 30.000000
## 840  13447030 FALSE        NA     66.97057 29.000000
## 841  13447030 FALSE        NA     67.95346 30.000000
## 842  13447030 FALSE        NA     69.06229 30.000000
## 843  13447030 FALSE        NA     69.94661 30.000000
## 844  13447030 FALSE        NA     71.01437 29.000000
## 845  13447030 FALSE        NA     72.18344 30.000000
## 846  13447030 FALSE        NA     73.26489 30.000000
## 847  13447030 FALSE        NA     74.00684 30.000000
## 848  13462593  TRUE  87.71800     85.44559 25.000000
## 849  13462593  TRUE  87.71800     86.43121 28.000000
## 850  13462593  TRUE  87.71800     87.47981 27.000000
## 851  13464351 FALSE  88.48460     83.15400 29.000000
## 852  13464351 FALSE  88.48460     84.17248 29.000000
## 853  13464351 FALSE  88.48460     85.16085 29.000000
## 854  13464351 FALSE  88.48460     86.16016 28.000000
## 855  13464351 FALSE  88.48460     87.16222 24.000000
## 856  13464351 FALSE  88.48460     88.15332 27.000000
## 857  13485298 FALSE  89.70568     80.69268 21.000000
## 858  13485298 FALSE  89.70568     81.71389 25.000000
## 859  13485298 FALSE  89.70568     82.70500 27.000000
## 860  13485298 FALSE  89.70568     83.69884 26.000000
## 861  13485298 FALSE  89.70568     85.69747 15.000000
## 862  13485298 FALSE  89.70568     86.69405        NA
## 863  13485298 FALSE  89.70568     87.69062 23.000000
## 864  13485298 FALSE  89.70568     88.72005 26.000000
## 865  13515617 FALSE        NA     64.58590 28.000000
## 866  13633244 FALSE        NA     74.69678 29.000000
## 867  13633244 FALSE        NA     75.43053 29.000000
## 868  13633244 FALSE        NA     76.42437 29.000000
## 869  13633244 FALSE        NA     77.39904 28.000000
## 870  13633244 FALSE        NA     78.39836 28.000000
## 871  13666711 FALSE        NA     84.46270 30.000000
## 872  13666711 FALSE        NA     85.47296 27.000000
## 873  13666711 FALSE        NA     86.45038 29.000000
## 874  13666711 FALSE        NA     87.47159 29.000000
## 875  13666711 FALSE        NA     88.45175 28.000000
## 876  13666711 FALSE        NA     89.44285 29.000000
## 877  13666711 FALSE        NA     90.46407 28.000000
## 878  13666711 FALSE        NA     91.41958 28.000000
## 879  13666711 FALSE        NA     92.45448 26.000000
## 880  13666711 FALSE        NA     93.48392 30.000000
## 881  13666711 FALSE        NA     94.43121 27.000000
## 882  13743579 FALSE  84.00274     82.65298 28.000000
## 883  13747771  TRUE        NA     80.00000 28.000000
## 884  13747771  TRUE        NA     80.66804 29.000000
## 885  13747771  TRUE        NA     81.70568 29.000000
## 886  13747771  TRUE        NA     82.70226 28.000000
## 887  13747771  TRUE        NA     83.78097 29.000000
## 888  13747771  TRUE        NA     84.71184 30.000000
## 889  13747771  TRUE        NA     85.72485 29.000000
## 890  13747771  TRUE        NA     86.72964 28.000000
## 891  13747771  TRUE        NA     87.76454 30.000000
## 892  13939071 FALSE        NA     56.61054 29.000000
## 893  13939071 FALSE        NA     61.17180 29.000000
## 894  13998626 FALSE        NA     60.14237 30.000000
## 895  14030021 FALSE        NA     86.35729 28.000000
## 896  14030021 FALSE        NA     87.00890 27.000000
## 897  14030021 FALSE        NA     88.04107 26.000000
## 898  14030021 FALSE        NA     89.03765 27.000000
## 899  14030021 FALSE        NA     90.05065 26.000000
## 900  14074375 FALSE        NA     82.98700 28.000000
## 901  14074375 FALSE        NA     84.04381 30.000000
## 902  14074375 FALSE        NA     85.00753 30.000000
## 903  14074375 FALSE        NA     86.01506 26.000000
## 904  14074375 FALSE        NA     87.04997 30.000000
## 905  14074375 FALSE        NA     87.99726 29.000000
## 906  14074375 FALSE        NA     89.01027 27.000000
## 907  14074375 FALSE        NA     90.00958 27.000000
## 908  14074375 FALSE        NA     91.17864 15.000000
## 909  14074375 FALSE        NA     92.01369 11.000000
## 910  14184286 FALSE  79.68241     73.75496 30.000000
## 911  14184286 FALSE  79.68241     74.84736 28.965517
## 912  14184286 FALSE  79.68241     75.87953 28.000000
## 913  14184286 FALSE  79.68241     76.85695 28.888889
## 914  14184286 FALSE  79.68241     77.82615        NA
## 915  14184286 FALSE  79.68241     78.90760 26.666667
## 916  14393933  TRUE  86.81725     83.09103 29.000000
## 917  14393933  TRUE  86.81725     84.11225 28.000000
## 918  14393933  TRUE  86.81725     85.08966 27.000000
## 919  14397423  TRUE  95.58111     84.43806 29.000000
## 920  14397423  TRUE  95.58111     85.45380 27.000000
## 921  14397423  TRUE  95.58111     86.43395 24.000000
## 922  14397423  TRUE  95.58111     87.42505 27.000000
## 923  14397423  TRUE  95.58111     88.44353 26.000000
## 924  14397423  TRUE  95.58111     89.42368 26.000000
## 925  14397423  TRUE  95.58111     90.41752 22.000000
## 926  14397423  TRUE  95.58111     91.41136 24.000000
## 927  14397423  TRUE  95.58111     92.41342 26.000000
## 928  14397423  TRUE  95.58111     93.71389 23.000000
## 929  14397423  TRUE  95.58111     94.42574 24.000000
## 930  14397423  TRUE  95.58111     95.41958 20.400000
## 931  14452889 FALSE  93.15264     85.40999 23.000000
## 932  14452889 FALSE  93.15264     86.51061 30.000000
## 933  14452889 FALSE  93.15264     87.48528 26.000000
## 934  14452889 FALSE  93.15264     88.52293 27.000000
## 935  14452889 FALSE  93.15264     89.53867 26.000000
## 936  14452889 FALSE  93.15264     90.47502 27.000000
## 937  14452889 FALSE  93.15264     91.49076 28.000000
## 938  14452889 FALSE  93.15264     92.47639 27.000000
## 939  14458137 FALSE        NA     67.01164 29.000000
## 940  14458137 FALSE        NA     68.24914 30.000000
## 941  14458137 FALSE        NA     69.39083 24.000000
## 942  14487402 FALSE        NA     66.07255 29.000000
## 943  14487402 FALSE        NA     67.01437 30.000000
## 944  14498577 FALSE  95.53730     90.42574 26.000000
## 945  14498577 FALSE  95.53730     91.42231 29.000000
## 946  14498577 FALSE  95.53730     92.43532 29.000000
## 947  14498577 FALSE  95.53730     93.51403        NA
## 948  14498577 FALSE  95.53730     94.50513 20.000000
## 949  14498577 FALSE  95.53730     95.50719  0.000000
## 950  14536586 FALSE        NA     83.12115 28.000000
## 951  14575759 FALSE        NA     80.06845 29.000000
## 952  14575759 FALSE        NA     81.05407 25.000000
## 953  14696573 FALSE        NA     84.52293 28.000000
## 954  14696573 FALSE        NA     85.53593 28.000000
## 955  14696573 FALSE        NA     86.53251 29.000000
## 956  14696573 FALSE        NA     87.53457 29.000000
## 957  14696573 FALSE        NA     88.52567 29.000000
## 958  14696573 FALSE        NA     89.53867 30.000000
## 959  14726154  TRUE  91.31828     84.34497 26.000000
## 960  14726154  TRUE  91.31828     84.91718 26.000000
## 961  14726154  TRUE  91.31828     85.91650 27.000000
## 962  14726154  TRUE  91.31828     86.86927 30.000000
## 963  14726154  TRUE  91.31828     87.95072 26.000000
## 964  14726154  TRUE  91.31828     89.07598 28.000000
## 965  14861002 FALSE        NA     67.63039 28.000000
## 966  14861002 FALSE        NA     69.63997 29.000000
## 967  14861002 FALSE        NA     70.59822 29.000000
## 968  14861002 FALSE        NA     71.54278 28.000000
## 969  14861002 FALSE        NA     72.45722 28.000000
## 970  14861002 FALSE        NA     73.39630 29.000000
## 971  14861002 FALSE        NA     75.29363        NA
## 972  14871874 FALSE        NA     78.45585 29.000000
## 973  14871874 FALSE        NA     80.44627 29.000000
## 974  15003546 FALSE        NA     86.84736 27.000000
## 975  15003546 FALSE        NA     87.83847 30.000000
## 976  15003546 FALSE        NA     88.84326 29.000000
## 977  15218541  TRUE  81.93840     81.61807 28.000000
## 978  15269182 FALSE        NA     74.03149 30.000000
## 979  15269182 FALSE        NA     75.02806 29.000000
## 980  15286377 FALSE  90.84189     83.62218 26.000000
## 981  15286377 FALSE  90.84189     84.58590 24.000000
## 982  15286377 FALSE  90.84189     85.60986 24.000000
## 983  15286377 FALSE  90.84189     86.62560 21.000000
## 984  15286377 FALSE  90.84189     87.64956 23.000000
## 985  15286377 FALSE  90.84189     89.77960 11.000000
## 986  15302308 FALSE        NA     66.12731 28.000000
## 987  15302308 FALSE        NA     66.56537 30.000000
## 988  15302308 FALSE        NA     67.57563 30.000000
## 989  15302308 FALSE        NA     68.51745 29.000000
## 990  15302308 FALSE        NA     69.55236 30.000000
## 991  15302308 FALSE        NA     70.58453 29.000000
## 992  15302308 FALSE        NA     71.54278 29.000000
## 993  15304328 FALSE        NA     65.09514 29.000000
## 994  15304328 FALSE        NA     66.23956 30.000000
## 995  15304328 FALSE        NA     67.12115 29.000000
## 996  15304328 FALSE        NA     68.21355 30.000000
## 997  15304328 FALSE        NA     69.22929 30.000000
## 998  15304328 FALSE        NA     70.47502 30.000000
## 999  15373321 FALSE        NA     72.32854 28.000000
## 1000 15373321 FALSE        NA     73.36619 25.000000
## 1001 15373321 FALSE        NA     74.36277 30.000000
## 1002 15373321 FALSE        NA     75.34292 28.000000
## 1003 15373321 FALSE        NA     76.35318 27.000000
## 1004 15373321 FALSE        NA     77.31691 24.000000
## 1005 15373321 FALSE        NA     78.40383 23.000000
## 1006 15373321 FALSE        NA     79.32101 27.000000
## 1007 15373321 FALSE        NA     81.30322 25.000000
## 1008 15376482  TRUE        NA     78.68036 28.000000
## 1009 15387421 FALSE  92.40246     86.10541 18.000000
## 1010 15387421 FALSE  92.40246     87.05544 13.000000
## 1011 15387421 FALSE  92.40246     88.01916 14.000000
## 1012 15387421 FALSE  92.40246     91.04175  3.000000
## 1013 15387421 FALSE  92.40246     92.04107  3.000000
## 1014 15690969 FALSE  86.95962     84.08761 25.000000
## 1015 15690969 FALSE  86.95962     85.14168 29.000000
## 1016 15690969 FALSE  86.95962     86.11910 30.000000
## 1017 15938020  TRUE        NA     63.14031 28.000000
## 1018 15938020  TRUE        NA     64.13142 27.000000
## 1019 15938020  TRUE        NA     65.12799 28.000000
## 1020 15938020  TRUE        NA     66.15195 30.000000
## 1021 15938020  TRUE        NA     67.14305 29.000000
## 1022 15938020  TRUE        NA     68.13963 27.000000
## 1023 15938020  TRUE        NA     69.14168 28.000000
## 1024 15938020  TRUE        NA     70.13552 28.000000
## 1025 15938020  TRUE        NA     71.38398        NA
## 1026 15938020  TRUE        NA     72.15058 29.000000
## 1027 15938020  TRUE        NA     73.14442 28.000000
## 1028 15938020  TRUE        NA     74.14374 28.000000
## 1029 16029910 FALSE        NA     89.21561 28.000000
## 1030 16029910 FALSE        NA     90.23135 26.000000
## 1031 16029910 FALSE        NA     91.21424 29.000000
## 1032 16029910 FALSE        NA     92.24641 25.000000
## 1033 16047796  TRUE        NA     75.06913 27.000000
## 1034 16047796  TRUE        NA     76.10130 27.000000
## 1035 16047796  TRUE        NA     77.06229 28.000000
## 1036 16047796  TRUE        NA     80.04107 29.000000
## 1037 16064431 FALSE        NA     72.19165 28.000000
## 1038 16064431 FALSE        NA     73.19097 30.000000
## 1039 16068769  TRUE  92.06571     83.12663 29.000000
## 1040 16068769  TRUE  92.06571     84.08761 30.000000
## 1041 16068769  TRUE  92.06571     85.10883 30.000000
## 1042 16068769  TRUE  92.06571     86.10267 28.000000
## 1043 16068769  TRUE  92.06571     87.08556 29.000000
## 1044 16068769  TRUE  92.06571     88.10130 29.000000
## 1045 16068769  TRUE  92.06571     89.10883 28.000000
## 1046 16068769  TRUE  92.06571     90.06982 27.000000
## 1047 16068769  TRUE  92.06571     91.10746 29.000000
## 1048 16136058 FALSE        NA     84.35044 29.000000
## 1049 16136058 FALSE        NA     85.08693 28.000000
## 1050 16136058 FALSE        NA     86.09993 28.000000
## 1051 16207822 FALSE        NA     87.53183 29.000000
## 1052 16207822 FALSE        NA     88.56947 24.000000
## 1053 16207822 FALSE        NA     89.53867 27.000000
## 1054 16207822 FALSE        NA     90.69678 29.000000
## 1055 16207822 FALSE        NA     91.49897 28.000000
## 1056 16207822 FALSE        NA     92.50650 28.000000
## 1057 16207822 FALSE        NA     93.52498 28.000000
## 1058 16212351 FALSE        NA     86.42847 30.000000
## 1059 16212351 FALSE        NA     87.07461 30.000000
## 1060 16212351 FALSE        NA     88.09582 29.000000
## 1061 16212351 FALSE        NA     89.09240 29.000000
## 1062 16212351 FALSE        NA     90.08898 29.000000
## 1063 16215962 FALSE        NA     61.67009 28.000000
## 1064 16215962 FALSE        NA     62.93498 28.000000
## 1065 16215962 FALSE        NA     64.10130 26.000000
## 1066 16215962 FALSE        NA     65.06229 29.000000
## 1067 16215962 FALSE        NA     65.97947 27.000000
## 1068 16215962 FALSE        NA     66.91307 27.000000
## 1069 16215962 FALSE        NA     67.89870 28.000000
## 1070 16215962 FALSE        NA     68.93087 28.000000
## 1071 16215962 FALSE        NA     69.95209        NA
## 1072 16215962 FALSE        NA     70.93771 28.000000
## 1073 16238829  TRUE        NA     68.11499 29.000000
## 1074 16238829  TRUE        NA     68.93087 30.000000
## 1075 16238829  TRUE        NA     69.94387 28.000000
## 1076 16265624 FALSE        NA     87.82478 28.000000
## 1077 16265624 FALSE        NA     88.84052 27.000000
## 1078 16322424  TRUE        NA     79.03080 28.000000
## 1079 16322424  TRUE        NA     79.92608 27.000000
## 1080 16322424  TRUE        NA     80.88159 29.000000
## 1081 16322424  TRUE        NA     81.84257 28.000000
## 1082 16322424  TRUE        NA     82.83641 25.000000
## 1083 16322424  TRUE        NA     83.83573 25.000000
## 1084 16322424  TRUE        NA     84.86790 26.000000
## 1085 16322424  TRUE        NA     85.86448 28.000000
## 1086 16322424  TRUE        NA     86.84736 27.000000
## 1087 16322424  TRUE        NA     87.84394 26.000000
## 1088 16322424  TRUE        NA     88.84600 29.000000
## 1089 16322424  TRUE        NA     89.85626 25.000000
## 1090 16403934  TRUE        NA     73.81246 30.000000
## 1091 16403934  TRUE        NA     74.80903 29.000000
## 1092 16446147 FALSE        NA     86.61191 29.000000
## 1093 16513683 FALSE  96.70637     88.73922 30.000000
## 1094 16513683 FALSE  96.70637     89.74127 27.000000
## 1095 16513683 FALSE  96.70637     90.75154 28.928571
## 1096 16513683 FALSE  96.70637     91.74812 15.555556
## 1097 16513683 FALSE  96.70637     92.78303 21.600000
## 1098 16513683 FALSE  96.70637     93.77687 27.000000
## 1099 16513683 FALSE  96.70637     94.76249 15.600000
## 1100 16513683 FALSE  96.70637     95.77002 19.615385
## 1101 16583691  TRUE        NA     88.21629 29.000000
## 1102 16583691  TRUE        NA     89.18823 30.000000
## 1103 16583691  TRUE        NA     90.16838 28.000000
## 1104 16583691  TRUE        NA     91.18138 28.000000
## 1105 16583691  TRUE        NA     92.17522 29.000000
## 1106 16597115 FALSE        NA     88.60233 30.000000
## 1107 16597115 FALSE        NA     89.54141 30.000000
## 1108 16597115 FALSE        NA     90.60096 26.000000
## 1109 16597115 FALSE        NA     91.55373 28.000000
## 1110 16597115 FALSE        NA     92.55305 29.000000
## 1111 16597115 FALSE        NA     93.56605 27.000000
## 1112 16597115 FALSE        NA     94.56810 28.000000
## 1113 16597115 FALSE        NA     95.54552 28.000000
## 1114 16597115 FALSE        NA     96.55852 26.000000
## 1115 16621574 FALSE  89.30322     86.04791 28.000000
## 1116 16621574 FALSE  89.30322     87.02259 29.000000
## 1117 16621574 FALSE  89.30322     87.99726 28.000000
## 1118 16621574 FALSE  89.30322     88.98015        NA
## 1119 16716896  TRUE        NA     75.51814 29.000000
## 1120 16716896  TRUE        NA     76.27926 30.000000
## 1121 16716896  TRUE        NA     77.27858 29.000000
## 1122 16716896  TRUE        NA     78.28063 30.000000
## 1123 16716896  TRUE        NA     79.29363 29.000000
## 1124 16733667 FALSE        NA     87.59480 29.000000
## 1125 16733667 FALSE        NA     88.55031 25.000000
## 1126 16835690 FALSE        NA     67.04723 27.000000
## 1127 16835690 FALSE        NA     69.80972 26.000000
## 1128 16879494 FALSE        NA     84.14237 29.000000
## 1129 16879494 FALSE        NA     85.14168 30.000000
## 1130 16879494 FALSE        NA     86.15743 29.000000
## 1131 17151093  TRUE        NA     78.68309 28.000000
## 1132 17151093  TRUE        NA     79.64682 27.000000
## 1133 17151093  TRUE        NA     80.67899 26.000000
## 1134 17151093  TRUE        NA     81.66188 26.000000
## 1135 17151093  TRUE        NA     82.68036 27.000000
## 1136 17219510 FALSE  84.87611     81.88364 28.000000
## 1137 17219510 FALSE  84.87611     82.53799 26.000000
## 1138 17219510 FALSE  84.87611     83.55099 24.000000
## 1139 17233356  TRUE        NA     77.31691 29.000000
## 1140 17233356  TRUE        NA     78.34360 29.000000
## 1141 17233356  TRUE        NA     79.30732 29.000000
## 1142 17233356  TRUE        NA     80.29843 28.000000
## 1143 17233356  TRUE        NA     81.31964 27.000000
## 1144 17233356  TRUE        NA     82.27789 28.000000
## 1145 17233356  TRUE        NA     83.31280 28.000000
## 1146 17233356  TRUE        NA     84.29569 27.000000
## 1147 17233356  TRUE        NA     85.26762 28.000000
## 1148 17233356  TRUE        NA     86.30253 27.000000
## 1149 17233356  TRUE        NA     87.29637 26.000000
## 1150 17255334  TRUE        NA     65.22656 29.000000
## 1151 17255334  TRUE        NA     66.22040 27.000000
## 1152 17255334  TRUE        NA     67.21424 29.000000
## 1153 17255334  TRUE        NA     68.23272 30.000000
## 1154 17255334  TRUE        NA     69.20739 30.000000
## 1155 17255334  TRUE        NA     70.21766 29.000000
## 1156 17255334  TRUE        NA     71.23888 30.000000
## 1157 17255334  TRUE        NA     72.21355 30.000000
## 1158 17255334  TRUE        NA     73.21834 30.000000
## 1159 17255334  TRUE        NA     74.36277 29.000000
## 1160 17255334  TRUE        NA     75.37851 29.000000
## 1161 17260313 FALSE        NA     82.77071 29.000000
## 1162 17260313 FALSE        NA     83.52088 30.000000
## 1163 17260313 FALSE        NA     84.70910 28.000000
## 1164 17260313 FALSE        NA     85.83710 28.000000
## 1165 17260313 FALSE        NA     86.74333 28.000000
## 1166 17260313 FALSE        NA     87.81656 28.965517
## 1167 17260313 FALSE        NA     88.76112 26.000000
## 1168 17260313 FALSE        NA     89.82615 27.000000
## 1169 17260313 FALSE        NA     90.70500 27.000000
## 1170 17345449 FALSE  85.70568     75.81383 30.000000
## 1171 17345449 FALSE  85.70568     76.81588 29.000000
## 1172 17345449 FALSE  85.70568     77.80698 27.000000
## 1173 17345449 FALSE  85.70568     78.81999 28.000000
## 1174 17345449 FALSE  85.70568     79.81930 23.000000
## 1175 17345449 FALSE  85.70568     80.81314 26.896552
## 1176 17345449 FALSE  85.70568     81.80972 28.000000
## 1177 17345449 FALSE  85.70568     83.82478 25.000000
## 1178 17345449 FALSE  85.70568     84.82136 27.000000
## 1179 17375017 FALSE        NA     81.72485 28.000000
## 1180 17375017 FALSE        NA     82.92402 30.000000
## 1181 17375017 FALSE        NA     84.63792 29.000000
## 1182 17375017 FALSE        NA     87.46064 27.000000
## 1183 17375017 FALSE        NA     89.62628 23.000000
## 1184 17413576 FALSE        NA     76.08761 30.000000
## 1185 17413576 FALSE        NA     77.03217 28.000000
## 1186 17413576 FALSE        NA     78.04517 27.000000
## 1187 17413576 FALSE        NA     79.07734 29.000000
## 1188 17497710 FALSE        NA     87.73717 27.000000
## 1189 17497710 FALSE        NA     88.73101 27.000000
## 1190 17497710 FALSE        NA     89.72758        NA
## 1191 17615774 FALSE 101.60986     92.79945 30.000000
## 1192 17615774 FALSE 101.60986     93.77413 30.000000
## 1193 17615774 FALSE 101.60986     94.77344 28.888889
## 1194 17615774 FALSE 101.60986     95.77276 28.928571
## 1195 17615774 FALSE 101.60986     96.80219 24.000000
## 1196 17615774 FALSE 101.60986     97.74675 25.714286
## 1197 17615774 FALSE 101.60986     98.81725 26.400000
## 1198 17615774 FALSE 101.60986     99.79192 24.545455
## 1199 17615774 FALSE 101.60986    100.77755 24.827586
## 1200 17659730 FALSE  94.31075     89.04860 21.600000
## 1201 17659730 FALSE  94.31075     91.27447 25.200000
## 1202 17705889 FALSE        NA     77.07871 30.000000
## 1203 17705889 FALSE        NA     78.09172 26.000000
## 1204 17705889 FALSE        NA     79.05818 27.000000
## 1205 17705889 FALSE        NA     80.04928 26.000000
## 1206 17705889 FALSE        NA     81.07050 26.000000
## 1207 17705889 FALSE        NA     82.04517 27.000000
## 1208 17705889 FALSE        NA     83.29637 26.000000
## 1209 17705889 FALSE        NA     84.05202 28.000000
## 1210 17705889 FALSE        NA     85.03765 26.000000
## 1211 17712202 FALSE  89.01848     80.84600 30.000000
## 1212 17712202 FALSE  89.01848     81.84257 25.000000
## 1213 17712202 FALSE  89.01848     82.89938 29.000000
## 1214 17712202 FALSE  89.01848     83.89049 28.000000
## 1215 17712202 FALSE  89.01848     84.90623 30.000000
## 1216 17712202 FALSE  89.01848     85.90828 27.000000
## 1217 17712202 FALSE  89.01848     86.84189 28.000000
## 1218 17712202 FALSE  89.01848     87.87680 24.000000
## 1219 17712202 FALSE  89.01848     88.89528        NA
## 1220 17827744 FALSE        NA     80.90075 26.000000
## 1221 17929065 FALSE  91.37577     86.12457 29.000000
## 1222 17929065 FALSE  91.37577     87.10198 28.000000
## 1223 17929065 FALSE  91.37577     89.11704 27.000000
## 1224 17929065 FALSE  91.37577     90.13826 27.000000
## 1225 17974060 FALSE        NA     83.79740 28.000000
## 1226 17974060 FALSE        NA     84.75017 29.000000
## 1227 17974060 FALSE        NA     85.74401 29.000000
## 1228 17974060 FALSE        NA     86.78166 30.000000
## 1229 17974060 FALSE        NA     87.77550 30.000000
## 1230 17974060 FALSE        NA     88.76112 28.000000
## 1231 17974060 FALSE        NA     89.74949 30.000000
## 1232 17974060 FALSE        NA     90.76797 29.000000
## 1233 17974060 FALSE        NA     91.74812 28.000000
## 1234 17974060 FALSE        NA     92.76386 29.000000
## 1235 17974060 FALSE        NA     93.77687 28.000000
## 1236 17974060 FALSE        NA     94.75975 26.000000
## 1237 18014283 FALSE        NA     70.79808 30.000000
## 1238 18014283 FALSE        NA     71.82752 29.000000
## 1239 18112988  TRUE  71.73990     69.53867 29.000000
## 1240 18112988  TRUE  71.73990     70.40657 28.000000
## 1241 18112988  TRUE  71.73990     71.65229 22.000000
## 1242 18126826  TRUE        NA     87.98905 25.000000
## 1243 18126826  TRUE        NA     88.63244 30.000000
## 1244 18126826  TRUE        NA     89.66461 28.000000
## 1245 18126826  TRUE        NA     90.66119 28.000000
## 1246 18126826  TRUE        NA     91.66598 27.000000
## 1247 18219966  TRUE        NA     80.52293 27.000000
## 1248 18219966  TRUE        NA     81.53320 29.000000
## 1249 18293524 FALSE        NA     87.38125 28.000000
## 1250 18293524 FALSE        NA     88.37509 27.000000
## 1251 18293524 FALSE        NA     89.37714 28.000000
## 1252 18301541 FALSE        NA     80.15880 29.000000
## 1253 18301541 FALSE        NA     81.13621 29.000000
## 1254 18301541 FALSE        NA     82.14648 29.000000
## 1255 18393249 FALSE        NA     65.36893 27.000000
## 1256 18414513  TRUE  97.60164     92.21355 15.000000
## 1257 18414513  TRUE  97.60164     92.78576 17.000000
## 1258 18414513  TRUE  97.60164     93.84257 14.000000
## 1259 18414513  TRUE  97.60164     94.89938 12.000000
## 1260 18414513  TRUE  97.60164     95.87406 14.000000
## 1261 18414513  TRUE  97.60164     96.83231  4.000000
## 1262 18455382 FALSE        NA     82.67214 30.000000
## 1263 18455382 FALSE        NA     83.69062 30.000000
## 1264 18455382 FALSE        NA     84.68172 28.000000
## 1265 18455382 FALSE        NA     85.69473 27.000000
## 1266 18455382 FALSE        NA     86.70773 28.000000
## 1267 18455382 FALSE        NA     87.67420 30.000000
## 1268 18455382 FALSE        NA     88.68994 28.000000
## 1269 18455382 FALSE        NA     89.66735 26.000000
## 1270 18455382 FALSE        NA     91.06913 24.000000
## 1271 18500390 FALSE        NA     82.20945 29.000000
## 1272 18611216 FALSE        NA     69.63723 29.000000
## 1273 18611216 FALSE        NA     70.49966 29.000000
## 1274 18611216 FALSE        NA     71.49076 28.000000
## 1275 18611216 FALSE        NA     72.47365 30.000000
## 1276 18611216 FALSE        NA     74.52977 28.000000
## 1277 18611216 FALSE        NA     75.46612 29.000000
## 1278 18611216 FALSE        NA     76.45996 30.000000
## 1279 18643192 FALSE        NA     79.11020 29.000000
## 1280 18643192 FALSE        NA     80.10678 29.000000
## 1281 18643192 FALSE        NA     81.12526 29.000000
## 1282 18643192 FALSE        NA     82.17659 28.000000
## 1283 18643192 FALSE        NA     83.21424 22.000000
## 1284 18659212  TRUE  91.73169     88.29569 27.000000
## 1285 18659212  TRUE  91.73169     89.19644 28.000000
## 1286 18659212  TRUE  91.73169     90.20945 29.000000
## 1287 18659212  TRUE  91.73169     91.18960 25.000000
## 1288 18740882 FALSE        NA     69.37440 29.000000
## 1289 18740882 FALSE        NA     70.37372 29.000000
## 1290 18740882 FALSE        NA     71.36208 30.000000
## 1291 18740882 FALSE        NA     72.38330 29.000000
## 1292 18740882 FALSE        NA     73.35797 30.000000
## 1293 18740882 FALSE        NA     74.39836 30.000000
## 1294 18740882 FALSE        NA     75.37577 29.000000
## 1295 18740882 FALSE        NA     76.40246 30.000000
## 1296 18740882 FALSE        NA     77.36619 30.000000
## 1297 18740882 FALSE        NA     78.38741 30.000000
## 1298 18740882 FALSE        NA     79.39493 30.000000
## 1299 18910654 FALSE        NA     80.99110 27.000000
## 1300 18910654 FALSE        NA     81.90828 27.000000
## 1301 18920002 FALSE 102.65298     92.66530 27.000000
## 1302 18920002 FALSE 102.65298     93.72211 27.000000
## 1303 18920002 FALSE 102.65298     94.67762 26.000000
## 1304 18920002 FALSE 102.65298     95.68241 23.000000
## 1305 18920002 FALSE 102.65298     96.69541 22.000000
## 1306 18920002 FALSE 102.65298     97.65640 24.000000
## 1307 18920002 FALSE 102.65298     98.66940 27.000000
## 1308 18920002 FALSE 102.65298     99.67967 27.000000
## 1309 18920002 FALSE 102.65298    100.88706 27.000000
## 1310 18920002 FALSE 102.65298    101.64271 26.000000
## 1311 18942080 FALSE  86.23956     84.33128 29.000000
## 1312 19114228  TRUE        NA     76.43532 27.000000
## 1313 19114228  TRUE        NA     77.42642 28.000000
## 1314 19114228  TRUE        NA     79.42231 26.000000
## 1315 19114228  TRUE        NA     80.48734 28.000000
## 1316 19114228  TRUE        NA     81.47296 27.000000
## 1317 19114228  TRUE        NA     82.40931 25.000000
## 1318 19114228  TRUE        NA     83.49897 28.000000
## 1319 19114228  TRUE        NA     85.77687 24.000000
## 1320 19241874 FALSE        NA     85.41821 27.000000
## 1321 19325445 FALSE        NA     71.50171 29.000000
## 1322 19325445 FALSE        NA     72.55031 30.000000
## 1323 19325445 FALSE        NA     73.45380 30.000000
## 1324 19325445 FALSE        NA     74.45038 28.000000
## 1325 19325445 FALSE        NA     75.48528 30.000000
## 1326 19325445 FALSE        NA     76.52293 30.000000
## 1327 19325445 FALSE        NA     77.51129 26.000000
## 1328 19325445 FALSE        NA     78.47228 30.000000
## 1329 19325445 FALSE        NA     79.52635 30.000000
## 1330 19325445 FALSE        NA     80.50103 29.000000
## 1331 19325445 FALSE        NA     81.50034 30.000000
## 1332 19325445 FALSE        NA     82.51608 29.000000
## 1333 19367355  TRUE        NA     68.15058 25.000000
## 1334 19429100 FALSE        NA     80.19713 29.000000
## 1335 19429100 FALSE        NA     80.88433 30.000000
## 1336 19429100 FALSE        NA     81.92471 28.000000
## 1337 19429100 FALSE        NA     82.87748 29.000000
## 1338 19429100 FALSE        NA     83.95619 29.000000
## 1339 19429100 FALSE        NA     84.91718 26.000000
## 1340 19429100 FALSE        NA     86.15195 28.000000
## 1341 19429100 FALSE        NA     86.92950 27.000000
## 1342 19429100 FALSE        NA     87.97262 26.000000
## 1343 19429100 FALSE        NA     88.97741 26.000000
## 1344 19460005  TRUE  88.67899     87.76181 29.000000
## 1345 19606719 FALSE        NA     80.49829 27.000000
## 1346 19651714 FALSE        NA     84.02464 30.000000
## 1347 19651714 FALSE        NA     85.06502 25.000000
## 1348 19721447 FALSE        NA     82.50513 28.000000
## 1349 19721447 FALSE        NA     83.25257 30.000000
## 1350 19721447 FALSE        NA     84.32854 28.000000
## 1351 19721447 FALSE        NA     85.30595 28.965517
## 1352 19721447 FALSE        NA     86.28337 29.000000
## 1353 19721447 FALSE        NA     87.55099 28.000000
## 1354 19721447 FALSE        NA     88.29843 28.000000
## 1355 19721447 FALSE        NA     89.31417 29.000000
## 1356 19721447 FALSE        NA     90.28611 27.000000
## 1357 19785885  TRUE  93.64545     84.50103 28.000000
## 1358 19785885  TRUE  93.64545     85.50308 29.000000
## 1359 19785885  TRUE  93.64545     86.51608 24.000000
## 1360 19785885  TRUE  93.64545     87.52909 26.000000
## 1361 19785885  TRUE  93.64545     88.52019 30.000000
## 1362 19785885  TRUE  93.64545     89.48939 24.000000
## 1363 19785885  TRUE  93.64545     90.51608 29.000000
## 1364 19785885  TRUE  93.64545     91.49076 27.000000
## 1365 19785885  TRUE  93.64545     92.47365 27.000000
## 1366 19897716 FALSE        NA     66.81725 30.000000
## 1367 19897716 FALSE        NA     67.82752 28.000000
## 1368 19897716 FALSE        NA     68.80767 30.000000
## 1369 19928140 FALSE        NA     67.90691 30.000000
## 1370 19994956 FALSE  92.95277     91.20602 28.000000
## 1371 19994956 FALSE  92.95277     91.67967 23.000000
## 1372 19994956 FALSE  92.95277     92.73648 21.000000
## 1373 20046260 FALSE        NA     67.41684 29.000000
## 1374 20046260 FALSE        NA     68.66530 29.000000
## 1375 20046260 FALSE        NA     69.65914 30.000000
## 1376 20046260 FALSE        NA     70.87748 29.000000
## 1377 20046260 FALSE        NA     71.69610 29.000000
## 1378 20046260 FALSE        NA     72.65982 30.000000
## 1379 20046260 FALSE        NA     73.65092 30.000000
## 1380 20046260 FALSE        NA     74.66119 27.000000
## 1381 20046260 FALSE        NA     75.69884 28.000000
## 1382 20046260 FALSE        NA     76.69815 29.000000
## 1383 20088044  TRUE        NA     64.11499 29.000000
## 1384 20088044  TRUE        NA     64.70637 29.000000
## 1385 20088044  TRUE        NA     65.74127 28.000000
## 1386 20088044  TRUE        NA     66.81725 28.000000
## 1387 20088044  TRUE        NA     68.18070        NA
## 1388 20185734 FALSE        NA     70.49144 27.857143
## 1389 20185734 FALSE        NA     71.45517 28.000000
## 1390 20185734 FALSE        NA     72.57769 26.000000
## 1391 20185734 FALSE        NA     73.51951 28.000000
## 1392 20842880 FALSE        NA     86.98426 27.000000
## 1393 20842880 FALSE        NA     87.99452 28.000000
## 1394 20842880 FALSE        NA     89.01848 27.000000
## 1395 20842880 FALSE        NA     90.01232 26.000000
## 1396 20853379 FALSE        NA     82.16290 28.000000
## 1397 20853379 FALSE        NA     82.79261 27.000000
## 1398 20853379 FALSE        NA     83.80561 27.000000
## 1399 20860828 FALSE        NA     99.81109 26.000000
## 1400 20860828 FALSE        NA    100.84873 29.000000
## 1401 20907534 FALSE  82.40383     81.04312 25.000000
## 1402 20907534 FALSE  82.40383     82.04791 22.000000
## 1403 21305588 FALSE        NA     75.15674 29.000000
## 1404 21305588 FALSE        NA     76.17248 24.000000
## 1405 21305588 FALSE        NA     77.21013 23.000000
## 1406 21305588 FALSE        NA     78.20397 21.000000
## 1407 21305588 FALSE        NA     79.20602 16.000000
## 1408 21310305 FALSE        NA     86.94593 29.000000
## 1409 21362537  TRUE  86.19302     79.89322 26.000000
## 1410 21362537  TRUE  86.19302     80.93361 25.000000
## 1411 21362537  TRUE  86.19302     81.87543 20.000000
## 1412 21362537  TRUE  86.19302     82.89938 22.000000
## 1413 21362537  TRUE  86.19302     83.89870 20.000000
## 1414 21362537  TRUE  86.19302     84.86242  9.000000
## 1415 21362537  TRUE  86.19302     85.90007  9.000000
## 1416 21539112  TRUE        NA     80.64887 27.000000
## 1417 21539112  TRUE        NA     81.66461 30.000000
## 1418 21539112  TRUE        NA     82.65572 30.000000
## 1419 21608092 FALSE        NA     92.81040 28.000000
## 1420 21608092 FALSE        NA     93.83162 27.000000
## 1421 21608092 FALSE        NA     94.82546 28.000000
## 1422 21986205 FALSE        NA     75.32649 29.000000
## 1423 21986205 FALSE        NA     76.77207 29.000000
## 1424 22396591 FALSE        NA     76.81040 30.000000
## 1425 22396591 FALSE        NA     77.88638 30.000000
## 1426 22396591 FALSE        NA     78.77892 29.000000
## 1427 22396591 FALSE        NA     79.79740 30.000000
## 1428 22396591 FALSE        NA     80.81040 29.000000
## 1429 22396591 FALSE        NA     81.79329 28.000000
## 1430 22396591 FALSE        NA     82.79261 30.000000
## 1431 22396591 FALSE        NA     83.80561 29.000000
## 1432 22396591 FALSE        NA     84.78029 27.000000
## 1433 22396591 FALSE        NA     85.79603 30.000000
## 1434 22396591 FALSE        NA     86.79535 23.000000
## 1435 22396591 FALSE        NA     87.79466 22.000000
## 1436 22408684 FALSE        NA     71.36208 30.000000
## 1437 22408684 FALSE        NA     72.33676 29.000000
## 1438 22408684 FALSE        NA     73.26489 29.000000
## 1439 22408684 FALSE        NA     74.27242 29.000000
## 1440 22408684 FALSE        NA     75.27447 28.000000
## 1441 22408684 FALSE        NA     76.26557 29.000000
## 1442 22408684 FALSE        NA     77.28405 28.000000
## 1443 22408684 FALSE        NA     78.26420 28.000000
## 1444 22408684 FALSE        NA     79.27173 29.000000
## 1445 22408684 FALSE        NA     80.25736 28.000000
## 1446 22408684 FALSE        NA     81.25394 30.000000
## 1447 22408684 FALSE        NA     82.26968 29.000000
## 1448 22454720 FALSE        NA     74.85832 26.000000
## 1449 22454720 FALSE        NA     75.86037 26.000000
## 1450 22454720 FALSE        NA     76.77481        NA
## 1451 22454720 FALSE        NA     77.77960 28.000000
## 1452 22454720 FALSE        NA     78.79808        NA
## 1453 22454720 FALSE        NA     80.08214 22.000000
## 1454 22454720 FALSE        NA     81.13073 11.000000
## 1455 22454720 FALSE        NA     82.04517 18.000000
## 1456 22454720 FALSE        NA     82.73785 17.000000
## 1457 22454720 FALSE        NA     83.75359 14.000000
## 1458 22486606 FALSE  90.55989     81.00753 27.000000
## 1459 22486606 FALSE  90.55989     81.94387 22.000000
## 1460 22486606 FALSE  90.55989     82.94319 25.000000
## 1461 22486606 FALSE  90.55989     83.97810 26.000000
## 1462 22486606 FALSE  90.55989     84.93361 26.000000
## 1463 22486606 FALSE  90.55989     86.97057 27.000000
## 1464 22486606 FALSE  90.55989     89.05955 21.000000
## 1465 22486606 FALSE  90.55989     89.95483 22.000000
## 1466 22644848 FALSE        NA     87.77550 19.000000
## 1467 22644848 FALSE        NA     88.36687 17.000000
## 1468 22644848 FALSE        NA     89.38261 16.000000
## 1469 22644848 FALSE        NA     90.40110 14.000000
## 1470 22644848 FALSE        NA     91.43326 16.000000
## 1471 22644848 FALSE        NA     92.41068 12.000000
## 1472 22644848 FALSE        NA     93.45380 11.000000
## 1473 22644848 FALSE        NA     94.39014 14.000000
## 1474 22644848 FALSE        NA     95.40041  6.000000
## 1475 22644848 FALSE        NA     96.34223  5.000000
## 1476 22644848 FALSE        NA     97.37714  2.000000
## 1477 22644848 FALSE        NA     98.43669  1.000000
## 1478 22677865  TRUE        NA     91.78371 28.000000
## 1479 22677865  TRUE        NA     92.42710 29.000000
## 1480 22677865  TRUE        NA     93.46475 28.000000
## 1481 22677865  TRUE        NA     94.43943 25.000000
## 1482 22677865  TRUE        NA     95.44422 25.000000
## 1483 22683723 FALSE        NA     82.56537 30.000000
## 1484 22683723 FALSE        NA     83.61123 28.000000
## 1485 22776575 FALSE  89.10335     85.53867 30.000000
## 1486 22776575 FALSE  89.10335     86.44216 25.000000
## 1487 22776575 FALSE  89.10335     87.47707 27.000000
## 1488 22776575 FALSE  89.10335     88.44627 30.000000
## 1489 22789958  TRUE  99.16496     88.73922 24.000000
## 1490 22789958  TRUE  99.16496     89.72758 29.000000
## 1491 22789958  TRUE  99.16496     90.73238 28.000000
## 1492 22789958  TRUE  99.16496     91.76181 27.000000
## 1493 22789958  TRUE  99.16496     92.75565 25.000000
## 1494 22789958  TRUE  99.16496     93.75770 27.000000
## 1495 22789958  TRUE  99.16496     94.75975 26.000000
## 1496 22789958  TRUE  99.16496     95.75359 23.000000
## 1497 22789958  TRUE  99.16496     96.76112 21.000000
## 1498 22789958  TRUE  99.16496     97.76591 11.000000
## 1499 22789958  TRUE  99.16496     98.75975 13.000000
## 1500 22809217 FALSE        NA     77.67830 27.000000
## 1501 22809217 FALSE        NA     78.63655 30.000000
## 1502 22809217 FALSE        NA     79.30185 27.000000
## 1503 22809217 FALSE        NA     80.30390 28.000000
## 1504 22809217 FALSE        NA     81.30048 28.000000
## 1505 22813029  TRUE  85.61533     79.84120 30.000000
## 1506 22813029  TRUE  85.61533     80.87337 26.000000
## 1507 22813029  TRUE  85.61533     81.83436 24.000000
## 1508 22813029  TRUE  85.61533     82.86379 26.785714
## 1509 22865387  TRUE  99.67146     92.59411 24.000000
## 1510 22865387  TRUE  99.67146     93.39357 26.000000
## 1511 22865387  TRUE  99.67146     94.38741 20.000000
## 1512 22865387  TRUE  99.67146     95.42505 21.000000
## 1513 22865387  TRUE  99.67146     96.38056 20.000000
## 1514 22865387  TRUE  99.67146     97.40178 13.000000
## 1515 22865387  TRUE  99.67146     98.38193 14.000000
## 1516 22865387  TRUE  99.67146     99.38125  5.000000
## 1517 22868024  TRUE  94.70226     91.42505 27.000000
## 1518 22868024  TRUE  94.70226     92.39151 29.000000
## 1519 22868024  TRUE  94.70226     93.39630 27.000000
## 1520 22868024  TRUE  94.70226     94.43669 26.000000
## 1521 22880976 FALSE        NA     83.31280 28.000000
## 1522 22880976 FALSE        NA     84.30390 29.000000
## 1523 22903134 FALSE        NA     77.79603 28.000000
## 1524 22903134 FALSE        NA     78.99795 20.000000
## 1525 22903134 FALSE        NA     79.93703 23.000000
## 1526 22903134 FALSE        NA     81.01027 26.000000
## 1527 22903134 FALSE        NA     82.78987 10.000000
## 1528 22903134 FALSE        NA     86.13005 16.000000
## 1529 22903134 FALSE        NA     87.33196 15.000000
## 1530 23004922  TRUE  87.15674     81.94935 30.000000
## 1531 23004922  TRUE  87.15674     82.96509 30.000000
## 1532 23004922  TRUE  87.15674     83.96167 29.000000
## 1533 23004922  TRUE  87.15674     84.95551 29.000000
## 1534 23004922  TRUE  87.15674     86.95414 26.000000
## 1535 23354613 FALSE        NA     80.30116 30.000000
## 1536 23354613 FALSE        NA     81.31691 30.000000
## 1537 23601829 FALSE        NA     70.87201 30.000000
## 1538 23601829 FALSE        NA     71.93703 29.000000
## 1539 23601829 FALSE        NA     72.83504 28.000000
## 1540 23601829 FALSE        NA     73.83436 29.000000
## 1541 23601829 FALSE        NA     74.87748 29.000000
## 1542 23601829 FALSE        NA     75.84942 30.000000
## 1543 23601829 FALSE        NA     76.84600 28.000000
## 1544 23601829 FALSE        NA     77.86174 30.000000
## 1545 23601829 FALSE        NA     78.83915 28.000000
## 1546 23601829 FALSE        NA     79.85216 30.000000
## 1547 23601829 FALSE        NA     80.85695 28.000000
## 1548 23601829 FALSE        NA     81.84257 28.000000
## 1549 23634846 FALSE        NA     74.43943 28.000000
## 1550 23634846 FALSE        NA     75.43326 30.000000
## 1551 23634846 FALSE        NA     76.42437 29.000000
## 1552 23634846 FALSE        NA     77.44285 29.000000
## 1553 23634846 FALSE        NA     78.49692 28.000000
## 1554 23634846 FALSE        NA     80.41342 29.000000
## 1555 23634846 FALSE        NA     81.50582 29.000000
## 1556 23634846 FALSE        NA     83.77276 22.000000
## 1557 23690880 FALSE  95.81930     94.78713 29.000000
## 1558 23690880 FALSE  95.81930     95.75907 28.800000
## 1559 23791808 FALSE  92.11773     83.50992 29.000000
## 1560 23791808 FALSE  92.11773     84.49281 28.000000
## 1561 23791808 FALSE  92.11773     85.58248 25.000000
## 1562 23791808 FALSE  92.11773     86.52156 22.000000
## 1563 23791808 FALSE  92.11773     87.50445 19.000000
## 1564 23791808 FALSE  92.11773     88.50924  3.000000
## 1565 23791808 FALSE  92.11773     89.47570 17.000000
## 1566 23791808 FALSE  92.11773     90.48323 15.000000
## 1567 23791808 FALSE  92.11773     91.48528        NA
## 1568 23825005 FALSE        NA     76.31759 30.000000
## 1569 23825005 FALSE        NA     77.41273 28.000000
## 1570 23825005 FALSE        NA     78.40657 29.000000
## 1571 23825005 FALSE        NA     79.38125 28.000000
## 1572 23825005 FALSE        NA     80.51198 28.000000
## 1573 23825005 FALSE        NA     81.44011 30.000000
## 1574 23825005 FALSE        NA     82.33539 30.000000
## 1575 23825005 FALSE        NA     83.29363 30.000000
## 1576 23825005 FALSE        NA     84.35318 29.000000
## 1577 23825005 FALSE        NA     85.35797 29.000000
## 1578 23825005 FALSE        NA     86.34086 30.000000
## 1579 23860814 FALSE        NA     79.66872 28.000000
## 1580 23870000  TRUE  79.41410     77.95209 23.000000
## 1581 23870000  TRUE  79.41410     78.89665 13.000000
## 1582 23892088 FALSE        NA     81.13347 29.000000
## 1583 23892088 FALSE        NA     82.09172 27.000000
## 1584 23892088 FALSE        NA     83.09103 29.000000
## 1585 23892088 FALSE        NA     84.11225 28.000000
## 1586 23892088 FALSE        NA     85.12526 27.000000
## 1587 23892088 FALSE        NA     86.08077 28.000000
## 1588 23892088 FALSE        NA     87.14853 29.000000
## 1589 23892088 FALSE        NA     88.13415 27.000000
## 1590 23892088 FALSE        NA     89.11157 28.000000
## 1591 23892088 FALSE        NA     90.10815 27.000000
## 1592 23892088 FALSE        NA     91.12663 28.000000
## 1593 23892088 FALSE        NA     92.13963 25.000000
## 1594 23895699 FALSE        NA     90.99521 23.000000
## 1595 23993132 FALSE  89.42094     81.44285 27.000000
## 1596 23993132 FALSE  89.42094     82.37919 28.000000
## 1597 23993132 FALSE  89.42094     83.35661 21.000000
## 1598 23993132 FALSE  89.42094     84.35866 23.000000
## 1599 23993132 FALSE  89.42094     85.41273 23.000000
## 1600 23993132 FALSE  89.42094     86.31896 22.000000
## 1601 23993132 FALSE  89.42094     87.36756 23.000000
## 1602 23993132 FALSE  89.42094     88.30938 17.000000
## 1603 24039289  TRUE  72.14784     68.44079 26.000000
## 1604 24051131 FALSE        NA     69.83710 30.000000
## 1605 24051131 FALSE        NA     70.32170 25.000000
## 1606 24051131 FALSE        NA     71.31280 30.000000
## 1607 24051131 FALSE        NA     72.45175 29.000000
## 1608 24051131 FALSE        NA     73.31143 29.000000
## 1609 24051131 FALSE        NA     74.30527 29.000000
## 1610 24051131 FALSE        NA     75.30459 30.000000
## 1611 24051131 FALSE        NA     76.34223 29.000000
## 1612 24051131 FALSE        NA     77.27858 29.000000
## 1613 24067675 FALSE        NA     66.37919 30.000000
## 1614 24067675 FALSE        NA     67.49076 30.000000
## 1615 24067675 FALSE        NA     68.25736 30.000000
## 1616 24073245  TRUE        NA     81.09514 24.000000
## 1617 24073245  TRUE        NA     82.09172 22.000000
## 1618 24073245  TRUE        NA     83.22245 22.000000
## 1619 24073245  TRUE        NA     84.08487 19.000000
## 1620 24073245  TRUE        NA     85.04586 21.000000
## 1621 24073245  TRUE        NA     86.04517 26.000000
## 1622 24073245  TRUE        NA     87.10472 22.000000
## 1623 24073245  TRUE        NA     88.01916 16.000000
## 1624 24073245  TRUE        NA     89.08693 19.000000
## 1625 24073245  TRUE        NA     90.12457 22.000000
## 1626 24073245  TRUE        NA     91.07187 20.000000
## 1627 24097955 FALSE        NA     84.04928 28.000000
## 1628 24097955 FALSE        NA     85.06776 29.000000
## 1629 24141372 FALSE  85.25667     76.64339 29.000000
## 1630 24141372 FALSE  85.25667     77.66461 30.000000
## 1631 24141372 FALSE  85.25667     78.64203 29.000000
## 1632 24141372 FALSE  85.25667     79.67146 30.000000
## 1633 24141372 FALSE  85.25667     80.65708 29.000000
## 1634 24141372 FALSE  85.25667     81.70294 29.000000
## 1635 24141372 FALSE  85.25667     82.66667 30.000000
## 1636 24141372 FALSE  85.25667     83.68241 28.000000
## 1637 24141372 FALSE  85.25667     84.65708 29.000000
## 1638 24185338 FALSE        NA     82.86379 28.000000
## 1639 24185338 FALSE        NA     83.86311 29.000000
## 1640 24185338 FALSE        NA     84.84326 28.000000
## 1641 24185338 FALSE        NA     85.87817 28.000000
## 1642 24185338 FALSE        NA     86.83094 30.000000
## 1643 24185338 FALSE        NA     88.86790        NA
## 1644 24185338 FALSE        NA     90.43943        NA
## 1645 24185338 FALSE        NA     91.49897        NA
## 1646 24219409 FALSE  92.75838     81.80972 27.000000
## 1647 24219409 FALSE  92.75838     82.80630 30.000000
## 1648 24219409 FALSE  92.75838     83.82204 29.000000
## 1649 24219409 FALSE  92.75838     84.85695 29.000000
## 1650 24219409 FALSE  92.75838     85.82615 29.000000
## 1651 24219409 FALSE  92.75838     86.83094 29.000000
## 1652 24219409 FALSE  92.75838     87.83025 29.000000
## 1653 24219409 FALSE  92.75838     88.80493 27.000000
## 1654 24219409 FALSE  92.75838     89.81246 28.000000
## 1655 24219409 FALSE  92.75838     90.81999 28.000000
## 1656 24242426 FALSE        NA     83.01437 28.000000
## 1657 24310553 FALSE  84.75017     83.55647 28.000000
## 1658 24310553 FALSE  84.75017     84.54483 28.750000
## 1659 24414506 FALSE        NA     86.66667 24.000000
## 1660 24414506 FALSE        NA     87.65777 27.000000
## 1661 24414506 FALSE        NA     88.65708 27.000000
## 1662 24644776  TRUE        NA     77.40452 27.000000
## 1663 24644776  TRUE        NA     78.43669 29.000000
## 1664 24644776  TRUE        NA     79.09103 28.000000
## 1665 24644776  TRUE        NA     80.07666 28.000000
## 1666 24644776  TRUE        NA     81.11978 29.000000
## 1667 24644776  TRUE        NA     82.06160 28.000000
## 1668 24644776  TRUE        NA     83.09651 29.000000
## 1669 24644776  TRUE        NA     84.04654 23.000000
## 1670 24644776  TRUE        NA     85.04312 26.000000
## 1671 24644776  TRUE        NA     86.07803 28.000000
## 1672 24664996 FALSE        NA     92.95003 26.000000
## 1673 24680888  TRUE  86.16838     76.30116 22.000000
## 1674 24680888  TRUE  86.16838     77.26762 23.000000
## 1675 24680888  TRUE  86.16838     78.26420 21.000000
## 1676 24680888  TRUE  86.16838     79.26352 18.000000
## 1677 24680888  TRUE  86.16838     80.26831 20.000000
## 1678 24680888  TRUE  86.16838     81.24572 14.000000
## 1679 24680888  TRUE  86.16838     82.26694 16.000000
## 1680 24680888  TRUE  86.16838     83.28542 16.000000
## 1681 24680888  TRUE  86.16838     84.26283        NA
## 1682 24680888  TRUE  86.16838     85.28131  3.103448
## 1683 24747976 FALSE  91.85216     82.10815 29.000000
## 1684 24747976 FALSE  91.85216     83.14031 26.896552
## 1685 24747976 FALSE  91.85216     84.22177 22.000000
## 1686 24747976 FALSE  91.85216     85.08419 26.000000
## 1687 24930281 FALSE        NA     89.00205 28.000000
## 1688 24930281 FALSE        NA     90.02053 29.000000
## 1689 24930281 FALSE        NA     90.98152 27.000000
## 1690 24930281 FALSE        NA     91.98631 27.000000
## 1691 24930281 FALSE        NA     93.01027 28.000000
## 1692 24951704 FALSE        NA     67.31828 29.000000
## 1693 24951704 FALSE        NA     68.28474 27.000000
## 1694 24951704 FALSE        NA     69.20739 29.000000
## 1695 24951704 FALSE        NA     70.25051 28.000000
## 1696 24951704 FALSE        NA     71.18686 30.000000
## 1697 24951704 FALSE        NA     72.24367 29.000000
## 1698 24951704 FALSE        NA     73.19644 27.000000
## 1699 24951704 FALSE        NA     74.21492 30.000000
## 1700 24951704 FALSE        NA     75.18960 30.000000
## 1701 24951704 FALSE        NA     76.21081 30.000000
## 1702 24951704 FALSE        NA     77.19918 30.000000
## 1703 24969970  TRUE        NA     90.48323 26.000000
## 1704 24969970  TRUE        NA     91.48255 25.000000
## 1705 25248418 FALSE        NA     86.52156 28.000000
## 1706 25248418 FALSE        NA     87.50171 21.000000
## 1707 25248418 FALSE        NA     88.53388 25.000000
## 1708 25254826 FALSE  85.61259     85.31691 28.000000
## 1709 25300551  TRUE  88.95003     87.00616 25.000000
## 1710 25300551  TRUE  88.95003     87.94251 27.000000
## 1711 25423683 FALSE  86.37098     84.22724 30.000000
## 1712 25423683 FALSE  86.37098     85.23477 26.000000
## 1713 25423683 FALSE  86.37098     86.31896  0.000000
## 1714 25455983 FALSE        NA     80.35592 29.000000
## 1715 25455983 FALSE        NA     82.28063 30.000000
## 1716 25455983 FALSE        NA     83.24709 30.000000
## 1717 25455983 FALSE        NA     84.24367 28.000000
## 1718 25464740 FALSE        NA     82.69405 29.000000
## 1719 25580771 FALSE  91.61944     86.57358 29.000000
## 1720 25580771 FALSE  91.61944     87.43326 28.000000
## 1721 25580771 FALSE  91.61944     88.41342 29.000000
## 1722 25580771 FALSE  91.61944     89.45106 28.000000
## 1723 25580771 FALSE  91.61944     90.42026 27.000000
## 1724 25580771 FALSE  91.61944     91.42779 21.000000
## 1725 25670598 FALSE        NA     85.36619 29.000000
## 1726 25670598 FALSE        NA     86.36277 29.000000
## 1727 25670598 FALSE        NA     87.42779 28.000000
## 1728 25670598 FALSE        NA     88.40246 30.000000
## 1729 25670598 FALSE        NA     89.36619 28.000000
## 1730 25681825  TRUE        NA     84.55031 28.000000
## 1731 25681825  TRUE        NA     85.56057 28.000000
## 1732 25681825  TRUE        NA     86.55989 27.000000
## 1733 25779758  TRUE  84.89528     84.01369  9.000000
## 1734 25837301  TRUE  82.19028     76.57769 29.000000
## 1735 25837301  TRUE  82.19028     77.59890 28.000000
## 1736 25837301  TRUE  82.19028     78.60643 25.000000
## 1737 25837301  TRUE  82.19028     79.60849 25.000000
## 1738 25837301  TRUE  82.19028     80.56400 26.000000
## 1739 25837301  TRUE  82.19028     81.57974 28.000000
## 1740 25939172 FALSE  87.54825     79.80835 28.000000
## 1741 25939172 FALSE  87.54825     81.10883        NA
## 1742 25939172 FALSE  87.54825     82.38741 25.000000
## 1743 25939172 FALSE  87.54825     82.87474 27.000000
## 1744 25939172 FALSE  87.54825     84.94456 26.000000
## 1745 25939172 FALSE  87.54825     85.85900 16.000000
## 1746 25939172 FALSE  87.54825     86.81725 14.000000
## 1747 25974431 FALSE        NA     73.60438 29.000000
## 1748 25974431 FALSE        NA     74.51335 27.000000
## 1749 25974431 FALSE        NA     75.37029 30.000000
## 1750 25974431 FALSE        NA     76.36961 29.000000
## 1751 25974431 FALSE        NA     77.36345 30.000000
## 1752 25974431 FALSE        NA     78.55715 29.000000
## 1753 25974431 FALSE        NA     79.38398 29.000000
## 1754 25974431 FALSE        NA     80.38056 29.000000
## 1755 25974431 FALSE        NA     81.51951 30.000000
## 1756 26011331 FALSE  95.96167     91.18412 21.000000
## 1757 26011331 FALSE  95.96167     93.18275 25.000000
## 1758 26011331 FALSE  95.96167     94.17659 22.000000
## 1759 26011331 FALSE  95.96167     95.20602 23.000000
## 1760 26084536 FALSE        NA     59.95346 30.000000
## 1761 26084536 FALSE        NA     60.95551 29.000000
## 1762 26084536 FALSE        NA     61.99589 29.000000
## 1763 26084536 FALSE        NA     63.01985 29.000000
## 1764 26084536 FALSE        NA     64.01643 30.000000
## 1765 26277427  TRUE  93.55784     84.86790 30.000000
## 1766 26277427  TRUE  93.55784     85.82341 29.000000
## 1767 26277427  TRUE  93.55784     86.81999 25.000000
## 1768 26277427  TRUE  93.55784     87.79740 29.000000
## 1769 26277427  TRUE  93.55784     88.79124 25.000000
## 1770 26277427  TRUE  93.55784     89.83162 25.000000
## 1771 26277427  TRUE  93.55784     90.80903 28.000000
## 1772 26277427  TRUE  93.55784     91.78645 26.000000
## 1773 26277427  TRUE  93.55784     92.78029 26.000000
## 1774 26330313  TRUE        NA     84.55852 26.000000
## 1775 26330313  TRUE        NA     85.29500 25.000000
## 1776 26330313  TRUE        NA     86.30801 25.000000
## 1777 26334777 FALSE        NA     70.54073 29.000000
## 1778 26334777 FALSE        NA     71.15948 28.000000
## 1779 26334777 FALSE        NA     72.15880 28.000000
## 1780 26334777 FALSE        NA     73.13073 29.000000
## 1781 26334803 FALSE        NA     77.32512 27.000000
## 1782 26334803 FALSE        NA     78.42574 22.000000
## 1783 26334803 FALSE        NA     80.01916 23.000000
## 1784 26468686 FALSE        NA     71.33196 27.000000
## 1785 26468686 FALSE        NA     72.77481 27.000000
## 1786 26468686 FALSE        NA     73.66188 29.000000
## 1787 26468686 FALSE        NA     74.76523 28.000000
## 1788 26468686 FALSE        NA     75.93977 26.000000
## 1789 26468686 FALSE        NA     76.66804 27.000000
## 1790 26468686 FALSE        NA     77.79329 27.000000
## 1791 26468686 FALSE        NA     79.25257 29.000000
## 1792 26468686 FALSE        NA     80.38056 27.000000
## 1793 26468686 FALSE        NA     81.40178 28.000000
## 1794 26468686 FALSE        NA     82.72142 30.000000
## 1795 26498416 FALSE  86.16838     82.45038 30.000000
## 1796 26498416 FALSE  86.16838     82.93498 29.000000
## 1797 26498416 FALSE  86.16838     83.92334 28.000000
## 1798 26498416 FALSE  86.16838     84.94730 29.000000
## 1799 26498416 FALSE  86.16838     85.91650 30.000000
## 1800 26516467 FALSE        NA     83.50445 26.000000
## 1801 26516467 FALSE        NA     84.48186 29.000000
## 1802 26516467 FALSE        NA     85.48392 28.000000
## 1803 26516467 FALSE        NA     86.51335 28.000000
## 1804 26516467 FALSE        NA     87.49350 25.000000
## 1805 26569730 FALSE  79.40862     74.42300 26.000000
## 1806 26569730 FALSE  79.40862     75.41684 28.000000
## 1807 26569730 FALSE  79.40862     76.61602 28.000000
## 1808 26569730 FALSE  79.40862     77.55510 28.000000
## 1809 26581268  TRUE        NA     68.10404 28.000000
## 1810 26581268  TRUE        NA     69.10883 30.000000
## 1811 26581268  TRUE        NA     70.08898 30.000000
## 1812 26581268  TRUE        NA     71.08830 30.000000
## 1813 26631069 FALSE  89.37440     85.04038 23.000000
## 1814 26631069 FALSE  89.37440     85.86174 17.000000
## 1815 26631069 FALSE  89.37440     86.89391 12.000000
## 1816 26631069 FALSE  89.37440     87.89322  9.000000
## 1817 26631069 FALSE  89.37440     88.89528  7.000000
## 1818 26637867 FALSE  91.24435     80.51198 27.000000
## 1819 26637867 FALSE  91.24435     81.51129 27.000000
## 1820 26637867 FALSE  91.24435     82.51882 27.000000
## 1821 26637867 FALSE  91.24435     83.52361 27.000000
## 1822 26637867 FALSE  91.24435     84.50376 25.000000
## 1823 26637867 FALSE  91.24435     85.51129 28.000000
## 1824 26637867 FALSE  91.24435     86.52704 29.000000
## 1825 26637867 FALSE  91.24435     87.50992 29.000000
## 1826 26637867 FALSE  91.24435     88.52567 26.000000
## 1827 26637867 FALSE  91.24435     89.67556 25.000000
## 1828 26637867 FALSE  91.24435     90.68309 25.000000
## 1829 26671823 FALSE        NA     93.27584 24.000000
## 1830 26722927 FALSE        NA     59.46612 30.000000
## 1831 26722927 FALSE        NA     63.63860 30.000000
## 1832 26722927 FALSE        NA     65.08966 30.000000
## 1833 26795384  TRUE        NA     71.14853 30.000000
## 1834 26795384  TRUE        NA     72.08487 28.846154
## 1835 26795384  TRUE        NA     73.01300 27.600000
## 1836 26795384  TRUE        NA     74.04244 28.800000
## 1837 26795384  TRUE        NA     75.03628 26.400000
## 1838 26795384  TRUE        NA     76.25462 26.400000
## 1839 26795384  TRUE        NA     77.07598 27.857143
## 1840 26801129 FALSE        NA     73.85626 27.000000
## 1841 26801129 FALSE        NA     74.91581 29.000000
## 1842 26801129 FALSE        NA     75.89049 26.000000
## 1843 26801129 FALSE        NA     76.94456 30.000000
## 1844 26801129 FALSE        NA     77.88912 28.000000
## 1845 26801129 FALSE        NA     78.96235 30.000000
## 1846 26801129 FALSE        NA     79.97810 27.000000
## 1847 26801129 FALSE        NA     80.89802 30.000000
## 1848 26801129 FALSE        NA     81.95209 28.000000
## 1849 26929170 FALSE        NA     85.95209 30.000000
## 1850 26929170 FALSE        NA     86.91034 27.000000
## 1851 26929170 FALSE        NA     87.90965 25.000000
## 1852 26938063 FALSE        NA     75.29911 28.000000
## 1853 26938063 FALSE        NA     76.22177 30.000000
## 1854 26938063 FALSE        NA     77.16359 28.000000
## 1855 26938063 FALSE        NA     78.31348 27.000000
## 1856 26938063 FALSE        NA     79.13484 30.000000
## 1857 26938063 FALSE        NA     80.11773 29.000000
## 1858 26938063 FALSE        NA     81.14442 29.000000
## 1859 26938063 FALSE        NA     82.16564 30.000000
## 1860 26938063 FALSE        NA     83.21424 30.000000
## 1861 26975216  TRUE        NA     81.75496 30.000000
## 1862 26975216  TRUE        NA     82.75702 29.000000
## 1863 26975216  TRUE        NA     83.44148 29.000000
## 1864 26975216  TRUE        NA     84.44079 28.000000
## 1865 26975216  TRUE        NA     85.45654 28.000000
## 1866 26992537 FALSE  89.69199     88.35044 27.000000
## 1867 26992537 FALSE  89.69199     89.35797 21.000000
## 1868 27054288 FALSE        NA     65.38261 29.000000
## 1869 27054288 FALSE        NA     66.28063 29.000000
## 1870 27054288 FALSE        NA     67.34018 29.000000
## 1871 27054288 FALSE        NA     68.31759 30.000000
## 1872 27054288 FALSE        NA     69.27858 28.000000
## 1873 27054288 FALSE        NA     70.31348 29.000000
## 1874 27054288 FALSE        NA     71.28542 29.000000
## 1875 27054288 FALSE        NA     72.26557 29.000000
## 1876 27054288 FALSE        NA     73.27858 30.000000
## 1877 27054288 FALSE        NA     74.29706 29.000000
## 1878 27054288 FALSE        NA     75.26626 29.000000
## 1879 27054288 FALSE        NA     76.27379 29.000000
## 1880 27083391  TRUE        NA     72.13142 26.000000
## 1881 27083391  TRUE        NA     72.88980 28.000000
## 1882 27083391  TRUE        NA     73.91650 28.000000
## 1883 27083391  TRUE        NA     74.92402 26.000000
## 1884 27083391  TRUE        NA     75.92060 28.000000
## 1885 27083391  TRUE        NA     77.05955 28.000000
## 1886 27083391  TRUE        NA     77.91923 29.000000
## 1887 27083391  TRUE        NA     78.89391 27.000000
## 1888 27083391  TRUE        NA     79.90418 29.000000
## 1889 27242962  TRUE        NA     78.58179 30.000000
## 1890 27242962  TRUE        NA     79.61944 28.000000
## 1891 27242962  TRUE        NA     80.76386 28.000000
## 1892 27242962  TRUE        NA     81.74675 30.000000
## 1893 27242962  TRUE        NA     82.56810 29.000000
## 1894 27242962  TRUE        NA     83.54825 29.000000
## 1895 27242962  TRUE        NA     84.59411 29.000000
## 1896 27242962  TRUE        NA     85.61533 27.000000
## 1897 27242962  TRUE        NA     86.63107 29.000000
## 1898 27313862 FALSE  97.20739     93.32786 29.000000
## 1899 27313862 FALSE  97.20739     94.07255 29.000000
## 1900 27313862 FALSE  97.20739     95.26899 29.000000
## 1901 27313862 FALSE  97.20739     96.37509 28.000000
## 1902 27463113 FALSE        NA     79.40862 30.000000
## 1903 27481601 FALSE  88.44627     81.24298 26.000000
## 1904 27481601 FALSE  88.44627     82.24504 23.000000
## 1905 27481601 FALSE  88.44627     83.25804 20.000000
## 1906 27481601 FALSE  88.44627     84.27379 14.000000
## 1907 27481601 FALSE  88.44627     85.25120 15.000000
## 1908 27481601 FALSE  88.44627     86.26420  7.000000
## 1909 27481601 FALSE  88.44627     87.27447  3.000000
## 1910 27481601 FALSE  88.44627     88.24093  0.000000
## 1911 27509940 FALSE        NA     85.35524 17.000000
## 1912 27509940 FALSE        NA     85.99042 16.000000
## 1913 27560777 FALSE  88.83504     86.69952 28.000000
## 1914 27586957 FALSE        NA     82.87201 29.000000
## 1915 27586957 FALSE        NA     83.89049 28.000000
## 1916 27745104  TRUE        NA     64.01095 30.000000
## 1917 27745104  TRUE        NA     64.92813 29.000000
## 1918 27865599 FALSE        NA     71.71253 28.000000
## 1919 27865599 FALSE        NA     72.68994 30.000000
## 1920 27865599 FALSE        NA     73.61533 30.000000
## 1921 27865599 FALSE        NA     74.65024 30.000000
## 1922 27865599 FALSE        NA     75.60849 29.000000
## 1923 27865599 FALSE        NA     76.64339 30.000000
## 1924 27865599 FALSE        NA     77.59617 30.000000
## 1925 27865599 FALSE        NA     78.60096 30.000000
## 1926 27865599 FALSE        NA     79.59480 28.000000
## 1927 27865599 FALSE        NA     80.61054 28.000000
## 1928 27865599 FALSE        NA     81.65914 28.000000
## 1929 27908391 FALSE        NA     83.79466 30.000000
## 1930 27908391 FALSE        NA     84.78850 29.000000
## 1931 27908391 FALSE        NA     85.80424 29.000000
## 1932 27908391 FALSE        NA     86.78987 29.000000
## 1933 27908391 FALSE        NA     87.82478 30.000000
## 1934 27908391 FALSE        NA     88.77755 28.000000
## 1935 27908391 FALSE        NA     89.81520 29.000000
## 1936 27908391 FALSE        NA     90.78439 29.000000
## 1937 27908391 FALSE        NA     91.76181 29.000000
## 1938 27908391 FALSE        NA     92.77755 28.000000
## 1939 28013603 FALSE        NA     74.16290 30.000000
## 1940 28013603 FALSE        NA     75.29090 26.000000
## 1941 28044600 FALSE        NA     76.54209 23.000000
## 1942 28044600 FALSE        NA     77.41547 22.000000
## 1943 28044600 FALSE        NA     79.35387 20.000000
## 1944 28044600 FALSE        NA     80.55852 19.000000
## 1945 28044600 FALSE        NA     81.81246 16.000000
## 1946 28044600 FALSE        NA     82.53251 14.000000
## 1947 28127842 FALSE        NA     80.39699  1.000000
## 1948 28314511  TRUE        NA     86.22861 30.000000
## 1949 28314511  TRUE        NA     87.18686 30.000000
## 1950 28314511  TRUE        NA     88.21903 29.000000
## 1951 28314511  TRUE        NA     89.23751 29.000000
## 1952 28314511  TRUE        NA     90.25051 29.000000
## 1953 28314511  TRUE        NA     91.22793 30.000000
## 1954 28314511  TRUE        NA     92.26283 29.000000
## 1955 28314511  TRUE        NA     93.21561 30.000000
## 1956 28314511  TRUE        NA     94.21766 30.000000
## 1957 28314511  TRUE        NA     95.17317 27.000000
## 1958 28314511  TRUE        NA     96.20534 27.000000
## 1959 28314511  TRUE        NA     97.23203 30.000000
## 1960 28363718  TRUE  79.20055     78.85558  9.000000
## 1961 28388569 FALSE  83.27721     78.69952 26.000000
## 1962 28388569 FALSE  83.27721     80.40246 27.000000
## 1963 28388569 FALSE  83.27721     81.11157 27.000000
## 1964 28517012 FALSE        NA     68.30664 30.000000
## 1965 28517012 FALSE        NA     69.19918 30.000000
## 1966 28517012 FALSE        NA     70.22040 29.000000
## 1967 28517012 FALSE        NA     71.24983 29.000000
## 1968 28517012 FALSE        NA     72.46270 30.000000
## 1969 28628802 FALSE        NA     64.83231 30.000000
## 1970 28628802 FALSE        NA     65.81246 30.000000
## 1971 28628802 FALSE        NA     66.82272 30.000000
## 1972 28628802 FALSE        NA     68.11225 30.000000
## 1973 28628802 FALSE        NA     68.84052 30.000000
## 1974 28628802 FALSE        NA     69.84805 30.000000
## 1975 28628802 FALSE        NA     70.94593 30.000000
## 1976 28628802 FALSE        NA     71.79192 30.000000
## 1977 28628802 FALSE        NA     72.79124 30.000000
## 1978 28628802 FALSE        NA     73.83984 30.000000
## 1979 28628802 FALSE        NA     74.85558 29.000000
## 1980 28663873 FALSE        NA     80.79124 30.000000
## 1981 28663873 FALSE        NA     81.68925 29.000000
## 1982 28663873 FALSE        NA     82.25873 30.000000
## 1983 28663873 FALSE        NA     83.22245 28.000000
## 1984 28663873 FALSE        NA     84.27652 29.000000
## 1985 28680644 FALSE        NA     88.50103 30.000000
## 1986 28680644 FALSE        NA     88.96646 29.000000
## 1987 28680644 FALSE        NA     90.06160 30.000000
## 1988 28680644 FALSE        NA     90.94593 28.000000
## 1989 28680644 FALSE        NA     91.95893 27.000000
## 1990 28875005 FALSE        NA     67.35934 30.000000
## 1991 28875005 FALSE        NA     68.35044 30.000000
## 1992 28875005 FALSE        NA     69.34702 30.000000
## 1993 28875005 FALSE        NA     70.38193 27.000000
## 1994 28875005 FALSE        NA     71.33744 29.000000
## 1995 28875005 FALSE        NA     72.35866 28.000000
## 1996 28875005 FALSE        NA     73.37166 29.000000
## 1997 28875005 FALSE        NA     74.35455 30.000000
## 1998 28875005 FALSE        NA     75.34292 29.000000
## 1999 28875005 FALSE        NA     76.59138 27.000000
## 2000 28875005 FALSE        NA     77.87269        NA
##  [ reached getOption("max.print") -- omitted 7708 rows ]
```

```r
# d$id <- substring(d$id,1,1)
# write.csv(d,"./data/shared/musti-state-dementia.csv")  


d <- ds_long %>% 
  dplyr::select(id, male, age_at_visit, mmse, age_death ) 
# print(d[d$id %in% c(5,11),])
str(d)
```

```
## 'data.frame':	9708 obs. of  5 variables:
##  $ id          : int  9121 9121 9121 9121 9121 33027 33027 204228 204228 204228 ...
##  $ male        : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
##  $ age_at_visit: atomic  80 81.1 81.6 82.6 83.6 ...
##   ..- attr(*, "label")= chr "Age at cycle - fractional"
##  $ mmse        : atomic  29 29 30 30 29 29 NA 27 25 28 ...
##   ..- attr(*, "label")= chr "MMSE - 2014"
##  $ age_death   : num  NA NA NA NA NA NA NA NA NA NA ...
```

```r
# x <- c(NA, 5, NA, 7)
determine_censor <- function(x, is_right_censored){
  ifelse(is_right_censored, -2,
         ifelse(is.na(x), -1, x)
  )
}
(N <- length(unique(ds_long$id)))
```

```
## [1] 1696
```

```r
(subjects <- as.numeric(unique(ds_long$id)))
```

```
##    [1]     9121    33027   204228   246264   285563   402800   482428
##    [8]   617643   668310   696418   701662   709354   807897  1172523
##   [15]  1179886  1243685  1250710  1266704  1393350  1626306  1634158
##   [22]  1674624  1738075  1797756  1809849  1841461  1878130  2108769
##   [29]  2136155  2188675  2518573  2525608  2657173  2673641  2695917
##   [36]  2817047  2899847  2904677  2950975  2959960  2967974  3052480
##   [43]  3060782  3227207  3283241  3326467  3335936  3380931  3430444
##   [50]  3700779  3713990  3806878  3889845  3902977  3971682  4127190
##   [57]  4319814  4330337  4406282  4493359  4576591  4767750  4862682
##   [64]  4879843  4886978  4941596  4947970  4968529  4981936  4984547
##   [71]  5001777  5102083  5218242  5274286  5331374  5375330  5427601
##   [78]  5498462  5522533  5537936  5577538  5632732  5689621  5779736
##   [85]  5859529  5931594  6073025  6107196  6129174  6131380  6138931
##   [92]  6152191  6272612  6625341  6702361  6764103  6769734  6804844
##   [99]  6881437  7042636  7053099  7096040  7117738  7142937  7253015
##  [106]  7265221  7287209  7311370  7570491  7761236  7803023  7883803
##  [113]  8109170  8132197  8245033  8323356  8337320  8390339  8464714
##  [120]  8481297  8536593  8558869  8604620  8637647  8682642  8891975
##  [127]  9032080  9061779  9108223  9248090  9351224  9391376  9391790
##  [134]  9508427  9536237  9650662  9841821  9892462  9896826  9986931
##  [141] 10002167 10029352 10042633 10093562 10371937 10665684 10788554
##  [148] 10989297 11291338 12317427 12337359 12365619 12368518 12766954
##  [155] 12788806 12799845 12850397 13026999 13064995 13258503 13269830
##  [162] 13346850 13360984 13380780 13419518 13432899 13447030 13462593
##  [169] 13464351 13485298 13515617 13633244 13666711 13743579 13747771
##  [176] 13939071 13998626 14030021 14074375 14184286 14393933 14397423
##  [183] 14452889 14458137 14487402 14498577 14536586 14575759 14696573
##  [190] 14726154 14861002 14871874 15003546 15218541 15269182 15286377
##  [197] 15302308 15304328 15373321 15376482 15387421 15690969 15938020
##  [204] 16029910 16047796 16064431 16068769 16136058 16207822 16212351
##  [211] 16215962 16238829 16265624 16322424 16403934 16446147 16513683
##  [218] 16583691 16597115 16621574 16716896 16733667 16835690 16879494
##  [225] 17151093 17219510 17233356 17255334 17260313 17345449 17375017
##  [232] 17413576 17497710 17615774 17659730 17705889 17712202 17827744
##  [239] 17929065 17974060 18014283 18112988 18126826 18219966 18293524
##  [246] 18301541 18393249 18414513 18455382 18500390 18611216 18643192
##  [253] 18659212 18740882 18910654 18920002 18942080 19114228 19241874
##  [260] 19325445 19367355 19429100 19460005 19606719 19651714 19721447
##  [267] 19785885 19897716 19928140 19994956 20046260 20088044 20185734
##  [274] 20842880 20853379 20860828 20907534 21305588 21310305 21362537
##  [281] 21539112 21608092 21986205 22396591 22408684 22454720 22486606
##  [288] 22644848 22677865 22683723 22776575 22789958 22809217 22813029
##  [295] 22865387 22868024 22880976 22903134 23004922 23354613 23601829
##  [302] 23634846 23690880 23791808 23825005 23860814 23870000 23892088
##  [309] 23895699 23993132 24039289 24051131 24067675 24073245 24097955
##  [316] 24141372 24185338 24219409 24242426 24310553 24414506 24644776
##  [323] 24664996 24680888 24747976 24930281 24951704 24969970 25248418
##  [330] 25254826 25300551 25423683 25455983 25464740 25580771 25670598
##  [337] 25681825 25779758 25837301 25939172 25974431 26011331 26084536
##  [344] 26277427 26330313 26334777 26334803 26468686 26498416 26516467
##  [351] 26569730 26581268 26631069 26637867 26671823 26722927 26795384
##  [358] 26801129 26929170 26938063 26975216 26992537 27054288 27083391
##  [365] 27242962 27313862 27463113 27481601 27509940 27560777 27586957
##  [372] 27745104 27865599 27908391 28013603 28044600 28127842 28314511
##  [379] 28363718 28388569 28517012 28628802 28663873 28680644 28875005
##  [386] 29026694 29067201 29182641 29197882 29244108 29278716 29306403
##  [393] 29323436 29399378 29403481 29462612 29504823 29540773 29629849
##  [400] 29806034 29821047 29843151 29933130 30257786 30261598 30282435
##  [407] 30311425 30456409 30597867 30604167 30663686 30711043 30755009
##  [414] 30819298 31037310 31095950 31143443 31156114 31272569 31291350
##  [421] 31504924 31509843 31533749 31578558 31586274 31587865 31680227
##  [428] 31701041 31726180 31728786 31756046 31813134 31824173 31914288
##  [435] 31989791 32016379 32114650 32202457 32244817 32383679 32533645
##  [442] 32689956 32705437 32816489 32863530 32959281 32971269 33006377
##  [449] 33062311 33084399 33118460 33137549 33154734 33321607 33332646
##  [456] 33400773 33411712 33423630 33477756 33501827 33635574 33646937
##  [463] 33657002 33659310 33679954 33707641 33725003 33781047 34018777
##  [470] 34070069 34070357 34108468 34135713 34185763 34204855 34287534
##  [477] 34317953 34326260 34453492 34524842 34542628 34620789 34726040
##  [484] 34748028 34766480 34777681 34781079 34853696 34962204 34999847
##  [491] 35072859 35079112 35110444 35170130 35259170 35286551 35299510
##  [498] 35458631 35463458 35521263 35558806 35592862 35705009 35847634
##  [505] 35913453 35941263 35967579 36010337 36087310 36128228 36220549
##  [512] 36267530 36379623 36379885 36487640 36492755 36642271 36654487
##  [519] 36689398 36719393 36751041 36773029 36791229 36830117 36855706
##  [526] 36951779 36953249 36978388 36997205 37030589 37065652 37125649
##  [533] 37178462 37190440 37251992 37280555 37393077 37436329 37439930
##  [540] 37452211 37470097 37527863 37529621 37617978 37712486 37750518
##  [547] 37759927 37809304 37865636 37913381 37914710 37946272 37997363
##  [554] 38056377 38090333 38113465 38131115 38292829 38606123 38618915
##  [561] 38831212 38881712 38967303 39125441 39130132 39136480 39184672
##  [568] 39226595 39236493 39250103 39282539 39304782 39316600 39393581
##  [575] 39405962 39407432 39484737 39539033 39541825 39680713 39721045
##  [582] 39800111 39809520 39898329 39989287 40071481 40385646 40401703
##  [589] 40510997 40530379 40530793 40600002 40611041 40622080 40756151
##  [596] 40871627 40880222 40983260 41228878 41265021 41285665 41296604
##  [603] 41357606 41417981 41587876 41635233 41725500 41746159 41757198
##  [610] 41773404 41828674 41915754 41948357 42023091 42063693 42174519
##  [617] 42297641 42387756 42433067 42543978 42589954 42680008 42826974
##  [624] 42949394 42988567 43074402 43119512 43169148 43191312 43211671
##  [631] 43403133 43485807 43536587 43556969 43636464 43872204 44019405
##  [638] 44041093 44299049 44472870 44655449 44671043 44749170 44751386
##  [645] 44797362 44842532 44951690 44952317 44985334 45115248 45122535
##  [652] 45212640 45223689 45352543 45450112 45481821 45514725 45566083
##  [659] 45627085 45635549 45795112 45800230 45855523 45984063 45986371
##  [666] 46000440 46105408 46110487 46178577 46189516 46226934 46229419
##  [673] 46246604 46251007 46291609 46358797 46369736 46433373 46516939
##  [680] 46547648 46561196 46808242 46814524 46909396 46910335 46957588
##  [687] 47054886 47067421 47189548 47214624 47236602 47315778 47371712
##  [694] 47520485 47619873 47652086 47705812 47955338 48013463 48023497
##  [701] 48129208 48192539 48331728 48451825 48480640 48513418 48697089
##  [708] 48748345 48778463 49007537 49070444 49094578 49297367 49333806
##  [715] 49380119 49428128 49429845 49452862 49507582 49590907 49643021
##  [722] 49676048 49766153 50100068 50100194 50100220 50100356 50100482
##  [729] 50100518 50100644 50100770 50100806 50100932 50101073 50101109
##  [736] 50101235 50101361 50101497 50101523 50101659 50101785 50101811
##  [743] 50101947 50102088 50102114 50102240 50102376 50102402 50102538
##  [750] 50102664 50102790 50102826 50102952 50103093 50103129 50103255
##  [757] 50103381 50103417 50103543 50103679 50103705 50103831 50103967
##  [764] 50104008 50104134 50104260 50104396 50104422 50104558 50104684
##  [771] 50104710 50104846 50104972 50105013 50105149 50105275 50105301
##  [778] 50105437 50105563 50105699 50105725 50105851 50105987 50106028
##  [785] 50106154 50106280 50106316 50106442 50106578 50106604 50106730
##  [792] 50106866 50106992 50107033 50107169 50107295 50107321 50107457
##  [799] 50107583 50107619 50107745 50107871 50107907 50108048 50108174
##  [806] 50108200 50108336 50108462 50108598 50108624 50108750 50108886
##  [813] 50108912 50109053 50109189 50109215 50109477 50109503 50109639
##  [820] 50109927 50111971 50112274 50112436 50197261 50197711 50199993
##  [827] 50300084 50300110 50300246 50300372 50300408 50300534 50300660
##  [834] 50300796 50300822 50300958 50301099 50301125 50301251 50301387
##  [841] 50301413 50301549 50301675 50301701 50301963 50302004 50302130
##  [848] 50302266 50302392 50302428 50302554 50302680 50302716 50302842
##  [855] 50302978 50303019 50303145 50303271 50303307 50304024 50304998
##  [862] 50305165 50400259 50400385 50400411 50400673 50400709 50400835
##  [869] 50400961 50401002 50401264 50401390 50401426 50401714 50401840
##  [876] 50401976 50402017 50402143 50402279 50402305 50402431 50402567
##  [883] 50402693 50402729 50402855 50402981 50403158 50403284 50403310
##  [890] 50403446 50403572 50403860 50403996 50404037 50404163 50404299
##  [897] 50404325 50404451 50404749 50405042 50405330 50405592 50406057
##  [904] 50406183 50406345 50406471 50406633 50406769 50407486 50407800
##  [911] 50407936 50408077 50408103 50408239 50408365 50408491 50408527
##  [918] 50408653 50408789 50408815 50408941 50409370 50409406 50409532
##  [925] 50409668 50409794 50409820 50409956 50410021 50410157 50410283
##  [932] 50410319 50410445 50500000 50500136 50500424 50500550 50501015
##  [939] 50502020 50502156 50502282 50502606 50666895 51039226 51129205
##  [946] 51164438 51400993 51442191 51515723 51520126 51599255 51622573
##  [953] 51624179 51650969 51668135 51730202 51791453 51815338 51826377
##  [960] 51864085 51903261 51938758 52018573 52052115 52064033 52173227
##  [967] 52175661 52178858 52256919 52298793 52311825 52322864 52509923
##  [974] 52731249 52764842 52781299 52940446 52957571 53192752 53200779
##  [981] 53355949 53356828 53389845 53422197 53495004 53533437 53588568
##  [988] 53641742 53682197 53727207 53772202 53791255 53825614 53965805
##  [995] 54104440 54122640 54324848 54458919 54519335 54539393 54559063
## [1002] 54571041 54572768 54661156 54739607 55025694 55061706 55177253
## [1009] 55204773 55296057 55314846 55385157 55392868 55580128 55585885
## [1016] 55603674 55772716 55820335 55861780 55897318 55932428 55943467
## [1023] 55994710 56025914 56029116 56090689 56102646 56180668 56214739
## [1030] 56263800 56266835 56416937 56486107 56629174 56670427 56696733
## [1037] 56742594 56751351 56800561 56961563 56979865 57002539 57003706
## [1044] 57293950 57311163 57434619 57442623 57597479 57833358 57835666
## [1051] 57978468 57978756 58006501 58014515 58051920 58108372 58143217
## [1058] 58171603 58199939 58203880 58306828 58326624 58331153 58458351
## [1065] 58501637 58531593 58677906 59150662 59166782 59204827 59217750
## [1072] 59306274 59320984 59449940 59497970 59598024 59618707 59671554
## [1079] 59720188 59756266 60153630 60248664 60278494 60370977 60638122
## [1086] 60655605 60725338 60747316 60848460 60871487 60909048 60922329
## [1093] 60961592 61029627 61074758 61142759 61344957 61389630 61490006
## [1100] 61548175 61579172 61595488 61640072 61709892 61827429 62176713
## [1107] 62301938 62367972 62398393 62404688 62483327 62502833 62574447
## [1114] 62651593 62720059 62985554 63144733 63188799 63227551 63290882
## [1121] 63357970 63514945 63551648 63649283 63698192 63740337 63818202
## [1128] 63821685 63861449 63874408 63986591 64145770 64150173 64216968
## [1135] 64287431 64291829 64336939 64358179 64386439 64493027 64505110
## [1142] 64635241 64831489 64925372 64997274 65001607 65017989 65082780
## [1149] 65084674 65214844 65292866 65309742 65384603 65539462 65608216
## [1156] 65652206 65685223 65692934 65736039 65778949 65838800 65856136
## [1163] 65925304 65933570 65952361 65990079 66069855 66132199 66233829
## [1170] 66394957 66406040 66447233 66451045 66754397 66787314 66800446
## [1177] 66924745 67185070 67216828 67227993 67266328 67418026 67429065
## [1184] 67510897 67531158 67628490 67632202 67725478 67831051 67872082
## [1191] 67946467 68015667 68217991 68240882 68419063 68481703 68525196
## [1198] 68539908 68611261 68725248 68745332 68778359 68813045 68914513
## [1205] 68977784 69099545 69187342 69331934 69432088 69540555 69544171
## [1212] 69577198 69660076 69866926 69920089 69924281 69982407 69982533
## [1219] 70153803 70212461 70329923 70344350 70625336 70636113 70669392
## [1226] 70696773 70726480 70816595 70883578 70917649 70939627 71063018
## [1233] 71070017 71291394 71356048 71428241 71514280 71532930 71537723
## [1240] 71558084 71592202 71626373 71648351 71727427 71806467 71932972
## [1247] 71952642 72010353 72026185 72031614 72076711 72188804 72205714
## [1254] 72207446 72276737 72324068 72343697 72347501 72419830 72448817
## [1261] 72560222 72650337 72659872 72717425 72777797 72795447 72830557
## [1268] 72841884 72918294 73033080 73146926 73177635 73369061 73549281
## [1275] 73763467 73943687 73957787 73976154 74067756 74078795 74191827
## [1282] 74203334 74284255 74494179 74552010 74587057 74635126 74708460
## [1289] 74718818 74753465 74797421 74961945 75001294 75009300 75161029
## [1296] 75169847 75175129 75262623 75359253 75495116 75507759 75647940
## [1303] 75675336 75797165 75833578 75861964 75862131 75990666 76008327
## [1310] 76137867 76280567 76431098 76621666 76733461 76755449 76867532
## [1317] 76878571 76992870 77108236 77143621 77180612 77239958 77252103
## [1324] 77273914 77330002 77333587 77366180 77631046 77689940 77716758
## [1331] 77743003 77790442 77868579 77891596 77970662 78005770 78010047
## [1338] 78072753 78123271 78195885 78267114 78331049 78353027 78410089
## [1345] 78452313 78476159 78511269 78657384 78707509 78724406 78905055
## [1352] 79087764 79155639 79411152 79412879 79455082 79462793 79501267
## [1359] 79521487 79576932 79590228 79680333 79692387 79769959 79803180
## [1366] 79938680 79953855 79978444 80161242 80187972 80204332 80333458
## [1373] 80345114 80352799 80368783 80450368 80487613 80592317 80606718
## [1380] 80790863 80915504 80930779 81086436 81185560 81274534 81354615
## [1387] 81403249 81455345 81504393 81526371 81569322 81576033 81639479
## [1394] 81783210 81795552 81810992 81852640 81874628 82003527 82138315
## [1401] 82140107 82317494 82325110 82335720 82455953 82478522 82520217
## [1408] 82527318 82617423 82624422 82643501 82647965 82684406 82728899
## [1415] 82780217 82858344 82890542 83001827 83034844 83112293 83164399
## [1422] 83173570 83216408 83351356 83419611 83721144 83902667 83944153
## [1429] 83984043 84091825 84248280 84417209 84483565 84525776 84563196
## [1436] 84642424 84653463 84732827 84858308 84896566 84916951 84945776
## [1443] 84949680 84955962 85036828 85065193 85171938 85266386 85300481
## [1450] 85328131 85395114 85508351 85509528 85527016 85578107 85584353
## [1457] 85666580 85762265 85925902 85980779 86037865 86071821 86127970
## [1464] 86177506 86274610 86295007 86408244 86420222 86471999 86600442
## [1471] 86668820 86712535 86767530 86880662 86901774 86903794 86910081
## [1478] 86934089 86937852 86947750 86956481 87038802 87179008 87195990
## [1485] 87208386 87264456 87275819 87330987 87386573 87410220 87555330
## [1492] 87585034 87604126 87645445 87702533 87779516 87821751 87942151
## [1499] 87948797 88001453 88015139 88029789 88038410 88041767 88049747
## [1506] 88106709 88488240 88499289 88558711 88703606 88799920 88837803
## [1513] 88869941 88961000 89001223 89065823 89160755 89164957 89171820
## [1520] 89377194 89437343 89445221 89512181 89515666 89546375 89613947
## [1527] 89614402 89645797 89649999 89800328 89811231 89876260 89903942
## [1534] 89929122 89968269 89975556 90021936 90076229 90100426 90133029
## [1541] 90155007 90173045 90214403 90224563 90267190 90429110 90434801
## [1548] 90439144 90447310 90496931 90536384 90544000 90544686 90559953
## [1555] 90581541 90661046 90780976 90805280 90906596 90942860 90977195
## [1562] 91018909 91189485 91199969 91214985 91280115 91347203 91349809
## [1569] 91444029 91525115 91583467 91670673 91707643 91763687 91804757
## [1576] 91875770 91897758 91921829 91949579 92023910 92039030 92068279
## [1583] 92113025 92308774 92371267 92393245 92427316 92454247 92539409
## [1590] 92602617 92613520 92629514 92693724 92928376 92959959 92996364
## [1597] 93014211 93024957 93041854 93103023 93154240 93417026 93462021
## [1604] 93493992 93504106 93667416 93770190 93787649 93815598 93966278
## [1611] 94092977 94115009 94144536 94205114 94328246 94362202 94430339
## [1618] 94463356 94549523 94630355 94722642 94734696 94803738 94828877
## [1625] 94852511 94937061 94974890 95048469 95116046 95127085 95161041
## [1632] 95185625 95252909 95281012 95329283 95330358 95373147 95439194
## [1639] 95442315 95453354 95491648 95600557 95620227 95638231 95723689
## [1646] 95845256 95868799 95902182 95914848 95919181 96016939 96091926
## [1653] 96095092 96140000 96189273 96244639 96306484 96337805 96529231
## [1660] 96612533 96741073 96892753 97006937 97130008 97161005 97220113
## [1667] 97264179 97449632 97478169 97749823 97775875 97859996 97882751
## [1674] 98096223 98186040 98273670 98322204 98388248 98430933 98506202
## [1681] 98844813 98866341 98953007 99110004 99151323 99210431 99367207
## [1688] 99526580 99592710 99693576 99718754 99746564 99750664 99809748
## [1695] 99911705 99982430
```

```r
for(i in 1:N){
  # Get the individual data:
  (dta.i <- d[d$id==subjects[i],])
  (dta.i <- as.data.frame(dta.i %>% dplyr::arrange(-age_at_visit)))
  (dta.i$missed_last_wave = (cumsum(!is.na(dta.i$mmse))==0L))
  (dta.i$presumed_alive      =  is.na(any(dta.i$age_death)))
  (dta.i$right_censored   = dta.i$missed_last_wave & dta.i$presumed_alive)
  # dta.i$mmse_recoded     = determine_censor(dta.i$mmse, dta.i$right_censored)
  (dta.i$mmse     <- determine_censor(dta.i$mmse, dta.i$right_censored))
  (dta.i <- as.data.frame(dta.i %>% dplyr::arrange(age_at_visit)))
  (dta.i <- dta.i %>% dplyr::select(-missed_last_wave, -right_censored ))
  # Rebuild the data:
  if(i==1){ds_miss <- dta.i}else{ds_miss <- rbind(ds_miss,dta.i)}
  
}
```

```
## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical
```

```r
encode_multistates <- function(
  d, # data frame in long format 
  outcome_name, # measure to compute live states
  age_name, # age at each wave
  age_death_name, # age of death
  dead_state_value # value to represent dead state
){
  # declare arguments for debugging
  # d = d,
  # outcome_name = "mmse";age_name = "age_at_visit";age_death_name = "age_death";dead_state_value = 4
  (subjects <- sort(unique(d$id))) # list subject ids
  (N <- length(subjects)) # count subject ids
  # standardize names
  colnames(d)[colnames(d)==outcome_name] <- "state"
  colnames(d)[colnames(d)==age_name] <- "age"
  for(i in 1:N){
    # Get the individual data: i = 1
    (dta.i <- d[d$id==subjects[i],])
    # Encode live states
    dta.i$state <- ifelse( 
      dta.i$state > 26, 1, ifelse( # healthy
        dta.i$state <= 26 &  dta.i$state >= 23, 2, ifelse( # mild CI
          dta.i$state < 23 & dta.i$state >= 0, 3, dta.i$state))) # mod-sever CI
    # Is there a death? If so, add a record:
    (death <- !is.na(dta.i[,age_death_name][1]))
    if(death){
      (record <- dta.i[1,])
      (record$state <- dead_state_value)
      (record$age   <- dta.i[,age_death_name][1])
      (ddta.i <- rbind(dta.i,record))
    }else{ddta.i <- dta.i}
    # Rebuild the data:
    if(i==1){dta1 <- ddta.i}else{dta1 <- rbind(dta1,ddta.i)}
  }
  dta1[,age_death_name] <- NULL
  return(dta1)
}

ds_ms <- encode_multistates(
  d = ds_miss,
  outcome_name = "mmse",
  age_name = "age_at_visit",
  age_death_name = "age_death",
  dead_state_value = 4
)
# examine transition matrix
msm::statetable.msm(state,id,ds_ms)
```

```
##     to
## from   -2   -1    1    2    3    4
##   -2   32    0    0    0    0    0
##   -1    0   25   27   13   27   50
##   1    32   59 4855  715  120  251
##   2     8   20  534  478  257  146
##   3     6   34   24   97  649  233
```

```r
knitr::kable(msm::statetable.msm(state,id,ds_ms))
```



|   | -2| -1|    1|   2|   3|   4|
|:--|--:|--:|----:|---:|---:|---:|
|-2 | 32|  0|    0|   0|   0|   0|
|-1 |  0| 25|   27|  13|  27|  50|
|1  | 32| 59| 4855| 715| 120| 251|
|2  |  8| 20|  534| 478| 257| 146|
|3  |  6| 34|   24|  97| 649| 233|

```r
# Save as a compress, binary R dataset.  It's no longer readable with a text editor, but it saves metadata (eg, factor information).

# at this point there exist two relevant data sets:
# ds_miss - missing states are encoded
# ds_ms   - multi   states are encoded
# it is useful to have access to both while understanding/verifying encodings

names(dto)
```

```
## [1] "unitData" "metaData" "ms_mmse"
```

```r
dto[["ms_mmse"]][["missing"]] <- ds_miss
dto[["ms_mmse"]][["multi"]] <- ds_ms
saveRDS(dto, file="./data/unshared/derived/dto.rds", compress="xz")
```

```r
# the production of the dto object is now complete
# we verify its structure and content:
dto <- readRDS("./data/unshared/derived/dto.rds")
names(dto)
```

```
## [1] "unitData" "metaData" "ms_mmse"
```

```r
# 1st element - unit(person) level data
dplyr::tbl_df(dto[["unitData"]])
```

```
## Source: local data frame [9,708 x 113]
## 
##        id study scaled_to.x agreeableness conscientiousness extraversion
##     (int) (chr)       (chr)         (int)             (int)        (int)
## 1    9121  MAP         MAP             NA                35           34
## 2    9121  MAP         MAP             NA                35           34
## 3    9121  MAP         MAP             NA                35           34
## 4    9121  MAP         MAP             NA                35           34
## 5    9121  MAP         MAP             NA                35           34
## 6   33027  MAP         MAP             NA                NA           30
## 7   33027  MAP         MAP             NA                NA           30
## 8  204228  MAP         MAP             NA                NA           32
## 9  204228  MAP         MAP             NA                NA           32
## 10 204228  MAP         MAP             NA                NA           32
## ..    ...   ...         ...           ...               ...          ...
## Variables not shown: neo_altruism (int), neo_conscientiousness (int),
##   neo_trust (int), openness (int), anxiety_10items (dbl), neuroticism_12
##   (int), neuroticism_6 (int), age_bl (dbl), age_death (dbl), died (int),
##   educ (int), msex (int), race (int), spanish (int), apoe_genotype (int),
##   alco_life (dbl), q3smo_bl (int), q4smo_bl (int), smoke_bl (int), smoking
##   (int), fu_year (int), scaled_to.y (chr), cesdsum (int), r_depres (int),
##   intrusion (dbl), neglifeevents (int), negsocexchange (dbl), nohelp
##   (dbl), panas (dbl), perceivedstress (dbl), rejection (dbl),
##   unsympathetic (dbl), dcfdx (int), dementia (int), r_stroke (int),
##   cogn_ep (dbl), cogn_global (dbl), cogn_po (dbl), cogn_ps (dbl), cogn_se
##   (dbl), cogn_wo (dbl), cts_bname (int), catfluency (int), cts_db (int),
##   cts_delay (int), cts_df (int), cts_doperf (int), cts_ebdr (int),
##   cts_ebmt (int), cts_idea (int), cts_lopair (int), mmse (dbl), cts_nccrtd
##   (int), cts_pmat (int), cts_read_nart (int), cts_read_wrat (int),
##   cts_sdmt (int), cts_story (int), cts_wli (int), cts_wlii (int),
##   cts_wliii (int), age_at_visit (dbl), iadlsum (int), katzsum (int),
##   rosbscl (int), rosbsum (int), vision (int), visionlog (dbl), fev (dbl),
##   mep (dbl), mip (dbl), pvc (dbl), bun (int), ca (dbl), chlstrl (int), cl
##   (int), co2 (int), crn (dbl), fasting (int), glucose (int), hba1c (dbl),
##   hdlchlstrl (int), hdlratio (dbl), k (dbl), ldlchlstrl (int), na (int),
##   alcohol_g (dbl), bmi (dbl), htm (dbl), phys5itemsum (dbl), wtkg (dbl),
##   bp11 (chr), bp2 (chr), bp3 (int), bp31 (chr), hypertension_cum (int),
##   dm_cum (int), thyroid_cum (int), chf_cum (int), claudication_cum (int),
##   heart_cum (int), stroke_cum (int), vasc_3dis_sum (dbl), vasc_4dis_sum
##   (dbl), vasc_risks_sum (dbl), gait_speed (dbl), gripavg (dbl)
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
## 43      cognitive           cogn_global       global cognition
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
## 22           TRUE        FALSE       drinks/day    TRUE
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

```r
# 3rd element - data for MMSE outcome
names(dto[["ms_mmse"]])
```

```
## [1] "missing" "multi"
```

```r
ds_miss <- dto$ms_mmse$missing
ds_ms <- dto$ms_mmse$multi
```

```r
# compare before and after ms encoding
view_id <- function(ds1,ds2,id){
  cat("Before ms encoding:","\n")
  print(ds1[ds1$id==id,])
  cat("\nAfter ms encoding","\n")
  print(ds2[ds2$id==id,])
}
# view a random person for sporadic inspections
ids <- sample(unique(ds_miss$id),1)
view_id(ds_miss, ds_ms, ids)
```

```
## Before ms encoding: 
##            id male age_at_visit mmse age_death presumed_alive
## 7004 68525196 TRUE     89.94114   25  92.96099          FALSE
## 7005 68525196 TRUE     90.93224   25  92.96099          FALSE
## 7006 68525196 TRUE     91.92882   28  92.96099          FALSE
## 
## After ms encoding 
##             id male      age state presumed_alive
## 7004  68525196 TRUE 89.94114     2          FALSE
## 7005  68525196 TRUE 90.93224     2          FALSE
## 7006  68525196 TRUE 91.92882     1          FALSE
## 70041 68525196 TRUE 92.96099     4          FALSE
```

The R session information (including the OS info, R version and all
packages used):


```r
sessionInfo()
```

```
## R version 3.2.5 (2016-04-14)
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
## [1] magrittr_1.5
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.5      knitr_1.13       splines_3.2.5    munsell_0.4.3   
##  [5] testit_0.5       lattice_0.20-33  colorspace_1.2-6 R6_2.1.2        
##  [9] highr_0.6        stringr_1.0.0    plyr_1.8.3       dplyr_0.4.3     
## [13] tools_3.2.5      parallel_3.2.5   grid_3.2.5       gtable_0.2.0    
## [17] msm_1.6.1        DBI_0.4-1        htmltools_0.3.5  survival_2.38-3 
## [21] lazyeval_0.1.10  assertthat_0.1   digest_0.6.9     Matrix_1.2-4    
## [25] ggplot2_2.1.0    formatR_1.4      rsconnect_0.4.3  evaluate_0.9    
## [29] rmarkdown_1.0    stringi_1.1.1    scales_0.4.0     expm_0.999-0    
## [33] mvtnorm_1.0-5
```

```r
Sys.time()
```

```
## [1] "2016-07-22 14:53:46 PDT"
```

