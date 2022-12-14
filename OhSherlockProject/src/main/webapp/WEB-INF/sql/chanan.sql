-- 로그인 이력 테이블 -- 
create table tbl_login_history
(fk_userid    varchar2(15)   not null
,logindate    date default sysdate not null 
,clientip     varchar2(20)   not null 
,constraint FK_tbl_login_history_fk_userid foreign key(fk_userid) references tbl_member(userid)
);

select * from tbl_member;
desc tbl_login_history;

-- 로그인 sql --
select userid, name, email, mobile, postcode, address, detail_address, extra_address, gender,       
birthyyyy, birthmm, birthdd, coin, point, registerday,        
passwd_change_gap, last_login_date, nvl(last_login_gap, months_between(sysdate, registerday)) as last_login_gap
from
(select userid, name, email, mobile, postcode, address, detail_address, extra_address, gender     
, substr(birthday,1,4) AS birthyyyy, substr(birthday,6,2) AS birthmm, substr(birthday,9) AS birthdd     
, coin, point, to_char(registerday, 'yyyy-mm-dd') AS registerday     
, trunc( months_between(sysdate, last_passwd_date) ) AS passwd_change_gap
from tbl_member
where status = 1 and userid = 'na0seok' and passwd = '0ffe1abd1a08215353c233d6e009613e95eec4253832a761af28ff37ac5a150c') M
cross join
(select max(logindate) as last_login_date, trunc(months_between(sysdate, max(logindate))) as last_login_gap
from tbl_login_history
where fk_userid = '5sherlock') H;

-- 휴면 상태 해제 sql --
update tbl_member set idle = 1 where userid = 'leess';
commit;

--------------------------------------------------------------------------------

-- 공지사항 테이블 --
create table tbl_notice (
noticeNo number,
noticeSubject Nvarchar2(100) not null,
noticeContent clob not null,
noticeHit number default 0,
noticeDate date default sysdate,
noticeFile varchar2(100),
constraint PK_tbl_notice_noticeNo primary key(noticeNo)
);

-- 공지사항 글번호 시퀀스 --
CREATE SEQUENCE seq_notice
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOMINVALUE
NOCYCLE
NOCACHE;

-- 공지사항 글쓰기 sql --
insert into tbl_notice(noticeNo, noticeSubject, noticeContent, noticeFile)
values(seq_notice.nextval, '2조 화이팅', '아좌좌', null);

-- 공지사항 글목록 가져오기 sql --
String sql = "select noticeNo, noticeSubject, noticeContent, noticeHit, noticeDate from tbl_notice";

-- 공지사항 글내용 가져오기 sql --
String sql = "select noticeSubject, noticeContent, noticeHit, noticeDate, noticeFile from tbl_notice where noticeNo = ?";

-- 공지사항 글 조회수 증가 sql --
String sql = "update tbl_notice set noticeHit = noticeHit + 1 where noticeNo = ?";

-- 시퀀스 얻기 sql --
String sql = "select seq_notice.nextval from dual";

-- 공지사항 글쓰기 sql --
String sql = "insert into tbl_notice(noticeNo, noticeSubject, noticeContent, noticeFile)\n"+
"values(?, ?, ?, ?)";

-- 공지사항 글삭제 sql --
String sql = "delete from tbl_notice where noticeNo = ?";

-- 공지사항 글수정 sql --
String sql = "update tbl_notice set noticeSubject = ?, noticeContent = ? where noticeNo = ?";

--------------------------------------------------------------------------------

-- 1:1 문의 테이블 --
create table tbl_inquiry(
inquiry_no number,
fk_userid varchar2(15),
inquiry_type Nvarchar2(20)  not null,
inquiry_subject Nvarchar2(100) not null,
inquiry_content clob not null,
inquiry_date date default sysdate,
inquiry_answered number default 0, -- 미답변:0, 답변완료:1
inquiry_email number default 0, -- 이메일발송거부:0, 이메일발송희망:1
inquiry_sms number default 0, -- 문자발송거부:0, 문자발송희망:1
constraint PK_tbl_inquiry_inquiry_no primary key(inquiry_no),
constraint CK_tbl_inquiry_inquiry_answered check (inquiry_answered in (0,1)),
constraint CK_tbl_inquiry_inquiry_email check (inquiry_email in (0,1)),
constraint CK_tbl_inquiry_inquiry_sms check (inquiry_sms in (0,1))
);

-- inquiry 시퀀스 사용 --
select seq_inquiry.nextval from dual;

-- inquiry 테이블 insert문 --
insert into tbl_inquiry(inquiry_no, fk_userid, inquiry_type, inquiry_subject, inquiry_content, inquiry_email, inquiry_sms)
values(seq_inquiry.nextval, 'test1', 'delivery', '문의', 'ㅇㅇ', 0, 0);
commit;

-- (사용자) 자신의 문의글 전체 개수 가져오기 select문 --
select count(*) from tbl_inquiry where fk_userid = 'test1' and inquiry_date between '2022-09-28' and to_date('2022-09-28 23:59:59', 'yyyy-mm-dd hh24:mi:ss');

String sql = "select count(*) from tbl_inquiry where fk_userid = ? and inquiry_date between ? and to_date(? ||' 23:59:59', 'yyyy-mm-dd hh24:mi:ss')";

-- (사용자) 자신의 문의 내역 가져오기 select문 --
String sql = "select INQUIRY_NO , INQUIRY_TYPE , INQUIRY_SUBJECT , INQUIRY_CONTENT , INQUIRY_DATE , INQUIRY_ANSWERED\n"+
"from\n"+
"(\n"+
"select row_number() over(order by INQUIRY_DATE desc) as rno,\n"+
"INQUIRY_NO , INQUIRY_TYPE , INQUIRY_SUBJECT , INQUIRY_CONTENT , INQUIRY_DATE , INQUIRY_ANSWERED\n"+
"from tbl_inquiry\n"+
"where fk_userid = ? AND inquiry_date between ? and to_date(? ||' 23:59:59', 'yyyy-mm-dd hh24:mi:ss')\n"+
")\n"+
"where rno between ? and ?";

-- (사용자) 자신의 문의글 상세보기 --
select inquiry_no, inquiry_reply_content, inquiry_type, inquiry_subject, inquiry_content, inquiry_date, inquiry_answered
FROM tbl_inquiry join tbl_inquiry_reply
on inquiry_no = fk_inquiry_no
where INQUIRY_NO = 1;

-- (관리자) 1:1문의 전체 페이지 수 --
select ceil(count(*)/7) from tbl_inquiry where INQUIRY_ANSWERED = 0;

String sql = "select ceil(count(*)/7) from tbl_inquiry where INQUIRY_ANSWERED = ?";

-- (관리자) 1:1 문의 글목록 --
String sql = "SELECT inquiry_no, inquiry_type, inquiry_subject, inquiry_content, inquiry_date, fk_userid "+
        " FROM ( SELECT ROWNUM AS rno, inquiry_no, inquiry_type, inquiry_subject, inquiry_content, inquiry_date, fk_userid "+
        " FROM ( SELECT inquiry_no, inquiry_type, inquiry_subject, inquiry_content, inquiry_date, fk_userid "+
        " FROM tbl_inquiry WHERE inquiry_answered = ? ORDER BY 1 DESC ) v ) t\n"+
        " WHERE rno BETWEEN ? AND ?";


-- 관리자 1:1 문의글 상세 --
SELECT inquiry_reply_content, inquiry_reply_date
FROM tbl_inquiry_reply
WHERE fk_inquiry_no = 29;

-- 1:1 문의 댓글 시퀀스 --
create sequence seq_inquiry_reply_no
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 관리자 1:1 문의글 댓글달기 --
String sql = "insert into tbl_inquiry_reply(inquiry_reply_no, fk_inquiry_no, inquiry_reply_content)\n"+
"values(?, ?, ?)";

-- 1:1 문의글의 답변여부 update --
String sql = "update tbl_inquiry set inquiry_answered = 1 where inquiry_no = ?";

--------------------------------------------------------------------------------

-- 카테고리 테이블 생성 --
create table tbl_category
(cnum    number(8)     not null  -- 카테고리 대분류 번호
,code    varchar2(20)  not null  -- 카테고리 코드
,cname   varchar2(100) not null  -- 카테고리명
,constraint PK_tbl_category_cnum primary key(cnum)
,constraint UQ_tbl_category_code unique(code)
);

-- 카테고리 시퀀스 생성 --
create sequence seq_category_cnum 
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

--------------------------------------------------------------------------------
-- 상품번호 시퀀스 생성 --
create sequence seq_product_pnum
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

--------------------------------------------------------------------------------

-- 주문 테이블 --
create table tbl_order (
odrcode                  not null varchar2(20) -- 주문코드 형식 : o+날짜+sequence
,fk_userid                not null varchar2(15)  
,odrdate                  not null date          
,recipient_name           not null varchar2(30)  
,recipient_mobile         not null varchar2(200) 
,recipient_postcode       not null varchar2(5)   
,recipient_address        not null varchar2(100) 
,recipient_detail_address not null varchar2(100) 
,recipient_extra_address  not null varchar2(100) 
,odrtotalprice            not null number(38)    
,odrtotalpoint            not null number 
,delivery_cost            not null number(4)    
,delivery_status          not null number(1)  -- 배송상태( 1 : 주문만 받음,  2 : 배송중,  3 : 배송완료)   
,delivery_date                     varchar2(20) 
,constraint PK_tbl_order_onum primary key(onum)
,constraint FK_tbl_order_fk_userid foreign key(fk_userid) references tbl_member(userid)
,constraint CK_tbl_order_delivery_status CHECK delivery_cost in (1,2,3)
);

desc tbl_order;

-- 주문코드 시퀀스 --
create sequence seq_tbl_order
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 주문상세 테이블 --
create table tbl_order_detail (
odnum      not null number(8),    
fk_odrcode not null varchar2(20),
fk_pnum    not null number(8),    
oqty       not null number(8),    
oprice     not null number(8),    
refund     not null number(1),    
exchange   not null number(1), 
constraint PK_tbl_order_detail_odnum primary key(odnum),
constraint FK_TBL_ORDER_DETAIL_FK_ODRCODE foreign key(FK_ODRCODE) references TBL_ORDER(ODRCODE),
constraint FK_tbl_order_detail_fk_pnum foreign key(fk_pnum) references tbl_product(pnum),
constraint CK_tbl_order_detail_refund check (refund in (0,1)),
constraint CK_tbl_order_detail_exchange check (exchange in (0,1))
);

-- 주문상세번호 시퀀스 --
create sequence seq_tbl_order_detail
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

insert into tbl_order_detail(odnum, fk_odrcode, fk_pnum, oqty, Oprice, opoint)
values(seq_tbl_order_detail.nextval, 'O20221007-2', 32, 1, 22000, 220);
commit;

String sql = "select odnum, fk_pnum, oqty, Oprice, refund, cancel,\n"+
"pname, pimage\n"+
"from tbl_order_detail join tbl_product\n"+
"on fk_pnum = pnum\n"+
"where fk_odrcode = ?";

-- 리뷰 테이블 --
create table tbl_review (
rnum       not null number(8),   
fk_odrcode not null varchar2(20),  
fk_odnum   not null number(8),     
fk_pnum    not null number(8),     
fk_userid  not null varchar2(15),  
score      not null number(1),     
rsubject   not null varchar2(100), 
rcontent   not null varchar2(500), 
rimage              varchar2(100),
constraint PK_tbl_review_rnum primary key(rnum),
constraint fk_tbl_review_fk_odrcode foreign key(fk_odrcode) references tbl_order(odrcode),
constraint FK_tbl_review_fk_odnum foreign key(fk_odnum) references tbl_order_detail(odnum),
constraint FK_tbl_review_fk_pnum foreign key(fk_pnum) references tbl_product(pnum),
constraint FK_tbl_review_fk_userid foreign key(fk_userid) references tbl_member(userid)
);

--------------------------------------------------------------------------------
SELECT odrcode, fk_userid, odrdate, odrtotalprice, odrstatus
FROM( SELECT
    ROWNUM AS rno,
    odrcode,
    fk_userid,
    odrdate,
    odrtotalprice,
    odrstatus
FROM     ( SELECT
    odrcode,
    fk_userid,
    odrdate,
    odrtotalprice,
    odrstatus
FROM
    tbl_order a 
    where not exists 
    (select '1' from tbl_order_detail b where a.odrcode = b.fk_odrcode and refund = -1)  
    and odrstatus in  
    order by odrdate desc )V
    )T
    where rno BETWEEN 1 AND 10;
    
    select ceil(count(*)/10) from tbl_order a where not exists (select '1' from tbl_order_detail b where a.odrcode = b.fk_odrcode and refund = -1)  and odrstatus in (1) ;

select odrcode, fk_userid, odrdate, odrtotalprice, odrstatus, fk_pnum, oqty, pname
from
(select odrcode, fk_userid, odrdate, odrtotalprice, odrstatus, fk_pnum, oqty
from tbl_order join tbl_order_detail
on odrcode = fk_odrcode 
where odrstatus = 2)
join tbl_product on pnum = fk_pnum;

desc tbl_order_detail;

select odrusedpoint from tbl_order where odrcode = 'O20221014-1';

update tbl_order set odrtotalpoint = 0;
commit;