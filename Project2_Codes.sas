/* WILLIAMS MT 31979742, ASSIGNMENT 3 */



libname assign3 "C:\Assign3";
run;

proc print data = assign3.retail_sales;
run;

*Question1;
*==========;



data assign3.retail_sales_dummy;
set assign3.retail_sales;

if region= "North" then region_north = 1;
else region_north = 0;
if region = "South" then region_south = 1;
else region_south = 0;
if region = "East" then region_east = 1;
else region_east = 0;

run;

proc print data = assign3.retail_sales_dummy;
run;


proc reg data = assign3.retail_sales_dummy;
model sales = Advertising Employees marketing Store_Area Parking region_north region_south region_east / vif collinoint;
run;

*Question2;
*==========;


/*
H0: Employees = 0 ( no effect)
Ha: Employess != 0 ( Signifiant effect)

Reject H0 if p < 0.05 , since p = <.0001 < 0.05 then reject null hypothesis.
Employees have a significant effect on sales.


The estimated coefficient for employees is 1.80, therefore it means for each additional employee,
sales are expected to increase by 1.80 units.


*/



*Question3;
*===========;
/*

The North region, it has a positive parameter coefficient of 3.08 and p-value is significant. Therefore,
the north have higher sales by 3.08 units on average compared to stores in the west region.


*/



*Question4;
*============;


proc reg data = assign3.retail_sales_dummy;
model sales = Advertising Employees marketing Store_Area Parking region_north region_south region_east / vif tol collinoint;
run;



*Question5;
*============;


proc reg data = assign3.retail_sales_dummy;
        model sales = Advertising Employees marketing Store_Area Parking region_north region_south region_east / influence;
        output out = assign3.retail2 rstudent = rstd covratio = covr;

run;


data assign3.retail_infl;
set assign3.retail2;
if abs(rstd) > 2 & abs(covr) > 3 * 9 / 155;
run;

data assign3.retail_Cleaned;
set assign3.retail2;
if abs(rstd) <= 2 & abs(covr) <= 3 * 9 / 155;
run;


/*


Store ID's that hold both these conditions are:

6, 29, 53,73,75,117,119,132.152

Obs ID Advertising Employees Marketing Store_Area Parking Sales Region region_north region_south region_east rstd covr
1 6 48 27 50 1573 47 198 South 0 1 0 -2.09483 0.85221
2 29 47 17 51 1751 61 203 North 1 0 0 2.03799 0.88027
3 53 56 28 64 1637 56 247 South 0 1 0 2.11694 0.85004
4 73 58 28 63 1876 61 258 North 1 0 0 2.23133 0.82301
5 75 47 26 54 1870 52 201 North 1 0 0 -2.72922 0.70123
6 117 58 23 63 2113 57 227 East 0 0 1 -2.34531 0.80132
7 119 41 28 45 1723 51 181 West 0 0 0 -2.64554 0.72860
8 132 65 22 70 2039 34 250 North 1 0 0 -2.44921 0.78491
9 152 69 28 77 2247 50 291 South 0 1 0 2.14580 0.86018

*/







*Question 6;
*==============;

proc reg data = assign3.retail_sales_dummy;
model sales = Advertising Employees marketing Store_Area Parking region_north region_south region_east / selection = forward SLE =0.01;
run;

/*  final best fitted model using forward selection


Sales
^
 =2.89021+2.179*5·Advertising+1.79786*Employees+0.77985*Marketing+0.00852*Store_Area+3.97287*region_north

*/



*Question 7;
*=============;

proc reg data = assign3.retail_sales_dummy;
        model sales = Advertising Employees marketing Store_Area Parking region_north region_south region_east;
        output out = assign3.resdata r = myres;

run;






ods select testsfornormality histogram qqplot;
proc univariate data=assign3.resdata normal;
        var myres;
        histogram /normal;
        qqplot /normal(mu=est sigma=est);
run;


/*Graphical method

Histogram shows that the residuals are normally distributed (bell - shaped).


QQ-plot of residuals shows that the residuals are normal.



*/

/*
Tests for Normality
Test Statistic p Value
Shapiro-Wilk W 0.993246 Pr < W 0.6855
Kolmogorov-Smirnov D 0.025951 Pr > D >0.1500
Cramer-von Mises W-Sq 0.011846 Pr > W-Sq >0.2500
Anderson-Darling A-Sq 0.128588 Pr > A-Sq >0.2500

*/


/*

H0: Residuals are normal
Ha: Residuals are not normal
p-value=0.6855

Therefore, Do not reject H0 (conclude residuals are normal)



*/





*Question8;
*=============;




proc reg data = assign3.retail_sales_dummy;
        model sales = Advertising Employees marketing Store_Area Parking region_north region_south region_east / spec;
        output out = assign3.resdata r = myres p= yhat;

run;


/*
Plots of residuals vs. predicted values tell me the errors are homoskedastic


/*
Test of First and Second Moment Specification
DF Chi-Square Pr > ChiSq
38 34.47 0.6333
*/

/*
H0: Errors are homoskedastic
Ha: Errors are heteroskedastic
p-value=0.6333, which is > 0.05
Therefore, Do not reject H0 (Assume homoskedasticity)
*/
