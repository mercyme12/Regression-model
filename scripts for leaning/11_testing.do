
********************************************************************************
********************************************************************************
******                Chapter 11. 가설검정 pp.167~180                     ******
********************************************************************************
********************************************************************************


****** ----------------------- Change Directory ------------------------- ******
	cd "C:\Users\Owner\Google 드라이브\[국제산업인력개발 연구실] 랩스\2. 통계학\[19.05]STATA 패널데이터 분석\데이터 파일"
****** ------------------------------------------------------------------ ******


/* ===========================================================================*/
/* 11.1 오차항 u_i에 대한 가설검정 ===========================================*/
/* ===========================================================================*/
	use P_data11_1, clear       // 고정된 개체 특성 고려 여부 검정
	tsset company year          // 균형패널, 1년단위 확인됨
	xtreg invest mvalue kstock, fe // 고정효과 추정
	// 추정결과 맨 아래 가설검정 겨로가가 제시됨
	// 패널 그룹더미변수(9개, 총 패널그룹 10개) 추정계수가 0인지 확인. 1%유의수준에서 기각됨
	// 개체특성을 고려한 고정효과가 합동 OLS 보다 나은 모형임.

	use P_data11_2, clear // 확률효과 여부 검정
	tsset id year  
	quietly xtreg ln_wage ttl_exp tenure black, re 
	xttest0 // Breusch-Pagan LM 검정결과 제시. 1%유의수준에서 귀무가설 기각됨.
	
	ereturn list // 확률효과 추정 후 명령어 실행으로 두 오차항의 분산,표준편차 추정치 구할 수 있음
	
	quietly xtreg ln_wage ttl_exp tenure black, re 
	display "sd_u=" e(sigma_u) // 오차항 u 표준편차 계산
	display "sd_e=" e(sigma_e) // 오차항 e 표준편차 계산
	summarize ln_wage if e(sample)==1 // 분석에 활용된 종속변수만 선택하여 표준편차 계산
	display "sd_ln_w=" r(sd) // 종속변수 표준편차 제시
	// => 확률효과 검정 후 계산된 두 오차항 및 종속변수의 분산, 표준편차와 LM통계량의 추정치 동일함


/* ===========================================================================*/
/* 11.2 상관관계와 이분산성 검정 =============================================*/
/* ===========================================================================*/
	findit xttest1 // 자기상관 검정

	use P_data11_1, clear
	tsset company year
	quietly xtreg invest mvalue kstock, re

	xttest1, unadjusted // 자기상관 검정 (균형, 불균형 패널 모두에서 실행됨)

	xttest0

	findit xttest2 // 개체 간 상관관계 검정

	use P_data11_3, clear
	tsset company year
	quietly xtreg invest mvalue kstock, fe
	xttest2

	use P_data11_2, clear
	tsset id year
	quietly xtreg ln_wage ttl_exp tenure black, fe
	xttest3 // 개체 간 이분산성 검정


/* ===========================================================================*/
/* 11.3 하우스만 검정 ========================================================*/
/* ===========================================================================*/
	use P_data11_4, clear
	tsset state year
	quietly xtreg fatal unrate perincK beertax spircons, fe
	estimates store FE
	quietly xtreg fatal unrate perincK beertax spircons, re
	estimates store RE // 고정, 확률 효과를 각각 추정하여 추정치를 저장
	hausman FE RE // 고정효과 + 확률효과 순으로 적어야 함!
	//귀무가설 기각됨. 고정효과 모형 선택ㅎ는 것이 적절.

	hausman FE RE, sigmamore // 확률효과 모형에서 얻은 오차항 분산 추정치 이용하여 var(bFE, bFE) 계산

	use P_data11_2, clear
	tsset id year
	quietly xtreg ln_wage ttl_exp tenure, fe
	estimates store FE
	quietly xtreg ln_wage ttl_exp tenure, re
	estimates store RE
	hausman FE RE // 15 유의수준에서 귀무가설 기각됨 = 고정효과 사용이 효율적임.

	// hausman 검정통계량을 다음과 같이 stata 행렬함수를 이용하여 확인 가능함
	
	quietly xtreg ln_wage ttl_exp tenure, fe	//고정효과 모형 추정

	mat def v_fe=e(V)	//추정계수 공분산 행렬
	mat def v_fe=v_fe[1..2,1..2]	//공분산 행렬중 2x2행렬만 추출

	mat def coef_fe=e(b)	//추정계수 행렬
	mat def coef_fe=coef_fe[.,1..2]		//추정계수 행렬 중 1x2행렬만 추출

	quietly xtreg ln_wage ttl_exp tenure, re	//확률효과 모형 추정

	mat def v_re=e(V)	//추정계수 공분산 행렬
	mat def v_re=v_re[1..2,1..2]	//공분산 행렬중 2x2행렬만 추출

	mat def coef_re=e(b)	//추정계수 행렬
	mat def coef_re=coef_re[.,1..2]		//추정계수 행렬 중 1x2행렬만 추출

	mat def diff_coef=coef_fe-coef_re	//추정계수 행렬 차이
	mat def diff_v=v_fe-v_re	//추정계수 공분산 행렬 차이

	mat def haus=diff_coef*syminv(diff_v)*diff_coef'	//하우스만 검정통계량

	mat list haus


