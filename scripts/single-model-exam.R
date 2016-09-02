models <- readRDS("./data/shared/derived/models/version-3/models_A.rds")

model <- models$age
model <- models$age_bl
model <- models$male
model <- models$educat
model <- models$edu

model <- mA1
model <- mA2

# intensity matrix
qmatrix.msm(model)
qmatrix.msm(model, covariates = list(male = 0))
# transition probability matrix
pmatrix.msm(model, t = 2) # t = time, in original metric
# mean sojourn times
sojourn.msm(model)
# probability that each state is next
pnext.msm(model)
# total length of stay
totlos.msm(model)
# expected number of visits to the state
envisits.msm(model)
# ratio of transition intensities
qratio.msm(model,ind1 = c(2,1), ind2 = c(1,2))
# Hazard ratios for transtion
hazard.msm(model)
hazard.msm(model)
#



# summary(msm_model) 


p<-model$estimates; p.se<-sqrt(diag(model$covmat))
print(cbind(q=qnames,p=round(p,3),se=round(p.se,3)),quote=FALSE)

examine_multistate(model) 
# msm::summary.msm(msm_model)
print(msm_model)