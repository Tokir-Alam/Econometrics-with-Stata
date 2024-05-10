/************************************

/////Simple Linear Regression///////

Outline:
1. Simple regression
2. Prediction after regression
3. Log forms: log-log and log-linear forms

***************************************/

* setup
clear all
set more off  

* Loading the dataset
use "H:/stata/Econometrics/datasets/CEOSAL1.dta"
desc

keep salary roe
list in 1/5

* correlation between salary and roe
corr salary roe

* Simple Regression - salary = f(roe)
reg salary roe

* plotting the observation with a fitted line
graph twoway (scatter salary roe) (lfit salary roe)

/*******************************************
////////Prediction after regression/////////
********************************************/

* load dataset
use "H:/stata/Econometrics/datasets/CEOSAL1.dta", clear

* run regression
reg salary roe

* Predicted value for the dependent variable (salaryhat)
predict salaryhat, xb
summarize salary salaryhat
graph twoway (scatter salary roe) (scatter salaryhat roe)

* Residuals 
predict uhat, residuals
summarize salary uhat
graph twoway (scatter salary roe) (scatter uhat roe)

list roe salary salaryhat uhat in 1/10

* (5) Graph Actual and Predicted Values and Residuals
graph twoway (scatter salary roe, msymbol(smcircle) mcolor(black)) ///
			 (scatter salaryhat roe, msymbol(smcircle) mcolor(yellow)) ///
			 (scatter uhat roe, msymbol(smcircle_hollow) mcolor(green)) ///
			 (lfit salary roe), ///
			 legend(order(1 "True value" 2 "Predicted value" 3 "Residual")) 
			 
			 
/**********************************************
//////Log-Models: Log-Log and Log-Linear///////
***********************************************/

* Log-Log Model
use "H:/stata/Econometrics/datasets/CEOSAL1.dta", clear

* generating logged variables
// gen lsalary = log(salary)
// gen lsales = log(sales)

* running log-log regression
reg lsalary lsales

* graph
graph twoway (scatter lsalary lsales) (lfit lsalary lsales)

* Log-linear model
reg lsalary sales

* Graph 
graph twoway (scatter lsalary sales) (lfit lsalary sales)

* Linear-log form
reg salary lsales
* Graph 
graph twoway (scatter salary lsales) (lfit salary lsales)
			 
			 
			 
			 
			 
