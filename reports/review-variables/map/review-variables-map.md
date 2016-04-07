



This report was automatically generated with the R package **knitr**
(version 1.12.3).


```r
# knitr::stitch_rmd(script="./reports/review-variables/map/review-variables.R", output="./reports/review-variables/map/review-variables.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 
```



```r
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
```

```r
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
# requireNamespace("readr") # data input
requireNamespace("tidyr") # data manipulation
requireNamespace("dplyr") # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")# For asserting conditions meet expected patterns.
# requireNamespace("car") # For it's `recode()` function.
```


```r
# load the product of 0-ellis-island.R,  a list object containing data and metadata
dto <- readRDS("./data/unshared/derived/dto.rds")
# each element this list is another list:
names(dto)
```

```
## [1] "unitData" "metaData"
```

```r
# 3rd element - data set with unit data
dplyr::tbl_df(dto[["unitData"]]) 
```

```
## Source: local data frame [9,708 x 27]
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
## Variables not shown: cogn_global (dbl), iadlsum (int), cts_mmse30 (dbl),
##   cts_catflu (int), dementia (int), bmi (dbl), phys5itemsum (dbl),
##   q3smo_bl (int), q4smo_bl (int), smoke_bl (int), smoking (int), ldai_bl
##   (dbl), dm_cum (int), hypertension_cum (int), stroke_cum (int), r_stroke
##   (int), katzsum (int), rosbscl (int)
```

```r
# 4th element - dataset with augmented names and labels of the unit data
dplyr::tbl_df(dto[["metaData"]])
```

```
## Source: local data frame [113 x 9]
## 
##                     name                     label        type
##                   (fctr)                    (fctr)      (fctr)
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
## Variables not shown: name_new (fctr), construct (fctr), self_reported
##   (lgl), longitudinal (lgl), unit (fctr), include (lgl)
```

```r
# assing aliases
ds0 <- dto[["unitData"]]
ds <- ds0
```

```r
dto[["metaData"]] %>%  
  DT::datatable(
    class   = 'cell-border stripe',
    caption = "This is a dynamic table of the metadata file. Edit at `./data/meta/map/meta-data-map.csv",
    filter  = "top",
    options = list(pageLength = 6, autoWidth = TRUE)
  )
```

<!--html_preserve--><div id="htmlwidget-748" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-748">{"x":{"filter":"top","filterHTML":"<tr>\n  <td>\u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"age_at_visit\">age_at_visit\u003c/option>\n        <option value=\"age_bl\">age_bl\u003c/option>\n        <option value=\"age_death\">age_death\u003c/option>\n        <option value=\"agreeableness\">agreeableness\u003c/option>\n        <option value=\"alcohol_g\">alcohol_g\u003c/option>\n        <option value=\"anxiety_10items\">anxiety_10items\u003c/option>\n        <option value=\"apoe_genotype\">apoe_genotype\u003c/option>\n        <option value=\"bmi\">bmi\u003c/option>\n        <option value=\"bp11\">bp11\u003c/option>\n        <option value=\"bp2\">bp2\u003c/option>\n        <option value=\"bp3\">bp3\u003c/option>\n        <option value=\"bp31\">bp31\u003c/option>\n        <option value=\"bun\">bun\u003c/option>\n        <option value=\"ca\">ca\u003c/option>\n        <option value=\"cesdsum\">cesdsum\u003c/option>\n        <option value=\"chf_cum\">chf_cum\u003c/option>\n        <option value=\"chlstrl\">chlstrl\u003c/option>\n        <option value=\"cl\">cl\u003c/option>\n        <option value=\"claudication_cum\">claudication_cum\u003c/option>\n        <option value=\"co2\">co2\u003c/option>\n        <option value=\"cogn_ep\">cogn_ep\u003c/option>\n        <option value=\"cogn_global\">cogn_global\u003c/option>\n        <option value=\"cogn_po\">cogn_po\u003c/option>\n        <option value=\"cogn_ps\">cogn_ps\u003c/option>\n        <option value=\"cogn_se\">cogn_se\u003c/option>\n        <option value=\"cogn_wo\">cogn_wo\u003c/option>\n        <option value=\"conscientiousness\">conscientiousness\u003c/option>\n        <option value=\"crn\">crn\u003c/option>\n        <option value=\"cts_bname\">cts_bname\u003c/option>\n        <option value=\"cts_catflu\">cts_catflu\u003c/option>\n        <option value=\"cts_db\">cts_db\u003c/option>\n        <option value=\"cts_delay\">cts_delay\u003c/option>\n        <option value=\"cts_df\">cts_df\u003c/option>\n        <option value=\"cts_doperf\">cts_doperf\u003c/option>\n        <option value=\"cts_ebdr\">cts_ebdr\u003c/option>\n        <option value=\"cts_ebmt\">cts_ebmt\u003c/option>\n        <option value=\"cts_idea\">cts_idea\u003c/option>\n        <option value=\"cts_lopair\">cts_lopair\u003c/option>\n        <option value=\"cts_mmse30\">cts_mmse30\u003c/option>\n        <option value=\"cts_nccrtd\">cts_nccrtd\u003c/option>\n        <option value=\"cts_pmat\">cts_pmat\u003c/option>\n        <option value=\"cts_read_nart\">cts_read_nart\u003c/option>\n        <option value=\"cts_read_wrat\">cts_read_wrat\u003c/option>\n        <option value=\"cts_sdmt\">cts_sdmt\u003c/option>\n        <option value=\"cts_story\">cts_story\u003c/option>\n        <option value=\"cts_wli\">cts_wli\u003c/option>\n        <option value=\"cts_wlii\">cts_wlii\u003c/option>\n        <option value=\"cts_wliii\">cts_wliii\u003c/option>\n        <option value=\"dcfdx\">dcfdx\u003c/option>\n        <option value=\"dementia\">dementia\u003c/option>\n        <option value=\"died\">died\u003c/option>\n        <option value=\"dm_cum\">dm_cum\u003c/option>\n        <option value=\"educ\">educ\u003c/option>\n        <option value=\"extraversion\">extraversion\u003c/option>\n        <option value=\"fasting\">fasting\u003c/option>\n        <option value=\"fev\">fev\u003c/option>\n        <option value=\"fu_year\">fu_year\u003c/option>\n        <option value=\"gait_speed\">gait_speed\u003c/option>\n        <option value=\"glucose\">glucose\u003c/option>\n        <option value=\"gripavg\">gripavg\u003c/option>\n        <option value=\"hba1c\">hba1c\u003c/option>\n        <option value=\"hdlchlstrl\">hdlchlstrl\u003c/option>\n        <option value=\"hdlratio\">hdlratio\u003c/option>\n        <option value=\"heart_cum\">heart_cum\u003c/option>\n        <option value=\"htm\">htm\u003c/option>\n        <option value=\"hypertension_cum\">hypertension_cum\u003c/option>\n        <option value=\"iadlsum\">iadlsum\u003c/option>\n        <option value=\"id\">id\u003c/option>\n        <option value=\"intrusion\">intrusion\u003c/option>\n        <option value=\"k\">k\u003c/option>\n        <option value=\"katzsum\">katzsum\u003c/option>\n        <option value=\"ldai_bl\">ldai_bl\u003c/option>\n        <option value=\"ldlchlstrl\">ldlchlstrl\u003c/option>\n        <option value=\"mep\">mep\u003c/option>\n        <option value=\"mip\">mip\u003c/option>\n        <option value=\"msex\">msex\u003c/option>\n        <option value=\"na\">na\u003c/option>\n        <option value=\"neglifeevents\">neglifeevents\u003c/option>\n        <option value=\"negsocexchange\">negsocexchange\u003c/option>\n        <option value=\"neo_altruism\">neo_altruism\u003c/option>\n        <option value=\"neo_conscientiousness\">neo_conscientiousness\u003c/option>\n        <option value=\"neo_trust\">neo_trust\u003c/option>\n        <option value=\"neuroticism_12\">neuroticism_12\u003c/option>\n        <option value=\"neuroticism_6\">neuroticism_6\u003c/option>\n        <option value=\"nohelp\">nohelp\u003c/option>\n        <option value=\"openness\">openness\u003c/option>\n        <option value=\"panas\">panas\u003c/option>\n        <option value=\"perceivedstress\">perceivedstress\u003c/option>\n        <option value=\"phys5itemsum\">phys5itemsum\u003c/option>\n        <option value=\"pvc\">pvc\u003c/option>\n        <option value=\"q3smo_bl\">q3smo_bl\u003c/option>\n        <option value=\"q4smo_bl\">q4smo_bl\u003c/option>\n        <option value=\"r_depres\">r_depres\u003c/option>\n        <option value=\"r_stroke\">r_stroke\u003c/option>\n        <option value=\"race\">race\u003c/option>\n        <option value=\"rejection\">rejection\u003c/option>\n        <option value=\"rosbscl\">rosbscl\u003c/option>\n        <option value=\"rosbsum\">rosbsum\u003c/option>\n        <option value=\"scaled_to.x\">scaled_to.x\u003c/option>\n        <option value=\"scaled_to.y\">scaled_to.y\u003c/option>\n        <option value=\"smoke_bl\">smoke_bl\u003c/option>\n        <option value=\"smoking\">smoking\u003c/option>\n        <option value=\"spanish\">spanish\u003c/option>\n        <option value=\"stroke_cum\">stroke_cum\u003c/option>\n        <option value=\"study\">study\u003c/option>\n        <option value=\"thyroid_cum\">thyroid_cum\u003c/option>\n        <option value=\"unsympathetic\">unsympathetic\u003c/option>\n        <option value=\"vasc_3dis_sum\">vasc_3dis_sum\u003c/option>\n        <option value=\"vasc_4dis_sum\">vasc_4dis_sum\u003c/option>\n        <option value=\"vasc_risks_sum\">vasc_risks_sum\u003c/option>\n        <option value=\"vision\">vision\u003c/option>\n        <option value=\"visionlog\">visionlog\u003c/option>\n        <option value=\"wtkg\">wtkg\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"Age at baseline\">Age at baseline\u003c/option>\n        <option value=\"Age at cycle - fractional\">Age at cycle - fractional\u003c/option>\n        <option value=\"Age at death\">Age at death\u003c/option>\n        <option value=\"Anxiety-10 item version - ROS and MAP\">Anxiety-10 item version - ROS and MAP\u003c/option>\n        <option value=\"ApoE genotype\">ApoE genotype\u003c/option>\n        <option value=\"Blood pressure measurement- sitting - trial 1\">Blood pressure measurement- sitting - trial 1\u003c/option>\n        <option value=\"Blood pressure measurement- sitting - trial 2\">Blood pressure measurement- sitting - trial 2\u003c/option>\n        <option value=\"Blood pressure measurement- standing\">Blood pressure measurement- standing\u003c/option>\n        <option value=\"Blood urea nitrogen\">Blood urea nitrogen\u003c/option>\n        <option value=\"Body mass index\">Body mass index\u003c/option>\n        <option value=\"Boston naming - 2014\">Boston naming - 2014\u003c/option>\n        <option value=\"Calcium\">Calcium\u003c/option>\n        <option value=\"Calculated domain score-episodic memory\">Calculated domain score-episodic memory\u003c/option>\n        <option value=\"Calculated domain score - perceptual orientation\">Calculated domain score - perceptual orientation\u003c/option>\n        <option value=\"Calculated domain score - perceptual speed\">Calculated domain score - perceptual speed\u003c/option>\n        <option value=\"Calculated domain score - semantic memory\">Calculated domain score - semantic memory\u003c/option>\n        <option value=\"Calculated domain score - working memory\">Calculated domain score - working memory\u003c/option>\n        <option value=\"Carbon Dioxide\">Carbon Dioxide\u003c/option>\n        <option value=\"Category fluency - 2014\">Category fluency - 2014\u003c/option>\n        <option value=\"CESD-Measure of depressive symptoms\">CESD-Measure of depressive symptoms\u003c/option>\n        <option value=\"Chloride\">Chloride\u003c/option>\n        <option value=\"Cholesterol\">Cholesterol\u003c/option>\n        <option value=\"Clinical Diagnoses - Stroke - cumulative\">Clinical Diagnoses - Stroke - cumulative\u003c/option>\n        <option value=\"Clinical dx summary\">Clinical dx summary\u003c/option>\n        <option value=\"Clinical stroke dx\">Clinical stroke dx\u003c/option>\n        <option value=\"Complex ideas - 2014\">Complex ideas - 2014\u003c/option>\n        <option value=\"Conscientiousness-ROS/MAP\">Conscientiousness-ROS/MAP\u003c/option>\n        <option value=\"Creatinine\">Creatinine\u003c/option>\n        <option value=\"Dementia diagnosis\">Dementia diagnosis\u003c/option>\n        <option value=\"Digit ordering - 2014\">Digit ordering - 2014\u003c/option>\n        <option value=\"Digits backwards - 2014\">Digits backwards - 2014\u003c/option>\n        <option value=\"Digits forwards - 2014\">Digits forwards - 2014\u003c/option>\n        <option value=\"East Boston story - delayed recall - 2014\">East Boston story - delayed recall - 2014\u003c/option>\n        <option value=\"East Boston story - immediate - 2014\">East Boston story - immediate - 2014\u003c/option>\n        <option value=\"Extremity strength\">Extremity strength\u003c/option>\n        <option value=\"Follow-up year\">Follow-up year\u003c/option>\n        <option value=\"forced expiratory volume\">forced expiratory volume\u003c/option>\n        <option value=\"Gait Speed - MAP\">Gait Speed - MAP\u003c/option>\n        <option value=\"Gender\">Gender\u003c/option>\n        <option value=\"Global cognitive score\">Global cognitive score\u003c/option>\n        <option value=\"Glucose\">Glucose\u003c/option>\n        <option value=\"Grams of alcohol per day\">Grams of alcohol per day\u003c/option>\n        <option value=\"HDL cholesterol\">HDL cholesterol\u003c/option>\n        <option value=\"HDL ratio\">HDL ratio\u003c/option>\n        <option value=\"Height(meters)\">Height(meters)\u003c/option>\n        <option value=\"Hemoglobin A1c\">Hemoglobin A1c\u003c/option>\n        <option value=\"Hx of Meds for HTN\">Hx of Meds for HTN\u003c/option>\n        <option value=\"Indicator of death\">Indicator of death\u003c/option>\n        <option value=\"Instrumental activities of daily liviing\">Instrumental activities of daily liviing\u003c/option>\n        <option value=\"Katz measure of disability\">Katz measure of disability\u003c/option>\n        <option value=\"LDL cholesterol\">LDL cholesterol\u003c/option>\n        <option value=\"Lifetime daily alcohol intake -baseline\">Lifetime daily alcohol intake -baseline\u003c/option>\n        <option value=\"Line orientation - 2014\">Line orientation - 2014\u003c/option>\n        <option value=\"Logical memory Ia - immediate - 2014\">Logical memory Ia - immediate - 2014\u003c/option>\n        <option value=\"Logical memory IIa - 2014\">Logical memory IIa - 2014\u003c/option>\n        <option value=\"Major depression dx-clinic rating\">Major depression dx-clinic rating\u003c/option>\n        <option value=\"maximal expiratory pressure\">maximal expiratory pressure\u003c/option>\n        <option value=\"maximal inspiratory pressure\">maximal inspiratory pressure\u003c/option>\n        <option value=\"Medical conditions - claudication -cumulative\">Medical conditions - claudication -cumulative\u003c/option>\n        <option value=\"Medical Conditions - congestive heart failure -&#10;cumulative\">Medical Conditions - congestive heart failure -\ncumulative\u003c/option>\n        <option value=\"Medical Conditions - heart - cumulative\">Medical Conditions - heart - cumulative\u003c/option>\n        <option value=\"Medical conditions - hypertension - cumulative\">Medical conditions - hypertension - cumulative\u003c/option>\n        <option value=\"Medical Conditions - thyroid disease - cumulative\">Medical Conditions - thyroid disease - cumulative\u003c/option>\n        <option value=\"Medical history - diabetes - cumulative\">Medical history - diabetes - cumulative\u003c/option>\n        <option value=\"MMSE - 2014\">MMSE - 2014\u003c/option>\n        <option value=\"Negative life events\">Negative life events\u003c/option>\n        <option value=\"Negative social exchange\">Negative social exchange\u003c/option>\n        <option value=\"Negative social exchange-help-MAP\">Negative social exchange-help-MAP\u003c/option>\n        <option value=\"Negative social exchange-intrusion-MAP\">Negative social exchange-intrusion-MAP\u003c/option>\n        <option value=\"Negative social exchange-unsymapathetic-MAP\">Negative social exchange-unsymapathetic-MAP\u003c/option>\n        <option value=\"Negative social exchange - rejection-MAP\">Negative social exchange - rejection-MAP\u003c/option>\n        <option value=\"NEO agreeableness-ROS\">NEO agreeableness-ROS\u003c/option>\n        <option value=\"NEO altruism scale-MAP\">NEO altruism scale-MAP\u003c/option>\n        <option value=\"NEO conscientiousness-MAP\">NEO conscientiousness-MAP\u003c/option>\n        <option value=\"NEO extraversion-ROS/MAP\">NEO extraversion-ROS/MAP\u003c/option>\n        <option value=\"NEO openess-ROS\">NEO openess-ROS\u003c/option>\n        <option value=\"NEO trust-MAP\">NEO trust-MAP\u003c/option>\n        <option value=\"Neuroticism - 12 item version-RMM\">Neuroticism - 12 item version-RMM\u003c/option>\n        <option value=\"Neuroticism - 6 item version - RMM\">Neuroticism - 6 item version - RMM\u003c/option>\n        <option value=\"No label found in codebook\">No label found in codebook\u003c/option>\n        <option value=\"Number comparison - 2014\">Number comparison - 2014\u003c/option>\n        <option value=\"Panas score\">Panas score\u003c/option>\n        <option value=\"Participant&#39;s race\">Participant's race\u003c/option>\n        <option value=\"Perceived stress\">Perceived stress\u003c/option>\n        <option value=\"Potassium\">Potassium\u003c/option>\n        <option value=\"Progressive Matrices - 2014\">Progressive Matrices - 2014\u003c/option>\n        <option value=\"pulmonary vital capacity\">pulmonary vital capacity\u003c/option>\n        <option value=\"Reading test-NART-2014\">Reading test-NART-2014\u003c/option>\n        <option value=\"Reading test - WRAT - 2014\">Reading test - WRAT - 2014\u003c/option>\n        <option value=\"Rosow-Breslau scale\">Rosow-Breslau scale\u003c/option>\n        <option value=\"Smoking\">Smoking\u003c/option>\n        <option value=\"Smoking at baseline\">Smoking at baseline\u003c/option>\n        <option value=\"Smoking duration-baseline\">Smoking duration-baseline\u003c/option>\n        <option value=\"Smoking quantity-baseline\">Smoking quantity-baseline\u003c/option>\n        <option value=\"Sodium\">Sodium\u003c/option>\n        <option value=\"Spanish/Hispanic origin\">Spanish/Hispanic origin\u003c/option>\n        <option value=\"Summary of self reported physical activity&#10;measure (in hours) ROS/MAP\">Summary of self reported physical activity\nmeasure (in hours) ROS/MAP\u003c/option>\n        <option value=\"Symbol digit modalitities - 2014\">Symbol digit modalitities - 2014\u003c/option>\n        <option value=\"Vascular disease burden (3 items w/o chf)&#10;ROS/MAP/MARS\">Vascular disease burden (3 items w/o chf)\nROS/MAP/MARS\u003c/option>\n        <option value=\"Vascular disease burden (4 items) - MAP/MARS&#10;only\">Vascular disease burden (4 items) - MAP/MARS\nonly\u003c/option>\n        <option value=\"Vascular disease risk factors\">Vascular disease risk factors\u003c/option>\n        <option value=\"Vision acuity\">Vision acuity\u003c/option>\n        <option value=\"Visual acuity\">Visual acuity\u003c/option>\n        <option value=\"Weight (kg)\">Weight (kg)\u003c/option>\n        <option value=\"Whether blood was collected on fasting participant\">Whether blood was collected on fasting participant\u003c/option>\n        <option value=\"Word list I- immediate- 2014\">Word list I- immediate- 2014\u003c/option>\n        <option value=\"Word list II - delayed - 2014\">Word list II - delayed - 2014\u003c/option>\n        <option value=\"Word list III - recognition - 2014\">Word list III - recognition - 2014\u003c/option>\n        <option value=\"Years of education\">Years of education\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"clinical\">clinical\u003c/option>\n        <option value=\"cognitive\">cognitive\u003c/option>\n        <option value=\"demographic\">demographic\u003c/option>\n        <option value=\"design\">design\u003c/option>\n        <option value=\"personality\">personality\u003c/option>\n        <option value=\"physical\">physical\u003c/option>\n        <option value=\"psychological\">psychological\u003c/option>\n        <option value=\"substance\">substance\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"age_at_visit\">age_at_visit\u003c/option>\n        <option value=\"age_bl\">age_bl\u003c/option>\n        <option value=\"age_death\">age_death\u003c/option>\n        <option value=\"agreeableness\">agreeableness\u003c/option>\n        <option value=\"alco_life\">alco_life\u003c/option>\n        <option value=\"alcohol_g\">alcohol_g\u003c/option>\n        <option value=\"anxiety_10items\">anxiety_10items\u003c/option>\n        <option value=\"apoe_genotype\">apoe_genotype\u003c/option>\n        <option value=\"bmi\">bmi\u003c/option>\n        <option value=\"bp11\">bp11\u003c/option>\n        <option value=\"bp2\">bp2\u003c/option>\n        <option value=\"bp3\">bp3\u003c/option>\n        <option value=\"bp31\">bp31\u003c/option>\n        <option value=\"bun\">bun\u003c/option>\n        <option value=\"ca\">ca\u003c/option>\n        <option value=\"catfluency\">catfluency\u003c/option>\n        <option value=\"cesdsum\">cesdsum\u003c/option>\n        <option value=\"chf_cum\">chf_cum\u003c/option>\n        <option value=\"chlstrl\">chlstrl\u003c/option>\n        <option value=\"cl\">cl\u003c/option>\n        <option value=\"claudication_cum\">claudication_cum\u003c/option>\n        <option value=\"co2\">co2\u003c/option>\n        <option value=\"cogn_ep\">cogn_ep\u003c/option>\n        <option value=\"cogn_global\">cogn_global\u003c/option>\n        <option value=\"cogn_po\">cogn_po\u003c/option>\n        <option value=\"cogn_ps\">cogn_ps\u003c/option>\n        <option value=\"cogn_se\">cogn_se\u003c/option>\n        <option value=\"cogn_wo\">cogn_wo\u003c/option>\n        <option value=\"conscientiousness\">conscientiousness\u003c/option>\n        <option value=\"crn\">crn\u003c/option>\n        <option value=\"cts_bname\">cts_bname\u003c/option>\n        <option value=\"cts_db\">cts_db\u003c/option>\n        <option value=\"cts_delay\">cts_delay\u003c/option>\n        <option value=\"cts_df\">cts_df\u003c/option>\n        <option value=\"cts_doperf\">cts_doperf\u003c/option>\n        <option value=\"cts_ebdr\">cts_ebdr\u003c/option>\n        <option value=\"cts_ebmt\">cts_ebmt\u003c/option>\n        <option value=\"cts_idea\">cts_idea\u003c/option>\n        <option value=\"cts_lopair\">cts_lopair\u003c/option>\n        <option value=\"cts_nccrtd\">cts_nccrtd\u003c/option>\n        <option value=\"cts_pmat\">cts_pmat\u003c/option>\n        <option value=\"cts_read_nart\">cts_read_nart\u003c/option>\n        <option value=\"cts_read_wrat\">cts_read_wrat\u003c/option>\n        <option value=\"cts_sdmt\">cts_sdmt\u003c/option>\n        <option value=\"cts_story\">cts_story\u003c/option>\n        <option value=\"cts_wli\">cts_wli\u003c/option>\n        <option value=\"cts_wlii\">cts_wlii\u003c/option>\n        <option value=\"cts_wliii\">cts_wliii\u003c/option>\n        <option value=\"dcfdx\">dcfdx\u003c/option>\n        <option value=\"dementia\">dementia\u003c/option>\n        <option value=\"died\">died\u003c/option>\n        <option value=\"dm_cum\">dm_cum\u003c/option>\n        <option value=\"educ\">educ\u003c/option>\n        <option value=\"extraversion\">extraversion\u003c/option>\n        <option value=\"fasting\">fasting\u003c/option>\n        <option value=\"fev\">fev\u003c/option>\n        <option value=\"fu_year\">fu_year\u003c/option>\n        <option value=\"gait_speed\">gait_speed\u003c/option>\n        <option value=\"glucose\">glucose\u003c/option>\n        <option value=\"gripavg\">gripavg\u003c/option>\n        <option value=\"hba1c\">hba1c\u003c/option>\n        <option value=\"hdlchlstrl\">hdlchlstrl\u003c/option>\n        <option value=\"hdlratio\">hdlratio\u003c/option>\n        <option value=\"heart_cum\">heart_cum\u003c/option>\n        <option value=\"htm\">htm\u003c/option>\n        <option value=\"hypertension_cum\">hypertension_cum\u003c/option>\n        <option value=\"iadlsum\">iadlsum\u003c/option>\n        <option value=\"id\">id\u003c/option>\n        <option value=\"intrusion\">intrusion\u003c/option>\n        <option value=\"k\">k\u003c/option>\n        <option value=\"katzsum\">katzsum\u003c/option>\n        <option value=\"ldlchlstrl\">ldlchlstrl\u003c/option>\n        <option value=\"mep\">mep\u003c/option>\n        <option value=\"mip\">mip\u003c/option>\n        <option value=\"mmse\">mmse\u003c/option>\n        <option value=\"msex\">msex\u003c/option>\n        <option value=\"na\">na\u003c/option>\n        <option value=\"neglifeevents\">neglifeevents\u003c/option>\n        <option value=\"negsocexchange\">negsocexchange\u003c/option>\n        <option value=\"neo_altruism\">neo_altruism\u003c/option>\n        <option value=\"neo_conscientiousness\">neo_conscientiousness\u003c/option>\n        <option value=\"neo_trust\">neo_trust\u003c/option>\n        <option value=\"neuroticism_12\">neuroticism_12\u003c/option>\n        <option value=\"neuroticism_6\">neuroticism_6\u003c/option>\n        <option value=\"nohelp\">nohelp\u003c/option>\n        <option value=\"openness\">openness\u003c/option>\n        <option value=\"panas\">panas\u003c/option>\n        <option value=\"perceivedstress\">perceivedstress\u003c/option>\n        <option value=\"phys5itemsum\">phys5itemsum\u003c/option>\n        <option value=\"pvc\">pvc\u003c/option>\n        <option value=\"q3smo_bl\">q3smo_bl\u003c/option>\n        <option value=\"q4smo_bl\">q4smo_bl\u003c/option>\n        <option value=\"r_depres\">r_depres\u003c/option>\n        <option value=\"r_stroke\">r_stroke\u003c/option>\n        <option value=\"race\">race\u003c/option>\n        <option value=\"rejection\">rejection\u003c/option>\n        <option value=\"rosbscl\">rosbscl\u003c/option>\n        <option value=\"rosbsum\">rosbsum\u003c/option>\n        <option value=\"scaled_to.x\">scaled_to.x\u003c/option>\n        <option value=\"scaled_to.y\">scaled_to.y\u003c/option>\n        <option value=\"smoke_bl\">smoke_bl\u003c/option>\n        <option value=\"smoking\">smoking\u003c/option>\n        <option value=\"spanish\">spanish\u003c/option>\n        <option value=\"stroke_cum\">stroke_cum\u003c/option>\n        <option value=\"study\">study\u003c/option>\n        <option value=\"thyroid_cum\">thyroid_cum\u003c/option>\n        <option value=\"unsympathetic\">unsympathetic\u003c/option>\n        <option value=\"vasc_3dis_sum\">vasc_3dis_sum\u003c/option>\n        <option value=\"vasc_4dis_sum\">vasc_4dis_sum\u003c/option>\n        <option value=\"vasc_risks_sum\">vasc_risks_sum\u003c/option>\n        <option value=\"vision\">vision\u003c/option>\n        <option value=\"visionlog\">visionlog\u003c/option>\n        <option value=\"wtkg\">wtkg\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"\">\u003c/option>\n        <option value=\"age\">age\u003c/option>\n        <option value=\"alcohol\">alcohol\u003c/option>\n        <option value=\"apoe\">apoe\u003c/option>\n        <option value=\"cardio\">cardio\u003c/option>\n        <option value=\"cognition\">cognition\u003c/option>\n        <option value=\"dementia\">dementia\u003c/option>\n        <option value=\"diabetes\">diabetes\u003c/option>\n        <option value=\"education\">education\u003c/option>\n        <option value=\"episodic memory\">episodic memory\u003c/option>\n        <option value=\"global\">global\u003c/option>\n        <option value=\"hypertension\">hypertension\u003c/option>\n        <option value=\"id\">id\u003c/option>\n        <option value=\"perceptual orientation\">perceptual orientation\u003c/option>\n        <option value=\"perceptual speed\">perceptual speed\u003c/option>\n        <option value=\"physact\">physact\u003c/option>\n        <option value=\"physcap\">physcap\u003c/option>\n        <option value=\"physique\">physique\u003c/option>\n        <option value=\"race\">race\u003c/option>\n        <option value=\"semantic memory\">semantic memory\u003c/option>\n        <option value=\"sex\">sex\u003c/option>\n        <option value=\"smoking\">smoking\u003c/option>\n        <option value=\"stroke\">stroke\u003c/option>\n        <option value=\"time\">time\u003c/option>\n        <option value=\"verbal comprehension\">verbal comprehension\u003c/option>\n        <option value=\"working memory\">working memory\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"true\">true\u003c/option>\n        <option value=\"false\">false\u003c/option>\n        <option value=\"na\">na\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"true\">true\u003c/option>\n        <option value=\"false\">false\u003c/option>\n        <option value=\"na\">na\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"\">\u003c/option>\n        <option value=\"0 to 10\">0 to 10\u003c/option>\n        <option value=\"0 to 110\">0 to 110\u003c/option>\n        <option value=\"0 to 12\">0 to 12\u003c/option>\n        <option value=\"0 to 14\">0 to 14\u003c/option>\n        <option value=\"0 to 15\">0 to 15\u003c/option>\n        <option value=\"0 to 16\">0 to 16\u003c/option>\n        <option value=\"0 to 25\">0 to 25\u003c/option>\n        <option value=\"0 to 30\">0 to 30\u003c/option>\n        <option value=\"0 to 48\">0 to 48\u003c/option>\n        <option value=\"0 to 75\">0 to 75\u003c/option>\n        <option value=\"0 to 8\">0 to 8\u003c/option>\n        <option value=\"0, 1\">0, 1\u003c/option>\n        <option value=\"category\">category\u003c/option>\n        <option value=\"cigarettes / day\">cigarettes / day\u003c/option>\n        <option value=\"cm H20\">cm H20\u003c/option>\n        <option value=\"composite\">composite\u003c/option>\n        <option value=\"drinks / day\">drinks / day\u003c/option>\n        <option value=\"grams\">grams\u003c/option>\n        <option value=\"kg/msq\">kg/msq\u003c/option>\n        <option value=\"kilos\">kilos\u003c/option>\n        <option value=\"lbs\">lbs\u003c/option>\n        <option value=\"liters\">liters\u003c/option>\n        <option value=\"meters\">meters\u003c/option>\n        <option value=\"min/sec\">min/sec\u003c/option>\n        <option value=\"o to 10\">o to 10\u003c/option>\n        <option value=\"person\">person\u003c/option>\n        <option value=\"scale\">scale\u003c/option>\n        <option value=\"time point\">time point\u003c/option>\n        <option value=\"year\">year\u003c/option>\n        <option value=\"years\">years\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"true\">true\u003c/option>\n        <option value=\"false\">false\u003c/option>\n        <option value=\"na\">na\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n\u003c/tr>","caption":"<caption>This is a dynamic table of the metadata file. Edit at `./data/meta/map/meta-data-map.csv\u003c/caption>","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113"],["id","study","scaled_to.x","agreeableness","conscientiousness","extraversion","neo_altruism","neo_conscientiousness","neo_trust","openness","anxiety_10items","neuroticism_12","neuroticism_6","age_bl","age_death","died","educ","msex","race","spanish","apoe_genotype","ldai_bl","q3smo_bl","q4smo_bl","smoke_bl","smoking","fu_year","scaled_to.y","cesdsum","r_depres","intrusion","neglifeevents","negsocexchange","nohelp","panas","perceivedstress","rejection","unsympathetic","dcfdx","dementia","r_stroke","cogn_ep","cogn_global","cogn_po","cogn_ps","cogn_se","cogn_wo","cts_bname","cts_catflu","cts_db","cts_delay","cts_df","cts_doperf","cts_ebdr","cts_ebmt","cts_idea","cts_lopair","cts_mmse30","cts_nccrtd","cts_pmat","cts_read_nart","cts_read_wrat","cts_sdmt","cts_story","cts_wli","cts_wlii","cts_wliii","age_at_visit","iadlsum","katzsum","rosbscl","rosbsum","vision","visionlog","fev","mep","mip","pvc","bun","ca","chlstrl","cl","co2","crn","fasting","glucose","hba1c","hdlchlstrl","hdlratio","k","ldlchlstrl","na","alcohol_g","bmi","htm","phys5itemsum","wtkg","bp11","bp2","bp3","bp31","hypertension_cum","dm_cum","thyroid_cum","chf_cum","claudication_cum","heart_cum","stroke_cum","vasc_3dis_sum","vasc_4dis_sum","vasc_risks_sum","gait_speed","gripavg"],[null,null,null,"NEO agreeableness-ROS","Conscientiousness-ROS/MAP","NEO extraversion-ROS/MAP","NEO altruism scale-MAP","NEO conscientiousness-MAP","NEO trust-MAP","NEO openess-ROS","Anxiety-10 item version - ROS and MAP","Neuroticism - 12 item version-RMM","Neuroticism - 6 item version - RMM","Age at baseline","Age at death","Indicator of death","Years of education","Gender","Participant's race","Spanish/Hispanic origin","ApoE genotype","Lifetime daily alcohol intake -baseline","Smoking quantity-baseline","Smoking duration-baseline","Smoking at baseline","Smoking","Follow-up year","No label found in codebook","CESD-Measure of depressive symptoms","Major depression dx-clinic rating","Negative social exchange-intrusion-MAP","Negative life events","Negative social exchange","Negative social exchange-help-MAP","Panas score","Perceived stress","Negative social exchange - rejection-MAP","Negative social exchange-unsymapathetic-MAP","Clinical dx summary","Dementia diagnosis","Clinical stroke dx","Calculated domain score-episodic memory","Global cognitive score","Calculated domain score - perceptual orientation","Calculated domain score - perceptual speed","Calculated domain score - semantic memory","Calculated domain score - working memory","Boston naming - 2014","Category fluency - 2014","Digits backwards - 2014","Logical memory IIa - 2014","Digits forwards - 2014","Digit ordering - 2014","East Boston story - delayed recall - 2014","East Boston story - immediate - 2014","Complex ideas - 2014","Line orientation - 2014","MMSE - 2014","Number comparison - 2014","Progressive Matrices - 2014","Reading test-NART-2014","Reading test - WRAT - 2014","Symbol digit modalitities - 2014","Logical memory Ia - immediate - 2014","Word list I- immediate- 2014","Word list II - delayed - 2014","Word list III - recognition - 2014","Age at cycle - fractional","Instrumental activities of daily liviing","Katz measure of disability","Rosow-Breslau scale","Rosow-Breslau scale","Vision acuity","Visual acuity","forced expiratory volume","maximal expiratory pressure","maximal inspiratory pressure","pulmonary vital capacity","Blood urea nitrogen","Calcium","Cholesterol","Chloride","Carbon Dioxide","Creatinine","Whether blood was collected on fasting participant","Glucose","Hemoglobin A1c","HDL cholesterol","HDL ratio","Potassium","LDL cholesterol","Sodium","Grams of alcohol per day","Body mass index","Height(meters)","Summary of self reported physical activity\nmeasure (in hours) ROS/MAP","Weight (kg)","Blood pressure measurement- sitting - trial 1","Blood pressure measurement- sitting - trial 2","Hx of Meds for HTN","Blood pressure measurement- standing","Medical conditions - hypertension - cumulative","Medical history - diabetes - cumulative","Medical Conditions - thyroid disease - cumulative","Medical Conditions - congestive heart failure -\ncumulative","Medical conditions - claudication -cumulative","Medical Conditions - heart - cumulative","Clinical Diagnoses - Stroke - cumulative","Vascular disease burden (3 items w/o chf)\nROS/MAP/MARS","Vascular disease burden (4 items) - MAP/MARS\nonly","Vascular disease risk factors","Gait Speed - MAP","Extremity strength"],["design","design","design","personality","personality","personality","personality","personality","personality","personality","personality","personality","personality","demographic","demographic","demographic","demographic","demographic","demographic","demographic","clinical","substance","substance","substance","substance","substance","design","design","psychological","psychological","psychological","psychological","psychological","psychological","psychological","psychological","psychological","psychological","clinical","cognitive","clinical","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","demographic","physical","physical","physical","physical","physical","physical","physical","physical","physical","physical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","substance","physical","physical","physical","physical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","physical","physical"],["id","study","scaled_to.x","agreeableness","conscientiousness","extraversion","neo_altruism","neo_conscientiousness","neo_trust","openness","anxiety_10items","neuroticism_12","neuroticism_6","age_bl","age_death","died","educ","msex","race","spanish","apoe_genotype","alco_life","q3smo_bl","q4smo_bl","smoke_bl","smoking","fu_year","scaled_to.y","cesdsum","r_depres","intrusion","neglifeevents","negsocexchange","nohelp","panas","perceivedstress","rejection","unsympathetic","dcfdx","dementia","r_stroke","cogn_ep","cogn_global","cogn_po","cogn_ps","cogn_se","cogn_wo","cts_bname","catfluency","cts_db","cts_delay","cts_df","cts_doperf","cts_ebdr","cts_ebmt","cts_idea","cts_lopair","mmse","cts_nccrtd","cts_pmat","cts_read_nart","cts_read_wrat","cts_sdmt","cts_story","cts_wli","cts_wlii","cts_wliii","age_at_visit","iadlsum","katzsum","rosbscl","rosbsum","vision","visionlog","fev","mep","mip","pvc","bun","ca","chlstrl","cl","co2","crn","fasting","glucose","hba1c","hdlchlstrl","hdlratio","k","ldlchlstrl","na","alcohol_g","bmi","htm","phys5itemsum","wtkg","bp11","bp2","bp3","bp31","hypertension_cum","dm_cum","thyroid_cum","chf_cum","claudication_cum","heart_cum","stroke_cum","vasc_3dis_sum","vasc_4dis_sum","vasc_risks_sum","gait_speed","gripavg"],["id","","","","","","","","","","","","","age","age","age","education","sex","race","race","apoe","alcohol","smoking","smoking","smoking","smoking","time","","","","","","","","","","","","cognition","dementia","stroke","episodic memory","global","perceptual orientation","perceptual speed","semantic memory","working memory","semantic memory","semantic memory","working memory","episodic memory","working memory","working memory","episodic memory","episodic memory","verbal comprehension","perceptual orientation","dementia","perceptual speed","perceptual orientation","semantic memory","semantic memory","perceptual speed","episodic memory","episodic memory","episodic memory","episodic memory","","physact","physcap","physcap","physcap","physcap","physcap","physcap","physcap","physcap","physcap","","","","","","","","","","","","","","","alcohol","physique","physique","physact","physique","hypertension","hypertension","hypertension","hypertension","hypertension","diabetes","","cardio","","","stroke","","","","physcap","physcap"],[false,null,null,null,null,null,null,null,null,null,null,null,null,false,false,false,true,false,true,true,false,true,true,true,true,true,false,null,null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,null,true,true,true,true,false,false,false,false,false,false,null,null,null,null,null,null,null,null,null,null,null,null,null,null,true,false,false,true,false,false,false,true,false,true,true,null,true,null,null,false,null,null,null,false,false],[false,null,null,null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,false,false,false,false,false,false,false,false,true,null,null,null,null,null,null,null,null,null,null,null,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,null,true,true,true,true,true,true,true,true,true,true,null,null,null,null,null,null,null,null,null,null,null,null,null,null,false,true,true,null,true,true,true,true,true,true,true,null,true,null,null,true,null,null,null,true,true],["person","","","","","","","","","","","","","year","year","category","years","category","category","category","scale","drinks / day","cigarettes / day","years","category","category","time point","","","","","","","","","","","","category","0, 1","category","composite","composite","composite","composite","composite","composite","0 to 15","0 to 75","0 to 12","0 to 25","0 to 12","0 to 14","0 to 12","0 to 12","0 to 8","0 to 15","0 to 30","0 to 48","0 to 16","0 to 10","0 to 15","0 to 110","0 to 25","0 to 30","0 to 10","o to 10","","scale","scale","scale","scale","scale","scale","liters","cm H20","cm H20","liters","","","","","","","","","","","","","","","grams","kg/msq","meters","","kilos","","","","","","","","category","","","category","","","","min/sec","lbs"],[true,null,null,null,null,null,null,null,null,null,null,null,null,true,true,true,true,true,true,true,true,true,true,true,true,true,true,null,null,null,null,null,null,null,null,null,null,null,true,true,true,true,true,true,true,true,true,null,null,null,null,null,null,null,null,null,null,true,null,null,null,null,null,null,null,null,null,null,true,true,true,true,true,true,true,true,true,true,null,null,null,null,null,null,null,null,null,null,null,null,null,null,true,true,true,null,true,null,null,null,null,null,null,null,true,null,null,true,null,null,null,true,true]],"container":"<table class=\"cell-border stripe\">\n  <thead>\n    <tr>\n      <th> \u003c/th>\n      <th>name\u003c/th>\n      <th>label\u003c/th>\n      <th>type\u003c/th>\n      <th>name_new\u003c/th>\n      <th>construct\u003c/th>\n      <th>self_reported\u003c/th>\n      <th>longitudinal\u003c/th>\n      <th>unit\u003c/th>\n      <th>include\u003c/th>\n    \u003c/tr>\n  \u003c/thead>\n\u003c/table>","options":{"pageLength":6,"autoWidth":true,"order":[],"orderClasses":false,"columnDefs":[{"orderable":false,"targets":0}],"orderCellsTop":true,"lengthMenu":[6,10,25,50,100]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->




```r
# this is how we can interact with the `dto` to call and graph data and metadata
dto[["metaData"]] %>% 
  dplyr::filter(type=="demographic") %>% 
  dplyr::select(name,name_new,label)
```

```
##           name     name_new                     label
## 1       age_bl       age_bl           Age at baseline
## 2    age_death    age_death              Age at death
## 3         died         died        Indicator of death
## 4         educ         educ        Years of education
## 5         msex         msex                    Gender
## 6         race         race        Participant's race
## 7      spanish      spanish   Spanish/Hispanic origin
## 8 age_at_visit age_at_visit Age at cycle - fractional
```

```r
dto[["unitData"]]%>%
  histogram_continuous("age_death", bin_width=1)
```

<img src="figure/review-variables-map-Rmdbasic-graph-1.png" title="plot of chunk basic-graph" alt="plot of chunk basic-graph" style="display: block; margin: auto;" />

```r
dto[["metaData"]] %>% dplyr::filter(name=="fu_year")
```

```
##      name          label   type name_new construct self_reported
## 1 fu_year Follow-up year design  fu_year      time         FALSE
##   longitudinal       unit include
## 1         TRUE time point    TRUE
```

```r
ds %>% 
  dplyr::group_by_("fu_year") %>%
  dplyr::summarize(sample_size=n())
```

```
## Source: local data frame [18 x 2]
## 
##    fu_year sample_size
##      (int)       (int)
## 1        0        1695
## 2        1        1467
## 3        2        1266
## 4        3        1078
## 5        4         908
## 6        5         740
## 7        6         666
## 8        7         558
## 9        8         466
## 10       9         342
## 11      10         237
## 12      11         133
## 13      12          56
## 14      13          44
## 15      14          28
## 16      15          21
## 17      16           2
## 18      NA           1
```

```r
dto[["metaData"]] %>% 
  dplyr::filter(type=="cognitive") %>% 
  dplyr::select(-name,-type,-name_new) %>%
  dplyr::arrange(construct, include)
```

```
##                                               label              construct
## 1                                Dementia diagnosis               dementia
## 2                                       MMSE - 2014               dementia
## 3           Calculated domain score-episodic memory        episodic memory
## 4                         Logical memory IIa - 2014        episodic memory
## 5         East Boston story - delayed recall - 2014        episodic memory
## 6              East Boston story - immediate - 2014        episodic memory
## 7              Logical memory Ia - immediate - 2014        episodic memory
## 8                      Word list I- immediate- 2014        episodic memory
## 9                     Word list II - delayed - 2014        episodic memory
## 10               Word list III - recognition - 2014        episodic memory
## 11                           Global cognitive score                 global
## 12 Calculated domain score - perceptual orientation perceptual orientation
## 13                          Line orientation - 2014 perceptual orientation
## 14                      Progressive Matrices - 2014 perceptual orientation
## 15       Calculated domain score - perceptual speed       perceptual speed
## 16                         Number comparison - 2014       perceptual speed
## 17                 Symbol digit modalitities - 2014       perceptual speed
## 18        Calculated domain score - semantic memory        semantic memory
## 19                             Boston naming - 2014        semantic memory
## 20                          Category fluency - 2014        semantic memory
## 21                           Reading test-NART-2014        semantic memory
## 22                       Reading test - WRAT - 2014        semantic memory
## 23                             Complex ideas - 2014   verbal comprehension
## 24         Calculated domain score - working memory         working memory
## 25                          Digits backwards - 2014         working memory
## 26                           Digits forwards - 2014         working memory
## 27                            Digit ordering - 2014         working memory
##    self_reported longitudinal      unit include
## 1          FALSE         TRUE      0, 1    TRUE
## 2           TRUE         TRUE   0 to 30    TRUE
## 3          FALSE         TRUE composite    TRUE
## 4          FALSE         TRUE   0 to 25      NA
## 5          FALSE         TRUE   0 to 12      NA
## 6          FALSE         TRUE   0 to 12      NA
## 7          FALSE         TRUE   0 to 25      NA
## 8          FALSE         TRUE   0 to 30      NA
## 9          FALSE         TRUE   0 to 10      NA
## 10         FALSE         TRUE   o to 10      NA
## 11         FALSE         TRUE composite    TRUE
## 12         FALSE         TRUE composite    TRUE
## 13         FALSE         TRUE   0 to 15      NA
## 14         FALSE         TRUE   0 to 16      NA
## 15         FALSE         TRUE composite    TRUE
## 16         FALSE         TRUE   0 to 48      NA
## 17         FALSE         TRUE  0 to 110      NA
## 18         FALSE         TRUE composite    TRUE
## 19         FALSE         TRUE   0 to 15      NA
## 20         FALSE         TRUE   0 to 75      NA
## 21         FALSE         TRUE   0 to 10      NA
## 22         FALSE         TRUE   0 to 15      NA
## 23         FALSE         TRUE    0 to 8      NA
## 24         FALSE         TRUE composite    TRUE
## 25         FALSE         TRUE   0 to 12      NA
## 26         FALSE         TRUE   0 to 12      NA
## 27         FALSE         TRUE   0 to 14      NA
```

```r
dto[["metaData"]] %>% 
  dplyr::filter(type=="cognitive", include==TRUE) %>% 
  dplyr::select(-type,-name_new) %>%
  dplyr::arrange(construct, include)
```

```
##          name                                            label
## 1    dementia                               Dementia diagnosis
## 2  cts_mmse30                                      MMSE - 2014
## 3     cogn_ep          Calculated domain score-episodic memory
## 4 cogn_global                           Global cognitive score
## 5     cogn_po Calculated domain score - perceptual orientation
## 6     cogn_ps       Calculated domain score - perceptual speed
## 7     cogn_se        Calculated domain score - semantic memory
## 8     cogn_wo         Calculated domain score - working memory
##                construct self_reported longitudinal      unit include
## 1               dementia         FALSE         TRUE      0, 1    TRUE
## 2               dementia          TRUE         TRUE   0 to 30    TRUE
## 3        episodic memory         FALSE         TRUE composite    TRUE
## 4                 global         FALSE         TRUE composite    TRUE
## 5 perceptual orientation         FALSE         TRUE composite    TRUE
## 6       perceptual speed         FALSE         TRUE composite    TRUE
## 7        semantic memory         FALSE         TRUE composite    TRUE
## 8         working memory         FALSE         TRUE composite    TRUE
```

```r
dto[["unitData"]] %>% 
  dplyr::select(id,fu_year, cogn_global) %>% 
  # dplyr::filter(!is.na(cogn_global)) %>% 
  dplyr::group_by(fu_year) %>% 
  dplyr::summarize(ave_cog = mean(cogn_global),
                   observed =n()) 
```

```
## Source: local data frame [18 x 3]
## 
##    fu_year   ave_cog observed
##      (int)     (dbl)    (int)
## 1        0        NA     1695
## 2        1        NA     1467
## 3        2        NA     1266
## 4        3        NA     1078
## 5        4        NA      908
## 6        5        NA      740
## 7        6        NA      666
## 8        7        NA      558
## 9        8        NA      466
## 10       9        NA      342
## 11      10        NA      237
## 12      11        NA      133
## 13      12        NA       56
## 14      13        NA       44
## 15      14        NA       28
## 16      15        NA       21
## 17      16 0.6609268        2
## 18      NA        NA        1
```

```r
dto[["metaData"]] %>% dplyr::filter(name=="dementia")
```

```
##       name              label      type name_new construct self_reported
## 1 dementia Dementia diagnosis cognitive dementia  dementia         FALSE
##   longitudinal unit include
## 1         TRUE 0, 1    TRUE
```

```r
dto[["unitData"]] %>% 
  dplyr::group_by_("fu_year","dementia") %>% 
  dplyr::summarize(count=n())
```

```
## Source: local data frame [49 x 3]
## Groups: fu_year [?]
## 
##    fu_year dementia count
##      (int)    (int) (int)
## 1        0        0  1597
## 2        0        1    97
## 3        0       NA     1
## 4        1        0  1347
## 5        1        1    97
## 6        1       NA    23
## 7        2        0  1115
## 8        2        1   124
## 9        2       NA    27
## 10       3        0   922
## ..     ...      ...   ...
```

```r
dto[["unitData"]] %>% 
  dplyr::filter(!is.na(dementia)) %>% 
  dplyr::group_by_("fu_year") %>% 
  dplyr::summarize(percent_diagnosed=mean(dementia),
                   observed_n = n())
```

```
## Source: local data frame [17 x 3]
## 
##    fu_year percent_diagnosed observed_n
##      (int)             (dbl)      (int)
## 1        0        0.05726092       1694
## 2        1        0.06717452       1444
## 3        2        0.10008071       1239
## 4        3        0.11601151       1043
## 5        4        0.12013730        874
## 6        5        0.14344262        732
## 7        6        0.15160796        653
## 8        7        0.17765568        546
## 9        8        0.19376392        449
## 10       9        0.18327974        311
## 11      10        0.17452830        212
## 12      11        0.22018349        109
## 13      12        0.20000000         55
## 14      13        0.22727273         44
## 15      14        0.25925926         27
## 16      15        0.26315789         19
## 17      16        0.00000000          2
```

```r
dto[["metaData"]] %>% dplyr::filter(name=="educ")
```

```
##   name              label        type name_new construct self_reported
## 1 educ Years of education demographic     educ education          TRUE
##   longitudinal  unit include
## 1        FALSE years    TRUE
```

```r
# shows attrition in each education group
t <- table(ds$educ, ds$fu_year); t[t==0]<-".";t
```

```
##     
##      0   1   2   3   4   5   6   7   8   9  10 11 12 13 14 15 16
##   0  2   1   1   .   .   .   .   .   .   .  .  .  .  .  .  .  . 
##   2  3   1   .   1   1   1   1   .   .   .  .  .  .  .  .  .  . 
##   3  3   3   2   1   .   .   .   .   .   .  .  .  .  .  .  .  . 
##   4  5   3   2   2   2   1   2   .   .   .  .  .  .  .  .  .  . 
##   5  6   3   4   3   2   2   1   .   .   .  .  .  .  .  .  .  . 
##   6  11  9   8   6   5   2   3   1   .   .  .  .  .  .  .  .  . 
##   7  6   3   3   3   2   2   2   1   1   1  1  1  .  .  .  .  . 
##   8  32  27  22  20  14  13  13  9   7   6  3  .  .  .  .  .  . 
##   9  15  14  10  7   6   5   6   4   1   2  .  1  .  .  .  .  . 
##   10 32  26  23  17  16  11  11  8   7   5  4  1  .  .  .  .  . 
##   11 36  30  26  24  21  15  16  13  10  7  4  2  2  1  1  1  . 
##   12 391 327 288 246 208 177 161 131 109 83 56 30 16 10 3  2  . 
##   13 134 119 110 92  83  64  57  49  37  28 18 11 4  2  2  2  . 
##   14 202 181 152 118 100 82  75  65  55  43 31 14 5  5  3  2  1 
##   15 80  74  65  58  49  41  39  34  26  20 13 10 4  3  3  3  . 
##   16 343 304 253 228 187 159 128 115 108 70 55 36 13 13 11 7  1 
##   17 76  72  62  51  42  35  34  27  22  18 13 6  .  1  .  .  . 
##   18 157 139 124 109 91  68  63  53  43  27 15 6  4  2  .  .  . 
##   19 43  37  31  26  20  20  15  13  12  11 6  4  2  2  2  2  . 
##   20 50  45  38  30  24  16  16  14  12  10 8  5  1  .  .  .  . 
##   21 27  25  23  19  19  14  13  12  10  8  6  5  4  4  3  2  . 
##   22 11  10  9   8   7   4   3   3   1   1  1  .  .  .  .  .  . 
##   23 5   5   5   4   4   4   3   2   2   .  .  .  .  .  .  .  . 
##   24 4   4   2   2   2   2   2   2   1   1  1  1  1  1  .  .  . 
##   25 4   3   1   1   1   .   .   .   .   .  .  .  .  .  .  .  . 
##   28 2   2   2   2   2   2   2   2   2   1  2  .  .  .  .  .  .
```

```r
# response categories
dto[["unitData"]] %>% 
  dplyr::group_by_("educ") %>% 
  dplyr::summarize(count=n())
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
## ..   ...   ...
```

```r
# descriptives by follow-up year
dto[["unitData"]] %>% 
  dplyr::filter(!is.na(educ)) %>% 
  dplyr::group_by_("fu_year") %>% 
  dplyr::summarize(average_years_edu=mean(educ),
                   SD=sd(educ),
                   observed_n = n())
```

```
## Source: local data frame [18 x 4]
## 
##    fu_year average_years_edu       SD observed_n
##      (int)             (dbl)    (dbl)      (int)
## 1        0          14.48869 3.279858       1680
## 2        1          14.61486 3.196754       1467
## 3        2          14.59874 3.163047       1266
## 4        3          14.63729 3.143604       1078
## 5        4          14.65749 3.142426        908
## 6        5          14.62973 3.083973        740
## 7        6          14.52853 3.161792        666
## 8        7          14.73297 2.997070        558
## 9        8          14.81330 2.924409        466
## 10       9          14.69298 2.933657        342
## 11      10          14.86498 3.052978        237
## 12      11          14.94737 2.818542        133
## 13      12          15.03571 3.098177         56
## 14      13          15.43182 3.060610         44
## 15      14          15.60714 2.685203         28
## 16      15          15.52381 2.731649         21
## 17      16          15.00000 1.414214          2
## 18      NA          12.00000      NaN          1
```


```r
dto[["metaData"]] %>% dplyr::filter(name %in% c("bmi","wtkg", "htm"))
```

```
##   name           label     type name_new construct self_reported
## 1  bmi Body mass index physical      bmi  physique         FALSE
## 2  htm  Height(meters) physical      htm  physique         FALSE
## 3 wtkg     Weight (kg) physical     wtkg  physique         FALSE
##   longitudinal   unit include
## 1         TRUE kg/msq    TRUE
## 2         TRUE meters    TRUE
## 3         TRUE  kilos    TRUE
```

```r
# descriptives by follow-up year
dto[["unitData"]] %>% 
  dplyr::filter(!is.na(bmi)) %>% 
  dplyr::group_by_("fu_year") %>% 
  dplyr::summarize(average_years_edu=mean(bmi),
                   SD=sd(bmi),
                   observed_n = n())
```

```
## Source: local data frame [17 x 4]
## 
##    fu_year average_years_edu       SD observed_n
##      (int)             (dbl)    (dbl)      (int)
## 1        0          27.16808 5.325645       1643
## 2        1          27.27554 5.261774       1395
## 3        2          27.17962 5.244885       1177
## 4        3          27.17739 5.357885        973
## 5        4          27.00213 5.062759        805
## 6        5          26.92788 5.391633        629
## 7        6          26.56684 5.183859        526
## 8        7          26.88239 5.294955        448
## 9        8          26.68655 5.340990        343
## 10       9          26.91890 5.848888        272
## 11      10          26.23854 4.726430        176
## 12      11          26.26217 4.993561        104
## 13      12          25.33696 4.337400         42
## 14      13          26.22375 4.210867         29
## 15      14          25.71626 4.309203         23
## 16      15          25.07465 4.102202         16
## 17      16          23.05176      NaN          1
```

```r
dto[["metaData"]] %>% dplyr::filter(construct %in% c("smoking"))
```

```
##       name                     label      type name_new construct
## 1 q3smo_bl Smoking quantity-baseline substance q3smo_bl   smoking
## 2 q4smo_bl Smoking duration-baseline substance q4smo_bl   smoking
## 3 smoke_bl       Smoking at baseline substance smoke_bl   smoking
## 4  smoking                   Smoking substance  smoking   smoking
##   self_reported longitudinal             unit include
## 1          TRUE        FALSE cigarettes / day    TRUE
## 2          TRUE        FALSE            years    TRUE
## 3          TRUE        FALSE         category    TRUE
## 4          TRUE        FALSE         category    TRUE
```

```r
dto[["unitData"]] %>% 
  dplyr::filter(!is.na(q3smo_bl)) %>% 
  dplyr::group_by_("q3smo_bl") %>% 
  dplyr::summarize(n=n())
```

```
## Source: local data frame [33 x 2]
## 
##    q3smo_bl     n
##       (int) (int)
## 1         1    73
## 2         2   107
## 3         3   182
## 4         4   134
## 5         5    92
## 6         6    77
## 7         7    10
## 8         8    25
## 9        10   549
## 10       11    10
## ..      ...   ...
```

```r
dto[["unitData"]] %>% 
  dplyr::filter(!is.na(q3smo_bl)) %>% 
  dplyr::group_by_("fu_year") %>% 
  dplyr::summarize(average_years_edu=mean(q3smo_bl),
                   SD=sd(q3smo_bl),
                   observed_n = n())
```

```
## Source: local data frame [16 x 4]
## 
##    fu_year average_years_edu       SD observed_n
##      (int)             (dbl)    (dbl)      (int)
## 1        0          20.05165 14.66455        697
## 2        1          20.40440 14.95702        591
## 3        2          20.35490 14.68776        510
## 4        3          20.56876 14.79732        429
## 5        4          20.95238 15.08312        357
## 6        5          20.11684 14.76342        291
## 7        6          20.27953 14.79787        254
## 8        7          20.58454 14.42191        207
## 9        8          21.09202 14.62064        163
## 10       9          21.87719 15.32546        114
## 11      10          22.21795 15.41937         78
## 12      11          21.43478 15.50291         46
## 13      12          18.61538 10.89754         13
## 14      13          20.92308 12.03787         13
## 15      14          18.00000 11.57584          6
## 16      15          19.60000 12.17785          5
```

```r
table(ds$iadlsum)
```

```
## 
##    0    1    2    3    4    5    6    7    8 
## 3886 2281  867  625  427  363  226  319  403
```

```r
rmarkdown::render(
  input = "./reports/review-variables/map/review-variables.Rmd" ,
  output_format="html_document", clean=TRUE
)
```

```
## Warning in normalizePath(path.expand(path), winslash, mustWork):
## path[1]="./reports/review-variables/map/review-variables.Rmd": The system
## cannot find the file specified
```

```
## Error in tools::file_path_as_absolute(input): file './reports/review-variables/map/review-variables.Rmd' does not exist
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
## [37] markdown_0.7.7
```

```r
Sys.time()
```

```
## [1] "2016-04-07 10:49:00 PDT"
```

