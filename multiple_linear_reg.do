/**************************************************


         **************************
		 Multiple Linear Regression
		 **************************

		 Outline:
			Multiple regression
			Goodness of fit (R-squared and adjusted R-squared)
			Perfect collinearity 
			Multicollinearity using VIF	
			Omitted variable bias
			Homoscedasticity and heteroscedasticity

***************************************************/

/**************************************************
/////////////////Multiple Regression///////////////
***************************************************/

* loading the dataset
use "H:/stata/Econometrics/datasets/wage1.dta"

list wage educ exper tenure in 1/10
summarize wage educ exper tenure

* multiple regressions
reg wage educ exper
reg wage educ exper tenure

/*Note:- As I include the variable 'tenure' in the model, 
the coeffieicent of exper becomes statistically insignificanr*/

* display the coefficients
display _b[educ]
display _b[exper]
display _b[tenure]

* predicted values and residuals
predict wagehat, xb
predict uhat, residual

summarize wage wagehat uhat
* wage = wagehat + uhat
* mean(uhat)=0 and mean(wage)=mean(wagehat)

*************************************************************************
/////////// Goodness of fit (R-squared and adjusted R-squared) //////////
*************************************************************************

* loading the dataset 
use "H:/stata/Econometrics/datasets/wage1.dta", clear

* simple regression
reg wage educ

* Display stored R-squared
display e(r2)

* Display stored adjusted R-squared
display e(r2_a)

* Run a multiple regression with 2 regressors
reg wage educ exper 
display e(r2)
display e(r2_a)

* Run a multiple regression with 3 regressors
reg wage educ exper tenure
display e(r2)
display e(r2_a)

* CEO Salary Example
use "H:/stata/Econometrics/datasets/CEOSAL1.dta", clear

list salary lsalary roe sales lsales in 1/5

*Linear form
reg salary roe sales

* Linear-log form
reg salary roe lsales 

* Log-linear form
reg lsalary roe sales 

* Log-log form
reg lsalary roe lsales

*Note: Log-Log model has highest adjusted r-squared

*************************************************************************
//////////////////////// Perfect collinearity ///////////////////////////
*************************************************************************

* Perfect collinearity is an exact linear relationship between the variables
* Perfect collinearity example is when male = 1-female

* Wage example
use "H:/stata/Econometrics/datasets/wage1.dta", clear

* Model for wage with female
reg wage educ female 

* Male is an exact linear function of female (perfect collinearity)
gen male=1-female

* Try to run regression with both female and male
reg wage educ female male
* This model cannot be estimated because of perfect collinearity
* Stata drops one variable, but it chooses which one to drop

* Run regression with "no constant" option
reg wage educ female male, nocons

*************************************************************************
//////////////Detecting Multicollinearity using VIF//////////////////////
*************************************************************************

* Multicollinearity is when regressors are highly correlated with each other.

* Test scores example
use "H:/stata/Econometrics/datasets/elemapi2.dta", clear

keep api00 avg_ed grad_sch col_grad
desc

* Multicollinearity: parents' average education is collinear with
* whether they completed grad school or college

* Correlation table
correlate avg_ed grad_sch col_grad 

* Run regression, find VIF. If VIF>10 then drop the variable
reg api00 avg_ed grad_sch col_grad
vif

* Run regression without variable that has high VIF
reg api00 grad_sch col_grad
vif

*************************************************************************
////////////////////// Omitted variable bias ////////////////////////////
*************************************************************************


* Omitted variable bias is when an omitted variable causes biased coefficients.

* Wage 2 example
use "H:/stata/Econometrics/datasets/HTV.dta",clear
keep wage educ abil
describe
list in 1/5

*True model with educ and ability 
* wage = beta0 + beta1*educ + beta2*abil + u
reg wage educ abil
gen beta1 = _b[educ]
gen beta2 = _b[abil]

* Model between ability and education
* abil = delta0 + delta1*educ + v
reg abil educ 
gen delta1 = _b[educ]

* Model where ability is omitted variable, so coefficient on educ is biased
* wage = (beta0+beta2*delta0) + (beta1+beta2*delta1)*educ +(beta2*v+u)
reg wage educ 
gen beta1_biased=_b[educ]
display beta1_biased

* Calculate bias and biased coefficient
gen bias = beta2*delta1
display bias

gen beta1_biased_calculated=beta1+beta2*delta1
display beta1_biased_calculated


*************************************************************************
//////////////////// Homoscedasticity and heteroscedasticity ///////////
*************************************************************************

* Homoscedasticy is when the variance of the error is constant for each x
* Heteroscedasticy is when the variance of the error is not constant for each x

* Wage example
use "H:/stata/Econometrics/datasets/wage1.dta", clear	

reg wage educ exper tenure

* Plotting residuals with "graph twoway scatter"
predict uhat, residual
graph twoway scatter uhat educ
graph twoway scatter uhat exper

* Ploting residuals with "rvpplot" (same graphs as above)
rvpplot educ, yline(0) 
rvpplot exper, yline(0) 
* Graphs show heteroscedasticity for educ and homoscedasticity for exper





































