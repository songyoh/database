-/*
	조인(JOIN)
    2개 이상의 테이블을 결합, 여러 테이블에 나누어 삽입된 연관된 데이터를 결합해주는 기능
    같은 내용의 컬럼이 존재해야만 사용할 수 있음.
    
    SELCET 테이블1.컬럼1, 테이블1.컬럼2 ... 테이블2.컬럼1, 테이블2.컬럼2...
    FROM 테이블1 JOIN 구문 테이블2
    ON 테이블1.공통컬럼 = 테이블2.공통컬럼;
    
    WHERE구문을 이용해 ON절로 합쳐진 결과 컬럼에 대한 필터링이 가능하다.
*/

-- 예제 데이터를 삽입하기 위한 테이블 2개 생성(외래키는 걸지 않겠습니다.)
CREATE TABLE member_tbl (
	mem_num INT PRIMARY KEY AUTO_INCREMENT,
    mem_name VARCHAR(10) NOT NULL,
    mem_addr VARCHAR(10) NOT NULL
    );
CREATE TABLE purchase_tbl (
	pur_num INT PRIMARY KEY AUTO_INCREMENT,
    mem_num INT,
    pur_date DATETIME DEFAULT now(),
    pur_price INT
);

-- 예제 데이터 삽입
INSERT INTO member_tbl VALUES
	(null, '김회원','서울'),
	(null, '박회원','경기'),
    (null, '최회원','제주'),
    (null, '박성현','경기'),
    (null, '이성민','서울'),
    (null, '강영호','충북');

-- 구매 데이터 삽입
INSERT INTO purchase_tbl VALUES
	(null, 1, '2023-05-12',50000),
    (null, 3, '2023-05-12',20000),
    (null, 4, '2023-05-12',10000),
    (null, 1, '2023-05-13',40000),
    (null, 1, '2023-05-14',30000),
    (null, 3, '2023-05-14',30000),
    (null, 5, '2023-05-14',50000),
    (null, 5, '2023-05-15',60000),
    (null, 1, '2023-05-15',15000);
    
SELECT * FROM member_tbl;
SELECT * FROM purchase_tbl;

SELECT member_tbl.mem_num, member_tbl.mem_name, member_tbl.mem_addr,
	purchase_tbl.pur_date, purchase_tbl.pur_num, purchase_tbl.pur_price
FROM member_tbl INNER JOIN purchase_tbl
ON member_tbl.mem_num = purchase_tbl.mem_num;

-- buy_tbl과 user_tbl을 조인해보자
-- user_tbl에서 조회할 컬럼 : user_name, user_address, user_num
-- buy_tbl에서 조회할 컬럼 : buy_num, prod_name, prod_cate, price, amount
SELECT user_tbl.user_name, user_tbl.user_address, user_tbl.user_num,
	buy_tbl.buy_num, buy_tbl.prod_name, buy_tbl.prod_cate, buy_tbl.price, buy_tbl.amount
FROM user_tbl INNER JOIN buy_tbl
ON user_tbl.user_num = buy_tbl.user_num;

-- 테이블명을 전부 적으면 구문이 길어지기 때문에, 테이블명을 별칭으로 줄여서 써보자
-- FROM절에서 테이블명 지정시 FROM 테이블명 별칭1 JOIN 테이블명 별칭2
-- 형식을 사용하면 별칭을 테이블명 대신 사용할 수 있다.
SELECT m.mem_num, m.mem_name, m.mem_addr,
	p.pur_date, p.pur_num, p.pur_price
FROM member_tbl m INNER JOIN purchase_tbl p
ON m.mem_num = p.mem_num;

-- buy_tbl과 user_tbl을 조인해보자
-- 이 문자에 대해서도 테이블 별칭을 사용해서 작성해보자
SELECT asdf.user_name, asdf.user_address, asdf.user_num,
	qwer.buy_num, qwer.prod_name, qwer.prod_cate, qwer.price, qwer.amount
FROM user_tbl asdf INNER JOIN buy_tbl qwer
ON asdf.user_num = qwer.user_num;

-- LEFT JOIN, RIGHT JOIN은 JOIN절 왼쪽이나 오른쪽 테이블은 전부 데이터를 남기고
-- 반대쪽 방향 테이블은 교집합만 남깁니다.
SELECT m.mem_num, m.mem_name, m.mem_addr,
	p.pur_date, p.pur_num, p.pur_price
FROM member_tbl m RIGHT JOIN purchase_tbl p
ON m.mem_num = p.mem_num;

-- RIGHT JOIN 확인을 위한 데이터 생성
INSERT INTO purchase_tbl VALUES
	(null, 8, '2023-05-16', 25000),
    (null, 9, '2023-05-16', 25000),
    (null, 8, '2023-05-17', 35000);
    
-- MySQL 에서는 FULL OUTER JOIN을 지원하지 않는다. 오라클에서만 실행가능
-- 따라서 UNION 구문을 응용해 처리한다.

-- 조인할 컬럼명이 동일하다면, ON 대신 USING(공통컬럼명) 구문을 대신 써도 된다.
SELECT m.mem_num, m.mem_name, m.mem_addr,
	p.pur_date, p.pur_num, p.pur_price
FROM member_tbl m RIGHT JOIN purchase_tbl p
USING (mem_num);

-- CROSS JOIN은 조인 대상인 테이블1과 테이블2간의 모든 ROW의 조합쌍을 출력한다.
-- 그래서 결과 ROW의 개수는 테이블1의 ROW개수 * 테이블2의 ROW개수가 된다.

-- 테스트 코드 돌려보고, 예제 테이블 재작성
SELECT * FROM
	user_tbl, buy_tbl;
SELECT count(*) FROM buy_tbl;

-- user_tbl 11개 로우, buy_tbl은 5개 로우 = 크로스조인 결과 로우는 55개
SELECT COUNT(*) FROM
	user_tbl CROSS JOIN buy_tbl;
    
SELECT u.user_num, b.buy_num FROM
	user_tbl u, buy_tbl b; -- ,로 나열시 cross join 구문 생략 가능

-- 좀 더 이해하기 쉬운 예시
CREATE TABLE phone_volume(
	volume VARCHAR(4), -- 폰 용량
    model_name VARCHAR(10)
);

CREATE TABLE phone_color(
	color VARCHAR(5)
);

INSERT INTO phone_volume VALUES
	(128, 'galaxy'),
    (256, 'galaxy'),
    (512, 'galaxy'),
    (1024, 'galaxy'),
    (128, 'iphone'),
    (256, 'iphone'),
    (512, 'iphone'),
    (1024, 'iphone');
    
INSERT INTO phone_color VALUES
	('빨강'),
    ('파랑'),
    ('노랑'),
    ('회색');
    
-- 크로스 조인 결과를 보면서 모든 조합쌍이 나왔는지 체크해보기
SELECT * FROM
	phone_volume CROSS JOIN phone_color;
    
-- self JOIN은 자기 테이블 내부 자료를 참조하는 컬럼이 있을때
-- 해당 자료를 온전하게 노출시키기 위해서 사용하는 경우가 대부분이다.
-- 예시로는 사원 목록 중 자기 자신과 직속상사를 나타내거나 게시판에서 원본글과 답변글을 나타내는 경우
-- 연관된 자료를 한 테이블 형식으로 조회하기 위해 사용한다.
CREATE TABLE staff(
	staff_num INT AUTO_INCREMENT PRIMARY KEY,
    staff_name VARCHAR(20),
    staff_job VARCHAR(20),
    staff_salary INT,
    staff_supervisor INT
);

INSERT INTO staff VALUES
	(null,'설민경','개발', 30000, NULL),
    (null,'윤동석','총무', 25000, NULL),
    (null,'하영선','인사', 18000, NULL),
    (null,'오진호','개발', 5000, 1),
    (null,'류민지','개발', 4500, 4),
    (null,'권기남','총무', 4000, 2),
    (null,'조예지','인사', 3200, 3),
    (null,'배성은','개발', 3500, 5);

-- SELF JOIN을 이용해 직원이름과 상사이름이 같이 나오게 만들어 보기
-- SELF JOIN은 테이블 자기 자신을 참조하도록 만들기 때문에
-- JOIN시 테이블명은 좌, 우 같은 이름으로, AS를 이용해서 부여한 별칭은 다르게 해서
-- 좌측과 우측 테이블을 구분하면 된다. 이외에는 모두 같다.
SELECT r.staff_num, l.staff_name AS 상급자명, r.staff_name AS 하급자명
FROM staff AS l INNER JOIN staff AS r
ON l.staff_num = r.staff_supervisor;

SELECT * FROM staff;

--

-- 고양이 테이블 생성
CREATE TABLE CAT (
	animal_name VARCHAR(20),
    animal_age INT,
    animal_owner VARCHAR(20),
    animal_type VARCHAR(20)
);
-- 강아지 테이블 생성
CREATE TABLE DOG (
	animal_name VARCHAR(20),
    animal_age INT,
    animal_owner VARCHAR(20),
	animal_type VARCHAR(20)
);

INSERT INTO cat VALUES
	('룰루', 4, '룰맘', '고양이'),
    ('어완자', 5, '양정', '고양이');
INSERT INTO dog VALUES
	('턱순이', 7, '이영수', '강아지'),
    ('구슬이', 8, '이영수', '강아지');
    
-- UNION으로 결과 합치기
SELECT * FROM CAT
UNION
SELECT * FROM DOG;

-- 

-- MySQL은 FULL OUTER JOIN을 UNION을 이용해 한다.
-- LEFT 조인 구문 UNION RIGHT 조인구문
-- 순으로 작성하면 된다. -- 방향만 반대로 하면 된다.
SELECT p.mem_num, m.mem_name, m.mem_addr,
		p.pur_date, p.pur_num, p.pur_price
FROM member_tbl m RIGHT JOIN purchase_tbl p
ON m.mem_num = p.mem_num

UNION

SELECT p.mem_num, m.mem_name, m.mem_addr,
		p.pur_date, p.pur_num, p.pur_price
FROM member_tbl m LEFT JOIN purchase_tbl p
ON m.mem_num = p.mem_num;