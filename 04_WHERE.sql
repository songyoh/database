-- user_tbl을 사용할 것
SELECT * FROM user_tbl;

-- 수도권(서울, 경기)에 사는 사람을 쿼리문 하나로 조회해보기
SELECT * FROM user_tbl 
WHERE user_address = '서울' OR user_address = '경기';

-- IN문법은 IN다음에 오는 리스트 목록에 포함된 요소만 출력해준다.
SELECT * FROM user_tbl
WHERE user_address IN ('서울', '경기');

-- IN 문법을 응용하여 구매내역이 있는 user만 출력
SELECT user_num FROM buy_tbl; -- 왼쪽 구문이 구매자 번호만 나타내는 리스트이므로

-- 서브쿼리를 활용한 조회구문.
SELECT * FROM user_tbl WHERE user_num IN (SELECT user_num FROM buy_tbl);

-- like구문은 패턴 일치 여부를 통해서 조회한다.
-- %는 와일드카드 문자로, 어떤 문자가 몇 글자가 와도 좋다는 의미
-- _는 와일드카드 문자로, _하나당 1글자씩을 처리한다.
-- 이름이 "희"로 끝나는 사람 조회
SELECT * FROM user_tbl WHERE user_name like '%희';

-- "XX남도"에 사는 사람만 조회
SELECT * FROM user_tbl WHERE user_address like '_남'; 

-- 이름이 "자바"인 사람만 조회
SELECT * FROM user_tbl WHERE user_name like '_자바';
SELECT * FROM user_tbl WHERE user_name like '%자바';

-- 키가 170~180인 사람만 조회하기.
SELECT * FROM user_tbl WHERE user_height BETWEEN 170 AND 180;

-- AND를 이용해서 동일한 조건의 쿼리문 작성해보기
SELECT * FROM user_tbl WHERE user_height > 169 AND user_height < 181;

-- NULL을 가지는 데이터 생성
INSERT INTO user_tbl VALUES
		(null, '박진영', 1990, '제주', null, '2020-10-01'),
        (null, '김혜경', 1992, '강원', null, '2020-10-02'),
        (null, '신지수', 1993, '서울', null, '2020-10-05');
        
SELECT * FROM user_tbl;   

-- NULL인 자료들만 얻어내기 위해서 WHERE절에 컬럼명 IS NULL;을 사용한다.
SELECT * FROM user_tbl WHERE user_height = NULL; -- 실행불가
SELECT * FROM user_tbl WHERE user_height IS NULL;
