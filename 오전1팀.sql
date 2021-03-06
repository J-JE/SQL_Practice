--함수

-- 부서별로 월급의 평균을 구하고 최고 월급자와 최저 월급자를 구한 뒤
-- 평균월급이 높은 순으로 출력하자
SELECT DEPT_CODE, AVG(SALARY), MAX(SALARY), MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 2 DESC;


-- 급여가 4,000,000원 이상인 모든 사람은 급여의 20% 세금으로 내야한다는 법이 생겼다. 
-- 세금을 내야 하는 직원들의 이름, 급여, 세금(원화로 출력할 것)을 출력하자
SELECT 
    EMP_NAME 이름,
    TO_CHAR(SALARY,'L99,999,999') 급여,
    TO_CHAR(SALARY*0.2,'L99,999,999') 세금
FROM EMPLOYEE
WHERE SALARY >=4000000;




--JOIN

-- 직급이 과장이면서 아시아 지역에 근무하는 남직원 조회
-- 사번, 이름, 주민번호, 직급명, 부서명, 근무지역명 조회
-- 주민번호 뒷자리 1자리 이후는 *로 표시되게
-- 오라클, ANSI 둘 다

--ORACLE
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    SUBSTR(A.EMP_NO, 1,8)||'******' 주민번호,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    D.LOCAL_NAME 근무지역명
FROM EMPLOYEE A, JOB B, DEPARTMENT C, LOCATION D
WHERE A.JOB_CODE = B.JOB_CODE
AND A.DEPT_CODE = C.DEPT_ID
AND C.LOCATION_ID = D.LOCAL_CODE -- 여기까지는 조인
AND B.JOB_NAME = '과장' AND D.LOCAL_NAME LIKE 'ASIA%' -- 여기부터는 조건
AND SUBSTR(A.EMP_NO,8,1) = '1';

--ANSI
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    SUBSTR(A.EMP_NO, 1,8)||'******' 주민번호,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    D.LOCAL_NAME 근무지역명
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID
JOIN LOCATION D ON C.LOCATION_ID = D.LOCAL_CODE
WHERE B.JOB_NAME = '과장'
AND D.LOCAL_NAME LIKE 'ASIA%'
AND SUBSTR(A.EMP_NO,8,1) = '1';


-- 직급이 사원이 아니고 급여등급이 S3이상에 해당하는 직원들 조회
-- 사번, 이름, 직급, 급여, 급여등급 조회
-- 오라클, ANSI 둘 다

--ORACLE
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    C.JOB_NAME 직급,
    A.SALARY 급여,
    A.SAL_LEVEL 급여등급
FROM EMPLOYEE A, SAL_GRADE B, JOB C
WHERE A.SALARY BETWEEN B.MIN_SAL AND B.MAX_SAL
AND A.JOB_CODE = C.JOB_CODE
AND B.SAL_LEVEL IN ('S1', 'S2', 'S3')
AND C.JOB_CODE NOT IN 'J7';


--ANSI
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    C.JOB_NAME 직급,
    A.SALARY 급여,
    A.SAL_LEVEL 급여등급
FROM EMPLOYEE A
JOIN SAL_GRADE B ON (A.SALARY BETWEEN B.MIN_SAL AND B.MAX_SAL)
JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
WHERE B.SAL_LEVEL IN ('S1', 'S2', 'S3')
AND C.JOB_CODE NOT IN 'J7';




--서브쿼리

-- EMPLOYEE 테이블 기준
-- 부서코드별 월급평균 보다 많이 받는 사원번호, 사원 이름, 부서명, 직급명, 월급 구하기
SELECT 
    A.EMP_ID 사번,
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    A.SALARY 지역명
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
LEFT JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
WHERE A.SALARY > ANY (SELECT
                    	FLOOR(AVG(SALARY))
                    	FROM EMPLOYEE 
                    	GROUP BY DEPT_CODE);
                        

-- 직원 테이블에서 보너스 포함한 연봉이 낮은 순으로 5위까지
-- 사번, 이름, 부서명, 직급명, 지역명 조회하세요 (공동순위 포함)
SELECT
   A.*
FROM (SELECT
        A.EMP_ID 사번,
        A.EMP_NAME 이름,
        B.DEPT_TITLE 부서명,
        C.JOB_NAME 직급명,
        D.LOCAL_NAME 지역명,
        DENSE_RANK() OVER(ORDER BY (A.SALARY + A.SALARY*NVL(BONUS,0))*12) 순위
    FROM EMPLOYEE A
    JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
    JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
    JOIN LOCATION D ON B.LOCATION_ID = D.LOCAL_CODE
    ) A
WHERE A.순위 <= 5;




--DDL

-- 1번
-- EMP_COPYTEST 테이블 만들기 (EMPLOYEE를 이용해서 복제)
-- EMP_COPYTEST 테이블에 NEW_ADDRESS , NEW_PHONE 컬럼 추가하고
-- NEW_PHONE 컬럼 삭제
-- EMP_COPYTEST 테이블의 이름을 EMP_TESTCOPY123 으로 변경하기
CREATE TABLE EMP_COPYTEST 
AS
SELECT * FROM EMPLOYEE;

ALTER TABLE EMP_COPYTEST
ADD(NEW_ADDRESS VARCHAR2(50))
ADD(NEW_PHONE VARCHAR2(20));

ALTER TABLE EMP_COPYTEST
DROP COLUMN NEW_PHONE;

ALTER TABLE EMP_COPYTEST
RENAME TO EMP_TESTCOPY123;


-- 2번
-- EMP_TESTCOPY123테이블 사번의 자료형을 VARCHAR(50)으로 바꾸고 사번 컬럼을 삭제
-- UPDATE1 컬럼을 만들고 제약조건을 (A,B)로만 선택되도록 하기
ALTER TABLE EMP_TESTCOPY123 
MODIFY DEPT_CODE VARCHAR(50);

ALTER TABLE EMP_TESTCOPY123 
DROP COLUMN DEPT_CODE;

ALTER TABLE EMP_TESTCOPY123
ADD(UPDATE1 CHAR(3) CONSTRAINT CK_UPDATE1 CHECK(UPDATE1 IN ('A', 'B')) );




--DML

-- LOCATION 테이블에서 LOCAL_NAME 이 아시아 인 사원의 
-- 이름, 입사일, 부서명, 근무지역명을 조회하여 
-- EMP_ASIA 테이블에 삽입하고
-- 아시아가 아닌 사원은 EMP_OTHER에 삽입하세요
SELECT C.EMP_NAME, C.HIRE_DATE, B.DEPT_TITLE ,A.LOCAL_NAME
FROM LOCATION A
JOIN DEPARTMENT B ON A.LOCAL_CODE = B.LOCATION_ID 
JOIN EMPLOYEE C ON B.DEPT_ID = C.DEPT_CODE
WHERE LOCAL_NAME LIKE 'ASIA%';

--테이블 2개 생성
CREATE TABLE EMP_ASIA
AS SELECT C.EMP_NAME, C.HIRE_DATE, B.DEPT_TITLE ,A.LOCAL_NAME
   FROM LOCATION A
   JOIN DEPARTMENT B ON A.LOCAL_CODE = B.LOCATION_ID 
   JOIN EMPLOYEE C ON B.DEPT_ID = C.DEPT_CODE
WHERE 1=0;

CREATE TABLE EMP_OTHER
AS SELECT C.EMP_NAME, C.HIRE_DATE, B.DEPT_TITLE ,A.LOCAL_NAME
   FROM LOCATION A
   JOIN DEPARTMENT B ON A.LOCAL_CODE = B.LOCATION_ID 
   JOIN EMPLOYEE C ON B.DEPT_ID = C.DEPT_CODE
WHERE 1=0;

SELECT * FROM EMP_ASIA;
--조건절이 같은 두개의 쿼리를 사용하기 때문에 INSERT ALL을 사용해 데이터 삽입
INSERT ALL
    WHEN LOCAL_NAME LIKE 'ASIA%' THEN --ASIA = EMP_ASIA
    INTO EMP_ASIA
    VALUES (EMP_NAME, HIRE_DATE, DEPT_TITLE, LOCAL_NAME)
    
    WHEN LOCAL_NAME NOT LIKE 'ASIA%' THEN --NOT ASIA = EMP_OTHER
    INTO EMP_OTHER
    VALUES (EMP_NAME, HIRE_DATE, DEPT_TITLE, LOCAL_NAME)
    
    SELECT C.EMP_NAME, C.HIRE_DATE, B.DEPT_TITLE ,A.LOCAL_NAME
    FROM LOCATION A
    JOIN DEPARTMENT B ON A.LOCAL_CODE = B.LOCATION_ID 
    JOIN EMPLOYEE C ON B.DEPT_ID = C.DEPT_CODE;


-- EMPLOYEE 테이블을 복사한 EMP_EXAMPLE 테이블을 만든 후
-- 모든 사원의 월급을 전 사원의 월급 평균을 만 단위에서 내림 한 값 으로 바꾸고
-- 입사일을 가장 최근에 입사한 사원의 날짜로 바꾸시오
CREATE TABLE EMP_EXAMPLE
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_EXAMPLE;

UPDATE EMP_EXAMPLE EE
SET EE.SALARY = (SELECT TRUNC(AVG(SALARY),-5) FROM EMP_EXAMPLE),
    EE.HIRE_DATE = (SELECT MAX(HIRE_DATE) FROM EMP_EXAMPLE);
