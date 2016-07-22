# ialsa-2016-amsterdam
Multi-study and multivariate evaluation of healthy life expectancy (HLE): An IALSA workshop on multistate modeling using R . [edit me](https://github.com/IALSA/ialsa-2016-amsterdam/edit/master/README.md)

#### Reproducible reports
- Follow [`./utility/reproducibility-instructions.md`](utility/reproducibility-instructions.md) to create dynamic documents linked below:
- `./manipulation/map/`[`0-ellis-island-map.R`][ellis-island-map]  
- `./reports/`[`review-variables.R`][review-variables-map]
- `./manipulation/map/`[`1-encode-multistate.R`][https://rawgit.com/IALSA/ialsa-2016-amsterdam/master/manipulation/map/1-encode-multistate-mmse.R]


#### Documentation
- [letter of invitation](./documentation/log/2016-03-02-invitation-letter.md)   
- venue: [Amsterdam, April 14-16, 2016](./documentation/venue.md)
- instructional and academic [resources](./documentation/resources-and-references.md)
- overview of the [studies and variables](./documentation/studies-and-variables.md)


#### Rational and Objective
This is a hands-on workshop for the purpose of active data analysis on a variety of datasets during the two-day workshop. We expect this to be a productive workshop with the aim of publishing outcomes of analyses that are developed during the workshop. Although this is also a learning opportunity, we encourage participants to participate in a multi-study papers before publishing independent results.

The **objectives** of this workshop are: 
* 1. Evaluate sensitivity of using alternative variables/definitions of HLE and Cognitive Impairment/Dementia-Free HLE and replication across studies.  
* 2. Evaluate utility of multistate model for making individual predictions of future transitions and confidence in making individual predictions.   
 
#### Brief look   
* **Candidate Studies** : HRS,  ELSA   , LASA  ,  WLS  ,  MAP  ,  OCTO-Twin, H-70, LBSC       
* **Outcomes** :  ADL/IADL,  MMSE < 24, self-rated health, diagnosis of dementia, other cognitive variables (decisions about thresholds and alternative models required)     
* **Major covariates** : age at baseline,  sex , education, SES/SEP   
* **Minor covariates** : BMI, sedentary behavior (physical activity) , smoking (various),  alcohol use (various),  chronic conditions (comorbidity index)   
*  [closer look](./documentation/studies-and-variables.md)   


#### Resources 

The workshop lectures will be delivered by Dr. Ardo van den Hout (UCL, Lecturer at the Department of Statistics), developer of the R package ELECT that estimates these models. Participants are encouraged to review at the [ELECT web site](http://www.ucl.ac.uk/~ucakadl/ELECT/indexELECT.html) to prepare for this workshop. 

Here are some example operationalizations: http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2966893/  and  http://www.ncbi.nlm.nih.gov/pubmed/25150976. For example, the BRFSS question used to assess health status was "Would you say that in general your health is excellent, very good, good, fair, or poor?" For this study, participant responses of "fair or poor" were categorized as "unhealthy" and "excellent, very good, or good" as "healthy."


[ellis-island-map]:https://rawgit.com/IALSA/ialsa-2016-amsterdam-public/master/0-ellis-island-map.html
[review-variables-map]:https://rawgit.com/IALSA/ialsa-2016-amsterdam-public/master/review-variables-map.html
encode-multistate-map]:
