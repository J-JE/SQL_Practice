-- 1. 사원번호, 직원명, 월급 조회
--    이름에 '동' 들어가는 사람 제외
--    사원번호 내림차순 정렬
SELECT
    EMP_ID,
    EMP_NAME,
    SALARY
FROM EMPLOYEE
WHERE EMP_NAME NOT LIKE '%동%'
ORDER BY EMP_ID DESC;


-- 2. 2010년 이후에 입사한 사원들 중 사수가 있는 사원의 
--    이름, 입사날짜, 원화로 표시 된 보너스 포함 연봉을 
--    연봉 오름차순으로 조회
SELECT
    EMP_NAME,
    HIRE_DATE,
    TO_CHAR((SALARY+(SALARY*NVL(BONUS,0)))*12,'L999,999,999') "보너스 포함 연봉"
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL
AND HIRE_DATE >= TO_DATE(2010,'RRRR');


-- 3. 직원명, 주민번호(뒷자리는 *표시, 오름차순으로 설정), 성별(남 / 여)을 조회
SELECT 
    EMP_NAME 직원명,
    REPLACE(EMP_NO,SUBSTR(EMP_NO,8,7),'*******') 주민번호,
    CASE WHEN SUBSTR(EMP_NO,8,1) = 1 THEN '남'
         ELSE '여' END 성별
FROM EMPLOYEE
ORDER BY 2;


-- 4. 사번, 직원 이름, 급여레벨, 월급여를 조회하고 월급여는 원으로 표시하고 내림차순하시오.
SELECT 
    EMP_ID,
    EMP_NAME,
    SAL_LEVEL,
    TO_CHAR(SALARY,'L999,999,999')
FROM EMPLOYEE
ORDER BY SALARY DESC;


-- 5. 나이가 30대인 사람들만 회원번호, 회원명, 주민번호, 나이, 생월, 생일 정보조회
--    단 일 수가 큰 순서대로 내림차순으로
--    그리고 이때도 사번이 200, 201, 214가 아닌 사원들에서..
SELECT *
FROM EMPLOYEE
WHERE (122-SUBSTR(EMP_NO,1,2)) BETWEEN 30 AND 39 --전부 2000년대 전에 태어났기 때문에 -122로 나이를 계산 할 수 있음
AND EMP_ID NOT IN ('200','201','214');


-- 6. 입사일이 2010년 부터 2017년 사이인 사원들 중에 보너스가 없는 사원들의 사원명, 부서코드, 보너스, 입사일 조회
SELECT 
    EMP_NAME,
    DEPT_CODE,
    BONUS,
    HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN TO_DATE(2010,'RRRR') AND TO_DATE(2017,'RRRR')
AND BONUS IS NULL;


-- 7. 2004년도 이후에 입사한 직원들중 부서코드가 D5 또는 D9이며 연봉은 4천만원 이상인 직원의
--    사번 사원명 부서코드, 입사일, 연봉(화폐단위로) 조회 
SELECT
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    HIRE_DATE,
    TO_CHAR((SALARY*(NVL(BONUS,0)+1))*12,'L999,999,999') 연봉
FROM EMPLOYEE
WHERE HIRE_DATE > TO_DATE(2004,'YYYY')
AND DEPT_CODE IN ('D5','D9')
AND (SALARY*(NVL(BONUS,0)+1))*12 >= 40000000;


-- 8. 핸드폰 번호에 6이 두번 이상 들어가고, 이메일 아이디 부분이 6글자 이상인 사람의 
--    이름, 이메일, 핸드폰번호, 보너스 포함 연봉(\99,999,999)로 표시
SELECT
    EMP_NAME,
    EMAIL,
    PHONE,
    TO_CHAR((SALARY*(NVL(BONUS,0)+1))*12,'L999,999,999') 연봉
FROM EMPLOYEE
WHERE PHONE LIKE '%6%6%'
AND EMAIL LIKE '______@%';


-- 9. 사원번호가 210 이상이면서 나이가 43세 이상인 사원들의 
--    사원명, 나이, 아이디, 부서이름을 조회하세요
--    아이디는 이메일의 @ 앞자리, 
--    D5 = 총무부, D1 = 기획부, D2 = 영업부, D8 = 인사부, NULL = 부서미정로 표현할 것 
SELECT 
    EMP_NAME,
    (122-SUBSTR(EMP_NO,1,2)) 나이,
    SUBSTR(EMAIL, 1,INSTR(EMAIL,'@')-1) 아이디,
    DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE TO_NUMBER(EMP_ID) >= 210
AND (122-SUBSTR(EMP_NO,1,2)) >= 43 ;


-- 10. 직원명, 부서코드, 생년월일 (단, 생년월일은 주민번호에서 추출, 00년 00월 00일로 출력),
--     입사일로부터 2017년06월06일까지의 근무일수 조회(단, 입사일도 근무일수 포함), 아이디 조회
SELECT 
    EMP_NAME,
    DEPT_CODE,
    TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD'),'YY"년 "MM"월 "DD"일"') 생년월일,
    CEIL(SYSDATE - HIRE_DATE) + 1 근무일수,
    SUBSTR(EMAIL, 1,INSTR(EMAIL,'@')-1) 아이디
FROM EMPLOYEE
WHERE EMP_ID NOT IN (200, 201, 214);


-- 11. 부서코드가 D6 또는 D8인 직원들 중 근무년수가 5년 이상인 사람들의 
--     직원명, 생년월일(0000년 00월 00일), 입사일(9월 입사자만), 연봉 조회(내림차순)
SELECT
    EMP_NAME,
    TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD'),'YYYY"년 "MM"월 "DD"일"') 생년월일,
    HIRE_DATE,
    (SALARY*(NVL(BONUS,0)+1))*12 연봉
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D6','D8')
AND EXTRACT(MONTH FROM HIRE_DATE) = EXTRACT(MONTH FROM TO_DATE(09,'MM'))
AND CEIL((MONTHS_BETWEEN(SYSDATE,HIRE_DATE))/12)>=5
ORDER BY 4 DESC;


-- 12. 이번에 3천만원짜리 자동차를 살 수 있는 기회가 생겼다. 
--     자신의 연봉선에 가능한 직원들을 이름, 연봉을 조회하시오
--     단, 월마다 집에다 50만원씩 줘야된다
SELECT 
    EMP_NAME,
    (SALARY*(NVL(BONUS,0)+1))*12 연봉
FROM EMPLOYEE;


-- 13. 2019년 기준 최저임금보다 못받는 불쌍한 직원의 사번, 직원명, 연봉(화폐단위)을 연봉 높은순으로 정렬하세요.
SELECT *
FROM EMPLOYEE;


-- 14. 모든 직원의 보너스포함 연봉을 20%씩 삭감하나, 생일의 날짜가 11일(오늘)인사람과, 하이유를 제외하여
--     직원이름,부서, 직원생일, 보너스포함 삭감전연봉, 보너스포함 삭감후 연봉을 조회하라
--     보너스 포함 후 삭감연봉은 1000원단위까지 절삭한다.
SELECT *
FROM EMPLOYEE;


-- 15. EMPLOYEE 테이블에서 62년생 중에 이메일주소를 네이버로 바꿔라
SELECT *
FROM EMPLOYEE;


-- 16. EMPLOYEE 테이블에서 DEPT_CODE가 D5이고 EMP_ID = 207인 하이유가 사수인 회원의
--     회원의 로그인 아이디(이메일에서 @kh.or.kr을 제외한), 휴대폰번호(010/017 등등 제외 , 오른쪽 정렬)
--     생년월일 (0000년 00월 00일) , 남/여, 연봉(보너스포함, 57,000,000 형식), 고용일  (0000년 00월 00일)
--     퇴사 안한 사람만 , 200,201,214 제외
SELECT *
FROM EMPLOYEE;


-- 17. 직원의 이름, 직급,월급(기존), 월급(상승된 월급), 연봉을 조회
--     단, 이름 중 '이' 또는 '연'이 들어가는 직원
--     조회된 직원중 직급이 J2인 사람의 월급은 50만원 올려줌 , J4인 직원은 100만원 , J5인 직원은 70만원 나머지 20만원 급여 상승
--     J2의 직급은 과장, J4의 직급은 대리 , J5의 직급은 주임으로 나머지 직급은 사원으로 처리한다.
SELECT *
FROM EMPLOYEE;



-- 18. 실적이 좋았던 총무부(부서코드 D5)에는 
--     보너스를 기존 보너스의 300%씩 인상시켜줌 (보너스가 없던 직원은 0.3으로 변경)
--    보너스가 없으면 0으로 출력
--    부서코드가 D5인 직원의 이름, 부서명, 변경 전 보너스, 변경 후 보너스, 인상 후 연봉, 인상금액 을 조회함
SELECT *
FROM EMPLOYEE;


-- 19. 연봉 1000만 단위로만 나오고(3천미만 인턴, 억이상 임원), 등급 나누고,  
--     연봉별 내림차순 하고 만약 급이 같으면 나이순으로 오름차순
SELECT *
FROM EMPLOYEE;


-- 20. (현재날짜)당월 생일자 조회
SELECT *
FROM EMPLOYEE;


-- 21. EMPLOYEE 테이블에서 입사년도가 2010년 이후인 사원의 이름, 성별, 입사일, 근무년수 조회
--     근무년수 내림차순 정렬
SELECT *
FROM EMPLOYEE;


-- 22. 송씨성을 가진 사원의 정보를 뽑는데, 사원명, 사원의 성별, 생년월일을 뽑아라
SELECT *
FROM EMPLOYEE;


-- 23. 부서별 평균연봉 순위 출력(정렬)
--     부서코드와 평균 연봉을 조회하는데 이때 부서코드가 없는 경우 '부서없음'으로 보여지게끔
SELECT *
FROM EMPLOYEE;


-- 24. 잡 코드가 J1 인 부서의 사람 중 사원번호, 이름, 월급을 출력
SELECT *
FROM EMPLOYEE;

-------------------------------------------------------------------------------
--세미 3팀
--1. 각 부서별로 나이가 가장 어린 사람의 사번, 사원명, 부서명, 직급명 조회
SELECT
    MAX(EMP_NO)
FROM EMPLOYEE
GROUP BY DEPT_CODE; --부서별 가장 어린 사람의 주민번호

SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.DEPT_TITLE,
    C.JOB_NAME,
    EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM (TO_DATE(SUBSTR(A.EMP_NO,1,2),'RR'))) 나이
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C USING(JOB_CODE)
JOIN (SELECT 
            MAX(EMP_NO) 주민번호
        FROM EMPLOYEE
        GROUP BY DEPT_CODE) D ON A.EMP_NO = D.주민번호
WHERE DEPT_CODE IS NOT NULL
ORDER BY DEPT_CODE;
---------------------------
SELECT
    DEPT_CODE,
    MIN(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM (TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))) 나이
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE IS NOT NULL;

SELECT
    A.EMP_ID,
    A.EMP_NAME,
    B.DEPT_TITLE,
    C.JOB_NAME,
    EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM (TO_DATE(SUBSTR(A.EMP_NO,1,2),'RR'))) 나이
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN JOB C USING(JOB_CODE)
WHERE (A.DEPT_CODE ,EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM (TO_DATE(SUBSTR(A.EMP_NO,1,2),'RR'))))
    IN(SELECT
            DEPT_CODE,
            MIN(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM (TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))) 나이
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        HAVING DEPT_CODE IS NOT NULL)
ORDER BY DEPT_CODE;
---백지우님 답 수정---
SELECT A.EMP_ID, A.EMP_NAME, A.DEPT_CODE, B.DEPT_TITLE, C.JOB_NAME,
    EXTRACT (YEAR FROM SYSDATE) - 
    EXTRACT (YEAR FROM TO_DATE(SUBSTR(A.EMP_NO, 1, 2), 'RRRR')) "나이"   
FROM EMPLOYEE A, DEPARTMENT B, JOB C 
WHERE A.DEPT_CODE = B.DEPT_ID 
AND A.JOB_CODE = C.JOB_CODE 
AND (A.DEPT_CODE,EXTRACT(YEAR FROM SYSDATE) - 
                EXTRACT (YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RRRR'))) IN
                (SELECT DEPT_CODE, MIN(EXTRACT (YEAR FROM SYSDATE) - 
                EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RRRR')))
                FROM EMPLOYEE
                GROUP BY DEPT_CODE);

--2. 본인의 급여등급 평균보다 급여를 15% 더 받는 직원의 이름, 급여등급, 급여 조회
SELECT
    SAL_LEVEL,
    AVG(SALARY)
FROM EMPLOYEE
GROUP BY SAL_LEVEL; --급여등급별 평균

SELECT
    A.EMP_NAME 이름,
    A.SAL_LEVEL 급여등급,
    A.SALARY 급여
FROM EMPLOYEE A
WHERE A.SALARY > (SELECT
                        AVG(B.SALARY)*1.15
                    FROM EMPLOYEE B
                    WHERE A.SAL_LEVEL=B.SAL_LEVEL);

--3. 직급이 대리이면서 하이유와 같은 관리자를 가진 사원의 이름,부서명,관리자 사번 조회
SELECT
    A.EMP_NAME, 
    B.DEPT_TITLE,
    A.MANAGER_ID
FROM EMPLOYEE A
JOIN DEPARTMENT B ON DEPT_CODE = DEPT_ID
JOIN JOB C USING(JOB_CODE)
WHERE C.JOB_NAME = '대리'
AND MANAGER_ID = (SELECT
                        MANAGER_ID
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하이유');
                    
SELECT
    A.EMP_NAME,
    B.DEPT_TITLE,
    A.MANAGER_ID
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
WHERE MANAGER_ID = (SELECT
                        MANAGER_ID
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '하이유')
                    AND A.JOB_CODE = 'J6';

--4. 직급이 과장 이상이면서 나이가 38세 이상인 사원의 사원명,부서코드,직급명, 나이를 조회
SELECT
    A.EMP_NAME,
    A.DEPT_CODE,
    B.JOB_NAME,
    EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM (TO_DATE(SUBSTR(A.EMP_NO,1,2),'RR'))) 나이
FROM EMPLOYEE A, JOB B
WHERE A.JOB_CODE = B.JOB_CODE
AND B.JOB_CODE <= 'J5'
AND EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM (TO_DATE(SUBSTR(A.EMP_NO,1,2),'RR'))) >= 38;


--5. 평균급여 이상을 받는 사원에 대해 직원명, 급여,부서명, 직급명과 급여가 많은 순서로 5위까지 추출
SELECT
    A.*
FROM(SELECT
        A.EMP_NAME,
        A.SALARY,
        B.DEPT_TITLE,
        C.JOB_NAME
    FROM EMPLOYEE A
    JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
    JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
    WHERE A.SALARY >= (SELECT AVG(SALARY) FROM EMPLOYEE)
    ORDER BY 2 DESC)A
WHERE ROWNUM <=5;

SELECT
    ROWNUM AS 순위,
    A.EMP_NAME AS 직원명,
    A.SALARY AS 급여,
    A.DEPT_TITLE AS 부서명,
    A.JOB_NAME AS 직급명
FROM (SELECT
            A.EMP_NAME,
            A.SALARY,
            B.DEPT_TITLE,
            C.JOB_NAME
        FROM EMPLOYEE A
        LEFT JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
        LEFT JOIN JOB C ON A.JOB_CODE = C.JOB_CODE
        WHERE A.SALARY > ( SELECT
        AVG(SALARY)
        FROM EMPLOYEE))A
WHERE ROWNUM <=5;
  
--6. EMAIL의 ‘_’ 앞이 3글자면서 여성인 사원을 조회하세요.
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '___/_%' ESCAPE '/'
AND SUBSTR(EMP_NO,8,1) ='2';


--7. 전화번호가 010으로 시작하는 사람들 중
--   전화번호의 4번째부터 7번째 까지의 숫자를 ‘*’로 출력하세요.
SELECT
    EMP_NAME,
    SUBSTR(PHONE,1,3)||'-****-'||SUBSTR(PHONE,8,4) 번호
FROM EMPLOYEE
WHERE PHONE LIKE '010%';


SELECT
EMP_NAME,
REPLACE(PHONE,SUBSTR(PHONE,4,4),'****')
FROM EMPLOYEE
WHERE SUBSTR(PHONE,1,3) = 010;

SELECT
    A.*
FROM (SELECT
        EMP_NAME,
        REPLACE(PHONE ,SUBSTR(PHONE,4,4),'****')
        FROM EMPLOYEE
        WHERE SUBSTR(PHONE,1,3)= '010')A;

--8. 전사원의 사원명, 부서명을 출력하세요. (부서값이 NULL인 사람은 부서명을 ‘미배정’으로 출력)
SELECT
    A.EMP_NAME,
    NVL(B.DEPT_TITLE,'미배정')
FROM EMPLOYEE A, DEPARTMENT B
WHERE A.DEPT_CODE = B.DEPT_ID(+);

SELECT
EMP_NAME,
NVL(DEPT_TITLE,'미배정')
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

--9. 가장 늦게 입사한 사원의 근무년수를 조회하세요.
SELECT
    EMP_NAME,
    DEPT_CODE,
    HIRE_DATE,
    EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM HIRE_DATE)+1||'년' 근무년수
FROM EMPLOYEE
WHERE HIRE_DATE = (SELECT MAX(HIRE_DATE) FROM EMPLOYEE);

SELECT
    ROWNUM ,
    A.EMP_NAME AS "가장 늦게 입사한 사람",
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)+1 근무년수
FROM (SELECT
            EMP_NAME,
            HIRE_DATE,
            MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE))
        FROM EMPLOYEE
        GROUP BY EMP_NAME, HIRE_DATE
        ORDER BY 3)A
WHERE ROWNUM = 1;

--10. 해외에 근무하는 직원들의 사원명, 부서명, 국가명을 조회하세요.
SELECT
    A.EMP_NAME,
    B.DEPT_TITLE,
    D.NATIONAL_NAME
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
JOIN NATIONAL D ON C.NATIONAL_CODE = D.NATIONAL_CODE
WHERE D.NATIONAL_NAME <> '한국';


