--1.EMPLOYEE 테이블에서 김씨 성을 가진 사원의 이름과 급여, 입사날짜를 조회하시오
--(조회하는 컬럼의 별칭을 이름, 급여, 입사날짜로 설정)
SELECT
    EMP_NAME 이름,
    SALARY 급여,
    HIRE_DATE 입사날짜
FROM EMPLOYEE
WHERE EMP_NAME LIKE '김%';


--2.직원이름, 직원들이 고용된 날짜(요일포함), 고용일에서 수요일과 가장 가까운 날짜, 근무 개월수(오늘날짜기준,소숫점없음)를 구하시오
SELECT
    EMP_NAME "직원이름",
    HIRE_DATE "고용된 날짜",
    NEXT_DAY(HIRE_DATE,'수요일') "고용일 수요일",
    CEIL(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)) "근무 개월수"
FROM EMPLOYEE;


--3.직원 명, 입사 일, 근무 일 수, 연봉, 세율을 구하시오. 이때, 연봉을 오름차순으로 정렬하시오. (CASE 이용)
--연봉 : (급여+(급여*보너스))*12
--세율 : 연봉 3000만원 이하는 0.03, 연봉 3000만원 이상 0.05, 연봉 5000만원 초과는 0.07
SELECT
    EMP_NAME AS "직원 명", 
    HIRE_DATE AS "입사 일", 
    CEIL(SYSDATE-HIRE_DATE) AS "근무 일 수", 
    (SALARY+(SALARY*NVL(BONUS,0)))*12 AS "연봉", 
    CASE 
        WHEN (SALARY+(SALARY*NVL(BONUS,0)))*12 > 50000000 THEN '0.07'
        WHEN (SALARY+(SALARY*NVL(BONUS,0)))*12 > 30000000 THEN '0.05'
        WHEN (SALARY+(SALARY*NVL(BONUS,0)))*12 <=30000000 THEN '0.03'
    END"세율"
FROM EMPLOYEE;


--4.매니저가 있는 직원들 중에서 직급코드가
--J2 혹은 J4인 직원들의 이름, 보너스포함 연봉, 직급명, 부서명을 조회하시오 (JOIN과 IN 사용)
SELECT
    A.EMP_NAME 이름,
    (A.SALARY+(A.SALARY*NVL(A.BONUS,0)))*12 AS "연봉",
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명
FROM EMPLOYEE A
JOIN JOB B USING(JOB_CODE)
JOIN DEPARTMENT C ON A.DEPT_CODE=C.DEPT_ID
WHERE MANAGER_ID IS NOT NULL
AND JOB_CODE IN('J2','J4');


--5.주민번호가 60년대 생이고 성별이 남자인 사람중에서, 이름에 '동'이 있는 직원은 제외한 직원들의 사번, 사원명, 주민번호, 부서명, 직급명, 연봉(보너스포함X)을 조회하시오.
---    ANSI표준, 오라클 전용구문 2개 풀이 할 것.
---    JOIN문 사용
--ANSI
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    A.EMP_NO 주민번호,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    A.SALARY*12 연봉
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE=B.DEPT_ID
LEFT JOIN JOB C USING(JOB_CODE)
WHERE SUBSTR(EMP_NO,1,2) BETWEEN 60 AND 69
AND SUBSTR(EMP_NO,8,1) =1
AND EMP_NAME NOT LIKE '%동%';
--ORACLE
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 사원명,
    A.EMP_NO 주민번호,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    A.SALARY*12 연봉
FROM EMPLOYEE A, DEPARTMENT B, JOB C
WHERE A.DEPT_CODE=B.DEPT_ID(+)
AND A.JOB_CODE=C.JOB_CODE(+)
AND SUBSTR(EMP_NO,1,2) BETWEEN 60 AND 69
AND SUBSTR(EMP_NO,8,1) =1
AND EMP_NAME NOT LIKE '%동%';


--6.근무 년수가 20년 이상이면서 대표, 부사장, 부장직을 가진 사원들의 사번, 직원명, 직급명, 부서명, 지역명을 출력하시오. 
--사번으로 오름차순 정렬, JOIN, INTERSECT를 사용
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 직원명,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    D.LOCAL_NAME 지역명
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE=B.JOB_CODE
JOIN DEPARTMENT C ON A.DEPT_CODE=C.DEPT_ID
JOIN LOCATION D ON C.LOCATION_ID=D.LOCAL_CODE
WHERE (SYSDATE-HIRE_DATE)/365 >=20
INTERSECT
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 직원명,
    B.JOB_NAME 직급명,
    C.DEPT_TITLE 부서명,
    D.LOCAL_NAME 지역명
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE=B.JOB_CODE
JOIN DEPARTMENT C ON A.DEPT_CODE=C.DEPT_ID
JOIN LOCATION D ON C.LOCATION_ID=D.LOCAL_CODE
WHERE B.JOB_NAME IN('대표','부사장','부장')
ORDER BY 1;

--7.부서코드 'D5'의 직급별 인원을 조회하시오
SELECT
    JOB_CODE,
    COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE, DEPT_CODE
HAVING DEPT_CODE = 'D5'
ORDER BY 1;


--8.’심봉선' 사원의 연봉보다 많이 받는 직원의 사번, 이름 , 부서명, 직급명, 연봉을 조회하세요 (연봉은 보너스 포함으로 할 것)
---   ANSI표준, 오라클 전용구문 2개 풀이 할 것.
--ANSI
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 주민번호,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    (A.SALARY+(A.SALARY*NVL(A.BONUS,0)))*12 AS "연봉"
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE=B.DEPT_ID
LEFT JOIN JOB C USING(JOB_CODE)
WHERE (A.SALARY+(A.SALARY*NVL(A.BONUS,0)))*12 >(
        SELECT (SALARY+(SALARY*NVL(BONUS,0)))*12
        FROM EMPLOYEE
        WHERE EMP_NAME ='심봉선');
--ORACLE
SELECT
    A.EMP_ID 사번,
    A.EMP_NAME 주민번호,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
    (A.SALARY+(A.SALARY*NVL(A.BONUS,0)))*12 AS "연봉"
FROM EMPLOYEE A, DEPARTMENT B, JOB C
WHERE A.DEPT_CODE=B.DEPT_ID(+)
AND A.JOB_CODE=C.JOB_CODE(+)
AND SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME ='심봉선');

--------수정

--9.직원 테이블에서 입사일자가 오래된 순인 5명의 사번, 이름, 부서명을 조회하시오
SELECT * 
FROM (SELECT
        A.EMP_ID 사번,
        A.EMP_NAME 이름,
        B.DEPT_TITLE 부서명
    FROM EMPLOYEE A
    LEFT JOIN DEPARTMENT B ON A.DEPT_CODE=B.DEPT_ID
    ORDER BY A.HIRE_DATE
    )
WHERE ROWNUM <=5;

--10.급여의 합계가 송씨 성을 가진 사람들의 평균보다 많이 받는 사람의 이름과 직책, 부서 조회하시오(송씨 성을 가진 직원 포함)
--(조회하는 컬럼의 별칭을 이름, 직책, 부서로 설정)
SELECT
    AVG(SALARY)
FROM EMPLOYEE
WHERE EMP_NAME LIKE '송%'; -- 송씨 성을 가진 사람들의 평균급여

SELECT
    A.EMP_NAME 이름,
    B.JOB_NAME 직책,
    C.DEPT_TITLE 부서
FROM EMPLOYEE A
LEFT JOIN JOB B ON A.JOB_CODE=B.JOB_CODE
LEFT JOIN DEPARTMENT C ON A.DEPT_CODE=C.DEPT_ID
WHERE SALARY > (SELECT
                    AVG(SALARY)
                FROM EMPLOYEE
                WHERE EMP_NAME LIKE '송%');
