# 블로그 테이블 생성 구문
CREATE TABLE blog(
	blog_id int auto_increment primary key,
	writer varchar(16) not null,
    blog_title varchar(200) not null,
    blog_content varchar(4000) not null,
    published_at datetime default now(),
    updated_at datetime default now(),
    blog_count int default 0
);

CREATE TABLE IF NOT EXISTS blog(
    blog_id int auto_increment primary key,
    writer varchar(16) not null,
    blog_title varchar(200) not null,
    blog_content varchar(4000) not null,
    published_at datetime default now(),
    updated_at datetime default now(),
	blog_count int default 0
);

INSERT INTO blog VALUES
    (null, '1번유저', '1번제목', '1번본문', now(), now(), null),
    (null, '2번유저', '2번제목', '2번본문', now(), now(), null),
    (null, '3번유저', '3번제목', '3번본문', now(), now(), null);
    
SELECT * FROM blog;    
DROP TABLE blog;


## 댓글 테이블 설정
CREATE TABLE reply(
	reply_id int primary key auto_increment,
    blog_id int not null,
    reply_writer varchar(40) not null,
    reply_content varchar(200) not null,
    published_at datetime default now(),
    updated_at datetime default now()
);
# 외래키 설정
# blog_id에는 기존에 존재하는 글의 blog_id만 들어가야 한다.
alter table reply add constraint fk_reply foreign key (blog_id) references blog(blog_id);

# 더미 데이터 입력
INSERT INTO reply VALUES(null, 2, "댓글쓴이", "1빠댓글", now(), now()),
(null, 2, "미미", "2빠댓글", now(), now()),
(null, 2, "릴리", "3빠댓글", now(), now()),
(null, 2, "슈슈", "4빠댓글", now(), now()),
(null, 3, "개발고수", "1빠댓글", now(), now());

SELECT * FROM reply;
SELECT count(*) FROM blog;    # 게시글 수 확인
SELECT * FROM blog;

DROP TABLE reply;
DROP TABLE blog;

INSERT INTO blog VALUES (null, "더미데이터본문!!!", 0, "더미데이터제목!!!", now(), now(), "더미글쓴이");  

INSERT INTO blog(blog_content, blog_count, blog_title, published_at, updated_at, writer) 
	(SELECT blog_content, blog_count, blog_title, now(), now(), writer FROM blog);
    