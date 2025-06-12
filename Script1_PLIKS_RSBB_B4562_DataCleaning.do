*** PROJECT: Exploring the association between psychotic experiences and religious beliefs and behaviours (B4562)
*** STATA VERSION 18
*** Script 1: Cleaning and processing datasets
*** Created 31/01/2025 by Dan Major-Smith (based on script by Grace Obo)

* Change working directory
cd "X:\Studies\RSBB Team\Dan\B4562 - PLIKS and RSBB"

** Create log file
capture log close
log using ".\Results\PLEandReligion_cleaning.log", replace

* Open dataset with the raw data
use "PLIKS_RSBB_B4562.dta", clear

* Add labels to variables
numlabel, add

* Remove if not alive at 1 year of age or if withdrew consent
tab1 kz011b YPG1052 pb150
tab1 kz011b YPG1052 pb150, m
drop if kz011b == 2
drop if kz011b == .a
drop if YPG1052 == .b
drop if pb150 == .c


**** Go through each variable and process for analysis

*** Psychotic(-like) experience (PLE)

** At age 24 (any PLE since age 12)
tab FKPL2120
tab FKPL2120, m

replace FKPL2120 = . if FKPL2120 < 0
rename FKPL2120 PLE24_since12
tab PLE24_since12
tab PLE24_since12, m

* Combining suspected and definite
recode PLE24_since12 (0 = 0) (1 2 = 1), gen(PLE24_since12_susdef)
label variable PLE24_since12_susdef "PLIKS since age 12 (sus/def)"
label define susdef_lb 0 "None" 1 "Sus/Def"
numlabel susdef_lb, add
label values PLE24_since12_susdef susdef_lb
tab PLE24_since12_susdef
tab PLE24_since12_susdef, m

* Just definite 
recode PLE24_since12 (0 1 = 0) (2 = 1), gen(PLE24_since12_def)
label variable PLE24_since12_def "PLIKS since age 12 (def)"
label define def_lb 0 "None/Sus" 1 "Def"
numlabel def_lb, add
label values PLE24_since12_def def_lb
tab PLE24_since12_def
tab PLE24_since12_def, m


*** At age 32

** F1 - Hearing voices
tab f1
tab f1, m

tab f1a
tab f1a, m

tab f1 f1a
tab f1 f1a, m

* Creating and recoding new variable
gen voices32 = .
replace voices32 = 0 if (f1 == 0 & f1a == .) | (f1 == 0 & f1a == 0) | (f1 == 1 & f1a == 0) | (f1 == 2 & f1a == 0)
replace voices32 = 1 if (f1 == 1 & f1a >= 1 & f1a <.) | (f1 == 2 & f1a >= 1 & f1a <.)

tab voices32
tab voices32, m

tab voices32 f1
tab voices32 f1a

* Meta-data
label define ple32_lb 0 "Never/not in past year" 1 "Ever in past year"
numlabel ple32_lb, add
label values voices32 ple32_lb
label variable voices32 "Hearing voices that others couldn't hear (age 32)"
tab voices32
tab voices32, m


** F2 - Seeing things
tab f2
tab f2, m

tab f2a
tab f2a, m

tab f2 f2a
tab f2 f2a, m

* Creating and recoding new variable
gen seeing32 = .
replace seeing32 = 0 if (f2 == 0 & f2a == .) | (f2 == 0 & f2a == 0) | (f2 == 1 & f2a == 0) | (f2 == 2 & f2a == 0)
replace seeing32 = 1 if (f2 == 1 & f2a >= 1 & f2a <.) | (f2 == 2 & f2a >= 1 & f2a <.)

tab seeing32
tab seeing32, m

tab seeing32 f2
tab seeing32 f2a

* Meta-data
label values seeing32 ple32_lb
label variable seeing32 "Seeing things others couldn't see (age 32)"
tab seeing32
tab seeing32, m


** F3 - Followed/Spied on
tab f3
tab f3, m

tab f3a
tab f3a, m

tab f3 f3a
tab f3 f3a, m

* Creating and recoding new variable
gen spied32 = .
replace spied32 = 0 if (f3 == 0 & f3a == .) | (f3 == 0 & f3a == 0) | (f3 == 1 & f3a == 0) | (f3 == 2 & f3a == 0)
replace spied32 = 1 if (f3 == 1 & f3a >= 1 & f3a <.) | (f3 == 2 & f3a >= 1 & f3a <.)

tab spied32
tab spied32, m

tab spied32 f3
tab spied32 f3a

* Meta-data
label values spied32 ple32_lb
label variable spied32 "Followed or spied on (age 32)"
tab spied32
tab spied32, m


** F4 - Plot to be harmed
tab f4
tab f4, m

tab f4a
tab f4a, m

tab f4 f4a
tab f4 f4a, m

* Creating and recoding new variable
gen harm32 = .
replace harm32 = 0 if (f4 == 0 & f4a == .) | (f4 == 0 & f4a == 0) | (f4 == 1 & f4a == 0) | (f4 == 2 & f4a == 0)
replace harm32 = 1 if (f4 == 1 & f4a >= 1 & f4a <.) | (f4 == 2 & f4a >= 1 & f4a <.)

tab harm32
tab harm32, m

tab harm32 f4
tab harm32 f4a

* Meta-data
label values harm32 ple32_lb
label variable harm32 "Followed as plot to be harmed (age 32)"
tab harm32
tab harm32, m


** F5 - Thoughts read
tab f5
tab f5, m

tab f5a
tab f5a, m

tab f5 f5a
tab f5 f5a, m

* Creating and recoding new variable
gen thoughts32 = .
replace thoughts32 = 0 if (f5 == 0 & f5a == .) | (f5 == 0 & f5a == 0) | (f5 == 1 & f5a == 0) | (f5 == 2 & f5a == 0)
replace thoughts32 = 1 if (f5 == 1 & f5a >= 1 & f5a <.) | (f5 == 2 & f5a >= 1 & f5a <.)

tab thoughts32
tab thoughts32, m

tab thoughts32 f5
tab thoughts32 f5a

* Meta-data
label values thoughts32 ple32_lb
label variable thoughts32 "Thoughts read by others (age 32)"
tab thoughts32
tab thoughts32, m


** F6 - Sent messages
tab f6
tab f6, m

tab f6a
tab f6a, m

tab f6 f6a
tab f6 f6a, m

* Creating and recoding new variable
gen messages32 = .
replace messages32 = 0 if (f6 == 0 & f6a == .) | (f6 == 0 & f6a == 0) | (f6 == 1 & f6a == 0) | (f6 == 2 & f6a == 0)
replace messages32 = 1 if (f6 == 1 & f6a >= 1 & f6a <.) | (f6 == 2 & f6a >= 1 & f6a <.)

tab messages32
tab messages32, m

tab messages32 f6
tab messages32 f6a

* Meta-data
label values messages32 ple32_lb
label variable messages32 "Sent messages through TV or radio (age 32)"
tab messages32
tab messages32, m


** F7 - Under control by special power
tab f7
tab f7, m

tab f7a
tab f7a, m

tab f7 f7a
tab f7 f7a, m

* Creating and recoding new variable
gen power32 = .
replace power32 = 0 if (f7 == 0 & f7a == .) | (f7 == 0 & f7a == 0) | (f7 == 1 & f7a == 0) | (f7 == 2 & f7a == 0)
replace power32 = 1 if (f7 == 1 & f7a >= 1 & f7a <.) | (f7 == 2 & f7a >= 1 & f7a <.)

tab power32
tab power32, m

tab power32 f7
tab power32 f7a

* Meta-data
label values power32 ple32_lb
label variable power32 "Felt under control of special power (age 32)"
tab power32
tab power32, m


** F8 - Delusions of grandeur
tab f8
tab f8, m

tab f8a
tab f8a, m

tab f8 f8a
tab f8 f8a, m

* Creating and recoding new variable
gen grandeur32 = .
replace grandeur32 = 0 if (f8 == 0 & f8a == .) | (f8 == 0 & f8a == 0) | (f8 == 1 & f8a == 0) | (f8 == 2 & f8a == 0)
replace grandeur32 = 1 if (f8 == 1 & f8a >= 1 & f8a <.) | (f8 == 2 & f8a >= 1 & f8a <.)

tab grandeur32
tab grandeur32, m

tab grandeur32 f1
tab grandeur32 f1a

* Meta-data
label values grandeur32 ple32_lb
label variable grandeur32 "Delusions of grandeur (age 32)"
tab grandeur32
tab grandeur32, m


* Generating a new variable as '1' if positive to any of the 8 PLIKS questions
gen PLE32 = 0
replace PLE32 = 1 if voices32 == 1 | seeing32 == 1 | spied32 == 1 | harm32 == 1 | thoughts32 == 1 | messages32 == 1 | power32 == 1 | grandeur32 == 1
replace PLE32 = . if voices32 == . & seeing32 == . & spied32 == . & harm32 == . & thoughts32 == . & messages32 == . & power32 == . & grandeur32 == .

label define yn_lb 0 "No" 1 "Yes"
numlabel yn_lb, add
label values PLE32 yn_lb
label variable PLE32 "PLIKS at 32 years"

tab PLE32
tab PLE32, m


*** Religion variables (age 28)

** Belief in God
tab YPG3000
tab YPG3000, m

replace YPG3000 = . if YPG3000 < 0

rename YPG3000 belief
recode belief (0 = 0) (1 = 2) (2 = 1)
label define belief_lb 0 "No" 1 "Not sure" 2 "Yes"
numlabel belief_lb, add
label values belief belief_lb

tab belief
tab belief, m


** Religious identity
tab YPG3040
tab YPG3040, m

replace YPG3040 = . if YPG3040 < 0

rename YPG3040 identity
recode identity (13 = 0) (nonmissing = 1)
label define identity_lb 0 "Non-religious" 1 "Religious"
numlabel identity_lb, add
label values identity identity_lb

tab identity
tab identity, m


** Religious attendance
tab YPG3080
tab YPG3080, m

replace YPG3080 = . if YPG3080 < 0

rename YPG3080 attend
recode attend (0 3 4 = 0) (1 2 = 1)
label define attend_lb 0 "Never/Occasionally" 1 "Regular"
numlabel attend_lb, add
label values attend attend_lb

tab attend
tab attend, m


** Religious latent classes
tab CLASS
tab CLASS, m

gen lca = .
replace lca = 1 if CLASS == "Atheist"
replace lca = 2 if CLASS == "Agnostic"
replace lca = 3 if CLASS == "Moderately religious"
replace lca = 4 if CLASS == "Highly religious"

label variable lca "Latent religiosity classes"
label define lca_yp_lb 1 "Atheist" 2 "Agnostic" 3 "Moderately religious" 4 "Highly religious"
numlabel lca_yp_lb, add
label values lca lca_yp_lb

tab lca
tab lca, m


*** Confounder variables

** Offspring sex assigned at birth
tab kz021

rename kz021 sex

* Recode sex from 1/2 to 0/1
tab sex
recode sex (1 = 0) (2 = 1)
label define sex_lb 0 "Male" 1 "Female"
numlabel sex_lb, add
label values sex sex_lb
tab sex


** Maternal age at birth
tab mz028b

replace mz028b = . if mz028b < 0

rename mz028b mat_age
sum mat_age


** Maternal home ownership status
tab a006

replace a006 = . if a006 < 0

rename a006 mat_home
recode mat_home (0 1 = 0) (2 5 = 1) (3 4 = 2) (6 = 3)
label define home_lb 0 "Owned/Mortgaged" 1 "Council/HA" 2 "Rented" 3 "Other"
numlabel home_lb, add
label values mat_home home_lb
tab mat_home
tab mat_home, m


** Maternal marital status
tab a525

replace a525 = . if a525 < 0

rename a525 mat_marital
recode mat_marital (5 6 = 1) (1 = 0) (2 3 4  = 0)
label define marital_lb 0 "Not married" 1 "Married"
numlabel marital_lb, add
label values mat_marital marital_lb
tab mat_marital
tab mat_marital, m


** Maternal education
tab c645a

replace c645a = . if c645a < 0

rename c645a mat_edu
tab mat_edu
tab mat_edu, m


** Maternal IMD
tab jan1993imd2010q5_M

replace jan1993imd2010q5_M = . if jan1993imd2010q5_M < 0

rename jan1993imd2010q5_M mat_imd
tab mat_imd
tab mat_imd, m


** Child ethnic background
tab c804

replace c804 = . if c804 < 0

rename c804 ethnic
recode ethnic (1 = 0) (2 = 1)
label define ethnic_lb 0 "White" 1 "Other than White"
numlabel ethnic_lb, add
label values ethnic ethnic_lb
tab ethnic
tab ethnic, m


** Maternal depressive symptoms in pregnancy
tab b370

replace b370 = . if b370 < 0

rename b370 mat_dep
sum mat_dep


** Maternal anxiety symptoms in pregnancy
tab b351

replace b351 = . if b351 < 0

rename b351 mat_anx
sum mat_anx


** Maternal schizophrenia
tab d169

replace d169 = . if d169 < 0

rename d169 mat_schizo
recode mat_schizo (3 = 0) (1 2 = 1)
label values mat_schizo yn_lb
tab mat_schizo
tab mat_schizo, m

* Drop this variable, as so few cases will cause more issues than help
drop mat_schizo


** Paternal depressive symptoms in pregnancy
tab pb260

replace pb260 = . if pb260 < 0

rename pb260 pat_dep
sum pat_dep


** Paternal anxiety symptoms in pregnancy
tab pb233

replace pb233 = . if pb233 < 0

rename pb233 pat_anx
sum pat_anx


** Maternal ACEs score
tab c433

replace c433 = . if c433 < 0

rename c433 mat_aces
tab mat_aces
tab mat_aces, m


** Paternal ACEs score
tab pb482

replace pb482 = . if pb482 < 0

rename pb482 pat_aces
tab pat_aces
tab pat_aces, m


** Maternal religious belief
tab d810

replace d810 = . if d810 < 0

rename d810 mat_belief
tab mat_belief
tab mat_belief, m


** Maternal religious identity
tab d813

replace d813 = . if d813 < 0

rename d813 mat_identity
recode mat_identity (0 = 0) (1 / 13 = 1)
label values mat_identity identity_lb
tab mat_identity
tab mat_identity, m


** Maternal religious attendance
tab d816

replace d816 = . if d816 < 0

rename d816 mat_attend
recode mat_attend (1 = 0) (2 = 1) (3 = 2) (4 = 3)
label define mat_attend_lb 0 "Min 1/week" 1 "Min 1/month" 2 "Min 1/year" 3 "Not at all"
numlabel mat_attend_lb, add
label values mat_attend mat_attend_lb
tab mat_attend
tab mat_attend, m


** Paternal religious belief
tab pb150

replace pb150 = . if pb150 < 0

rename pb150 pat_belief
tab pat_belief
tab pat_belief, m


** Paternal religious identity
tab pb153

replace pb153 = . if pb153 < 0

rename pb153 pat_identity
recode pat_identity (0 = 0) (1 / 13 = 1)
label values pat_identity identity_lb
tab pat_identity
tab pat_identity, m


** Paternal religious attendance
tab pb155

replace pb155 = . if pb155 < 0

rename pb155 pat_attend
recode pat_attend (1 = 0) (2 = 1) (3 = 2) (4 = 3)
label values pat_attend mat_attend_lb
tab pat_attend
tab pat_attend, m


** Offspring relationship status
tab YPG1052

replace YPG1052 = . if YPG1052 < 0

rename YPG1052 relationship
tab relationship
tab relationship, m


** Highest offspring education
tab YPF7970

replace YPF7970 = . if YPF7970 < 0

rename YPF7970 edu
recode edu (1 2  = 0) (3 4 5 = 1) (6 = 2) (7 8 = 3)
label define edu_lb 0 "GCSE" 1 "A level/Vocational" 2 "Degree" 3 "Post-grad"
numlabel edu_lb, add
label values edu edu_lb
tab edu 
tab edu, m


** Offspring income
tab YPE6020

replace YPE6020 = . if YPE6020 < 0

rename YPE6020 income
recode income (0 1 2 = 0) (3 = 1) (4 = 2) (5 6 7 = 3)
label define income_lb 0 "£0-£999" 1 "£1000-£1499" 2 "£1500-£1999" 3 "£2000+"
numlabel income_lb, add
label value income income_lb
tab income
tab income, m


** Offspring IMD
tab jan2021imd2015q5_YP

replace jan2021imd2015q5_YP = . if jan2021imd2015q5_YP < 0

rename jan2021imd2015q5_YP imd
tab imd
tab imd, m


** Offspring home ownership status
tab YPG1060

replace YPG1060 = . if YPG1060 < 0

rename YPG1060 home
recode home (1 2 = 0) (3 = 1) (4 = 2) (5 = 3)
label values home home_lb
tab home
tab home, m


** Offspring age at age 28 questionnaire (religion questions)
sum YPG8000

replace YPG8000 = . if YPG8000 < 0

rename YPG8000 age28
replace age28 = age28 / 12
sum age28


** Offspring age at age 32 questionnaire (PLIKS quest)
tab age32


** Any traumas/ACEs age 0 - 11
tab1 clon145 clon152

replace clon145 = . if clon145 < 0
replace clon152 = . if clon152 < 0

tab clon145 clon152, m

gen trauma11 = 0
replace trauma11 = 1 if clon145 == 1 | clon152 == 1
replace trauma11 = . if clon145 == . | clon152 == .

label variable trauma11 "Trauma/ACEs ages 0-11"
label values trauma11 yn_lb
tab trauma11
tab trauma11, m


** Any trauma to age 17
tab clon166

replace clon166 = . if clon166 < 0

rename clon166 trauma17
tab trauma17
tab trauma17, m


** Prior self-reported PLEs at age 24 (same Qs as at age 32)
tab1 FKPL1300-FKPL1725
tab1 FKPL1300-FKPL1725, m

* Remove missing/refused/DK values, and recode as binary variables (yes/maybe vs no)
foreach var of varlist FKPL1300-FKPL1725 {
	replace `var' = . if `var' < 0 | `var' == 8 | `var' == 9
	recode `var' (1 = 0) (2 3 = 1), gen(`var'_bin)
	tab1 `var' `var'_bin, m
}

* Generating a new variable as '1' if positive to any of the 8 stem PLIKS questions
gen PLE24_stem = 0
replace PLE24_stem = 1 if FKPL1300_bin == 1 | FKPL1600_bin == 1 | FKPL1700_bin == 1 | FKPL1705_bin == 1 | FKPL1710_bin == 1 | FKPL1715_bin == 1 | FKPL1720_bin == 1 | FKPL1725_bin == 1
replace PLE24_stem = . if FKPL1300_bin == . & FKPL1600_bin == . & FKPL1700_bin == . & FKPL1705_bin == . & FKPL1710_bin == . & FKPL1715_bin == . & FKPL1720_bin == . & FKPL1725_bin == .

label values PLE24_stem yn_lb
label variable PLE24_stem "Self-reported PLIKS at 24 years"

tab PLE24_stem
tab PLE24_stem, m


** Mental health (emotional disorder) at age 10 (DAWBA)
tab kv8616

replace kv8616 = . if kv8616 < 0

rename kv8616 MH10
tab MH10
tab MH10, m


** Mental health/  (depression and anxiety) at age 24 (CIS-R)
tab1 FKDQ1000 FKDQ1030

replace FKDQ1000 = . if FKDQ1000 < 0
replace FKDQ1030 = . if FKDQ1030 < 0

rename FKDQ1000 dep24
rename FKDQ1030 anx24
tab1 dep24 anx24
tab1 dep24 anx24, m


** Locus of control at age 8
tab f8lc125

replace f8lc125 = . if f8lc125 < 0

rename f8lc125 LoC8
tab LoC8
tab LoC8, m


** Locus of control at age 16 (need to construct this variable first)
tab1 ccs3000-ccs3012, m

foreach var of varlist ccs3000-ccs3011 {
	replace `var' = . if `var' < 0
	
	if "`var'" != "ccs3011" {
		recode `var' (1 = 1) (2 = 0), gen(`var'_loc)
		tab1 `var' `var'_loc, m
	}
	
	if "`var'" == "ccs3011" {
		recode `var' (1 = 0) (2 = 1), gen(`var'_loc)
		tab1 `var' `var'_loc, m
	}
	
}

egen LoC16 = rowtotal(ccs3000_loc-ccs3011_loc), missing
egen LoC16_miss = rowmiss(ccs3000_loc-ccs3011_loc)

tab1 LoC16 LoC16_miss, m

replace LoC16 = . if LoC16_miss > 0

tab1 LoC16 LoC16_miss, m

sum LoC16
sum LoC16, d



*** Keep just relevant variables and re-order
keep sex-mat_attend pat_belief-pat_attend relationship edu income-age32 LoC8 MH10 dep24 anx24 trauma17 PLE24_since12 belief-attend PLE24_since12_susdef PLE24_since12_def PLE32 lca trauma11 PLE24_stem LoC16

order PLE24_since12 PLE24_since12_susdef PLE24_since12_def PLE32 ///
	belief identity attend lca ///
	mat_age-mat_imd mat_dep mat_anx mat_aces mat_belief mat_identity mat_attend ///
	pat_dep pat_anx pat_aces pat_belief pat_identity pat_attend ///
	sex ethnic relationship edu income imd home age28 age32 trauma11 trauma17 ///
	PLE24_stem MH10 dep24 anx24 LoC8 LoC16



*** Save this processed dataset and create synthetic dataset
save "PLIKS_RSBB_B4562_Processed.dta", replace

log close

