//Chapter 7. Between Effects 모형//

cd "C:\Users\user\Google 드라이브\[국제산업인력개발 연구실] 랩스\2. 통계학\[19.05]STATA 패널데이터 분석\데이터 파일"
use P_data7_1.dta, clear

//7.1 기본 모형 및 추정방법
*Between 모형 추정

tsset id year

//1.합동 OLS 모형 추정
reg ln_wage ttl_exp tenure black

//2.Bewteen 모형 추정 -기울기 계수는 변수의 변화에 대한 패널 개체 간 한계효과를 말함
xtreg ln_wage ttl_exp tenure black, be


*종속변수의 적합값 변수 생성/ 상관계수 계산
qui xtreg ln_wage ttl_exp tenure black, be

predict yhat

corr yhat ln_wage

di 0.3464^2

*직접 변수를 변환하여 OLS 추정
qui xtreg ln_wage ttl_exp tenure black, be

by id, sort: egen float wage_mean = mean(ln_wage) if e(sample)==1

by id, sort: egen float ttlexp_mean = mean(ttl_exp) if e(sample)==1

by id, sort: egen float tenure_mean = mean(tenure) if e(sample)==1

by id, sort: egen float black_mean = mean(black) if e(sample)==1

egen byte tag1 = tag(id) if e(sample)==1

reg wage_mean ttlexp_mean tenure_mean black_mean if tag1==1


//7.2 사후분석
*predcit - 적합값(fitted value)와 잔차(residuals)를 계산할 수 있음

tsset id year

qui xtreg ln_wage ttl_exp tenure black, be
*xb는 적합값
predict yhat, xb
*xbu는 회귀모형에 의해 설명되는 부분과 개체특성 오차항이 설명하는 부분의 합
predict xb1, xbu
*ue는 오차항에 대한 잔차를 생성
predict res1, ue
*u는 잔차 생성
predict res2, u

predict res3, e

*위에서 생성된 변수들의 일부분
list ln_wage yhat xb1 res1 res2 res3 in 1/10

**estimates 명령어 활용 - 저장되어 있는 추정결과를 불러오기 위한 명령어
qui xtreg ln_wage ttl_exp tenure black, be

estimates

**estimates store -추정 결과 저장
qui xtreg ln_wage ttl_exp tenure black, be
estimates store BE_model

qui reg ln_wage ttl_exp tenure black
estimates store OLS_model


estimates restore BE_model

estimates




