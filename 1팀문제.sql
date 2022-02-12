--1. 하이유가 사수인 직원의 사번, 이름, 생년월일을 조회하시오
--(주민번호가 이상한 사번 214번은 제외)
SELECT
    EMP_ID 사번,
    EMP_NAME 이름,
    TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD'),'RRRR"년 "MM"월 "DD"일"')생년월일
FROM EMPLOYEE
WHERE MANAGER_ID = (SELECT EMP_ID FROM EMPLOYEE WHERE EMP_NAME = '하이유')
AND EMP_ID !='214';
--답
SELECT
    EMP_ID,
    EMP_NAME,
    TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD'), 'RR"년 "fmMM"월 "DD"일"') 생년월일
FROM EMPLOYEE
WHERE EMP_ID NOT IN ('200', '201', '214') AND MANAGER_ID = 207;

-- 2.사내 이벤트 당첨자는 이 달에 태어난 사원들이다.
--당첨자들의 사번, 이름, 아이디, 부서명을 조회하시오
--(단, 사번의 마지막 숫자는 *표시)
SELECT
    SUBSTR(EMP_ID,1,2)||'*' 사번,
    EMP_NAME 이름,
    SUBSTR(EMAIL,1,INSTR(EMAIL,'@',-1)-1) 아이디,
    DEPT_TITLE 부서명
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE SUBSTR(EMP_NO,3,2) = TO_CHAR(SYSDATE, 'MM');
--답
SELECT
    RPAD(SUBSTR(EMP_ID,1,2),3,'*') 사번,
    EMP_NAME 이름,
    SUBSTR(EMAIL,1,INSTR(EMAIL, '@')-1) 아이디,
    DEPT_TITLE 부서명
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE SUBSTR(EMP_NO,3,2) = EXTRACT(MONTH FROM SYSDATE);

--3.2000년 이전에 입사한 사람 중, 
--직급이 대리이거나 급여가 2000000 이하인 사원의  사원번호, 사원명, 부서명, 직급명, 보너스 포함
--연봉을 연봉 오름차순으로 조회하시오 (연봉은 원으로 표시)
SELECT
    A.EMP_ID 사원번호,
    A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명,
    C.JOB_NAME 직급명,
--    TO_CHAR((A.SALARY*(NVL(A.BONUS,0)+1))*12,'L999,999,999') 연봉
    (A.SALARY*(NVL(A.BONUS,0)+1))*12||'원' 연봉
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
LEFT JOIN JOB C USING (JOB_CODE)
WHERE HIRE_DATE <='2000/01/01'
AND (C.JOB_NAME = '대리' OR SALARY <2000000)
ORDER BY 5;
--답(연봉 원 표시,오름차순어디감?)
SELECT 
    A.EMP_ID,
    A.EMP_NAME,
    B.DEPT_TITLE,
    C.JOB_NAME,
    (A.SALARY*(1+NVL(BONUS, 0)))*12 연봉
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C USING(JOB_CODE)
WHERE EXTRACT(YEAR FROM HIRE_DATE) < 2000
AND (C.JOB_NAME LIKE '대리' OR A.SALARY < 2000000);
--백지우------
SELECT A.EMP_ID 사원번호, A.EMP_NAME 사원명,
    B.DEPT_TITLE 부서명, C.JOB_NAME 직급명,
    (A.SALARY + A.SALARY * NVL(A.BONUS, 0)) * 12||'원' 연봉
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
LEFT JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
WHERE A.HIRE_DATE < '2000/01/01'
AND (C.JOB_NAME = '대리' OR A.SALARY <= 2000000)
ORDER BY 5;

--공구민------
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.DEPT_TITLE,
    C.JOB_NAME,
    (A.SALARY + (A.SALARY * NVL(A.BONUS,0))*12)||'원' "연봉(원)"
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
WHERE A.HIRE_DATE < '2000/01/01'
AND (A.JOB_CODE = 'J6'
OR A.SALARY <= 2000000)
ORDER BY 5 DESC;


--4.직급이 사원인 사원들의 사원명, 직급명, 근속년수, 매니저명, 매니저 부서명를 조회하시오
--(매니저 없는 사원도 조회) (나이순으로 조회)
SELECT
    A.EMP_NAME 사원명,
    B.JOB_NAME 직급명,
    TRUNC((SYSDATE-A.HIRE_DATE)/365)||'년' 근속년수,
    C.EMP_ID 매니저명,
    C.DEPT_TITLE "매니저 부서명"
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
LEFT JOIN (SELECT * FROM EMPLOYEE E JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
     ) C ON A.MANAGER_ID = C.EMP_ID
WHERE B.JOB_NAME = '사원'
ORDER BY A.EMP_NO DESC;
--답--(사번??)
SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.JOB_NAME,
    TO_CHAR((SYSDATE - A.HIRE_DATE)/365, '99')||'년' 근속년수,
    C.EMP_NAME 매니저이름,
    D.DEPT_TITLE 매니저부서
FROM EMPLOYEE A 
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
LEFT JOIN EMPLOYEE C ON A.MANAGER_ID = C.EMP_ID
LEFT JOIN DEPARTMENT D ON C.DEPT_CODE = D.DEPT_ID
WHERE B.JOB_NAME LIKE '사원'
ORDER BY SUBSTR(A.EMP_NO, 1, 2) DESC;
--5.이름이 ‘이’로 시작하는 사원의 이름과 부서명을 조회하시오
--(부서명이 NULL인 것도 출력) (1. ANSI 조인, 2. ORACLE 조인)
--ANSI
SELECT
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE=B.DEPT_ID
WHERE EMP_NAME LIKE '이%';
--ORACLE
SELECT
    A.EMP_NAME 이름,
    B.DEPT_TITLE 부서명
FROM EMPLOYEE A, DEPARTMENT B
WHERE A.DEPT_CODE=B.DEPT_ID(+)
AND EMP_NAME LIKE '이%';
--답
--ANSI--
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON B.DEPT_ID = A.DEPT_CODE
WHERE EMP_NAME LIKE '이%';

--ORACLE--
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE A, DEPARTMENT B
WHERE B.DEPT_ID(+) = A.DEPT_CODE
AND EMP_NAME LIKE '이%';

--서브쿼리문제--

--1.직급별 평균 월급 이상의 월급을 받는 직원에게 'GD' / 이하의 월급을 받는 직원은 'NI'등급을 부여.
--직원의 사번, 이름, 직급명, 'GD' 등급 / 'NI' 등급을 사번 오름차순으로 조회하시오
--(단, 월급은 보너스를 포함하며 퇴사한 직원은 제외)
--(UNION or CASE 사용)
SELECT EMP_ID, EMP_NAME, SALARY*(NVL(BONUS,0)+1) FROM EMPLOYEE;

SELECT JOB_CODE, AVG(SALARY*(NVL(BONUS,0)+1)) FROM EMPLOYEE GROUP BY JOB_CODE; --직급별 평균 월급

SELECT
    A.EMP_NAME
FROM EMPLOYEE A 
WHERE A.SALARY*(NVL(A.BONUS,0)+1) >=
        (SELECT AVG(B.SALARY*(NVL(B.BONUS,0)+1))
        FROM EMPLOYEE B  
        WHERE A.JOB_CODE=B.JOB_CODE); --직급별 평균 월급 보다 많이 받는 직원
        
--UNION
SELECT A.EMP_ID 사번, A.EMP_NAME 이름, B.JOB_NAME 직급명, 'GD' 구분
FROM EMPLOYEE A
JOIN JOB B USING(JOB_CODE)
WHERE A.ENT_YN ='N'
AND EMP_NAME IN (
        SELECT
            A.EMP_NAME
        FROM EMPLOYEE A 
        WHERE A.SALARY*(NVL(A.BONUS,0)+1) >=
                (SELECT AVG(B.SALARY*(NVL(B.BONUS,0)+1))
                FROM EMPLOYEE B  
                WHERE A.JOB_CODE=B.JOB_CODE))--GD              
UNION
SELECT A.EMP_ID 사번, A.EMP_NAME 이름, B.JOB_NAME 직급명, 'NI' 구분
FROM EMPLOYEE A
JOIN JOB B USING(JOB_CODE)
WHERE A.ENT_YN ='N'
AND EMP_NAME NOT IN (
        SELECT
            A.EMP_NAME
        FROM EMPLOYEE A 
        WHERE A.SALARY*(NVL(A.BONUS,0)+1) >=
                (SELECT AVG(B.SALARY*(NVL(B.BONUS,0)+1))
                FROM EMPLOYEE B  
                WHERE A.JOB_CODE=B.JOB_CODE))
ORDER BY 1;

--CASE
SELECT
    A.EMP_ID 사번, A.EMP_NAME 이름, B.JOB_NAME 직급명,
    CASE WHEN A.EMP_NAME IN (
                SELECT A.EMP_NAME
                FROM EMPLOYEE A
                WHERE A.SALARY*(NVL(BONUS,0)+1) >=
                    (SELECT AVG(B.SALARY*(NVL(B.BONUS,0)+1))
                     FROM EMPLOYEE B
                     WHERE A.JOB_CODE=B.JOB_CODE)
                ) THEN 'GD'
    ELSE 'NI'
    END 등급
FROM EMPLOYEE A
JOIN JOB B USING(JOB_CODE)
WHERE A.ENT_YN ='N' GROUP BY A.EMP_ID, A.EMP_NAME, B.JOB_NAME
ORDER BY 1;
--
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_NAME 직급명,
CASE WHEN (SALARY + (SALARY * NVL(BONUS, 0))) >= (SELECT
                                                    AVG(SALARY + (SALARY * NVL(BONUS, 0)))
                                                    FROM EMPLOYEE) THEN 'GD'
        ELSE 'NI'
        END 등급
FROM EMPLOYEE
LEFT JOIN JOB USING(JOB_CODE)
WHERE ENT_YN = 'N'
ORDER BY EMP_ID;
--답
SELECT
    EMP_ID,
    EMP_NAME,
    JOB_NAME,
    CASE WHEN (SALARY + (SALARY * NVL(BONUS,0))) > (SELECT
                                                    AVG(SALARY)
                                                    FROM EMPLOYEE
                                                    ) THEN 'GD'
         ELSE 'NI'
		END 등급
FROM EMPLOYEE
LEFT JOIN JOB USING(JOB_CODE)
WHERE ENT_YN NOT IN 'Y'
ORDER BY 1;

--2.부서별 급여 평균이 3위인 부서들의 부서명과 부서별 급여 평균, 사원수를 조회하고 순위를 붙여조회하시오
--(순위를 오름차순으로 정렬) (부서별 급여 평군은 100000 단위로 표현)
SELECT
    ROWNUM, A.*
FROM
    (SELECT  
        B.DEPT_TITLE "부서명",
        TRUNC(AVG(A.SALARY),-5) "부서별 급여 평균",
        COUNT(*) "사원수"
    FROM EMPLOYEE A
    JOIN DEPARTMENT B ON A.DEPT_CODE=B.DEPT_ID
    GROUP BY B.DEPT_TITLE
    ORDER BY 2 DESC)A
WHERE ROWNUM <=3;
--답
SELECT  
    ROWNUM 순위,
    B.DEPT_TITLE,
    A.부서별급여평균,
    A.사원수
FROM (
         SELECT 
             DEPT_CODE,
             TRUNC(AVG(SALARY), -5) 부서별급여평균,
             COUNT(*) 사원수
         FROM EMPLOYEE
         GROUP BY DEPT_CODE
         ORDER BY AVG(SALARY) DESC
                    ) A
JOIN DEPARTMENT B ON DEPT_CODE = DEPT_ID
WHERE ROWNUM <= 3;

--3.EMPLOYEE 테이블에서 ROWNUM(테이블의 일련번호)이 20 이상인 사원이름을 조회하시오
SELECT
    A.*
FROM (SELECT
            ROWNUM 일련번호,
            EMP_NAME 사원이름
        FROM EMPLOYEE) A
WHERE  A.일련번호 >=20;
--답
SELECT EMP_NAME
FROM (SELECT ROWNUM NUM, EMP_NAME FROM EMPLOYEE)
WHERE NUM >= 20;
--4.아시아 지역에서 근무하는 사원들을 관리하는 관리자중 보너스를 받는 관리자의 부서별 평균 연봉을 구해 높은 연봉순으로 조회
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
WHERE C.LOCAL_NAME LIKE 'ASIA%'
AND MANAGER_ID IS NOT NULL;--아시아 지역에서 근무하는 사원의 관리자

SELECT A.DEPT_CODE, AVG((SALARY + SALARY * NVL(BONUS,0)) * 12) 연봉
FROM EMPLOYEE A
JOIN (
        SELECT DISTINCT MANAGER_ID
        FROM EMPLOYEE A
        JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
        JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
        WHERE C.LOCAL_NAME LIKE 'ASIA%'
        AND MANAGER_ID IS NOT NULL
        AND BONUS IS NOT NULL
)B ON A.EMP_ID = B.MANAGER_ID
GROUP BY DEPT_CODE;--중 보너스를 받는 관리자의 부서의 연봉

SELECT DEPT_CODE "부서",  AVG((SALARY + SALARY * NVL(BONUS,0)) * 12) "평균연봉"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE IN (
                SELECT A.DEPT_CODE
                FROM EMPLOYEE A
                JOIN (
                        SELECT DISTINCT MANAGER_ID
                        FROM EMPLOYEE A
                        JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
                        JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
                        WHERE C.LOCAL_NAME LIKE 'ASIA%'
                        AND MANAGER_ID IS NOT NULL
                        AND BONUS IS NOT NULL--아시아 지역에서 근무하는 사원의 관리자
                )B ON A.EMP_ID = B.MANAGER_ID--중 보너스를 받는 관리자의 부서
)
ORDER BY 2 DESC;--의 평균 연봉
--다른팀1--
SELECT
    DEPT_CODE,
    AVG((SALARY + SALARY * NVL(BONUS,0)) * 12) 연봉 --평균 연봉
FROM EMPLOYEE A
WHERE DEPT_CODE NOT IN ('D7','D8')--아시아 근무 부서
AND A.EMP_ID IN (SELECT B.MANAGER_ID
                 FROM EMPLOYEE B
                 WHERE EMP_ID = B.MANAGER_ID) --관리자
AND BONUS IS NOT NULL --보너스를 받는
GROUP BY DEPT_CODE --부서별
ORDER BY 2 DESC;


SELECT DEPT_CODE, AVG((SALARY + SALARY * NVL(BONUS,0)) * 12)
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY DEPT_CODE; HAVING DEPT_CODE IN('D1','D5','D9');

SELECT
    DEPT_CODE,
    AVG((SALARY + SALARY * NVL(BONUS,0)) * 12) 연봉
FROM EMPLOYEE A
LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
WHERE C.LOCAL_NAME LIKE 'ASIA%'
AND A.EMP_ID IN (SELECT B.MANAGER_ID
                 FROM EMPLOYEE B
                 WHERE A.EMP_ID = B.MANAGER_ID)
AND A.BONUS IS NOT NULL
GROUP BY DEPT_CODE
ORDER BY 연봉 DESC;
--다른팀2--
SELECT 
    A.DEPT_TITLE AS 부서,
    AVG(A.연봉) AS 부서별평균연봉
FROM (
    SELECT
        --A.EMP_NAME AS 사원, 
        --C.LOCAL_NAME AS 지역,
        --A.MANAGER_ID AS 관리자번호, 
        D.EMP_NAME AS 관리자명, 
        B.DEPT_TITLE, 
        (D.SALARY+D.SALARY*NVL(D.BONUS, 0))*12 AS 연봉
    FROM EMPLOYEE A, DEPARTMENT B, LOCATION C, EMPLOYEE D 
    WHERE A.DEPT_CODE = B.DEPT_ID(+)
    AND B.LOCATION_ID = C.LOCAL_CODE(+)
    AND A.MANAGER_ID = D.EMP_ID
    AND D.DEPT_CODE = B.DEPT_ID
    AND C.LOCAL_NAME LIKE 'ASIA%'
    AND D.BONUS IS NOT NULL) A
GROUP BY A.DEPT_TITLE;
--답
SELECT
    DEPT_CODE,
    AVG((SALARY + NVL(BONUS,0)*SALARY)*12) 연봉
FROM(
        SELECT
                A.EMP_NAME,
                A.DEPT_CODE,
                A.SALARY,
                A.BONUS
--                E.LOCAL_NAME
              FROM EMPLOYEE A
              JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
              JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
              JOIN EMPLOYEE D ON D.MANAGER_ID = A.EMP_ID
              JOIN LOCATION E ON B.LOCATION_ID = E.LOCAL_CODE
      ) A
WHERE LOCAL_NAME LIKE 'ASIA%'
AND BONUS IS NOT NULL              
GROUP BY DEPT_CODE
ORDER BY 연봉 DESC;
--아시아에서 근무하는 사원들중 관리자가 있고, 보너스를 받는 사원들의 부서별 평균 연봉

--5.D9번 부서의 최소급여를 받는 사원보다 많은 급여를 받는 사원의 사원번호, 이름, 입사일, 급여, 부서번호 조회 (단, D9번 부서는 제외)
SELECT MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE = 'D9'; --D9번 부서의 최소급여

SELECT
    EMP_ID 사원번호,
    EMP_NAME 이름,
    HIRE_DATE 입사일,
    SALARY 급여,
    DEPT_CODE 부서번호
FROM EMPLOYEE
WHERE SALARY > (SELECT MIN(SALARY)--를 받는 사원보다 많은 급여를 받는 사원
                FROM EMPLOYEE
                GROUP BY DEPT_CODE
                HAVING DEPT_CODE = 'D9')
AND DEPT_CODE <> 'D9';--단, D9번 부서는 제외

--------ANY--------
SELECT EMP_ID 사원번호, EMP_NAME 이름, HIRE_DATE 입사일, SALARY 급여, DEPT_CODE 부서번호
FROM EMPLOYEE
WHERE SALARY > ANY (SELECT SALARY
                FROM EMPLOYEE
                WHERE DEPT_CODE = 'D9')
AND DEPT_CODE NOT IN 'D9';

