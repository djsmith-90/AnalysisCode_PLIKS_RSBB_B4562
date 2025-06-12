## Git repository for 'Exploring potential bidirectional causality between psychotic experiences and religiosity 
## in a UK longitudinal cohort study (ALSPAC)' ALSPAC project (B4562)

The main directory in this repository contains four scripts for the actual analyses. These files are:
 - Script1_PLIKS_RSBB_B4562_DataCleaning.do - Stata script to clean and process the raw ALSPAC data
 - Script2_PLIKS_RSBB_B4562_SyntheticDataScript.R - R script to create synthetic datasets using the 'synthpop' package
 - Script3_PLIKS_RSBB_B4562_Analyses.do - Stata script to perform all analyses
 - Script4_PLIKS_RSBB_B4562_PlotsScript.R - R script to make nice plots of the results using 'ggplot2'
 
 
The 'SyntheticData' folder also contains synthetic versions of the ALSPAC dataset, created
using Script 2 above. As raw ALSPAC data cannot be released, these synthesised datasets are modelled on the original 
ALSPAC data, thus maintaining variable distributions and relations among variables (albeit not pefectly), while 
at the same time preserving participant anonymity and confidentiality. Please note that while these synthetic datasets 
can be used to follow the analysis scripts, as data are simulated they should *not* be used for research purposes; 
only the actual, observed, ALSPAC data should be used for formal research and analyses reported in published work.

These synthetic datasets have the file name 'syntheticData_B4562' and are available in R ('.RData'), Stata ('.dta') 
and CSV ('.csv') formats. A code book describing the data file is also in this folder ('PEsandReligion_codebook.xlsx')


Note that ALSPAC data access is through a system of managed open access. Information about access to ALSPAC data is 
given on the ALSPAC website (http://www.bristol.ac.uk/alspac/researchers/access/). The datasets used in these
scripts are linked to ALSPAC project number B4562; if you are interested in accessing these datasets, please quote 
this number during your application.
