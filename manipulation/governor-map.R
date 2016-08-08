rm(list=ls(all=TRUE)) # clear environment
cat("\f") # clear console 


# All data land on Ellis Island
knitr::stitch_rmd(
  script="./manipulation/map/0-ellis-island-map.R", 
  output="./manipulation/map/stitched-output/0-ellis-island-map.md"
)
# look into knitr::spin() http://www.r-bloggers.com/knitrs-best-hidden-gem-spin/

# Initial reivew of variables
rmarkdown::render(
  input = "./reports/review-variables/map/review-variables-map.Rmd" ,
  output_format="html_document",
  clean=TRUE
)

# Encoding of the multi-state (ms) measure(s)
knitr::stitch_rmd(
  script="./manipulation/map/1-encode-multistate-mmse.R",
  output="./manipulation/map/stitched-output/1-encode-multistate-mmse.md"
)
 

## Reproducible Reports

# Domonstration and annotation of how multistate variable has been computed
rmarkdown::render(
  input = "./reports/encode-multistate/encode-multistate.Rmd",
  output_format="html_document", 
  clean=TRUE
)