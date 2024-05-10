/**************************************************************
   
	************************
	Regression Specification
	************************
   
Outline:
	RESET
	Proxy variables
	Measurement error in the dependent and independent variables
   
	
***************************************************************/

***********************************************
****************** RESET **********************
******Regression Specififcation Error Test*****
***********************************************

* RESET includes squares and cubes of the fitted values in 
* the regression model and tests for joint coefficient significance.


use "datasets/wage1.dta", clear

* Regression model of wage 
reg wage educ exper tenure
predict yhat, xb
gen yhatsq = yhat^2
gen yhatcube = yhat^3

* RESET, testing for joint significance of coefficients on yhatsq and yhatcube
reg wage educ exper tenure yhatsq yhatcube
* The null hypothesis is the model is well-specified 
test (yhatsq=0) (yhatcube=0) 
* p-value<0.05 so the model is misspecified.

* Regression model of log wage
reg lwage educ exper tenure
predict lyhat, xb
gen lyhatsq = lyhat^2
gen lyhatcube = lyhat^3
reg lwage educ exper tenure lyhatsq lyhatcube
test (lyhatsq=0) (lyhatcube=0)

* Generating squares of variables
gen educsq=educ^2
gen tenuresq=tenure^2

* Regression model of wage including square terms
reg wage educ exper tenure educsq expersq tenuresq
predict yhat1, xb
gen yhat1sq=yhat1^2
gen yhat1cube=yhat1^3
reg wage educ exper tenure educsq expersq tenuresq yhat1sq yhat1cube
test (yhat1sq=0) (yhat1cube=0)

* Regression model of lwage including square terms
reg lwage educ exper tenure educsq expersq tenuresq
predict lyhat1, xb
gen lyhat1sq=lyhat1^2
gen lyhat1cube=lyhat1^3
reg lwage educ exper tenure educsq expersq tenuresq lyhat1sq lyhat1cube 
test (lyhat1sq=0) (lyhat1cube=0) 
* This is a correctly specified model.





























