//chap.05 그래프그리기//

cd "C:\Users\Owner\Google 드라이브\[국제산업인력개발 연구실] 랩스\2. 통계학\[19.05]STATA 패널데이터 분석\데이터 파일"

//5.1 tsline : 패널개체별로 시계열 데이터 변화 그래프로 확인
use P_data5_1.dta, clear

//균형패널 확인하기
tsset firm year

//invest 변수의 시계열 그래프 그리기 (1,2번 회사, 2번은 선모양 다르게)
db tsline

twoway (tsline invest if firm==1) (tsline invest if firm==2, lpattern(longdash))
//범례 바꾸기
twoway(tsline invest if firm==1)(tsline invest if firm==2, lpattern(longdash)), ///
 legend(order(1 "firm=1" 2 "firm=2"))

 *모든 회사를 각자 그리는 경우
 db tsline
 twoway (tsline invest), by(firm)
 * 회사마다 y축 다르게
 twoway (tsline invest), by(firm, yrescale)

 ///xtline  
 
 tsset firm year
 *회사별로 f, c를 각각 그려줌!
 db xtline
 
 xtline f c
 * 선의 종류 다르게 lpattern(첫번째 변수 적용 선, 두번째 변수 적용 선)
 xtline f c, recast(line) lpattern(solid longdash)
 
 *y축 다르게
 xtline f c, byopts(yrescale) recast(line) lpattern(solid longdash)
 
 *s2mono scheme : 변수마다 선 모양을 다르게 지정해주는 2번째 방식
 xtline f c, scheme(s2mono)
 
 *xtline 이용 여러 개체를 한꺼번에 그래프에 표현
 xtline f, overlay
 *xtline overlay시 선 유형을 다르게
 xtline f, overlay scheme(s2mono)
 
 
 use P_data5_2.dta, clear
 
 xtline calories, overlay scheme(s2mono)
 
 * x 축에 시간표시를 반복되는 연도(2002) 제거하고 싶을 때
 xtline calories, overlay tlabel(, format(%tddm)) scheme(s2mono)
 
 
///xtgraph : 패널 평균값 및 신뢰구간을 시계열로 그려줌
findit xtgraph

use P_data5_1.dta, clear

tsset firm year

*연도별 변수(invest) 평균값 +신뢰구간 표시, list : 각 연도 평균 및 그 신뢰구간 표로 제시
xtgraph invest, list
*수동으로 게산시, 신뢰구간 구하기 : ci
ci means invest if year==1935

** 각 회사에 따른 20년간 평균 값 + 신뢰구간 구할때 : tsset에서 개체, 시간 변수 순서 바꾸기!
tsset year firm

xtgraph invest
