-- 동의어 (SYNONYM)
-- 다른 데이터 베이스가 가진 객체에 대한 별명 혹은 줄임말
-- 여러사용자가 테이블을 공유할경우
-- 다른 사용자가 테이블에 접근할경우 사용자명.테이블명 으로 표현함
-- 동의어를 사용하면 간단하게 접근 가능
-- 삭제 : DROP SYNONYM EMP;

SELECT * FROM SYS.USER_SYNONYMS;

GRANT CREATE SYNONYM TO EMPLOYEE;--시스템 계정에서 생성하고 오기 (권한 부여)

--CREATE SYNONYM 줄임말 FOR 사용자명.객체명;
CREATE SYNONYM EMP FOR EMPLOYEE;

SELECT * FROM EMP;

-- 동의어의 구분
--1. 비공개 동의어
-- 객체에대한 접근 권한을 부여 받은 사용자가 정의한 동의어
--2. 공개 동의어
-- 모든 권한을 주는 사용자(DBA)가 정의한 동의어
-- 모든 사용자가 사용할수 있음 (PUBLIC)
-- 예) DUAL

--시스템 계정에서 테스트
SELECT * FROM EMP; --에러 발생
SELECT * FROM EMPLOYEE.EMP;
SELECT * FROM EMPLOYEE.DEPARTMNET;
CREATE PUBLIC SYNONYM DEPT FOR EMPLOYEE.DEPARTMNET;

SELECT * FROM DEPT;--시스템 계정, EMPLOYEE 계정 둘다 조회됨


