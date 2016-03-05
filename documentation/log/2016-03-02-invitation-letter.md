Dear Colleagues, 

We are organising an IALSA workshop on multistate models for the estimation of “Healthy Life Expectancy (HLE)” April 14-April 16 in Amsterdam. This is a hands-on workshop for the purpose of active data analysis on a variety of datasets during the two-day workshop. Participants should have access to R and have installed the package “msm” on their laptops for purposes of this workshop. We also encourage participants to bring their own data (see format required below) and to be willing to collaborate on joint papers deriving from this workshop.

Expenses for travel and accommodation will be paid by the Integrative Analysis of Longitudinal Studies of Aging and Dementia (IALSA) network through the University of Victoria. We expect this to be a productive workshop with the aim of publishing outcomes of analyses that are developed during the workshop. Although this is also a learning opportunity, we encourage participants to participate in a multi-study papers before publishing independent results.

The workshop lectures will be delivered by Dr. Ardo van den Hout (UCL, Lecturer at the Department of Statistics), developer of the R package ELECT that estimates these models. Participants are encouraged to review at the ELECT web site: http://www.ucl.ac.uk/~ucakadl/indexELECT.html to prepare for this workshop. The objectives of this workshop are:
•	Evaluate sensitivity of using alternative variables/definitions of HLE and Cognitive Impairment/Dementia-Free HLE and replication across studies. 
•	Evaluate utility of multistate model for making individual predictions of future transitions and confidence in making individual predictions.

Data will potentially include: HRS, ELSA, CHAP, LASA, WLS, MAP, and OCTO-Twin.

Data sets should include these variables (as possible) to permit alternative models to be evaluated across studies:
Outcomes: ADL/IADL; MMSE < 24; self-rated health, diagnosis of dementia, other cognitive variables (decisions about thresholds and alternative models required)
Covariates: age at baseline, sex, education, SES/SEP
Additional covariates: BMI, sedentary behavior (phys activity), smoking (various), alcohol use (various), chronic conditions (comorbidity index)

Here are some example operationalizations: http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2966893/; http://www.ncbi.nlm.nih.gov/pubmed/25150976. For example, the BRFSS question used to assess health status was "Would you say that in general your health is excellent, very good, good, fair, or poor?" For this study, participant responses of "fair or poor" were categorized as "unhealthy" and "excellent, very good, or good" as "healthy."

Data format:
- Longitudinal in long format (one record per observation); see below
- Interval-censored transition times are OK
- Data with exact time of transition is also OK
- Data with a mix of interval censoring, right censoring, and exact times are OK
- Up to five-state models are OK 
- One of the state is the dead state (else you cannot really talk about life expectancy)
- State are denoted by integers 1,2,3..., with the dead state being the highest integer

Here are two example of the require data format (with x a covariate)

```
  id state   age   x
   3     1   65     19
   3     1   67     19
   3     1   68     19
   3     1   74     19
   3     2   75     19
   3     3   77.3   19
```
and 
```
   id state  age    x
    4     1     0       1
    4     2     1       1
    4     1    1.7     1
    4     1    3.7     1
    4     1    5.7     1
    4     1    7.7     1
    4    -2    9.7     1
```
The -2 in the last example denotes a right-censored state. For the fitting of models it is essential that consecutive records for one individual do not contain the same age. Age can be in years, but also in months. Please review the materials on the ELECT web site: [http://www.ucl.ac.uk/~ucakadl/indexELECT.html](http://www.ucl.ac.uk/~ucakadl/indexELECT.html) to prepare for and gain further understanding of the multistate model and data requirements. 

Other practical information regarding dates and venue:

Hotel: [http://www.zuiveramsterdam.nl/hotel-en/](http://www.zuiveramsterdam.nl/hotel-en/)
 
 
Koenenkade 8-10
1081 KH Amsterdam 
Nederland	   

 
By public transport from Schiphol airport to the hotel:
Take bus 310 at airport/plaza Schiphol (direction Station Zuid) get off at the stop VUmc, De Boelelaan, Amsterdam, from here to the hotel, 12 min. walking (see walking route )![}(https://www.google.nl/maps/dir/De+Boelelaan+1117,+1081+HV+Amsterdam/Koenenkade+10,+1081+KH+Amsterdam/@52.3325083,4.8547264,17z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x47c5e1e2e626845f:0xa01a0dc26d04114b!2m2!1d4.8598158!2d52.3345709!1m5!1m1!1s0x47c5e1e42c8d5e47:0xc8f10fa0fd453c5a!2m2!1d4.852003!2d52.3315249!3e2)              
 
From Central Station  to the hotel : 
Bus
Line 170 and 172: get off at the stop Koenenkade (see walking route below) .
 
 
Tram
Line 16: get off at the stop VUmc, De Boelelaan
![](https://www.google.nl/maps/dir/De+Boelelaan+1117,+1081+HV+Amsterdam/Koenenkade+10,+1081+KH+Amsterdam/@52.3325083,4.8547264,17z/data=!3m1!4b1!4m14!4m13!1m5!1m1!1s0x47c5e1e2e626845f:0xa01a0dc26d04114b!2m2!1d4.8598158!2d52.3345709!1m5!1m1!1s0x47c5e1e42c8d5e47:0xc8f10fa0fd453c5a!2m2!1d4.852003!2d52.3315249!3e20)

We hope you can join us in Amsterdam!

Cheers,

Graciela Muniz-Terrera, University of Edinburgh
Scott Hofer, University of Victoria/Oregon Health & Science University

