/* 좌측의 SCHEMAS의 DATABASE는 더블클릭이나 우클릭으로도 호출할 수 있지만
use DB명;을 수행해 호출 할 수도 있습니다.*/

-- Workbench(윈도우)에서 수행가능한 구문은 거의 모두 CLI환경에서 수행 가능합니다.
-- DATABASE 변경 구문;
use sys; -- use bitcamp06;

/* DATABASE 정보 조회 */
show DATABASES;

/* 테이블 생성*/
CREATE TABLE user_tbl(
	user_num int(5) PRIMARY KEY AUTO_INCREMENT, -- INSERT시 숫자 자동배정
    user_name varchar(10) NOT NULL,
	user_birth_year int NOT NULL,
    user_address char(5) NOT NULL,
    user_height int, -- 자리수 제한 없음
    entry_date date -- 회원가입일 
);

/* 특정 테이블은 원래 조회할 때 SELECT * FROM 데이터베이스명.테이블명; 형식으로
조회해야 합니다. 그러나 use 구문 등을 이용해 데이터베이스를 지정한 경우는 데이터베이스를
생략할 수 있습니다*/
SELECT * FROM bitcamp06.user_tbl;
use bitcamp06;
				-- pk가 걸린 컬럼은 null을 주면 알아서 숫자 배정
INSERT INTO user_tbl VALUES(null, '김자바', 1987, '서울', 180, '2020-05-03');
INSERT INTO user_tbl VALUES(null, '이연희', 1992, '경기', 164, '2020-05-12');
INSERT INTO user_tbl VALUES(null, '박종현', 1990, '부산', 177, '2020-06-01');
INSERT INTO user_tbl
	(user_name,user_birth_year, user_address,user_height,entry_date)
	VALUES('신영웅',1995,'광주',172,'2020-07-15');

-- WHERE 조건절을 이용해서 조회해보겠습니다.
-- 90년대 이후 출생자만 조회하기   user_birth_year가 1989보다 큰 유저만
SELECT * FROM user_tbl WHERE user_birth_year > 1989;
-- 키 175 미만만 조회하는 SELECT 구문을 만들어보기
SELECT *FROM user_tbl WHERE user_height < 175;
-- AND 혹은 OR을 이용해 조건을 두 개 이상 걸수도 있습니다.
SELECT * FROM user_tbl WHERE user_num > 2 AND user_height < 178;
commit;

-- UPDATE 테이블명 set 컬럼명1=대입값1, 컬럼명2=대입값2.....;
-- 주의! WHERE를 걸지 않으면 해당 컬럼의 모든 값을 다 통일시켜버립니다.
UPDATE user_tbl SET user_address = '서울';

-- WHERE절 없는 UPDATE 구문 실행 방지, 0 대입시 해제, 1대입시 실행
set sql_safe_updates=1; 

-- 테이블이 존재하지 않다면 삭제구문을 실행하지 않아 에러를 발생시키지 않음
DROP TABLE IF EXISTS user_tbl;

SELECT * FROM user_tbl;

-- 김자바의 주소를 서울에서 강원으로 바꿔보자
UPDATE user_tbl SET user_address = '강원' WHERE user_num = 1;

-- 삭제는 특정 컬럼만 떼서 삭제할 일이 없으므로 SELECT와는 달리 * 등을 쓰지 않습니다.
-- 박종현이 DB에서 삭제되는 상황
commit;
-- 박종현이 DB에서 삭제되는 상황, safety 모드를 우회하거나 cli에서 해주세요.
DELETE FROM user_tbl WHERE user_name = '박종현';

-- 만약 WHERE없이 삭제시 truncate와 비슷하게 작동합니다.
DELETE FROM user_tbl;

-- 다중 INSERT구문을 사용해보겠습니다.
/* INSERT INTO 테이블명(컬럼1,컬럼2,컬럼3...)
	VALUES(값1,값2,값3...),
		  (값4,값5,값6...),
          (값7,값8,값9...),
          ...;
컬럼명은 모든 컬럼에 값을 집어넣을시 생략 가능합니다.*/
INSERT INTO user_tbl
	VALUES(null,'강개발', 1994, '경남', 178, '2020-08-02'),
		  (null, '최지선', 1998, '전북', 179, '2020-08-03'),
          (null, '류가연', 2000, '전남', 158, '2020-08-20');
SELECT * FROM user_tbl;
commit;
      
-- INSERT~SELECT를 이용한 데이터 삽입을 위해 user_tbl과 동일한 테이블을 하나 더 만듭니다.
CREATE TABLE user_tbl2(
	user_num int(5) PRIMARY KEY AUTO_INCREMENT, -- INSERT시 숫자 자동배정
    user_name varchar(10) NOT NULL,
	user_birth_year int NOT NULL,
    user_address char(5) NOT NULL,
    user_height int, -- 자리수 제한 없음
    entry_date date -- 회원가입일 
);

-- user_tbl2에 user_tbl의 자료 중 생년 1995년 이후인 사람의 자료만 복사해여 삽입하기
INSERT INTO user_tbl2
	SELECT * FROM user_tbl
    WHERE user_birth_year > 1995;
SELECT * FROM user_tbl WHERE user_birth_year > 1995;
SELECT * FROM user_tbl2;
commit;

-- 두 번째 테이블인 구매내역을 나타내는 buy_tbl을 생성해보겠습니다.
-- 어떤 유저가 무엇을 샀는지 저장하는 테이블
-- 어떤 유저는 반드시 user_tbl에 존재하는 유저만 추가할 수 있습니다.
CREATE TABLE buy_tbl (
	buy_num INT AUTO_INCREMENT PRIMARY KEY,
    user_num INT(5) NOT NULL,
    prod_name varchar(10) NOT NULL,
    prod_cate varchar(10) NOT NULL,
    price INT NOT NULL,
    amount INT NOT NULL
);

-- 외래키 설정없이 추가해보겠습니다.
INSERT INTO buy_tbl VALUES(null, 4, '아이패드', '전자기기', 100, 1);
INSERT INTO buy_tbl VALUES(null, 4, '애플펜슬', '전자기기', 15, 1);
INSERT INTO buy_tbl VALUES
	(null, 6, '트레이닝복', '의류', 10, 2),
	(null, 5, '안마의자', '의료기기', 400, 1),
	(null, 2, 'SQL책', '도서', 2, 1);

DELETE FROM buy_tbl WHERE buy_num = 6;
-- 이제 외래키 설정을 통하여 있지 않은 유저는 등록될 수 없도록 처리하겠습니다.
-- buy_tbl이 user_tbl을 참조하는 관계임.
		-- 참조하는									-- 참조자의 어떤 컬럼
ALTER TABLE buy_tbl ADD CONSTRAINT FK_buy_tbl FOREIGN KEY (user_num)
		-- 참조당하는 테이블과 컬럼명
	REFERENCES user_tbl(user_num);
commit;
    
-- 참조가 끝난 상태에서 있지도 않은 199번 유저의 구매내역을 넣어보겠습니다.
INSERT INTO buy_tbl VALUES(null, 199, '오픈카', '승용차', 1000, 5);   
DELETE FROM buy_tbl WHERE buy_num = 8; 

SELECT * FROM buy_tbl;

-- user_tbl을 삭제했다 재생성 했는데 user_num이 1번부터 시작한게 아닌상황으로
-- buy_tbl상의 포렌키가 인식 되지 않는 상황이었음. 결국 UPDATE구문을 사용하여 회원번호를 변경했다.
UPDATE buy_tbl -- 변경될 테이블
SET user_num = 9 -- 기존에 관리하고 있는 유저 번호
WHERE buy_num = 5; -- buy_num의 바꿔질 회원번호

commit;

SELECT * FROM buy_tbl;
SELECT * FROM user_tbl;
-- 만약 user_tbl에 있는 요소를 삭제시, buy_tbl에 구매내역이 남은 user_num을 삭제한다면
-- 특별히 on_delete를 걸지 않은 경우는 참조 무결성 원칙에 위배되어 삭제가 되지 않습니다.
DELETE FROM user_tbl WHERE user_num=8;

-- 만약 추가적인 설정 없이 user_tbl의 8번 유저를 삭제하고 싶다면
-- 먼저 buy_tbl의 8번 유저가 남긴 구매내역을 모두 삭제해야 합니다.
DELETE FROM buy_tbl WHERE buy_num = 2;
