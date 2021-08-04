

 **  Chapter 14. 동적 패널 모형 pp.215~230 **
	cd "C:\Users\isoll\Documents\stata\panel data"

/* ===========================================================================*/
/* 14.1 기본 모형 ============================================================*/
/* ===========================================================================*/

/* ===========================================================================*/
/* 14.2 Arellano-Bond 추정 ===================================================*/
/* ===========================================================================*/
	use P_data14_1.dta, clear
	tsset state yr
	
	// 로그변수 만들기
	gen lnP=ln(price)
	gen lnC=ln(c)
	gen lnY=ln(ndi)
	gen lnPn=ln(pimin)
	
	// 2차 차분변수 이용, fd 옵션 사용(FD2SLS: 1차차분 2SLS, 책 205쪽) //
	xtivreg lnC lnP lnY lnPn (L.lnC=L2.lnC), fd
	**여기서 변수는 로그-로그 형태로 탄력성으로 해석(%-%)
	
	// 알레라노-본드 추정량으로 구하기 - 알아서 도구변수를 넣어줌 //
	xtabond lnC lnP lnY lnPn, lags(1) nocons
	xtabond lnC lnP lnY lnPn, lags(1) nocons robust
	** robust 사용하면 오차항이 달라짐
	
	// 이 이후에 검정 두 가지를 시행해 볼 수 있음.
	// 1. sargan 검정(과대식별 적절성) // 
	quietly xtabond lnC lnP lnY lnPn, lags(1) nocons
	estat sargan
	**귀무가설은 과대식별이 적절하다는 것, 결과는 기각 -> 즉 적절하지 않음
	**도구변수의 수가 많을 경우 주의 필요(그룹 수보다 많으면 해석x)
	
	//2. 오차항의 자기상관 검정(변화량의 2계 자기상관을 확인하는 것으로 검정함) 
	quietly xtabond lnC lnP lnY lnPn, lags(1) nocons
	estat abond
	**델타 오차항에 2계자기상관이 없음 -> 괜찮은 것(오차항에 1계 자기상관이 없음)

	
	xtabond lnC lnP lnY lnPn, lags(1) nocons twostep robust
	**2-step 방법 사용 -> 점근적으로 더 효율적, bias 제거를 위해 robust 옵션 사용(수정된 표준오차)

	
	// xtabond2 패키지 설치 // 
	findit xtabond2

	xtabond2 lnC L.lnC lnP lnY lnPn, gmm(L.lnC) iv(lnP lnY lnPn) noleveleq /*
		*/nomata
	**설명변수에 L. 변수 직접 넣어줘야 함. 
	**gmm() 안에 GMM 추정할 변수 넣어줘야 함. 이 안에 넣은 변수의 L.연산자로 GMM추정을 실시함.
	**결과를 보면 L(2/).lnc == L(1.).L.lnc임
	*-> 즉 바로 이전의 결과(책 226페이지) 와 일치함

		
	quietly xtabond lnC lnP lnY lnPn, lags(1) nocons robust
	estat sargan

	xtabond2 lnC L.lnC lnP lnY lnPn, gmm(L.lnC) iv(lnP lnY lnPn) noleveleq /*
		*/nomata robust

	// 2-step 추정량 사용옵션 twostep	
	xtabond2 lnC L.lnC lnP lnY lnPn, gmm(L.lnC) iv(lnP lnY lnPn) noleveleq /*
		*/nomata robust twostep
// robust 조건에서도 검정결과를 제공한다는 장점 있음!



/* ===========================================================================*/
/* 14.3 System GMM 추정 ======================================================*/
/* ===========================================================================*/
	// system GMM 추정 -> 차분변수의 L. 변수 사용
	**간단하게 생각하면 추가적인 도구변수를(차분변수의 L.변수)를 사용하는 것
	xtdpdsys lnC lnP lnY lnPn, lags(1)

	
	//비교해보기(차분 GMM _vs_ 시스템 GMM) 
	quietly xtabond lnC lnP lnY lnPn, lags(1) nocons
	estimates store DIFF

	quietly xtdpdsys lnC lnP lnY lnPn, lags(1)
	estimates store SYS

	//비교결과 xml 표로 내보내기
	xml_tab DIFF SYS, below save(C:\Users\isoll\Documents\stata_output\diffsys.xml) replace

	
	quietly xtdpdsys lnC lnP lnY lnPn, lags(1)
	estat sargan

	quietly xtdpdsys lnC lnP lnY lnPn, lags(1)
	estat abond

	quietly xtdpdsys lnC lnP lnY lnPn, lags(1) vce(robust)
	estat abond

