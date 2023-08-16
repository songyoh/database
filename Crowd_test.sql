SELECT * FROM crowd;
SELECT * FROM crowd_order_details;
SELECT * FROM reward;
SELECT * FROM sponsor;

# crowd_test 용 더미데이터
INSERT INTO crowd VALUES
	(null, 1, 1, 1, '1번 본문', '23-12-31', 1000000, '1-1번사진', '1-2번사진', '1-3번사진', '1-4번사진', '1-5번사진', 1, '1번펀딩', '1번헤더', 1, 100, now(), now(), 1),
    (null, 2, 2, 2, '2번 본문', '23-12-31', 2000000, '2-1번사진', '2-2번사진', '2-3번사진', '2-4번사진', '2-5번사진', 2, '2번펀딩', '2번헤더', 1, 200, now(), now(), 2),
    (null, 3, 3, 3, '3번 본문', '23-12-31', 3000000, '3-1번사진', '3-2번사진', '3-3번사진', '3-4번사진', '3-5번사진', 3, '3번펀딩', '3번헤더', 1, 300, now(), now(), 3);
    
# crowd_order_details용 더미데이터
INSERT INTO crowd_order_details VALUES
	(null, 1, 0, '서울시 강남구', '23-08-01', '김자바', '01012345678', '카드결제', 1, 1, 1),
    (null, 2, 0, '경기도 안산시', '23-08-02', '김파이', '01045678900', '카드결제', 1, 2, 2),
    (null, 3, 0, '서울시 강북구', '23-08-01', '김코드', '01088889999', '계좌송금', 1, 3, 3);
    
# reward_test용 더미데이터
CREATE TABLE reward(
	reward_id int auto_increment primary key,
    crowd_id int not null,
    reward_title varchar(255) not null,
    reward_content varchar(255) not null,
    reward_amount int not null,
    reward_limit int not null);
    
INSERT INTO reward VALUES
	(null, 1, '슈퍼얼리버드1', '기본후원1', 1000, 5),
    (null, 1, '슈퍼얼리버드2', '기본후원2', 10000, 5),
    (null, 1, '슈퍼얼리버드3', '기본후원3', 50000, 5);
    
# sponsor_test용 더미데이터
CREATE TABLE sponsor(
	sponsor_id int auto_increment primary key,
    crowd_id int not null,
    purchase_id int not null);
    
INSERT INTO sponsor VALUES
		(null, 1, 1),
        (null, 1, 2),
        (null, 1, 3);