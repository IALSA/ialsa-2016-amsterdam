#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load-packages -----------------------------------------------------------
library(magrittr) #Pipes
library(msm)
requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) 
requireNamespace("testit", quietly=TRUE)

# ---- load-sources ------------------------------------------------------------
# base::source("http://www.ucl.ac.uk/~ucakadl/ELECT/ELECT.r") # load  ELECT functions
base::source("./scripts/ELECT.r") # load  ELECT functions
base::source("./scripts/ELECT-utility-functions.R") # ELECT utility functions
# base::source("./scripts/common-functions.R") # used in multiple reports
base::source("./scripts/graph-presets.R") # fonts, colors, themes
# base::source("./scripts/general-graphs.R")
# base::source("./scripts/specific-graphs.R")
# ---- declare-globals ---------------------------------------------------------
# ELECT option:
digits = 2
# Model objects saved here:
path_folder <- "./data/shared/derived/models/model-b"
# ---- load-data ---------------------------------------------------------------
# first, the script `0-ellis-island.R` imports and cleans the raw data
# second, the script `1-encode-multistate.R` augments the data with multi-states
# thirds, the script `2-estimate-models.R` conducts msm estimation and ELECT simulation
# now we import the objects containing the results of the last script

# ---- load-data-v1 ---------------------------------------------------------------
path_files <- list.files(file.path(path_folder),full.names=T, pattern="mB_v1_")
# ---- load-data-v2 ---------------------------------------------------------------
path_files <- list.files(file.path(path_folder),full.names=T, pattern="mB_v2_")

# ---- load-data-target ---------------------------------------------------------------
path_files %>% as.data.frame() %>% format(justify="left") %>% print()
models <- list()
for(i in seq_along(path_files)){
  (min_age <- strsplit(path_files[i], split = "_")[[1]][3])
  models[[paste0("age_",min_age)]] <- readRDS(path_files[i])
}

# ---- inspect-data -------------------------------------------------------------
# view the composition of the list object
lapply(models, names) # each age condition contains 4 elements
model <- models$age_60 # msm output is identical in all component
# element 1) msm output
names(model$msm)
# element 2) levels of covariates for which simulation was conducted
model$levels
# element 3) results of the simulations for the correspondent levels of covariates
names(model$le)
# outcome of the  ELECT simulation
lapply(model$le[[1]], names)# for condition #1 in the model$levels
# view descriptives 
model$descriptives %>% dplyr::filter(condition_n ==1) # for condition #1 in the model$levels
# ---- msm-1 -----------------------------------
msm_summary(models$age_60$msm) 

# ---- msm-2 -----------------------------------
msm_details(models$age_60$msm)  

# ---- msm-3 -----------------------------------
print_hazards(models$age_60$msm) %>% knitr::kable() 


# ---- create-pooled-dataset -----------------------
desc <- list() 
for(i in names(models)){
  desc[[i]] <- models[[i]]$descriptives
}
results <- plyr::ldply(desc, data.frame) 

# ---- reconstruct-edu-from-dummies ----------------------
results <- results %>% 
  dplyr::mutate( 
    educat = ifelse(
      edu_low_med == 0 & edu_low_high==0,-1,ifelse(
        edu_low_med == 1 & edu_low_high==0, 0, ifelse(
          edu_low_med == 0 & edu_low_high==1, 1,
          NA))))


# ----- prepare-for-graphing ---------------------------
# prepare dataset for graphing
results <- results %>% 
  dplyr::rename(
    min_age = .id
    ,q_025  = X0.025q
    ,q_5    = X0.5q
    ,q_975  = X0.975q
    ) %>% 
  dplyr::mutate(
    min_age = as.numeric(gsub("(\\w+)_(\\d+)", "\\2", min_age))
    ,male   = factor(male, levels = c(0,1), labels = c("Women","Men"))
    ,sescat = factor(sescat,levels = c(-1,0,1), labels = c("Low", "Med","High"))
    ,sescat = factor(sescat, levels = rev(levels(sescat)))
    ,educat = factor(educat, levels = c(-1,0,1), labels = c(
      "< 10 years", 
      "10-11 years", 
      "12+ years"))
    ,pnt    = as.numeric(pnt)
    ,mn     = as.numeric(mn)
    ,se     = as.numeric(se)
    ,q_025  = as.numeric(q_025)
    ,q_5    = as.numeric(q_5)
    ,q_975  = as.numeric(q_975)
  ) 
head(results)

# ---- view-dynamic ------------------
negnames <- c("pnt", "mn", "se", "q_025", "q_5", "q_975")
posnames <- names(results)
posnames <- posnames[!posnames %in% negnames]
d <- results
d[,posnames] <- lapply(d[,posnames], factor)

d %>% dplyr::select_(.dots = c(posnames,negnames)) %>%  
  dplyr::rename(
    gender = male 
  ) %>% 
  dplyr::filter(!e_name %in% c("e31", "e32")) %>% 
  DT::datatable(
  class = 'cell-border stripe',
  caption = "Results of the ELECT simulation",
  filter = "top", 
  options = list(pageLength = 14, autoWidth = TRUE)
  )



# ----- define-graphing-functions ------------------

le_scatter_simple <- function(
  results,
  ename,
  ci=FALSE
){
  # ename <- "e11"
  d <- results %>% dplyr::filter(e_name == ename) 
  # str(d)
  # define graph presets
  ses_shapes <- c("Low" = 25, "Med" = 21,"High"= 24)
  palette_gender_dark <- c("#af6ca8", "#5a8fc1") #duller than below. http://colrd.com/image-dna/42282/ & http://colrd.com/image-dna/42275/
  palette_gender_light <- adjustcolor(palette_gender_dark, alpha.f = .2)#brighter than above. http://colrd.com/palette/42278/

  g <- ggplot2::ggplot(data=d,aes(x = min_age, y=pnt, color=male, fill=male) ) +
    geom_point(aes(shape=sescat), size = 3, alpha=1) +
    geom_line(aes(group=condition_n))+
    scale_color_manual(values=palette_gender_dark,name=NULL) +
    scale_fill_manual(values=palette_gender_light,name=NULL) +
    scale_shape_manual(values = ses_shapes, name = "SES")
    if(ci){
      g <- g + facet_grid(sescat ~ educat) +
      geom_ribbon(aes(ymin=q_025,ymax=q_975,group=condition_n), alpha=.2)
    }else{
      g <- g + facet_grid(. ~ educat)
    }
    g <- g + main_theme +
    labs(x ="Age", y = "Point estimate")+
    theme(
      # axis.title.x = element_text("NNN")
    )
  # g
}
# le_scatter_simple(results, "e11",ci=F)



le_scatter_complex <- function(
  results, 
  ename,
  ymax
){ 
  e_legend <- c(
    "e11" = "Expected years in state 1 for those in state 1 at the given age",
    "e12" = "Expected years in state 2 for those in state 1 at the given age",
    "e13" = "Expected years in state 3 for those in state 1 at the given age",
    "e21" = "Expected years in state 1 for those in state 2 at the given age",
    "e22" = "Expected years in state 2 for those in state 2 at the given age",
    "e23" = "Expected years in state 3 for those in state 2 at the given age",
    "e33" = "Expected years in state 3 for those in state 3 at the given age",
    
    "e.1" = "Expected years in state 1 disregarding the state at the given age",
    "e.2" = "Expected years in state 2 disregarding the state at the given age",
    "e.3" = "Expected years in state 3 disregarding the state at the given age",
    "e"   = "Total expected years of life at the given age"
  )
  # ymax = 25
  
  line_1 <- paste0(e_legend[ename]," (",ename,")")
  line_2 <- "across levels of education"
  a <- le_scatter_simple(results, ename,ci=FALSE) + 
    labs( title = paste0(line_1," \n ",line_2 )) 
    # scale_y_continuous(limits = c(0, ymax))
  b <- le_scatter_simple(results, ename,ci=TRUE)
    # scale_y_continuous(limits = c(0, ymax))

  vpLayout <- function(rowIndex, columnIndex) { return( viewport(layout.pos.row=rowIndex, layout.pos.col=columnIndex) ) }
  grid::grid.newpage()
  #Defnie the relative proportions among the panels in the mosaic.
  layout <- grid::grid.layout(nrow=2, ncol=1,
                              widths=grid::unit(c(1) ,c("null")),
                              heights=grid::unit(c( .35,.65), c("null","null"))
  )
  grid::pushViewport(grid::viewport(layout=layout))
  # main_title <- "Title XXX"
  # grid::grid.text(main_title, vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 1))
  print(a, vp=grid::viewport(layout.pos.row=1,layout.pos.col=1))
  print(b, vp=grid::viewport(layout.pos.row=2,layout.pos.col=1))
  return(grid::popViewport(0))
}
# le_scatter_complex(results,"e11")

# ----- print-scatters --------------------
cat("\n## Total LE \n")
cat("\n### e \n")
le_scatter_complex(results,"e", ymax=30)
cat("\n")
    
cat("\n## LE without CI \n")
for(e in c("e.1","e11", "e21")){
  # for(e in c("e11", "e12")){
  cat("\n###",e,"\n")
  le_scatter_complex(results,e, ymax=30)
  cat("\n")
}

cat("\n## LE with Mild CI \n")
for(e in c("e.2","e22","e12")){
# for(e in c("e11", "e12")){
  cat("\n###",e,"\n")
  le_scatter_complex(results,e, ymax = 7)
  cat("\n")
}

cat("\n## LE with Severe CI \n")
for(e in c("e.3","e13", "e23" )){
  # for(e in c("e11", "e12")){
  cat("\n###",e,"\n")
  le_scatter_complex(results,e, ymax=5)
  cat("\n")
}
cat("\n### e33 \n")
le_scatter_complex(results,"e33", ymax=12)
cat("\n")
# ---- print-dist-1 --------------------------

age_conditions <- as.numeric(gsub("age_","",names(models)))
level_conditions <- 1:nrow(models$age_60$levels)
# available levels of covariates
print(models$age_60$levels)# %>% knitr::kable() %>% print()

# ---- print-dist-2 --------------------
for(i in level_conditions){
    cat("\n##",i,"\n")
  for(k in age_conditions){
    # k = 65
    # i = 1
    
    cat("\n###", paste0("age = ",k),"\n")
    model <- models[[paste0("age_",k)]]
    plot.elect(model$le[[i]])
    cat("\n")
    model$descriptives %>%
      dplyr::filter(condition_n == as.integer(i)) %>%
      knitr::kable() %>%
      print()
    cat("\n")
  }
}





# ---- export-selected-le-into-common-table -----------

dt <- results %>% 
  dplyr::filter(min_age %in% c(80,85), e_name %in% c("e","e.1")) %>% 
  dplyr::select(min_age, e_name, male, educat, sescat, pnt, q_025, q_975) %>% 
  dplyr::mutate(
    dense = sprintf("%0.2f(%.2f,%.2f)", pnt, q_025, q_975)
  ) %>% 
  dplyr::arrange(e_name,min_age, desc(male), desc(educat) ) %>% 
  dplyr::filter(
    educat == "< 10 years" & sescat == "Low" |
    educat == "10-11 years" & sescat == "Med" |
    educat == "12+ years" & sescat == "High" 
  )  
dt  
readr::write_csv(dt,"./reports/model-b/common-table.csv")












