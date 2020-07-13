set more off
clear


* This next line of code changes where STATA will look for files and save files
cap cd "\\prism.nas.gatech.edu\jmorgan67\vlab\desktop\HW5 Data"
use stardata_Kindergarten


* Start log file to record what Stata does below
log using Assignment5_log, replace

* Read in Data
use stardata_Kindergarten, clear

* Create percentiles of test scores (using only reg and reg+aide classes), apply percentiles to entire sample to create mean score
replace readk=. if readk==999
replace mathk=. if mathk==999
pctile readkpct=readk if ctypek==2|ctypek==3, nq(100)
pctile mathkpct=mathk if ctypek==2|ctypek==3, nq(100)
xtile readkperc=readk if ctypek~=9, cutpoints(readkpct)
xtile mathkperc=mathk if ctypek~=9, cutpoints(mathkpct)
gen mnscorek=(readkperc+mathkperc)/2
replace mnscorek=readkperc if mathkperc==.
replace mnscorek=mathkperc if readkperc==.
label var mnscorek "mean reading and math score, grade k"

* Create age variable
replace yob=. if yob==9999
replace qob=. if qob==99

gen mob=.
replace mob=2.5 if qob==1
replace mob=5.5 if qob==2
replace mob=8.5 if qob==3
replace mob=11.5 if qob==4 
gen agein1985=1985-yob+(9-mob)/12 
label var agein1985 "Age in (September) 1985"

* Your code to complete the assignment will start here...

* Part I (this is where we generated the variables)
gen freelunch=.
replace freelunch=1 if sesk==1
replace freelunch=0 if sesk==2

gen whiteorasian=.
replace whiteorasian=1 if race==1|race==3
replace whiteorasian=0 if race==2|race==4|race==5|race==6

summarize freelunch whiteorasian

*c)
gen Twhiteorasian=.
replace Twhiteorasian=1 if race==1|race==3
replace Twhiteorasian=0 if race==2|race==4|race==5|race==6

summarize Twhiteorasian totexpk

*d) 
 tabstat freelunch whiteorasian Twhiteorasian totexpk csizek, by (ctypek)
 
 display "Yes! The means of the variables appear to be evenly (randomly) distributed across the class types."

* PART II (this is HW6 code)
* Question a) and Question b) are in a word file

*new variables generated
gen Regular=.
replace Regular=1 if ctypek==2
replace Regular=0 if ctypek==1 | ctypek==3
 
gen Small=.
replace Small=1 if ctypek==1
replace Small=0 if ctypek==2 | ctypek==3
 
gen RegAid=.
replace RegAid=1 if ctypek==3
replace RegAid=0 if ctypek==1 | ctypek==2

* Question c)
 reg freelunch Small RegAid, robust
 tabstat freelunch, by (ctypek)
 
 reg whiteorasian Small RegAid, robust
 tabstat whiteorasian, by (ctypek)
 
 reg agein1985 Small RegAid, robust
 tabstat agein1985, by (ctypek)
 
 reg Twhiteorasian Small RegAid, robust
 tabstat Twhiteorasian, by (ctypek)
 
 reg totexpk Small RegAid, robust
 tabstat totexpk, by (ctypek)
 
*Question d)
*This answer is located in the word document.

*Question e) 
*The "test" command will display the F-test between Small and RegAid
reg freelunch Small RegAid, robust
test Small RegAid

reg whiteorasian Small RegAid, robust
test Small RegAid

reg agein1985 Small RegAid, robust
test Small RegAid

reg Twhiteorasian Small RegAid, robust
test Small RegAid

reg totexpk Small RegAid, robust
test Small RegAid

* Question f)
* The following command produces a new set of indicator variables
* These indicator variables represent 80 different schools
xi i.schid, noomit

reg freelunch Small RegAid _Ischidk*, robust
reg whiteorasian Small RegAid _Ischidk*, robust
reg agein1985 Small RegAid _Ischidk*, robust
reg Twhiteorasian Small RegAid _Ischidk*, robust
reg totexpk Small RegAid _Ischidk*, robust


