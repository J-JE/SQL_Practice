/*@ 데이터 딕셔너리 (Data Dictionary)
-> 자원을 효율적으로 관리하기 위한 다양한 정보를 저장하는 시스템 테이블
-> 데이터 딕셔너리는 사용자가 테이블을 생성하거나 사용자를 변경하는 등의
작업을 할 때 데이터베이스 서버에 의해 자동으로 갱신되는 테이블
-> 사용자는 데이터 딕셔너리의 내용을 직접 수정하거나 삭제할 수 없음
-> 데이터 딕셔너리 안에는 중요한 정보가 많이 있기 때문에 사용자는 이를 활용하기 위해
데이터 딕셔너리 뷰를 사용하게 됨
	
	※ 뷰(VIEW)는 뒤에 배우겠지만 미리 말씀 드리면 원본 테이블을 
	커스터마이징해서 보여주는 원본테이블의 가상의 TABLE 객체


@ 3개의 데이터 딕셔너리 뷰 (Data Dictionary View)


1. DBA_XXXX : 데이터 베이스 관리자만 접근이 가능한 객체 등의 정보 조회
	(DBA는 모든 접근이 가능하므로 결국 디비에 있는 모든 객체에 대한 조회가 됨) 

2. ALL_XXXX : 자신의 계정이 소유하거나 권한을 부여받은 객체 등에 관한 정보 조회

3. USER_XXXX : 자신의 계정이 소유한 객체 등에 관한 정보 조회

*/

SELECT * FROM USER_TABLES; --테이블의정보
SELECT * FROM USER_TAB_COLUMNS; --테이블내컬럼정보
SELECT * FROM USER_VIEWS;--뷰정보
SELECT * FROM USER_CONSTRAINTS;--테이블의 제약조건 검색
SELECT * FROM USER_CONS_COLUMNS;--컬럼의 제약조건 검색


-- DML(Data Manupulation Language)
-- INSERT, UPDATE, DELETE, SELECT
-- : 데이터 조작 언어, 테이블에 값을 삽입하거나, 수정하거나,
--   삭제하거나, 조회하는 언어


--INSERT : 새로운행을 추가하는 구문이다. 
--         테이블의 행의 갯수가 증가한다. 

-- 테이블에 모든 컬럼에 대해 값을 INSERT
-- INSERT INTO 테이블명  VALUES(데이터, 데이터,,,,...)

-- 테이블에 일부컬럼에대해 INSERT
-- INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명,....)  VALUES(데이터, 데이터,데이터,,,...)


INSERT INTO EMPLOYEE
    (EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE
    , DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS
    , MANAGER_ID, HIRE_DATE, ENT_DATE, ENT_YN
    )
    VALUES --VALUES 컬럼명을 나열, 서브쿼리는 괄호
    (
        900, '장재현', '901123-1080503', 'jang@kh.co.kr', '01059591234',
        'D1', 'J7', 'S3', 4300000, 0.2,
        '200', SYSDATE, NULL, DEFAULT
    );

SELECT *
FROM EMPLOYEE
WHERE EMP_ID=900;

COMMIT;

--INSERT 시 VALUES 대신에 서브쿼리 이용 할수있다.

CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

INSERT INTO EMP_01
(
    SELECT A.EMP_ID, A.EMP_NAME, B.DEPT_TITLE
    FROM EMPLOYEE A
    LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B. DEPT_ID
);

-- EMP_DEPT_D1테이블에 EMPLOYEE 테이블에서 부서코드가 D1인 
-- 직원을 조회해서 사번, 이름 , 소속 부서, 입사일을 삽입하고,
-- EMP_MANAGER 테이블에 EMPLOYEE 테이블에서 부서코드가 D1인 
-- 직원을 조회해서 사번, 이름, 관리자사번을 조회해서 삽입하세요

CREATE TABLE EMP_DEPT_D1
AS
SELECT EMP_ID,
        EMP_NAME,
        DEPT_CODE,
        HIRE_DATE
FROM EMPLOYEE
WHERE 1=0; --형식 복사

CREATE TABLE EMP_MANAGER
AS
SELECT
    EMP_ID,
    EMP_NAME,
    MANAGER_ID
FROM EMPLOYEE
WHERE 1=0; --형식 복사

INSERT INTO EMP_DEPT_D1(
    SELECT
        EMP_ID,
        EMP_NAME,
        DEPT_CODE,
        HIRE_DATE
    FROM EMPLOYEE
    WHERE DEPT_CODE ='D1'
    );

INSERT INTO EMP_MANAGER(
    SELECT
        EMP_ID,
        EMP_NAME,
        MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE ='D1'
    );

SELECT * FROM EMP_DEPT_D1;
SELECT * FROM EMP_MANAGER;

DELETE FROM EMP_DEPT_D1;
DELETE FROM EMP_MANAGER;

--INSERT ALL: INSERT시에 사용하는 서브쿼리가 같은경우 
--            두개이상의 테이블에 INSERT ALL 을 이용하여 
--            한번에 데이터를 삽입할수 있다. 
--            단, 각 서브쿼리의 조건절이 같아야 한다.

INSERT ALL
    INTO EMP_DEPT_D1
    VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
    INTO EMP_MANAGER
    VALUES(EMP_ID, EMP_NAME,MANAGER_ID)
    SELECT
        EMP_ID,
        EMP_NAME,
        DEPT_CODE,
        HIRE_DATE,
        MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE='D1';

SELECT * FROM EMP_DEPT_D1;  
SELECT * FROM EMP_MANAGER;

-- EMPLOYEE 테이블에서 입사일 기준으로 2000년 1월1일 이전에 입사한
-- 사원의 사번, 이름, 입사일, 급여를 조회하여 
-- EMP_OLD 테이블에 삽입하고 
-- 그 이후에 입사한 사원은 EMP_NEW 테이블에 삽입하세요

CREATE TABLE EMP_OLD
AS
SELECT
    EMP_ID,
    EMP_NAME,
    HIRE_DATE,
    SALARY
FROM EMPLOYEE
WHERE 1=0;

CREATE TABLE EMP_NEW
AS
SELECT
    EMP_ID,
    EMP_NAME,
    HIRE_DATE,
    SALARY
FROM EMPLOYEE
WHERE 1=0;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

INSERT ALL
    WHEN HIRE_DATE < '2000/01/01' THEN
    INTO EMP_OLD
    VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    WHEN HIRE_DATE >= '2000/01/01' THEN
    INTO EMP_NEW
    VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    SELECT
        EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

-- UPDATE 테이블명 SET 컬럼명 = 바꿀값, 컬럼명 = 바꿀값, ...
-- [WHERE 컬럼명 비교연산자 비교값 ]

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * 
FROM DEPT_COPY
WHERE DEPT_ID = 'D9'; --총무부

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

SELECT * 
FROM DEPT_COPY
WHERE DEPT_ID = 'D9'; --전략기획팀

CREATE TABLE EMP_SALARY
AS
SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY,
    BONUS
FROM EMPLOYEE;

SELECT
    *
FROM EMP_SALARY
WHERE EMP_NAME IN('유재식','방명수');

-- 평상시 유재식 사원을 부러워하던 방명수 사원의 급여와 
-- 보너스율을 유재식 사원과 동일하게 변경을 해주기로 했다. 
-- 이를 반영하는 UPDATE 문을 작성하시오
UPDATE EMP_SALARY ES
SET ES.SALARY = ( SELECT SALARY
                    FROM EMP_SALARY
                    WHERE EMP_NAME ='유재식'),
    ES.BONUS = (SELECT BONUS
                    FROM EMP_SALARY
                    WHERE EMP_NAME ='유재식')
WHERE EMP_NAME = '방명수';

-- 다중열 서브쿼리를 이용한 UPDATE 문
-- 방명수 사원의 급여인상소식을 전해들은 다른직원들이 
-- 단체로 파업을 진행했다
-- 노옹철, 전형돈, 정중하, 하동운 사원의 급여와 보너스를 
-- 유재식 사원의 급여와  보너스 와 같게 변경하는 UPDATE문을 작성하시오
SELECT *
FROM EMP_SALARY
WHERE EMP_NAME IN('노옹철', '전형돈', '정중하', '하동운');

UPDATE EMP_SALARY ES
SET (ES.SALARY, ES.BONUS)=( SELECT SALARY, BONUS
                            FROM EMP_SALARY
                            WHERE EMP_NAME ='유재식'),
WHERE ES.EMP_NAME IN('노옹철', '전형돈', '정중하', '하동운');

--다중행 서브쿼리를 이용한 UPDATE
-- EMP_SALARY 테이블에서 아시아 근무지역에 근무하는 직원의 보너스를 0.5 로 변경 하시오
SELECT *
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
WHERE LOCAL_NAME LIKE 'ASIA%';

UPDATE EMP_SALARY
SET BONUS = 0.5
WHERE EMP_ID IN (SELECT EMP_ID
                    FROM EMPLOYEE A
                    JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
                    JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
                    WHERE LOCAL_NAME LIKE 'ASIA%');

-- UPDATE 시 변경할 값은 해당 컬럼에 대한 제약조건에 위배되지 않아야한다.
UPDATE EMPLOYEE
SET DEPT_CODE = '65' --FOREIGN KEY 제약조건에 위배
WHERE DEPT_CODE = 'D6';

UPDATE EMPLOYEE
SET EMP_NAME = NULL --NOT NULL 제약조건에 위배
WHERE EMP_ID = 200;

UPDATE EMPLOYEE
SET EMP_NO ='621235-1985634' --UNIQUE 제약조건에 위배
WHERE EMP_ID = 201;
SELECT * FROM EMPLOYEE WHERE EMP_ID = 200;

COMMIT;


--DELETE : 테이블의 행을 삭제하는 구문이다 , 행의 갯수가 줄어듬
--DELETE FROM 테이블명 WHERE 조건설정
-- 만약 WHERE 에 조건을 설정하지않으면 모든 행이 삭제

DELETE FROM EMPLOYEE;
SELECT * FROM EMPLOYEE;
ROLLBACK;

SELECT * FROM EMPLOYEE WHERE EMP_NAME = '장재현';
DELETE FROM EMPLOYEE WHERE EMP_NAME = '장재현';

ROLLBACK;

--FOREIGN KEY 제약조건이 설정되어있는경우
--참조되고 있는 값에 대해서는 삭제할수없다.
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;
DELETE FROM DEPARTMENT WHERE DEPT_ID ='D1';

--참조되고 있지않은 값에 대해서는 삭제할수 있다.
DELETE FROM DEPARTMENT WHERE DEPT_ID ='D3';
ROLLBACK;

-- 삭제시 FOREGIN KEY 제약조건으로 컬럼삭제가 불가능 한경우
-- 제약조건을 비활성화 시킬수 있다.

ALTER TABLE EMPLOYEE
DISABLE CONSTRAINT SYS_C007164 CASCADE;
DELETE FROM DEPARTMENT WHERE DEPT_ID ='D1';
SELECT * FROM DEPARTMENT;

ROLLBACK;

ALTER TABLE EMPLOYEE
ENABLE CONSTRAINT SYS_C007164;

-- TRUNCATE : 테이블의 전체행을 삭제할시 사용된다
--            DELETE  보다 수행속도 빠르다
--            ROLLBACK 을 통해 복구 할수 없다.

SELECT * FROM EMP_SALARY;
COMMIT;

DELETE FROM EMP_SALARY;
ROLLBACK;

TRUNCATE TABLE EMP_SALARY;


--MERGE :  구조가 같은 두개의 테이블을 하나로 합치는 기능을한다
--         테이블에서 지정하는 조건의 값이 존재하면  UPDATE
--         조건의 값이 없으면 INSERT

CREATE TABLE M_TEST01(
    ID CHAR(20),
    NAME VARCHAR2(20)
);

INSERT INTO M_TEST01 VALUES('user11','전재은');
INSERT INTO M_TEST01 VALUES('user22','김재호');
INSERT INTO M_TEST01 VALUES('user33','김태훈');

CREATE TABLE M_TEST02(
    ID CHAR(20),
    NAME VARCHAR2(20)
);

INSERT INTO M_TEST02 VALUES('user12','공구민');
INSERT INTO M_TEST02 VALUES('user22','구승환');
INSERT INTO M_TEST02 VALUES('user32','권영아');

SELECT * FROM M_TEST01;
SELECT * FROM M_TEST02;

SELECT * FROM M_TEST01
UNION
SELECT * FROM M_TEST02
ORDER BY 2 DESC;

--MERGE하기 (M_TEST01에 M_TEST02를 병합)

MERGE INTO M_TEST01 M1 USING M_TEST02 M2 ON (M1.ID=M2.ID)
WHEN MATCHED THEN --위에 ON 조건이 참이면 UPDATE
UPDATE --수정
SET M1.NAME = M2.NAME
WHEN NOT MATCHED THEN --위의 ON 조건이 참이 아니면 INSERT
INSERT
    (M1.ID, M1.NAME)
VALUES
    (M2.ID, M2.NAME); --M1의 값이 변경되고 추가되었다.

SELECT * FROM M_TEST01;