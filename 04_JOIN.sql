/*@ 조인문(JOIN)
-> 여러테이블의 레코드를 조합하여 하나의 열로 표현한것, 하나로 합쳐서 결과를 조회한다. 
-> 두 개 이상의 테이블에서 연관성을 가지고있는 데이터 들을 따로 분류하여 새로운 가상의 테이블을 이용하여 출력
   서로다른 테이블에서 각각 공통값을 이용함으로써 필드를 조합함
   즉, 관계형 데이터베이스에서 SQL 문을 이용한 테이블간 "관계"를 맺는 방법
   
* JOIN 시 컬럼이 같을 경우와 다를 경우 2가지 방법이있다.
- ORACLE 전용구문
- ANSI 표준구문
(ANSI( 미국 국립 표준 협회 => 산업표준을 재정하는 단체 ) 에서 지정한 DBMS 에 상관없이 공통으로 사용하는 표준 SQL)
*/

--오라클 전용구문 
-- FROM 절에 ','  로 구분하여 합치게될 테이블명을 기술하고 
-- WHERE 절에 합치기위해 사용할 컬럼명을 명시한다.


--연결에 사영할 두 컬럼명이 다른경우!
SELECT --제대로 JOIN 됐는지 확인 후 SELECT로 뽑아와야함
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,DEPT_TITLE
FROM EMPLOYEE
    ,DEPARTMENT --DEPT_CODE가 없는 두 값은 출력X (NULL값은 제외됨),(OUTERJOIN은 가능함)
WHERE DEPT_CODE = DEPT_ID;

--연결에 사용할 두 컬럼명이 같은경우
SELECT
    EMP_ID
    ,EMP_NAME
    ,EMPLOYEE.JOB_CODE --중복되는 컬럼만 어떤 테이블인지 명시해주면 된다.
    ,JOB_NAME
FROM EMPLOYEE
    ,JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

SELECT
    A.EMP_ID --앞에 테이블의 별칭을 붙여주는게 가독성이 좋다.
    ,A.EMP_NAME --(처음보는 쿼리의 경우 한눈에 알아보기 어렵기 때문)
    ,A.JOB_CODE
    ,B.JOB_NAME
FROM EMPLOYEE A
    ,JOB B
WHERE A.JOB_CODE = B.JOB_CODE;

-- ANSI 표준 구문
-- 연결에 사용할 컬럼명이 같은 경우 USING(컬럼명)을 사용함
SELECT
    EMP_ID
    ,EMP_NAME
    ,JOB_CODE
    ,JOB_NAME
FROM EMPLOYEE
INNER JOIN JOB USING(JOB_CODE); --INNER JOIN, JOIN은 같다.

--컬럼명이 같은 경우에도 ON()을 사용할 수 있다.

SELECT
    A.EMP_ID
    ,A.EMP_NAME
    ,A.JOB_CODE
    ,B.JOB_NAME
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE=B.JOB_CODE;

--연결에 사용할 컬럼명이 다를경우 ON(컬럼명)을 사용한다.

SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    DEPT_TITLE
FROM EMPLOYEE --JOIN을 걸 때는 주 테이블이 있어야한다.
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;


-- 부서 테이블과 지역 테이블을 조인하여 테이블에 모든 데이터를 조회하세요
--ORACLE 전용
SELECT
    *
FROM DEPARTMENT A
    ,LOCATION B
WHERE A.LOCATION_ID = B.LOCAL_CODE;

--ANSI표준

SELECT
    B.*, A.DEPT_ID
FROM DEPARTMENT A
JOIN LOCATION B ON A.LOCATION_ID=B.LOCAL_CODE; --컬럼명이 다르기 때문에 별칭 생략 가능


--조인은 기본이 EQUAL JOIN(등가조인) 이다(=EQU JOIN)
--연결이 되는 컬럼의 값이 일치하는 행들만 조인됨(일치하는 값이 없는 경우는 조인에서 제외되어 출력)

--JOIN 기본은 INNER JOIN(=JOIN) & EQU JOIN


--OUTER JOIN : 두테이블의 지정하는 컬럼값이 일치하지 않는 행도 조인에 포함을 시킴
--             반드시 OUTER JOIN 임을 명시해야한다. 

--1. LEFT OUTER JOIN (= LEFT JOIN) : 합치기에 사용된 두테이블중에서 왼편에 기술된 테이블의 행을 기준으로 하여 JOIN

--2. RIGHT OUTER JOIN (= RIGHT JOIN) : 합치기에 사용된 두테이블중에서 오른편에 기술된 테이블의 행을 기준으로 하여 JOIN

--3. FULL OUTER JOIN (= FULL JOIN): 합치기에 사용된 두테이블이 가진 모든행을 결과에 포함하여 JOIN

SELECT
    *
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;


--LEFT OUTER JOIN
--ANSI 표준
SELECT
    *
FROM EMPLOYEE
--LEFT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID; --EMP테이블을 기준으로
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

--오라클 전용 구문
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE,
    DEPARTMENT
WHERE DEPT_CODE=DEPT_ID(+);


--RIGHT OUTER JOIN
--ANSI표준
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE
--RIGHT OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID; --DEPT테이블을 기준으로
RIGHT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

--ORACLE전용구문
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE,
    DEPARTMENT
WHERE DEPT_CODE(+)=DEPT_ID;


--FULL OUTER JOIN
--ANSI표준
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE
--FULL OUTER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
FULL JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

--ORACLE전용구문
--오라클 전용 구문으로는  FULL OUTER JOIN이 불가능
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE,
    DEPARTMENT
WHERE DEPT_CODE(+)=DEPT_ID(+); --오류

--CROSS JOIN : 카테시안 곱이라고도 한다.
--             조인이되는 테이블의 각행들이 모두 매핑된 데이터가 검색되는 방법 (곱집합)

SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT; --23(사원수) * 9(DEPT_TITLE) = 207(모든 경우의 수)

--ORACLE 전용 구문
SELECT
    EMP_NAME,
    DEPT_TITLE
FROM EMPLOYEE,
    DEPARTMENT
WHERE DEPT_CODE=DEPT_ID;--중복되는 키 값이 없어서 걸 수 없다.

--NON EQUAL JOIN(NON EQU JOIN)
--: 지정한 컬럼의 값이 일치하는 경우가 아닌 , 값의 범위에 포함하는 행들을 연결 하는 방식 
--ANSI 표준

SELECT
    A.EMP_NAME,
    A.SALARY,
    A.SAL_LEVEL,
    B.SAL_LEVEL SAL_LEVEL_S
FROM EMPLOYEE A
JOIN SAL_GRADE B ON A.SALARY BETWEEN B.MIN_SAL AND B.MAX_SAL;

-- SELF JOIN : 같은 테이블을 조인하는 경우 자기 자신과 조인을 맺는것
-- 동일한 테이블내에서 원하는 정보를 한번에 가져올수 없을 때 사용
SELECT
--    *
    A.EMP_ID,
    A.EMP_NAME,
    A.DEPT_CODE,
    A.MANAGER_ID,
    B.EMP_NAME MNAME
FROM EMPLOYEE A,
    EMPLOYEE B
WHERE A.MANAGER_ID = B.EMP_ID;

-- 다중조인 : N 개의 테이블을 조회할때 사용 
-- ANSI표준
-- 순서중요

SELECT
--    *
    A.EMP_ID,
    A.EMP_NAME,
    A.DEPT_CODE,
    B.DEPT_TITLE,
    C.LOCAL_NAME
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE;

--오라클 전용 구문(사번이 200번인 사원의 정보)
SELECT
--    *
    A.EMP_ID,
    A.EMP_NAME,
    A.DEPT_CODE,
    B.DEPT_TITLE,
    C.LOCAL_NAME
FROM EMPLOYEE A,
    DEPARTMENT B,
    LOCATION C
WHERE A.DEPT_CODE = B.DEPT_ID
AND B.LOCATION_ID = C.LOCAL_CODE
AND A.EMP_ID = 200;

-- 직급이 대리이면서 아시아 지역에 근무하는 직원조회
-- 사번, 이름 , 직급명, 부서명, 근무지역명, 급여를 조회하세요 
-- (조회시에는 모든 컬럼에 테이블 별칭을 사용하는것이 좋다. )
--ANSI표준
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.JOB_NAME,
    C.DEPT_TITLE,
    D.LOCAL_NAME,
    A.SALARY
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE= B.JOB_CODE
JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID
JOIN LOCATION D ON C.LOCATION_ID = D.LOCAL_CODE
WHERE A.JOB_CODE ='J6'
--AND D.LOCAL_CODE BETWEEN 'L1' AND 'L3';
--AND D.LOCAL_CODE IN ('L1','L2','L3');
AND D.LOCAL_NAME LIKE 'ASIA%';

--오라클 전용
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.JOB_NAME,
    C.DEPT_TITLE,
    D.LOCAL_NAME,
    A.SALARY
FROM  EMPLOYEE A,
    JOB B,
    DEPARTMENT C,
    LOCATION D
WHERE 1=1
AND A.JOB_CODE= B.JOB_CODE
AND A.DEPT_CODE = C.DEPT_ID
AND C.LOCATION_ID = D.LOCAL_CODE
AND A.JOB_CODE ='J6'
AND D.LOCAL_NAME LIKE 'ASIA%';




-- JOIN 연습문제

-- 1. 2020년 12월 25일이 무슨 요일인지 조회하시오.
SELECT TO_CHAR(TO_DATE('20/12/25', 'YY/MM/DD'),'DAY') "2020/12/25"
FROM DUAL;

-- 2. 주민번호가 70년대 생이면서 성별이 여자이고, 
--    성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.

--ANSI
SELECT
    A.EMP_NAME 사원명,
    A.EMP_NO 주민번호,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C ON A.JOB_CODE= C.JOB_CODE
WHERE A.EMP_NO LIKE '7%'
AND SUBSTR(A.EMP_NO,8,1) LIKE '2'
AND A.EMP_NAME LIKE '전%';

--ORACLE
SELECT
    A.EMP_NAME 사원명,
    A.EMP_NO 주민번호,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명
FROM EMPLOYEE A, DEPARTMENT B, JOB C
WHERE 1=1
AND A.DEPT_CODE = B.DEPT_ID
AND A.JOB_CODE= C.JOB_CODE
AND A.EMP_NO LIKE '7%'
AND SUBSTR(A.EMP_NO,8,1) LIKE '2'
AND A.EMP_NAME LIKE '전%';

-- 3. 가장 나이가 적은 직원의 사번, 사원명, 
--    나이, 부서명, 직급명을 조회하시오.

--ANSI
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    EXTRACT(YEAR FROM SYSDATE)
    -EXTRACT(YEAR FROM (TO_DATE(SUBSTR(A.EMP_NO,1,2),'RR'))) 나이,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C ON A.JOB_CODE= C.JOB_CODE
WHERE A.EMP_NO = (SELECT MAX(EMP_NO) FROM EMPLOYEE);

--ORACLE
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    EXTRACT(YEAR FROM SYSDATE)
    -EXTRACT(YEAR FROM (TO_DATE(SUBSTR(A.EMP_NO,1,2),'RR'))) 나이,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명
FROM EMPLOYEE A, DEPARTMENT B, JOB C
WHERE 1=1
AND A.DEPT_CODE = B.DEPT_ID
AND A.JOB_CODE= C.JOB_CODE
AND A.EMP_NO = (SELECT MAX(EMP_NO) FROM EMPLOYEE);


--SELECT 
--       E.EMP_ID
--     , E.EMP_NAME
--     , EXTRACT(YEAR FROM SYSDATE)
--     - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(E.EMP_NO,1,2), 'RR'))) + 1 AS 나이
--     , D.DEPT_TITLE
--     , J.JOB_NAME
--  FROM EMPLOYEE E
--     , DEPARTMENT D
--     , JOB J
-- WHERE E.DEPT_CODE = D.DEPT_ID
--   AND E.JOB_CODE = J.JOB_CODE
--   AND EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 = (
--    SELECT
--        MIN(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1) 
--    FROM EMPLOYEE);


-- 4. 이름에 '형'자가 들어가는 직원들의
-- 사번, 사원명, 부서명을 조회하시오.

--ANSI
SELECT 
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
WHERE EMP_NAME LIKE '%형%';

--ORACLE
SELECT 
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명
FROM EMPLOYEE A, DEPARTMENT B
WHERE A.DEPT_CODE = B.DEPT_ID
AND EMP_NAME LIKE '%형%';

-- 5. 해외영업팀에 근무하는 사원명, 
--    직급명, 부서코드, 부서명을 조회하시오.

--ANSI
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    A.DEPT_CODE 부서코드,
    C.DEPT_TITLE 부서명
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID
WHERE DEPT_TITLE LIKE '해외영업%';

--ORACLE
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    A.DEPT_CODE 부서코드,
    C.DEPT_TITLE 부서명
FROM EMPLOYEE A, JOB B, DEPARTMENT C
WHERE 1=1
AND A.JOB_CODE = B.JOB_CODE
AND A.DEPT_CODE = C.DEPT_ID
AND DEPT_TITLE LIKE '해외영업%';

-- 6. 보너스를 받는 직원들의 사원명, 
--    보너스, 부서명, 근무지역명을 조회하시오.(보너스를 받지않는 사원도 모두 출력)

--ANSI
SELECT
    A.EMP_NAME 사원명,
    A.BONUS 보너스,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 근무지역명
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
LEFT JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE;
--WHERE BONUS IS NOT NULL;

--ORACLE
SELECT
    A.EMP_NAME 사원명,
    A.BONUS 보너스,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 근무지역명
FROM EMPLOYEE A, DEPARTMENT B, LOCATION C
WHERE A.DEPT_CODE = B.DEPT_ID(+)
AND B.LOCATION_ID = C.LOCAL_CODE(+);
--WHERE BONUS IS NOT NULL;

-- 7. 부서코드가 D2인 직원들의 사원명, 
--    직급명, 부서명, 근무지역명을 조회하시오.

--ANSI
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    D.LOCAL_NAME 근무지역명
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID
JOIN LOCATION D ON C.LOCATION_ID = D.LOCAL_CODE
WHERE DEPT_CODE LIKE 'D2';

--ORACLE
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    D.LOCAL_NAME 근무지역명
FROM EMPLOYEE A, JOB B, DEPARTMENT C, LOCATION D
WHERE 1=1
AND A.JOB_CODE = B.JOB_CODE
AND A.DEPT_CODE = C.DEPT_ID
AND C.LOCATION_ID = D.LOCAL_CODE
AND DEPT_CODE LIKE 'D2';

-- 8. 본인 급여 등급의 최소급여(MIN_SAL)를 초과하여 급여를 받는 직원들의
--    사원명, 직급명, 급여, 보너스포함 연봉을 조회하시오.
--    연봉에 보너스포인트를 적용하시오.

--ANSI
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    A.SALARY 급여,
    A.SALARY*(NVL(BONUS,0)+1)*12 "보너스포함 연봉"
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID
JOIN SAL_GRADE D ON A.SAL_LEVEL=D.SAL_LEVEL
WHERE A.SALARY > D.MIN_SAL;

--ORACLE
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    A.SALARY 급여,
    A.SALARY*(NVL(BONUS,0)+1)*12 "보너스포함 연봉"
FROM EMPLOYEE A, JOB B, DEPARTMENT C, SAL_GRADE D
WHERE 1=1
AND A.JOB_CODE = B.JOB_CODE
AND A.DEPT_CODE = C.DEPT_ID
AND A.SAL_LEVEL=D.SAL_LEVEL
AND A.SALARY > D.MIN_SAL;

-- 9. 한국(KO)과 일본(JP)에 근무하는 직원들의 
--    사원명, 부서명, 지역명, 국가명을 조회하시오.

--ANSI
SELECT
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 지역명,
    D.NATIONAL_NAME 국가명
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
JOIN NATIONAL D ON C.NATIONAL_CODE = D.NATIONAL_CODE
WHERE C.NATIONAL_CODE IN('KO', 'JP');

--ORACLE
SELECT
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    C.LOCAL_NAME 지역명,
    D.NATIONAL_NAME 국가명
FROM EMPLOYEE A, DEPARTMENT B, LOCATION C, NATIONAL D
WHERE A.DEPT_CODE = B.DEPT_ID
AND B.LOCATION_ID = C.LOCAL_CODE
AND C.NATIONAL_CODE = D.NATIONAL_CODE
AND C.NATIONAL_CODE IN('KO', 'JP');

-- 10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 
--     동료이름을 조회하시오.self join 사용

--ANSI
SELECT
    A.EMP_NAME 사원명,
    A.DEPT_CODE 부서코드,
    B.EMP_NAME 동료이름
FROM EMPLOYEE A
JOIN EMPLOYEE B ON A.DEPT_CODE = B.DEPT_CODE
WHERE A.EMP_NAME != B.EMP_NAME
ORDER BY 2, 1;

--SELECT
--    DEPT_CODE,
--    COUNT(*)
--FROM EMPLOYEE
--GROUP BY DEPT_CODE;

--ORACLE
SELECT
    A.EMP_NAME 사원명,
    A.DEPT_CODE 부서코드,
    B.EMP_NAME 동료이름
FROM EMPLOYEE A, EMPLOYEE B
WHERE A.DEPT_CODE = B.DEPT_CODE
AND A.EMP_NAME != B.EMP_NAME
ORDER BY 2, 1;

-- 11. 보너스포인트가 없는 직원들 중에서 직급코드가 
--     J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.
--     단, join과 IN 사용할 것

--ANSI
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    A.SALARY
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
WHERE A.BONUS IS NULL
AND A.JOB_CODE IN ('J4','J7');

--ORACLE
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    A.SALARY
FROM EMPLOYEE A, JOB B
WHERE A.JOB_CODE = B.JOB_CODE
AND A.BONUS IS NULL
AND A.JOB_CODE IN ('J4','J7');

--12. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.

SELECT
    COUNT(*)-COUNT(ENT_DATE) 재직중,
    COUNT(ENT_DATE) 퇴사
FROM EMPLOYEE;

SELECT
    DECODE(SUBSTR(ENT_YN,1,1),'Y','재직중','N','퇴사') 재직여부,
    COUNT(*) 직원수
FROM EMPLOYEE
GROUP BY ENT_YN;

---------
--연봉, 보너스 조회하는
SELECT
    (SALARY + (SALARY* NVL(BONUS,0)))*12 연봉,
    NVL(BONUS,0) 보너스
FROM EMPLOYEE;    

--20년 이상 근속
SELECT
    EMP_NAME,
    SALARY
FROM EMPLOYEE
WHERE MONTHS_BETWEEN(SYSDATE,HIRE_DATE)>=20*12
AND ENT_DATE IS NULL;--퇴사자 제외