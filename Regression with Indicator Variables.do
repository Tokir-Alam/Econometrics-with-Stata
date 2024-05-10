/**************************************************************
   
	***********************************************************
	Regression with Indicator Variables
	***********************************************************
   
Outline:
	Single indicator variable
	Interaction terms with another indicator variable
	Several related indicator variables
	Interaction terms with a non-indicator variable
	F-test for differences across groups
	Chow test for differences across groups

***************************************************************/

clear all
set more off

**********************************
////Single Indicator Variable/////
**********************************

*loading wage data
use "datasets/wage1.dta", clear

summarize wage

*regression of wage on female
reg wage female

*graph of wage on female
graph twoway (scatter wage female) (lfit wage female)

* Summary statistics for groups of females and males
bysort female: summarize wage

* T-test for average wage for females and males
ttest wage, by(female)

*generate indicator variable for male
gen male = 1 - female

* Regression of wage on female and regression of wage on male
reg wage female
reg wage male
* The coefficient on male has the same magnitude and significance 
* but opposite sign from the coefficient on female.

* Regression with female and male cannot be estimated because of perfect collinearity
reg wage female male


* Regression with female and male can be estimated with no constant
reg wage female male, nocons

*************************************************************
***** Interaction terms with another indicator variable *****
*************************************************************

* generate indicator variable
gen single = 1 - married

* Categories: female*single, male*single, female*married, male*married
gen female_single = female *single
gen male_single = male*single
gen female_married = female*married
gen male_married = male*married

* List indicator variables and interaction terms for indicator variables
list male female single married female_single male_single female_married male_married in 1/10

* Regression with all four categories, Stata will drop one
reg wage female_single male_single female_married male_married

* Regression with male_single as reference category
reg wage female_single female_married male_married

* Marginal effect for female and single on wage
display _b[female_single]

* Marginal effect for female and married on wage
display _b[female_married] 

* Alternative categories: female, married, and femaleXmarried

* Generate interaction variable 
gen femaleXmarried=female*married

* Regression with interaction term
reg wage female married femaleXmarried

* Marginal effect for female and single on wage
display _b[female]

* Marginal effect for female and married on wage
display _b[female] + _b[married] + _b[femaleXmarried]

************************************************
****** Several related indicator variables *****
************************************************

* Regression with several related indicator variables needs to drop one as the reference category.

* Indicator variables for region (northcentral, south, and west)
gen east = 1 - northcen - south - west
summarize northcen south west east

* Regression with east as the reference category
reg wage northcen south west

* Regression with west as the reference category
reg wage northcen south east


************************************************************
****** Interaction terms with a non-indicator variable *****
************************************************************

* Regression of wage on educ 
* Model with same intercept and slope for females and males
reg wage educ
graph twoway (scatter wage educ) (lfit wage educ) 

* Regression of wage on educ and female
* Model with same slope but different intercepts for females and males
reg wage educ female
predict wagehat, xb

* Graph of wage on education, same slope and different intercepts for females and males
graph twoway (scatter wage educ) (lfit wagehat educ if female==1) (lfit wagehat educ if female==0)

* Regression of wage on educ for females
reg wage educ if female==1

* Regression of wage on education for males
reg wage educ if female==0

* Graph of wage on education, different slopes and intercepts for females and males
graph twoway (scatter wage educ) (lfit wage educ if female==1) (lfit wage educ if female==0)

* Generate an interaction term between female and education
gen femaleXeduc = female*educ

* Regression of wage on educ, female, and female*educ
* Model with different intercepts and slopes for females and males
reg wage educ female femaleXeduc

* Intercepts and slopes for males and females
display "intercept for males is " _b[_cons]
display "intercept for females is " _b[_cons] + _b[female]
display "marginal effect of education on wage for males is " _b[educ] 
display "marginal effect of education on wage for females is " _b[educ] + _b[femaleXeduc]









