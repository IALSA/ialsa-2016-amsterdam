



This report was automatically generated with the R package **knitr**
(version 1.13).


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
```

```
## Loading required namespace: tidyr
```

```r
requireNamespace("dplyr") # f() names conflict with other packages (esp. base, stats, and plyr).
```

```
## Loading required namespace: dplyr
```

```r
requireNamespace("testit") # for asserting conditions meet expected patterns.
```

```
## Loading required namespace: testit
```

```r
# reach out to the curator for a dataset prepared for general consumption
data_path_input  <- "../MAP/data-unshared/derived/ds0.rds"
# point to the local metadata to be used for this project (specific consumption)
metadata_path_input <- "./data/shared/meta/map/meta-data-map.csv" 
```

```r
# load data objects
unitData <- readRDS(data_path_input) 
metaData <- read.csv(metadata_path_input, stringsAsFactors=F, header=T)
```

```r
# inspect loaded data objects (using basic demographic variables )
ds <- unitData # assing alias
length(unique(ds$id)) # there are this many of subjects
```

```
## [1] 1696
```

```r
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
t <- table(ds[,"msex"], ds[,"race"], useNA = "always"); t[t==0]<-".";t
```

```
##       
##        1    2   3  6  <NA>
##   0    6796 443 13 34 .   
##   1    2310 94  8  10 .   
##   <NA> .    .   .  .  .
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
dto <- list()
# the first element of data transfer object contains unit data
dto[["unitData"]] <- unitData
# the second element of data transfer object contains meta data
dto[["metaData"]] <-  metaData
# verify and glimpse
dto[["unitData"]] %>% dplyr::glimpse()
```

```
## Observations: 9,708
## Variables: 113
## $ id                    <int> 9121, 9121, 9121, 9121, 9121, 33027, 330...
## $ study                 <chr> "MAP ", "MAP ", "MAP ", "MAP ", "MAP ", ...
## $ scaled_to.x           <chr> "MAP ", "MAP ", "MAP ", "MAP ", "MAP ", ...
## $ agreeableness         <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ conscientiousness     <int> 35, 35, 35, 35, 35, NA, NA, NA, NA, NA, ...
## $ extraversion          <int> 34, 34, 34, 34, 34, 30, 30, 32, 32, 32, ...
## $ neo_altruism          <int> 27, 27, 27, 27, 27, NA, NA, NA, NA, NA, ...
## $ neo_conscientiousness <int> 35, 35, 35, 35, 35, NA, NA, NA, NA, NA, ...
## $ neo_trust             <int> 25, 25, 25, 25, 25, NA, NA, NA, NA, NA, ...
## $ openness              <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ anxiety_10items       <dbl> 0, 0, 0, 0, 0, NA, NA, 0, 0, 0, 0, 0, 0,...
## $ neuroticism_12        <int> 9, 9, 9, 9, 9, NA, NA, 16, 16, 16, 16, 1...
## $ neuroticism_6         <int> 8, 8, 8, 8, 8, 1, 1, 14, 14, 14, 14, 14,...
## $ age_bl                <dbl> 79.96988, 79.96988, 79.96988, 79.96988, ...
## $ age_death             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ died                  <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ educ                  <int> 12, 12, 12, 12, 12, 14, 14, 8, 8, 8, 8, ...
## $ msex                  <int> 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0...
## $ race                  <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
## $ spanish               <int> 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 2...
## $ apoe_genotype         <int> 34, 34, 34, 34, 34, 33, 33, 33, 33, 33, ...
## $ ldai_bl               <dbl> 0.2, 0.2, 0.2, 0.2, 0.2, 0.0, 0.0, 0.0, ...
## $ q3smo_bl              <int> 20, 20, 20, 20, 20, NA, NA, NA, NA, NA, ...
## $ q4smo_bl              <int> 31, 31, 31, 31, 31, NA, NA, NA, NA, NA, ...
## $ smoke_bl              <int> 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ smoking               <int> 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ fu_year               <int> 0, 1, 2, 3, 4, 0, 1, 0, 2, 3, 4, 5, 6, 0...
## $ scaled_to.y           <chr> "RMM", "RMM", "RMM", "RMM", "RMM", "RMM"...
## $ cesdsum               <int> 0, 0, 0, 0, 0, 1, 2, 6, 1, 3, 1, 0, 2, 1...
## $ r_depres              <int> 4, 4, 4, 4, NA, 4, 4, 3, 4, 4, 4, 4, 4, ...
## $ intrusion             <dbl> NA, NA, NA, 2.000000, NA, NA, NA, NA, NA...
## $ neglifeevents         <int> NA, NA, NA, 4, NA, NA, NA, NA, NA, NA, N...
## $ negsocexchange        <dbl> NA, NA, NA, 1.833333, NA, NA, NA, NA, NA...
## $ nohelp                <dbl> NA, NA, NA, 1.666667, NA, NA, NA, NA, NA...
## $ panas                 <dbl> NA, NA, NA, 1.1, NA, NA, NA, NA, NA, NA,...
## $ perceivedstress       <dbl> NA, NA, NA, 2.5, NA, NA, NA, NA, NA, NA,...
## $ rejection             <dbl> NA, NA, NA, 1.666667, NA, NA, NA, NA, NA...
## $ unsympathetic         <dbl> NA, NA, NA, 2, NA, NA, NA, NA, NA, NA, N...
## $ dcfdx                 <int> 1, 1, 1, 1, NA, 1, NA, 1, 2, 1, 1, 1, 1,...
## $ dementia              <int> 0, 0, 0, 0, NA, 0, NA, 0, 0, 0, 0, 0, 0,...
## $ r_stroke              <int> NA, NA, 4, 4, NA, 4, NA, 4, NA, 4, NA, N...
## $ cogn_ep               <dbl> 0.073389978, -0.002270858, -0.533467384,...
## $ cogn_global           <dbl> 0.25733204, 0.33752780, 0.06659408, 0.40...
## $ cogn_po               <dbl> 0.299150420, 0.893261567, 0.893261567, 0...
## $ cogn_ps               <dbl> 0.48563724, 0.88320592, 0.78368706, 0.59...
## $ cogn_se               <dbl> 0.780455216, 0.938832669, 1.202795091, 1...
## $ cogn_wo               <dbl> 0.157699036, -0.004753158, -0.319903508,...
## $ cts_bname             <int> 15, 15, 15, 15, 15, 12, NA, 15, 15, 15, ...
## $ cts_catflu            <int> 40, 43, 48, 49, 45, 20, NA, 31, 27, 26, ...
## $ cts_db                <int> 6, 6, 4, 4, 4, 6, NA, 2, 4, 3, 5, 3, 4, ...
## $ cts_delay             <int> 10, 7, 7, 10, 10, 4, NA, 14, 11, 11, 6, ...
## $ cts_df                <int> 9, 8, 9, 9, 9, 8, NA, 6, 8, 9, 9, 10, 9,...
## $ cts_doperf            <int> 7, 7, 6, 7, 8, 7, NA, 7, 4, 5, 5, 6, 6, ...
## $ cts_ebdr              <int> 9, 9, 6, 8, 9, 10, NA, 8, 0, 8, 7, 10, 1...
## $ cts_ebmt              <int> 7, 9, 6, 12, 9, 11, NA, 8, 10, 7, 9, 12,...
## $ cts_idea              <int> 8, 8, 8, 8, 8, 8, NA, 7, 8, 8, 8, 8, 8, ...
## $ cts_lopair            <int> 9, 14, 14, 15, 15, 5, NA, 10, 12, 8, 7, ...
## $ cts_mmse30            <dbl> 29, 29, 30, 30, 29, 29, NA, 27, 25, 28, ...
## $ cts_nccrtd            <int> 24, 34, 26, 27, 28, 19, NA, 16, 19, 13, ...
## $ cts_pmat              <int> 13, 12, 12, 11, 11, 10, NA, 11, 7, 13, 1...
## $ cts_read_nart         <int> 9, 8, 9, 8, 9, 10, NA, 5, 5, 3, 3, 3, 4,...
## $ cts_read_wrat         <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ cts_sdmt              <int> 49, 43, 53, 47, 51, 39, NA, 24, 21, 30, ...
## $ cts_story             <int> 10, 9, 7, 8, 11, 8, NA, 14, 14, 10, 9, 8...
## $ cts_wli               <int> 19, 18, 17, 18, 16, 20, NA, 16, 13, 11, ...
## $ cts_wlii              <int> 7, 6, 5, 6, 5, 5, NA, 5, 5, 3, 5, 5, 3, ...
## $ cts_wliii             <int> 10, 10, 10, 10, 10, 10, NA, 10, 10, 10, ...
## $ age_at_visit          <dbl> 79.96988, 81.08145, 81.61259, 82.59548, ...
## $ iadlsum               <int> 0, 0, 0, 0, 0, 5, 3, 0, 0, 0, 0, 0, 0, 1...
## $ katzsum               <int> 6, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 0...
## $ rosbscl               <int> 1, 3, 3, 3, 3, 0, 0, 3, 3, 3, 3, 2, 3, 2...
## $ rosbsum               <int> 2, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 1, 0, 1...
## $ vision                <int> 1, 1, 1, 2, 2, 1, 4, 1, 2, 1, NA, 2, 7, ...
## $ visionlog             <dbl> 0.3, 0.3, 0.3, 0.4, 0.4, 0.3, 0.7, 0.3, ...
## $ fev                   <dbl> 1.650, 1.280, 1.655, NA, 1.525, 1.110, N...
## $ mep                   <dbl> 39.5, 33.5, 43.0, NA, 39.0, 84.0, NA, 95...
## $ mip                   <dbl> 32.5, 36.5, 35.0, NA, 41.5, 73.5, NA, 82...
## $ pvc                   <dbl> 2.285, 1.285, 1.690, NA, 1.940, 1.510, N...
## $ bun                   <int> 13, NA, 13, 13, 14, 32, 35, 14, 12, 12, ...
## $ ca                    <dbl> 9.5, NA, 9.4, 9.4, 9.2, 9.2, 8.8, 9.7, 9...
## $ chlstrl               <int> 235, NA, 205, 230, 210, 201, 197, 134, 1...
## $ cl                    <int> 96, NA, 102, 93, 99, 103, 103, 102, 104,...
## $ co2                   <int> 24, NA, 24, 25, 25, 22, 25, 23, 20, 21, ...
## $ crn                   <dbl> 0.85, NA, 0.98, 0.89, 0.82, 1.30, 2.00, ...
## $ fasting               <int> 2, NA, 2, 2, 2, 3, 3, 3, 2, 1, NA, 3, 1,...
## $ glucose               <int> 92, NA, 77, 85, 92, 180, 153, 170, 203, ...
## $ hba1c                 <dbl> 5.6, NA, 5.5, 5.5, 6.1, NA, NA, NA, 7.0,...
## $ hdlchlstrl            <int> 79, NA, 76, 79, 69, 50, 51, 30, 37, 40, ...
## $ hdlratio              <dbl> 3.0, NA, 2.7, 2.9, 3.0, 4.0, 3.9, 4.5, 4...
## $ k                     <dbl> 5.0, NA, 4.2, 4.3, 4.5, 4.8, 4.6, 4.2, 4...
## $ ldlchlstrl            <int> 133, NA, 112, 134, 119, 107, 99, NA, 48,...
## $ na                    <int> 136, NA, 139, 130, 136, 139, 140, 139, 1...
## $ alcohol_g             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ bmi                   <dbl> 26.83177, 27.61514, 26.97526, 26.40132, ...
## $ htm                   <dbl> 1.778004, 1.752604, 1.778004, 1.778004, ...
## $ phys5itemsum          <dbl> 1.7500000, 4.0416667, 0.6250000, 0.45833...
## $ wtkg                  <dbl> 84.8232, 84.8232, 85.2768, 83.4624, 84.3...
## $ bp11                  <chr> "159/090", "145/090", "160/095", "147/09...
## $ bp2                   <chr> "159/090", "150/084", "160/088", "149/09...
## $ bp3                   <int> 1, 1, NA, 1, NA, 1, 1, 1, 1, 1, 1, 1, 1,...
## $ bp31                  <chr> "157/082", "109/077", "151/082", "138/08...
## $ hypertension_cum      <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0...
## $ dm_cum                <int> 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0...
## $ thyroid_cum           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ chf_cum               <int> 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0...
## $ claudication_cum      <int> 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0...
## $ heart_cum             <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ stroke_cum            <int> NA, NA, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
## $ vasc_3dis_sum         <dbl> 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0...
## $ vasc_4dis_sum         <dbl> 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0...
## $ vasc_risks_sum        <dbl> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0...
## $ gait_speed            <dbl> 0.4393514, NA, NA, 0.4876800, 0.3483429,...
## $ gripavg               <dbl> 41.00, 41.00, 35.50, NA, 25.75, 59.00, N...
```

```r
dto[["metaData"]] %>% dplyr::glimpse()
```

```
## Observations: 113
## Variables: 9
## $ name          <chr> "id", "study", "scaled_to.x", "agreeableness", "...
## $ label         <chr> NA, NA, NA, "NEO agreeableness-ROS", "Conscienti...
## $ type          <chr> "design", "design", "design", "personality", "pe...
## $ name_new      <chr> "id", "study", "scaled_to.x", "agreeableness", "...
## $ construct     <chr> "id", "", "", "", "", "", "", "", "", "", "", ""...
## $ self_reported <lgl> FALSE, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ longitudinal  <lgl> FALSE, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ unit          <chr> "person", "", "", "", "", "", "", "", "", "", ""...
## $ include       <lgl> TRUE, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA...
```

```r
meta_data <- dto[["metaData"]] %>%
  dplyr::filter(include == TRUE) %>%
  # dplyr::select(name, name_new, type, label, construct) %>%
  dplyr::arrange(type, construct, name)
knitr::kable(meta_data)
```



|name          |label                                                      |type        |name_new      |construct              |self_reported |longitudinal |unit             |include |
|:-------------|:----------------------------------------------------------|:-----------|:-------------|:----------------------|:-------------|:------------|:----------------|:-------|
|apoe_genotype |ApoE genotype                                              |clinical    |apoe_genotype |apoe                   |FALSE         |FALSE        |scale            |TRUE    |
|chf_cum       |Medical Conditions - congestive heart failure -
cumulative |clinical    |chf_cum       |cardio                 |TRUE          |TRUE         |category         |TRUE    |
|dcfdx         |Clinical dx summary                                        |clinical    |dcfdx         |cognition              |FALSE         |TRUE         |category         |TRUE    |
|r_stroke      |Clinical stroke dx                                         |clinical    |r_stroke      |stroke                 |FALSE         |TRUE         |category         |TRUE    |
|stroke_cum    |Clinical Diagnoses - Stroke - cumulative                   |clinical    |stroke_cum    |stroke                 |FALSE         |TRUE         |category         |TRUE    |
|cts_mmse30    |MMSE - 2014                                                |cognitive   |mmse          |dementia               |TRUE          |TRUE         |0 to 30          |TRUE    |
|dementia      |Dementia diagnosis                                         |cognitive   |dementia      |dementia               |FALSE         |TRUE         |0, 1             |TRUE    |
|cogn_ep       |Calculated domain score-episodic memory                    |cognitive   |cogn_ep       |episodic memory        |FALSE         |TRUE         |composite        |TRUE    |
|cogn_global   |Global cognitive score                                     |cognitive   |cogn_global   |global cognition       |FALSE         |TRUE         |composite        |TRUE    |
|cogn_po       |Calculated domain score - perceptual orientation           |cognitive   |cogn_po       |perceptual orientation |FALSE         |TRUE         |composite        |TRUE    |
|cogn_ps       |Calculated domain score - perceptual speed                 |cognitive   |cogn_ps       |perceptual speed       |FALSE         |TRUE         |composite        |TRUE    |
|cogn_se       |Calculated domain score - semantic memory                  |cognitive   |cogn_se       |semantic memory        |FALSE         |TRUE         |composite        |TRUE    |
|cogn_wo       |Calculated domain score - working memory                   |cognitive   |cogn_wo       |working memory         |FALSE         |TRUE         |composite        |TRUE    |
|age_bl        |Age at baseline                                            |demographic |age_bl        |age                    |FALSE         |FALSE        |year             |TRUE    |
|age_death     |Age at death                                               |demographic |age_death     |age                    |FALSE         |FALSE        |year             |TRUE    |
|died          |Indicator of death                                         |demographic |died          |age                    |FALSE         |FALSE        |category         |TRUE    |
|educ          |Years of education                                         |demographic |educ          |education              |TRUE          |FALSE        |years            |TRUE    |
|race          |Participant's race                                         |demographic |race          |race                   |TRUE          |FALSE        |category         |TRUE    |
|spanish       |Spanish/Hispanic origin                                    |demographic |spanish       |race                   |TRUE          |FALSE        |category         |TRUE    |
|msex          |Gender                                                     |demographic |msex          |sex                    |FALSE         |FALSE        |category         |TRUE    |
|id            |NA                                                         |design      |id            |id                     |FALSE         |FALSE        |person           |TRUE    |
|fu_year       |Follow-up year                                             |design      |fu_year       |time                   |FALSE         |TRUE         |time point       |TRUE    |
|iadlsum       |Instrumental activities of daily liviing                   |physical    |iadlsum       |physact                |TRUE          |TRUE         |scale            |TRUE    |
|fev           |forced expiratory volume                                   |physical    |fev           |physcap                |FALSE         |TRUE         |liters           |TRUE    |
|gait_speed    |Gait Speed - MAP                                           |physical    |gait_speed    |physcap                |FALSE         |TRUE         |min/sec          |TRUE    |
|gripavg       |Extremity strength                                         |physical    |gripavg       |physcap                |FALSE         |TRUE         |lbs              |TRUE    |
|katzsum       |Katz measure of disability                                 |physical    |katzsum       |physcap                |TRUE          |TRUE         |scale            |TRUE    |
|mep           |maximal expiratory pressure                                |physical    |mep           |physcap                |FALSE         |TRUE         |cm H20           |TRUE    |
|mip           |maximal inspiratory pressure                               |physical    |mip           |physcap                |FALSE         |TRUE         |cm H20           |TRUE    |
|pvc           |pulmonary vital capacity                                   |physical    |pvc           |physcap                |FALSE         |TRUE         |liters           |TRUE    |
|rosbscl       |Rosow-Breslau scale                                        |physical    |rosbscl       |physcap                |TRUE          |TRUE         |scale            |TRUE    |
|rosbsum       |Rosow-Breslau scale                                        |physical    |rosbsum       |physcap                |TRUE          |TRUE         |scale            |TRUE    |
|vision        |Vision acuity                                              |physical    |vision        |physcap                |FALSE         |TRUE         |scale            |TRUE    |
|visionlog     |Visual acuity                                              |physical    |visionlog     |physcap                |FALSE         |TRUE         |scale            |TRUE    |
|bmi           |Body mass index                                            |physical    |bmi           |physique               |FALSE         |TRUE         |kg/msq           |TRUE    |
|htm           |Height(meters)                                             |physical    |htm           |physique               |FALSE         |TRUE         |meters           |TRUE    |
|wtkg          |Weight (kg)                                                |physical    |wtkg          |physique               |FALSE         |TRUE         |kilos            |TRUE    |
|alcohol_g     |Grams of alcohol per day                                   |substance   |alcohol_g     |alcohol                |TRUE          |FALSE        |grams            |TRUE    |
|ldai_bl       |Lifetime daily alcohol intake -baseline                    |substance   |alco_life     |alcohol                |TRUE          |FALSE        |drinks/day       |TRUE    |
|q3smo_bl      |Smoking quantity-baseline                                  |substance   |q3smo_bl      |smoking                |TRUE          |FALSE        |cigarettes / day |TRUE    |
|q4smo_bl      |Smoking duration-baseline                                  |substance   |q4smo_bl      |smoking                |TRUE          |FALSE        |years            |TRUE    |
|smoke_bl      |Smoking at baseline                                        |substance   |smoke_bl      |smoking                |TRUE          |FALSE        |category         |TRUE    |
|smoking       |Smoking                                                    |substance   |smoking       |smoking                |TRUE          |FALSE        |category         |TRUE    |

```r
# rename variables
d_rules <- dto[["metaData"]] %>%
  dplyr::filter(name %in% names(ds)) %>% 
  dplyr::select(name, name_new ) # leave only collumn, which values you wish to append
names(ds) <- d_rules[,"name_new"]
# transfer changes to dto
ds <- ds %>% dplyr::filter(study == "MAP ")
table(ds$study)
```

```
## 
## MAP  
## 9708
```

```r
dto[["unitData"]] <- ds 
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
names(dto[["unitData"]])
```

```
##   [1] "id"                    "study"                
##   [3] "scaled_to.x"           "agreeableness"        
##   [5] "conscientiousness"     "extraversion"         
##   [7] "neo_altruism"          "neo_conscientiousness"
##   [9] "neo_trust"             "openness"             
##  [11] "anxiety_10items"       "neuroticism_12"       
##  [13] "neuroticism_6"         "age_bl"               
##  [15] "age_death"             "died"                 
##  [17] "educ"                  "msex"                 
##  [19] "race"                  "spanish"              
##  [21] "apoe_genotype"         "alco_life"            
##  [23] "q3smo_bl"              "q4smo_bl"             
##  [25] "smoke_bl"              "smoking"              
##  [27] "fu_year"               "scaled_to.y"          
##  [29] "cesdsum"               "r_depres"             
##  [31] "intrusion"             "neglifeevents"        
##  [33] "negsocexchange"        "nohelp"               
##  [35] "panas"                 "perceivedstress"      
##  [37] "rejection"             "unsympathetic"        
##  [39] "dcfdx"                 "dementia"             
##  [41] "r_stroke"              "cogn_ep"              
##  [43] "cogn_global"           "cogn_po"              
##  [45] "cogn_ps"               "cogn_se"              
##  [47] "cogn_wo"               "cts_bname"            
##  [49] "catfluency"            "cts_db"               
##  [51] "cts_delay"             "cts_df"               
##  [53] "cts_doperf"            "cts_ebdr"             
##  [55] "cts_ebmt"              "cts_idea"             
##  [57] "cts_lopair"            "mmse"                 
##  [59] "cts_nccrtd"            "cts_pmat"             
##  [61] "cts_read_nart"         "cts_read_wrat"        
##  [63] "cts_sdmt"              "cts_story"            
##  [65] "cts_wli"               "cts_wlii"             
##  [67] "cts_wliii"             "age_at_visit"         
##  [69] "iadlsum"               "katzsum"              
##  [71] "rosbscl"               "rosbsum"              
##  [73] "vision"                "visionlog"            
##  [75] "fev"                   "mep"                  
##  [77] "mip"                   "pvc"                  
##  [79] "bun"                   "ca"                   
##  [81] "chlstrl"               "cl"                   
##  [83] "co2"                   "crn"                  
##  [85] "fasting"               "glucose"              
##  [87] "hba1c"                 "hdlchlstrl"           
##  [89] "hdlratio"              "k"                    
##  [91] "ldlchlstrl"            "na"                   
##  [93] "alcohol_g"             "bmi"                  
##  [95] "htm"                   "phys5itemsum"         
##  [97] "wtkg"                  "bp11"                 
##  [99] "bp2"                   "bp3"                  
## [101] "bp31"                  "hypertension_cum"     
## [103] "dm_cum"                "thyroid_cum"          
## [105] "chf_cum"               "claudication_cum"     
## [107] "heart_cum"             "stroke_cum"           
## [109] "vasc_3dis_sum"         "vasc_4dis_sum"        
## [111] "vasc_risks_sum"        "gait_speed"           
## [113] "gripavg"
```

```r
# 2nd element - meta data, info about variables
names(dto[["metaData"]])
```

```
## [1] "name"          "label"         "type"          "name_new"     
## [5] "construct"     "self_reported" "longitudinal"  "unit"         
## [9] "include"
```

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
## [1] ggplot2_2.1.0 magrittr_1.5 
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.6        tidyr_0.5.1        dplyr_0.5.0       
##  [4] assertthat_0.1     digest_0.6.10      R6_2.1.2          
##  [7] grid_3.3.1         plyr_1.8.4         DBI_0.4-1         
## [10] gtable_0.2.0       formatR_1.4        evaluate_0.9      
## [13] scales_0.4.0       highr_0.6          stringi_1.1.1     
## [16] lazyeval_0.2.0     testit_0.5         rmarkdown_0.9.6.14
## [19] tools_3.3.1        stringr_1.0.0      munsell_0.4.3     
## [22] colorspace_1.2-6   htmltools_0.3.5    knitr_1.13        
## [25] tibble_1.1
```

```r
Sys.time()
```

```
## [1] "2016-08-08 07:25:23 PDT"
```

