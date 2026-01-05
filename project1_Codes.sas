/*Williams Marvin, 31979742
Assignment 1 STTN317*/



*Question1.1;
*==============;

libname ASSIGN1 "C:\ASSIGN1";
run;

*Question1.2;
*==============;

data ASSIGN1.sales_data;
infile "C:\ASSIGN1\sales_data.txt" DLM = "09"x Firstobs = 2;
input Sales_ID Product_ID $ Region_Code $ Category_ID $ Total_Sales Discount;
run;
Question 1.3

proc import out = ASSIGN1.product_data
            datafile = "C:\ASSIGN1\product_data.xlsx"
            DBMS = XLSX;
      Sheet = "Sheet2";
      Getnames = yes;
run;

*Question1.4;
*==============;

data ASSIGN1.sales_copy;
set ASSIGN1.sales_data;

format Region_Name $8.;
      if Region_Code = 1 then region_name = "North";
      else if Region_Code = 2 then region_name = "South";
      else region_name = "West";

Drop region_code;
run;

data ASSIGN1.sales_copy;
set ASSIGN1.sales_data;

format Discount_Category $10.;
            if Discount < 5 then Discount_Category = "Minimal";
            else if 5 <= Discount <= 15 then Discount_Category = "Moderate";
            else if Discount > 15 then Discount_Category = "High";
run;

*Question1.5;
*==============;


proc sql;
create table Work.low_disc as
select *
from ASSIGN1.sales_data
where Category_ID ^= "A" AND Discount <= 20;
quit;







*Question 2.1;
*==============;

data Q1_1;
      n=20; p=0.2; kmax = 5;
      prob = CDF ("Binomial",kmax,p,n);
      output;

run;

proc print data = Q1_1;
run;

*Question2.2;
*==============;

data Q2_2;
      muuu = 10.45;
      probQ2 = QUANTILE("Exponential",0.8,1/muuu);
      output;
run;

proc print data = Q2_2;
run;

*Question3;
*==============;

proc sql;
create table ASSIGN1.sales_prod as
select p.sales_id, s.discount_category, s.region_name, p.price
from ASSIGN1.product_data as p left join ASSIGN1.sales_copy as s
on p.sales_id = s.sales_id;

quit;

*Question4.1;
*==============;

data ASSIGN1.supplier_data;
set ASSIGN1.supplier;
ODS printer file = "C:\ASSIGN1\supplier_report.pdf";
ODS Output report = ASSIGN1.supplier_report;
ODS select report;
proc means data = ASSIGN1.supplier_data N MEAN MEDIAN STD RANGE CLM ALPHA = 0.01 MAXDEC = 2;
            var price;

            output out = ASSIGN1.supplier_report
                  MEAN = mean_price
                  MEDIAN = median_price
                  MODE = mode_price
                  STD = std_dev
                  RANGE = price_range
                  LCLM = lower_CI
                  UCLM = upper_CI;
run;

ODS select all;
ods printer close;



*Question 4.2;
*==============;

proc sql;
create table ASSIGN1.supplier_report2 as
select max(mean_price) as highest_mean, max(median_price) as highest_median, max(mode_price) as highest_mode
from ASSIGN1.supplier_report;

quit;

proc print data = ASSIGN1.supplier_report2(obs=1);
run;

*Question4.3;
*==============;

/*Judging from the values on the supplier_report2 table, the maximum or highest values of the mean,median and mode are almost equal , or
there is not a great difference between their values,
therefore the distribution is symmetric because the data of these three measures is evenly distributed around the central point.*/

*Question5;

Proc sort data = work.supplier_data out = supplier2
      By supplier;
Run;

*Question6;
*==============;

ODS SELECT HISTOGRAM;
PROC UNIVARIATE DATA=SortedSupplier NORMAL mu0=140;
        BY Supplier;
        VAR Price;
        HISTOGRAM Price / NORMAL KERNEL;
        PROBPLOT Price / NORMAL(MU=EST SIGMA=EST);
RUN;

ODS _ALL_ CLOSE;





*Question7;
*==============;

Data work.supplier3;
Input supplier shapiro_wilk p_value decision $ conclusion $50.;
Datalines;

1 0.977638 0.0869 No_Reject Price_normally_distributed
2 0.993705 0.9267 No_Reject Price_normally_distributed
3 0.961189 0.0049 Reject Price_not_normally_distributed
;
run;









*Question8;
*==============;

data ASSIGN1.supplier3;
    set ASSIGN1.supplier;
    price = price - 140;
run;


proc means data=ASSIGN1.supplier3 clm alpha=0.05 mean stderr t prt;
    var price;
    output out=MeansOutput mean=Mean stderr=StdErr lclm=LowerCLM uclm=UpperCLM t=tValue probt=pValue;
run;

proc print data=MeansOutput;
run;

*/H0 : Mean = 0
 HA :Mean != 0
 Reject H0 if p < 0.05
P > .0001 ,so we do not reject H0
so mean != 0
*/ ;

/*Williams Marvin, 31979742
Assignment 1 STTN317*/



*Question1.1;
*==============;

libname ASSIGN1 "C:\ASSIGN1";
run;

*Question1.2;
*==============;

data ASSIGN1.sales_data;
infile "C:\ASSIGN1\sales_data.txt" DLM = "09"x Firstobs = 2;
input Sales_ID Product_ID $ Region_Code $ Category_ID $ Total_Sales Discount;
run;
Question 1.3

proc import out = ASSIGN1.product_data
            datafile = "C:\ASSIGN1\product_data.xlsx"
            DBMS = XLSX;
      Sheet = "Sheet2";
      Getnames = yes;
run;

*Question1.4;
*==============;

data ASSIGN1.sales_copy;
set ASSIGN1.sales_data;

format Region_Name $8.;
      if Region_Code = 1 then region_name = "North";
      else if Region_Code = 2 then region_name = "South";
      else region_name = "West";

Drop region_code;
run;

data ASSIGN1.sales_copy;
set ASSIGN1.sales_data;

format Discount_Category $10.;
            if Discount < 5 then Discount_Category = "Minimal";
            else if 5 <= Discount <= 15 then Discount_Category = "Moderate";
            else if Discount > 15 then Discount_Category = "High";
run;

*Question1.5;
*==============;


proc sql;
create table Work.low_disc as
select *
from ASSIGN1.sales_data
where Category_ID ^= "A" AND Discount <= 20;
quit;







*Question 2.1;
*==============;

data Q1_1;
      n=20; p=0.2; kmax = 5;
      prob = CDF ("Binomial",kmax,p,n);
      output;

run;

proc print data = Q1_1;
run;

*Question2.2;
*==============;

data Q2_2;
      muuu = 10.45;
      probQ2 = QUANTILE("Exponential",0.8,1/muuu);
      output;
run;

proc print data = Q2_2;
run;

*Question3;
*==============;

proc sql;
create table ASSIGN1.sales_prod as
select p.sales_id, s.discount_category, s.region_name, p.price
from ASSIGN1.product_data as p left join ASSIGN1.sales_copy as s
on p.sales_id = s.sales_id;

quit;

*Question4.1;
*==============;

data ASSIGN1.supplier_data;
set ASSIGN1.supplier;
ODS printer file = "C:\ASSIGN1\supplier_report.pdf";
ODS Output report = ASSIGN1.supplier_report;
ODS select report;
proc means data = ASSIGN1.supplier_data N MEAN MEDIAN STD RANGE CLM ALPHA = 0.01 MAXDEC = 2;
            var price;

            output out = ASSIGN1.supplier_report
                  MEAN = mean_price
                  MEDIAN = median_price
                  MODE = mode_price
                  STD = std_dev
                  RANGE = price_range
                  LCLM = lower_CI
                  UCLM = upper_CI;
run;

ODS select all;
ods printer close;



*Question 4.2;
*==============;

proc sql;
create table ASSIGN1.supplier_report2 as
select max(mean_price) as highest_mean, max(median_price) as highest_median, max(mode_price) as highest_mode
from ASSIGN1.supplier_report;

quit;

proc print data = ASSIGN1.supplier_report2(obs=1);
run;

*Question4.3;
*==============;

/*Judging from the values on the supplier_report2 table, the maximum or highest values of the mean,median and mode are almost equal , or
there is not a great difference between their values,
therefore the distribution is symmetric because the data of these three measures is evenly distributed around the central point.*/

*Question5;

Proc sort data = work.supplier_data out = supplier2
      By supplier;
Run;

*Question6;
*==============;

ODS SELECT HISTOGRAM;
PROC UNIVARIATE DATA=SortedSupplier NORMAL mu0=140;
        BY Supplier;
        VAR Price;
        HISTOGRAM Price / NORMAL KERNEL;
        PROBPLOT Price / NORMAL(MU=EST SIGMA=EST);
RUN;

ODS _ALL_ CLOSE;





*Question7;
*==============;

Data work.supplier3;
Input supplier shapiro_wilk p_value decision $ conclusion $50.;
Datalines;

1 0.977638 0.0869 No_Reject Price_normally_distributed
2 0.993705 0.9267 No_Reject Price_normally_distributed
3 0.961189 0.0049 Reject Price_not_normally_distributed
;
run;









*Question8;
*==============;

data ASSIGN1.supplier3;
    set ASSIGN1.supplier;
    price = price - 140;
run;


proc means data=ASSIGN1.supplier3 clm alpha=0.05 mean stderr t prt;
    var price;
    output out=MeansOutput mean=Mean stderr=StdErr lclm=LowerCLM uclm=UpperCLM t=tValue probt=pValue;
run;

proc print data=MeansOutput;
run;

*/H0 : Mean = 0
 HA :Mean != 0
 Reject H0 if p < 0.05
P > .0001 ,so we do not reject H0
so mean != 0
*/ ;
