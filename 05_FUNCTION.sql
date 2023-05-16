-- 영어로 된 사람을 추가해보자
SELECT * FROM user_tbl;

INSERT INTO user_tbl VALUES
	(null, 'alex',1986,'LY', 173, '2020-11-01'),
    (null, 'Smith',1992,'Texas', 181, '2020-11-05'),
    (null, 'Emma',1995,'Tampa', 168, '2020-12-13'),
    (null, 'JANE',1996,'LA', 157, '2020-12-15');
    
-- 문자열 함수를 활용해서, 하나의 컬럼을 여러 형식으로 조회해보자
SELECT
	user_name,
	UPPER(user_name) AS 대문자유저명,
	LOWER(user_name) AS 소문자유저명,
	CHAR_LENGTH(user_name) AS 문자길이,
	SUBSTR(user_name, 1, 2) AS 첫글자두번째글자,
	CONCAT(user_name, '회원이 존재합니다.') AS 회원목록
FROM user_tbl;

-- 이름이 4글자 이상인 유저만 출력하기
-- LENGTH는 byte길이이므로 한글은 한 글자에 3바이트로 간주한다.
-- 따라서 CHAR_LENGTH()를 이용하면 그냥 글자숫자로 처리된다.
SELECT * FROM user_tbl
WHERE CHAR_LENGTH(user_name) > 3;

-- 함수 도움 없이 4글자만 뽑는 방법
SELECT * FROM user_tbl
WHERE user_name LIKE "____";

-- 함수 도움 없이 4글자 이상을 뽑는 방법
SELECT * FROM user_tbl
WHERE user_name LIKE "____%";

-- user_tbl에 소수점 아래를 저장받을 수 있는 컬럼 추가하기
-- DECIMAL은 고정자리수 이므로 반드시 소수점 아래 2자리까지 표기해야 합니다.
-- 전제 3자리중 소수점아래에 두 자리를 배정하겠다.
-- ALTER TABLE user_tbl ADD (user_weight DECIMAL(3,2)); 잘못된 코드
ALTER TABLE user_tbl MODIFY user_weight DECIMAL(5,2);
SELECT * FROM user_tbl;

UPDATE user_tbl SET user_weight = 81.5 WHERE user_num = 5;
UPDATE user_tbl SET user_weight = 60.2 WHERE user_num = 6;
UPDATE user_tbl SET user_weight = 63.7 WHERE user_num = 7;
UPDATE user_tbl SET user_weight = 72.93 WHERE user_num = 8;
-- UPDATE user_tbl SET user_weight = 58.86 WHERE user_num = 9; -- 나중에 수정.. 없는 케이스
UPDATE user_tbl SET user_weight = 55.52 WHERE user_num = 10;
UPDATE user_tbl SET user_weight = 50.13 WHERE user_num = 11;
UPDATE user_tbl SET user_weight = 70 WHERE user_num = 12;
UPDATE user_tbl SET user_weight = 53.33 WHERE user_num = 13;
UPDATE user_tbl SET user_weight = 52.12 WHERE user_num = 14;

-- 숫자 함수 사용 예제
SELECT
	user_name, user_weight,
    -- ROUND(user_weight,1) AS 키반올림,
    -- ROUND(user_weight,-1) AS 키반올림,
    ROUND(user_weight,0) AS 키반올림,
    TRUNCATE(user_weight,1) AS 키소수점아래_1자리절사,
    MOD(user_height, 150) AS 키_150으로나눈나머지,
	CEIL(user_weight) AS 키올림,
    FLOOR(user_weight) AS 키내림,
    SIGN(user_weight) AS 양수음수_0여부,
    SQRT(user_height) AS 키_제곱근
FROM
	user_tbl;
    
-- user_tbl의 날짜를 확인합니다.
SELECT * FROM user_tbl;

-- 날짜 함수를 활용한 예제
SELECT
	user_name, entry_date,
    DATE_ADD(entry_date, INTERVAL 3 MONTH) AS _3개월후,
    -- DATE_ADD(entry_date, INTERVAL 3 DAY) AS_3일후,
    -- DATE_ADD(entry_date, INTERVAL 15 DAY) AS_15일후,
    LAST_DAY(entry_date) AS 해당월마지막날짜,
    -- TIMESTAMPDIFF(MONTH, entry_date, now()) AS 오늘과의개월수차이
    TIMESTAMPDIFF(YEAR, entry_date, now()) AS 오늘과의년수차이
FROM
	user_tbl;
    
SELECT now(); -- 현재시각 리턴
commit;

-- 변환함수 활용 예제
SELECT
	user_num, user_name, entry_date,
    DATE_FORMAT(entry_date, '%Y%m%d') AS 일자표현변경,
    CAST(user_num AS CHAR) AS 문자로바꾼회원번호
FROM
	user_tbl;
    
-- user_height, user_weight이 NULL인 자료 추가
INSERT INTO user_tbl VALUES(null, '임쿼리', 1986, '제주', null, '2021-01-03', null);
SELECT * FROM user_tbl;

-- NULL(없다는 의미)에다가 특정 숫자 곱하기
SELECT 0 * null; -- 일반직군
SELECT 10000000 * 0.1; -- 영업직군

-- 최종수령금액은 기본급 + 인센
SELECT null + 5000000;
SELECT 1000000 + 5000000;

-- user_tbl 테이블 조회
SELECT * FROM user_tbl;

-- IFNULL을 이용해 특정 컬럼이 null인 경우 대체값으로 표현하는 예제
SELECT
	user_name, 
    ifnull(user_height, 167) as _null대체값넣은키,
    ifnull(user_weight,65) as _null대체값넣은체중
FROM
	user_tbl;

-- SQL에서 0으로 나누면 무슨일이 일어나는지 확인
SELECT 3 / 0;    

-- user_tbl의 회원들 중 키 기준으로 165미만은 평균미만, 165는 평균, 165이상은 평균이상으로 출력해보자
SELECT
	user_name,
    user_height,
    CASE
		WHEN user_height < 164 THEN '평균미만'
        WHEN user_height = 164 THEN '평균'
        WHEN user_height > 164 THEN '평균이상'
	END AS 키분류,
    user_weight
FROM user_tbl;

-- 문제
-- user_tbl에 대해, BMI지수를 구해보자
-- BMI지수 : (체중/ 키M 제곱)으로 구할 수 있다.
-- BMI지수의 결과를 18미만이면 '저체중', 18~24 '일반체충', 25이상이면 '고체중'으로
-- CASE 구문을 이용해서 출력. 
-- BMI지수를 나타내는 컬럼은 BMI_RESULT, MBI 분류를 나타내는 컬럼은 BMI_CASE
SELECT
	user_name,
    user_weight,
    user_height,
    user_weight / POW(user_height/100,2) AS BMI_RESULT1,
    CASE
		WHEN user_weight / POW(user_height/100,2) < 18 THEN '저체중'
        WHEN user_weight / POW(user_height/100,2) BETWEEN 18 AND 24 THEN '일반체중'
        -- WHEN 18 < user_weight / POW(user_height/100,2) < 24 THEN '일반체중'
		WHEN user_weight / POW(user_height/100,2) > 24 THEN '고체중'
	END AS BMI_RESULT
FROM user_tbl;
 
 SELECT * FROM user_tbl;
 