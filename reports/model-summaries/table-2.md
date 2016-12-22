# BISR: pulmonary
Date: `r Sys.Date()`  

<!--  Set the working directory to the repository's base directory; this assumes the report is nested inside of two directories.-->


<!-- Set the report-wide options, and point to the external code file. -->


<!-- Load the sources.  Suppress the output when loading sources. --> 


<!-- Load 'sourced' R files.  Suppress the output when loading packages. --> 


<!-- Load any global functions and variables declared in the R file.  Suppress the output. --> 


<!-- Declare any global functions specific to a Rmd output.  Suppress the output. --> 


<!-- Load the datasets.   -->




<!-- Tweak the datasets.   -->

```
[1] "age"     "male"    "edumed"  "eduhigh" "inkomen"
```

```
[1] "age"    "gender" "ses"    "dummy1" "dummy2"
```

```
[1] "age"          "male"         "edu_low_med"  "edu_low_high" "sescat"      
```

```
[1] "age"          "male"         "edu_cat_dum1" "edu_cat_dum2"
```



transition          predictor      lasa                lbc                 map                 wh                
------------------  -------------  ------------------  ------------------  ------------------  ------------------
State 1 - State 2   age            1.05 (1.04, 1.06)   1.14 (1.05, 1.24)   1.08 (1.07, 1.09)   1.02 (0.95, 1.09) 
State 1 - State 4   age            1.09 (1.07, 1.10)   1.18 (1.10, 1.27)   1.10 (1.07, 1.13)   1.14 (1.06, 1.22) 
State 2 - State 1   age            0.96 (0.95, 0.97)   0.99 (0.87, 1.12)   0.98 (0.96, 0.99)   0.91 (0.86, 0.96) 
State 2 - State 3   age            1.11 (1.09, 1.13)   1.22 (0.95, 1.57)   1.05 (1.02, 1.07)   1.15 (0.98, 1.36) 
State 2 - State 4   age            1.06 (1.03, 1.08)   1.19 (0.99, 1.44)   1.11 (1.04, 1.18)   1.12 (0.92, 1.36) 
State 3 - State 2   age            NA                  NA                  NA                  NA                
State 3 - State 4   age            1.05 (1.04, 1.07)   1.16 (1.02, 1.31)   1.06 (1.03, 1.09)   NA                
State 1 - State 2   edu_high_low   0.40 (0.32, 0.50)   0.70 (0.40, 1.22)   0.40 (0.29, 0.54)   0.51 (0.25, 1.02) 
State 1 - State 4   edu_high_low   0.92 (0.70, 1.20)   NA                  0.82 (0.21, 3.15)   NA                
State 2 - State 1   edu_high_low   NA                  NA                  NA                  NA                
State 2 - State 3   edu_high_low   1.09 (0.67, 1.77)   0.87 (0.27, 2.83)   1.33 (0.66, 2.66)   1.28 (0.22, 7.34) 
State 2 - State 4   edu_high_low   0.97 (0.51, 1.84)   NA                  1.13 (0.25, 4.97)   NA                
State 3 - State 2   edu_high_low   NA                  NA                  NA                  NA                
State 3 - State 4   edu_high_low   1.15 (0.76, 1.72)   NA                  0.77 (0.43, 1.39)   NA                
State 1 - State 2   edu_med_low    0.53 (0.45, 0.63)   0.68 (0.37, 1.26)   0.50 (0.30, 0.83)   0.48 (0.26, 0.91) 
State 1 - State 4   edu_med_low    0.94 (0.73, 1.20)   NA                  1.31 (0.26, 6.66)   NA                
State 2 - State 1   edu_med_low    NA                  NA                  NA                  NA                
State 2 - State 3   edu_med_low    0.92 (0.62, 1.36)   0.39 (0.09, 1.80)   2.39 (0.99, 5.80)   0.34 (0.06, 1.99) 
State 2 - State 4   edu_med_low    1.04 (0.66, 1.64)   NA                  0.84 (0.04,15.75)   NA                
State 3 - State 2   edu_med_low    NA                  NA                  NA                  NA                
State 3 - State 4   edu_med_low    1.33 (0.97, 1.83)   NA                  1.22 (0.54, 2.75)   NA                
State 1 - State 2   male           1.45 (1.26, 1.67)   1.12 (0.63, 1.99)   1.36 (1.17, 1.58)   0.89 (0.61, 1.29) 
State 1 - State 4   male           1.80 (1.44, 2.24)   0.51 (0.26, 0.99)   1.44 (0.94, 2.20)   0.99 (0.60, 1.64) 
State 2 - State 1   male           NA                  NA                  NA                  NA                
State 2 - State 3   male           1.04 (0.77, 1.39)   2.30 (0.54, 9.79)   0.87 (0.65, 1.17)   2.52 (0.69, 9.21) 
State 2 - State 4   male           1.95 (1.33, 2.84)   1.25 (0.24, 6.60)   1.74 (0.94, 3.25)   NA                
State 3 - State 2   male           NA                  NA                  NA                  NA                
State 3 - State 4   male           1.27 (1.02, 1.58)   1.05 (0.47, 2.37)   1.30 (0.98, 1.72)   NA                
State 1 - State 2   ses            0.79 (0.73, 0.86)   0.93 (0.61, 1.44)   0.90 (0.82, 0.99)   NA                
State 1 - State 4   ses            NA                  NA                  NA                  NA                
State 2 - State 1   ses            NA                  NA                  NA                  NA                
State 2 - State 3   ses            0.84 (0.72, 1.00)   0.69 (0.29, 1.64)   0.95 (0.79, 1.13)   NA                
State 2 - State 4   ses            NA                  NA                  NA                  NA                
State 3 - State 4   ses            NA                  NA                  NA                  NA                



# Session Information
For the sake of documentation and reproducibility, the current report was rendered on a system using the following software.


```
Report rendered by koval_000 at 2016-12-22, 09:39 -0500
```

```
R version 3.3.1 (2016-06-21)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows >= 8 x64 (build 9200)

locale:
[1] LC_COLLATE=English_United States.1252  LC_CTYPE=English_United States.1252    LC_MONETARY=English_United States.1252
[4] LC_NUMERIC=C                           LC_TIME=English_United States.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] knitr_1.14    ggplot2_2.2.0 nnet_7.3-12   msm_1.6.4     magrittr_1.5 

loaded via a namespace (and not attached):
 [1] Rcpp_0.12.7        RColorBrewer_1.1-2 formatR_1.4        plyr_1.8.4         highr_0.6          tools_3.3.1       
 [7] extrafont_0.17     digest_0.6.10      evaluate_0.10      tibble_1.2         gtable_0.2.0       lattice_0.20-34   
[13] Matrix_1.2-7.1     DBI_0.5-1          yaml_2.1.13        mvtnorm_1.0-5      expm_0.999-0       Rttf2pt1_1.3.4    
[19] dplyr_0.5.0        stringr_1.1.0      grid_3.3.1         R6_2.2.0           survival_2.39-5    readxl_0.1.1      
[25] rmarkdown_1.1      tidyr_0.6.0        extrafontdb_1.0    scales_0.4.1       htmltools_0.3.5    splines_3.3.1     
[31] rsconnect_0.5      assertthat_0.1     dichromat_2.0-0    testit_0.5         colorspace_1.2-7   stringi_1.1.2     
[37] lazyeval_0.2.0     munsell_0.4.3     
```
