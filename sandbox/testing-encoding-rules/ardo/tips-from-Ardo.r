#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.

# ---- load_packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) #Pipes
library(msm)

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
# requireNamespace("ggplot2", quietly=TRUE)
requireNamespace("dplyr", quietly=TRUE) #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit", quietly=TRUE)
# requireNamespace("plyr", quietly=TRUE)
 

# Example code for wide-data format to long-data format

# Ardo, UCL 2016 

####################################
# Tip 1:
# Have a look at data that is already in the correct format. See
# for example the four-state CAV data in the msm package:
#
# library(msm)
# head(cav,20)
# table(table(cav$PTNUM))  # Number of records per individual
# 
# # Note that the minimum number of records per individual is two, and
# that there quite a bit of variation in the number of records per individual
#
# Tip 2:
# There are functions in R which will help you to go from wide to
# long format. Example: the function <reshape> in the package <stats>
#
# Tip 3:
# Always start with a small data set (couple of individuals) and check
# the conversion visually
#
# Tip 4:
# If you are more used to the wide format, then it make sense to define
# intermediate missing states and right-censored states in the wide format
# before conversion
######################################


#######################################
# point to the data object
filePath <- "./sandbox/testing-encoding-rules/ardo/data-for-testing.csv"

# ---- ardo-wide-to-long-transformation ----------------------

# Load the example of the wide data:
dta.wide <- read.table(file=filePath, header=TRUE, sep = ",")
dta.wide <- as.data.frame(dta.wide %>% dplyr::select(-condition))
# Have a look at the data:
# (Note that state -1 is an intermediate missing state)
cat("\nWide-data format:\n")
print(dta.wide)

# Build long data:
(N <- nrow(dta.wide))
(subjects <- as.numeric(names(table(dta.wide$id))))
for(i in 1:N){
   # Get the individual data:
   dta.i  <- dta.wide[dta.wide$id==subjects[i],]
   # Extract the variables:
   id     <- dta.i$id
   male   <- dta.i$male
   edu    <- dta.i$edu
   ages   <- dta.i[5:8]
   states <- dta.i[9:12]
   ageD   <- dta.i$age_death
   # Define the long format for the individual data:
   ddta.i <- as.data.frame(cbind(id,male,edu,t(ages),t(states),ageD))
   names(ddta.i)<-c("id","male","edu","age","state","ageD")
   # Build up the data:
   if(i==1){dta0 <- ddta.i}else{dta0 <- rbind(dta0,ddta.i)}
}
# Redefine the row names:
row.names(dta0) <- 1:nrow(dta0)

#####################################################
# ---- andrey-wide-to-long-transformation ----------------------
ds_wide <- read.csv(filePath, stringsAsFactors = F, header = T)
ds_wide <- as.data.frame(ds_wide %>% dplyr::select(-condition))
head(ds_wide)

# declare what variables do not change over time
(time_invariant_varnames <- c("id", "male", "edu", "age_death"))
# the rest do change over time
(time_variant_varnames <- setdiff( colnames(ds_wide), time_invariant_varnames))

# define a general function for wide-to-long tranformations
make_long_from_wide <- function(
  d = d, # dataset in wide format
  time_invariant # character vector of variable names
){
  (time_variant <- setdiff(names(d), time_invariant))
  ds_long <- data.table::melt(
    data = d, 
    id.vars = time_invariant,  
    measure.vars = time_variant
  )
  # check the intermediate results during debugging
  # ds_long$variable <- as.character(ds_long$variable)
  # unique(ds_long$variable)
  # now process the elongated data
  regex <- "^(\\w+?)_(\\d+?)$" # must have a form xxxx_zz, where x - any character, z - number
  d_long <- ds_long %>%
    dplyr::mutate(
      # splits each value of the column "variable" according to regex rule
      measure = gsub(regex,"\\1",variable), # the first element
      time_point = gsub(regex,"\\2",variable) # the second element
    ) %>%
    dplyr::select(-variable) # remove uncessary column
  # head(d_long)  
  d_wide <- d_long %>% # transform back to wide, leaving time in long
    tidyr::spread(key=measure,value=value) %>%
    dplyr::arrange_(.dots=time_invariant)
  # head(d_wide)
  return(d_wide)
}
# usage of the function :
# ds_long <- make_long_from_wide(
#   d = ds_wide,
#   time_invariant = time_invariant_varnames
# )

# ---- transform-to-wide-time ----------------------------------------
ds_long <- ds_wide %>% make_long_from_wide(time_invariant_varnames)
# make identical to  Ardo's example
d_long <- ds_long %>% 
  dplyr::mutate( ageD = age_death, state = mmse) %>% 
  dplyr::select(id, male, edu, age, state, ageD) 

# compare the two outputs
head(dta0) # Ardo
head(d_long) # Andrey



# ----- ardo-encode-states ---------------------
# Add death if needed (here assuming state 5 is the dead state):
deadstate <- 4
for(i in 1:N){
   # Get the individual data:
   dta.i <- dta0[dta0$id==subjects[i],]
   # Encode live states - added by Andrey
   dta.i$state <- ifelse( 
     dta.i$state > 26, 1, ifelse( # healthy
       dta.i$state <= 26 &  dta.i$state >= 23, 2, ifelse( # mild CI
         dta.i$state < 23, 3,NA))) # mod-sever CI
   # Is there a death? If so, add a record:
   death <- !is.na(dta.i$ageD[1])
   if(death){
      record <- dta.i[1,]
      record$state <- deadstate
      record$age   <- dta.i$ageD[1]
      ddta.i <- rbind(dta.i,record)
   }else{ddta.i <- dta.i}
   # Rebuild the data:
   if(i==1){dta1 <- ddta.i}else{dta1 <- rbind(dta1,ddta.i)}
}
# Remove <ageD> from the data:
dta1 <- dta1[-6]
# Redefine the row names:
row.names(dta1) <- 1:nrow(dta1)

# Remove all records with no state:
dta <-dta1[!is.na(dta1$state),] 

# Have a look at the data:
cat("\nLong-data format:\n")
print(dta)




# ---- andrey-encodes-missing-states ------------------
d <- ds_long %>% 
  dplyr::select(id, male, edu, age, mmse, age_death ) 
print(d[d$id %in% c(5,11),])
str(d)
# x <- c(NA, 5, NA, 7)
determine_censor <- function(x, is_right_censored){
  ifelse(is_right_censored, -2,
         ifelse(is.na(x), -1, x)
  )
}
# determine_censor(x)

d <- d %>% 
  dplyr::filter(id %in% c(5,11)) %>%
  dplyr::group_by(id) %>% 
  dplyr::arrange(-age) %>% 
  dplyr::mutate( 
    missed_last_wave  = (cumsum(!is.na(mmse))==0L),
    still_alive       = is.na(any(age_death)),
    right_censored    = as.integer(missed_last_wave & still_alive)
    ,mmse_recoded     = determine_censor(mmse, right_censored)
    # ,mmse             = determine_censor(mmse, right_censored)
  ) %>% 
  dplyr::select(-missed_last_wave, -still_alive,-right_censored ) %>%
  dplyr::arrange(age) %>% 
  dplyr::ungroup()

# drop variables you don't need
# TODO: have  determine_censor include the sorting variable (age), so that 
# you could make the outcome (mmse) dynamicly defined. 
# example: negative_two <- (cumsum(!is.na(c(NA, 5, NA, 7)))==0L)

print(d[d$id==5,])

# Subject's age at each measurement is assumed to be known
# For ids 1:5, the age of death is available
# For ids 6:10 the age of death is not available

# id = 1(7)  : ideal case 
# id = 2(8)  : ideal case + reverse transition
# id = 3(9)  : missing Y on last wave 
# id = 4(10) : missing Y on intermidiate wave
# id = 5(11) : missing Y on intermediate wave and last wave
# id = 6(12) : missing Y and TIME on last wave ( no measure collected on wave 4)


# ---- andrey-encode-states ----------------------------------

encode_multistates <- function(
  d, # data frame in long format 
  outcome_name, # measure to compute live states
  age_name, # age at each wave
  age_death_name, # age of death
  dead_state_value # value to represent dead state
){
  # declare arguments for debugging
  # d = d,
  # outcome_name = "mmse";age_name = "age";age_death_name = "age_death";dead_state_value = 4
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
          dta.i$state < 23 & dta.i$state > 0, 3, dta.i$state))) # mod-sever CI
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

ds_ms <- encode_multistates(
  d = d,
  outcome_name = "mmse",
  age_name = "age",
  age_death_name = "age_death",
  dead_state_value = 4
)
# Remove all records with no state:
ds_ms <-ds_ms[!is.na(ds_ms$state),] 

# compare outcomes
print(dta) # Ardo
print(ds_ms) # Andrey

# compare before and after ms encoding
view_id <- function(d,ds_ms,id){
  cat("Before ms encoding:","\n")
  print(d[d$id==id,])
  cat("After ms encoding","\n")
  print(ds_ms[ds_ms$id==id,])
}
for(i in 12){
  cat("\nPrinting observation for subject with id = ",i,"\n")
  view_id(d, ds_ms,i)  
} 
# Subject's age at each measurement is assumed to be known
# For ids 1:5, the age of death is available
# For ids 6:10 the age of death is not available

# id = 1(7)  : ideal case 
# id = 2(8)  : ideal case + reverse transition
# id = 3(9)  : missing Y on last wave 
# id = 4(10) : missing Y on intermidiate wave
# id = 5(11) : missing Y on intermediate wave and last wave
# id = 6(12) : missing Y and TIME on last wave ( no measure collected on wave 4)





