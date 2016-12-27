# Hazard Ratios and 95% CI
Date: `r Sys.Date()`  

<!--  Set the working directory to the repository's base directory; this assumes the report is nested inside of two directories.-->


<!-- Set the report-wide options, and point to the external code file. -->


<!-- Load the sources.  Suppress the output when loading sources. --> 


<!-- Load 'sourced' R files.  Suppress the output when loading packages. --> 


<!-- Load any global functions and variables declared in the R file.  Suppress the output. --> 


<!-- Declare any global functions specific to a Rmd output.  Suppress the output. --> 


<!-- Load the datasets.   -->




<!-- Tweak the datasets.   -->







Transition          Predictor               OCTO-Twin
(N = 642)   LASA
(N = 2570)      Whitehall
(N = 1299)   H70
(N = 913)        LBC1921
(N = 415)    MAP
(N = 1449)     
------------------  ----------------------  --------------------  -------------------  ---------------------  -------------------  -------------------  -------------------
State 1 - State 2   Age                     1.12 (1.06, 1.17)*    1.05 (1.04, 1.06)*   1.02 (0.95, 1.09)      1.09 (0.98, 1.20)    1.14 (1.05, 1.24)*   1.08 (1.07, 1.09)* 
State 1 - State 4   Age                     1.16 (1.09, 1.23)*    1.09 (1.07, 1.10)*   1.14 (1.06, 1.22)*     1.08 (0.99, 1.18)    1.18 (1.10, 1.27)*   1.10 (1.07, 1.13)* 
State 2 - State 1   Age                     0.96 (0.88, 1.04)     0.96 (0.95, 0.97)*   0.91 (0.86, 0.96)*     1.16 (1.03, 1.30)*   0.99 (0.87, 1.12)    0.98 (0.96, 0.99)* 
State 2 - State 3   Age                     1.08 (1.04, 1.13)*    1.11 (1.09, 1.13)*   1.15 (0.98, 1.36)      1.13 (1.01, 1.27)*   1.22 (0.95, 1.57)    1.05 (1.02, 1.07)* 
State 2 - State 4   Age                     1.11 (0.98, 1.27)     1.06 (1.03, 1.08)*   1.12 (0.92, 1.36)      1.16 (1.00, 1.36)*   1.19 (0.99, 1.44)    1.11 (1.04, 1.18)* 
State 3 - State 4   Age                     1.05 (1.02, 1.07)*    1.05 (1.04, 1.07)*   ---                    1.00 (0.92, 1.10)    1.16 (1.02, 1.31)*   1.06 (1.03, 1.09)* 
State 1 - State 2   Sex                     1.45 (1.07, 1.94)*    1.45 (1.26, 1.67)*   0.89 (0.61, 1.29)      1.02 (0.70, 1.49)    1.12 (0.63, 1.99)    1.36 (1.17, 1.58)* 
State 1 - State 4   Sex                     1.45 (0.92, 2.29)     1.80 (1.44, 2.24)*   0.99 (0.60, 1.64)      1.98 (1.03, 3.82)*   0.51 (0.26, 0.99)*   1.44 (0.94, 2.20)  
State 2 - State 3   Sex                     1.42 (1.02, 1.97)*    1.04 (0.77, 1.39)    2.52 (0.69, 9.21)      1.21 (0.66, 2.22)    2.30 (0.54, 9.79)    0.87 (0.65, 1.17)  
State 2 - State 4   Sex                     0.61 (0.08, 4.86)     1.95 (1.33, 2.84)*   ---                    2.89 (0.97, 8.66)    1.25 (0.24, 6.60)    1.74 (0.94, 3.25)  
State 3 - State 4   Sex                     1.60 (1.25, 2.03)*    1.27 (1.02, 1.58)*   ---                    1.50 (0.85, 2.65)    1.05 (0.47, 2.37)    1.30 (0.98, 1.72)  
State 1 - State 2   Med vs Low Education    0.46 (0.22, 0.96)*    0.53 (0.45, 0.63)*   0.51 (0.25, 1.02)      0.88 (0.53, 1.46)    0.70 (0.40, 1.22)    0.50 (0.30, 0.83)* 
State 1 - State 4   Med vs Low Education    1.94 (1.09, 3.43)*    0.94 (0.73, 1.20)    ---                    0.94 (0.30, 2.93)    ---                  1.31 (0.26, 6.66)  
State 2 - State 3   Med vs Low Education    1.39 (0.65, 2.96)     0.92 (0.62, 1.36)    1.28 (0.22, 7.34)      1.83 (0.85, 3.91)    0.87 (0.27, 2.83)    2.39 (0.99, 5.80)  
State 2 - State 4   Med vs Low Education    ---                   1.04 (0.66, 1.64)    ---                    0.43 (0.03, 5.55)    ---                  0.84 (0.04,15.75)  
State 3 - State 4   Med vs Low Education    0.87 (0.48, 1.59)     1.33 (0.97, 1.83)    ---                    1.12 (0.52, 2.39)    ---                  1.22 (0.54, 2.75)  
State 1 - State 2   High vs Low Education   0.48 (0.25, 0.90)*    0.40 (0.32, 0.50)*   0.48 (0.26, 0.91)*     0.95 (0.57, 1.58)    0.68 (0.37, 1.26)    0.40 (0.29, 0.54)* 
State 1 - State 4   High vs Low Education   1.44 (0.82, 2.51)     0.92 (0.70, 1.20)    ---                    1.11 (0.49, 2.50)    ---                  0.82 (0.21, 3.15)  
State 2 - State 3   High vs Low Education   1.42 (0.65, 3.12)     1.09 (0.67, 1.77)    0.34 (0.06, 1.99)      1.55 (0.66, 3.66)    0.39 (0.09, 1.80)    1.33 (0.66, 2.66)  
State 2 - State 4   High vs Low Education   ---                   0.97 (0.51, 1.84)    ---                    0.36 (0.04, 3.19)    ---                  1.13 (0.25, 4.97)  
State 3 - State 4   High vs Low Education   1.56 (0.84, 2.91)     1.15 (0.76, 1.72)    ---                    0.80 (0.32, 1.98)    ---                  0.77 (0.43, 1.39)  
State 1 - State 2   SES                     0.94 (0.77, 1.15)     0.79 (0.73, 0.86)*   ---                    0.69 (0.51, 0.92)*   0.93 (0.61, 1.44)    0.90 (0.82, 0.99)* 
State 2 - State 3   SES                     0.88 (0.70, 1.11)     0.84 (0.72, 1.00)*   ---                    0.70 (0.40, 1.22)    0.69 (0.29, 1.64)    0.95 (0.79, 1.13)  

```


 Age


Transition          OCTO-Twin
(N = 642)   LASA
(N = 2570)      Whitehall
(N = 1299)   H70
(N = 913)        LBC1921
(N = 415)    MAP
(N = 1449)     
------------------  --------------------  -------------------  ---------------------  -------------------  -------------------  -------------------
State 1 - State 2   1.12 (1.06, 1.17)*    1.05 (1.04, 1.06)*   1.02 (0.95, 1.09)      1.09 (0.98, 1.20)    1.14 (1.05, 1.24)*   1.08 (1.07, 1.09)* 
State 1 - State 4   1.16 (1.09, 1.23)*    1.09 (1.07, 1.10)*   1.14 (1.06, 1.22)*     1.08 (0.99, 1.18)    1.18 (1.10, 1.27)*   1.10 (1.07, 1.13)* 
State 2 - State 1   0.96 (0.88, 1.04)     0.96 (0.95, 0.97)*   0.91 (0.86, 0.96)*     1.16 (1.03, 1.30)*   0.99 (0.87, 1.12)    0.98 (0.96, 0.99)* 
State 2 - State 3   1.08 (1.04, 1.13)*    1.11 (1.09, 1.13)*   1.15 (0.98, 1.36)      1.13 (1.01, 1.27)*   1.22 (0.95, 1.57)    1.05 (1.02, 1.07)* 
State 2 - State 4   1.11 (0.98, 1.27)     1.06 (1.03, 1.08)*   1.12 (0.92, 1.36)      1.16 (1.00, 1.36)*   1.19 (0.99, 1.44)    1.11 (1.04, 1.18)* 
State 3 - State 4   1.05 (1.02, 1.07)*    1.05 (1.04, 1.07)*   ---                    1.00 (0.92, 1.10)    1.16 (1.02, 1.31)*   1.06 (1.03, 1.09)* 

 Age

                                                                                                                                                
------------------  -------------------  -------------------  -------------------  -------------------  -------------------  -------------------
State 1 - State 2   1.12 (1.06, 1.17)*   1.05 (1.04, 1.06)*   1.02 (0.95, 1.09)    1.09 (0.98, 1.20)    1.14 (1.05, 1.24)*   1.08 (1.07, 1.09)* 
State 1 - State 4   1.16 (1.09, 1.23)*   1.09 (1.07, 1.10)*   1.14 (1.06, 1.22)*   1.08 (0.99, 1.18)    1.18 (1.10, 1.27)*   1.10 (1.07, 1.13)* 
State 2 - State 1   0.96 (0.88, 1.04)    0.96 (0.95, 0.97)*   0.91 (0.86, 0.96)*   1.16 (1.03, 1.30)*   0.99 (0.87, 1.12)    0.98 (0.96, 0.99)* 
State 2 - State 3   1.08 (1.04, 1.13)*   1.11 (1.09, 1.13)*   1.15 (0.98, 1.36)    1.13 (1.01, 1.27)*   1.22 (0.95, 1.57)    1.05 (1.02, 1.07)* 
State 2 - State 4   1.11 (0.98, 1.27)    1.06 (1.03, 1.08)*   1.12 (0.92, 1.36)    1.16 (1.00, 1.36)*   1.19 (0.99, 1.44)    1.11 (1.04, 1.18)* 
State 3 - State 4   1.05 (1.02, 1.07)*   1.05 (1.04, 1.07)*   ---                  1.00 (0.92, 1.10)    1.16 (1.02, 1.31)*   1.06 (1.03, 1.09)* 
------------------  -------------------  -------------------  -------------------  -------------------  -------------------  -------------------



 Sex

 Sex

                                                                                                                                               
------------------  -------------------  -------------------  ------------------  -------------------  -------------------  -------------------
State 1 - State 2   1.45 (1.07, 1.94)*   1.45 (1.26, 1.67)*   0.89 (0.61, 1.29)   1.02 (0.70, 1.49)    1.12 (0.63, 1.99)    1.36 (1.17, 1.58)* 
State 1 - State 4   1.45 (0.92, 2.29)    1.80 (1.44, 2.24)*   0.99 (0.60, 1.64)   1.98 (1.03, 3.82)*   0.51 (0.26, 0.99)*   1.44 (0.94, 2.20)  
State 2 - State 3   1.42 (1.02, 1.97)*   1.04 (0.77, 1.39)    2.52 (0.69, 9.21)   1.21 (0.66, 2.22)    2.30 (0.54, 9.79)    0.87 (0.65, 1.17)  
State 2 - State 4   0.61 (0.08, 4.86)    1.95 (1.33, 2.84)*   ---                 2.89 (0.97, 8.66)    1.25 (0.24, 6.60)    1.74 (0.94, 3.25)  
State 3 - State 4   1.60 (1.25, 2.03)*   1.27 (1.02, 1.58)*   ---                 1.50 (0.85, 2.65)    1.05 (0.47, 2.37)    1.30 (0.98, 1.72)  
------------------  -------------------  -------------------  ------------------  -------------------  -------------------  -------------------



 Med vs Low Education

 Med vs Low Education

                                                                                                                                             
------------------  -------------------  -------------------  ------------------  ------------------  ------------------  -------------------
State 1 - State 2   0.46 (0.22, 0.96)*   0.53 (0.45, 0.63)*   0.51 (0.25, 1.02)   0.88 (0.53, 1.46)   0.70 (0.40, 1.22)   0.50 (0.30, 0.83)* 
State 1 - State 4   1.94 (1.09, 3.43)*   0.94 (0.73, 1.20)    ---                 0.94 (0.30, 2.93)   ---                 1.31 (0.26, 6.66)  
State 2 - State 3   1.39 (0.65, 2.96)    0.92 (0.62, 1.36)    1.28 (0.22, 7.34)   1.83 (0.85, 3.91)   0.87 (0.27, 2.83)   2.39 (0.99, 5.80)  
State 2 - State 4   ---                  1.04 (0.66, 1.64)    ---                 0.43 (0.03, 5.55)   ---                 0.84 (0.04,15.75)  
State 3 - State 4   0.87 (0.48, 1.59)    1.33 (0.97, 1.83)    ---                 1.12 (0.52, 2.39)   ---                 1.22 (0.54, 2.75)  
------------------  -------------------  -------------------  ------------------  ------------------  ------------------  -------------------



 High vs Low Education

 High vs Low Education

                                                                                                                                              
------------------  -------------------  -------------------  -------------------  ------------------  ------------------  -------------------
State 1 - State 2   0.48 (0.25, 0.90)*   0.40 (0.32, 0.50)*   0.48 (0.26, 0.91)*   0.95 (0.57, 1.58)   0.68 (0.37, 1.26)   0.40 (0.29, 0.54)* 
State 1 - State 4   1.44 (0.82, 2.51)    0.92 (0.70, 1.20)    ---                  1.11 (0.49, 2.50)   ---                 0.82 (0.21, 3.15)  
State 2 - State 3   1.42 (0.65, 3.12)    1.09 (0.67, 1.77)    0.34 (0.06, 1.99)    1.55 (0.66, 3.66)   0.39 (0.09, 1.80)   1.33 (0.66, 2.66)  
State 2 - State 4   ---                  0.97 (0.51, 1.84)    ---                  0.36 (0.04, 3.19)   ---                 1.13 (0.25, 4.97)  
State 3 - State 4   1.56 (0.84, 2.91)    1.15 (0.76, 1.72)    ---                  0.80 (0.32, 1.98)   ---                 0.77 (0.43, 1.39)  
------------------  -------------------  -------------------  -------------------  ------------------  ------------------  -------------------



 SES

 SES

                                                                                                                               
------------------  ------------------  -------------------  ----  -------------------  ------------------  -------------------
State 1 - State 2   0.94 (0.77, 1.15)   0.79 (0.73, 0.86)*   ---   0.69 (0.51, 0.92)*   0.93 (0.61, 1.44)   0.90 (0.82, 0.99)* 
State 2 - State 3   0.88 (0.70, 1.11)   0.84 (0.72, 1.00)*   ---   0.70 (0.40, 1.22)    0.69 (0.29, 1.64)   0.95 (0.79, 1.13)  
------------------  ------------------  -------------------  ----  -------------------  ------------------  -------------------
```



# Session Information
For the sake of documentation and reproducibility, the current report was rendered on a system using the following software.


```
Report rendered by koval_000 at 2016-12-23, 13:48 -0500
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
[1] knitr_1.14    msm_1.6.4     magrittr_1.5  ggplot2_2.2.0

loaded via a namespace (and not attached):
 [1] Rcpp_0.12.7        formatR_1.4        RColorBrewer_1.1-2 plyr_1.8.4         highr_0.6          tools_3.3.1       
 [7] extrafont_0.17     digest_0.6.10      jsonlite_1.1       evaluate_0.10      tibble_1.2         gtable_0.2.0      
[13] lattice_0.20-34    Matrix_1.2-7.1     DBI_0.5-1          yaml_2.1.13        mvtnorm_1.0-5      expm_0.999-0      
[19] Rttf2pt1_1.3.4     dplyr_0.5.0        stringr_1.1.0      htmlwidgets_0.7    grid_3.3.1         DT_0.2            
[25] R6_2.2.0           readxl_0.1.1       survival_2.39-5    rmarkdown_1.1      tidyr_0.6.0        extrafontdb_1.0   
[31] scales_0.4.1       htmltools_0.3.5    splines_3.3.1      rsconnect_0.5      assertthat_0.1     dichromat_2.0-0   
[37] testit_0.5         colorspace_1.2-7   stringi_1.1.2      lazyeval_0.2.0     munsell_0.4.3     
```