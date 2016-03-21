



This report was automatically generated with the R package **knitr**
(version 1.12.3).


```r
# knitr::stitch_rmd(script="./reports/vignette-ELECT/vignette-ELECT.R", output="./reports/vignette-ELECT/vignette-ELECT.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 
```



```r
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
base::source("./scripts/common-functions.R") # used in multiple reports
base::source("./scripts/graph-presets.R") # fonts, colors, themes 
base::source("http://www.ucl.ac.uk/~ucakadl/ELECT.r") # load  ELECT functions
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
requireNamespace("msm") # multistate modeling
```

```
## Loading required namespace: msm
```

```r
requireNamespace("flexsurv") # parameteric survival and multi-state
```

```
## Loading required namespace: flexsurv
```

```r
requireNamespace("mstate") # multistate modeling
```

```
## Loading required namespace: mstate
```

```r
requireNamespace("foreign") # data input
```

```r
# load the data file used in Example 1 of the official ELECT vignette
path_data_example_i <- "./data/shared/raw/dataExample1.RData"
```

```r
load(path_data_example_i)
ds <- dplyr::tbl_df(data)
```

```r
ds
```

```
## Source: local data frame [10,171 x 4]
## 
##       id state   age ybirth
##    (dbl) (dbl) (dbl)  (dbl)
## 1      1     1  2.90     22
## 2      1     3  4.53     22
## 3      2     1  3.50     18
## 4      2     3  5.09     18
## 5      3     1 -0.50     19
## 6      3     1  1.50     19
## 7      3     1  3.50     19
## 8      3     1  5.50     19
## 9      3     2  7.50     19
## 10     3     3  8.64     19
## ..   ...   ...   ...    ...
```

```r
ds %>% dplyr::filter(id %in% c("4","99"))
```

```
## Source: local data frame [11 x 4]
## 
##       id state   age ybirth
##    (dbl) (dbl) (dbl)  (dbl)
## 1      4     1 -2.30     21
## 2      4     2 -0.30     21
## 3      4     1  1.70     21
## 4      4     1  3.70     21
## 5      4     1  5.70     21
## 6      4     1  7.70     21
## 7      4    -2  9.70     21
## 8     99     1 -3.00     12
## 9     99     1 -1.00     12
## 10    99     2  1.00     12
## 11    99     3  2.99     12
```


The R session information (including the OS info, R version and all
packages used):


```r
sessionInfo()
```

```
## R version 3.2.3 (2015-12-10)
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
## [1] magrittr_1.5  nnet_7.3-12   ggplot2_2.1.0
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.3        Rttf2pt1_1.3.3     knitr_1.12.3      
##  [4] munsell_0.4.3      testit_0.5         colorspace_1.2-6  
##  [7] R6_2.1.2           stringr_1.0.0      plyr_1.8.3        
## [10] dplyr_0.4.3        tools_3.2.3        parallel_3.2.3    
## [13] dichromat_2.0-0    grid_3.2.3         gtable_0.2.0      
## [16] DBI_0.3.1          extrafontdb_1.0    lazyeval_0.1.10   
## [19] assertthat_0.1     formatR_1.3        RColorBrewer_1.1-2
## [22] tidyr_0.4.1        evaluate_0.8.3     stringi_1.0-1     
## [25] scales_0.4.0       extrafont_0.17     markdown_0.7.7    
## [28] foreign_0.8-66
```

```r
Sys.time()
```

```
## [1] "2016-03-19 09:12:30 PDT"
```

