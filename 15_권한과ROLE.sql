--DCL(Data Control Language) - 데이터베이스에 접근하거나 객체에 권한을 주는등의 역할을 하는 언어
-- <사용자 관리>
-- : 사용자의 계정과 암호설정, 권한 부여

-- 오라클 데이터베이스를 설치하면 기본적으로 제공되는 계정
-- 1. SYS
-- 2. SYSTEM
-- 3. SCOTT(교육용 샘플 계정) : 11G 별도로 생성해야 함
-- 4. HR (샘플계정) : 처음에는 잠겨져 있고, 11G에서는 없음

--SYS: Oracle Database administrator(오라클디비관리자) ,super user,database 생성삭제가능
--System:권한이 동일하지만 db생성삭제 권한이 없다.


-- 보안을 위한 데이터베이스 관리자
-- : 사용자가 데이터베이스의 객체(테이블, 뷰 등)에 대해
--   특정 권한을 가질 수 있게 하는 권한이 있음
--   다수의 사용자가 공유하는 데이터베이스 정보에 대한 보안 설정
--   데이터베이스에 접근하는 사용자마다 서로 다른 권한과 롤을 부여함

-- 권한 : 사용자가 특정 테이블에 접근할 수 있도록 하거나
--       해당 테이블에 SQL(SELECT/INSERT/UPDATE/DELETE)문을
--       사용할 수 있도록 제한을 두는 것

-- 시스템권한 : 데이터베이스 관리자가 가지고 있는 권한
--            CRAETE USER(사용자 계정 만들기)
--            DROP USER(사용자 계정 삭제)
--            DROP ANY TABLE(임의의 테이블 삭제)
--            QUERY REWRITE(함수 기반 인덱스 생성 권한)
--            BACKUP ANY TABLE(테이블 백업)

-- 시스템 관리자가 사용자에게 부여하는 권한
--            CREATE SESSION (데이터베이스에 접속)
--            CREATE TABLE (테이블 생성)
--            CREATE VIEW(뷰 생성)
--            CREATE SEQUENCE(시퀀스 생성)
--            CREATE PROCEDURE(프로시져 생성 권한)

CREATE USER SAMPLE IDENTIFIED BY SAMPLE; --SYS AS SYSDBA에서 실행
GRANT CREATE SESSION TO SAMPLE;
GRANT CREATE TABLE TO SAMPLE;

-- 테이블 스페이스(TABLE SPACE)
-- : 테이블, 뷰, 그밖에 데이터베이스 객체들이 저장되는
--   디스크상의 장소
SELECT
    DEFAULT_TABLESPACE
FROM DBA_USERS
WHERE USERNAME = 'SAMPLE';


-- WITH ADMIN OPTION
-- : 사용자에게 시스템 권한을 부여할 때 사용함
-- 권한을 부여받은 사용자는 다른 사용자에게 권한을 지정할 수 있음
GRANT CREATE SESSION TO SAMPLE WITH ADMIN OPTION;


-- 객체 권한 : 테이블이나 뷰, 시퀀스, 함수 등 각 객체별로
--           DML(SELECT/INSERT/UPDATE/DELETE)
-- GRANT 권한종류 [(컬럼명)] | ALL
-- ON 객체명 | ROLE 이름 | PUBLIC
-- TO 사용자이름;

-- 권한 종류     설정 객체
-- ALTER       TABLE, SEQUENCE
-- DELETE      TABLE, VIEW
-- EXECUTE     PROCEDURE
-- INDEX       TABLE
-- REFERENCES  TABLE
-- INSERT      TABLE, VIEW
-- SELECT      TABLE, VIEW, SEQUENCE
-- UPDATE      TABLE, VIEW

-- WITH GRANT OPTION
-- : 사용자가 해당 객체에 접근할 수 있는 권한을 부여받으면서
--   그 권한을 다른 사용자에게 다시 부여할 수 있는 권한 옵션

GRANT SELECT ON EMPLOYEE.EMPLOYEE TO SAMPLE
WITH GRANT OPTION;

--현재 사용자에게 부여된 권한 조회
SELECT * FROM USER_TAB_PRIVS_RECD;
--현재 사용자가 부여한 권한 조회
SELECT * FROM USER_TAB_PRIVS_MADE;


--권한철회
-- : REVOKE 명령어 사용
REVOKE SELECT ON EMPLOYEE.EMPLOYEE FROM SAMPLE;


-- <데이터베이스 ROLE - 권한제어>
-- : 사용자마다 일일히 권한을 부여하는 것은 번거롭기 때문에
--   간편하게 권한을 부여할 수 있는 방법으로 ROLE을 제공한다.

-- 롤(ROLE)
-- : 사용자에게 보다 간편하게 부여할 수 있도록
--   여러개의 권한을 묶어놓은 것
-- => 사용자 권한 관리를 보다 간편하고 효율적으로 할 수 있게 함
--    다수의 사용자에게 공통적으로 필요한 권한들을 하나의 롤로 묶고
--    사용자에게는 특정 롤에 대한 권한을 부여할 수 있도록 함

--    사용자에게 부여한 권한을 수정하고자 할 때도
--    롤만 수정하면 그 롤에 대한 권한을 부여받은 사용자들의
--    권한이 자동으로 수정된다.
--    롤을 활성화하거나 비활성화해서 일시적으로 권한을 부여하고
--    철회할 수 있음

-- 롤의 종류
-- 1. 사전 정의된 롤
-- : 오라클 설치시 시스템에서 기본적으로 제공됨
--  CONNECT ROLE
--  시스템권한 8가지를 묶어 놓음
--  CREATE SESSION, ALTER SESSION,
--  CREATE TABLE, CREATE VIEW,
--  CREATE SYNONYM, CREATE SEQUENCE,
--  CREATE CLUSTER, CREATE DATABASE LINK

-- RESOURCE ROLE
-- : 사용자가 객체를 생성할 수 있도록 하는 권한을 묶어 놓음
--  CREATE CLUSTER, CREATE PROCEDURE,
--  CREATE SEQUENCE, CRETAE TABLE,
--  CREATE TRIGGER

-- 9버전 이후에는 CONNECT, RESOURCE에 권한이 변경됨
--CREATE VIEW, CREATE SYNONYM 사라져서 우리가 권한을 줬었음 

-- CONNECT ROLE : CREATE SESSION
-- RESOURCE ROLE : CREATE CLUSTER, CREATE PROCEDURE,
--                 CREATE SEQUENCE, CREATE TABLE,
--                 CREATE TRIGGER, CREATE TYPE,
--                 CREATE INDEXTYPE, CREATE OPERATOR

-- 권한 부여 이전에 줬던거 생각해보면
--GRANT RESOURCE, CONNECT TO EMPLOYEE;

SELECT *
FROM DICT
WHERE TABLE_NAME LIKE '%ROLE%';

-- 2. 사용자가 정의하는 롤
-- : CREATE ROLE 명령으로 롤 생성
--   롤 생성은 반드시 DBA권한이 있는 사용자만 할 수 있음
-- CREATE ROLE 롤이름;  -- 1. 롤 생성
-- GRANT 권한종류 TO 롤이름; -- 2. 생성된 롤에 권한 추가
-- GRANT 롤이름 TO 사용자이름; -- 3. 사용자에게 롤 부여

CREATE ROLE MYROLE; --생성
GRANT CREATE SESSION, CREATE TABLE TO MYROLE; --권한 부여

GRANT MYROLE TO SAMPLE; --
SELECT * FROM SYS.USER_ROLE_PRIVS; --조회

--FINAL WORKSHOP문제
--CREATE USER WORKSHOP IDENTIFIED BY WORKSHOP;
--GRANT CREATE SESSION TO WORKSHOP;
--GRANT CREATE TABLE TO WORKSHOP;
--GRANT CONNECT, RESOURCE TO WORKSHOP;

