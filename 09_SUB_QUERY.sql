-- SUB QUERY란 쿼리문 내에 쿼리문을 중첩하는 것이다.
-- 기본적으로 SELECT문의 범위를 좁히는 경우 많이 사용한다.

-- 회원별 평균 키를 구하는 GROUP BY구문을 수행해보자
/*SELECT user_name, AVG(user_height) FROM user_tbl
GROUP BY user_name; 전체회원의 평균키를 알 수 없다.*/ 
SELECT AVG(user_height) FROM user_tbl;

-- 위에서 설명했듯, GROUP BY는 우선 동명이인이 있을 경우 동명이인을 하나의 집단으로 보기때문에 문제가 되고
-- 하나의 테이블에 전체 평균을 넣을 수 없다.
-- 이 경우 서브쿼리를 이요하면 된다. -- 괄호안쪽부터 실행된다.
SELECT AVG(user_height) FROM user_tbl;
SELECT user_name, (SELECT AVG(user_height) FROM user_tbl) as avg_height -- SELECT user_name, (SELECT 170.8000) as avg_height
FROM user_tbl; -- 안쪽 괄호의 값이 평균값으로 계산된 170.8000로 보면 된다.

-- FROM절 SUB QUERY를 활용한 범위좁히기 개념에 대해 알아보자.
-- FROM절 다음에는 테이블명만 올 수 있는게 아니고, 데이터 시트형식을 갖춘 자료라면
-- 모든 형태의 자료를 적어줄 수 있다.
-- user_tbl중 키가 170미만인 요소만 1차적으로 조회한 결과시트를 토대로 전체데이터를 조회하는 구문이다.
-- FROM절 SUB QUERY를 활용할 때는 별칭을 무조건 붙여야 한다.
SELECT A.* FROM (SELECT * FROM user_tbl WHERE user_height < 170) A;
SELECT * FROM user_tbl;
-- SUB QUERY의 실제 활용 : 신영웅보다 키가 큰 사람을 한 줄로 결과 얻기
-- 기존방식으로 처리하는 경우
-- 1. 신영웅의 키를 WHERE절을 이용해 확인
SELECT user_height FROM user_tbl WHERE user_name='신영웅';

-- 2. 얻은 172를 토대로 쿼리문에 다시 WHERE절로 집어넣어 조회
SELECT * FROM user_tbl WHERE user_height > 172;

-- 개선 방안 : WHERE절에 user_height > (서브쿼리로 신영웅의 키를 구해보자);
-- 힌트 : 셀 하나에 172만 나오게 서브쿼리 부분 작성해보기
-- 1. 최지선의 키만 나오는 구문 작성
SELECT user_height FROM user_tbl WHERE user_name = '신영웅';
-- 2. SELECT * FROM user_tbl WHERE user_height > (1에서 구한 쿼리문);
SELECT * FROM user_tbl WHERE user_height > (SELECT user_height FROM user_tbl WHERE user_name = '신영웅');

-- 위 코드를 참조하여 평균보다 체중이 낮은 사람만 조회하는 쿼리문을 서브쿼리를 활용해 작성해보기
SELECT AVG(user_weight) FROM user_tbl; -- 평균체중 : 61.829키로
SELECT * FROM user_tbl WHERE user_weight < (SELECT AVG(user_weight) FROM user_tbl);

-- 지역이 '경기'인 사람들 중 키가 제일 큰 사람보다 키가 더 큰 사람을 조회해보자
SELECT MAX(user_height) FROM user_tbl WHERE user_address = '경기';
SELECT * FROM user_tbl WHERE user_height > (SELECT MAX(user_height) FROM user_tbl WHERE user_address = '경기');

-- 전체 평균보다 키가 큰 지역에 속하는 유저만 출력하기(해당 구문 생각해보고 분석도 해보기)
SELECT * FROM user_tbl -- 전체 테이블에서1
	WHERE user_address IN -- user_address가2
    (SELECT user_address FROM user_tbl -- 키가 큰 지역4
    WHERE user_height > (SELECT AVG(user_height) FROM user_tbl) -- 전체키 전체평균보다3
GROUP BY user_address);	