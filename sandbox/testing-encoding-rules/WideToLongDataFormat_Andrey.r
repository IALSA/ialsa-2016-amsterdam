# Example code for wide-data format to long-data format

# Ardo, UCL 2016 

####################################
# Tip 1:
# Have a look at data that is already in the correct format. See
# for example the four-state CAV data in the msm package:
#
library(msm)
head(cav,20)
table(table(cav$PTNUM))  # Number of records per individual

# Note that the minimum number of records per individual is two, and
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
# Some code to go form wide-data format to long-data format:

# Load the example of the wide data: 
dta.wide <- read.table(file="./sandbox/testing-encoding-rules/ardo/data-for-testing-v1.csv", header=TRUE, sep = ",") 
# Have a look at the data:
# (Note that state -1 is an intermediate missing state)
cat("\nWide-data format:\n")
print(dta.wide)


# Build long data:
N <- nrow(dta.wide)
subjects <- as.numeric(names(table(dta.wide$id)))
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

# Add death if needed (here assuming state 5 is the dead state):
deadstate <- 5
for(i in 1:N){
   # Get the individual data:
   dta.i <- dta0[dta0$id==subjects[i],]
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
