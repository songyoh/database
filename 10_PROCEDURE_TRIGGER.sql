/*MySQL에서도 프로그래밍이 가능하다.
 JAVA, PYTHON등과 달리 제약이 많지만 반복 작업을 줄여줄 수 있다는 점에서 많이 사용한다.*/
 /* <MySQL에서 변수 사용하기>
 변수를 지정할때는 SET @변수명 = 값;의 문법을 사용한다.*/
 SET @myVar1 = 5;
 SET @myVar2 = 3;
 SET @myVar3 = 4.25;
 SET @myVar4 = '유저명: ';
 SET myVar5 = 50; -- 변수명 왼쪽에 @를 작성 안하게 된다면..?
 
 -- 출력은 SELECT @변수명;을 사용
 SELECT @myVar1 + @myVar2 - @myVar3;
 
-- 테이블을 조회하던 SELECT 구문 처럼 콤마,로 여러 데이터를 반환 가능
SELECT @myVar4, user_name FROM user_tbl;

/*PREPARE 구문
PREPARE 구문에 가변적으로 입력되는 문장요소의 자리에 ?를 입력하고, 그 자리를 EXECUTE 구문으로 채움
PREPARE 구문이름 '실제 쿼리문'; 으로 선언한다.
EXECUTE 구문이름 USING 전달 변수; 로 호출한다.*/
-- 어떤 값이 오는지 모르는 상황에서 구문 만들 때
SET @myVar5 = 3;
PREPARE myQuery
	FROM 'SELECT user_name, user_height FROM user_tbl LIMIT ?';
SELECT user_name, user_height FROM user_tbl LIMIT 5; -- LIMIT는 상위 n개만 보여주기

EXECUTE myQuery USING @myVar5;

-- 조건문 사용하기 (WHEN THEN 구문)
/* IF(수식, 참일때 리턴, 거짓일때 리턴)
삼항 연산자와 비슷하게 판단 - 조건문 ? 참리턴값 : 거짓리턴값 */
SELECT IF(100>200, 'true', 'false') AS 판단;

/*<SQL 프로그래밍과 프로시저>
함수 : 대체로 매개변수와 반환값을 모두가지면 함수로 선언
프로시저 : 매개변수는 존재하나 반환값이 없고, 특정 로직만 처리할 때 주로 선언
DELIMITER는 JAVA의 Main Method와 같은 역할을 함

DELIMITER $$ -- 시작지점
CREATE PROCEDURE 선언할프로시저명()
BEGIN -- 본 실행코드는 BEGIN 아래에 작성
	실행코드들...
END $$
DELIMITER ; -- 띄어쓰기 주의!!!
위와 같이 선언된 프로시저는
CALL 프로시저명(); 으로 호출*/

-- IF~ELSE문을 프로시저로 작성
DELIMITER $$ -- 프로시저 구역 선언(DDL), 리턴이 없는 경우 대부분 쓴다
CREATE PROCEDURE IFProc()
BEGIN
	DECLARE var1 INT; # 프로시저 내 주석은 #처리. DECLARE는 변수 선언문
    SET var1 = 100; # 위에 var1 INT 로 선언된 변수에 100 대입
    IF var1 = 100 THEN
		SELECT 'THIS IS 100';
	else
		SELECT 'THIS IS NOT 100';
	END IF;
END $$
DELIMITER ;

CALL ifProc();

-- 테이블 호출 구문을 프로시저로 작성
DELIMITER $$
CREATE PROCEDURE getUser()
BEGIN
	SELECT * FROM user_tbl;
END $$
DELIMITER ;

CALL getUser();

-- 프로시저를 생성하기 -> 프로시저의 이름은 getOverAvgHeight()로 생성
-- 평균보다 키 큰 사람 전체 목록을 호출해주는 프로시저
SELECT AVG(user_height) FROM user_tbl;
SELECT * FROM user_tbl WHERE user_height > (SELECT AVG(user_height) FROM user_tbl);

DELIMITER $$
CREATE PROCEDURE getOverAvgHeight()
BEGIN
	SELECT * FROM user_tbl WHERE user_height > (SELECT AVG(user_height) FROM user_tbl);
END $$
DELIMITER ;
-- 위에서 생성한 getOverAvgHeight() 프로시저 호출
CALL getOverAvgHeight();

-- 프로시저 삭제시 DROP PROCEDURE 프로시저명; -- ()는 사용하지 않는다.
-- 특정 프로시저는 DB에 소속된 것이기 때문에 DB가 먼저 선택되어야 명령을 수행한다.
DROP PROCEDURE ifProc;
DROP PROCEDURE getUser;
DROP PROCEDURE getOverAvgHeight;

-- 프로시저 목록 조회하기 : 모든 DB 통합
 SHOW PROCEDURE STATUS;
 -- 프로시저 목록 조회 : 특정 DB만
 SHOW PROCEDURE status WHERE db = 'bitcamp06';
 
 /* 프로시저를 활용해
 user_tbl 6번 회원의 회원가입일 3년 경과 여부 확인하기*/
 SELECT * FROM user_tbl;
 
 DELIMITER $$
 CREATE PROCEDURE getSix()
 BEGIN
	DECLARE entryDate DATE; # 날짜 판독을 위한 저장변수 선언
    DECLARE todayDate DATE; # 오늘 날짜 저장변수 선언
    DECLARE days INT; # 경과일수 저장변수 선언
    
    SELECT entry_date INTO entryDate # 쿼리분의 결과로 나온 값을 entryDate 변수에 대입 (이 구문은 외우기!!!!!)
		FROM user_tbl WHERE user_num = 6; # 6,7번 user 불러오는 구문
	SET todayDate = CURRENT_DATE(); # 오늘날짜를 얻어오는 내장함수, 오늘날짜(연,월,일)만 얻어옴
    SET days = DATEDIFF(todayDate, entryDate); # 경과 일수 구하기(todayDate - entryDate)
    
    IF(days/365) >= 3 THEN # 가입이 3년이상이 되었는지 확인
		SELECT CONCAT('가입한지', days, '일이 경과했습니다.');
	ELSE
		SELECT CONCAT('가입일은 3년 미만이며', days,'일이 경과했습니다.');
	END IF;
END $$
DELIMITER ;
# 주석
 CALL getSix();
 DROP PROCEDURE getSix; -- 프로시저에 유저번호를 바꿔보고 싶을때 프로시저를 삭제 -> user_num의 숫자 변경 ->프로시저 생성 ->  CALL getSix();
 
 /* IF THEN 구문 이후에 ELSE 가 아닌 ELSEIF ~ THEN 을 작성하면 두 개 이상의 조건을 입력할 수 있음
getScore 프로시저 생성
변수 point(INT)는 점수를 입력받는데, 77점을 입력하고
변수 ranking(CHAR)는
	90점 이상이면 'A'를 저장
    80점 이상이면 'B'를 저장
    70점 이상이면 'C'를 저장
    60점 이상이면 'D'를 저장
    그 이하 점수는 'F'를 저장
IF 구문 종료 후 SELECT 구문과 CONCAT()을 활용해서
취득점수: 77, 학점: C라는 구문을 콘솔에 출력 */

DELIMITER $$
 CREATE PROCEDURE getScore()
 BEGIN
	DECLARE point INT; # 점수 입력 변수선언
    DECLARE ranking CHAR; # 점수별 성적 변수선언
    SET point = 77;
    
	IF point >= 90 THEN
		SET ranking = 'A';
	ELSEIF point >= 80 THEN
		SET ranking = 'B';
	ELSEIF point >= 70 THEN 
		SET ranking = 'C';
	ELSEIF point >= 60 THEN 
		SET ranking = 'D';
	ELSEIF point < 60 THEN
		SET ranking = 'F';
	END IF;
    
    SELECT CONCAT('취득점수:', point, ',학점:', ranking);
END $$
DELIMITER ;

CALL getScore();

/* SQL에서 WHILE 구문 작성
WHILE(조건식) DO
	실행문...
END WHILE;
조건식이 특정 조건을 만족시키지 못하면 WHILE 구문을 탈출하도록 함*/

DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
    DECLARE i INT; -- i 변수값으로 반복횟수를 조절
    SET i = 1; -- i가 1부터 시작해서
    
    WHILE i <= 30 DO -- i에 저장된 값이 30까지 반복하는 동안
        SET i = i + 1; -- 1씩 증가시키며 누적합 구하기
    END WHILE;
    
    SELECT i;
END $$
DELIMITER ;
CALL whileProc();

/* 3+6+9+12+ ...와 같은 방식으로
3부터 99까지 더했을때, 총합을 SELECT 구문으로 프로시져 작성 후 호출
프로시저명은 sum3nProc() */
DELIMITER $$
CREATE PROCEDURE sum3nProc()
BEGIN
	DECLARE j INT; -- 몇바퀴인지 체크
    DECLARE sum INT; -- 총합 누적 저장
    SET j = 3; -- j(count)가 3일때
    SET sum = 0;
    
    WHILE j <= 99 DO -- count < 33회(33*3=99)
		SET sum = sum + j; -- SET count = count +1;
		SET j = j + 3; -- SET totalsum = totalsum + (count * 3);
	END WHILE;
    
    SELECT CONCAT('100보다 작은 3의 배수의 총합: ', sum);
END $$
DELIMITER ;
CALL sum3nProc();


/* 프로시저 getSix()의 문제점은 조회시 회원번호를 바꿀때마다
프로시저를 삭제했다가 다시 번호를 갱신한 프로시저를 저장해줘야 한다.
그래서 해당 프로시저를 호출시 번호를 가변적으로 받는 형식으로 변환해보자

파라미터 지정 문법
CREATE PROCEDURE 프로시저명(IN 파라미터명 데이터타입(크기))
*/
DELIMITER $$
 CREATE PROCEDURE getSixArgu(IN user_number INT)
 BEGIN
	DECLARE entryDate DATE; # 날짜 판독을 위한 저장변수 선언
    DECLARE todayDate DATE; # 오늘 날짜 저장변수 선언
    DECLARE days INT; # 경과일수 저장변수 선언
    
    SELECT entry_date INTO entryDate # 쿼리분의 결과로 나온 값을 entryDate 변수에 대입 (이 구문은 외우기!!!!!)
		FROM user_tbl WHERE user_num = user_number; # 입력한 user_number를 불러오는 구문
	SET todayDate = CURRENT_DATE(); # 오늘날짜를 얻어오는 내장함수, 오늘날짜(연,월,일)만 얻어옴
    SET days = DATEDIFF(todayDate, entryDate); # 경과 일수 구하기(todayDate - entryDate)
    
    IF(days/365) >= 3 THEN # 가입이 3년이상이 되었는지 확인
		SELECT CONCAT('가입한지', days, '일이 경과했습니다.');
	ELSE
		SELECT CONCAT('가입일은 3년 미만이며', days,'일이 경과했습니다.');
	END IF;
END $$
DELIMITER ;
# 주석
 CALL getSixArgu(8);
 
 /* <트리거>
특정 테이블에 명령이 내려지면 자동으로 연동된 명령을 수행하도록 구문을 걸어줌
예) 회원 탈퇴시 탈퇴한 회원을 DB에서 바로 삭제(soft delete)하지 하지 않고 탈퇴보류 테이블에 INSERT를 하거나
	수정이 일어나면 수정 전 내역을 따로 다른 테이블에 저장하거나
	특정 테이블 대상으로 실행되는 구문 이전이나 이후에 추가로 실핼할 명령어를 지정 
문법은 프로시저와 유사(달러자리에 슬래시로 입력)
DELIMITER //
CREATE TRIGGER 트리거명
	실행시점(BEFORE / AFTER) 실행로직(어떤 구문이 들어오면 실행할지 작성:SELECT, INSERT...)
	ON 트리거적용테이블
	FOR EACH ROW
BEGIN
	트리거 실행시 작동코드
END //
DELIMITER ;
*/

-- 트리거를 적용할 테이블 생성
CREATE TABLE game_list(
	id INT AUTO_INCREMENT PRIMARY KEY,
	game_name VARCHAR(10)
);

INSERT INTO game_list VALUES
	(1, '바람의나라'),
    (2, '리그오브레전드'),
    (3, '스타크래프트'),
    (4, '리니지');

-- 삭제할때마다 게임이 삭제되었다는 메세지 생성하기
DELIMITER //
CREATE TRIGGER testTrg
	AFTER DELETE # 삭제 후에
    ON game_list # game_list 테이블의 자료가
    FOR EACH ROW
BEGIN
	# OLD.컬럼명을 적으면 해당 삭제 row의 데이터를 조회할 수 있습니다.
	SET @msg = CONCAT(OLD.game_name, '게임이 삭제되었습니다');
    # INSERT INTO log_table (message) VALUES ('게임이 삭제되었습니다');이렇게 작성할 수도 있음
END //
DELIMITER ;

SELECT @msg;
-- 게임 아무거나 삭제하기
DELETE FROM game_list WHERE id = 3; -- (3, '스타크래프트')가 삭제됨
-- 데이터 삭제 후
SELECT @msg;