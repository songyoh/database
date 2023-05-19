-- ORDER BY는 SELECT문의 질의결과를 정렬할때 사용한다.
-- ORDER BY절 다음에는 어떤 컬럼을 기준으로 어떤 방식으로 정렬할지 적어줘야 한다.

-- 다음은 user_tbl에 대해서 키순으로 내림차순 정렬한 예시다
SELECT * FROM user_tbl ORDER BY user_height DESC;

-- Q) user_tbl에 대해 키순으로 오름차순 정렬, 키가 동률이라면 체중순으로 내림차순 정렬
SELECT * FROM user_tbl order by user_height ASC, user_weight DESC;

-- 이름 가나다 순으로 정보를 정렬하되, un이라는 별칭을 활용해보자
SELECT user_num, user_name AS un, user_birth_year, user_address
FROM user_tbl
ORDER BY un DESC;

SELECT * FROM user_tbl;

-- 컬럼 번호를(왼쪽부터 1번으로 시작, 우측으로 갈수록 1씩 증가)이용해서 정렬 가능하다.
SELECT user_num, user_name AS un, user_birth_year, user_address
FROM user_tbl
ORDER BY 3 DESC;

-- 지역별 키 평균을 내림차순으로 정렬해보기
select user_address, avg(user_height)
from user_tbl
group by user_address  -- **별로 정렬
ORDER BY AVG(user_height) DESC; -- 정렬할 순서(내림차순,역순)

-- 경기 지역 사람들만 체중을 기준으로 내림차순 정렬
-- 나머지 지역은 정렬기준 없음
SELECT user_name, user_birth_year, user_address, user_height, user_weight
FROM user_tbl
ORDER BY
	CASE user_address -- 지역컬럼에서
		WHEN '경기' then user_weight
        else null
	end desc;

-- 생년이 1994인 사람만 키 순으로 나열해보기 내림차순(역순)
SELECT user_name, user_birth_year, user_address, user_height
from user_tbl
order by
	case user_birth_year
		when '1994' then user_height
        else null
	end desc;
    
-- 생년이 1992년인 사람은 키 기준 오름차순,
-- 생년이 1998인 사람은 이름 기준 오름차순으로 정렬하여 출력
-- 나머지는 null조건(조건적용 X)
select user_name, user_birth_year, user_weight
from user_tbl
order by
	case user_birth_year
		when 1992 then user_weight
        when 1998 then user_name
        else null
	end asc;
