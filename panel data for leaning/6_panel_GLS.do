*********************
***랩스 6장 Panel OLS***
**********************

cd "C:\Users\LORDSHIP\Google 드라이브\[국제산업인력개발 연구실] 랩스\2. 통계학\[19.05]STATA 패널데이터 분석\데이터 파일"
use P_data6_1.dta, clear

tsset state year

***6.1 Pooled OLS***
reg fatal perincK spircons //오차항의 공분산 행렬 가정이 같다는 가정이 충족되어야 BLUE(Best Linear Unbiased Estimaor)이 충족됨.


***6.2 이분산성 가정***
**오차항의 이분산성이 존재하는 경우 GLS를 사용함**

xtgls fatal perincK spircons //reg 보다 S.E 값이 약간 작음.

xtgls fatal perincK spircons, nmk //Poole OLS의 coef, S.E.모두 동일. 단, 동분산성과 자기상관을 가정함.

xtgls fatal perincK spircons, panel(hetero) // 오차항에서 패널 개체간 이분산성 가정

findit ereturn
eretern list  //사후 결과) 기존에 비하여 S.E이 작아졌음.
mat list e(Sigma) // 행렬값 확인


**공분산 행렬의 크기 한도**
use P_data6_2.dta, clear

tsset id year
xtdes

xtgls ln_wage ttl_exp hours, panel(hetero) //error. 행렬 크기가 최대 한도(800*800)를 벗어났음


**LR(likelihood ratio)검정(이분산성 검정)***
use P_data6_1.dta, clear

xtgls fatal perincK spircons //제약모형 추정. 대각선 분산이 같다고 가정
estimates store R_model

xtgls fatal perincK spircons, panel(hetero) igls nolog //비제약모형 추정. 대각선 분산이 다르다고 가정(이분산성). igls(iteration gls)
estimates store UR_model

lrtest UR_model R_model, df(47) //0가설: UR_model 오차항이 동분산성이다. 기각 시 이분산성=> R_model 사용해야함.


***6.3 상관관계 가정***
use P_data6_1.dta, clear

tsset state year

xtgls fatal perincK spircons, corr(ar1) //자기상관의 존재 가정. 모든 패널 개체에 대하여 자기상관 계수가 모두 p로 같다고 가정.

xtgls fatal perincK spircons, corr(psar1) //자기상관의 존재 가정. 각 패널 개체에 대하여 자기상관 계수가 서로 다른 것으로 가정.

xtgls fatal perinc spircons, corr(ar1) igls nolog //corr()옵션을 사용할 경우 igls를 사용해도 로그우드함수값이 주어지지 않음.=> 다른 방법을 강구

**자기상관 검정**
findit xtserial //자기상관 검정
xtserial fatal perincK spircons // H0: 1계자기상관이 존재하지 않는다. 기각하면 1계 자기상관이 존재한다.

**이분산성과 동시적 상관을 함께 가정**
xtgls fatal perincK spircons, panel(corr) //이분산성 상관 검정(패널 개체별 오차항의 분산이 서로 다르다고 가정)+동시적상관(패널 개체간 상관)

**이분산성과 자기상관을 함께 가정
xtgls fatal perincK spircons, corr(ar1) panel(hetero) //(패널 개체별 오차항의 분산이 서로 다르다고 가정)+자기상관(개체 내 시간적 상관)


**force 옵션의 사용**
use P_data6_3.dta, clear

tsset id year //time gap
xtgls ln_wage hours ttl_exp, corr(ar1) //error
xtgls ln_wage hours ttl_exp, corr(ar1) force //success


***6.4 사후 분석***
use P_data6_1.dta, clear

qui xtgls fatal unrate perincK beertax spircons, panel(hetero) igls
test unrate //추정계수 유의성 검정
test unrate perincK // 두 변수의 계수를 동시에 0으로 가정

**LR test**
qui xtgls fatal unrate perincK beertax spircons, panel(hetero) igls
estimates store full

qui xtgls fatal beertax spircons, panel(hetero) igls
estimates store restricted

lrtest full restricted //unrate, perincK변수 계수가 동시에 0이라는 귀무가설 기각

**z검정 chi검정**
xtgls fatal unrate perincK beertax spircons, panel(hetero)
test unrate+perincK=0

lincom unrate+perinck=0 //error
lincom unrate+perincK //success.  z^2=chi
 
**표준오차 계산하기**
qui xtgls fatal unrate perincK beertax spircons, panel(hetero)
scalar var1=_se[unrate]^2+_se[perincK]^2
mat def aa=e(V)
scalar cov=aa[2,1]
di "Std.Err=" sqrt(var1+2*cov)



