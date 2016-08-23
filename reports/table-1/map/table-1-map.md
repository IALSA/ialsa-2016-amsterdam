# MAP: initial variable review

<!-- These two chunks should be added in the beginning of every .Rmd that you want to source an .R script -->
<!--  The 1st mandatory chunck  -->
<!--  Set the working directory to the repository's base directory -->


<!--  The 2nd mandatory chunck  -->
<!-- Set the report-wide options, and point to the external code file. -->


# Environment

## Load environment
<!-- Load 'sourced' R files.  Suppress the output when loading packages. --> 

```r
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
```


<!-- Load the sources.  Suppress the output when loading sources. --> 

```r
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
```


<!-- Load any Global functions and variables declared in the R file.  Suppress the output. --> 


<!-- Declare any global functions specific to a Rmd output.  Suppress the output. --> 

```r
#Put code in here.  It doesn't call a chunk in the codebehind file.
```

## Load data
<!-- Load the datasets.   -->

```r
# # load the object prepared by ./manipulation/map/2-estimate-models.R en route estimation
# ds <- readRDS("./data/unshared/derived/ds_clean-map.rds")

# load the product of 0-ellis-island.R,  a list object containing data and metadata
# data_path_input  <- "../MAP/data-unshared/derived/ds0.rds" # original 
dto <- readRDS("./data/unshared/derived/dto.rds") # local copy
# each element this list is another list:
names(dto)
# 3rd element - data set with unit data. Inspect the names of variables:
names(dto[["unitData"]])
# 4th element - dataset with augmented names and labels of the unit data
knitr::kable(head(dto[["metaData"]]))
# assing aliases
ds0 <- dto[["unitData"]]
```

## Tweak data
<!-- Tweak the datasets.   -->

```r
ds <- ds0 %>%  # to leave a clean copy of the ds, before any manipulation takes place
  dplyr::mutate(
    age_bl    = as.numeric(age_bl),
    age_death = as.numeric(age_death), 
    male      = as.logical(ifelse(!is.na(msex), msex=="1", NA_integer_)),
    edu       = as.numeric(educ)
  ) %>% 
  dplyr::select_(
    "id",
    "fu_year",
    "died",
    "age_bl",
    "male",
    "edu",
    "age_death",
    "age_at_visit",
    "mmse") 
```
Keep only observation with non-missing age


```r
# remove the observation with missing age
sum(is.na(ds$age_at_visit)) # count obs with missing age
```

```
[1] 1
```

```r
# ds_miss %>% 
ds %>% 
  dplyr::group_by(id) %>% 
  dplyr::summarize(n_data_points = n()) %>% 
  dplyr::group_by(n_data_points) %>% 
  dplyr::summarize(n_people=n())
```

```
# A tibble: 17 x 2
   n_data_points n_people
           <int>    <int>
1              1      194
2              2      200
3              3      193
4              4      181
5              5      176
6              6      104
7              7      108
8              8       99
9              9      122
10            10      101
11            11      100
12            12       64
13            13       18
14            14       10
15            15        8
16            16       17
17            17        1
```

```r
# remove ids with a single data point
remove_ids <- ds %>% 
  dplyr::group_by(id) %>% 
  dplyr::summarize(n_data_points = n()) %>% 
  dplyr::arrange(n_data_points) %>% 
  dplyr::filter(n_data_points==1) %>% 
  dplyr::select(id)
remove_ids <- remove_ids$id
length(remove_ids) # number of ids to remove
```

```
[1] 194
```

```r
ds_clean <- ds %>% 
  dplyr::filter(!(id %in% remove_ids))
```

Split education into categories

```r
ds_clean$educat <- cut(
  ds_clean$edu, 
  breaks = c(0, 9, 11, Inf), 
  labels = c("0-9 years", "10-11 years", ">11 years")
)
```

Split MMSE into categories

```r
ds_clean$impairment <- cut(
  ds_clean$mmse,
  breaks = c(0, 23, 26, Inf),
  labels = c("Moderate to severe", "Mild Impairment", "No Impairment")
)
```

## Define functions

```r
basic_stats <- function(ds,measure_name, precision=1, remove_na = T){
  a <- lazyeval::interp(~ round(mean(var, na.rm=remove_na),precision) , var = as.name(measure_name))
  b <- lazyeval::interp(~ round(sd(var, na.rm=remove_na),precision),   var = as.name(measure_name))
  c <- lazyeval::interp(~ n())
  (dots <- list(a,b,c))
  cat("Descriptives for:", measure_name,"\n\n")
  cat("Entire sample: \n\n")
  d <- ds %>% 
    dplyr::filter(fu_year == 0) # select obs at baseline
  
  d1 <- d %>% 
    dplyr::select_(measure_name) %>% 
    dplyr::summarize_(.dots = setNames(dots, c("mean","sd","count")))
  print(d1)
  cat("\n Split up by eductaion:")
  d2 <- d %>% 
    dplyr::select_(measure_name, "educat") %>% 
    dplyr::group_by(educat) %>% 
    dplyr::summarize_(.dots = setNames(dots, c("mean","sd","count")))
  print(knitr::kable(d2), showEnv = F)
}
# basic_stats(ds,"age_bl")

basic_freqs <- function(ds, measure_name, precision = 2){ 
  # ds <- ds_clean
  (counts <- table(ds[ds$fu_year==0,measure_name], useNA = "always")) 
  (sample_size <- length(unique(ds$id)))
  (percent <- round(counts/sample_size*100,precision)) 
  (t <- cbind(counts, percent))
  (t <-stats::addmargins(t))
  # (t <- t[!rownames(t) == "Sum", ]) 
  (t <- t[,!colnames(t) == "Sum"])
  print(knitr::kable(t))
} 
# basic_freqs(ds_clean,"male")

split_freqs <- function(ds, measure_name, precision = 4){
  d <- ds[ds$fu_year==0,]
  head(d)
  (counts <- table(d[,"educat"],d[,measure_name], useNA = "always")) 
  (sample_size <- length(unique(ds$id)))
  (percent <- round(counts/sample_size*100, precision))
  (t <- cbind(counts, percent))
  (t <-stats::addmargins(t))
  (t <- t[,!colnames(t) == "Sum"])
  print(knitr::kable(t))
}
# split_freqs(ds_clean, "male")
```


# Descriptives


## Age

```r
basic_stats(ds_clean,"age_bl",precision = 1, remove_na = T)
```

```
Descriptives for: age_bl 

Entire sample: 

  mean  sd count
1 79.8 7.5  1502

 Split up by eductaion:

educat         mean    sd   count
------------  -----  ----  ------
0-9 years      77.8   8.8      67
10-11 years    79.6   7.6      57
>11 years      79.9   7.4    1376
NA             77.5   8.6       2
```

## Sex

```r
basic_freqs(ds_clean, "male", precision = 2)
```

```

         counts   percent
------  -------  --------
FALSE      1111     73.97
TRUE        391     26.03
NA            0      0.00
Sum        1502    100.00
```

```r
split_freqs(ds_clean, "male", precision = 2)
```

```

               FALSE   TRUE   NA   FALSE    TRUE   NA
------------  ------  -----  ---  ------  ------  ---
0-9 years         51     16   NA    3.40    1.07   NA
10-11 years       45     12   NA    3.00    0.80   NA
>11 years       1014    362   NA   67.51   24.10   NA
NA                 1      1   NA    0.07    0.07   NA
Sum             1111    391   NA   73.98   26.04   NA
```

## Education 

```r
# basic_stats(ds_clean, "edu", precision = 2, remove_na = T)
basic_freqs(ds_clean, "educat", precision = 2)
```

```

               counts   percent
------------  -------  --------
0-9 years          67      4.46
10-11 years        57      3.79
>11 years        1376     91.61
NA                  2      0.13
Sum              1502     99.99
```

## MMSE


```r
# basic_stats(ds_clean, "mmse", precision = 2, remove_na = T)
basic_freqs(ds_clean, "impairment", precision = 2)
```

```

                      counts   percent
-------------------  -------  --------
Moderate to severe       110      7.32
Mild Impairment          230     15.31
No Impairment           1159     77.16
NA                         3      0.20
Sum                     1502     99.99
```

```r
split_freqs(ds_clean, "impairment", precision = 2)
```

```

               Moderate to severe   Mild Impairment   No Impairment   NA   Moderate to severe   Mild Impairment   No Impairment   NA
------------  -------------------  ----------------  --------------  ---  -------------------  ----------------  --------------  ---
0-9 years                      15                23              29   NA                 1.00              1.53            1.93   NA
10-11 years                     4                14              38   NA                 0.27              0.93            2.53   NA
>11 years                      91               191            1092   NA                 6.06             12.72           72.70   NA
NA                              0                 2               0   NA                 0.00              0.13            0.00   NA
Sum                           110               230            1159   NA                 7.33             15.31           77.16   NA
```

