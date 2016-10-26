rm(list=ls(all=TRUE)) # clear environment
cat("\f") # clear console 



path_est  <- base::file.path("./reports/model-b/estimation.Rmd")

path_anal_v1  <- base::file.path("./reports/model-b/analysis-v1.Rmd")
path_dist_v1   <- base::file.path("./reports/model-b/distributions-v1.Rmd")

path_anal_v2  <- base::file.path("./reports/model-b/analysis-v2.Rmd")
path_dist_v2   <- base::file.path("./reports/model-b/distributions-v2.Rmd")



# Has no gait: map, nuage, satsa

#  Define groups of reports
allReports<- c(
  # path_est
  path_anal_v1
  ,path_dist_v1
  ,path_anal_v2
  ,path_dist_v2
)
# Place report paths HERE ###########
pathFilesToBuild <- c(allReports) ##########


testit::assert("The knitr Rmd files should exist.", base::file.exists(pathFilesToBuild))
# Build the reports
for( pathFile in pathFilesToBuild ) {
  #   pathMd <- base::gsub(pattern=".Rmd$", replacement=".md", x=pathRmd)
  rmarkdown::render(input = pathFile,
                    output_format=c(
                      "html_document" # set print_format <- "html" in seed-study.R
                      #, "pdf_document"
                      # ,"md_document"
                      # "word_document" # set print_format <- "pandoc" in seed-study.R
                    ),
                    clean=TRUE)
}