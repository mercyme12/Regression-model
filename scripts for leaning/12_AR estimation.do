
********************************************************************************
******       Chapter 12. 기본가정 위배 1: AR(1) 오차항 pp.181~188         ******
********************************************************************************

cd "C:\Users\my\Documents\stata"

/* 12.1 기본 모형 및 추정방법 ================================================*/


/* 12.2 모형 추정 ============================================================*/

	use P_data12_1, clear
	tsset company year

	xtserial invest mvalue kstock
///xtserial은 패널 선형회귀모형의 오차항 e에 자기상관이 있는지 검정하기 위한 명령문 검정결과 귀무가설이 기각되어 1계 자기상관이 존재함을 확인함. 

	xtregar invest mvalue kstock, fe
///1계 자기상관이 존재함 확인 후 고정효과 모형을 추정하기 위해 xtregar 명령어 사용, fe 추가 

	bysort company: egen float mean_invest = mean(invest)
	bysort company: egen float mean_mvalue = mean(mvalue)
	bysort company: egen float mean_kstock = mean(kstock)

	gen invest1=invest - mean_invest
	gen mvalue1=mvalue - mean_mvalue
	gen kstock1=kstock - mean_kstock
///8장에서 실시한 within모형 형성 방식과 동일(p.114-115 확인)

	prais invest1 mvalue1 kstock1, nolog nocons rhotype(dw)
///자기상관을 보정한 형태의 회귀분석 실시를 통해 p 구하기 

/* ===========================================================================*/
/* TIP12.1 estimates table 명령어 활용 =======================================*/
/* ===========================================================================*/
	use P_data12_1, clear
	tsset company year
	quietly xtreg invest mvalue kstock, fe
	estimates store FE
	quietly xtregar invest mvalue kstock, fe
	estimates store FE_AR
	estimates table FE FE_AR, b(%9.3f) se(%9.3f)

	estimates table FE FE_AR, b(%9.3f) se(%9.3f) stat(sigma_u sigma_e /*
		*/rho rho_fov rho_ar)
///estimates store은 회귀식의 결과를 저장하는 명령어, 
///xtreg 회귀는 fe로 저장하고 xtregar회귀(자기상관을 가정한 회귀)는 fe_ar로 저장 

/* ===========================================================================*/
/* 12.2 모형 추정 ============================================================*/
/* ===========================================================================*/
	use P_data12_2, clear
	tsset idcode year
	xtregar ln_wage ttl_exp tenure black, re

	xtregar ln_wage ttl_exp tenure black, fe lbi

	xtregar ln_wage ttl_exp tenure black, re lbi
