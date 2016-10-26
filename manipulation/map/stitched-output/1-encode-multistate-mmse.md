



This report was automatically generated with the R package **knitr**
(version 1.14).


```r
# knitr::stitch_rmd(script="./manipulation/rename-classify.R", output="./manipulation/rename-classify.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
```

```r
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 
source("./scripts/general-graphs.R")
source("./scripts/specific-graphs.R")
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
path_output <- "./data/unshared/derived/dto.rds"
```

```r
# load the product of 0-ellis-island.R,  a list object containing data and metad
dto <- readRDS(path_input)
```

```r
names(dto)
```

```
## [1] "unitData" "metaData"
```

```r
# 1st element - unit(person) level data
# dplyr::tbl_df(dto[["unitData"]])
# 2nd element - meta data, info about variables
# dto[["metaData"]]
```

```r
ds <- dto[["unitData"]]

# table(ds$fu_year, ds$dementia)
```

```r
# if died==1, all subsequent focal_outcome==DEAD.
# during debuggin/testing use only a few ids, for manipulation use all
set.seed(43)
ids <- sample(unique(ds$id),3) # randomly select a few ids
# custom select a few ids that give different pattern of data. To be used for testing
ids <- c(33027) #,33027, 50101073, 6804844, 83001827 , 56751351, 13485298, 30597867)
```

```r
ds_long <- ds %>% 
  # dplyr::filter(id %in% ids) %>% # turn this off when using the entire sample
  dplyr::mutate(
    age_at_bl    = as.numeric(age_bl),
    age_at_death = as.numeric(age_death), 
    male      = as.logical(ifelse(!is.na(msex), msex=="1", NA_integer_)),
    edu       = as.numeric(educ)
  ) %>% 
  dplyr::select_(
    "id"
    ,"died"  
    ,"age_death"
    ,"male"
    ,"edu"
    # ,"birth_date" # perturbed data of birth
    ,"birth_year" # the year of birth
    # ,"date_at_bl" # date at baseline 
    ,"age_at_bl" # age at baseline 
# time-invariant above
    ,"fu_year" # Follow-up year ------------------------------------------------
# time-variant below
    ,"date_at_visit" # perturbed date of visit
    ,"age_at_visit" #Age at cycle - fractional  
    ,"mmse"
    ,"income_40" # income at age 40
    ,"cogact_old" # cognitive activity in late life
    ,"socact_old" # social activity in late life
    ,"soc_net" # social network size
    ,"social_isolation" # loneliness   
    ) 
# save to disk for direct examination
# write.csv(d,"./data/shared/musti-state-dementia.csv")  


# inspect crated data object
ds_long %>% 
  dplyr::filter(id %in% ids) %>% 
  print()
```

```
##      id died age_death  male edu birth_year age_at_bl fu_year
## 1 33027    0        NA FALSE  14       1922  81.00753       0
## 2 33027    0        NA FALSE  14       1922  81.00753       1
##   date_at_visit age_at_visit mmse income_40 cogact_old socact_old soc_net
## 1    2003-07-01     81.00753   29         7   2.714286   1.500000       1
## 2    2004-08-15     82.13552   NA         7   3.000000   1.333333       4
##   social_isolation
## 1              1.8
## 2              2.2
```

```r
t <- table(ds_long[,"fu_year"], ds_long[,"died"]); t[t==0]<-".";t
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
# raw_smooth_lines(ds_long, "mmse")
```

```r
# x <- c(NA, 5, NA, 7)
determine_censor <- function(x, is_right_censored){
  ifelse(is_right_censored, -2,
         ifelse(is.na(x), -1, x)
  )
}
(N <- length(unique(ds_long$id))) # sample size
```

```
## [1] 1853
```

```r
(subjects <- as.numeric(unique(ds_long$id))) # list the ids
```

```
##    [1]     9121    33027   204228   228190   246264   285563   402800
##    [8]   482428   617643   668310   696418   701662   709354   807897
##   [15]  1172523  1179886  1243685  1250710  1266704  1393350  1626306
##   [22]  1634158  1674624  1738075  1797756  1809849  1841461  1878130
##   [29]  2108769  2136155  2158395  2188675  2518573  2525608  2657173
##   [36]  2673641  2695917  2817047  2899847  2904677  2950975  2959960
##   [43]  2967974  3052480  3060782  3227207  3283241  3326467  3335936
##   [50]  3340627  3368115  3380931  3430444  3700779  3713990  3806878
##   [57]  3889845  3902977  3918123  3971682  4127190  4319814  4330337
##   [64]  4406282  4493359  4576591  4767750  4862682  4879843  4886978
##   [71]  4941596  4947970  4968529  4981936  4984547  5001777  5102083
##   [78]  5200652  5218242  5225665  5274286  5296264  5331374  5375330
##   [85]  5389430  5427601  5498462  5522533  5537936  5577538  5632732
##   [92]  5689621  5779736  5859529  5931594  6073025  6107196  6129174
##   [99]  6131380  6138931  6152191  6272612  6625341  6702361  6764103
##  [106]  6769734  6804844  6881437  7042636  7053099  7096040  7117738
##  [113]  7142937  7195200  7253015  7265221  7287209  7311370  7570491
##  [120]  7761236  7803023  7883803  7985700  8072948  8098966  8109170
##  [127]  8132197  8245033  8323356  8337320  8390339  8464714  8481297
##  [134]  8536593  8558869  8604620  8637647  8682642  8891975  8899955
##  [141]  9032080  9061779  9108223  9165434  9215361  9248090  9351224
##  [148]  9391376  9391790  9508427  9536237  9650662  9687331  9790439
##  [155]  9841821  9892462  9896826  9986931 10002167 10029352 10042633
##  [162] 10093562 10371937 10516212 10665684 10788554 10989297 11130624
##  [169] 11266139 11291338 11364960 12317427 12337359 12357443 12365619
##  [176] 12368518 12766954 12788806 12799845 12850397 12872825 13026999
##  [183] 13064995 13103757 13258503 13269830 13282409 13346850 13360984
##  [190] 13380780 13419518 13432899 13447030 13462593 13464351 13485298
##  [197] 13515617 13633244 13635552 13666711 13743579 13747771 13885104
##  [204] 13939071 13998626 14030021 14050539 14074375 14184286 14393933
##  [211] 14397423 14452889 14458137 14487402 14498577 14536586 14575759
##  [218] 14696573 14726154 14861002 14871874 15003546 15218541 15269182
##  [225] 15286377 15302308 15304328 15373321 15376482 15387421 15548986
##  [232] 15656453 15690969 15938020 16019850 16029910 16047796 16064431
##  [239] 16068769 16136058 16207822 16212351 16215962 16235506 16238829
##  [246] 16265624 16288167 16322424 16403934 16446147 16513683 16583691
##  [253] 16597115 16621574 16716896 16733667 16835690 16879494 17151093
##  [260] 17166496 17219510 17233356 17255334 17260313 17345449 17375017
##  [267] 17413576 17497710 17615774 17659730 17705889 17712202 17827744
##  [274] 17863982 17929065 17974060 17974222 18014283 18112988 18126826
##  [281] 18219966 18293524 18301541 18393249 18414513 18455382 18500390
##  [288] 18611216 18643192 18659212 18740882 18882093 18910654 18920002
##  [295] 18942080 18948888 19114228 19241874 19325445 19367355 19429100
##  [302] 19460005 19606719 19651714 19721447 19785885 19852619 19897716
##  [309] 19928140 19994956 20046260 20088044 20185734 20368989 20735030
##  [316] 20842880 20853379 20860828 20907534 21305588 21310305 21362537
##  [323] 21539112 21608092 21986205 22396591 22408684 22454720 22486606
##  [330] 22644848 22677865 22683723 22776575 22789958 22809217 22813029
##  [337] 22832810 22865387 22868024 22880976 22887653 22903134 23004922
##  [344] 23354613 23601829 23634846 23690880 23791808 23825005 23860814
##  [351] 23870000 23892088 23895699 23993132 24039289 24051131 24067675
##  [358] 24073245 24097955 24141372 24185338 24219409 24242426 24310553
##  [365] 24328729 24348651 24414506 24523376 24644776 24664996 24680888
##  [372] 24747976 24769404 24930281 24951704 24969970 25248418 25254664
##  [379] 25254826 25300551 25423683 25455983 25464740 25580771 25670598
##  [386] 25681825 25779758 25837301 25939172 25974431 26011331 26084536
##  [393] 26277427 26330313 26334777 26334803 26468686 26498416 26516467
##  [400] 26569730 26581268 26631069 26637867 26671823 26722927 26795384
##  [407] 26801129 26929170 26938063 26975216 26992537 27054288 27083391
##  [414] 27242962 27313862 27463113 27481601 27509940 27560777 27586957
##  [421] 27745104 27865599 27908391 28013603 28044600 28086510 28127842
##  [428] 28314511 28363718 28388569 28517012 28628802 28663873 28680644
##  [435] 28875005 29026694 29067201 29182641 29197882 29244108 29278716
##  [442] 29306403 29323436 29399378 29403481 29462612 29504823 29540773
##  [449] 29629849 29806034 29821047 29843151 29933130 30028369 30257786
##  [456] 30261598 30282435 30311425 30456409 30597867 30604167 30663686
##  [463] 30711043 30755009 30819298 31037310 31095950 31143443 31156114
##  [470] 31272569 31291350 31504924 31509843 31533749 31578558 31586274
##  [477] 31587865 31680227 31701041 31726180 31728786 31756046 31813134
##  [484] 31824173 31914288 31989791 32016379 32114650 32202457 32244817
##  [491] 32383679 32533645 32689956 32697960 32705437 32816489 32863530
##  [498] 32959281 32971269 33006377 33062311 33084399 33118460 33135105
##  [505] 33137549 33154734 33321607 33332646 33360294 33400773 33411712
##  [512] 33416479 33423630 33477756 33501827 33635574 33646937 33657002
##  [519] 33659310 33679954 33707641 33725003 33781047 34018777 34070069
##  [526] 34070357 34108468 34135713 34185763 34204855 34204981 34287534
##  [533] 34317953 34326260 34378654 34453492 34524842 34542628 34726040
##  [540] 34748028 34766480 34777681 34781079 34853696 34962204 34999847
##  [547] 35072859 35079112 35110444 35170130 35259170 35286551 35299510
##  [554] 35458631 35463458 35521263 35558806 35592862 35705009 35847634
##  [561] 35908898 35913453 35941263 35967579 36010337 36087310 36128228
##  [568] 36220549 36267530 36379623 36379885 36487640 36492755 36642271
##  [575] 36654487 36689398 36719393 36751041 36773029 36791229 36830117
##  [582] 36855706 36951779 36953249 36978388 36997205 37030589 37065652
##  [589] 37070929 37125649 37178462 37190440 37251992 37280555 37326968
##  [596] 37393077 37436329 37439930 37452211 37470097 37527863 37529621
##  [603] 37617978 37700720 37712486 37750518 37759927 37809304 37865636
##  [610] 37913381 37914710 37946272 37997363 38056377 38090333 38113465
##  [617] 38131115 38292829 38599661 38606123 38618915 38831212 38881712
##  [624] 38967303 39125441 39130132 39136480 39184672 39226595 39236493
##  [631] 39250103 39282539 39304782 39316600 39339855 39393581 39405962
##  [638] 39407432 39484737 39539033 39541825 39680713 39721045 39800111
##  [645] 39809520 39898329 39989287 40071481 40385646 40401703 40510997
##  [652] 40530379 40530793 40600002 40611041 40622080 40745950 40756151
##  [659] 40768529 40871627 40880222 40983260 41228878 41265021 41285665
##  [666] 41296604 41357606 41417981 41587876 41635233 41725500 41731170
##  [673] 41746159 41757198 41773404 41828674 41871523 41915754 41941382
##  [680] 41948357 42023091 42063693 42174519 42297641 42387756 42433067
##  [687] 42450388 42543978 42589954 42680008 42721592 42826974 42949394
##  [694] 42950045 42988567 43074402 43116037 43119512 43169148 43191312
##  [701] 43211671 43403133 43485807 43536587 43556383 43556969 43636464
##  [708] 43872204 44019405 44041093 44299049 44472870 44655449 44671043
##  [715] 44749170 44751386 44797362 44842532 44951690 44952317 44985334
##  [722] 45115248 45122535 45212640 45223689 45352543 45450112 45481821
##  [729] 45514725 45566083 45627085 45635549 45795112 45800230 45855523
##  [736] 45984063 45986371 46000440 46105408 46110487 46178577 46189516
##  [743] 46226934 46229419 46246604 46251007 46291609 46358797 46369736
##  [750] 46433373 46516939 46547648 46561196 46808242 46814524 46909396
##  [757] 46910335 46957588 47054886 47067421 47189548 47214624 47229991
##  [764] 47236602 47315778 47371712 47520485 47619873 47652086 47705812
##  [771] 47955338 48013463 48023497 48129208 48192539 48331728 48451825
##  [778] 48480640 48513418 48697089 48748345 48778463 49007537 49070444
##  [785] 49094578 49297367 49333806 49380119 49428128 49429845 49452862
##  [792] 49507582 49590907 49643021 49676048 49766153 49772985 49845805
##  [799] 50100068 50100194 50100220 50100356 50100482 50100518 50100644
##  [806] 50100770 50100806 50100932 50101073 50101109 50101235 50101361
##  [813] 50101497 50101523 50101659 50101785 50101811 50101947 50102088
##  [820] 50102114 50102240 50102376 50102402 50102538 50102664 50102790
##  [827] 50102826 50102952 50103093 50103129 50103255 50103381 50103417
##  [834] 50103543 50103679 50103705 50103831 50103967 50104008 50104134
##  [841] 50104260 50104396 50104422 50104558 50104684 50104710 50104846
##  [848] 50104972 50105013 50105149 50105275 50105301 50105437 50105563
##  [855] 50105699 50105725 50105851 50105987 50106028 50106154 50106280
##  [862] 50106316 50106442 50106578 50106604 50106730 50106866 50106992
##  [869] 50107033 50107169 50107295 50107321 50107457 50107583 50107619
##  [876] 50107745 50107871 50107907 50108048 50108174 50108200 50108336
##  [883] 50108462 50108598 50108624 50108750 50108886 50108912 50109053
##  [890] 50109189 50109215 50109477 50109503 50109639 50109927 50111971
##  [897] 50112274 50112436 50197261 50197711 50199993 50300084 50300110
##  [904] 50300246 50300372 50300408 50300534 50300660 50300796 50300822
##  [911] 50300958 50301099 50301125 50301251 50301387 50301413 50301549
##  [918] 50301675 50301701 50301963 50302004 50302130 50302266 50302392
##  [925] 50302428 50302554 50302680 50302716 50302842 50302978 50303019
##  [932] 50303145 50303271 50303307 50304024 50304998 50305165 50400259
##  [939] 50400385 50400411 50400673 50400709 50400835 50400961 50401002
##  [946] 50401264 50401390 50401426 50401714 50401840 50401976 50402017
##  [953] 50402143 50402279 50402305 50402431 50402567 50402693 50402729
##  [960] 50402855 50402981 50403158 50403284 50403310 50403446 50403572
##  [967] 50403860 50403996 50404037 50404163 50404299 50404325 50404451
##  [974] 50404749 50405042 50405330 50405592 50406057 50406183 50406345
##  [981] 50406471 50406633 50406769 50407486 50407800 50407936 50408077
##  [988] 50408103 50408239 50408365 50408491 50408527 50408653 50408789
##  [995] 50408815 50408941 50409370 50409406 50409532 50409668 50409794
## [1002] 50409820 50409956 50410021 50410157 50410283 50410319 50410445
## [1009] 50500000 50500136 50500424 50500550 50501015 50502020 50502156
## [1016] 50502282 50502606 50551515 50666895 50723983 50957643 51039226
## [1023] 51129205 51164438 51400993 51442191 51515723 51520126 51541487
## [1030] 51599255 51622573 51624179 51650969 51668135 51730202 51791453
## [1037] 51815338 51826377 51864085 51903261 51938758 52018573 52052115
## [1044] 52064033 52173227 52175661 52178858 52256919 52298793 52311825
## [1051] 52322864 52509923 52731249 52764842 52781299 52939119 52940446
## [1058] 52957571 53180384 53192752 53200779 53355949 53356828 53389845
## [1065] 53422197 53495004 53533437 53585533 53588568 53641742 53682197
## [1072] 53727207 53772202 53791255 53825614 53932202 53965805 54104440
## [1079] 54122640 54324848 54458919 54519335 54539393 54559063 54571041
## [1086] 54572768 54661156 54739607 54743671 55025694 55061706 55177253
## [1093] 55204773 55296057 55314846 55385157 55392868 55530204 55580128
## [1100] 55583441 55585885 55598394 55603674 55772716 55820335 55861780
## [1107] 55897318 55932428 55943467 55994710 56025914 56029116 56090689
## [1114] 56102646 56180668 56214739 56263800 56266835 56416937 56486107
## [1121] 56569763 56629174 56670427 56696733 56742594 56751351 56800561
## [1128] 56961563 56979865 57002539 57003706 57251590 57293950 57311163
## [1135] 57434619 57442623 57529355 57597479 57833358 57835666 57978468
## [1142] 57978756 58006501 58014515 58051920 58108372 58143217 58171603
## [1149] 58199939 58203880 58306828 58326624 58331153 58458351 58501637
## [1156] 58531593 58677906 59150662 59166782 59204827 59217750 59306274
## [1163] 59320984 59449940 59497970 59500816 59598024 59618707 59671554
## [1170] 59720188 59756266 59865900 60153630 60248664 60278494 60346107
## [1177] 60370977 60593724 60638122 60655605 60725338 60747316 60848460
## [1184] 60871487 60909048 60922329 60961592 61029627 61055543 61074758
## [1191] 61142759 61344957 61389630 61490006 61542827 61548175 61579172
## [1198] 61595488 61640072 61709892 61827429 62176713 62301938 62367972
## [1205] 62398393 62404688 62483327 62502833 62574447 62578487 62651593
## [1212] 62720059 62985554 63144733 63188799 63198723 63227551 63290882
## [1219] 63357970 63514945 63551648 63649283 63698192 63740337 63818202
## [1226] 63821685 63861449 63874408 63986591 64145770 64150173 64216968
## [1233] 64287431 64291829 64336939 64358179 64386439 64493027 64505110
## [1240] 64635241 64831489 64925372 64997274 64997850 65001607 65017989
## [1247] 65082780 65084674 65214844 65292866 65309742 65384603 65499271
## [1254] 65539462 65608216 65652206 65685223 65692934 65736039 65778949
## [1261] 65838800 65856136 65925304 65933570 65952361 65990079 66069855
## [1268] 66132199 66233829 66394957 66406040 66447233 66451045 66523086
## [1275] 66754397 66787314 66800446 66905828 66924745 67185070 67216828
## [1282] 67227993 67266328 67418026 67429065 67510897 67531158 67628490
## [1289] 67632202 67725478 67831051 67872082 67946467 68005345 68015667
## [1296] 68217991 68240882 68419063 68481703 68525196 68539908 68611261
## [1303] 68725248 68745332 68772001 68778359 68813045 68914513 68977784
## [1310] 69087591 69099545 69187342 69331934 69432088 69528865 69540555
## [1317] 69544171 69577198 69660076 69866926 69920089 69924281 69982407
## [1324] 69982533 70153803 70212461 70329923 70344350 70625336 70636113
## [1331] 70669392 70696773 70726480 70816595 70836715 70883578 70917649
## [1338] 70939627 71063018 71070017 71263584 71291394 71356048 71428241
## [1345] 71514280 71532930 71537723 71558084 71560290 71592202 71626373
## [1352] 71648351 71727427 71755101 71806467 71932972 71952642 72010353
## [1359] 72026185 72031614 72066525 72076711 72152564 72188804 72205714
## [1366] 72207446 72276737 72277580 72324068 72343697 72347501 72419830
## [1373] 72448817 72560222 72650337 72659872 72717425 72777797 72795447
## [1380] 72830557 72841884 72918294 73033080 73146926 73177635 73369061
## [1387] 73549281 73763467 73943687 73957787 73976154 74067756 74078795
## [1394] 74174632 74191827 74203334 74284255 74494179 74536966 74552010
## [1401] 74587057 74635126 74708460 74718818 74753465 74797421 74961945
## [1408] 75001294 75009300 75161029 75169847 75175129 75262623 75359253
## [1415] 75458387 75495116 75507759 75510556 75647940 75675336 75797165
## [1422] 75833578 75861964 75862131 75990666 76008327 76025224 76137867
## [1429] 76280567 76431098 76621666 76731441 76733461 76755449 76867532
## [1436] 76878571 76992870 77034013 77108236 77143621 77180612 77239958
## [1443] 77252103 77273914 77330002 77333587 77366180 77631046 77689940
## [1450] 77716758 77743003 77790442 77868579 77891596 77970662 77999453
## [1457] 78005770 78010047 78072753 78123271 78195885 78267114 78331049
## [1464] 78353027 78410089 78452313 78476159 78511269 78657384 78707509
## [1471] 78724406 78905055 78916544 79087764 79155639 79411152 79412879
## [1478] 79455082 79462793 79501267 79521487 79576932 79590228 79680333
## [1485] 79692387 79742340 79769959 79803180 79938680 79953855 79978444
## [1492] 80161242 80187972 80204332 80320651 80333458 80345114 80352799
## [1499] 80368783 80432870 80450368 80487613 80592317 80606718 80686912
## [1506] 80790863 80915504 80930779 81086436 81148605 81185560 81274534
## [1513] 81354615 81403249 81455345 81504393 81526371 81569322 81576033
## [1520] 81622344 81639479 81783210 81795552 81810992 81852640 81874628
## [1527] 82003527 82138315 82140107 82317494 82325110 82335720 82366015
## [1534] 82455953 82478522 82520217 82527318 82617423 82624422 82643501
## [1541] 82647965 82684406 82728899 82736939 82780217 82858344 82890542
## [1548] 83001827 83034844 83112293 83164399 83173570 83216408 83351356
## [1555] 83419611 83622984 83700171 83721144 83874718 83902667 83944153
## [1562] 83984043 84091825 84248280 84417209 84483565 84525776 84563196
## [1569] 84642424 84653463 84732827 84858308 84896566 84916951 84945776
## [1576] 84949680 84955962 85036828 85065193 85065931 85171938 85266386
## [1583] 85300481 85328131 85395114 85508351 85509528 85527016 85539934
## [1590] 85578107 85584353 85666580 85762265 85925902 85980779 86037865
## [1597] 86071821 86127970 86177506 86274610 86295007 86408244 86420222
## [1604] 86471999 86600442 86668820 86712535 86767530 86880662 86901774
## [1611] 86903794 86910081 86934089 86937852 86947750 86956481 87038802
## [1618] 87121230 87179008 87195990 87208386 87264456 87275819 87330987
## [1625] 87386573 87410220 87555330 87585034 87604126 87645445 87702533
## [1632] 87779516 87821751 87942151 87948797 88001453 88015139 88029789
## [1639] 88038410 88041767 88049747 88106709 88182963 88488240 88499289
## [1646] 88558711 88703606 88799920 88837803 88869941 88961000 89001223
## [1653] 89065823 89160755 89164957 89171820 89377194 89437343 89445221
## [1660] 89461663 89512181 89515666 89546375 89613947 89614402 89645797
## [1667] 89649999 89800328 89811231 89876260 89903942 89912411 89929122
## [1674] 89968269 89975556 90021936 90076229 90100426 90133029 90155007
## [1681] 90173045 90214403 90224563 90254005 90267190 90387747 90429110
## [1688] 90434801 90439144 90447310 90496931 90536384 90544000 90544686
## [1695] 90559953 90581541 90661046 90780976 90805280 90821208 90906596
## [1702] 90942860 90977195 91018909 91189485 91199969 91214985 91231332
## [1709] 91280115 91347203 91349809 91444029 91525115 91583467 91670673
## [1716] 91707643 91763687 91804757 91875770 91897758 91921829 91949579
## [1723] 92023910 92039030 92068279 92113025 92276597 92308774 92371267
## [1730] 92393245 92427316 92454247 92539409 92602617 92613520 92629514
## [1737] 92693724 92928376 92959959 92996364 93014211 93024957 93041854
## [1744] 93103023 93154240 93417026 93462021 93493992 93504106 93667416
## [1751] 93770190 93787649 93815598 93966278 94092977 94115009 94144536
## [1758] 94171205 94205114 94225596 94328246 94362202 94430339 94463356
## [1765] 94549523 94630355 94722642 94734696 94803738 94828877 94852511
## [1772] 94937061 94974890 95048469 95116046 95127085 95161041 95185625
## [1779] 95252909 95281012 95329283 95330358 95373147 95398862 95439194
## [1786] 95442315 95453354 95491648 95600557 95620227 95638231 95723689
## [1793] 95845256 95868799 95902182 95914848 95919181 96016939 96091926
## [1800] 96095092 96140000 96177193 96189273 96244639 96306484 96314498
## [1807] 96337805 96351191 96370720 96529231 96612533 96741073 96892753
## [1814] 96915597 97006937 97130008 97161005 97220113 97264179 97449632
## [1821] 97478169 97498839 97749823 97775875 97859996 97882751 98096223
## [1828] 98186040 98273670 98322204 98388248 98430933 98506202 98844813
## [1835] 98866341 98919041 98953007 99041674 99110004 99151323 99210431
## [1842] 99278233 99367207 99526580 99592710 99693576 99718754 99746564
## [1849] 99750664 99809748 99893592 99911705 99982430
```

```r
# ds_long_temp <- ds_long
# i <- 5; 
for(i in 1:N){
# for(i in unique(ds$id)){  # use this line for testing
  # Get the individual data:
  # ds_long <- ds_long_temp %>% 
  #   dplyr::select(id, fu_year, age_at_visit,died, age_death, mmse) %>% 
  #   as.data.frame()
  (dta.i <- ds_long[ds_long$id==subjects[i],]) # select a single individual
  # (dta.i <- ds_long[ds_long$id==6804844,]) # select a single individual # use this line for testing
  (dta.i <- as.data.frame(dta.i %>% dplyr::arrange(-age_at_visit))) # enforce sorting
  (dta.i$missed_last_wave <- (cumsum(!is.na(dta.i$mmse))==0L)) # is the last obs missing?
  (dta.i$presumed_alive   =  is.na(any(dta.i$age_death))) # can we presume subject alive?
  (dta.i$right_censored   = dta.i$missed_last_wave & dta.i$presumed_alive) # right-censored?
  # dta.i$mmse_recoded     = determine_censor(dta.i$mmse, dta.i$right_censored) # use when tracing
  (dta.i$mmse     <- determine_censor(dta.i$mmse, dta.i$right_censored)) # replace in reality
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

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
## logical

## Warning in any(dta.i$age_death): coercing argument of type 'double' to
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
# inspect crated data object
ds_miss %>% 
  dplyr::filter(id %in% ids) %>% 
  print()
```

```
##      id died age_death  male edu birth_year age_at_bl fu_year
## 1 33027    0        NA FALSE  14       1922  81.00753       0
## 2 33027    0        NA FALSE  14       1922  81.00753       1
##   date_at_visit age_at_visit mmse income_40 cogact_old socact_old soc_net
## 1    2003-07-01     81.00753   29         7   2.714286   1.500000       1
## 2    2004-08-15     82.13552   -2         7   3.000000   1.333333       4
##   social_isolation presumed_alive
## 1              1.8           TRUE
## 2              2.2           TRUE
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
  d[,"raw_outcome"] <- d[,outcome_name] # create a copy
  # standardize names
  colnames(d)[colnames(d)==outcome_name] <- "state" # ELECT requires this name
  colnames(d)[colnames(d)==age_name] <- "age" # ELECT requires this name
  # for(i in unique(ds$id)){  # use this line for testing
  for(i in 1:N){
    # Get the individual data: i = 1
    (dta.i <- d[d$id==subjects[i],])
    # (dta.i <- ds_long[ds_long$id==6804844,]) # select a single individual # use this line for testing
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
  colnames(dta1)[colnames(dta1)=="raw_outcome"] <- outcome_name
  dta1[dta1$state == dead_state_value,outcome_name] <- NA_real_
  dta1[dta1$state == dead_state_value,"fu_year"] <- NA_real_
  return(dta1)
}

ds_ms <- encode_multistates(
  d = ds_miss,
  outcome_name = "mmse",
  age_name = "age_at_visit",
  age_death_name = "age_death",
  dead_state_value = 4
)
# set.seed(NULL)
# ids <- sample(unique(ds$id),1)
ids <- 50107169
ds_ms %>% 
  dplyr::filter(id %in% ids) %>% 
  print()
```

```
##         id died  male edu birth_year age_at_bl fu_year date_at_visit
## 1 50107169    1 FALSE  13       1914  84.11499       0    1998-03-01
## 2 50107169    1 FALSE  13       1914  84.11499       1    1999-03-13
## 3 50107169    1 FALSE  13       1914  84.11499       2    2000-03-08
## 4 50107169    1 FALSE  13       1914  84.11499      NA    1998-03-01
##        age state income_40 cogact_old socact_old soc_net social_isolation
## 1 84.11499     1        NA       2.25          2       8               NA
## 2 85.14716     1        NA         NA         NA       8               NA
## 3 86.13826     2        NA         NA         NA      11               NA
## 4 86.49418     4        NA       2.25          2       8               NA
##   presumed_alive mmse
## 1          FALSE   28
## 2          FALSE   27
## 3          FALSE   26
## 4          FALSE   NA
```

```r
correct_values_at_death <- function(
  ds, # data frame in long format with multistates encoded
  outcome_name, # measure to correct value in
  dead_state_value # value that represents dead state
){
  ds[ds$state == dead_state_value, outcome_name] <- NA_real_
  return(ds)
}
# d <- ds_ms %>% correct_values_at_death("dementia", 4)
# 
# correct_these_variables <- c("dementia", "income_40", "date_at_visit","cogact_old",
#                              "socact_old", "soc_net","social_isolation")

# for(i in correct_these_variables){

  ds_ms[ds_ms$state == 4, "date_at_visit"] <- NA # because of date format
  
  ds_ms <- ds_ms %>% correct_values_at_death("dementia",4)
  ds_ms <- ds_ms %>% correct_values_at_death("income_40",4)
  ds_ms <- ds_ms %>% correct_values_at_death("cogact_old",4)
  ds_ms <- ds_ms %>% correct_values_at_death("socact_old",4)
  ds_ms <- ds_ms %>% correct_values_at_death("soc_net",4)
  ds_ms <- ds_ms %>% correct_values_at_death("social_isolation",4)
# }

ds_ms %>% 
  dplyr::filter(id %in% ids) %>% 
  print()
```

```
##         id died  male edu birth_year age_at_bl fu_year date_at_visit
## 1 50107169    1 FALSE  13       1914  84.11499       0    1998-03-01
## 2 50107169    1 FALSE  13       1914  84.11499       1    1999-03-13
## 3 50107169    1 FALSE  13       1914  84.11499       2    2000-03-08
## 4 50107169    1 FALSE  13       1914  84.11499      NA          <NA>
##        age state income_40 cogact_old socact_old soc_net social_isolation
## 1 84.11499     1        NA       2.25          2       8               NA
## 2 85.14716     1        NA         NA         NA       8               NA
## 3 86.13826     2        NA         NA         NA      11               NA
## 4 86.49418     4        NA         NA         NA      NA               NA
##   presumed_alive mmse dementia
## 1          FALSE   28       NA
## 2          FALSE   27       NA
## 3          FALSE   26       NA
## 4          FALSE   NA       NA
```

```r
(N  <- length(unique(ds_ms$id)))
```

```
## [1] 1853
```

```r
subjects <- as.numeric(unique(ds_ms$id))
# Add first observation indicator
# this creates a new dummy variable "firstobs" with 1 for the first wave
cat("\nFirst observation indicator is added.\n")
```

```
## 
## First observation indicator is added.
```

```r
offset <- rep(NA,N)
for(i in 1:N){offset[i] <- min(which(ds_ms$id==subjects[i]))}
firstobs <- rep(0,nrow(ds_ms))
firstobs[offset] <- 1
ds_ms <- cbind(ds_ms ,firstobs=firstobs)
print(head(ds_ms))
```

```
##     id died  male edu birth_year age_at_bl fu_year date_at_visit      age
## 1 9121    0 FALSE  12       1930  79.96988       0    2010-06-01 79.96988
## 2 9121    0 FALSE  12       1930  79.96988       1    2011-07-12 81.08145
## 3 9121    0 FALSE  12       1930  79.96988       2    2012-01-22 81.61259
## 4 9121    0 FALSE  12       1930  79.96988       3    2013-01-14 82.59548
## 5 9121    0 FALSE  12       1930  79.96988       4    2014-01-14 83.59480
## 6 9121    0 FALSE  12       1930  79.96988       5    2015-01-18 84.60507
##   state income_40 cogact_old socact_old soc_net social_isolation
## 1     1         6   2.142857   2.666667       6              2.2
## 2     1         6   1.714286   2.333333       8              2.0
## 3     1         6   1.714286   2.333333       8              2.0
## 4     1         6   1.714286   2.500000       9              1.4
## 5     1         6   2.000000   2.166667       6              1.8
## 6     1         6   1.857143   2.500000       9              1.6
##   presumed_alive mmse dementia firstobs
## 1           TRUE   29       NA        1
## 2           TRUE   29       NA        0
## 3           TRUE   30       NA        0
## 4           TRUE   30       NA        0
## 5           TRUE   29       NA        0
## 6           TRUE   30       NA        0
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
##            id died age_death  male edu birth_year age_at_bl fu_year
## 8364 68914513    1  84.47639 FALSE  15       1927  75.43874       0
## 8365 68914513    1  84.47639 FALSE  15       1927  75.43874       1
## 8366 68914513    1  84.47639 FALSE  15       1927  75.43874       2
## 8367 68914513    1  84.47639 FALSE  15       1927  75.43874       3
## 8368 68914513    1  84.47639 FALSE  15       1927  75.43874       4
## 8369 68914513    1  84.47639 FALSE  15       1927  75.43874       5
## 8370 68914513    1  84.47639 FALSE  15       1927  75.43874       6
## 8371 68914513    1  84.47639 FALSE  15       1927  75.43874       7
## 8372 68914513    1  84.47639 FALSE  15       1927  75.43874       8
## 8373 68914513    1  84.47639 FALSE  15       1927  75.43874       9
##      date_at_visit age_at_visit mmse income_40 cogact_old socact_old
## 8364    2003-04-01     75.43874   30         7   2.000000   3.000000
## 8365    2004-01-19     76.24093   28         7   4.142857   3.833333
## 8366    2005-01-16     77.23477   28         7   3.428571   3.166667
## 8367    2006-01-22     78.25325   28         7   3.571429   2.833333
## 8368    2007-01-27     79.26626   28         7   3.142857   3.000000
## 8369    2008-01-21     80.24914   27         7   3.285714   2.833333
## 8370    2009-01-19     81.24572   29         7   2.571429   2.000000
## 8371    2010-01-14     82.23409   28         7   3.285714   2.666667
## 8372    2011-01-20     83.24983   28         7   3.142857   2.333333
## 8373    2012-01-13     84.22998   26         7   3.571429   1.833333
##      soc_net social_isolation presumed_alive
## 8364       4              1.4          FALSE
## 8365      NA              1.2          FALSE
## 8366       2              1.6          FALSE
## 8367       5              1.8          FALSE
## 8368       2              1.4          FALSE
## 8369       9              2.8          FALSE
## 8370       2              2.0          FALSE
## 8371       3              2.4          FALSE
## 8372       5              2.0          FALSE
## 8373       8              2.0          FALSE
## 
## After ms encoding 
##             id died  male edu birth_year age_at_bl fu_year date_at_visit
## 8364  68914513    1 FALSE  15       1927  75.43874       0    2003-04-01
## 8365  68914513    1 FALSE  15       1927  75.43874       1    2004-01-19
## 8366  68914513    1 FALSE  15       1927  75.43874       2    2005-01-16
## 8367  68914513    1 FALSE  15       1927  75.43874       3    2006-01-22
## 8368  68914513    1 FALSE  15       1927  75.43874       4    2007-01-27
## 8369  68914513    1 FALSE  15       1927  75.43874       5    2008-01-21
## 8370  68914513    1 FALSE  15       1927  75.43874       6    2009-01-19
## 8371  68914513    1 FALSE  15       1927  75.43874       7    2010-01-14
## 8372  68914513    1 FALSE  15       1927  75.43874       8    2011-01-20
## 8373  68914513    1 FALSE  15       1927  75.43874       9    2012-01-13
## 83641 68914513    1 FALSE  15       1927  75.43874      NA          <NA>
##            age state income_40 cogact_old socact_old soc_net
## 8364  75.43874     1         7   2.000000   3.000000       4
## 8365  76.24093     1         7   4.142857   3.833333      NA
## 8366  77.23477     1         7   3.428571   3.166667       2
## 8367  78.25325     1         7   3.571429   2.833333       5
## 8368  79.26626     1         7   3.142857   3.000000       2
## 8369  80.24914     1         7   3.285714   2.833333       9
## 8370  81.24572     1         7   2.571429   2.000000       2
## 8371  82.23409     1         7   3.285714   2.666667       3
## 8372  83.24983     1         7   3.142857   2.333333       5
## 8373  84.22998     2         7   3.571429   1.833333       8
## 83641 84.47639     4        NA         NA         NA      NA
##       social_isolation presumed_alive mmse dementia firstobs
## 8364               1.4          FALSE   30       NA        1
## 8365               1.2          FALSE   28       NA        0
## 8366               1.6          FALSE   28       NA        0
## 8367               1.8          FALSE   28       NA        0
## 8368               1.4          FALSE   28       NA        0
## 8369               2.8          FALSE   27       NA        0
## 8370               2.0          FALSE   29       NA        0
## 8371               2.4          FALSE   28       NA        0
## 8372               2.0          FALSE   28       NA        0
## 8373               2.0          FALSE   26       NA        0
## 83641               NA          FALSE   NA       NA        0
```

```r
# simple frequencies of states
table(ds_ms$state)
```

```
## 
##   -2   -1    1    2    3    4 
##   61  288 8024 1903 1397  847
```

```r
# examine transition matrix
# msm::statetable.msm(state,id,ds_ms)
knitr::kable(msm::statetable.msm(state,id,ds_ms))
```



|   | -2|  -1|    1|   2|   3|   4|
|:--|--:|---:|----:|---:|---:|---:|
|-2 | 29|   1|    0|   0|   0|   0|
|-1 |  0|  76|   32|  16|  29|  97|
|1  | 23| 109| 5921| 889| 132| 288|
|2  |  4|  41|  636| 564| 318| 171|
|3  |  4|  56|   26| 109| 805| 291|

```r
# Save as a compress, binary R dataset.  It's no longer readable with a text editor, but it saves metadata (eg, factor information).

# at this point there exist two relevant data sets:
# ds_miss - missing states are encoded
# ds_ms   - multi   states are encoded
# it is useful to have access to both while understanding/verifying encodings

names(dto)
```

```
## [1] "unitData" "metaData"
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
## # A tibble: 11,673 × 142
##        id study scaled_to agreeableness conscientiousness neo_altruism
##     <int> <chr>     <chr>         <lgl>             <int>        <int>
## 1    9121  MAP        MAP            NA                35           27
## 2    9121  MAP        MAP            NA                35           27
## 3    9121  MAP        MAP            NA                35           27
## 4    9121  MAP        MAP            NA                35           27
## 5    9121  MAP        MAP            NA                35           27
## 6    9121  MAP        MAP            NA                35           27
## 7    9121  MAP        MAP            NA                35           27
## 8   33027  MAP        MAP            NA                NA           NA
## 9   33027  MAP        MAP            NA                NA           NA
## 10 204228  MAP        MAP            NA                NA           NA
## # ... with 11,663 more rows, and 136 more variables:
## #   neo_conscientiousness <int>, neo_trust <int>, neuroticism_12 <int>,
## #   openness <lgl>, anxiety_10items <dbl>, neuroticism_6 <int>,
## #   cogdx <int>, age_bl <dbl>, age_death <dbl>, educ <int>, msex <int>,
## #   race <int>, spanish <int>, apoe_genotype <int>, alcohol_g_bl <dbl>,
## #   alco_life <dbl>, q3smo_bl <int>, q4smo_bl <int>, smoking <int>,
## #   cogact_chd <dbl>, cogact_midage <dbl>, cogact_past <dbl>,
## #   cogact_young <dbl>, lostcons_ever <int>, ad_reagan <int>,
## #   braaksc <int>, ceradsc <int>, niareagansc <int>, income_40 <int>,
## #   fu_year <int>, scaled_to.y <chr>, cesdsum <int>, r_depres <int>,
## #   intrusion <dbl>, neglifeevents <int>, negsocexchange <dbl>,
## #   nohelp <dbl>, panas <dbl>, perceivedstress <dbl>, rejection <dbl>,
## #   unsympathetic <dbl>, dcfdx <int>, dementia <int>, r_stroke <int>,
## #   cogn_ep <dbl>, cogn_po <dbl>, cogn_ps <dbl>, cogn_se <dbl>,
## #   cogn_wo <dbl>, cogn_global <dbl>, cts_animals <int>, cts_bname <int>,
## #   catfluency <int>, cts_db <int>, cts_delay <int>, cts_df <int>,
## #   cts_doperf <int>, cts_ebdr <int>, cts_ebmt <int>, cts_fruits <int>,
## #   cts_idea <int>, cts_lopair <int>, mmse <dbl>, cts_nccrtd <int>,
## #   cts_pmat <int>, cts_pmsub <int>, cts_read_nart <int>,
## #   cts_read_wrat <lgl>, cts_sdmt <int>, cts_story <int>,
## #   cts_stroop_cname <int>, cts_stroop_wread <int>, cts_wli <int>,
## #   cts_wlii <int>, cts_wliii <int>, age_at_visit <dbl>, iadlsum <int>,
## #   katzsum <int>, rosbscl <int>, rosbsum <int>, vision <int>,
## #   visionlog <dbl>, bun <int>, ca <dbl>, cholesterol <int>,
## #   cloride <int>, co2 <int>, crn <dbl>, fasting <int>, glucose <int>,
## #   hba1c <dbl>, hdlchlstrl <int>, hdlratio <dbl>, k <dbl>,
## #   ldlchlstrl <int>, na <int>, cogact_old <dbl>, bmi <dbl>, htm <dbl>,
## #   phys5itemsum <dbl>, ...
```

```r
# 2nd element - meta data, info about variables
dto[["metaData"]]
```

```
##                      name
## 1               ad_reagan
## 2            age_at_visit
## 3                  age_bl
## 4               age_death
## 5           agreeableness
## 6            alcohol_g_bl
## 7         anxiety_10items
## 8           apoe_genotype
## 9                     bmi
## 10                   bp11
## 11                    bp2
## 12                    bp3
## 13                   bp31
## 14                braaksc
## 15                    bun
## 16                     ca
## 17             cancer_cum
## 18                ceradsc
## 19                cesdsum
## 20        chd_cogact_freq
## 21                chf_cum
## 22                chlstrl
## 23                     cl
## 24       claudication_cum
## 25                    co2
## 26                cogdate
## 27                  cogdx
## 28                cogn_ep
## 29            cogn_global
## 30                cogn_po
## 31                cogn_ps
## 32                cogn_se
## 33                cogn_wo
## 34      conscientiousness
## 35                    crn
## 36            cts_animals
## 37              cts_bname
## 38             cts_catflu
## 39                 cts_db
## 40              cts_delay
## 41                 cts_df
## 42             cts_doperf
## 43               cts_ebdr
## 44               cts_ebmt
## 45             cts_fruits
## 46               cts_idea
## 47             cts_lopair
## 48             cts_mmse30
## 49             cts_nccrtd
## 50               cts_pmat
## 51              cts_pmsub
## 52          cts_read_nart
## 53          cts_read_wrat
## 54               cts_sdmt
## 55              cts_story
## 56       cts_stroop_cname
## 57       cts_stroop_wread
## 58                cts_wli
## 59               cts_wlii
## 60              cts_wliii
## 61                  dcfdx
## 62               dementia
## 63                 dm_cum
## 64                   educ
## 65                fasting
## 66                    fev
## 67                fu_year
## 68             gait_speed
## 69                glucose
## 70                gripavg
## 71                  hba1c
## 72             hdlchlstrl
## 73               hdlratio
## 74        headinjrloc_cum
## 75              heart_cum
## 76                    htm
## 77       hypertension_cum
## 78                iadlsum
## 79              intrusion
## 80                      k
## 81                katzsum
## 82  late_life_cogact_freq
## 83      late_life_soc_act
## 84                ldai_bl
## 85             ldlchlstrl
## 86          lostcons_ever
## 87   ma_adult_cogact_freq
## 88                    mep
## 89                    mip
## 90                   msex
## 91                     na
## 92          neglifeevents
## 93         negsocexchange
## 94           neo_altruism
## 95  neo_conscientiousness
## 96              neo_trust
## 97         neuroticism_12
## 98          neuroticism_6
## 99            niareagansc
## 100                nohelp
## 101              openness
## 102                 panas
## 103      past_cogact_freq
## 104       perceivedstress
## 105          phys5itemsum
## 106                projid
## 107                   pvc
## 108              q3smo_bl
## 109                q40inc
## 110              q4smo_bl
## 111              r_depres
## 112              r_stroke
## 113                  race
## 114             rejection
## 115               rosbscl
## 116               rosbsum
## 117           scaled_to.x
## 118           scaled_to.y
## 119               smoking
## 120               soc_net
## 121      social_isolation
## 122               spanish
## 123            stroke_cum
## 124                 study
## 125           thyroid_cum
## 126      total_smell_test
## 127         unsympathetic
## 128         vasc_3dis_sum
## 129         vasc_4dis_sum
## 130        vasc_risks_sum
## 131                vision
## 132             visionlog
## 133                  wtkg
## 134  ya_adult_cogact_freq
##                                                         label
## 1                                Dicotomized NIA-Reagan score
## 2                                   Age at cycle - fractional
## 3                                             Age at baseline
## 4                                                Age at death
## 5                                       NEO agreeableness-ROS
## 6                   Grams of alcohol used per day at baseline
## 7                       Anxiety-10 item version - ROS and MAP
## 8                                   Apolipoprotein E genotype
## 9                                             Body mass index
## 10              Blood pressure measurement- sitting - trial 1
## 11              Blood pressure measurement- sitting - trial 2
## 12                                         Hx of Meds for HTN
## 13                       Blood pressure measurement- standing
## 14        Semiquantitative measure of neurofibrillary tangles
## 15                                        Blood urea nitrogen
## 16                                                    Calcium
## 17                   Medical Conditions - cancer - cumulative
## 18               Semiquantitative measure of neuritic plaques
## 19             Measure of depressive symptoms (Modified CESD)
## 20                                 Cognitive actifity - child
## 21  Medical Conditions - congestive heart failure -cumulative
## 22                                                Cholesterol
## 23                                                   Chloride
## 24              Medical conditions - claudication -cumulative
## 25                                             Carbon Dioxide
## 26                          Date of the interview at baseline
## 27                        Final consensus cognitive diagnosis
## 28                    Calculated domain score-episodic memory
## 29                                     Global cognitive score
## 30           Calculated domain score - perceptual orientation
## 31                 Calculated domain score - perceptual speed
## 32                  Calculated domain score - semantic memory
## 33                   Calculated domain score - working memory
## 34                                  Conscientiousness-ROS/MAP
## 35                                                 Creatinine
## 36                                 Category fluence - Animals
## 37                                       Boston naming - 2014
## 38                                    Category fluency - 2014
## 39                                    Digits backwards - 2014
## 40                                  Logical memory IIa - 2014
## 41                                     Digits forwards - 2014
## 42                                      Digit ordering - 2014
## 43                  East Boston story - delayed recall - 2014
## 44                       East Boston story - immediate - 2014
## 45                                  Category fluency - Fruits
## 46                                       Complex ideas - 2014
## 47                                    Line orientation - 2014
## 48                                                MMSE - 2014
## 49                                   Number comparison - 2014
## 50                                Progressive Matrices - 2014
## 51                                                  cts_pmsub
## 52                                     Reading test-NART-2014
## 53                                 Reading test - WRAT - 2014
## 54                           Symbol digit modalitities - 2014
## 55                       Logical memory Ia - immediate - 2014
## 56                                        Stroop test  - name
## 57                                         Stroop test - read
## 58                               Word list I- immediate- 2014
## 59                              Word list II - delayed - 2014
## 60                         Word list III - recognition - 2014
## 61                                        Clinical dx summary
## 62                                         Dementia diagnosis
## 63                    Medical history - diabetes - cumulative
## 64                                         Years of education
## 65         Whether blood was collected on fasting participant
## 66                                   forced expiratory volume
## 67                                             Follow-up year
## 68                                           Gait Speed - MAP
## 69                                                    Glucose
## 70                                         Extremity strength
## 71                                             Hemoglobin A1c
## 72                                            HDL cholesterol
## 73                                                  HDL ratio
## 74                                                Head Injury
## 75                    Medical Conditions - heart - cumulative
## 76                                             Height(meters)
## 77             Medical conditions - hypertension - cumulative
## 78                   Instrumental activities of daily liviing
## 79                     Negative social exchange-intrusion-MAP
## 80                                                  Potassium
## 81                                 Katz measure of disability
## 82                             Codnitive activity - late life
## 83                                Social activity - late life
## 84                    Lifetime daily alcohol intake -baseline
## 85                                            LDL cholesterol
## 86                                                       <NA>
## 87                            Codnitive activity - middle age
## 88                                maximal expiratory pressure
## 89                               maximal inspiratory pressure
## 90                                                     Gender
## 91                                                     Sodium
## 92                                       Negative life events
## 93                                   Negative social exchange
## 94                                     NEO altruism scale-MAP
## 95                                  NEO conscientiousness-MAP
## 96                                              NEO trust-MAP
## 97                          Neuroticism - 12 item version-RMM
## 98                         Neuroticism - 6 item version - RMM
## 99                                                       <NA>
## 100                         Negative social exchange-help-MAP
## 101                                           NEO openess-ROS
## 102                                               Panas score
## 103                                 Cognitive actifity - past
## 104                                          Perceived stress
## 105                    Physical activity (summary of 5 items)
## 106                                        Subject identifier
## 107                                  pulmonary vital capacity
## 108                                 Smoking quantity-baseline
## 109                                    Income level at age 40
## 110                                 Smoking duration-baseline
## 111                         Major depression dx-clinic rating
## 112                                        Clinical stroke dx
## 113                                        Participant's race
## 114                  Negative social exchange - rejection-MAP
## 115                                       Rosow-Breslau scale
## 116                                       Rosow-Breslau scale
## 117                                          Scaled parameter
## 118                                          Scaled parameter
## 119                                                   Smoking
## 120                                       Social network size
## 121                                Percieved social isolation
## 122                                   Spanish/Hispanic origin
## 123                  Clinical Diagnoses - Stroke - cumulative
## 124                   The particular RADC study (MAP-ROS-RMM)
## 125         Medical Conditions - thyroid disease - cumulative
## 126                                                      <NA>
## 127               Negative social exchange-unsymapathetic-MAP
## 128 Vascular disease burden (3 items wo chf)\n\n ROS-MAP-MARS
## 129     Vascular disease burden (4 items) - MAP-MARS\n\n only
## 130                             Vascular disease risk factors
## 131                                             Vision acuity
## 132                                             Visual acuity
## 133                                               Weight (kg)
## 134                          Cognitive actifity - young adult
##              type              name_new              construct
## 1       pathology             ad_reagan              alzheimer
## 2     demographic          age_at_visit                    age
## 3     demographic                age_bl                    age
## 4     demographic             age_death                    age
## 5     personality         agreeableness                       
## 6       substance          alcohol_g_bl                alcohol
## 7     personality       anxiety_10items                anxiety
## 8        clinical         apoe_genotype                   apoe
## 9        physical                   bmi               physique
## 10        medical              bp_sit_1           hypertension
## 11        medical              bp_sit_2           hypertension
## 12        medical               bp_meds           hypertension
## 13        medical            bp_stand_3           hypertension
## 14      pathology               braaksc                  Braak
## 15       clinical                   bun                       
## 16       clinical                    ca                       
## 17                           cancer_cum                 cancer
## 18      pathology               ceradsc                  CERAD
## 19  psychological               cesdsum             depression
## 20      cognitive            cogact_chd                   <NA>
## 21       clinical               chf_cum                 cardio
## 22       clinical           cholesterol            cholesterol
## 23       clinical               cloride                cloride
## 24       clinical      claudication_cum                       
## 25       clinical                   co2                       
## 26         design      date_at_baseline                       
## 27       clinical                 cogdx                   <NA>
## 28      cognitive               cogn_ep        episodic memory
## 29      cognitive           cogn_global       global cognition
## 30      cognitive               cogn_po perceptual orientation
## 31      cognitive               cogn_ps       perceptual speed
## 32      cognitive               cogn_se        semantic memory
## 33      cognitive               cogn_wo         working memory
## 34    personality     conscientiousness      conscientiousness
## 35       clinical                   crn                       
## 36      cognitive           cts_animals                       
## 37      cognitive             cts_bname        semantic memory
## 38      cognitive            catfluency        semantic memory
## 39      cognitive                cts_db         working memory
## 40      cognitive             cts_delay        episodic memory
## 41      cognitive                cts_df         working memory
## 42      cognitive            cts_doperf         working memory
## 43      cognitive              cts_ebdr        episodic memory
## 44      cognitive              cts_ebmt        episodic memory
## 45      cognitive            cts_fruits                   <NA>
## 46      cognitive              cts_idea   verbal comprehension
## 47      cognitive            cts_lopair perceptual orientation
## 48      cognitive                  mmse               dementia
## 49      cognitive            cts_nccrtd       perceptual speed
## 50      cognitive              cts_pmat perceptual orientation
## 51      cognitive             cts_pmsub                   <NA>
## 52      cognitive         cts_read_nart        semantic memory
## 53      cognitive         cts_read_wrat        semantic memory
## 54      cognitive              cts_sdmt       perceptual speed
## 55      cognitive             cts_story        episodic memory
## 56      cognitive      cts_stroop_cname                   <NA>
## 57      cognitive      cts_stroop_wread                   <NA>
## 58      cognitive               cts_wli        episodic memory
## 59      cognitive              cts_wlii        episodic memory
## 60      cognitive             cts_wliii        episodic memory
## 61       clinical                 dcfdx              cognition
## 62      cognitive              dementia               dementia
## 63       clinical                dm_cum               diabetes
## 64    demographic                  educ              education
## 65       clinical               fasting                   <NA>
## 66       physical                   fev                physcap
## 67         design               fu_year                   time
## 68       physical            gait_speed                physcap
## 69       clinical               glucose                   <NA>
## 70       physical               gripavg                physcap
## 71       clinical                 hba1c                   <NA>
## 72       clinical            hdlchlstrl                   <NA>
## 73       clinical              hdlratio                   <NA>
## 74           <NA>       headinjrloc_cum                   <NA>
## 75       clinical             heart_cum                   <NA>
## 76       physical                   htm               physique
## 77       clinical      hypertension_cum           hypertension
## 78       physical               iadlsum                physact
## 79  psychological             intrusion                   <NA>
## 80       clinical                     k                   <NA>
## 81       physical               katzsum                physcap
## 82      lifestyle            cogact_old                       
## 83      lifestyle            socact_old                       
## 84      substance             alco_life                alcohol
## 85       clinical            ldlchlstrl                   <NA>
## 86           <NA>         lostcons_ever                   <NA>
## 87      cognitive         cogact_midage                   <NA>
## 88       physical                   mep                physcap
## 89       physical                   mip                physcap
## 90    demographic                  msex                    sex
## 91       clinical                    na                   <NA>
## 92  psychological         neglifeevents                   <NA>
## 93  psychological        negsocexchange                   <NA>
## 94    personality          neo_altruism                   <NA>
## 95    personality neo_conscientiousness                   <NA>
## 96    personality             neo_trust                   <NA>
## 97    personality        neuroticism_12                   <NA>
## 98    personality         neuroticism_6                   <NA>
## 99           <NA>           niareagansc                   <NA>
## 100 psychological                nohelp                   <NA>
## 101   personality              openness                   <NA>
## 102 psychological                 panas                   <NA>
## 103     cognitive           cogact_past                   <NA>
## 104 psychological       perceivedstress                   <NA>
## 105      physical          phys5itemsum                physact
## 106        design                    id                   <NA>
## 107      physical                   pvc                physcap
## 108     substance              q3smo_bl                smoking
## 109   demographic             income_40                   <NA>
## 110     substance              q4smo_bl                smoking
## 111 psychological              r_depres                   <NA>
## 112      clinical              r_stroke                 stroke
## 113   demographic                  race                   race
## 114 psychological             rejection                   <NA>
## 115      physical               rosbscl                physcap
## 116      physical               rosbsum                physcap
## 117        design             scaled_to                   <NA>
## 118        design           scaled_to.y                   <NA>
## 119     substance               smoking                smoking
## 120     lifestyle               soc_net                   <NA>
## 121     lifestyle      social_isolation                   <NA>
## 122   demographic               spanish                   race
## 123      clinical            stroke_cum                 stroke
## 124        design                 study                   <NA>
## 125      clinical           thyroid_cum                   <NA>
## 126          <NA>      total_smell_test                   <NA>
## 127 psychological         unsympathetic                   <NA>
## 128      clinical         vasc_3dis_sum                   <NA>
## 129      clinical         vasc_4dis_sum                   <NA>
## 130      clinical        vasc_risks_sum                   <NA>
## 131      physical                vision                physcap
## 132      physical             visionlog                physcap
## 133      physical                  wtkg               physique
## 134          <NA>          cogact_young                   <NA>
##     self_reported longitudinal             unit include
## 1           FALSE        FALSE         category      NA
## 2           FALSE         TRUE             year    TRUE
## 3           FALSE        FALSE             year    TRUE
## 4           FALSE        FALSE             year    TRUE
## 5            TRUE        FALSE            scale      NA
## 6            TRUE        FALSE            grams    TRUE
## 7              NA        FALSE            scale      NA
## 8           FALSE        FALSE         category    TRUE
## 9           FALSE         TRUE           kg/msq    TRUE
## 10          FALSE         TRUE            scale      NA
## 11          FALSE         TRUE            scale      NA
## 12           TRUE         TRUE         category      NA
## 13          FALSE         TRUE            scale      NA
## 14          FALSE        FALSE         category      NA
## 15          FALSE         TRUE            scale      NA
## 16          FALSE         TRUE            scale      NA
## 17          FALSE        FALSE         category      NA
## 18          FALSE        FALSE         category      NA
## 19           TRUE         TRUE            scale    TRUE
## 20             NA           NA             <NA>    TRUE
## 21           TRUE         TRUE         category    TRUE
## 22          FALSE         TRUE            scale      NA
## 23          FALSE         TRUE            scale      NA
## 24          FALSE        FALSE         category      NA
## 25          FALSE         TRUE            scale      NA
## 26          FALSE        FALSE                     TRUE
## 27          FALSE        FALSE         category    TRUE
## 28          FALSE         TRUE        composite    TRUE
## 29          FALSE         TRUE        composite    TRUE
## 30          FALSE         TRUE        composite    TRUE
## 31          FALSE         TRUE        composite    TRUE
## 32          FALSE         TRUE        composite    TRUE
## 33          FALSE         TRUE        composite    TRUE
## 34           TRUE        FALSE        composite      NA
## 35             NA           NA                       NA
## 36             NA           NA                       NA
## 37          FALSE         TRUE          0 to 15      NA
## 38          FALSE         TRUE          0 to 75      NA
## 39          FALSE         TRUE          0 to 12      NA
## 40          FALSE         TRUE          0 to 25      NA
## 41          FALSE         TRUE          0 to 12      NA
## 42          FALSE         TRUE          0 to 14      NA
## 43          FALSE         TRUE          0 to 12      NA
## 44          FALSE         TRUE          0 to 12      NA
## 45             NA           NA             <NA>      NA
## 46          FALSE         TRUE           0 to 8      NA
## 47          FALSE         TRUE          0 to 15      NA
## 48           TRUE         TRUE          0 to 30    TRUE
## 49          FALSE         TRUE          0 to 48      NA
## 50          FALSE         TRUE          0 to 16      NA
## 51             NA           NA             <NA>      NA
## 52          FALSE         TRUE          0 to 10      NA
## 53          FALSE         TRUE          0 to 15      NA
## 54          FALSE         TRUE         0 to 110      NA
## 55          FALSE         TRUE          0 to 25      NA
## 56             NA           NA             <NA>      NA
## 57             NA           NA             <NA>      NA
## 58          FALSE         TRUE          0 to 30      NA
## 59          FALSE         TRUE          0 to 10      NA
## 60          FALSE         TRUE          o to 10      NA
## 61          FALSE         TRUE         category    TRUE
## 62          FALSE         TRUE             0, 1    TRUE
## 63           TRUE         TRUE             <NA>      NA
## 64           TRUE        FALSE            years    TRUE
## 65             NA           NA             <NA>      NA
## 66          FALSE         TRUE           liters    TRUE
## 67          FALSE         TRUE       time point    TRUE
## 68          FALSE         TRUE          min/sec    TRUE
## 69             NA           NA             <NA>      NA
## 70          FALSE         TRUE              lbs    TRUE
## 71             NA           NA             <NA>      NA
## 72             NA           NA             <NA>      NA
## 73             NA           NA             <NA>      NA
## 74             NA           NA             <NA>      NA
## 75             NA           NA             <NA>      NA
## 76          FALSE         TRUE           meters    TRUE
## 77           TRUE         TRUE             <NA>      NA
## 78           TRUE         TRUE            scale    TRUE
## 79             NA           NA             <NA>      NA
## 80             NA           NA             <NA>      NA
## 81           TRUE         TRUE            scale    TRUE
## 82           TRUE         TRUE         category    TRUE
## 83           TRUE         TRUE         category    TRUE
## 84           TRUE        FALSE       drinks/day    TRUE
## 85             NA           NA             <NA>      NA
## 86             NA           NA             <NA>      NA
## 87             NA           NA             <NA>    TRUE
## 88          FALSE         TRUE           cm H20    TRUE
## 89          FALSE         TRUE           cm H20    TRUE
## 90          FALSE        FALSE         category    TRUE
## 91             NA           NA             <NA>      NA
## 92             NA           NA             <NA>      NA
## 93             NA           NA             <NA>    TRUE
## 94             NA           NA             <NA>      NA
## 95             NA           NA             <NA>      NA
## 96             NA           NA             <NA>      NA
## 97             NA           NA             <NA>      NA
## 98             NA           NA             <NA>      NA
## 99             NA           NA             <NA>      NA
## 100            NA           NA             <NA>      NA
## 101            NA           NA             <NA>      NA
## 102            NA           NA             <NA>      NA
## 103            NA           NA             <NA>    TRUE
## 104            NA           NA             <NA>      NA
## 105          TRUE         TRUE            hours    TRUE
## 106            NA           NA             <NA>    TRUE
## 107         FALSE         TRUE           liters    TRUE
## 108          TRUE        FALSE cigarettes / day    TRUE
## 109            NA           NA             <NA>    TRUE
## 110          TRUE        FALSE            years    TRUE
## 111            NA           NA             <NA>      NA
## 112         FALSE         TRUE         category    TRUE
## 113          TRUE        FALSE         category    TRUE
## 114            NA           NA             <NA>    TRUE
## 115          TRUE         TRUE            scale    TRUE
## 116          TRUE         TRUE            scale    TRUE
## 117            NA           NA             <NA>      NA
## 118            NA           NA             <NA>      NA
## 119          TRUE        FALSE         category    TRUE
## 120            NA           NA             <NA>    TRUE
## 121            NA           NA             <NA>    TRUE
## 122          TRUE        FALSE         category      NA
## 123         FALSE         TRUE         category      NA
## 124            NA           NA             <NA>      NA
## 125            NA           NA             <NA>      NA
## 126            NA           NA             <NA>      NA
## 127            NA           NA             <NA>      NA
## 128            NA           NA             <NA>      NA
## 129            NA           NA             <NA>      NA
## 130            NA           NA             <NA>      NA
## 131         FALSE         TRUE            scale      NA
## 132         FALSE         TRUE            scale      NA
## 133         FALSE         TRUE            kilos    TRUE
## 134            NA           NA             <NA>    TRUE
##                                                                                                                                      url
## 1              https://www.radc.rush.edu/docs/var/detail.htm?category=Pathology&subcategory=Alzheimer%27s%20Disease&variable=niareagansc
## 2                                              https://www.radc.rush.edu/docs/var/detail.htm?category=Demographics&variable=age_at_visit
## 3                                                    https://www.radc.rush.edu/docs/var/detail.htm?category=Demographics&variable=age_bl
## 4                                                 https://www.radc.rush.edu/docs/var/detail.htm?category=Demographics&variable=age_death
## 5                                                                                                                                       
## 6       https://www.radc.rush.edu/docs/var/detail.htm?category=Lifestyle&subcategory=Alcohol%20and%20Tobacco%20Use&variable=alcohol_g_bl
## 7                                                                                                                                   Todo
## 8                               https://www.radc.rush.edu/docs/var/detail.htm?category=Genotypes&subcategory=ApoE&variable=apoe_genotype
## 9                          https://www.radc.rush.edu/docs/var/detail.htm?category=Lifestyle&subcategory=Physical%20Activity&variable=bmi
## 10             https://www.radc.rush.edu/docs/var/detail.htm?category=Medical%20Conditions&subcategory=Blood%20Pressure&variable=sbp_avg
## 11             https://www.radc.rush.edu/docs/var/detail.htm?category=Medical%20Conditions&subcategory=Blood%20Pressure&variable=sbp_avg
## 12                                                                                                                                  todo
## 13             https://www.radc.rush.edu/docs/var/detail.htm?category=Medical%20Conditions&subcategory=Blood%20Pressure&variable=sbp_avg
## 14                 https://www.radc.rush.edu/docs/var/detail.htm?category=Pathology&subcategory=Alzheimer%27s%20Disease&variable=braaksc
## 15                                                                                                                                  todo
## 16                                                                                                                                  todo
## 17                                                                                                                                  todo
## 18                 https://www.radc.rush.edu/docs/var/detail.htm?category=Pathology&subcategory=Alzheimer%27s%20Disease&variable=ceradsc
## 19             https://www.radc.rush.edu/docs/var/detail.htm?category=Affect%20and%20Personality&subcategory=Depression&variable=cesdsum
## 20                                                                                                                                  todo
## 21                                                                                                                                  todo
## 22                                                                                                                                  todo
## 23                                                                                                                                  todo
## 24                                                                                                                                  todo
## 25                                                                                                                                  Todo
## 26                                                                                                                                      
## 27  https://www.radc.rush.edu/docs/var/detail.htm?category=Clinical%20Diagnosis&subcategory=Final%20consensus%20diagnosis&variable=cogdx
## 28                                 https://www.radc.rush.edu/docs/var/detail.htm?category=Cognition&subcategory=Domains&variable=cogn_ep
## 29                  https://www.radc.rush.edu/docs/var/detail.htm?category=Cognition&subcategory=Global%20cognition&variable=cogn_global
## 30                                 https://www.radc.rush.edu/docs/var/detail.htm?category=Cognition&subcategory=Domains&variable=cogn_po
## 31                                 https://www.radc.rush.edu/docs/var/detail.htm?category=Cognition&subcategory=Domains&variable=cogn_ps
## 32                                 https://www.radc.rush.edu/docs/var/detail.htm?category=Cognition&subcategory=Domains&variable=cogn_se
## 33                                 https://www.radc.rush.edu/docs/var/detail.htm?category=Cognition&subcategory=Domains&variable=cogn_wo
## 34          https://www.radc.rush.edu/docs/var/detail.htm?category=Affect%20and%20Personality&subcategory=NEO&variable=conscientiousness
## 35                                                                                                                                      
## 36                                                                                                                                      
## 37                                                                                                                                      
## 38                                                                                                                                      
## 39                                                                                                                                      
## 40                                                                                                                                      
## 41                                                                                                                                      
## 42                                                                                                                                      
## 43                                                                                                                                      
## 44                                                                                                                                      
## 45                                                                                                                                      
## 46                                                                                                                                      
## 47                                                                                                                                      
## 48                                                                                                                                      
## 49                                                                                                                                      
## 50                                                                                                                                      
## 51                                                                                                                                      
## 52                                                                                                                                      
## 53                                                                                                                                      
## 54                                                                                                                                      
## 55                                                                                                                                      
## 56                                                                                                                                      
## 57                                                                                                                                      
## 58                                                                                                                                      
## 59                                                                                                                                      
## 60                                                                                                                                      
## 61                                                                                                                                      
## 62                                                                                                                                      
## 63                                                                                                                                      
## 64                                                                                                                                      
## 65                                                                                                                                      
## 66                                                                                                                                      
## 67                                                                                                                                      
## 68                                                                                                                                      
## 69                                                                                                                                      
## 70                                                                                                                                      
## 71                                                                                                                                      
## 72                                                                                                                                      
## 73                                                                                                                                      
## 74                                                                                                                                      
## 75                                                                                                                                      
## 76                                                                                                                                      
## 77                                                                                                                                      
## 78                                                                                                                                      
## 79                                                                                                                                      
## 80                                                                                                                                      
## 81                                                                                                                                      
## 82      https://www.radc.rush.edu/docs/var/detail.htm?category=Lifestyle&subcategory=Cognitive%20Activity&variable=late_life_cogact_freq
## 83           https://www.radc.rush.edu/docs/var/detail.htm?category=Lifestyle&subcategory=Social%20Engagement&variable=late_life_soc_act
## 84                                                                                                                                      
## 85                                                                                                                                      
## 86                                                                                                                                      
## 87       https://www.radc.rush.edu/docs/var/detail.htm?category=Lifestyle&subcategory=Cognitive%20Activity&variable=ma_adult_cogact_freq
## 88                                                                                                                                      
## 89                                                                                                                                      
## 90                                                                                                                                      
## 91                                                                                                                                      
## 92                                                                                                                                      
## 93        https://www.radc.rush.edu/docs/var/detail.htm?category=Affect%20and%20Personality&subcategory=Negative&variable=negsocexchange
## 94                                                                                                                                      
## 95                                                                                                                                      
## 96                                                                                                                                      
## 97             https://www.radc.rush.edu/docs/var/detail.htm?category=Affect%20and%20Personality&subcategory=NEO&variable=neuroticism_12
## 98                                                                                                                                      
## 99                                                                                                                                      
## 100                                                                                                                                     
## 101                                                                                                                                     
## 102                                                                                                                                     
## 103                                                                                                                                 todo
## 104                                                                                                                                     
## 105               https://www.radc.rush.edu/docs/var/detail.htm?category=Lifestyle&subcategory=Physical%20Activity&variable=phys5itemsum
## 106                                                                                                                                     
## 107                                                                                                                                     
## 108                                                                                                                                     
## 109                                                                                                                                     
## 110                                                                                                                                     
## 111                                                                                                                                     
## 112                     https://www.radc.rush.edu/docs/var/detail.htm?category=Clinical%20Diagnosis&subcategory=Stroke&variable=r_stroke
## 113                                                                                                                                     
## 114                                                                                                                                     
## 115                                                                                                                                     
## 116                                                                                                                                     
## 117                                                                                                                                     
## 118                                                                                                                                     
## 119                                                                                                                                     
## 120                    https://www.radc.rush.edu/docs/var/detail.htm?category=Lifestyle&subcategory=Social%20Engagement&variable=soc_net
## 121           https://www.radc.rush.edu/docs/var/detail.htm?category=Lifestyle&subcategory=Social%20Engagement&variable=social_isolation
## 122                                                                                                                                     
## 123                                                                                                                                     
## 124                                                                                                                                     
## 125                                                                                                                                     
## 126                                                                                                                                     
## 127                                                                                                                                     
## 128                                                                                                                                     
## 129                                                                                                                                     
## 130                                                                                                                                     
## 131                                                                                                                                     
## 132                                                                                                                                     
## 133                                                                                                                                     
## 134      https://www.radc.rush.edu/docs/var/detail.htm?category=Lifestyle&subcategory=Cognitive%20Activity&variable=ya_adult_cogact_freq
##            notes
## 1               
## 2               
## 3               
## 4               
## 5               
## 6               
## 7               
## 8               
## 9               
## 10              
## 11              
## 12              
## 13              
## 14              
## 15              
## 16              
## 17              
## 18              
## 19              
## 20  young adult?
## 21              
## 22              
## 23              
## 24              
## 25              
## 26              
## 27              
## 28              
## 29              
## 30              
## 31              
## 32              
## 33              
## 34              
## 35              
## 36              
## 37              
## 38              
## 39              
## 40              
## 41              
## 42              
## 43              
## 44              
## 45              
## 46              
## 47              
## 48              
## 49              
## 50              
## 51              
## 52              
## 53              
## 54              
## 55              
## 56              
## 57              
## 58              
## 59              
## 60              
## 61              
## 62              
## 63              
## 64              
## 65              
## 66              
## 67              
## 68              
## 69              
## 70              
## 71              
## 72              
## 73              
## 74              
## 75              
## 76              
## 77              
## 78              
## 79              
## 80              
## 81              
## 82              
## 83              
## 84              
## 85              
## 86              
## 87              
## 88              
## 89              
## 90              
## 91              
## 92              
## 93              
## 94              
## 95              
## 96              
## 97              
## 98              
## 99              
## 100             
## 101             
## 102             
## 103             
## 104             
## 105             
## 106             
## 107             
## 108             
## 109             
## 110             
## 111             
## 112             
## 113             
## 114             
## 115             
## 116             
## 117             
## 118             
## 119             
## 120             
## 121             
## 122             
## 123             
## 124             
## 125             
## 126             
## 127             
## 128             
## 129             
## 130             
## 131             
## 132             
## 133             
## 134
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
## [1] knitr_1.14    ggplot2_2.1.0 nnet_7.3-12   msm_1.6.4     magrittr_1.5 
## 
## loaded via a namespace (and not attached):
##  [1] reshape2_1.4.1     splines_3.3.1      lattice_0.20-34   
##  [4] colorspace_1.2-7   expm_0.999-0       htmltools_0.3.5   
##  [7] yaml_2.1.13        mgcv_1.8-15        survival_2.39-5   
## [10] nloptr_1.0.4       DBI_0.5-1          RColorBrewer_1.1-2
## [13] plyr_1.8.4         stringr_1.1.0      MatrixModels_0.4-1
## [16] munsell_0.4.3      gtable_0.2.0       htmlwidgets_0.7   
## [19] mvtnorm_1.0-5      evaluate_0.10      labeling_0.3      
## [22] SparseM_1.72       extrafont_0.17     quantreg_5.29     
## [25] pbkrtest_0.4-6     parallel_3.3.1     markdown_0.7.7    
## [28] Rttf2pt1_1.3.4     highr_0.6          Rcpp_0.12.7       
## [31] scales_0.4.0       DT_0.2             formatR_1.4       
## [34] jsonlite_1.1       lme4_1.1-12        testit_0.5        
## [37] digest_0.6.10      stringi_1.1.2      dplyr_0.5.0       
## [40] grid_3.3.1         tools_3.3.1        lazyeval_0.2.0    
## [43] tibble_1.2         dichromat_2.0-0    car_2.1-3         
## [46] extrafontdb_1.0    tidyr_0.6.0        MASS_7.3-45       
## [49] Matrix_1.2-7.1     rsconnect_0.5      assertthat_0.1    
## [52] minqa_1.2.4        rmarkdown_1.1      R6_2.2.0          
## [55] nlme_3.1-128
```

```r
Sys.time()
```

```
## [1] "2016-10-24 15:08:18 EDT"
```

