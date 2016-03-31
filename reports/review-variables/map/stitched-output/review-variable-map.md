



This report was automatically generated with the R package **knitr**
(version 1.12.3).


```r
# knitr::stitch_rmd(script="./reports/review-variables/map/review-variables-map.R", output="./reports/review-variables/map/stitched-output/review-variable-map.md")
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
library(magrittr) # enables piping : %>% 

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
requireNamespace("tidyr") # data manipulation
requireNamespace("dplyr") # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")# For asserting conditions meet expected patterns.
# requireNamespace("car") # For it's `recode()` function.
```

```r
data_path_input  <- "../MAP/data-unshared/derived/ds0.rds"
metadata_path_input <- "../MAP/data-phi-free/raw/nl_augmented.csv" # input file with your manual classification
```

```r
ds <- readRDS(data_path_input)
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
t <- table(ds$race, ds$fu_year, useNA="always"); t[t==0]<-".";t
```

```
##       
##        0    1    2    3    4   5   6   7   8   9   10  11  12 13 14 15 16
##   1    1582 1380 1188 1011 848 693 624 518 434 316 231 129 56 44 28 21 2 
##   2    100  75   69   59   53  43  40  37  29  24  5   3   .  .  .  .  . 
##   3    4    4    3    3    3   2   1   1   .   .   .   .   .  .  .  .  . 
##   6    9    8    6    5    4   2   1   2   3   2   1   1   .  .  .  .  . 
##   <NA> .    .    .    .    .   .   .   .   .   .   .   .   .  .  .  .  . 
##       
##        <NA>
##   1    1   
##   2    .   
##   3    .   
##   6    .   
##   <NA> .
```

```r
d <- ds[c("id", "fu_year", "race")]
```

```r
# create a data object that will be used for subsequent analyses
# select variables you will need for modeling
selected_items <- c(
  "id", # personal identifier
  "age_bl", # Age at baseline
  "age_death", # Age at death
  "died", # Indicator of death
  "msex", # Gender
  "race", # Participant's race
  "educ", # Years of education

  # time-invariant above
  "fu_year", # Follow-up year ------------------------------------------------
  # time-variant below
  
  "age_at_visit", #Age at cycle - fractional
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

d <- ds[ , selected_items]
table(d$fu_year)
```

```
## 
##    0    1    2    3    4    5    6    7    8    9   10   11   12   13   14 
## 1695 1467 1266 1078  908  740  666  558  466  342  237  133   56   44   28 
##   15   16 
##   21    2
```



```r
#################################
#     Who are these people?     #
################################

# basic demographic variables
length(unique(ds$id)) # there are this many of them
```

```
## [1] 1696
```

```r
ds %>% dplyr::group_by_("msex") %>% dplyr::summarise(count = n())
```

```
## Source: local data frame [2 x 2]
## 
##    msex count
##   (int) (int)
## 1     0  7286
## 2     1  2422
```

```r
ds %>% dplyr::group_by_("race") %>% dplyr::summarise(count = n())
```

```
## Source: local data frame [4 x 2]
## 
##    race count
##   (int) (int)
## 1     1  9106
## 2     2   537
## 3     3    21
## 4     6    44
```

```r
table(ds$msex, ds$race)
```

```
##    
##        1    2    3    6
##   0 6796  443   13   34
##   1 2310   94    8   10
```

```r
table(ds["educ"])
```

```
## 
##    0    2    3    4    5    6    7    8    9   10   11   12   13   14   15 
##    4    8    9   17   21   45   26  166   71  161  209 2239  812 1134  522 
##   16   17   18   19   20   21   22   23   24   25   28 
## 2031  459  901  246  269  194   58   34   26   10   21
```

```r
histogram_discrete(ds, variable_name = "educ") 
```

<img src="figure/review-variables-map-Rmdsample-composition-1.png" title="plot of chunk sample-composition" alt="plot of chunk sample-composition" style="display: block; margin: auto;" />

```r
d <- ds %>% dplyr::group_by_("educ") %>% dplyr::summarize(count = n())
print(d, n=nrow(d))
```

```
## Source: local data frame [27 x 2]
## 
##     educ count
##    (int) (int)
## 1      0     4
## 2      2     8
## 3      3     9
## 4      4    17
## 5      5    21
## 6      6    45
## 7      7    26
## 8      8   166
## 9      9    71
## 10    10   161
## 11    11   209
## 12    12  2239
## 13    13   812
## 14    14  1134
## 15    15   522
## 16    16  2031
## 17    17   459
## 18    18   901
## 19    19   246
## 20    20   269
## 21    21   194
## 22    22    58
## 23    23    34
## 24    24    26
## 25    25    10
## 26    28    21
## 27    NA    15
```

```r
histogram_continuous(ds, variable_name = "age_at_visit", bin_width = 1)
```

<img src="figure/review-variables-map-Rmdsample-composition-2.png" title="plot of chunk sample-composition" alt="plot of chunk sample-composition" style="display: block; margin: auto;" />

```r
histogram_continuous(ds, variable_name = "educ",bin_width = 1)
```

<img src="figure/review-variables-map-Rmdsample-composition-3.png" title="plot of chunk sample-composition" alt="plot of chunk sample-composition" style="display: block; margin: auto;" />

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
## [1] msm_1.6.1     magrittr_1.5  nnet_7.3-12   ggplot2_2.1.0
## 
## loaded via a namespace (and not attached):
##  [1] deSolve_1.13        splines_3.2.4       lattice_0.20-33    
##  [4] mstate_0.2.9        colorspace_1.2-6    expm_0.999-0       
##  [7] flexsurv_0.7        chron_2.3-47        survival_2.38-3    
## [10] foreign_0.8-66      DBI_0.3.1           RColorBrewer_1.1-2 
## [13] muhaz_1.2.6         plyr_1.8.3          stringr_1.0.0      
## [16] munsell_0.4.3       gtable_0.2.0        mvtnorm_1.0-5      
## [19] evaluate_0.8.3      labeling_0.3        latticeExtra_0.6-28
## [22] knitr_1.12.3        extrafont_0.17      parallel_3.2.4     
## [25] markdown_0.7.7      Rttf2pt1_1.3.3      Rcpp_0.12.3        
## [28] acepack_1.3-3.3     scales_0.4.0        formatR_1.3        
## [31] Hmisc_3.17-2        gridExtra_2.2.1     testit_0.5         
## [34] stringi_1.0-1       dplyr_0.4.3         grid_3.2.4         
## [37] quadprog_1.5-5      tools_3.2.4         lazyeval_0.1.10    
## [40] dichromat_2.0-0     Formula_1.2-1       cluster_2.0.3      
## [43] extrafontdb_1.0     tidyr_0.4.1         Matrix_1.2-4       
## [46] rsconnect_0.3.79    data.table_1.9.6    assertthat_0.1     
## [49] R6_2.1.2            rpart_4.1-10
```

```r
Sys.time()
```

```
## [1] "2016-03-30 08:27:27 PDT"
```

