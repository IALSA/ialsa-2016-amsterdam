# Encode Multistate Outcome

This report demonstrates and annotates the computation of the multistate variable used as the outcome in multistate models.

<!-- These two chunks should be added in the beginning of every .Rmd that you want to source an .R script -->
<!--  The 1st mandatory chunck  -->
<!--  Set the working directory to the repository's base directory -->


<!--  The 2nd mandatory chunck  -->
<!-- Set the report-wide options, and point to the external code file. -->

<!-- Load 'sourced' R files.  Suppress the output when loading packages. -->

```r
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) #Pipes

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit", quietly=TRUE)
# requireNamespace("plyr", quietly=TRUE)
```
<!-- Load the sources.  Suppress the output when loading sources. -->

```r
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
```
<!-- Load any Global functions and variables declared in the R file.  Suppress the output. -->

```r
path_input <- "./data/unshared/derived/dto.rds"
path_output <- "data/unshared/derived/dto.rds"
```
<!-- Declare any global functions specific to a Rmd output.  Suppress the output. -->

```r
#Put code in here.  It doesn't call a chunk in the code behind file.
```

# (I) Exposition

> This report is a record of interaction with a data transfer object (dto) produced by `./manipulation/map/0-ellis-island-map.R`.

The next section recaps this script, exposes the architecture of the DTO, and demonstrates the language of interacting with it.   

## (I.A) Ellis Island

> All data land on Ellis Island.

The script `0-ellis-island.R` is the first script in the analytic workflow. It accomplished the following:

- (1) Reads in raw data file
- (2) Extract, combines, and exports metadata (specifically, variable names and labels, if provided) into `./data/shared/meta/map/names-labels-live.csv`, which is updated every time Ellis Island script is executed.   
- (3) Augments raw metadata with instructions for renaming and classifying variables. The instructions are provided as manually entered values in `./data/shared/meta/map/meta-data-map.csv`. They are used by automatic scripts in later manipulation and analysis.  
- (4) Combines unit and meta data into a single DTO to serve as a starting point to all subsequent analyses.   


<!-- Load the datasets.   -->

```r
# load the product of 0-ellis-island.R,  a list object containing data and metadata
dto <- readRDS(path_input)
```

<!-- Inspect the datasets.   -->

```r
names(dto)
```

```
[1] "unitData" "metaData" "ms_mmse" 
```

```r
# 1st element - unit(person) level data
dplyr::tbl_df(dto[["unitData"]]) 
```

```
Source: local data frame [9,708 x 113]

       id study scaled_to.x agreeableness conscientiousness extraversion neo_altruism neo_conscientiousness neo_trust
    (int) (chr)       (chr)         (int)             (int)        (int)        (int)                 (int)     (int)
1    9121  MAP         MAP             NA                35           34           27                    35        25
2    9121  MAP         MAP             NA                35           34           27                    35        25
3    9121  MAP         MAP             NA                35           34           27                    35        25
4    9121  MAP         MAP             NA                35           34           27                    35        25
5    9121  MAP         MAP             NA                35           34           27                    35        25
6   33027  MAP         MAP             NA                NA           30           NA                    NA        NA
7   33027  MAP         MAP             NA                NA           30           NA                    NA        NA
8  204228  MAP         MAP             NA                NA           32           NA                    NA        NA
9  204228  MAP         MAP             NA                NA           32           NA                    NA        NA
10 204228  MAP         MAP             NA                NA           32           NA                    NA        NA
..    ...   ...         ...           ...               ...          ...          ...                   ...       ...
Variables not shown: openness (int), anxiety_10items (dbl), neuroticism_12 (int), neuroticism_6 (int), age_bl (dbl),
  age_death (dbl), died (int), educ (int), msex (int), race (int), spanish (int), apoe_genotype (int), alco_life (dbl),
  q3smo_bl (int), q4smo_bl (int), smoke_bl (int), smoking (int), fu_year (int), scaled_to.y (chr), cesdsum (int),
  r_depres (int), intrusion (dbl), neglifeevents (int), negsocexchange (dbl), nohelp (dbl), panas (dbl),
  perceivedstress (dbl), rejection (dbl), unsympathetic (dbl), dcfdx (int), dementia (int), r_stroke (int), cogn_ep
  (dbl), cogn_global (dbl), cogn_po (dbl), cogn_ps (dbl), cogn_se (dbl), cogn_wo (dbl), cts_bname (int), catfluency
  (int), cts_db (int), cts_delay (int), cts_df (int), cts_doperf (int), cts_ebdr (int), cts_ebmt (int), cts_idea (int),
  cts_lopair (int), mmse (dbl), cts_nccrtd (int), cts_pmat (int), cts_read_nart (int), cts_read_wrat (int), cts_sdmt
  (int), cts_story (int), cts_wli (int), cts_wlii (int), cts_wliii (int), age_at_visit (dbl), iadlsum (int), katzsum
  (int), rosbscl (int), rosbsum (int), vision (int), visionlog (dbl), fev (dbl), mep (dbl), mip (dbl), pvc (dbl), bun
  (int), ca (dbl), chlstrl (int), cl (int), co2 (int), crn (dbl), fasting (int), glucose (int), hba1c (dbl), hdlchlstrl
  (int), hdlratio (dbl), k (dbl), ldlchlstrl (int), na (int), alcohol_g (dbl), bmi (dbl), htm (dbl), phys5itemsum
  (dbl), wtkg (dbl), bp11 (chr), bp2 (chr), bp3 (int), bp31 (chr), hypertension_cum (int), dm_cum (int), thyroid_cum
  (int), chf_cum (int), claudication_cum (int), heart_cum (int), stroke_cum (int), vasc_3dis_sum (dbl), vasc_4dis_sum
  (dbl), vasc_risks_sum (dbl), gait_speed (dbl), gripavg (dbl)
```

```r
# 2nd element - meta data, info about variables
dplyr::tbl_df(dto[["metaData"]])
```

```
Source: local data frame [113 x 9]

                    name                     label        type              name_new construct self_reported
                   (chr)                     (chr)       (chr)                 (chr)     (chr)         (lgl)
1                     id                        NA      design                    id        id         FALSE
2                  study                        NA      design                 study                      NA
3            scaled_to.x                        NA      design           scaled_to.x                      NA
4          agreeableness     NEO agreeableness-ROS personality         agreeableness                      NA
5      conscientiousness Conscientiousness-ROS/MAP personality     conscientiousness                      NA
6           extraversion  NEO extraversion-ROS/MAP personality          extraversion                      NA
7           neo_altruism    NEO altruism scale-MAP personality          neo_altruism                      NA
8  neo_conscientiousness NEO conscientiousness-MAP personality neo_conscientiousness                      NA
9              neo_trust             NEO trust-MAP personality             neo_trust                      NA
10              openness           NEO openess-ROS personality              openness                      NA
..                   ...                       ...         ...                   ...       ...           ...
Variables not shown: longitudinal (lgl), unit (chr), include (lgl)
```

```r
# create a convenient alias for individual-level data
ds <- dto[["unitData"]]
```

### Meta

```r
dto[["metaData"]] %>%  
  dplyr::mutate(
    type          = factor(type),
    construct     = factor(construct),
    self_reported = factor(self_reported),
    longitudinal  = factor(longitudinal)
  ) %>% 
  DT::datatable(
    class   = 'cell-border stripe',
    caption = "This is a dynamic table of the metadata file. Edit at `./data/meta/map/meta-data-map.csv",
    filter  = "top",
    options = list(pageLength = 6, autoWidth = TRUE )
  )
```

<!--html_preserve--><div id="htmlwidget-5222" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-5222">{"x":{"filter":"top","filterHTML":"<tr>\n  <td>\u003c/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"clinical\">clinical\u003c/option>\n        <option value=\"cognitive\">cognitive\u003c/option>\n        <option value=\"demographic\">demographic\u003c/option>\n        <option value=\"design\">design\u003c/option>\n        <option value=\"personality\">personality\u003c/option>\n        <option value=\"physical\">physical\u003c/option>\n        <option value=\"psychological\">psychological\u003c/option>\n        <option value=\"substance\">substance\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"\">\u003c/option>\n        <option value=\"age\">age\u003c/option>\n        <option value=\"alcohol\">alcohol\u003c/option>\n        <option value=\"apoe\">apoe\u003c/option>\n        <option value=\"cardio\">cardio\u003c/option>\n        <option value=\"cognition\">cognition\u003c/option>\n        <option value=\"dementia\">dementia\u003c/option>\n        <option value=\"diabetes\">diabetes\u003c/option>\n        <option value=\"education\">education\u003c/option>\n        <option value=\"episodic memory\">episodic memory\u003c/option>\n        <option value=\"global cognition\">global cognition\u003c/option>\n        <option value=\"hypertension\">hypertension\u003c/option>\n        <option value=\"id\">id\u003c/option>\n        <option value=\"perceptual orientation\">perceptual orientation\u003c/option>\n        <option value=\"perceptual speed\">perceptual speed\u003c/option>\n        <option value=\"physact\">physact\u003c/option>\n        <option value=\"physcap\">physcap\u003c/option>\n        <option value=\"physique\">physique\u003c/option>\n        <option value=\"race\">race\u003c/option>\n        <option value=\"semantic memory\">semantic memory\u003c/option>\n        <option value=\"sex\">sex\u003c/option>\n        <option value=\"smoking\">smoking\u003c/option>\n        <option value=\"stroke\">stroke\u003c/option>\n        <option value=\"time\">time\u003c/option>\n        <option value=\"verbal comprehension\">verbal comprehension\u003c/option>\n        <option value=\"working memory\">working memory\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"FALSE\">FALSE\u003c/option>\n        <option value=\"TRUE\">TRUE\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"FALSE\">FALSE\u003c/option>\n        <option value=\"TRUE\">TRUE\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"true\">true\u003c/option>\n        <option value=\"false\">false\u003c/option>\n        <option value=\"na\">na\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n\u003c/tr>","caption":"<caption>This is a dynamic table of the metadata file. Edit at `./data/meta/map/meta-data-map.csv\u003c/caption>","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100","101","102","103","104","105","106","107","108","109","110","111","112","113"],["id","study","scaled_to.x","agreeableness","conscientiousness","extraversion","neo_altruism","neo_conscientiousness","neo_trust","openness","anxiety_10items","neuroticism_12","neuroticism_6","age_bl","age_death","died","educ","msex","race","spanish","apoe_genotype","ldai_bl","q3smo_bl","q4smo_bl","smoke_bl","smoking","fu_year","scaled_to.y","cesdsum","r_depres","intrusion","neglifeevents","negsocexchange","nohelp","panas","perceivedstress","rejection","unsympathetic","dcfdx","dementia","r_stroke","cogn_ep","cogn_global","cogn_po","cogn_ps","cogn_se","cogn_wo","cts_bname","cts_catflu","cts_db","cts_delay","cts_df","cts_doperf","cts_ebdr","cts_ebmt","cts_idea","cts_lopair","cts_mmse30","cts_nccrtd","cts_pmat","cts_read_nart","cts_read_wrat","cts_sdmt","cts_story","cts_wli","cts_wlii","cts_wliii","age_at_visit","iadlsum","katzsum","rosbscl","rosbsum","vision","visionlog","fev","mep","mip","pvc","bun","ca","chlstrl","cl","co2","crn","fasting","glucose","hba1c","hdlchlstrl","hdlratio","k","ldlchlstrl","na","alcohol_g","bmi","htm","phys5itemsum","wtkg","bp11","bp2","bp3","bp31","hypertension_cum","dm_cum","thyroid_cum","chf_cum","claudication_cum","heart_cum","stroke_cum","vasc_3dis_sum","vasc_4dis_sum","vasc_risks_sum","gait_speed","gripavg"],[null,null,null,"NEO agreeableness-ROS","Conscientiousness-ROS/MAP","NEO extraversion-ROS/MAP","NEO altruism scale-MAP","NEO conscientiousness-MAP","NEO trust-MAP","NEO openess-ROS","Anxiety-10 item version - ROS and MAP","Neuroticism - 12 item version-RMM","Neuroticism - 6 item version - RMM","Age at baseline","Age at death","Indicator of death","Years of education","Gender","Participant's race","Spanish/Hispanic origin","ApoE genotype","Lifetime daily alcohol intake -baseline","Smoking quantity-baseline","Smoking duration-baseline","Smoking at baseline","Smoking","Follow-up year","No label found in codebook","CESD-Measure of depressive symptoms","Major depression dx-clinic rating","Negative social exchange-intrusion-MAP","Negative life events","Negative social exchange","Negative social exchange-help-MAP","Panas score","Perceived stress","Negative social exchange - rejection-MAP","Negative social exchange-unsymapathetic-MAP","Clinical dx summary","Dementia diagnosis","Clinical stroke dx","Calculated domain score-episodic memory","Global cognitive score","Calculated domain score - perceptual orientation","Calculated domain score - perceptual speed","Calculated domain score - semantic memory","Calculated domain score - working memory","Boston naming - 2014","Category fluency - 2014","Digits backwards - 2014","Logical memory IIa - 2014","Digits forwards - 2014","Digit ordering - 2014","East Boston story - delayed recall - 2014","East Boston story - immediate - 2014","Complex ideas - 2014","Line orientation - 2014","MMSE - 2014","Number comparison - 2014","Progressive Matrices - 2014","Reading test-NART-2014","Reading test - WRAT - 2014","Symbol digit modalitities - 2014","Logical memory Ia - immediate - 2014","Word list I- immediate- 2014","Word list II - delayed - 2014","Word list III - recognition - 2014","Age at cycle - fractional","Instrumental activities of daily liviing","Katz measure of disability","Rosow-Breslau scale","Rosow-Breslau scale","Vision acuity","Visual acuity","forced expiratory volume","maximal expiratory pressure","maximal inspiratory pressure","pulmonary vital capacity","Blood urea nitrogen","Calcium","Cholesterol","Chloride","Carbon Dioxide","Creatinine","Whether blood was collected on fasting participant","Glucose","Hemoglobin A1c","HDL cholesterol","HDL ratio","Potassium","LDL cholesterol","Sodium","Grams of alcohol per day","Body mass index","Height(meters)","Summary of self reported physical activity\nmeasure (in hours) ROS/MAP","Weight (kg)","Blood pressure measurement- sitting - trial 1","Blood pressure measurement- sitting - trial 2","Hx of Meds for HTN","Blood pressure measurement- standing","Medical conditions - hypertension - cumulative","Medical history - diabetes - cumulative","Medical Conditions - thyroid disease - cumulative","Medical Conditions - congestive heart failure -\ncumulative","Medical conditions - claudication -cumulative","Medical Conditions - heart - cumulative","Clinical Diagnoses - Stroke - cumulative","Vascular disease burden (3 items w/o chf)\nROS/MAP/MARS","Vascular disease burden (4 items) - MAP/MARS\nonly","Vascular disease risk factors","Gait Speed - MAP","Extremity strength"],["design","design","design","personality","personality","personality","personality","personality","personality","personality","personality","personality","personality","demographic","demographic","demographic","demographic","demographic","demographic","demographic","clinical","substance","substance","substance","substance","substance","design","design","psychological","psychological","psychological","psychological","psychological","psychological","psychological","psychological","psychological","psychological","clinical","cognitive","clinical","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","cognitive","demographic","physical","physical","physical","physical","physical","physical","physical","physical","physical","physical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","substance","physical","physical","physical","physical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","clinical","physical","physical"],["id","study","scaled_to.x","agreeableness","conscientiousness","extraversion","neo_altruism","neo_conscientiousness","neo_trust","openness","anxiety_10items","neuroticism_12","neuroticism_6","age_bl","age_death","died","educ","msex","race","spanish","apoe_genotype","alco_life","q3smo_bl","q4smo_bl","smoke_bl","smoking","fu_year","scaled_to.y","cesdsum","r_depres","intrusion","neglifeevents","negsocexchange","nohelp","panas","perceivedstress","rejection","unsympathetic","dcfdx","dementia","r_stroke","cogn_ep","cogn_global","cogn_po","cogn_ps","cogn_se","cogn_wo","cts_bname","catfluency","cts_db","cts_delay","cts_df","cts_doperf","cts_ebdr","cts_ebmt","cts_idea","cts_lopair","mmse","cts_nccrtd","cts_pmat","cts_read_nart","cts_read_wrat","cts_sdmt","cts_story","cts_wli","cts_wlii","cts_wliii","age_at_visit","iadlsum","katzsum","rosbscl","rosbsum","vision","visionlog","fev","mep","mip","pvc","bun","ca","chlstrl","cl","co2","crn","fasting","glucose","hba1c","hdlchlstrl","hdlratio","k","ldlchlstrl","na","alcohol_g","bmi","htm","phys5itemsum","wtkg","bp11","bp2","bp3","bp31","hypertension_cum","dm_cum","thyroid_cum","chf_cum","claudication_cum","heart_cum","stroke_cum","vasc_3dis_sum","vasc_4dis_sum","vasc_risks_sum","gait_speed","gripavg"],["id","","","","","","","","","","","","","age","age","age","education","sex","race","race","apoe","alcohol","smoking","smoking","smoking","smoking","time","","","","","","","","","","","","cognition","dementia","stroke","episodic memory","global cognition","perceptual orientation","perceptual speed","semantic memory","working memory","semantic memory","semantic memory","working memory","episodic memory","working memory","working memory","episodic memory","episodic memory","verbal comprehension","perceptual orientation","dementia","perceptual speed","perceptual orientation","semantic memory","semantic memory","perceptual speed","episodic memory","episodic memory","episodic memory","episodic memory","","physact","physcap","physcap","physcap","physcap","physcap","physcap","physcap","physcap","physcap","","","","","","","","","","","","","","","alcohol","physique","physique","physact","physique","hypertension","hypertension","hypertension","hypertension","hypertension","diabetes","","cardio","","","stroke","","","","physcap","physcap"],["FALSE",null,null,null,null,null,null,null,null,null,null,null,null,"FALSE","FALSE","FALSE","TRUE","FALSE","TRUE","TRUE","FALSE","TRUE","TRUE","TRUE","TRUE","TRUE","FALSE",null,null,null,null,null,null,null,null,null,null,null,"FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","TRUE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE",null,"TRUE","TRUE","TRUE","TRUE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE",null,null,null,null,null,null,null,null,null,null,null,null,null,null,"TRUE","FALSE","FALSE","TRUE","FALSE","FALSE","FALSE","TRUE","FALSE","TRUE","TRUE",null,"TRUE",null,null,"FALSE",null,null,null,"FALSE","FALSE"],["FALSE",null,null,null,null,null,null,null,null,null,null,null,null,"FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","TRUE",null,null,null,null,null,null,null,null,null,null,null,"TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE",null,"TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE",null,null,null,null,null,null,null,null,null,null,null,null,null,null,"FALSE","TRUE","TRUE",null,"TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE",null,"TRUE",null,null,"TRUE",null,null,null,"TRUE","TRUE"],["person","","","","","","","","","","","","","year","year","category","years","category","category","category","scale","drinks/day","cigarettes / day","years","category","category","time point","","","","","","","","","","","","category","0, 1","category","composite","composite","composite","composite","composite","composite","0 to 15","0 to 75","0 to 12","0 to 25","0 to 12","0 to 14","0 to 12","0 to 12","0 to 8","0 to 15","0 to 30","0 to 48","0 to 16","0 to 10","0 to 15","0 to 110","0 to 25","0 to 30","0 to 10","o to 10","","scale","scale","scale","scale","scale","scale","liters","cm H20","cm H20","liters","","","","","","","","","","","","","","","grams","kg/msq","meters","","kilos","","","","","","","","category","","","category","","","","min/sec","lbs"],[true,null,null,null,null,null,null,null,null,null,null,null,null,true,true,true,true,true,true,true,true,true,true,true,true,true,true,null,null,null,null,null,null,null,null,null,null,null,true,true,true,true,true,true,true,true,true,null,null,null,null,null,null,null,null,null,null,true,null,null,null,null,null,null,null,null,null,null,true,true,true,true,true,true,true,true,true,true,null,null,null,null,null,null,null,null,null,null,null,null,null,null,true,true,true,null,true,null,null,null,null,null,null,null,true,null,null,true,null,null,null,true,true]],"container":"<table class=\"cell-border stripe\">\n  <thead>\n    <tr>\n      <th> \u003c/th>\n      <th>name\u003c/th>\n      <th>label\u003c/th>\n      <th>type\u003c/th>\n      <th>name_new\u003c/th>\n      <th>construct\u003c/th>\n      <th>self_reported\u003c/th>\n      <th>longitudinal\u003c/th>\n      <th>unit\u003c/th>\n      <th>include\u003c/th>\n    \u003c/tr>\n  \u003c/thead>\n\u003c/table>","options":{"pageLength":6,"autoWidth":true,"order":[],"orderClasses":false,"columnDefs":[{"orderable":false,"targets":0}],"orderCellsTop":true,"lengthMenu":[6,10,25,50,100]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

#(II) Development

## Define outcome

The purpose of the transformations annotated in this report is to create a categorical outcome variable that would represent the observed state of the individual at time $t$. Mini-mental state exame (`mmse`) has been chosen to operationalize cognitive impairment. Possible states have been defined as :

* `mmse` $=[27,30]$ --> `state = 1` - no impairment  
* `mmse` $=[23,27)$ --> `state = 2` - mild impairment   
* `mmse` $=[0 :22)$ --> `state = 3` - moderate/severe impairment  
* `state = 4` - dead state  

The covariates of interested include:   

* `age` -  Centered at study specific mean age.   
* `birth cohort` - Birth year (?)  
* `male` -  Males 1, Female 0   ï‚§    
* `education` - Categorized as tertiles within each study, Centered as middle tertile (-1, 0, 1)  

The DTO has been queried to select relevant variables. The following view gives data for a two individuals:

```
         id  male age_bl age_death edu fu_year age_at_visit mmse
1   6804844  TRUE  77.34     86.97  13       0        77.34   29
2   6804844  TRUE  77.34     86.97  13       1        78.31   28
3   6804844  TRUE  77.34     86.97  13       2        79.29   26
4   6804844  TRUE  77.34     86.97  13       3        80.30   28
5   6804844  TRUE  77.34     86.97  13       4        81.83   28
6   6804844  TRUE  77.34     86.97  13       5        82.28   28
7   6804844  TRUE  77.34     86.97  13       6        83.35   29
8   6804844  TRUE  77.34     86.97  13       7        84.33   28
9   6804844  TRUE  77.34     86.97  13       8        85.32   28
10  6804844  TRUE  77.34     86.97  13       9        86.72   NA
11 13485298 FALSE  80.69     89.71  12       0        80.69   21
12 13485298 FALSE  80.69     89.71  12       1        81.71   25
13 13485298 FALSE  80.69     89.71  12       2        82.70   27
14 13485298 FALSE  80.69     89.71  12       3        83.70   26
15 13485298 FALSE  80.69     89.71  12       5        85.70   15
16 13485298 FALSE  80.69     89.71  12       6        86.69   NA
17 13485298 FALSE  80.69     89.71  12       7        87.69   23
18 13485298 FALSE  80.69     89.71  12       8        88.72   26
19 30597867 FALSE  75.92     84.56  11       0        75.92   26
20 30597867 FALSE  75.92     84.56  11       1        76.91   28
21 30597867 FALSE  75.92     84.56  11       2        77.91   30
22 50101073 FALSE  84.57     92.02  12       0        84.57   25
23 50101073 FALSE  84.57     92.02  12       1        85.52   28
24 50101073 FALSE  84.57     92.02  12       2        86.49   28
25 50101073 FALSE  84.57     92.02  12       3        87.48   24
26 50101073 FALSE  84.57     92.02  12       4        88.47   28
27 50101073 FALSE  84.57     92.02  12       5        89.49   18
28 50101073 FALSE  84.57     92.02  12       6        90.48   NA
29 50101073 FALSE  84.57     92.02  12       7        91.51    7
30 56751351  TRUE  72.90        NA  18       0        72.90   29
31 56751351  TRUE  72.90        NA  18       1        73.39   26
32 83001827 FALSE  82.03     92.43  13       0        82.03   27
33 83001827 FALSE  82.03     92.43  13       1        82.84   28
34 83001827 FALSE  82.03     92.43  13       2        83.97   NA
35 83001827 FALSE  82.03     92.43  13       3        85.27   NA
36 83001827 FALSE  82.03     92.43  13       4        86.34   NA
37 83001827 FALSE  82.03     92.43  13       5        87.07   NA
38 83001827 FALSE  82.03     92.43  13       6        88.30   NA
39 83001827 FALSE  82.03     92.43  13       7        88.81   NA
40 83001827 FALSE  82.03     92.43  13       8        89.82   NA
41 83001827 FALSE  82.03     92.43  13       9        91.19   NA
```

For the purposes of the current demonstration we fill focus only on the variables that go into computation of the multistate outcome:

```
         id age_death fu_year age_at_visit mmse
1   6804844     86.97       0        77.34   29
2   6804844     86.97       1        78.31   28
3   6804844     86.97       2        79.29   26
4   6804844     86.97       3        80.30   28
5   6804844     86.97       4        81.83   28
6   6804844     86.97       5        82.28   28
7   6804844     86.97       6        83.35   29
8   6804844     86.97       7        84.33   28
9   6804844     86.97       8        85.32   28
10  6804844     86.97       9        86.72   NA
11 13485298     89.71       0        80.69   21
12 13485298     89.71       1        81.71   25
13 13485298     89.71       2        82.70   27
14 13485298     89.71       3        83.70   26
15 13485298     89.71       5        85.70   15
16 13485298     89.71       6        86.69   NA
17 13485298     89.71       7        87.69   23
18 13485298     89.71       8        88.72   26
19 30597867     84.56       0        75.92   26
20 30597867     84.56       1        76.91   28
21 30597867     84.56       2        77.91   30
22 50101073     92.02       0        84.57   25
23 50101073     92.02       1        85.52   28
24 50101073     92.02       2        86.49   28
25 50101073     92.02       3        87.48   24
26 50101073     92.02       4        88.47   28
27 50101073     92.02       5        89.49   18
28 50101073     92.02       6        90.48   NA
29 50101073     92.02       7        91.51    7
30 56751351        NA       0        72.90   29
31 56751351        NA       1        73.39   26
32 83001827     92.43       0        82.03   27
33 83001827     92.43       1        82.84   28
34 83001827     92.43       2        83.97   NA
35 83001827     92.43       3        85.27   NA
36 83001827     92.43       4        86.34   NA
37 83001827     92.43       5        87.07   NA
38 83001827     92.43       6        88.30   NA
39 83001827     92.43       7        88.81   NA
40 83001827     92.43       8        89.82   NA
41 83001827     92.43       9        91.19   NA
```

## Encode multistate
Now we will demonstrate the logic of encoding

```r
# x <- c(NA, 5, NA, 7)
subjects <- as.numeric(unique(ds_long$id))
(N <- length(subjects))
```

```
[1] 1696
```

```r
# define function to be used in the call
determine_censor <- function(x, is_right_censored){
  # as.integer(
    ifelse(is_right_censored, -2,
         ifelse(is.na(x), -1, x)
    # )#,2
  )
}
# d <- ds_long
# i <- "30597867" 
for(i in 1:N){ 
  # Get the individual data:
  (dta.i <- ds_long[ds_long$id==subjects[i],])
  (dta.i <- as.data.frame(dta.i %>% dplyr::arrange(-age_at_visit)))
  (dta.i$mmse_raw     = dta.i$mmse)
  (dta.i$missed_last_wave = (cumsum(!is.na(dta.i$mmse))==0L))
  (dta.i$presumed_alive      =  is.na(any(dta.i$age_death)))
  (dta.i$right_censored   = dta.i$missed_last_wave & dta.i$presumed_alive)
  # dta.i$mmse_recoded     = determine_censor(dta.i$mmse, dta.i$right_censored)
  
  (dta.i$mmse     = determine_censor(dta.i$mmse, dta.i$right_censored))
  (dta.i <- as.data.frame(dta.i %>% dplyr::arrange(age_at_visit)))
  # (dta.i <- dta.i %>% dplyr::select(-missed_last_wave, -right_censored )) 
  # Rebuild the data:
  if(i==1){ds_miss <- dta.i}else{ds_miss <- rbind(ds_miss,dta.i)}
  
} 
# inspect for selected ids
ds_miss %>% 
  dplyr::mutate(id = factor(id), male = factor(male)) %>% 
  dplyr::filter(id %in% ids) %>% 
  DT::datatable(
    class   = 'cell-border stripe',
    caption = "Selected ids for demonstrating encoding rules",
    filter  = "top",
    options = list(pageLength = 6, autoWidth = FALSE )
  )
```

<!--html_preserve--><div id="htmlwidget-3421" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-3421">{"x":{"filter":"top","filterHTML":"<tr>\n  <td>\u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"6804844\">6804844\u003c/option>\n        <option value=\"13485298\">13485298\u003c/option>\n        <option value=\"30597867\">30597867\u003c/option>\n        <option value=\"50101073\">50101073\u003c/option>\n        <option value=\"56751351\">56751351\u003c/option>\n        <option value=\"83001827\">83001827\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"FALSE\">FALSE\u003c/option>\n        <option value=\"TRUE\">TRUE\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"display: none; position: absolute; width: 200px;\">\n      <div data-min=\"72.9\" data-max=\"84.57\" data-scale=\"2\">\u003c/div>\n      <span style=\"float: left;\">\u003c/span>\n      <span style=\"float: right;\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"display: none; position: absolute; width: 200px;\">\n      <div data-min=\"84.56\" data-max=\"92.43\" data-scale=\"2\">\u003c/div>\n      <span style=\"float: left;\">\u003c/span>\n      <span style=\"float: right;\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"display: none; position: absolute; width: 200px;\">\n      <div data-min=\"11\" data-max=\"18\">\u003c/div>\n      <span style=\"float: left;\">\u003c/span>\n      <span style=\"float: right;\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"display: none; position: absolute; width: 200px;\">\n      <div data-min=\"0\" data-max=\"9\">\u003c/div>\n      <span style=\"float: left;\">\u003c/span>\n      <span style=\"float: right;\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"display: none; position: absolute; width: 200px;\">\n      <div data-min=\"72.9\" data-max=\"91.51\" data-scale=\"2\">\u003c/div>\n      <span style=\"float: left;\">\u003c/span>\n      <span style=\"float: right;\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"number\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"display: none; position: absolute; width: 200px;\">\n      <div data-min=\"-1\" data-max=\"30\">\u003c/div>\n      <span style=\"float: left;\">\u003c/span>\n      <span style=\"float: right;\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"integer\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"display: none; position: absolute; width: 200px;\">\n      <div data-min=\"7\" data-max=\"30\">\u003c/div>\n      <span style=\"float: left;\">\u003c/span>\n      <span style=\"float: right;\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"true\">true\u003c/option>\n        <option value=\"false\">false\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"logical\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\">\n        <option value=\"true\">true\u003c/option>\n        <option value=\"false\">false\u003c/option>\n      \u003c/select>\n    \u003c/div>\n  \u003c/td>\n  <td data-type=\"disabled\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\">\u003c/span>\n    \u003c/div>\n  \u003c/td>\n\u003c/tr>","caption":"<caption>Selected ids for demonstrating encoding rules\u003c/caption>","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41"],["6804844","6804844","6804844","6804844","6804844","6804844","6804844","6804844","6804844","6804844","13485298","13485298","13485298","13485298","13485298","13485298","13485298","13485298","30597867","30597867","30597867","50101073","50101073","50101073","50101073","50101073","50101073","50101073","50101073","56751351","56751351","83001827","83001827","83001827","83001827","83001827","83001827","83001827","83001827","83001827","83001827"],["TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","TRUE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","TRUE","TRUE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE","FALSE"],[77.34,77.34,77.34,77.34,77.34,77.34,77.34,77.34,77.34,77.34,80.69,80.69,80.69,80.69,80.69,80.69,80.69,80.69,75.92,75.92,75.92,84.57,84.57,84.57,84.57,84.57,84.57,84.57,84.57,72.9,72.9,82.03,82.03,82.03,82.03,82.03,82.03,82.03,82.03,82.03,82.03],[86.97,86.97,86.97,86.97,86.97,86.97,86.97,86.97,86.97,86.97,89.71,89.71,89.71,89.71,89.71,89.71,89.71,89.71,84.56,84.56,84.56,92.02,92.02,92.02,92.02,92.02,92.02,92.02,92.02,null,null,92.43,92.43,92.43,92.43,92.43,92.43,92.43,92.43,92.43,92.43],[13,13,13,13,13,13,13,13,13,13,12,12,12,12,12,12,12,12,11,11,11,12,12,12,12,12,12,12,12,18,18,13,13,13,13,13,13,13,13,13,13],[0,1,2,3,4,5,6,7,8,9,0,1,2,3,5,6,7,8,0,1,2,0,1,2,3,4,5,6,7,0,1,0,1,2,3,4,5,6,7,8,9],[77.34,78.31,79.29,80.3,81.83,82.28,83.35,84.33,85.32,86.72,80.69,81.71,82.7,83.7,85.7,86.69,87.69,88.72,75.92,76.91,77.91,84.57,85.52,86.49,87.48,88.47,89.49,90.48,91.51,72.9,73.39,82.03,82.84,83.97,85.27,86.34,87.07,88.3,88.81,89.82,91.19],[29,28,26,28,28,28,29,28,28,-1,21,25,27,26,15,-1,23,26,26,28,30,25,28,28,24,28,18,-1,7,29,26,27,28,-1,-1,-1,-1,-1,-1,-1,-1],[29,28,26,28,28,28,29,28,28,null,21,25,27,26,15,null,23,26,26,28,30,25,28,28,24,28,18,null,7,29,26,27,28,null,null,null,null,null,null,null,null],[false,false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,true,true,true,true,true,true,true],[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,true,false,false,false,false,false,false,false,false,false,false],[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]],"container":"<table class=\"cell-border stripe\">\n  <thead>\n    <tr>\n      <th> \u003c/th>\n      <th>id\u003c/th>\n      <th>male\u003c/th>\n      <th>age_bl\u003c/th>\n      <th>age_death\u003c/th>\n      <th>edu\u003c/th>\n      <th>fu_year\u003c/th>\n      <th>age_at_visit\u003c/th>\n      <th>mmse\u003c/th>\n      <th>mmse_raw\u003c/th>\n      <th>missed_last_wave\u003c/th>\n      <th>presumed_alive\u003c/th>\n      <th>right_censored\u003c/th>\n    \u003c/tr>\n  \u003c/thead>\n\u003c/table>","options":{"pageLength":6,"autoWidth":false,"columnDefs":[{"className":"dt-right","targets":[3,4,5,6,7,8,9]},{"orderable":false,"targets":0}],"order":[],"orderClasses":false,"orderCellsTop":true,"lengthMenu":[6,10,25,50,100]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

### Define function

```r
encode_multistates <- function(
  d, # data frame in long format 
  outcome_name, # measure to compute live states
  age_name, # age at each wave
  age_death_name, # age of death
  dead_state_value # value to represent dead state
){
  # declare arguments for debugging
  # d = ds_miss;
  # d = ds_miss; outcome_name = "mmse";age_name = "age_at_visit";age_death_name = "age_death";dead_state_value = 4
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
```

### Encode outcome

```r
ds_ms <- encode_multistates(
  d = ds_miss,
  outcome_name = "mmse",
  age_name = "age_at_visit",
  age_death_name = "age_death",
  dead_state_value = 4
)
```

### Inspect created

```r
# examine transition matrix
msm::statetable.msm(state,id,ds_ms)
```

```
    to
from   -2   -1    1    2    3    4
  -2   32    0    0    0    0    0
  -1    0   25   25   15   27   50
  1    32   58 4830  724  115  248
  2     8   21  535  493  262  149
  3     6   34   24   97  649  233
```

```r
# knitr::kable(msm::statetable.msm(state,id,ds_ms))
```

# Recapitulation


```r
# Save as a compress, binary R dataset.  It's no longer readable with a text editor, but it saves metadata (eg, factor information).

# at this point there exist two relevant data sets:
# ds_miss - missing states are encoded
# ds_ms   - multi   states are encoded
# it is useful to have access to both while understanding/verifying encodings

names(dto)
```

```
[1] "unitData" "metaData" "ms_mmse" 
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
[1] "unitData" "metaData" "ms_mmse" 
```

```r
# 1st element - unit(person) level data
names(dto[["unitData"]])
```

```
  [1] "id"                    "study"                 "scaled_to.x"           "agreeableness"        
  [5] "conscientiousness"     "extraversion"          "neo_altruism"          "neo_conscientiousness"
  [9] "neo_trust"             "openness"              "anxiety_10items"       "neuroticism_12"       
 [13] "neuroticism_6"         "age_bl"                "age_death"             "died"                 
 [17] "educ"                  "msex"                  "race"                  "spanish"              
 [21] "apoe_genotype"         "alco_life"             "q3smo_bl"              "q4smo_bl"             
 [25] "smoke_bl"              "smoking"               "fu_year"               "scaled_to.y"          
 [29] "cesdsum"               "r_depres"              "intrusion"             "neglifeevents"        
 [33] "negsocexchange"        "nohelp"                "panas"                 "perceivedstress"      
 [37] "rejection"             "unsympathetic"         "dcfdx"                 "dementia"             
 [41] "r_stroke"              "cogn_ep"               "cogn_global"           "cogn_po"              
 [45] "cogn_ps"               "cogn_se"               "cogn_wo"               "cts_bname"            
 [49] "catfluency"            "cts_db"                "cts_delay"             "cts_df"               
 [53] "cts_doperf"            "cts_ebdr"              "cts_ebmt"              "cts_idea"             
 [57] "cts_lopair"            "mmse"                  "cts_nccrtd"            "cts_pmat"             
 [61] "cts_read_nart"         "cts_read_wrat"         "cts_sdmt"              "cts_story"            
 [65] "cts_wli"               "cts_wlii"              "cts_wliii"             "age_at_visit"         
 [69] "iadlsum"               "katzsum"               "rosbscl"               "rosbsum"              
 [73] "vision"                "visionlog"             "fev"                   "mep"                  
 [77] "mip"                   "pvc"                   "bun"                   "ca"                   
 [81] "chlstrl"               "cl"                    "co2"                   "crn"                  
 [85] "fasting"               "glucose"               "hba1c"                 "hdlchlstrl"           
 [89] "hdlratio"              "k"                     "ldlchlstrl"            "na"                   
 [93] "alcohol_g"             "bmi"                   "htm"                   "phys5itemsum"         
 [97] "wtkg"                  "bp11"                  "bp2"                   "bp3"                  
[101] "bp31"                  "hypertension_cum"      "dm_cum"                "thyroid_cum"          
[105] "chf_cum"               "claudication_cum"      "heart_cum"             "stroke_cum"           
[109] "vasc_3dis_sum"         "vasc_4dis_sum"         "vasc_risks_sum"        "gait_speed"           
[113] "gripavg"              
```

```r
# 2nd element - meta data, info about variables
names(dto[["metaData"]])
```

```
[1] "name"          "label"         "type"          "name_new"      "construct"     "self_reported" "longitudinal" 
[8] "unit"          "include"      
```

```r
# 3rd element - data for MMSE outcome
names(dto[["ms_mmse"]])
```

```
[1] "missing" "multi"  
```

```r
ds_miss <- dto$ms_mmse$missing
ds_ms <- dto$ms_mmse$multi
```



```rinspect

```


