//Chapter 8. Fixed Effects 모형//

cd "D:\google drive\[국제산업인력개발 연구실] 랩스\2. 통계학\[19.05]STATA 패널데이터 분석\데이터 파일"
use P_data9_1.dta, clear

//1. <1차 차분 모형 추정> //

//패널변수 만들기
gen state=group(46)
list state year in 1/6
//group(개체수) 로 46개의 그룹, 즉 ID를 만들라는 의미임

tsset state year
//state 기준 year로 패널변수 생성 -> 시간갭 있는 균형패널(82년, 87년)
//실제로는 5년 갭으로 연속측정된 것으로 갭이 없는 것으로 볼 수 있으나 시계열 연산이 제대로 작동하지 않을 수 있음

//따라서 새로운 변수 time을 만들어서 분석을 시행함
by state, sort: gen time=_n
list state time year in 1/6
tsset state time
//-> 시간갭 없는 균형패널(1, 2)



//------------------------------------------------//
// within 모형과 1차차분 비교1//
//within 모형
xtreg crmrte unem, fe

//1차차분 모형
reg D.crmrte D.unem, nocons //  D.= 1차 차분변수 연산자

//결과 표에서 기울기에 대한 모수(베타: -0.018)와 표준오차(0.608)이 동일함

//------------------------------------------------//




//------------------------------------------------//
// within 모형과 1차차분 비교2 - 이원고정효과모형 //
//이원고정효과모형은 시간 변수를 함께 고려해 주는 것(i.time)

//within 모형
xtreg crmrte unem i.time, fe

//1차차분 모형
reg D.crmrte D.unem
//------------------------------------------------//




//------------------------------------------------//
// within 모형과 1차차분 비교3 - 오차항 자기상관//
//앞 예제에서는 시점이 2개였음. 시점이 3개 이상인 경우 차분을 하여도 횡단데이터의 형태가 아님
//따라서 오차항의 변화량(델타)가 자기상관을 가지게 됨.
//이 때, 
//1.오차항에 자기상관이 존재하지 않는 경우 - 변화량에 자기상관 존재
//2. 오차항에 자기상관이 존재하는 경우  - 변화량에 자기상관 존재 x
//교재 페이지 138 참조


use P_data9_2.dta, clear
//within 모형
tsset county year
xtreg crmrte prbarr polpc, fe

//1차차분 모형
reg D.crmrte D.prbarr D.polpc, nocons
//1차차분의 경우 효율적이지 못함(자기상관이 실제로는 있기 때문)

//-> within 모형 사용이 바람직함

// 오차항 자기상관 가정 //
//Clustered sandwich 추정량, 옵션에서 vce(cluster id)
regress D.crmrte D.prbarr D.polpc, nocons vce(cluster county)
//강건한 모델로, 표준오차값이 달라짐

//자기상관 검정 확인
findit xtserial
xtserial crmrte prbarr polpc, output
//결과가 강건 모델을 사용한 것과 일치함 
//P값이 0.01보다 작아 영가설이 기각되어 '자기상관이 존재한다'는 것으로 해석된다.
//------------------------------------------------//


//2. <DID 추정> //
use P_data9_3.dta, clear

tsset fcode year
reg D.scrap D.grant

by fcode, sort : egen treat = total(grant)
gen dscrap=D.scrap
by treat, sort: su dscrap
di -1.303+0.563
//b계수 구한 결과와 맞는지 확인

//식 9.11에서의 베타값 = 식 9.14의 DID추정량
reg scrap i.year##i.treat

//diff 명령어(1차차분 추정량 얻는 명령어)
findit diff
//diff 명령어 이후에는 종속변수 지정
diff scrap, period(year) treated(treat)
//이 경우 반드시 연속적(1991-1992-1993)이어야 함. 연속이 아닌 경우 time변수 만들어서 활용
by fcode, sort: gen time=_n





