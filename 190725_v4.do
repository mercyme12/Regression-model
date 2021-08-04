cd "C:\Users\Mercyme\Dropbox\2019_빈곤과불평등_과제연구\2019_2학기_빈곤과 불평등, 사회정책\01. 분석\한국복지패널_1_13차_차수별_데이터(release190329)_stata"
cd "C:\Users\LORDSHIP\Dropbox\2019_빈곤과불평등_과제연구\2019_2학기_빈곤과 불평등, 사회정책\01. 분석\한국복지패널_1_13차_차수별_데이터(release190329)_stata"



********************2014***비분리 청년 자녀(수급+비수급 모두 포함) *************************

unicode encoding set korean 
unicode translate  *.dta , invalid 

use Koweps_hpda09_2014_beta5, clear

gen age1 = 2014 - (h09_g4) + 1

keep if age1 > 19 
keep if age1 < 31

tab age1 //(n=1708)

tab h09_g6 h09_g7 //학력 

tab h0901_5aq2 //기초보장 수급형태 0. 비해당 =1537  1. 가구원 전부 수급 =86  2. 가구원 중 일부 수급 = 42

rename h0901_5aq2 receive1
recode receive1 0=0 1=1 2=1

tab h09_eco4 // 근로형태 "1. 상용직 임금근로자
2. 임시직 임금근로자
3. 일용직 임금근로자
4. 자활근로, 공공근로, 노인일자
5. 고용주
6. 자영업자
7. 무급가족종사자
8. 실업자(지난 4주간 적극적으로 구직활동을 함)
9. 비경제 활동인구"
recode h09_eco4 1=1 2=1 3=1 4=1 5=1 6=1 7=1 8=0 9=0 , gen(workstatus1) // 1=근로자 0=비근로자


tab p0902_4aq2 //지난 1년간 구직활동 경험여부 1. 그렇다 2. 아니다
recode p0902_4aq2 1=1 2=0, gen(jobfinding1)

tab  h0913_26 //직업훈련취업상담취업알선자활근로 경험여부
recode h0913_26 1=1 2=0, gen(training1)



tab h09_g6 h09_g7 // 교육수준

**교육상태 변수 만들기
recode h09_g6(1/4=1)(5=2)(6=3)(7=4)(8/9=5), gen(edu1)
recode h09_g7(5=1)(2/5=2), gen(degree1)
replace edu1 =1 if edu1 ==2 & degree1!=1
replace edu1 =2 if edu1 ==3 & degree1!=1
replace edu1 =3 if edu1 ==4 & degree1!=1
replace edu1 =4 if edu1 ==5 & degree1!=1


rename h09_g3 gender1
recode gender 1=1 2=0

rename  h09_g9 handi1
recode handi 0=0 1=1 2=1 3=1 4=1 5=1 6=1 

rename h09_reg5 location1
recode location1 1=1 2=1 3=0 4=0 5=0  //1. 서울    2.광역시   3.시   4.군   5.도농복합군

rename h09_med2 health1
recode health1 1=5 2=4 3=3 4=2 5=1

rename h09_g2 familyhead1
recode familyhead1 10=1 3=0 11=0 12=0 13=0 14=0 20=0 21=0 22=0 31=0 32=0 41=0 42=0 111=0 112= 0 113=0 121=0 124=0 131=0 132=0 141=0 142=0 151=0 152=0 997=0 1=0 15=0 23=0 122=0

gen totasset1 = ///
h0906_6 +h0910_aq1 +h0910_aq2+ h0910_aq3+ h0910_aq4+ h0910_aq5+ h0910_aq6 +h0910_aq7+ h0910_aq8+ h0910_aq9 + ///
h0910_aq10 +h0910_aq11+ h0910_aq12+ h0910_aq13 +h0910_aq14 +h0910_aq15 +h0910_aq16 +h0910_aq17+ h0910_aq18 +h0910_aq19 + ///
h0910_aq20 +h0910_aq23+ h0910_aq24+ h0910_aq25+ h0910_aq26



gen pid=h09_pid

save "09_data_rename", replace




********************************************************************
*****************2018 수급 만들기******************************
use Koweps_hpwc11_2016_beta3, clear
 
gen pid=h11_pid


gen age2 = 2016 - (h11_g4) + 1

//keep if age2 > 19 
//keep if age2 < 33

tab age2 //(n=1518)


tab h1112_2_11aq4
tab h1101_11aq3 //생계급여 수급 여부
tab h1101_11aq6 //의료급여
tab h1101_11aq8 //주거급여 


gen receive2= 1 if h1101_11aq3 !=0 | h1101_11aq6 !=0 | h1101_11aq8 !=0  | h1101_11aq10 !=0
replace receive2 =0 if receive2==.


***********************
tab h11_eco4 // 근로형태 "1. 상용직 임금근로자
2. 임시직 임금근로자
3. 일용직 임금근로자
4. 자활근로, 공공근로, 노인일자
5. 고용주
6. 자영업자
7. 무급가족종사자
8. 실업자(지난 4주간 적극적으로 구직활동을 함)
9. 비경제 활동인구"
recode h11_eco4 1=1 2=1 3=1 4=1 5=1 6=1 7=1 8=0 9=0 , gen(workstatus2) // 1=근로자 0=비근로자


tab p1102_4aq2 //지난 1년간 구직활동 경험여부 1. 그렇다 2. 아니다
recode p1102_4aq2 1=1 2=0, gen(jobfinding2)

tab  h1113_26 //직업훈련취업상담취업알선자활근로 경험여부
recode h1113_26 1=1 2=0, gen(training2)


tab h11_g6 h11_g7 // 교육수준

**교육상태 변수 만들기
recode h11_g6(1/4=1)(5=2)(6=3)(7=4)(8/9=5), gen(edu2)
recode h11_g7(5=1)(2/5=2), gen(degree2)
replace edu2 =1 if edu2 ==2 & degree2!=1
replace edu2 =2 if edu2 ==3 & degree2!=1
replace edu2 =3 if edu2 ==4 & degree2!=1
replace edu2 =4 if edu2 ==5 & degree2!=1


rename  h11_g9 handi2
recode handi 0=0 1=1 2=1 3=1 4=1 5=1 6=1 


tab h11_reg5
rename h11_reg5 location2

recode location2 1=1 2=1 3=0 4=0 5=0
 
***건강상태**
rename h11_med2 health2

recode health2 1=5 2=4 3=3 4=2 5=1

**가구주와의 관계***
rename h11_g2 familyhead2
 
recode familyhead2 10=1 3=0 11=0 12=0 13=0 14=0 15=0 20=0 21=0 22=0 31=0 32=0 41=0 42=0 111=0 112= 0 113=0 121=0 131=0 132=0 141=0 142=0 151=0 997=0 1=0

**총소득액**

gen totasset2 = ///
h1106_6 +h1110_aq1 +h1110_aq2+ h1110_aq3+ h1110_aq4+ h1110_aq5+ h1110_aq6 +h1110_aq7+ h1110_aq8+ h1110_aq9 + ///
h1110_aq10 +h1110_aq11+ h1110_aq12+ h1110_aq13 +h1110_aq14 +h1110_aq15 +h1110_aq16 +h1110_aq17+ h1110_aq18 +h1110_aq19 + ///
h1110_aq20 +h1110_aq23+ h1110_aq24+ h1110_aq25+ h1110_aq26



save "11_data_rename", replace









use "09_data_rename", clear

su totasset1
egen p50 = pctile(totasset), p(50)

keep if totasset1 <= p50


merge 1:1 pid using 11_data

keep if _merge ==3

save "09_11_merge_p50below", replace
save "09_11_merge_0725", replace



reshape long age receive jobfinding training edu degree handi workstatus location totasset ///
health familyhead, i(pid) j(year)



save "09_11_merge_variable_remaing_long_0725_p50below", replace

keep year age gender receive jobfinding training edu degree handi workstatus location health familyhead totasset


tab receive edu

drop if edu==5
 
gen ageage = age*age

***model1***
logit workstatus age ageage i.gender i.location i.edu i.receive i.familyhead health, //나이, 학력2, 학력3, 학력4, 수급1, 훈련1
outreg2 using myreg_withoutpostgraduate_addvariable2.doc, replace ctitle(Model 1)

***model2***  
logit workstatus age ageage i.gender i.location i.edu i.receive i.familyhead health year i.receive#i.year , //나이, 학력2, 학력3, 학력4, 수급1, 훈련1
outreg2 using myreg_withoutpostgraduate_addvariable2.doc, append ctitle(Model 2)

***model3***(비유의)
logit workstatus age ageage i.location i.edu i.receive i.wave i.receive#i.wave i.familyhead health training incomesatis satisfaction famlifesatis handi, // 나이, 학력2, 학력3, 학력4, 수급1, 훈련1
outreg2 using myreg.doc, append ctitle(Model 3)
outreg2 using myreg_withoutpostgraduate.doc, replace ctitle(Model 3)



save "09_11_result_below50_edu", replace
save "09_11_result", replace
save "13and18poolingdata_totasset_withoutpostgraduate_addvariable", replace //2019.06.15.
