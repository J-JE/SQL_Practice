--문제 1
--팀원(직원)이 3명 이상인 부서의 부서 코드, 팀원 수, 부서 별 평균 연봉, 순위(평균 연봉)를 구하시오.
--이 때 부서 별 평균 연봉의 순위는 가장 큰 3개의 부서만 구하시오.
--(단, 부서 코드가 없는 직원은 제외한다.)
SELECT * 
FROM (SELECT
            DEPT_CODE "부서 코드",
            COUNT(*) "팀원 수",
            AVG(SALARY*12) "평균 연봉"
        FROM EMPLOYEE
        WHERE DEPT_CODE IS NOT NULL
        GROUP BY DEPT_CODE
        HAVING COUNT(*) >=3
        ORDER BY 3 DESC)
WHERE ROWNUM <=3;

--문제 2
--부서 별 직원 소계, 부서 별 각 직급의 인원수, 전체 직원 수를 구하시오. (직급 별 소계는 하지 않는다)
--비고 컬럼을 만들어 부서 별 소계는 '부서총합계'로 표시하고 직급별 인원수는 '-'로 표시하시오.
--비고 컬럼에 전 직원 총 합계는 '전직원총합계'로 표시하시오.
--이 때, 인원수는 숫자(수) 뒤 '명'이 같이 나오도록 하고 부서 명과 직급 명 모두 오름차순으로 하시오.
--(단, 부서 명과 직급 명이 없는(NULL) 직원도 조회하되 ‘-’로 표시하시오.)
SELECT
    NVL(B.DEPT_TITLE,'-') AS "부서 명",
    NVL(C.JOB_NAME,'-') AS "직급 명",
    COUNT(*)||'명' AS "인원수", 
    CASE
       WHEN GROUPING(B.DEPT_TITLE)=0 AND GROUPING(C.JOB_NAME) =1 THEN '부서총합계'
       WHEN GROUPING(B.DEPT_TITLE)=0 AND GROUPING(C.JOB_NAME) =0 THEN '-'
       ELSE '전직원총합계'
    END 비고
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE=B.DEPT_ID
LEFT JOIN JOB C ON A.JOB_CODE=C.JOB_CODE
GROUP BY ROLLUP(B.DEPT_TITLE,C.JOB_NAME)
ORDER BY B.DEPT_TITLE, C.JOB_NAME; --부서별 직급의 인원수

--문제 3
--EMPLOYEE 테이블에서 직급 별로 가장 많은 급여를 받는 사원들 중 직급 코드가 'J2' 또는 'J6'인 사원들의
--사원 명, 부서 명, 직급 코드, 급여, 연봉(보너스 포함, NULL인 수는 0으로)을 구하세요.
SELECT
    MAX(SALARY)
FROM EMPLOYEE
WHERE JOB_CODE IN ('J2','J6')
GROUP BY JOB_CODE;

SELECT
    A.EMP_NAME "사원 명",
    B.DEPT_TITLE "부서 명",
    A.JOB_CODE "직급 코드",
    A.SALARY "급여",
    A.SALARY*(NVL(A.BONUS,0)+1)*12 "연봉"
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE=B.DEPT_ID
WHERE (A.JOB_CODE,A.SALARY) IN (SELECT JOB_CODE, MAX(SALARY)
                                FROM EMPLOYEE
                                WHERE JOB_CODE IN ('J2','J6')
                                GROUP BY JOB_CODE);

--문제 4
--EMPLOYEE 테이블에서 이메일의 '_' 앞까지 문자가 네 글자인 사원의
--사원 번호, 사원 명, 부서 명, 직급 명, 이메일을 조회하세요.
SELECT
    A.EMP_NAME "사원 명",
    B.DEPT_TITLE "부서 명",
    C.JOB_NAME "직급 명",
    A.EMAIL "이메일"
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE=B.DEPT_ID
JOIN JOB C ON A.JOB_CODE=C.JOB_CODE
WHERE EMAIL LIKE '____/_%'ESCAPE '/';

--문제 5
--직급 코드와 직급별 급여 합계를 조회 후 급여 합계별 내림차순 정렬 하시오 (GROUP BY)
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 2 DESC;

--문제 6
--부서별 그룹의 급여 합계중 7백만원을 초과하는 부서코드와 급여합계를 조회하시오 (GROUP BY)
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY)>7000000;

--문제 7
--부서별 최소 급여를 받는 직원들보다/ 높은 급여를 받는 직원들의 이름, 직급코드, 부서코드, 급여를 모두 조회하시오 (SUB QUERY)
--*부서는 총 7 (null  포함)  부서 수를 제외한 인원이 나와야한다.
SELECT DEPT_CODE, MIN(SALARY)FROM EMPLOYEE GROUP BY DEPT_CODE;

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE,SALARY) NOT IN (SELECT DEPT_CODE,MIN(SALARY)FROM EMPLOYEE GROUP BY DEPT_CODE);

--문제 8
--휴대폰 번호가 011로 시작하는 사원들의 연봉 순위를 구하고 그 사원들의 사원이름, 직급명, 부서명, 핸드폰 번호, 연봉(보너스포함)을 출력하세요.
SELECT ROWNUM, A.*
FROM(SELECT
        A.EMP_NAME, B.JOB_NAME,
        C.DEPT_TITLE, A.PHONE,
        A.SALARY*(NVL(A.BONUS,0)+1)*12 연봉
    FROM EMPLOYEE A
    LEFT JOIN JOB B USING(JOB_CODE)
    LEFT JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID
    WHERE A.PHONE LIKE '011%'
    ORDER BY A.SALARY*(NVL(A.BONUS,0)+1)*12 DESC)A ;

--문제 9
--전형돈과 월급이 같거나 같은부서인 사원의 이름,부서명,급여, 근무일수(뒤에 일을 붙여서)를 추출
SELECT A.EMP_NAME, B.DEPT_TITLE, A.SALARY, CEIL(SYSDATE-HIRE_DATE)||'일' 근무일수
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE=B.DEPT_ID
WHERE (SALARY IN (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME ='전형돈')
OR DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME ='전형돈'))
AND EMP_NAME !='전형돈';

--문제 10
--하이유 사원은 자신보다 늦게 입사한 사람이 궁금해졌다. 하이유 사원보다 입사일이 늦은 사원들의
--사원명, 직급명, 부서명, 급여를 부서코드 기준으로 오름차순으로 출력하라
SELECT A.EMP_NAME, B.JOB_NAME, C.DEPT_TITLE, A.SALARY
FROM EMPLOYEE A
LEFT JOIN JOB B USING(JOB_CODE)
LEFT JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID
WHERE A.HIRE_DATE > (SELECT HIRE_DATE FROM EMPLOYEE WHERE EMP_NAME ='하이유')
ORDER BY A.DEPT_CODE;


