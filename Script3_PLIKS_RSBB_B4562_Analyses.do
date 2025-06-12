*** PROJECT: Exploring the association between psychotic experiences and religious beliefs and behaviours (B4562)
*** STATA VERSION 18
*** Script 3: Analysis
*** Created 31/01/2025 by Dan Major-Smith (based on script by Grace Obo)

* Change working directory
cd "X:\Studies\RSBB Team\Dan\B4562 - PLIKS and RSBB"

** Install any user-written packages
*ssc install missings, replace
*ssc install mimrgns, replace
*ssc install evalue, replace

** Create log file
capture log close
log using ".\Results\PLEandReligion_analysis.log", replace

* Open processed dataset
use "PLIKS_RSBB_B4562_Processed.dta", clear

** Or, if using synthetic data
*use ".\AnalysisCode_PLIKS_RSBB_B4562\SyntheticData\syntheticData_B4562.dta", clear
*drop FALSE_DATA


*****************************************************************************************
****** Descriptive statistics

** For each variable, want descriptive stats in full ALSPAC sample, analytic sample (i.e., the 5,879 participants with any PLE and/or religion data), CCA for RQ1, and CCA for RQ2

* Analytic/MI sample
gen for_mi = 0 
replace for_mi = 1 if PLE24_since12 != . | PLE32 != . | belief != . | identity != . | attend != . | lca!= .
tab for_mi

* CCA for RQ1
gen cca_rq1 = 0
replace cca_rq1 = 1 if (belief != . | identity != . | attend != . | lca != .) & ///
	PLE24_since12_susdef != . & mat_age != . & mat_home != . & mat_marital != . & ///
	mat_edu != . & mat_imd != . & mat_dep != . & mat_anx != . & mat_aces != . & ///
	mat_belief != . & mat_identity != . & mat_attend != . & pat_dep != . & pat_anx != . & ///
	pat_aces != . & pat_belief != . & pat_identity != . & pat_attend != . & sex != . & ///
	ethnic != . & trauma11 != . & age28 != . & LoC8 != . & MH10 != .
tab cca_rq1

* CCA for RQ2
gen cca_rq2 = 0
replace cca_rq2 = 1 if (belief != . | identity != . | attend != . | lca != .) & ///
	PLE32 != . & mat_age != . & mat_home != . & mat_marital != . & ///
	mat_edu != . & mat_imd != . & mat_dep != . & mat_anx != . & mat_aces != . & ///
	mat_belief != . & mat_identity != . & mat_attend != . & pat_dep != . & pat_anx != . & ///
	pat_aces != . & pat_belief != . & pat_identity != . & pat_attend != . & sex != . & ///
	ethnic != . & trauma17 != . & age32 != . & relationship != . & edu != . & ///
	income != . & imd != . & home != . & PLE24_stem != . & dep24 != . & anx24 != . & LoC16 != .
tab cca_rq2


** Descriptive stats

* Categorical variables
tab1 PLE24_since12-lca mat_home-mat_imd mat_belief-mat_attend pat_belief-home ///
	trauma11 trauma17 PLE24_stem MH10 dep24 anx24
tab1 PLE24_since12-lca mat_home-mat_imd mat_belief-mat_attend pat_belief-home ///
	trauma11 trauma17 PLE24_stem PLE24_stem MH10 dep24 anx24 if for_mi == 1
tab1 PLE24_since12-PLE24_since12_def belief-lca mat_home-mat_imd mat_belief-mat_attend ///
	pat_belief-ethnic trauma11 MH10 if cca_rq1 == 1
tab1 PLE24_since12 PLE32-lca mat_home-mat_imd mat_belief-mat_attend pat_belief-home ///
	trauma17 PLE24_stem dep24 anx24 if cca_rq2 == 1

* Continuous variables
sum mat_age mat_dep mat_anx mat_aces pat_dep pat_anx pat_aces age28 age32 LoC8 LoC16
sum mat_age mat_dep mat_anx mat_aces pat_dep pat_anx pat_aces age28 age32 LoC8 LoC16 if for_mi == 1
sum mat_age mat_dep mat_anx mat_aces pat_dep pat_anx pat_aces age28 LoC8 if cca_rq1 == 1
sum mat_age mat_dep mat_anx mat_aces pat_dep pat_anx pat_aces age32 LoC16 if cca_rq2 == 1


* Explore missing data in the samples
missings report _all, percent
missings report _all if for_mi == 1, percent
missings report _all if cca_rq1 == 1, percent
missings report _all if cca_rq2 == 1, percent


drop for_mi cca_rq1 cca_rq2


** Tetrachoric correlation between PLEs at ages 24 and 32
tab PLE24_since12_susdef PLE32, row chi
tetrachoric PLE24_since12_susdef PLE32

tab PLE24_stem PLE32, row chi
tetrachoric PLE24_stem PLE32


*****************************************************************************************
****** Complete-case analyses

***** RQ1: PLIKS at 24 as exposure and religion at 28 as outcome

**** Definition of PLE as suspected or definite from age 12

*** Religious belief

** Adjusted
mlogit belief i.PLE24_since12_susdef mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8, rrr baseoutcome(0)
	
* Marginal effects
margins PLE24_since12_susdef // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_susdef // Difference (marginal effect) of exposure for each level of outcome
	
	
** Unadjusted
capture drop sample
gen sample = e(sample)

tab PLE24_since12_susdef belief if sample == 1, row

mlogit belief i.PLE24_since12_susdef if sample == 1, rrr baseoutcome(0)

* Marginal effects
margins PLE24_since12_susdef // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_susdef // Difference (marginal effect) of exposure for each level of outcome



*** Religious identity

** Adjusted
logistic identity i.PLE24_since12_susdef mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8
	
* Marginal effects
margins PLE24_since12_susdef // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_susdef // Difference (marginal effect) of exposure on outcome
	
	
** Unadjusted
capture drop sample
gen sample = e(sample)

tab PLE24_since12_susdef identity if sample == 1, row

logistic identity i.PLE24_since12_susdef if sample == 1

* Marginal effects
margins PLE24_since12_susdef // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_susdef // Difference (marginal effect) of exposure on outcome



*** Religious attendance

** Adjusted
logistic attend i.PLE24_since12_susdef mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8
	
* Marginal effects
margins PLE24_since12_susdef // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_susdef // Difference (marginal effect) of exposure on outcome
	
	
** Unadjusted
capture drop sample
gen sample = e(sample)

tab PLE24_since12_susdef attend if sample == 1, row

logistic attend i.PLE24_since12_susdef if sample == 1

* Marginal effects
margins PLE24_since12_susdef // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_susdef // Difference (marginal effect) of exposure on outcome



*** Religious LCA

** Adjusted
mlogit lca i.PLE24_since12_susdef mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8, rrr baseoutcome(1)
	
* Marginal effects
margins PLE24_since12_susdef // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_susdef // Difference (marginal effect) of exposure for each level of outcome
	
	
** Unadjusted
capture drop sample
gen sample = e(sample)

tab PLE24_since12_susdef lca if sample == 1, row

mlogit lca i.PLE24_since12_susdef if sample == 1, rrr baseoutcome(1)

* Marginal effects
margins PLE24_since12_susdef // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_susdef // Difference (marginal effect) of exposure for each level of outcome



*****************************************
***** Sensitivity analysis: Definition of PLE as definite from age 12

*** Religious belief

** Adjusted
mlogit belief i.PLE24_since12_def mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8, rrr baseoutcome(0)
	
* Marginal effects
margins PLE24_since12_def // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_def // Difference (marginal effect) of exposure for each level of outcome
	
	
** Unadjusted
capture drop sample
gen sample = e(sample)

tab PLE24_since12_def belief if sample == 1, row

mlogit belief i.PLE24_since12_def if sample == 1, rrr baseoutcome(0)

* Marginal effects
margins PLE24_since12_def // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_def // Difference (marginal effect) of exposure for each level of outcome


	
*** Religious identity

** Adjusted
logistic identity i.PLE24_since12_def mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8
	
* Marginal effects
margins PLE24_since12_def // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_def // Difference (marginal effect) of exposure on outcome
	
	
** Unadjusted
capture drop sample
gen sample = e(sample)

tab PLE24_since12_def identity if sample == 1, row

logistic identity i.PLE24_since12_def if sample == 1

* Marginal effects
margins PLE24_since12_def // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_def // Difference (marginal effect) of exposure on outcome



*** Religious attendance

** Adjusted
logistic attend i.PLE24_since12_def mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8
	
* Marginal effects
margins PLE24_since12_def // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_def // Difference (marginal effect) of exposure on outcome
	
	
** Unadjusted
capture drop sample
gen sample = e(sample)

tab PLE24_since12_def attend if sample == 1, row

logistic attend i.PLE24_since12_def if sample == 1

* Marginal effects
margins PLE24_since12_def // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_def // Difference (marginal effect) of exposure on outcome



*** Religious LCA

** Adjusted
mlogit lca i.PLE24_since12_def mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8, rrr baseoutcome(1)
	
* Marginal effects
margins PLE24_since12_def // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_def // Difference (marginal effect) of exposure for each level of outcome
	
	
** Unadjusted
capture drop sample
gen sample = e(sample)

tab PLE24_since12_def lca if sample == 1, row

mlogit lca i.PLE24_since12_def if sample == 1, rrr baseoutcome(1)

* Marginal effects
margins PLE24_since12_def // Predicted probability of outcome for each level of exposure
margins r.PLE24_since12_def // Difference (marginal effect) of exposure for each level of outcome



***************************
***** RQ2: Religion at 28 as exposure and PLE at 32 as outcome

*** Religious belief exposure
logistic PLE32 i.belief i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma17 i.relationship i.edu i.income i.imd i.home age32 ///
	i.PLE24_stem i.dep24 i.anx24 LoC16
	
* Marginal effects
margins belief // Predicted probability of outcome for each level of exposure
margins r.belief // Difference (marginal effect) of exposure on outcome


** Unadjusted
capture drop sample
gen sample = e(sample)

tab belief PLE32 if sample == 1, row

logistic PLE32 i.belief if sample == 1

* Marginal effects
margins belief // Predicted probability of outcome for each level of exposure
margins r.belief // Difference (marginal effect) of exposure on outcome


*** Religious identity exposure
logistic PLE32 i.identity i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma17 i.relationship i.edu i.income i.imd i.home age32  ///
	i.PLE24_stem i.dep24 i.anx24 LoC16
	
* Marginal effects
margins identity // Predicted probability of outcome for each level of exposure
margins r.identity // Difference (marginal effect) of exposure on outcome


** Unadjusted
capture drop sample
gen sample = e(sample)

tab identity PLE32 if sample == 1, row

logistic PLE32 i.identity if sample == 1

* Marginal effects
margins identity // Predicted probability of outcome for each level of exposure
margins r.identity // Difference (marginal effect) of exposure on outcome



*** Religious attendance exposure
logistic PLE32 i.attend i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma17 i.relationship i.edu i.income i.imd i.home age32  ///
	i.PLE24_stem i.dep24 i.anx24 LoC16
	
* Marginal effects
margins attend // Predicted probability of outcome for each level of exposure
margins r.attend // Difference (marginal effect) of exposure on outcome


** Unadjusted
capture drop sample
gen sample = e(sample)

tab attend PLE32 if sample == 1, row

logistic PLE32 i.attend if sample == 1

* Marginal effects
margins attend // Predicted probability of outcome for each level of exposure
margins r.attend // Difference (marginal effect) of exposure on outcome



*** Religious LCA exposure
logistic PLE32 i.lca i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma17 i.relationship i.edu i.income i.imd i.home age32  ///
	i.PLE24_stem i.dep24 i.anx24 LoC16
	
* Marginal effects
margins lca // Predicted probability of outcome for each level of exposure
margins r.lca // Difference (marginal effect) of exposure on outcome


** Unadjusted
capture drop sample
gen sample = e(sample)

tab lca PLE32 if sample == 1, row

logistic PLE32 i.lca if sample == 1

* Marginal effects
margins lca // Predicted probability of outcome for each level of exposure
margins r.lca // Difference (marginal effect) of exposure on outcome


drop sample


** Save dataset for MI
save "PLIKS_RSBB_B4562_forMI.dta", replace



*********************************************************************************************
***** Multiple imputation of missing data

** Read in dataset ready for MI
use "PLIKS_RSBB_B4562_forMI.dta", clear


*** Explore missing data in full sample
missings report _all, percent

*** Reduce dataset down to just those with either religion or PLIKS data
gen for_mi = 0 
replace for_mi = 1 if PLE24_since12 != . | PLE32 != . | belief != . | identity != . | attend != . | lca!= .
tab for_mi

drop if for_mi == 0
drop for_mi

** Explore missingness again
missings report _all, percent


**** Multiple imputation process

* Drop PLE24 binary variables, as will re-create these post-imputation
drop PLE24_since12_susdef PLE24_since12_def


*** Set up imputations and register complete and missing variables
mi set mlong
mi register regular sex
mi register imputed PLE24_since12 PLE32 belief identity attend lca mat_age mat_home mat_marital mat_edu mat_imd mat_dep mat_anx mat_aces mat_belief mat_identity mat_attend ethnic relationship edu income imd home age28 age32 trauma11 trauma17 pat_dep pat_anx pat_aces pat_belief pat_identity pat_attend PLE24_stem MH10 dep24 anx24 LoC8 LoC16


** Test imputation with dry-run
mi impute chained ///
	(regress) mat_age age28 ///
	(pmm, knn(5)) mat_dep mat_anx mat_aces pat_dep pat_anx pat_aces age32 LoC8 LoC16 ///
	(logit) PLE32 identity attend mat_identity mat_attend mat_marital ethnic relationship trauma11 trauma17 pat_identity pat_attend PLE24_stem MH10 dep24 anx24 ///
	(mlogit) PLE24_since12 pat_belief belief lca mat_home mat_edu mat_belief edu home ///
	(ologit) mat_imd imd income ///
	= i.sex, ///
	add(50) burnin(10) rseed(9876) dryrun


** Now run the actual imputations. On a standard laptop, running 50 imputations with a burn-in period of 10 takes a couple of hours. Use 'dots' option to show progess, 'augment' to avoid perfect prediction of categorical variables (see White et al., 2010), and 'savetrace' to check convergence
mi impute chained ///
	(regress) mat_age age28 ///
	(pmm, knn(5)) mat_dep mat_anx mat_aces pat_dep pat_anx pat_aces age32 LoC8 LoC16 ///
	(logit) PLE32 identity attend mat_identity mat_attend mat_marital ethnic relationship trauma11 trauma17 pat_identity pat_attend PLE24_stem MH10 dep24 anx24 ///
	(mlogit) PLE24_since12 pat_belief belief lca mat_home mat_edu mat_belief edu home ///
	(ologit) mat_imd imd income ///
	= i.sex, ///
	add(50) burnin(10) rseed(9876) dots augment replace ///
	savetrace("./Results/imp_trace.dta", replace)
	

** Save this imputed dataset, so not have to run whole imputation again to access results
save "./Results/imputations_B4562.dta", replace



** Check convergence and that imputation chains are well-mixed
* Read in the trace dataset
use "./Results/imp_trace.dta", clear

sum 

* Save the mean value to add as a line in the plot - Do this for all outcomes and exposures
sum PLE24_since12_mean
local mean_PLE24_since12 = r(mean)
display `mean_PLE24_since12'

sum PLE32_mean
local mean_PLE32 = r(mean)
display `mean_PLE32'

sum belief_mean
local mean_belief = r(mean)
display `mean_belief'

sum identity_mean
local mean_identity = r(mean)
display `mean_identity'

sum attend_mean
local mean_attend = r(mean)
display `mean_attend'

sum lca_mean
local mean_lca = r(mean)
display `mean_lca'


* Convert the data from long to wide format (is necessary to create the plots)
reshape wide *mean *sd, i(iter) j(m)

* Set the iteration variable as the 'time' variable
tsset iter

* Make the plots - These all look relatively well-mixed and converged
tsline PLE24_since12_mean*, yline(`mean_PLE24_since12') legend(off) name(PLE24_since12, replace)
tsline PLE32_mean*, yline(`mean_PLE32') legend(off) name(PLE32, replace)
tsline belief_mean*, yline(`mean_belief') legend(off) name(belief, replace)
tsline identity_mean*, yline(`mean_identity') legend(off) name(identity, replace)
tsline attend_mean*, yline(`mean_attend') legend(off) name(attend, replace)
tsline lca_mean*, yline(`mean_lca') legend(off) name(lca, replace)

graph close _all


******************************************************************************
*** Now run the models on the imputed data and combine using Rubin's Rules
use "./Results/imputations_B4562.dta", clear


** Check descriptive stats of observed vs imputed data for exposures and outcomes
mi convert wide

* PLE at age 24 since age 12 (imputed data more likely to be 'suspected' or 'definite')
gen miss_PLE24 = 1
replace miss_PLE24 = 0 if PLE24_since12 < .
tab miss_PLE24, m

tab PLE24_since12
mi estimate: proportion PLE24_since12 if miss_PLE24 == 1

* PLE at age 32 (imputed data slightly more likely to be 'yes')
gen miss_PLE32 = 1
replace miss_PLE32 = 0 if PLE32 < .
tab miss_PLE32, m

tab PLE32
mi estimate: proportion PLE32 if miss_PLE32 == 1

* Religious belief at age 28 (imputed data slightly more likely to believe)
gen miss_belief = 1
replace miss_belief = 0 if belief < .
tab miss_belief, m

tab belief
mi estimate: proportion belief if miss_belief == 1

* Religious identity at age 28 (imputed data slightly more likely to be religious)
gen miss_identity = 1
replace miss_identity = 0 if identity < .
tab miss_identity, m

tab identity
mi estimate: proportion identity if miss_identity == 1

* Religious attendance at age 28 (imputed data slightly more likely to attend regularly)
gen miss_attend = 1
replace miss_attend = 0 if attend < .
tab miss_attend, m

tab attend
mi estimate: proportion attend if miss_attend == 1

* Religious LCA at age 28 (imputed data very similar to observed)
gen miss_lca = 1
replace miss_lca = 0 if lca < .
tab miss_lca, m

tab lca
mi estimate: proportion lca if miss_lca == 1


*********************************************************************
*** Re-set the data by reading in imputed data again and running analysis models, including marginal effects using user-written 'mimrgns' command
use "./Results/imputations_B4562.dta", clear


***** RQ1: PLIKS at 24 as exposure and religion at 28 as outcome

**** Definition of PLE as suspected or definite from age 12
recode PLE24_since12 (0 = 0) (1 2 = 1)
label values PLE24_since12 susdef_lb
rename PLE24_since12 PLE24_since12_susdef
tab PLE24_since12_susdef

*** Religious belief

** Adjusted
mi estimate, rrr: mlogit belief i.PLE24_since12_susdef mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8, baseoutcome(0)
	
* Marginal effects
mimrgns PLE24_since12_susdef, predict(outcome(0)) predict(outcome(1)) predict(outcome(2)) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_susdef, predict(outcome(0)) predict(outcome(1)) predict(outcome(2)) // Difference (marginal effect) of exposure for each level of outcome
	
	
** Unadjusted
mi estimate: proportion belief, over(PLE24_since12_susdef)

mi estimate, rrr: mlogit belief i.PLE24_since12_susdef, baseoutcome(0)

* Marginal effects
mimrgns PLE24_since12_susdef, predict(outcome(0)) predict(outcome(1)) predict(outcome(2)) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_susdef, predict(outcome(0)) predict(outcome(1)) predict(outcome(2)) // Difference (marginal effect) of exposure for each level of outcome



*** Religious identity

** Adjusted
mi estimate, or: logistic identity i.PLE24_since12_susdef mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8
	
* Marginal effects
mimrgns PLE24_since12_susdef, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_susdef, predict(pr) // Difference (marginal effect) of exposure on outcome
	
	
** Unadjusted
mi estimate: proportion identity, over(PLE24_since12_susdef)

mi estimate, or: logistic identity i.PLE24_since12_susdef

* Marginal effects
mimrgns PLE24_since12_susdef, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_susdef, predict(pr) // Difference (marginal effect) of exposure on outcome



*** Religious attendance

** Adjusted
mi estimate, or: logistic attend i.PLE24_since12_susdef mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8
	
* Marginal effects
mimrgns PLE24_since12_susdef, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_susdef, predict(pr) // Difference (marginal effect) of exposure on outcome
	
	
** Unadjusted
mi estimate: proportion attend, over(PLE24_since12_susdef)

mi estimate, or: logistic attend i.PLE24_since12_susdef

* Marginal effects
mimrgns PLE24_since12_susdef, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_susdef, predict(pr) // Difference (marginal effect) of exposure on outcome



*** Religious LCA

** Adjusted
mi estimate, rrr: mlogit lca i.PLE24_since12_susdef mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8, baseoutcome(1)
	
* Marginal effects
mimrgns PLE24_since12_susdef, predict(outcome(1)) predict(outcome(2)) predict(outcome(3))  predict(outcome(4)) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_susdef, predict(outcome(1)) predict(outcome(2)) predict(outcome(3))  predict(outcome(4)) // Difference (marginal effect) of exposure for each level of outcome
	
	
** Unadjusted
mi estimate: proportion lca, over(PLE24_since12_susdef)

mi estimate, rrr: mlogit lca i.PLE24_since12_susdef, baseoutcome(1)

* Marginal effects
mimrgns PLE24_since12_susdef, predict(outcome(1)) predict(outcome(2)) predict(outcome(3))  predict(outcome(4)) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_susdef, predict(outcome(1)) predict(outcome(2)) predict(outcome(3))  predict(outcome(4)) // Difference (marginal effect) of exposure for each level of outcome



*****************************************
***** Sensitivity analysis: Definition of PLE as definite from age 12

** Read in imputed dataset again
use "./Results/imputations_B4562.dta", clear

**** Definition of PLE as definite from age 12
recode PLE24_since12 (0 1 = 0) (2 = 1)
label values PLE24_since12 def_lb
rename PLE24_since12 PLE24_since12_def
tab PLE24_since12_def


*** Religious belief

** Adjusted
mi estimate, rrr: mlogit belief i.PLE24_since12_def mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8, baseoutcome(0)
	
* Marginal effects
mimrgns PLE24_since12_def, predict(outcome(0)) predict(outcome(1)) predict(outcome(2)) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_def, predict(outcome(0)) predict(outcome(1)) predict(outcome(2)) // Difference (marginal effect) of exposure for each level of outcome
	
	
** Unadjusted
mi estimate: proportion belief, over(PLE24_since12_def)

mi estimate, rrr: mlogit belief i.PLE24_since12_def, baseoutcome(0)

* Marginal effects
mimrgns PLE24_since12_def, predict(outcome(0)) predict(outcome(1)) predict(outcome(2)) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_def, predict(outcome(0)) predict(outcome(1)) predict(outcome(2)) // Difference (marginal effect) of exposure for each level of outcome



*** Religious identity

** Adjusted
mi estimate, or: logistic identity i.PLE24_since12_def mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8
	
* Marginal effects
mimrgns PLE24_since12_def, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_def, predict(pr) // Difference (marginal effect) of exposure on outcome
	
	
** Unadjusted
mi estimate: proportion identity, over(PLE24_since12_def)

mi estimate, or: logistic identity i.PLE24_since12_def

* Marginal effects
mimrgns PLE24_since12_def, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_def, predict(pr) // Difference (marginal effect) of exposure on outcome



*** Religious attendance

** Adjusted
mi estimate, or: logistic attend i.PLE24_since12_def mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8
	
* Marginal effects
mimrgns PLE24_since12_def, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_def, predict(pr) // Difference (marginal effect) of exposure on outcome
	
	
** Unadjusted
mi estimate: proportion attend, over(PLE24_since12_def)

mi estimate, or: logistic attend i.PLE24_since12_def

* Marginal effects
mimrgns PLE24_since12_def, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_def, predict(pr) // Difference (marginal effect) of exposure on outcome



*** Religious LCA

** Adjusted
mi estimate, rrr: mlogit lca i.PLE24_since12_def mat_age i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.sex i.ethnic i.trauma11 age28 i.MH10 LoC8, baseoutcome(1)
	
* Marginal effects
mimrgns PLE24_since12_def, predict(outcome(1)) predict(outcome(2)) predict(outcome(3))  predict(outcome(4)) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_def, predict(outcome(1)) predict(outcome(2)) predict(outcome(3))  predict(outcome(4)) // Difference (marginal effect) of exposure for each level of outcome
	
	
** Unadjusted
mi estimate: proportion lca, over(PLE24_since12_def)

mi estimate, rrr: mlogit lca i.PLE24_since12_def, baseoutcome(1)

* Marginal effects
mimrgns PLE24_since12_def, predict(outcome(1)) predict(outcome(2)) predict(outcome(3))  predict(outcome(4)) // Predicted probability of outcome for each level of exposure
mimrgns r.PLE24_since12_def, predict(outcome(1)) predict(outcome(2)) predict(outcome(3))  predict(outcome(4)) // Difference (marginal effect) of exposure for each level of outcome




***************************
***** RQ2: Religion at 28 as exposure and PLE at 32 as outcome

** Read in imputed dataset again
use "./Results/imputations_B4562.dta", clear


*** Religious belief exposure
mi estimate, or: logistic PLE32 i.belief i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.PLE24_stem i.sex i.ethnic i.trauma17 i.relationship i.edu i.income i.imd i.home age32 i.dep24 i.anx24 LoC16
	
* Marginal effects
mimrgns belief, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.belief, predict(pr) // Difference (marginal effect) of exposure on outcome


** Unadjusted
mi estimate: proportion PLE32, over(belief)

mi estimate, or: logistic PLE32 i.belief

* Marginal effects
mimrgns belief, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.belief, predict(pr) // Difference (marginal effect) of exposure on outcome


*** Religious identity exposure
mi estimate, or: logistic PLE32 i.identity i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.PLE24_stem i.sex i.ethnic i.trauma17 i.relationship i.edu i.income i.imd i.home age32 i.dep24 i.anx24 LoC16
	
* Marginal effects
mimrgns identity, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.identity, predict(pr) // Difference (marginal effect) of exposure on outcome


** Unadjusted
mi estimate: proportion PLE32, over(identity)

mi estimate, or: logistic PLE32 i.identity

* Marginal effects
mimrgns identity, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.identity, predict(pr) // Difference (marginal effect) of exposure on outcome


*** Religious attendance exposure
mi estimate, or: logistic PLE32 i.attend i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.PLE24_stem i.sex i.ethnic i.trauma17 i.relationship i.edu i.income i.imd i.home age32 i.dep24 i.anx24 LoC16
	
* Marginal effects
mimrgns attend, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.attend, predict(pr) // Difference (marginal effect) of exposure on outcome


** Unadjusted
mi estimate: proportion PLE32, over(attend)

mi estimate, or: logistic PLE32 i.attend

* Marginal effects
mimrgns attend, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.attend, predict(pr) // Difference (marginal effect) of exposure on outcome



*** Religious LCA exposure
mi estimate, or: logistic PLE32 i.lca i.mat_home i.mat_marital i.mat_edu i.mat_imd ///
	mat_dep mat_anx mat_aces i.mat_belief i.mat_identity i.mat_attend ///
	pat_dep pat_anx pat_aces i.pat_belief i.pat_identity i.pat_attend ///
	i.PLE24_stem i.sex i.ethnic i.trauma17 i.relationship i.edu i.income i.imd i.home age32 i.dep24 i.anx24 LoC16
	
* Marginal effects
mimrgns lca, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.lca, predict(pr) // Difference (marginal effect) of exposure on outcome


** Unadjusted
mi estimate: proportion PLE32, over(lca)

mi estimate, or: logistic PLE32 i.lca

* Marginal effects
mimrgns lca, predict(pr) // Predicted probability of outcome for each level of exposure
mimrgns r.lca, predict(pr) // Difference (marginal effect) of exposure on outcome



**********************************************************************************
**** E-value sensitivity analyses for unmeasured confounding (based on adjusted models and imputed results)


*** RQ1 - PLE exposure `any suspected/definite PLEs since age 12' 

** Outcome = Religious belief (reference = no)

* Not sure response (outcome common; >15%)
evalue or 1.29, lcl(0.98) ucl(1.70) common

* Yes response (outcome common; >15%)
evalue or 1.65, lcl(1.15) ucl(2.38) common


** Outcome = Religious identity (reference = None; outcome common; >15%)
evalue or 1.31, lcl(1.01) ucl(1.69) common


** Outcome = Religious attendance (reference = None; outcome rare; <15%)
evalue or 1.45, lcl(0.82) ucl(2.57)


** Outcome = Religious latent class (reference = "Atheist")

* "Agnostic" response (outcome common; >15%)
evalue or 1.04, lcl(0.75) ucl(1.42) common

* "Moderately religious" response (outcome rare; <15%)
evalue or 1.53, lcl(1.05) ucl(2.23)

* "Highly religious" response (outcome rare; <15%)
evalue or 2.08, lcl(1.28) ucl(3.36)



*** RQ1 - Sensitivity analysis - PLE exposure `any definite PLEs since age 12' 

** Outcome = Religious belief (reference = no)

* Not sure response (outcome common; >15%)
evalue or 1.74, lcl(1.23) ucl(2.46) common

* Yes response (outcome common; >15%)
evalue or 2.03, lcl(1.30) ucl(3.17) common


** Outcome = Religious identity (reference = None; outcome common; >15%)
evalue or 1.40, lcl(1.02) ucl(1.92) common


** Outcome = Religious attendance (reference = None; outcome rare; <15%)
evalue or 1.93, lcl(1.01) ucl(3.70)


** Outcome = Religious latent class (reference = "Atheist")

* "Agnostic" response (outcome common; >15%)
evalue or 1.42, lcl(0.98) ucl(2.05) common

* "Moderately religious" response (outcome rare; <15%)
evalue or 1.63, lcl(0.99) ucl(2.69)

* "Highly religious" response (outcome rare; <15%)
evalue or 2.45, lcl(1.39) ucl(4.33)



*** RQ2 - PLE outcome `any PLEs in past 6 months at age 32' (Outcome ~15%, so will be conservative and say outcome is common)

** Exposure = Religious belief (reference = no)

* Not sure response
evalue or 1.61, lcl(1.24) ucl(2.10) common

* Yes response
evalue or 1.63, lcl(1.19) ucl(2.23) common


** Exposure = Religious identity (reference = None)
evalue or 1.20, lcl(0.93) ucl(1.54) common


** Exposure = Religious attendance (reference = None)
evalue or 1.54, lcl(0.91) ucl(2.62) common


** Exposure = Religious latent class (reference = "Atheist")

* "Agnostic" response
evalue or 1.69, lcl(1.27) ucl(2.24) common

* "Moderately religious" response
evalue or 2.25, lcl(1.62) ucl(3.13) common

* "Highly religious" response
evalue or 1.37, lcl(0.86) ucl(2.18) common


log close

