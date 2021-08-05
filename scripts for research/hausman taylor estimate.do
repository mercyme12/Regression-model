cd "C:\Users\LORDSHIP\Dropbox\08.개인 연구\개인 공부\고령화와 자동화"

use wps_v7_10_fe_re, clear

xtset id year, delta(2) yearly


*****HAUSEMAN TAYLOR ESTIMATE***
//전산교육
xtreg auto1 log50 log30 c.log50#i.educom c.log30#i.educom job educom comp_re workplace_age total_num_l workplace_type, fe //educom#c.log50이 0.1 수준에서 유의
outreg2 using myreg_0705_v5.doc, replace ctitle(Computertraining_FE) symbol(***, **, *, ^) alpha(0.001, 0.01, 0.05, 0.1) dec(3)
xtreg auto1 log50 log30 c.log50#i.educom c.log30#i.educom job educom comp_re workplace_age total_num_l workplace_type, re  //
outreg2 using myreg_0705_v5.doc, append ctitle(Computertraining_RE) symbol(***, **, *, ^) alpha(0.001, 0.01, 0.05, 0.1) dec(3)


qui xtreg auto1 log50 log30 c.log50#i.educom c.log30#i.educom job educom comp_re workplace_age total_num_l workplace_type, fe //educom#c.log50이 0.1 수준에서 유의
estimates store FE
qui xtreg auto1 log50 log30 c.log50#i.educom c.log30#i.educom job educom comp_re workplace_age total_num_l workplace_type, re  //
estimates store RE
hausman FE RE  //전산교육




//신규훈련
qui xtreg auto1 log50 log30 c.log50#i.trian2 c.log30#i.trian2 job trian2 comp_re workplace_age total_num_l workplace_type, fe   //educom#c.30이 0.05 수준에서 유의
estimates store FE

qui xtreg auto1 log50 log30 c.log50#i.trian2 c.log30#i.trian2 job trian2 comp_re workplace_age total_num_l workplace_type, re  //나이는 유의함.
estimates store RE

hausman FE RE  //신규훈련


********************FE RE MODEL************************
//전산교육 고정효과가 유의하다고 나옴.
xtreg auto1 log50 log30 c.log50#i.educom c.log30#i.educom job educom comp_re workplace_age total_num_l workplace_type, fe //educom#c.log50이 0.1 수준에서 유의
outreg2 using myreg_0705_v5.doc, replace ctitle(Computertraining_FE) symbol(***, **, *, ^) alpha(0.001, 0.01, 0.05, 0.1) dec(3)

xtreg auto1 log50 log30 c.log50#i.educom c.log30#i.educom job educom comp_re workplace_age total_num_l workplace_type, re  //
outreg2 using myreg_0705_v5.doc, append ctitle(Computertraining_RE) symbol(***, **, *, ^) alpha(0.001, 0.01, 0.05, 0.1) dec(3)



//신규훈련 랜덤효과가 유의하다고 나옴.

xtreg auto1 log50 log30 c.log50#i.trian2 c.log30#i.trian2 job trian2 comp_re workplace_age total_num_l workplace_type, fe   //educom#c.30이 0.05 수준에서 유의
outreg2 using myreg_0705_v6.doc, replace ctitle(Freshmentraining_FE) symbol(***, **, *, ^) alpha(0.001, 0.01, 0.05, 0.1) dec(3) // l1, 461, cook D

xtreg auto1 log50 log30 c.log50#i.trian2 c.log30#i.trian2 job trian2 comp_re workplace_age total_num_l workplace_type, re  //나이는 유의함.
outreg2 using myreg_0705_v6.doc, append ctitle(Freshmentraining_RE) symbol(***, **, *, ^) alpha(0.001, 0.01, 0.05, 0.1) dec(3) // l1, 461, cook D



