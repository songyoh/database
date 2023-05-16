-- 트랜잭션은 2개 이상의  각종 쿼리문의 실행을 되돌리거나 영구적으로 반영할 때 사용한다.
-- 연습 테이블 생성
CREATE TABLE bank_account(
	act_num INT(5) PRIMARY KEY AUTO_INCREMENT,
    act_owner VARCHAR(10) NOT NULL,
    balance INT(10) NOT NULL DEFAULT 0
);

-- 계좌 데이터 2개를 집어넣기
INSERT INTO bank_account VALUES 
		   (null, '나구매', 50000),
		   (null, '가판매', 0);
           
SELECT * FROM bank_account;

-- 트랜잭션 시작(시작점, ROLLBACK; 수행시 이 지점 이후의 내용을 전부 취소한다.)
-- ctrl + enter로 실행해줘야 함
START TRANSACTION;

-- 나구매의 돈 30,000원 차감
UPDATE bank_account SET balance = (balance - 30000) WHERE act_owner = '나구매';
-- 가판매의 돈 30,000원 증가
UPDATE bank_account SET balance = (balance + 30000) WHERE act_owner = '가판매';
set sql_safe_updates=0;
SELECT * FROM bank_account;

-- 알고보니 25000원이어서 되돌리기
ROLLBACK;
SELECT * FROM bank_account;

-- 25000원으로 다시 차감 및 증가 코드 작성, 커밋도 진행해보자.
START TRANSACTION; -- 이 코드를 먼저 실행하고 요청한 쿼리문을 작성해서 실행해보자
UPDATE bank_account SET balance = (balance - 25000) WHERE act_owner = '나구매';
UPDATE bank_account SET balance = (balance + 25000) WHERE act_owner = '가판매';
COMMIT; -- 32번 이후 실행한 25,000차감 및 증가 로직 영구 반영 완료.
SELECT * FROM bank_account;
ROLLBACK; -- 커밋 이후에는 롤백을 실행해도 돌아갈 지점이 사라짐.

-- SAVEPOINT는 ROLLBACK시 해당 지점 전까지는 반영, 해당 지점 이후는 반영 안하는 경우에 사용한다.
START TRANSACTION; -- 아무것도 실행 안 됨 시점

-- 나구매의 돈 3,000원 차감
UPDATE bank_account SET balance = (balance - 3000) WHERE act_owner = '나구매';
-- 가판매의 돈 3,000원 증가
UPDATE bank_account SET balance = (balance + 3000) WHERE act_owner = '가판매';
SELECT * FROM bank_account;
SAVEPOINT first_tx; -- first_tx;라는 저장지점 생성

-- 나구매의 돈 5,000원 차감
UPDATE bank_account SET balance = (balance - 5000) WHERE act_owner = '나구매';
-- 가판매의 돈 5,000원 증가
UPDATE bank_account SET balance = (balance + 5000) WHERE act_owner = '가판매';
SELECT * FROM bank_account;
ROLLBACK to first_tx;





















