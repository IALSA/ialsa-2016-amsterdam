# ----- define-lookup-function-list -----------------------
names_labels_datas <- function(domain, file, wave){
  if(is.null(datas[[domain]][[file]][[wave]])){cat("You don't have this file")}else{
    ds0 <- datas[[domain]][[file]][[wave]]
    nl <- data.frame(matrix(NA, nrow=ncol(ds0), ncol=2))
    names(nl) <- c("name","label")
      for (i in seq_along(names(ds0))){
        nl[i,"name"] <- attr(ds0[i], "names")
          if(is.null(attr(ds0[[i]], "label")) ){
          nl[i,"label"] <- NA}else{
          nl[i,"label"] <- attr(ds0[[i]], "label")
          }
      }
    return(nl)
  }
}
# names.labels("cognitive", "035","B") # assumes the presence of the list `datas`

# ---- define-lookup-function-ds -------------------
names_labels <- function(ds){
     ds0 <- ds
    nl <- data.frame(matrix(NA, nrow=ncol(ds0), ncol=2))
    names(nl) <- c("name","label")
      for (i in seq_along(names(ds0))){
        nl[i,"name"] <- attr(ds0[i], "names")
          if(is.null(attr(ds0[[i]], "label")) ){
          nl[i,"label"] <- NA}else{
          nl[i,"label"] <- attr(ds0[[i]], "label")
          }
      }
    return(nl)
  }
# names.labels2(ds) # take in a dataset


# ----- define-merge-function ---------------------
merge_lasa_files <- function(list){
  Reduce(function( d_1, d_2 ) merge(d_1, d_2, by="respnr"), list)
}
# ds <- merge.files(datas[["cognitive"]][["021"]])
