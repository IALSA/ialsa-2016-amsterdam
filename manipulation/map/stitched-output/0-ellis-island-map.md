



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
t <- table(ds[,"fu_year"], ds[,"died"]); t[t==0]<-".";t 
```

```
##     
##      0    1  
##   0  1005 847
##   1  861  752
##   2  775  663
##   3  686  578
##   4  596  499
##   5  486  422
##   6  424  363
##   7  350  294
##   8  290  234
##   9  265  174
##   10 225  123
##   11 200  90 
##   12 137  63 
##   13 94   36 
##   14 42   10 
##   15 23   10 
##   16 17   2  
##   17 15   2  
##   18 15   4
```

```r
t <- table(ds[,"msex"], ds[,"race"], useNA = "always"); t[t==0]<-".";t 
```

```
##       
##        1    2   3  6  <NA>
##   0    8220 530 19 41 4   
##   1    2733 104 11 10 .   
##   <NA> .    .   .  .  1
```

```r
t <- table(ds[,"educ"], ds[,"race"]); t[t==0]<-".";t 
```

```
##     
##      1    2   3  6 
##   0  4    .   .  . 
##   2  9    .   .  . 
##   3  8    .   2  . 
##   4  23   1   .  . 
##   5  23   4   .  . 
##   6  49   6   .  . 
##   7  29   .   .  . 
##   8  164  26  .  . 
##   9  72   9   .  . 
##   10 158  24  .  5 
##   11 201  26  .  . 
##   12 2448 148 .  12
##   13 870  89  1  6 
##   14 1244 110 .  1 
##   15 547  41  .  14
##   16 2376 85  17 4 
##   17 553  .   .  . 
##   18 1093 49  5  9 
##   19 317  10  2  . 
##   20 337  6   .  . 
##   21 237  .   .  . 
##   22 75   .   .  . 
##   23 40   .   .  . 
##   24 32   .   .  . 
##   25 18   .   3  . 
##   28 25   .   .  .
```

```r
# reconstruct the dto to be used in this project
dto <- list()
# the first element of data transfer object contains unit data
dto[["unitData"]] <- ds
# the second element of data transfer object contains meta data
dto[["metaData"]] <-  metaData # new, local meta-data!!
# verify and glimpse
dto[["unitData"]] %>% dplyr::glimpse()
```

```
## Observations: 11,673
## Variables: 142
## $ id                    <int> 9121, 9121, 9121, 9121, 9121, 9121, 9121...
## $ study                 <chr> "MAP ", "MAP ", "MAP ", "MAP ", "MAP ", ...
## $ scaled_to             <chr> "MAP", "MAP", "MAP", "MAP", "MAP", "MAP"...
## $ agreeableness         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ conscientiousness     <int> 35, 35, 35, 35, 35, 35, 35, NA, NA, NA, ...
## $ neo_altruism          <int> 27, 27, 27, 27, 27, 27, 27, NA, NA, NA, ...
## $ neo_conscientiousness <int> 35, 35, 35, 35, 35, 35, 35, NA, NA, NA, ...
## $ neo_trust             <int> 25, 25, 25, 25, 25, 25, 25, NA, NA, NA, ...
## $ neuroticism_12        <int> 9, 9, 9, 9, 9, 9, 9, NA, NA, 16, 16, 16,...
## $ openness              <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ anxiety_10items       <dbl> 0, 0, 0, 0, 0, 0, 0, NA, NA, 0, 0, 0, 0,...
## $ neuroticism_6         <int> 8, 8, 8, 8, 8, 8, 8, 1, 1, 14, 14, 14, 1...
## $ cogdx                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ age_bl                <dbl> 79.96988, 79.96988, 79.96988, 79.96988, ...
## $ age_death             <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ educ                  <int> 12, 12, 12, 12, 12, 12, 12, 14, 14, 8, 8...
## $ msex                  <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1...
## $ race                  <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
## $ spanish               <int> 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1...
## $ apoe_genotype         <int> 34, 34, 34, 34, 34, 34, 34, 33, 33, 33, ...
## $ alcohol_g_bl          <dbl> 4.10, 4.10, 4.10, 4.10, 4.10, 4.10, 4.10...
## $ alco_life             <dbl> 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.0, ...
## $ q3smo_bl              <int> 20, 20, 20, 20, 20, 20, 20, NA, NA, NA, ...
## $ q4smo_bl              <int> 31, 31, 31, 31, 31, 31, 31, NA, NA, NA, ...
## $ smoking               <int> 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0...
## $ cogact_chd            <dbl> 3.888889, 3.888889, 3.888889, 3.888889, ...
## $ cogact_midage         <dbl> 2.555556, 2.555556, 2.555556, 2.555556, ...
## $ cogact_past           <dbl> 2.964286, 2.964286, 2.964286, 2.964286, ...
## $ cogact_young          <dbl> 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 2.9, ...
## $ lostcons_ever         <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ ad_reagan             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ braaksc               <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ ceradsc               <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ niareagansc           <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ income_40             <int> 6, 6, 6, 6, 6, 6, 6, 7, 7, 5, 5, 5, 5, 5...
## $ fu_year               <int> 0, 1, 2, 3, 4, 5, 6, 0, 1, 0, 2, 3, 4, 5...
## $ scaled_to.y           <chr> "MAP", "MAP", "MAP", "MAP", "MAP", "MAP"...
## $ cesdsum               <int> 0, 0, 0, 0, 0, 0, 0, 1, 2, 6, 1, 3, 1, 0...
## $ r_depres              <int> 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 4, 4, 4, 4...
## $ intrusion             <dbl> NA, NA, NA, 2.000000, 2.333333, 2.333333...
## $ neglifeevents         <int> NA, NA, NA, 4, 2, 1, 2, NA, NA, NA, NA, ...
## $ negsocexchange        <dbl> NA, NA, NA, 1.833333, 2.000000, 1.916667...
## $ nohelp                <dbl> NA, NA, NA, 1.666667, 2.000000, 2.000000...
## $ panas                 <dbl> NA, NA, NA, 1.1, 1.1, 1.0, 1.0, NA, NA, ...
## $ perceivedstress       <dbl> NA, NA, NA, 2.50, 1.50, 2.25, 2.00, NA, ...
## $ rejection             <dbl> NA, NA, NA, 1.666667, 2.000000, 2.000000...
## $ unsympathetic         <dbl> NA, NA, NA, 2.000000, 1.666667, 1.333333...
## $ dcfdx                 <int> 1, 1, 1, 1, 1, 1, 1, 1, NA, 1, 2, 1, 1, ...
## $ dementia              <int> 0, 0, 0, 0, 0, 0, 0, 0, NA, 0, 0, 0, 0, ...
## $ r_stroke              <int> NA, NA, 4, 4, 4, 4, 4, 4, NA, 4, NA, 4, ...
## $ cogn_ep               <dbl> 0.12835551, 0.05407987, -0.45377854, 0.2...
## $ cogn_po               <dbl> 0.144997854, 0.744225406, 0.744225406, 0...
## $ cogn_ps               <dbl> 0.4618100, 0.4163097, 0.4394061, 0.45296...
## $ cogn_se               <dbl> 0.66746102, 0.63381091, 0.93838810, 0.83...
## $ cogn_wo               <dbl> 0.136495644, -0.023354383, -0.369043213,...
## $ cogn_global           <dbl> 0.28671548, 0.28229571, 0.09356106, 0.37...
## $ cts_animals           <int> 19, 20, 23, 21, 21, 24, 22, 9, NA, 15, 1...
## $ cts_bname             <int> 15, 15, 15, 15, 15, 15, 15, 12, NA, 15, ...
## $ catfluency            <int> 40, 43, 48, 49, 45, 47, 44, 20, NA, 31, ...
## $ cts_db                <int> 6, 6, 4, 4, 4, 3, 4, 6, NA, 2, 4, 3, 5, ...
## $ cts_delay             <int> 10, 7, 7, 10, 10, 10, 11, 4, NA, 14, 11,...
## $ cts_df                <int> 9, 8, 9, 9, 9, 8, 9, 8, NA, 6, 8, 9, 9, ...
## $ cts_doperf            <int> 7, 7, 6, 7, 8, 7, 6, 7, NA, 7, 4, 5, 5, ...
## $ cts_ebdr              <int> 9, 9, 6, 8, 9, 8, 7, 10, NA, 8, 0, 8, 7,...
## $ cts_ebmt              <int> 7, 9, 6, 12, 9, 6, 7, 11, NA, 8, 10, 7, ...
## $ cts_fruits            <int> 21, 23, 25, 28, 24, 23, 22, 11, NA, 16, ...
## $ cts_idea              <int> 8, 8, 8, 8, 8, 8, 8, 8, NA, 7, 8, 8, 8, ...
## $ cts_lopair            <int> 9, 14, 14, 15, 15, 14, 14, 5, NA, 10, 12...
## $ mmse                  <dbl> 29, 29, 30, 30, 29, 30, 29, 29, NA, 27, ...
## $ cts_nccrtd            <int> 24, 34, 26, 27, 28, 27, 24, 19, NA, 16, ...
## $ cts_pmat              <int> 13, 12, 12, 11, 11, 13, 14, 10, NA, 11, ...
## $ cts_pmsub             <int> 8, 7, 8, 7, 8, 9, 9, 7, NA, 8, 5, 9, 8, ...
## $ cts_read_nart         <int> 9, 8, 9, 8, 9, 9, 8, 10, NA, 5, 5, 3, 3,...
## $ cts_read_wrat         <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ cts_sdmt              <int> 49, 43, 53, 47, 51, 43, 44, 39, NA, 24, ...
## $ cts_story             <int> 10, 9, 7, 8, 11, 9, 9, 8, NA, 14, 14, 10...
## $ cts_stroop_cname      <int> 27, 16, 25, 25, 27, 26, 23, 19, NA, 18, ...
## $ cts_stroop_wread      <int> 44, 50, 38, 44, 44, 42, 40, 59, NA, 29, ...
## $ cts_wli               <int> 19, 18, 17, 18, 16, 18, 16, 20, NA, 16, ...
## $ cts_wlii              <int> 7, 6, 5, 6, 5, 6, 6, 5, NA, 5, 5, 3, 5, ...
## $ cts_wliii             <int> 10, 10, 10, 10, 10, 9, 10, 10, NA, 10, 1...
## $ age_at_visit          <dbl> 79.96988, 81.08145, 81.61259, 82.59548, ...
## $ iadlsum               <int> 0, 0, 0, 0, 0, 0, 0, 5, 3, 0, 0, 0, 0, 0...
## $ katzsum               <int> 6, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0...
## $ rosbscl               <int> 1, 3, 3, 3, 3, 3, 3, 0, 0, 3, 3, 3, 3, 2...
## $ rosbsum               <int> 2, 0, 0, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 1...
## $ vision                <int> 1, 1, 1, 2, 2, 2, 1, 1, 4, 1, 2, 1, NA, ...
## $ visionlog             <dbl> 0.3, 0.3, 0.3, 0.4, 0.4, 0.4, 0.3, 0.3, ...
## $ bun                   <int> 13, NA, 13, 13, 14, 13, 14, 32, 35, 14, ...
## $ ca                    <dbl> 9.5, NA, 9.4, 9.4, 9.2, 8.8, 9.1, 9.2, 8...
## $ cholesterol           <int> 235, NA, 205, 230, 210, 201, 231, 201, 1...
## $ cloride               <int> 96, NA, 102, 93, 99, 98, 98, 103, 103, 1...
## $ co2                   <int> 24, NA, 24, 25, 25, 24, 23, 22, 25, 23, ...
## $ crn                   <dbl> 0.85, NA, 0.98, 0.89, 0.82, 0.85, 0.85, ...
## $ fasting               <int> 2, NA, 2, 2, 2, 2, 2, 3, 3, 3, 2, 1, NA,...
## $ glucose               <int> 92, NA, 77, 85, 92, 85, 95, 180, 153, 17...
## $ hba1c                 <dbl> 5.6, NA, 5.5, 5.5, 6.1, 5.9, 5.6, NA, NA...
## $ hdlchlstrl            <int> 79, NA, 76, 79, 69, 71, 82, 50, 51, 30, ...
## $ hdlratio              <dbl> 3.0, NA, 2.7, 2.9, 3.0, 2.8, 2.8, 4.0, 3...
## $ k                     <dbl> 5.0, NA, 4.2, 4.3, 4.5, 4.0, 4.3, 4.8, 4...
## $ ldlchlstrl            <int> 133, NA, 112, 134, 119, 116, 137, 107, 9...
## $ na                    <int> 136, NA, 139, 130, 136, 132, 134, 139, 1...
## $ cogact_old            <dbl> 2.142857, 1.714286, 1.714286, 1.714286, ...
## $ bmi                   <dbl> 26.83177, 27.61514, 26.97526, 26.40132, ...
## $ htm                   <dbl> 1.778004, 1.752604, 1.778004, 1.778004, ...
## $ phys5itemsum          <dbl> 1.7500000, 4.0416667, 0.6250000, 0.45833...
## $ wtkg                  <dbl> 84.8232, 84.8232, 85.2768, 83.4624, 84.3...
## $ socact_old            <dbl> 2.666667, 2.333333, 2.333333, 2.500000, ...
## $ soc_net               <int> 6, 8, 8, 9, 6, 9, 8, 1, 4, 6, 3, 2, 3, 5...
## $ social_isolation      <dbl> 2.2, 2.0, 2.0, 1.4, 1.8, 1.6, 1.4, 1.8, ...
## $ bp_sit_1              <chr> "159/090", "145/090", "160/095", "147/09...
## $ bp_sit_2              <chr> "159/090", "150/084", "160/088", "149/09...
## $ bp_meds               <int> 1, 1, NA, 1, NA, NA, NA, 1, 1, 1, 1, 1, ...
## $ bp_stand_3            <chr> "157/082", "109/077", "151/082", "138/08...
## $ hypertension_cum      <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1...
## $ cancer_cum            <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ dm_cum                <int> 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1...
## $ headinjrloc_cum       <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ thyroid_cum           <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ chf_cum               <int> 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0...
## $ claudication_cum      <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1...
## $ heart_cum             <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
## $ stroke_cum            <int> NA, NA, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
## $ vasc_3dis_sum         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1...
## $ vasc_4dis_sum         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1...
## $ vasc_risks_sum        <dbl> 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2...
## $ gait_speed            <dbl> 0.4393514, NA, NA, 0.4876800, 0.3483429,...
## $ gripavg               <dbl> 41.00, 41.00, 35.50, NA, 25.75, 39.50, N...
## $ total_smell_test      <dbl> 8, 9, 10, 8, 9, 9, 8, 8, NA, 8, NA, NA, ...
## $ fev                   <dbl> 1.650, 1.280, 1.655, NA, 1.525, 1.820, N...
## $ mep                   <dbl> 39.5, 33.5, 43.0, NA, 39.0, 42.0, NA, 84...
## $ mip                   <dbl> 32.5, 36.5, 35.0, NA, 41.5, 32.0, NA, 73...
## $ pvc                   <dbl> 2.285, 1.285, 1.690, NA, 1.940, 1.820, N...
## $ firstobs              <dbl> 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0...
## $ month                 <chr> "6", "6", "6", "6", "6", "6", "6", "7", ...
## $ year                  <chr> "2010", "2010", "2010", "2010", "2010", ...
## $ date_at_bl            <date> 2010-06-01, 2010-06-01, 2010-06-01, 201...
## $ age_at_bl             <dbl> 79.96988, 79.96988, 79.96988, 79.96988, ...
## $ birth_date            <date> 1930-07-02, 1930-07-02, 1930-07-02, 193...
## $ birth_year            <dbl> 1930, 1930, 1930, 1930, 1930, 1930, 1930...
## $ date_at_visit         <date> 2010-06-01, 2011-07-12, 2012-01-22, 201...
## $ died                  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0...
```

```r
dto[["metaData"]] %>% dplyr::glimpse()
```

```
## Observations: 134
## Variables: 11
## $ name          <chr> "ad_reagan", "age_at_visit", "age_bl", "age_deat...
## $ label         <chr> "Dicotomized NIA-Reagan score", "Age at cycle - ...
## $ type          <chr> "pathology", "demographic", "demographic", "demo...
## $ name_new      <chr> "ad_reagan", "age_at_visit", "age_bl", "age_deat...
## $ construct     <chr> "alzheimer", "age", "age", "age", "", "alcohol",...
## $ self_reported <lgl> FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, NA, FALS...
## $ longitudinal  <lgl> FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, ...
## $ unit          <chr> "category", "year", "year", "year", "scale", "gr...
## $ include       <lgl> NA, TRUE, TRUE, TRUE, NA, TRUE, NA, TRUE, TRUE, ...
## $ url           <chr> "https://www.radc.rush.edu/docs/var/detail.htm?c...
## $ notes         <chr> "", "", "", "", "", "", "", "", "", "", "", "", ...
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
names(dto[["unitData"]])
```

```
##   [1] "id"                    "study"                
##   [3] "scaled_to"             "agreeableness"        
##   [5] "conscientiousness"     "neo_altruism"         
##   [7] "neo_conscientiousness" "neo_trust"            
##   [9] "neuroticism_12"        "openness"             
##  [11] "anxiety_10items"       "neuroticism_6"        
##  [13] "cogdx"                 "age_bl"               
##  [15] "age_death"             "educ"                 
##  [17] "msex"                  "race"                 
##  [19] "spanish"               "apoe_genotype"        
##  [21] "alcohol_g_bl"          "alco_life"            
##  [23] "q3smo_bl"              "q4smo_bl"             
##  [25] "smoking"               "cogact_chd"           
##  [27] "cogact_midage"         "cogact_past"          
##  [29] "cogact_young"          "lostcons_ever"        
##  [31] "ad_reagan"             "braaksc"              
##  [33] "ceradsc"               "niareagansc"          
##  [35] "income_40"             "fu_year"              
##  [37] "scaled_to.y"           "cesdsum"              
##  [39] "r_depres"              "intrusion"            
##  [41] "neglifeevents"         "negsocexchange"       
##  [43] "nohelp"                "panas"                
##  [45] "perceivedstress"       "rejection"            
##  [47] "unsympathetic"         "dcfdx"                
##  [49] "dementia"              "r_stroke"             
##  [51] "cogn_ep"               "cogn_po"              
##  [53] "cogn_ps"               "cogn_se"              
##  [55] "cogn_wo"               "cogn_global"          
##  [57] "cts_animals"           "cts_bname"            
##  [59] "catfluency"            "cts_db"               
##  [61] "cts_delay"             "cts_df"               
##  [63] "cts_doperf"            "cts_ebdr"             
##  [65] "cts_ebmt"              "cts_fruits"           
##  [67] "cts_idea"              "cts_lopair"           
##  [69] "mmse"                  "cts_nccrtd"           
##  [71] "cts_pmat"              "cts_pmsub"            
##  [73] "cts_read_nart"         "cts_read_wrat"        
##  [75] "cts_sdmt"              "cts_story"            
##  [77] "cts_stroop_cname"      "cts_stroop_wread"     
##  [79] "cts_wli"               "cts_wlii"             
##  [81] "cts_wliii"             "age_at_visit"         
##  [83] "iadlsum"               "katzsum"              
##  [85] "rosbscl"               "rosbsum"              
##  [87] "vision"                "visionlog"            
##  [89] "bun"                   "ca"                   
##  [91] "cholesterol"           "cloride"              
##  [93] "co2"                   "crn"                  
##  [95] "fasting"               "glucose"              
##  [97] "hba1c"                 "hdlchlstrl"           
##  [99] "hdlratio"              "k"                    
## [101] "ldlchlstrl"            "na"                   
## [103] "cogact_old"            "bmi"                  
## [105] "htm"                   "phys5itemsum"         
## [107] "wtkg"                  "socact_old"           
## [109] "soc_net"               "social_isolation"     
## [111] "bp_sit_1"              "bp_sit_2"             
## [113] "bp_meds"               "bp_stand_3"           
## [115] "hypertension_cum"      "cancer_cum"           
## [117] "dm_cum"                "headinjrloc_cum"      
## [119] "thyroid_cum"           "chf_cum"              
## [121] "claudication_cum"      "heart_cum"            
## [123] "stroke_cum"            "vasc_3dis_sum"        
## [125] "vasc_4dis_sum"         "vasc_risks_sum"       
## [127] "gait_speed"            "gripavg"              
## [129] "total_smell_test"      "fev"                  
## [131] "mep"                   "mip"                  
## [133] "pvc"                   "firstobs"             
## [135] "month"                 "year"                 
## [137] "date_at_bl"            "age_at_bl"            
## [139] "birth_date"            "birth_year"           
## [141] "date_at_visit"         "died"
```

```r
# 2nd element - meta data, info about variables
names(dto[["metaData"]])
```

```
##  [1] "name"          "label"         "type"          "name_new"     
##  [5] "construct"     "self_reported" "longitudinal"  "unit"         
##  [9] "include"       "url"           "notes"
```

```r
names_labels(dto$unitData)
```

```
##                      name
## 1                      id
## 2                   study
## 3               scaled_to
## 4           agreeableness
## 5       conscientiousness
## 6            neo_altruism
## 7   neo_conscientiousness
## 8               neo_trust
## 9          neuroticism_12
## 10               openness
## 11        anxiety_10items
## 12          neuroticism_6
## 13                  cogdx
## 14                 age_bl
## 15              age_death
## 16                   educ
## 17                   msex
## 18                   race
## 19                spanish
## 20          apoe_genotype
## 21           alcohol_g_bl
## 22              alco_life
## 23               q3smo_bl
## 24               q4smo_bl
## 25                smoking
## 26             cogact_chd
## 27          cogact_midage
## 28            cogact_past
## 29           cogact_young
## 30          lostcons_ever
## 31              ad_reagan
## 32                braaksc
## 33                ceradsc
## 34            niareagansc
## 35              income_40
## 36                fu_year
## 37            scaled_to.y
## 38                cesdsum
## 39               r_depres
## 40              intrusion
## 41          neglifeevents
## 42         negsocexchange
## 43                 nohelp
## 44                  panas
## 45        perceivedstress
## 46              rejection
## 47          unsympathetic
## 48                  dcfdx
## 49               dementia
## 50               r_stroke
## 51                cogn_ep
## 52                cogn_po
## 53                cogn_ps
## 54                cogn_se
## 55                cogn_wo
## 56            cogn_global
## 57            cts_animals
## 58              cts_bname
## 59             catfluency
## 60                 cts_db
## 61              cts_delay
## 62                 cts_df
## 63             cts_doperf
## 64               cts_ebdr
## 65               cts_ebmt
## 66             cts_fruits
## 67               cts_idea
## 68             cts_lopair
## 69                   mmse
## 70             cts_nccrtd
## 71               cts_pmat
## 72              cts_pmsub
## 73          cts_read_nart
## 74          cts_read_wrat
## 75               cts_sdmt
## 76              cts_story
## 77       cts_stroop_cname
## 78       cts_stroop_wread
## 79                cts_wli
## 80               cts_wlii
## 81              cts_wliii
## 82           age_at_visit
## 83                iadlsum
## 84                katzsum
## 85                rosbscl
## 86                rosbsum
## 87                 vision
## 88              visionlog
## 89                    bun
## 90                     ca
## 91            cholesterol
## 92                cloride
## 93                    co2
## 94                    crn
## 95                fasting
## 96                glucose
## 97                  hba1c
## 98             hdlchlstrl
## 99               hdlratio
## 100                     k
## 101            ldlchlstrl
## 102                    na
## 103            cogact_old
## 104                   bmi
## 105                   htm
## 106          phys5itemsum
## 107                  wtkg
## 108            socact_old
## 109               soc_net
## 110      social_isolation
## 111              bp_sit_1
## 112              bp_sit_2
## 113               bp_meds
## 114            bp_stand_3
## 115      hypertension_cum
## 116            cancer_cum
## 117                dm_cum
## 118       headinjrloc_cum
## 119           thyroid_cum
## 120               chf_cum
## 121      claudication_cum
## 122             heart_cum
## 123            stroke_cum
## 124         vasc_3dis_sum
## 125         vasc_4dis_sum
## 126        vasc_risks_sum
## 127            gait_speed
## 128               gripavg
## 129      total_smell_test
## 130                   fev
## 131                   mep
## 132                   mip
## 133                   pvc
## 134              firstobs
## 135                 month
## 136                  year
## 137            date_at_bl
## 138             age_at_bl
## 139            birth_date
## 140            birth_year
## 141         date_at_visit
## 142                  died
##                                                          label
## 1                                           Subject identifier
## 2                      The particular RADC study (MAP/ROS/RMM)
## 3                                             Scaled parameter
## 4                                        NEO agreeableness-ROS
## 5                                    Conscientiousness-ROS/MAP
## 6                                       NEO altruism scale-MAP
## 7                                    NEO conscientiousness-MAP
## 8                                                NEO trust-MAP
## 9                            Neuroticism - 12 item version-RMM
## 10                                             NEO openess-ROS
## 11                       Anxiety-10 item version - ROS and MAP
## 12                          Neuroticism - 6 item version - RMM
## 13                         Final consensus cognitive diagnosis
## 14                                             Age at baseline
## 15                                                Age at death
## 16                                          Years of education
## 17                                                      Gender
## 18                                          Participant's race
## 19                                     Spanish/Hispanic origin
## 20                                   Apolipoprotein E genotype
## 21                   Grams of alcohol used per day at baseline
## 22                     Lifetime daily alcohol intake -baseline
## 23                                   Smoking quantity-baseline
## 24                                   Smoking duration-baseline
## 25                                                     Smoking
## 26                                  Cognitive actifity - child
## 27                             Codnitive activity - middle age
## 28                                   Cognitive actifity - past
## 29                            Cognitive actifity - young adult
## 30                                                        <NA>
## 31                                Dicotomized NIA-Reagan score
## 32         Semiquantitative measure of neurofibrillary tangles
## 33                Semiquantitative measure of neuritic plaques
## 34                                                        <NA>
## 35                                      Income level at age 40
## 36                                              Follow-up year
## 37                                            Scaled parameter
## 38              Measure of depressive symptoms (Modified CESD)
## 39                           Major depression dx-clinic rating
## 40                      Negative social exchange-intrusion-MAP
## 41                                        Negative life events
## 42                                    Negative social exchange
## 43                           Negative social exchange-help-MAP
## 44                                                 Panas score
## 45                                            Perceived stress
## 46                    Negative social exchange - rejection-MAP
## 47                 Negative social exchange-unsymapathetic-MAP
## 48                                         Clinical dx summary
## 49                                          Dementia diagnosis
## 50                                          Clinical stroke dx
## 51                     Calculated domain score-episodic memory
## 52            Calculated domain score - perceptual orientation
## 53                  Calculated domain score - perceptual speed
## 54                   Calculated domain score - semantic memory
## 55                    Calculated domain score - working memory
## 56                                      Global cognitive score
## 57                                  Category fluence - Animals
## 58                                        Boston naming - 2014
## 59                                     Category fluency - 2014
## 60                                     Digits backwards - 2014
## 61                                   Logical memory IIa - 2014
## 62                                      Digits forwards - 2014
## 63                                       Digit ordering - 2014
## 64                   East Boston story - delayed recall - 2014
## 65                        East Boston story - immediate - 2014
## 66                                   Category fluency - Fruits
## 67                                        Complex ideas - 2014
## 68                                     Line orientation - 2014
## 69                                                 MMSE - 2014
## 70                                    Number comparison - 2014
## 71                                 Progressive Matrices - 2014
## 72                                                        <NA>
## 73                                      Reading test-NART-2014
## 74                                  Reading test - WRAT - 2014
## 75                            Symbol digit modalitities - 2014
## 76                        Logical memory Ia - immediate - 2014
## 77                                                        <NA>
## 78                                                        <NA>
## 79                                Word list I- immediate- 2014
## 80                               Word list II - delayed - 2014
## 81                          Word list III - recognition - 2014
## 82                                   Age at cycle - fractional
## 83                    Instrumental activities of daily liviing
## 84                                  Katz measure of disability
## 85                                         Rosow-Breslau scale
## 86                                         Rosow-Breslau scale
## 87                                               Vision acuity
## 88                                               Visual acuity
## 89                                         Blood urea nitrogen
## 90                                                     Calcium
## 91                                                 Cholesterol
## 92                                                    Chloride
## 93                                              Carbon Dioxide
## 94                                                  Creatinine
## 95          Whether blood was collected on fasting participant
## 96                                                     Glucose
## 97                                              Hemoglobin A1c
## 98                                             HDL cholesterol
## 99                                                   HDL ratio
## 100                                                  Potassium
## 101                                            LDL cholesterol
## 102                                                     Sodium
## 103                             Codnitive activity - late life
## 104                                            Body mass index
## 105                                             Height(meters)
## 106                     Physical activity (summary of 5 items)
## 107                                                Weight (kg)
## 108                                Social activity - late life
## 109                                        Social network size
## 110                                 Percieved social isolation
## 111              Blood pressure measurement- sitting - trial 1
## 112              Blood pressure measurement- sitting - trial 2
## 113                                         Hx of Meds for HTN
## 114                       Blood pressure measurement- standing
## 115             Medical conditions - hypertension - cumulative
## 116                   Medical Conditions - cancer - cumulative
## 117                    Medical history - diabetes - cumulative
## 118                                                       <NA>
## 119          Medical Conditions - thyroid disease - cumulative
## 120  Medical Conditions - congestive heart failure -cumulative
## 121              Medical conditions - claudication -cumulative
## 122                    Medical Conditions - heart - cumulative
## 123                   Clinical Diagnoses - Stroke - cumulative
## 124 Vascular disease burden (3 items w/o chf)\r\r ROS/MAP/MARS
## 125      Vascular disease burden (4 items) - MAP/MARS\r\r only
## 126                              Vascular disease risk factors
## 127                                           Gait Speed - MAP
## 128                                         Extremity strength
## 129                                                       <NA>
## 130                                   forced expiratory volume
## 131                                maximal expiratory pressure
## 132                               maximal inspiratory pressure
## 133                                   pulmonary vital capacity
## 134                                                       <NA>
## 135                          Date of the interview at baseline
## 136                          Date of the interview at baseline
## 137                                                       <NA>
## 138                                                       <NA>
## 139                                                       <NA>
## 140                                                       <NA>
## 141                                  Age at cycle - fractional
## 142                                                       <NA>
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
##  [1] Rcpp_0.12.7      tidyr_0.6.0      dplyr_0.5.0      assertthat_0.1  
##  [5] R6_2.1.3         grid_3.3.1       plyr_1.8.4       DBI_0.5-1       
##  [9] gtable_0.2.0     formatR_1.4      evaluate_0.9     scales_0.4.0    
## [13] highr_0.6        stringi_1.1.1    lazyeval_0.2.0   testit_0.5      
## [17] tools_3.3.1      stringr_1.1.0    markdown_0.7.7   munsell_0.4.3   
## [21] rsconnect_0.4.3  colorspace_1.2-6 knitr_1.14       tibble_1.2
```

```r
Sys.time()
```

```
## [1] "2016-10-10 16:31:43 EDT"
```

