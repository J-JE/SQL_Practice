/*ORDER BY  절: SELECT 한 컬럼을 가지고 정렬을 할때 사용함
ORDER BY 컬럼명| 컬럼별칭 | 컬럼나열 순번 [ASC] | DESC 
ORDER BY 컬럼명 정렬방식, 컬럼명 정렬방식, 컬럼명 정렬방식.....
첫번째 기준으로 하는 컬럼에 대해서 정렬하고, 같은 값들에대해 두번째 기준으로 하는 컬럼에 대해 다시 정렬, 
SELECT 구문 맨마지막에 위치하고, 실행순서도 맨 마지막에 실행됨.*/

/*
 5 : SELECT 컬럼명 AS 별칭, 계산식, 함수식..
 1 : FROM 참조할 테이블
 2 : WHERE 컬럼명 | 함수식 비교연산자 비교값 (조건)
 3 : GROUP BY 그룹으로 묶을 컬럼명
 4 : HAVING 그룹함수식 비교연산자 비교값 ( 그룹핑된 대상에 대한 조건 )
 6 : ORDER BY 컬럼명| 컬럼별칭 | 컬럼나열 순번 [ASC] | DESC  |[NULLS FIRST | LAST]
 */

SELECT
    COUNT(*) 사원수,
    count(DEPT_CODE),
    DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT
    DEPT_CODE,
    JOB_CODE,
    SUM(SALARY) SAL,
    COUNT(*) CNT
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY 1, 2 DESC;


--직원테이블에서 부서코드별 그룹을 지정하여 
--부서코드, 그룹별 급여의 합계,
--그룹별 급여의 평균(정수처리-FLOOR) , 인원수를 조회하고 
--부서코드순으로 정렬하세요

SELECT
    DEPT_CODE,
    SUM(SALARY) 합계,
    FLOOR(AVG(SALARY)) 평균,
    COUNT(*) 인원수
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

--직원 테이블에서 직급 코드별 보너스를 받는 사원수를 조회하여
--직급코드 순으로 오름차순 정렬하세요
SELECT
    JOB_CODE 직급코드,
    COUNT(*) 사원수
FROM EMPLOYEE
WHERE BONUS IS NOT NULL
GROUP BY JOB_CODE
ORDER BY 1;

--GROUP BY 절 : 같은 값들이 여러개 기록된 컬럼을 가지고 하나의 그룹으로 묶음 
--GROUP BY 컬럼명 | 함수식 ....
--GROUP BY 에 명시된 값 이 SELECT 절에 명시되어있어야한다. 


--HAVING 절 : 그룹 함수로 구해올 그룹에 대해 조건을 설정할때 사용
--HAVING 컬럼명 | 함수식 | 비교연산자 |비교값

SELECT
    DEPT_CODE
    ,FLOOR(AVG(SALARY)) 평균
FROM EMPLOYEE
WHERE SALARY >3000000 --300만 이상의 급여를 가진 사람들만 묶어서 평균
GROUP BY DEPT_CODE
ORDER BY 1;


SELECT
    DEPT_CODE
    , FLOOR(AVG(SALARY)) 평균
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >3000000 --평균을 구한 그룹이 300만이 넘는 경우
ORDER BY 1;

-- EMPLOYEE테이블에서  부서별 그룹의 급여 합계중 9백만원을 초과하는 부서코드와 급여합계를 조회
SELECT
    DEPT_CODE
    ,SUM(SALARY) 합계
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) >9000000
ORDER BY 1;

--급여합계가 가장 많은 부서
SELECT
    DEPT_CODE
    MAX(SUM(SALARY)) 합계
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT
    DEPT_CODE
    ,SUM(SALARY) TOT
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY)=(SELECT
                        MAX(SUM(SALARY))
                    FROM EMPLOYEE
                    GROUP BY DEPT_CODE);
                    
--집계함수 

--ROLLUP 함수 : 그룹별로 중간 집계 처리를 하는 함수 
--GROUP BY 절에서만 사용 
-- 그룹별로 묶여진 값에 중간집계와 총집계를 구할때 사용
-- 그룹별로 계산된 값에대한 총집계가 자동으로 추가된다. 
-- 인자로 전달한 그룹중에서 가장 먼저 지정한 그룹(컬럼)별 합계와 총합계

SELECT
    JOB_CODE
    ,SUM(SALARY) SAL
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 1;

--SELECT
--    DEPT_CODE
--    ,JOB_CODE
--    ,SUM(SALARY) SAL
--FROM EMPLOYEE
--GROUP BY ROLLUP(DEPT_CODE,JOB_CODE,SAL_LEVEL)
--ORDER BY 1;

--CUBE 함수 : 그룹별 산출한 결과를 집계하는 함수이다.
-- 모든 그룹에대한 집계와 총합계
SELECT
    JOB_CODE
    ,SUM(SALARY) SAL
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1;

SELECT
    DEPT_CODE
    ,JOB_CODE
    ,SUM(SALARY) SAL
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE,JOB_CODE);
--ORDER BY 1;

SELECT
    DEPT_CODE
    ,JOB_CODE
    ,SUM(SALARY) SAL
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE,JOB_CODE);
--ORDER BY 1;

--GROUPING  함수 : ROLLUP이나 CUBE 에 의한 산출물이 
-- 인자로 전달받은 컬럼집합의 산출물이면 0
-- 아니면 1을 반환하는 함수
SELECT
    DEPT_CODE
    ,JOB_CODE
    ,SUM(SALARY) SAL
    ,GROUPING (DEPT_CODE) 부서별_그룹핑상태
    ,GROUPING (JOB_CODE) 직급별_그룹핑상태
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE,JOB_CODE)
--GROUP BY ROLLUP(DEPT_CODE,JOB_CODE)
ORDER BY 1;

SELECT
    DEPT_CODE
    ,JOB_CODE
    ,SUM(SALARY)
    ,CASE
        WHEN GROUPING(DEPT_CODE)=0 AND GROUPING(JOB_CODE) =1 THEN '부서별합계'
        WHEN GROUPING(DEPT_CODE)=1 AND GROUPING(JOB_CODE) =0 THEN '직급별합계'
        WHEN GROUPING(DEPT_CODE)=0 AND GROUPING(JOB_CODE) =0 THEN '그룹별합계'
        ELSE '총합계'
    END 구분
FROM EMPLOYEE  
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;


--@SET SPERATION(집합연산)
-- 두개이상의 테이블에서 조인을 사용하지않고 연관된 데이터를 조회하는 방법
-- 여러개의 질의 결과를 연결하여 하나로 결합하는 방식 
-- 각테이블의 조회결과를 하나의 테이블에 합쳐서 반환함 

-- 조건 : SELECT 절의 "컬럼수가 동일"해야함
--       SELECT 절의 동일 위채에 존재하는 "컬럼의 데이터 타입이 상호호환"가능해야함.

-- UNION, UNION ALL, INTERSECT, MINUS

-- UNION : 여러개의 쿼리결과를 하나로 합치는 연산자이다. 
--         중복된 영역을 한번만 반영
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5'
UNION
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE SALARY >3000000;

-- UNION ALL : 여러개의 쿼리결과를 하나로 합치는 연산자
            -- UNION 과의 차이점은 중복영역을 모두 포함시킨다.
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5'
UNION ALL
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE SALARY >3000000;


--INTERSECT : 여러개의 SELECT 한 결과에서 공통된 부분만 결과로 추출
-- 수학에서 교집합과 비슷
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5'
INTERSECT
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE SALARY >3000000;

SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5' AND SALARY >3000000;

--MINUS : 선행 SELECT 결과에서 다음 SELECT 결과와 겹치는 부분을 제외한 나머지 부분만추출
-- 수학에서 차집합과 비슷 하다
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D5'
MINUS
SELECT
    EMP_ID
    ,EMP_NAME
    ,DEPT_CODE
    ,SALARY
FROM EMPLOYEE
WHERE SALARY >3000000; --심봉선, 대북혼을 뺀 4명


--GROUPING SETS : 그룹별로 처리된 여러개의 SELECT 문을 하나로 합칠때 사용한다.
--SET OPERATION(집합연산)-UNION ALL 과 동일

SELECT
    DEPT_CODE
    ,JOB_CODE
    ,MANAGER_ID
    ,FLOOR(AVG(SALARY)) ASAL
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE, MANAGER_ID--19행
UNION ALL
SELECT
    DEPT_CODE
    ,'' JOB_CODE --문자열 타입이기 때문에 ''으로 비워둔다. 커럼의 개수와 순서를 맞춰야해서 뺄 수 없기 때문
    ,MANAGER_ID
    ,FLOOR(AVG(SALARY)) ASAL
FROM EMPLOYEE
GROUP BY DEPT_CODE, MANAGER_ID--15행
UNION ALL
SELECT
    '' DEPT_CODE,
    JOB_CODE,
    MANAGER_ID,
    FLOOR(AVG(SALARY)) ASAL
FROM EMPLOYEE
GROUP BY JOB_CODE, MANAGER_ID --19행
ORDER BY 1;--ORDER BY는 집합연산 마지막줄에 걸어야한다.
--총 53행

SELECT
    DEPT_CODE,
    JOB_CODE,
    MANAGER_ID,
    FLOOR(AVG(SALARY)) ASAL
FROM EMPLOYEE
GROUP BY GROUPING SETS( (DEPT_CODE, JOB_CODE, MANAGER_ID),
                        (DEPT_CODE, MANAGER_ID),
                        (JOB_CODE, MANAGER_ID) );
--ORDER BY 3;