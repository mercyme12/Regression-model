********************************************************************************
********************************************************************************
******      Chapter 13. 기본가정 위배 2: 설명변수 내생성 pp.189~213       ******
********************************************************************************
********************************************************************************


****** ----------------------- Change Directory ------------------------- ******
	cd "C:\Users\Mercyme\Google 드라이브\[국제산업인력개발 연구실] 랩스\2. 통계학\[19.05]STATA 패널데이터 분석\데이터 파일"
****** ------------------------------------------------------------------ ******


/* ===========================================================================*/
/* 13.1 하우스만-테일러 추정 =================================================*/
/* ===========================================================================*/
	use P_data13_1, clear
	tsset id t

	quietly xtreg lwage occ south smsa ind exp exp2 wks ms union fem blk ed, fe
	estimates store FE
	quietly xtreg lwage occ south smsa ind exp exp2 wks ms union fem blk ed, re
	estimates store RE
	hausman FE RE, sigmamore

	xthtaylor lwage occ south smsa ind exp exp2 wks ms union fem blk ed, /*
		*/endog(exp exp2 wks ms union)

	quietly xtreg lwage occ south smsa ind exp exp2 wks ms union fem blk ed, fe
	estimates store FE
	quietly xtreg lwage occ south smsa ind exp exp2 wks ms union fem blk ed, re
	estimates store RE
	quietly xthtaylor lwage occ south smsa ind exp exp2 wks ms union fem /*
		*/blk ed, endog(exp exp2 wks ms union)
	estimates store HT
	estimates table FE RE HT, b(%9.3f) star(0.01 0.05 0.1)

	quietly xthtaylor lwage occ south smsa ind exp exp2 wks ms union fem /*
		*/blk ed, endog(exp exp2 wks ms union) amacurdy
	estimates store AM
	estimates table HT AM, b(%9.3f) star(0.01 0.05 0.1)


/* ===========================================================================*/
/* 13.2 고정효과 2단계 추정 ==================================================*/
/* ===========================================================================*/
	use P_data13_2, clear
	tsset id year
	xtivreg ln_wage age not_smsa (tenure = union south), fe first

	quietly xtivreg ln_wage age not_smsa (tenure = union south), fe first
	xtreg tenure union south age not_smsa if e(sample)==1, fe
	predict tenure_hat if e(sample)==1
	xtreg ln_wage tenure_hat age not_smsa if e(sample)==1, fe

	quietly xtreg ln_wage tenure age not_smsa, fe
	estimates store XTREG
	quietly xtivreg ln_wage age not_smsa (tenure = union south), fe
	estimates store XTIVREG
	hausman XTIVREG XTREG, sigmamore

	findit dmexogxt

	quietly xtivreg ln_wage age not_smsa (tenure = union south), fe
	dmexogxt


/* ===========================================================================*/
/* 13.3 1차 차분 2단계 추정 ==================================================*/
/* ===========================================================================*/
	use P_data13_3, clear
	tsset id year
	xtivreg n w k ys (L.n=L2.n), fd

	reg DL.n D.(L2.n w k ys)
	predict Dn1_hat
	reg D.n Dn1_hat D.(w k ys)

	quietly xtivreg n w k ys (L.n=L2.n), fd reg
	estimates store FD_REG

	quietly xtivreg n w k ys (L.n=L2.n), fd
	estimates store FD2SLS

	quietly xtivreg n w k ys (L.n=L2.n), fe
	estimates store FE2SLS

	estimates table FD_REG FD2SLS FE2SLS, b(%9.3f) star(0.01 0.05 0.1)


/* ===========================================================================*/
/* 13.4 확률효과 2단계 추정 ==================================================*/
/* ===========================================================================*/
	use P_data13_4, clear
	tsset idcode year
	xtivreg ln_wage age not_smsa black (tenure = union birth_yr south), re
	xtivreg ln_wage age not_smsa black (tenure = union birth_yr south), re /*
		*/ec2sls

	quietly xtreg ln_wage age not_smsa black tenure, re
	estimates store XTREG_RE

	quietly xtivreg ln_wage age not_smsa black (tenure = union birth_yr /*
		*/south), re
	estimates store G2SLS

	quietly xtivreg ln_wage age not_smsa black (tenure = union birth_yr /*
		*/south), fe
	estimates store FE2SLS

	estimates table XTREG_RE G2SLS FE2SLS, b(%9.3f) star(0.01 0.05 0.1)

	hausman G2SLS XTREG_RE

	hausman FE2SLS G2SLS


/* ===========================================================================*/
/* 13.5 사후 분석 ============================================================*/
/* ===========================================================================*/
	quietly xtivreg ln_wage age not_smsa black (tenure = union birth_yr /*
		*/south), fe
	predict yhat
	predict resid_u, u
	predict resid_e, e
	predict xb_u, xbu
	list ln_wage yhat resid_u resid_e xb_u nooption if id==1, sep(0)

	use P_data13_5, clear
	tsset company year
	quietly xtivreg invest mvalue kstock (L.invest=L2.invest), fd
	predict yhat_fd

	gen d_invest=D.invest
	list company year invest d_invest yhat_fd in 1/10, sep(0)
