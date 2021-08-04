//Chapter 10. 확률효과 모형//

cd "C:\Users\user\Google 드라이브\[국제산업인력개발 연구실] 랩스\2. 통계학\[19.05]STATA 패널데이터 분석\데이터 파일"

//<10.2 확률효과 모형 추정>//
use P_data10_1.dta, clear
tsset company year

//확률효과 모형 추정을 위해 xtreg명령어와 re옵션 사용, theta옵션 사용하여 세타추정치도 구할 수 있음//
xtreg invest mvalue kstock, re theta

//between 모형 추정 후 식 10.4 분모 계산//
qui xtreg invest mvalue kstock, be
scalar sig2_be=e(rss)/e(df_r)
scalar sig2_be1=20*sig2_be
//고정효과 모형 추정 후 식 10.4 값 계산//
qui xtreg invest mvalue kstock, fe
scalar sig2_fe=e(rss)/e(df_r)
scalar theta1=1-sqrt(sig2_fe/sig2_be1)
di "theta_hat=" theta1

//rho 값 계산//
qui xtreg invest mvalue kstock, re
di "rho=" e(sigma_u)^2/(e(sigma_u)^2+e(sigma_e)^2)

//개체특성을 고려한 선형회귀모형 계산-theta값 직접 계산하여 OLS 추정하기//
by company, sort : egen m_invest = mean(invest)
by company, sort : egen m_mvalue = mean(mvalue)
by company, sort : egen m_kstock = mean(kstock)

scalar theta1=.86122362
gen cons1=1-theta1
gen invest1=invest-theta1*m_invest
gen mvalue1=mvalue-theta1*m_mvalue
gen kstock1=kstock-theta1*m_kstock

reg invest1 mvalue1 kstock1 cons1, nocons

//R^2 직접 계산하기//
//overall R^2//
qui xtreg invest mvalue kstock, re
predict yhat_re, xb
corr yhat_re invest

di "overall R-sq=" r(rho)^2

//between R^2//
by company, sort : egen yhat_be = mean(yhat_re)
egen byte tag1 = tag(company)
corr yhat_be m_invest if tag1==1

di "between R-sq=" r(rho)^2

//within R^2//
gen invest1=invest-m_invest
gen mvalue1=mvalue-m_mvalue
gen kstock1=kstock-m_kstock

gen yhat_fe=_b[_cons]+_b[mvalue]*mvalue1+_b[kstock]*kstock1

corr yhat_fe invest1

di "within R-sq=" r(rho)^2

//<10.3 추정계수의 해석>//
use P_data10_2.dta, clear
tsset id year

//불균형패널 BE, FE, RE 추정//
qui xtreg ln_wage ttl_exp tenure black, be
estimates store BE_model

qui xtreg ln_wage ttl_exp tenure black, fe
estimates store FE_model

qui xtreg ln_wage ttl_exp tenure black, re
estimates store RE_model

estimates table BE_model FE_model RE_model, b(%9.3f) star(0.01 0.05 0.1)

//<Tip 10.1 추정결과표 만들기: xml_tab 명령어>//
findit xml_tab

use P_data10_2.dta, clear

qui xtreg ln_wage ttl_exp tenure black, be
estimates store BE

qui xtreg ln_wage ttl_exp tenure black, fe
estimates store FE

qui xtreg ln_wage ttl_exp tenure black, re
estimates store RE

xml_tab BE FE RE, save(C:\Users\Gwiyoung\Desktop\panel1.xml) 

//below: 표준오차를 추정계수 아래에 써라, nolabel: 레이블 대신 변수명을 써라//
xml_tab BE FE RE, save(C:\Users\Gwiyoung\Desktop\panel2.xml) below nolabel
