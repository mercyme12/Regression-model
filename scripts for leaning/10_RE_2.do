//Chapter 10. 확률효과 모형//

cd "C:\Users\user\Google 드라이브\[국제산업인력개발 연구실] 랩스\2. 통계학\[19.05]STATA 패널데이터 분석\데이터 파일"

//<10.4 xtdata 명령어를 이용한 추정>//

use P_data10_1.dta, clear

xtreg invest mvalue kstock, be

xtdata invest mvalue kstock, be
reg invest mvalue kstock
//위 두개가 일치함. 아래 xtdata를 하고 reg를 한 경우는 200개가 아닌 10개의 데이터만 사용함.

//fe도 똑같음.
use P_data10_1.dta, clear

xtreg invest mvalue kstock, fe

xtdata invest mvalue kstock, fe
reg invest mvalue kstock

//확률효과 모형도 똑같음.
use P_data10_1.dta, clear

xtreg invest mvalue kstock, re

xtdata invest mvalue kstock, re ratio('sigma_r')
reg invest mvalue kstock constant, nocons

//<10.5 최우추정법>//
use P_data10_1.dta, clear
tsset company year

//GLS
xtreg invest mvalue kstock, re theta
estimate store GLS

//MLE
xtreg invest mvalue kstock, mle nolog
estimate store MLE

qui xtreg invest mvalue kstock, mle nolog
scalar theta1=sqrt(e(sigma_e)^2/10*e(sigma_u)^2+e(sigma_e)^2)
scalar theta2=1-theta1

di "theta의 추정치=" theta2
estimates table GLS MLE, eq(1:1) b(%9.4f) se(%9.4f)
