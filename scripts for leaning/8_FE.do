//Chapter 8. Fixed Effects 모형//

cd "C:\Users\user\Documents\stata"
use P_data8_1.dta, clear

//데이터의 형식 확인하기
tsset company year 

//패널 회귀 명령어에 fe 옵션을 사용하여 within 추정량 구하기
xtreg invest mvalue kstock, fe 

//8.7의 결과와 xtreg 추정결과가 동일한 것을 확인하기
qui xtreg invest mvalue kstock, fe
by company, sort: egen float m_invest=mean(invest) if e(sample)==1
by company, sort: egen float m_mvalue=mean(mvalue) if e(sample)==1
by company, sort: egen float m_kstock=mean(kstock) if e(sample)==1
 
gen invest1=invest-m_invest
gen mvalue1=mvalue-m_mvalue
gen kstock1=kstock-m_kstock
 
reg invest1 mvalue1 kstock1, nocons

//8.7 모형 추정하기 
qui xtreg invest mvalue kstock, fe
egen float all_invest = mean(invest) if e(sample)==1
egen float all_mvalue = mean(mvalue) if e(sample)==1
egen float all_kstock = mean(kstock) if e(sample)==1

gen invest2=invest1+all_invest
gen mvalue2=mvalue1+all_mvalue
gen kstock2=kstock1+all_kstock

reg invest2 mvalue2 kstock2

//고정효과 모형의 추정계수를 이용하여 적합값 일치 여부 확인 
qui xtreg invest mvalue kstock, fe
gen y_bar=_b[_cons]+_b[mvalue]*m_mvalue+_b[kstock]*m_kstock if e(sample)==1

corr y_bar m_invest

// 계산해보기 
di "Between R-sq=" 0.9052^2
qui xtreg invest mvalue kstock, fe
predict y_overall, xb
corr y_overall invest
di "overall R-sq="0.8978^2

qui xtreg invest mvalue kstock, fe
predict y_hat, xb
predict u_hat, u
corr y_hat u_hat

//직접 p계산해보기
di “rho=” (85.7^2)/85.7^2+52.7^2)

//새파일열기
use P_data8_2.dta, clear

//시간에 따라 변하지 않는 설명변수 포함 모형 
tsset id year
xtreg ln_wage ttl_exp tenure black, fe

//LSDV(최소제곱더미변수) 추정
use P_data8_1.dta, clear
// within 추정
xtreg invest mvalue kstock, fe
//lsdv 추정
xi, noomit: reg invest mvalue kstock i.company, nocons
xi : reg invest mvalue kstock i.company
testparm _Icompany_2- _Icompany_10

//새파일열기
use P_data8_2.dta, clear
xtreg ln_wage ttl_exp tenure black, fe
areg ln_wage ttl_exp tenure black, absorb(id)

//새파일열기
use P_data8_3.dta, clear
qui tsset company year
xi: xtreg invest mvalue kstock i.year, fe
testparm _Iyear_1936- _Iyear_1939

//사후분석
use P_data8_1.dta, clear
tsset company year
qui xtreg invest mvalue kstock, fe
predict invest_hat, xb
predict uhat, u
predict ehat, e

gen cons1=_b[_cons]+uhat


xi, noomit: reg invest mvalue kstock i.com, nocons

egen byte tag1 = tag(company)

gen cons2=. 
forvalues i=1/10 {
replace cons2=_b[_Icompany_`i'] if company==`i'
}

list company cons1 cons2 if tag1==1





