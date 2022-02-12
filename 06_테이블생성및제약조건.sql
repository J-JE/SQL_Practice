--DDL(CREATE TABLE ) 및 제약조건

--DDL(DATA DEFINITION LANGUAGE) : 데이터 정의  언어
--객체(OBJECT) 를 만들고 (CREATE) , 수정(ALTER) 하고 삭제(DROP)하는 구문

--오라클에서의 객체 
--테이블 (TABLE), 뷰(VIEW), 시퀀스(SEQUENCE) , 인덱스(INDEX)
--패키지 (PACKAGE), 트리거(TRIGGER), 동의어(SYNONYM),
--프로시져(PROCEDURE), 함수(FUNCTION), 사용자 (USER)

--테이블 만들기-------------------------------------------------------------------
--[표현식] :
--CREATE TABLE 테이블명(컬럼명 자료형(크기) , 컬럼명 자료형(크기)....)

CREATE TABLE MEMBER(
    MEMBER_ID VARCHAR2 (20),
    MEMBER_PWD VARCHAR2 (20),
    MEMBER_NAME VARCHAR2 (20)
);

SELECT * FROM MEMBER;

-- 컬럼에 주석달기 
--[표현식]
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용'
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원이름';

SELECT *
FROM USER_TABLES; --테이블 조회

SELECT *
FROM USER_TAB_COLUMNS --테이블 마다 갖고있는 컬럼
WHERE TABLE_NAME ='MEMBER'; --원하는 테이블 지정 가능

DESC MEMBER; --테이블 조회 방법 2


--제약조건-----------------------------------------------------------------------
-- 테이블작성시 각 컬럼에 대해 값 기록에 대한 제약조건을 설정할수 있다. 
-- 데이터 무결성 보장을 목적으로함 
-- 입력 / 수정 하는 데이터에 문제가 없는지 자동으로 검사하는 목적
-- PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY

SELECT *
FROM SYS.USER_CONSTRAINTS; --제약조건 조회

SELECT *
FROM USER_CONS_COLUMNS; --어떤 컬럼에 어떤 제약조건

--NOT NULL : 해당 컬럼에 반드시 값을 기록 해야하는 경우 사용----------------------
--           삽입/ 수정 시 NULL값을 허용하지 않도록 '컬럼레벨에서 제한'

CREATE TABLE USER_NOCONS(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(20),
    USER_NAME VARCHAR(20),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

SELECT * FROM USER_NOCONS;

INSERT INTO USER_NOCONS
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');

INSERT INTO USER_NOCONS
    VALUES
    (2, NULL, NULL, NULL, NULL, '010-1234-5678', 'yu@kh.co.kr');
    --제약조건이 없어서 아무렇게 넣어도 생성 가능

COMMIT; --영구 저장, 저장 없이 DDL구문을 실행하면 자동 COMMIT된다.
ROLLBACK;

--제약조건 있는 컬럼 생성-------------------------------
CREATE TABLE USER_NOTNULL(
    USER_NO NUMBER NOT NULL, --컬럼레벨에서 제약조건 설정
    USER_ID VARCHAR2(20)NOT NULL,
    USER_PWD VARCHAR2(20)NOT NULL,
    USER_NAME VARCHAR(20)NOT NULL,
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

SELECT 
    *
FROM SYS.USER_CONSTRAINTS UC
JOIN SYS.USER_CONS_COLUMNS UCC ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
WHERE UC.TABLE_NAME = 'USER_NOTNULL';--제약조건 조회

--CONTRAINT_TYPE이 'C'로 일종의 CHECK 제약조건이다.

INSERT INTO USER_NOTNULL
    VALUES
    (1, NULL, NULL, NULL, NULL, '010-1234-5678', 'yu@kh.co.kr');

--NOT NULL은 컬럼레벨에서 설정 가능하다.


-- UNIQUE  제약조건 : 컬럼에 입력값에대한 중복을 제한하는 제약조건  
--                   컬럼레벨, 테이블레벨에서 설정가능

DROP TABLE USER_UNIQUE; --테이블 제거
CREATE TABLE USER_UNIQUE(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) UNIQUE NOT NULL, --컬럼레벨 제약조건
    USER_PWD VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR(20),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

INSERT INTO USER_UNIQUE
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');

INSERT INTO USER_UNIQUE --unique constraint (EMPLOYEE.SYS_C007075) violated 에러
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');
    
INSERT INTO USER_UNIQUE
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, NULL, 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');
    
SELECT * FROM USER_UNIQUE;

SELECT 
    *
FROM SYS.USER_CONSTRAINTS UC
JOIN SYS.USER_CONS_COLUMNS UCC ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
WHERE UC.CONSTRAINT_NAME = 'SYS_C007078'; --제약조건이 U

CREATE TABLE USER_UNIQUE2(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) NOT NULL,
    USER_PWD VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR(20),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    UNIQUE (USER_ID) --테이블 레벨에서 제약조건 설정
);

INSERT INTO USER_UNIQUE2
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');

INSERT INTO USER_UNIQUE2
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');
    
INSERT INTO USER_UNIQUE2
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, NULL, 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');


-- 두개의 컬럼을 묶어서 하나의 UNIQUE 제약조건 설정
-- 컬럼레벨이 아닌 테이블 레벨에서 설정
CREATE TABLE USER_UNIQUE3(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) NOT NULL,
    USER_PWD VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR(20),
    GENDER VARCHAR2(10),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    UNIQUE (USER_NO, USER_ID) --테이블 레벨에서 제약조건 설정
);

INSERT INTO USER_UNIQUE3
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');

INSERT INTO USER_UNIQUE3
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user02', 'pass02', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');

INSERT INTO USER_UNIQUE3
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user01', 'pass02', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');
    
INSERT INTO USER_UNIQUE3
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (2, 'user01', 'pass02', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');
    
INSERT INTO USER_UNIQUE3--ORA-01400: cannot insert NULL into ("EMPLOYEE"."USER_UNIQUE3"."USER_ID")
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (2, NULL, 'pass02', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');


-- 제약조건 명 부여, 지정해주지않으면 시스템에서 알아서 임의의 제약 조건명 부여
-- 제약조건명은 회사의 네이밍 룰에 따르고, 어떤제약조건이 위배되는지 한눈에 파악가능

CREATE TABLE CONS_NAME(
    TEST_DATA1 VARCHAR2(20) CONSTRAINT NN_TEST_DATA1 NOT NULL,
    TEST_DATA2 VARCHAR2(20) CONSTRAINT UK_TEST_DATA2 UNIQUE,
    TEST_DATA3 VARCHAR2(20),
    CONSTRAINT UK_TEST_DATA3 UNIQUE(TEST_DATA3)
);

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'CONS_NAME'; --제약조건 U



--CHECK제약조건  : 컬럼에 기록되는 값에 조건을 설정할수있음-----------------------------
--CHECK(컬럼명 비교연산자 비교값 )
-- 주의 : 비교값은 리터럴만 사용 할수있음 , 변하는 값이나 함수는 사용 못함. (자동 NOT NULL  규칙이 적용됨)

CREATE TABLE USER_CHECK(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR(20),
    GENDER VARCHAR2(10)CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

INSERT INTO USER_CHECK
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');

INSERT INTO USER_CHECK
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user02', 'pass02', '유재석', '남자', '010-1234-5678', 'yu@kh.co.kr');

SELECT 
    *
FROM SYS.USER_CONSTRAINTS UC
JOIN SYS.USER_CONS_COLUMNS UCC ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
WHERE UC.CONSTRAINT_NAME = 'SYS_C007087'; --제약조건이 C

CREATE TABLE TEST_CHECK(
    TEST_NUMBER NUMBER,
    CONSTRAINT CK_TEST_NUMBER CHECK(TEST_NUMBER > 0)--0보다 커야한다는 제약조건
);

INSERT INTO TEST_CHECK
    (TEST_NUMBER)
    VALUES
    (10);

INSERT INTO TEST_CHECK
    (TEST_NUMBER)
    VALUES
    (-10);
SELECT * FROM TEST_CHECK;

CREATE TABLE TBL_CHECK( --제약조건을 거는 다른 방법--
    C_NAME VARCHAR2(10),
    C_PRICE NUMBER,
    C_LEVEL CHAR(1),
    C_DATE DATE,
    CONSTRAINT CK_C_PRICE CHECK(C_PRICE >= 1 AND C_PRICE <= 9999),
    CONSTRAINT CK_C_LEVEL CHECK(C_LEVEL ='A' OR C_LEVEL ='B' OR C_LEVEL ='C'),
    CONSTRAINT CK_C_DATE CHECK(C_DATE >= TO_DATE('2016/01/01','YYYY/MM/DD'))
);



-- 회원 가입용 테이블 생성(USER_TEST)
-- 컬럼명 : USER_NO(회원번호)
--         USER_ID(회원아이디) -- 중복 금지, NULL값 허용 안함
--         USER_PWD(회원비밀번호) -- NULL값 허용 안함
--         PNO(주민등록번호) -- 중복금지, NULL값 허용 안함
--         GENDER(성별) -- '남' 혹은 '여'로 입력
--         PHONE(연락처)
--         ADDRESS(주소)
--         STATUS(탈퇴여부) -- NOT NULL, 'Y' 혹은 'N'으로 입력
-- 각 컬럼에 제약조건 이름 부여
-- 각 컬럼별로 코멘트 생성
-- 5명 이상 회원 정보 INSERT

CREATE TABLE USER_TEST(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20) CONSTRAINT NN_USER_ID NOT NULL,
    USER_PWD VARCHAR2(20) CONSTRAINT NN_USER_PWD NOT NULL,
    PNO VARCHAR2(20) CONSTRAINT NN_PNO NOT NULL,
    GENDER VARCHAR2(20) ,
    PHONE VARCHAR2(20),
    ADDRESS VARCHAR2(50),
    STATUS VARCHAR2(20) CONSTRAINT NN_STATUS NOT NULL,
    
    CONSTRAINT UK_USER_ID UNIQUE(USER_ID),
    CONSTRAINT UK_PNO UNIQUE(PNO),
    
    CONSTRAINT CK_GENDER CHECK(GENDER IN ('남','여')),
    CONSTRAINT CK_STATUS CHECK(STATUS IN ('Y','N'))
--UK, NN, CK
);
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용'
COMMENT ON COLUMN USER_TEST.USER_NO IS '회원번호';
COMMENT ON COLUMN USER_TEST.USER_ID IS '회원아이디';
COMMENT ON COLUMN USER_TEST.USER_PWD IS '회원비밀번호';
COMMENT ON COLUMN USER_TEST.PNO IS '주민등록번호';
COMMENT ON COLUMN USER_TEST.GENDER IS '성별';
COMMENT ON COLUMN USER_TEST.PHONE IS '연락처';
COMMENT ON COLUMN USER_TEST.ADDRESS IS '주소';
COMMENT ON COLUMN USER_TEST.STATUS IS '탈퇴여부';

INSERT INTO USER_TEST
    (USER_NO,USER_ID,USER_PWD,PNO,GENDER,PHONE,ADDRESS,STATUS)
    VALUES
    (1,'user01','user01','666666-6666666','남','010-1111-1111','서울','N');

INSERT INTO USER_TEST
    (USER_NO,USER_ID,USER_PWD,PNO,GENDER,PHONE,ADDRESS,STATUS)
    VALUES
    (2,'user02','user02','777777-7777777','여','010-2222-2222','서울','N');

INSERT INTO USER_TEST
    (USER_NO,USER_ID,USER_PWD,PNO,GENDER,PHONE,ADDRESS,STATUS)
    VALUES
    (3,'user03','user03','888888-8888888','남','010-3333-3333','경기도','N');

INSERT INTO USER_TEST
    (USER_NO,USER_ID,USER_PWD,PNO,GENDER,PHONE,ADDRESS,STATUS)
    VALUES
    (4,'user04','user04','999999-9999999','여','010-4444-4444','경기도','N');

INSERT INTO USER_TEST
    (USER_NO,USER_ID,USER_PWD,PNO,GENDER,PHONE,ADDRESS,STATUS)
    VALUES
    (5,'user05','user05','671231-1234567','남','010-5555-5555','서울','Y'); 
    
--PRIMARY KEY(기본키) 제약조건 
-- : 테이블에서 한행의 정보를 찾기위해 사용할 컬럼을 의미
-- 테이블에 대한 식별자 역할을 한다. 
-- NOT NULL+ UNIQUE제약조건의 의미
-- 한 테이블당 한개만 설정
-- 컬럼 레벨, 테이블 레벨 둘다 설정 가능함
-- 한개 컬럼에 설정할수 있고, 여러개 컬럼 묶어서(복합키) 설정 할수 있음

CREATE TABLE USER_PRIMARYKEY(
    USER_NO NUMBER CONSTRAINT PK_USER_NO PRIMARY KEY, --컬럼레벨에서 지정
    USER_ID VARCHAR2(20) UNIQUE,
    USER_PWD VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR(20),
    GENDER VARCHAR2(10)CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50)
);

INSERT INTO USER_PRIMARYKEY
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');
    
INSERT INTO USER_PRIMARYKEY
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user02', 'pass02', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');
    
INSERT INTO USER_PRIMARYKEY
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (NULL, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');
    
SELECT 
    UC.TABLE_NAME,
    UCC.COLUMN_NAME,
    UC.CONSTRAINT_NAME,
    UC.CONSTRAINT_TYPE
FROM SYS.USER_CONSTRAINTS UC
JOIN SYS.USER_CONS_COLUMNS UCC ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
WHERE UC.CONSTRAINT_NAME = 'PK_USER_NO'; --제약조건이 P



CREATE TABLE USER_PRIMARYKEY2(
    USER_NO NUMBER ,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR(20),
    GENDER VARCHAR2(10)CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2(30),
    EMAIL VARCHAR2(50),
    CONSTRAINT PK_USER_NO2 PRIMARY KEY(USER_NO, USER_ID) --테이블레벨에서 지정
);

INSERT INTO USER_PRIMARYKEY2
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');

INSERT INTO USER_PRIMARYKEY2
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user02', 'pass02', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');

INSERT INTO USER_PRIMARYKEY2
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (2, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');

INSERT INTO USER_PRIMARYKEY2 --ORA-00001: unique constraint (EMPLOYEE.PK_USER_NO2) violated
    (USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL)
    VALUES
    (1, 'user01', 'pass01', '유재석', '남', '010-1234-5678', 'yu@kh.co.kr');


-- FOREIGN KEY(외부키 / 외래키) 제약조건 : 
-- 참조(REFERENCES)된 다른 테이블에서 제공하는 값만 사용할 수 있음
-- 참조 무결성을 위배하지 않게 하기 위해 사용
-- FOREIGN KEY제약조건에 의해서 
-- 테이블간의 관계(RELATIONSHIP)가 형성됨--> JOIN이 가능해짐 
-- 제공되는 값 외에는 NULL을 사용할 수 있음

-- 컬럼레벨일 경우
-- 컬럼명 자료형(크기) [CONSTRAINT 이름] REFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]

-- 테이블 레벨일 경우
-- [CONSTRAINT 이름] FOREIGN KEY (적용할컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]


-- 참조할 테이블의 참조할 컬럼명이 생략되면
-- PRIMARY KEY로 설정된 컬럼이 자동 참조할 컬럼이 됨
-- 참조될 수 있는 컬럼은 PRIMARY KEY 컬럼과,
-- UNIQUE 지정된 컬럼만 외래키로 사용할 수 있음

CREATE TABLE USER_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30)NOT NULL
);
INSERT INTO USER_GRADE
VALUES
    (10, '일반회원');

INSERT INTO USER_GRADE
VALUES
    (20, '우수회원');

INSERT INTO USER_GRADE
VALUES
    (30, '특별회원');

SELECT * FROM USER_GRADE;

CREATE TABLE USER_FOREIGNKEY(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2 (20) UNIQUE,
    USER_PWD VARCHAR2 (20) NOT NULL,
    USER_NAME VARCHAR2 (30),
    GENDER VARCHAR2(10) CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2 (30),
    EMAIL VARCHAR2 (50),
    GRADE_CODE NUMBER,
    CONSTRAINT FK_GRADE_CODE FOREIGN KEY (GRADE_CODE) REFERENCES USER_GRADE(GRADE_CODE)
);

INSERT INTO USER_FOREIGNKEY
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (1,'user01','pass01','홍길동','남','010-1234-5678','hong123@kh.or.kr',10);

INSERT INTO USER_FOREIGNKEY
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (2,'user02','pass02','홍길동','남','010-1234-5678','hong123@kh.or.kr',20);

INSERT INTO USER_FOREIGNKEY
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (3,'user03','pass03','홍길동','남','010-1234-5678','hong123@kh.or.kr',30);

INSERT INTO USER_FOREIGNKEY
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (4,'user04','pass04','홍길동','남','010-1234-5678','hong123@kh.or.kr',NULL);

INSERT INTO USER_FOREIGNKEY --ORA-02291: integrity constraint (EMPLOYEE.FK_GRADE_CODE) violated - parent key not found
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (5,'user05','pass05','홍길동','남','010-1234-5678','hong123@kh.or.kr',50);

SELECT 
    UC.TABLE_NAME,
    UCC.COLUMN_NAME,
    UC.CONSTRAINT_NAME,
    UC.CONSTRAINT_TYPE
FROM SYS.USER_CONSTRAINTS UC
JOIN SYS.USER_CONS_COLUMNS UCC ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
WHERE UC.CONSTRAINT_NAME = 'FK_GRADE_CODE'; --제약조건이 R

--USER_FOREIGNKEY에서 
--회원아이디, 이름, 성별, 연락처, 회원 등급명 을 조회하라 .
SELECT
    A.USER_ID,
    A.USER_NAME,
    A.GENDER,
    A.PHONE,
    B.GRADE_NAME
FROM USER_FOREIGNKEY A
--LEFT JOIN USER_GRADE B ON A.GRADE_CODE = B.GRADE_CODE;
NATURAL LEFT JOIN USER_GRADE B; --컬럼명이 같을 때 사용 가능

--삭제 옵션----------------------------------------------------------------------
--: 부모테이블의 데이터 삭제시 자식 테이블의 데이터를 어떤식으로 처리할지에 대한 내용 설정
DELETE FROM USER_GRADE WHERE GRADE_CODE =10; --ORA-02292: integrity constraint (EMPLOYEE.FK_GRADE_CODE) violated - child record found

-- ON DELETE RESTRICTED 기본으로 지정되어있음 
-- FOREIGN KEY로 지정된 컬럼에서 사용 되고 있는 값일경우 
-- 제공하는 컬럼의 값은 삭제 하지 못한다. ( 외래키 테이블에 값이 있기때문에)

DELETE FROM USER_GRADE WHERE GRADE_CODE =20;
SELECT * FROM USER_GRADE;

-- ON DELETE SET NULL : 부모키를 삭제시 자식키를 NULL 로 변경하는 옵션--
CREATE TABLE USER_GRADE2(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30)NOT NULL
);
INSERT INTO USER_GRADE2
VALUES
    (10, '일반회원');

INSERT INTO USER_GRADE2
VALUES
    (20, '우수회원');

INSERT INTO USER_GRADE2
VALUES
    (30, '특별회원');

CREATE TABLE USER_FOREIGNKEY2(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2 (20) UNIQUE,
    USER_PWD VARCHAR2 (20) NOT NULL,
    USER_NAME VARCHAR2 (30),
    GENDER VARCHAR2(10)CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2 (30),
    EMAIL VARCHAR2 (50),
    GRADE_CODE NUMBER,
    CONSTRAINT FK_GRADE_CODE2 FOREIGN KEY (GRADE_CODE) REFERENCES USER_GRADE2(GRADE_CODE) ON DELETE SET NULL
);

INSERT INTO USER_FOREIGNKEY2
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (1,'user01','pass01','홍길동','남','010-1234-5678','hong123@kh.or.kr',10);

INSERT INTO USER_FOREIGNKEY2
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (2,'user02','pass02','홍길동','남','010-1234-5678','hong123@kh.or.kr',10);

INSERT INTO USER_FOREIGNKEY2
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (3,'user03','pass03','홍길동','남','010-1234-5678','hong123@kh.or.kr',30);

INSERT INTO USER_FOREIGNKEY2
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (4,'user04','pass04','홍길동','남','010-1234-5678','hong123@kh.or.kr',NULL);

SELECT * FROM USER_GRADE2;
SELECT * FROM USER_FOREIGNKEY2;

DELETE FROM USER_GRADE2 WHERE GRADE_CODE =10;


--ON DELETE CASCADE : 부모키 삭제시 자식키를 가진 행도 함께 삭제---------------
CREATE TABLE USER_GRADE3(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30)NOT NULL
);
INSERT INTO USER_GRADE3
VALUES
    (10, '일반회원');

INSERT INTO USER_GRADE3
VALUES
    (20, '우수회원');

INSERT INTO USER_GRADE3
VALUES
    (30, '특별회원');

CREATE TABLE USER_FOREIGNKEY3(
    USER_NO NUMBER PRIMARY KEY,
    USER_ID VARCHAR2 (20) UNIQUE,
    USER_PWD VARCHAR2 (20) NOT NULL,
    USER_NAME VARCHAR2 (30),
    GENDER VARCHAR2(10)CHECK (GENDER IN ('남','여')),
    PHONE VARCHAR2 (30),
    EMAIL VARCHAR2 (50),
    GRADE_CODE NUMBER,
    CONSTRAINT FK_GRADE_CODE3 FOREIGN KEY (GRADE_CODE) REFERENCES USER_GRADE3(GRADE_CODE) ON DELETE CASCADE
);

INSERT INTO USER_FOREIGNKEY3
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (1,'user01','pass01','홍길동','남','010-1234-5678','hong123@kh.or.kr',10);

INSERT INTO USER_FOREIGNKEY3
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (2,'user02','pass02','홍길동','남','010-1234-5678','hong123@kh.or.kr',10);

INSERT INTO USER_FOREIGNKEY3
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (3,'user03','pass03','홍길동','남','010-1234-5678','hong123@kh.or.kr',30);

INSERT INTO USER_FOREIGNKEY3
    ( USER_NO, USER_ID, USER_PWD, USER_NAME, GENDER, PHONE, EMAIL ,GRADE_CODE)
    VALUES
    (4,'user04','pass04','홍길동','남','010-1234-5678','hong123@kh.or.kr',NULL);

SELECT * FROM USER_GRADE3;
SELECT * FROM USER_FOREIGNKEY3;

DELETE FROM USER_GRADE3 WHERE GRADE_CODE =10;


--서브쿼리를 이용한 테이블 생성 (컬럼명, 데이터 타입, 값이 복사되고 , 제약조건은 NOT NULL 만 복사됨
CREATE TABLE EMPLOYEE_COPY
AS SELECT * FROM EMPLOYEE; --복사

SELECT * FROM EMPLOYEE_COPY;
DROP TABLE EMPLOYEE_COPY;

CREATE TABLE EMPLOYEE_COPY --구조만 복사하고 싶을 때
AS SELECT * FROM EMPLOYEE WHERE 1=0;

CREATE TABLE EMPLOYEE_COPY2 --원하는 조건으로 복사 (서브쿼리 활용)
AS SELECT EMP_ID, EMP_NAME, SALARY, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_TITLE
LEFT JOIN JOB USING(JOB_CODE);

--제약조건 추가 
-- ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명)
-- ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 테이블명 (컬럼명)
-- ALTER TABLE 테이블명 ADD UNIQUE(컬럼명)
-- ALTER TABLE 테이블명 ADD CHECK(컬럼명 비교연산자 비교값)
-- ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL --주의! MODIFY임

ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);
ALTER TABLE EMPLOYEE_COPY MODIFY EMP_NAME NOT NULL;



-- 실습-------------------------------------------------------------------------

-- EMPLOYEE 테이블의 DEPT_CODE에 외래키 제약조건 추가
-- 참조 테이블은 DEPARTMENT, 참조컬럼은 DEPARTMENT의 기본키
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT (DEPT_ID);
--기본키는 생략하면 자동으로 들어간다. ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE)  REFERENCES DEPARTMENT;

-- DEPARTMENT 테이블의 LOCATION_ID에 외래키 제약조건 추가
-- 참조 테이블은 LOCATION, 참조 컬럼은 LOCATION의 기본키
ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION (LOCAL_CODE);

-- EMPLOYEE 테이블의 JOB_CODE에 외래키 제약조건 추가
-- 참조 테이블은 JOB 테이블, 참조 컬럼은 JOB테이블의 기본키
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB (JOB_CODE);

-- EMPLOYEE 테이블의 SAL_LEVEL에 외래키 제약조건 추가
-- 참조테이블은 SAL_GRADE테이블, 참조 컬럼은 SAL_GRADE테이블 기본키
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(SAL_LEVEL) REFERENCES SAL_GRADE (SAL_LEVEL);

-- EMPLOYEE테이블의 ENT_YN컬럼에 CHECK제약조건 추가('Y','N')
-- 단, 대 소문자를 구분하기 때문에 대문자로 설정
ALTER TABLE EMPLOYEE ADD CHECK(ENT_YN IN ('Y','N'));

-- EMPLOYEE테이블의 SALARY 컬럼에 CHECK제약조건 추가(양수)
ALTER TABLE EMPLOYEE ADD CHECK(SALARY > 0); 

-- EMPLOYEE테이블의 EMP_NO컬럼에 UNIQUE 제약조건 추가
ALTER TABLE EMPLOYEE ADD UNIQUE (EMP_NO);

----------정답------------------
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID);
ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION(LOCAL_CODE);
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB(JOB_CODE);
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(SAL_LEVEL) REFERENCES SAL_GRADE(SAL_LEVEL);
ALTER TABLE EMPLOYEE ADD CHECK (ENT_YN IN ('Y', 'N'));
ALTER TABLE EMPLOYEE ADD CHECK(SALARY > 0);
ALTER TABLE EMPLOYEE ADD UNIQUE(EMP_NO);

-------------------------------------------------------------------------------
ALTER TABLE 테이블명
DROP CONSTRAINT 제약조건명;
--테이블 삭제해야 하는 경우
DROP TABLE 테이블명;
DROP TABLE 테이블명 CASCADE CONSTRAINT;--제약조건이 걸려도 삭제 가능