# knitr::stitch_rmd(script="./manipulation/rename-classify.R", output="./manipulation/rename-classify.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load_sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.

# ---- load_packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) #Pipes
library(msm)

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
# requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit", quietly=TRUE)
# requireNamespace("plyr", quietly=TRUE)

# ---- declare-globals ----------------------------------------------
data_path_input  <- "./data/shared/raw/data-for-testing.csv"

# ---- load-data ------------------------------------------------
ds_wide <- read.csv(data_path_input, header = T, stringsAsFactors = F)
ds_wide[ds_wide=="#N/A"] <- NA # recode

# ---- define-variables -----------------------------------------
# we assume that data files arrives in a wide format
# Specifically, this implies that all variables could be classified
# into two groups:
time_invariant_varnames <- c(
  "id",
  "male",
  "edu", 
  "age_death" 
) 
# and, by exclusion,
(time_variant_varnames <- setdiff(names(ds_wide),time_invariant_varnames))
# we also require from the dataset that variable names of the time variant variables
# be identified with respect to the occasion of measurement by the complex ending "_n",
# where a numerical wave indicator "n" is appended to the variable name, separated by an underscore "_"

# ---- establish-transform-to-long --------------------------------
# this is the initial state of data from which multi states will be computed
ds_wide %>% dplyr::glimpse()

# following function requires all time-variant names to be of the form : [stem][_][number] (e.g. mmse_0)
# where "stem" may include any text character,  "number" is 1 or 2 digits of the wave number,
# "stem" and "number" are connected by an underscore symbol "_"
elongate_time <- function(
  d = d, # data in wide format, with encoded multi-state 
  time_invariant # specify the variables that do not change with time (all other will be expected to)
){
  (time_variant <- setdiff(names(d), time_invariant))
  
  ds_long <- data.table::melt(data = d, id.vars = time_invariant,  measure.vars = time_variant)
  ds_long$variable <- as.character(ds_long$variable)
  unique(ds_long$variable)
  # 
  regex <- "^(\\w+?)_(\\d+?)$" 
  d_long <- ds_long %>%
    dplyr::mutate(
      measure = gsub(regex,"\\1",variable),
      time_point = gsub(regex,"\\2",variable)
    ) %>%
    dplyr::select(-variable)
  head(d_long)  
  
  d_wide <- d_long %>%
    tidyr::spread(key=measure,value=value) %>%
    dplyr::arrange_(.dots=time_invariant)
  head(d_wide)
  return(d_wide)
}
ds_long <- elongate_time(ds_wide,time_invariant_varnames)

# print one respondent
ds_long %>% 
  dplyr::filter(id %in% c(2))

# alternatively, directly from wide
ds_wide %>% 
  elongate_time(time_invariant_varnames) %>%
  dplyr::filter(id==2)



# ---- recode-into-states-from-wide -------------------------------------------------------
# Guide to missingness : 
# -1 = denotes an intermediate missing state, e.i. There is a time of interview, but no observed state
# -2 = denotes being alive, bun in unknown state (there is no time of interview?)

d <- ds_wide # for brevity, an object to add to
d %>%
  elongate_time(time_invariant_varnames) %>%
  dplyr::filter(id==2)


for(w in sort(unique(ds_long$time_point))){ # w = 3
  # define varnames at waves
  (age_w <- paste0("age_",w))
  (var_w <- paste0("mmse_",w))
  (alive_w <- paste0("alive_",w))
  (state_w <- paste0("state_",w))
  
  d[,alive_w] <- 1 # start assuming R is alive
  for( i in 1:nrow(d)){
    d[i,alive_w] <- ifelse( 
      test = (!is.na(d[i,"age_death"]) & is.na(d[i,age_w]) ) , # only one case when R could be declared dead
      yes = FALSE,
      no = d[i,alive_w]
    ) 
  }

  # t(d %>% dplyr::filter(id %in% c(13) ))
  # R is alive, but ...
  d[,state_w] <- ifelse(
    # ... no age or measure present = right censored = unknown living state
    d[,alive_w]==1 & is.na(d[,age_w]) & is.na(d[,var_w]),  -2,  ifelse(
      # ... age is present, but measure is missing = intermediate missing state
      d[,alive_w]==1 & !is.na(d[,age_w]) & is.na(d[,var_w]),  -1, ifelse(
        # ... and has no cognitive impairment (HEALTHY)
        d[,alive_w]==1 & d[,var_w] >= 27,  1,  ifelse(
          # ... nd has mild cognitive impairment (MCI)
          d[,alive_w]==1 & d[,var_w] >= 23 & d[i,var_w] < 27,  2,  ifelse(
            # ... and has severe cognitive impairment (SCI)
            d[,alive_w]==1 & d[,var_w] < 23,  3, ifelse(
              # not alive
              d[,alive_w]==0, 4, NA)))))) 
  
}

# names(d) # data in wide format, with encoded multi-state 
d %>% 
  elongate_time(time_invariant_varnames) %>% 
  dplyr::filter(id==2)
# convert to long
dl <- d %>% 
  elongate_time(time_invariant_varnames) 
# see transition matrix
msm::statetable.msm(state,id,dl)


# ---- converting-from-long-format -------------------------------
# on the other hand, we can begin the encoding into mutli state variable from a long fromat
# below is the version of the script in which I used binary "dementia" instead of "mmse"
# to use as the source of multistate value computation.


#### Experimental code below ##################
#### Not for running, just for viewing ##########


# ---- look-up-pattern-for-single-id --------------------------------------------------------------
# if died==1, all subsequent focal_outcome==DEAD.
set.seed(1)
ids <- sample(unique(ds_long$id),1); ids <- 2
ds_long %>% dplyr::filter(id==2)
# assembles only the variables to be used in ms computing
d <- ds_long %>% 
  dplyr::filter(id %in% ids) %>%
  dplyr::select_("id","time_point","age_death","age","dementia") %>%
  # dplyr::select_("id","time_point","age_death","age","mmse") %>%
  dplyr::mutate(
    age_death = as.numeric(age_death)
  )
d

# d$id <- substring(d$id,1,1)
# write.csv(d,"./data/shared/musti-state-dementia.csv")  



# ---- ms_dementia -------------------------------------------------------------
# compute alive states
ds_alive <- d %>% 
  dplyr::rename(
    dementia_now=dementia, 
    fu_point = time_point) %>% 
  dplyr::group_by(id) %>% 
  dplyr::mutate(
    dead_now = FALSE,
    dementia_now   = as.logical(dementia_now),
    dementia_ever  = any(dementia_now)
  ) %>% 
  dplyr::ungroup()
ds_alive
# str(ds_alive )
# compute dead states
ds_dead <- ds_alive %>% 
  dplyr::filter(!is.na(age_death)) %>% 
  dplyr::group_by(id) %>% 
  dplyr::arrange(fu_point) %>% 
  dplyr::summarize(
    dead_now = TRUE,
    fu_point       = max(fu_point) + 1L,
    age_death      = max(age_death),
    age_at_visit   = NA_real_,
    dementia_last  = dplyr::last(dementia_now),
    dementia_now   = ifelse(dementia_last, TRUE, NA),
    dementia_ever  = any(dementia_now)
  ) %>% 
  dplyr::ungroup() %>% 
  dplyr::select(-dementia_last)
ds_dead
# str(ds_dead)
# combine dead and alive
ds <- ds_alive %>%
  dplyr::union(ds_dead) %>%
  dplyr::arrange(id, fu_point)
ds

# compute the multistate variable
ds <- ds %>%
  dplyr::mutate(
    state = ifelse(!dead_now & !dementia_now, 1,
                   ifelse(!dead_now & dementia_now, 2, 
                          ifelse(dead_now, 3, NA)))
  ) 
ds
ds$state <- ordered(ds$state, levels = c(1,2,3),
                    labels = c("Healthy","Sick","Dead"))
str(ds)

a <- ds_long %>% 
  dplyr::filter(id %in% ids) %>%
  dplyr::mutate(fu_point = time_point) %>% 
  dplyr::select_("id", "fu_point")
b <- ds %>% dplyr::select_("id","fu_point")
ab <- dplyr::union(a,b)
dsab <- ds_long %>% 
  dplyr::filter(id %in% ids) %>% 
  dplyr::select(id, msex, age_at_visit)


c <- dplyr::left_join(ds_long)
# a <- ds_long
# d <- ds %>% dplyr::select(id,state)
dsab <- dplyr::left_join(b,a,  by="id")

table(aa$fu_point, aa$state)
#