/*@ DQL(Data Query Language)
데이터를 검색 추출하기 위해 사용하는 언어 
DQL은 DML에 속한언어이기도 하다. 
데이터조회한 결과를 Result set(행들의 집합)이라고 한다.
->0개이상의 행이 포함될수 있고 , 특정기준에 의해 정렬될수 있다. 
*/
/*
@SELECT 기본 작성법
1. SELECT 컬럼명 FROM 테이블명;
2. SELECT 컬럼명 FROM 테이블명 WHERE 조건;

SELECT : 조회하고자하는 컬럼명을 기술, 여러개로 기술하고하하면, (쉼표)로 구분, 
        모든컬럼조회시 * 를 사용
FROM : 조회 대상 컬럼이 포함된 테이블 명을 기술 
WHERE: 행을 선택하는 조건을 기술 
       여러개의 제한조건을 포함할수있고 각 제한조건은 논리연산자로 연결, 제한조건에 만족하는 행들만 
       RESULT SET 에 포함됨
*/  


-- SELECT 기본문법연산자
-- EMPLOYEE 테이블에서 모든행 모든 컬럼 조회
select*
from employee;

-- 원하는 컬럼 조회
--EMPLOYEE 테이블에서 사번, 이름을 조회
select
    emp_ID,
    EMP_NAME
FROM EMPLOYEE;

--원하는 행조회
--EMPLOYEE 테이블에서 부서코드가 'D9'인 사원조회
SELECT
    * FROM EMPLOYEE
    WHERE DEPT_CODE ='D9';
--EMPLOYEE 테입즐에서 직급코드가 'J1'인 사원 조회
SELECT
    *FROM EMPLOYEE
    WHERE JOB_CODE = 'J1';
    
--원하는 행과 컬럼조회
--EMPLOYEE 테이블에서 급여가 300만원이상인 사원의 사번, 이름, 부서코드, 급여를 조회하시오
SELECT
    EMP_ID
    , EMP_NAME
    , DEPT_CODE
    , SALARY
FROM EMPLOYEE
WHERE SALARY >=3000000;

--컬럼에 별칭 짓기
--AS + 별칭 기술
SELECT
    EMP_NAME AS ENAME,
    SALARY *12 "1년급여(원)",
    NVL(BONUS,0),
    BONUS,
    SALARY*BONUS,
    (SALARY + (SALARY * NVL(BONUS,0)))*12 AS "총소득(원)"
FROM EMPLOYEE;    

-- 리터럴 : 임의로 지정한 문자열을 SELECT 절에 사용하면 존재하는 데이터처럼 사용할수있다.
-- 모든행에 반복 표시된다.

SELECT
    EMP_ID, EMP_NAME, SALARY, '원' 단위
FROM EMPLOYEE;

--DISTINCT 키워드는 중볻괸 컬럼값을 제거하여 조회한다.

SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

--DISTINCT 키워드는 SELECT 절에서 딱 한 번 만 쓸 수 있다.
SELECT DISTINCT JOB_CODE, DEPT_CODE
FROM EMPLOYEE;

--WHERE절
-- 테이블에서 조건을 만족하는 값을 가진행을 조회한다. 
-- 여러개의 조건을 만족하는 행을 조회할때는 AND 또는 OR 를 사용할수있다. 

-- 부서코드가 D6이고 급여를 200 만원보다 더많이 받는 직원의 
-- 이름, 부서코드, 급여 조회


SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE ='D6' AND SALARY>2000000;

-- 연결연산자(||)를 사용해서 여러컬럼을 하나의 컬럼인것 처럼 연결 할수 있다
SELECT 
    VAL
FROM (        
    SELECT
        EMP_ID||EMP_NAME||SALARY VAL, --컬럼과 컬럼의 연결
        EMP_NAME||'의 월급은'||SALARY||'원 입니다.' VAL2 --컬럼과 리터럴의 연결이다.
    FROM EMPLOYEE
);  

/*@ 비교 연산자
-> 표현식 사이의 관계를 비교하기 위해 사용하고, 비교 결과는 논리 결과중에 하나
(TRUE/FALSE/NULL)가 됨
-> 단, 비교하는 두 컬럼 값/표현식은 서로 동일한 데이터 타입이어야 함

	연산자			설명
	=			같다
	>,<			크다/작다
	>=,=<			크거나 같다/작거나 같다
	<>,!=,^=		같지 않다
	BETWEEN AND		특정 범위에 포함되는지 비교
	LIKE / NOT LIKE		문자 패턴 비교
	IS NULL / IS NOT NULL	NULL 여부 비교
	IN / NOT IN		비교 값 목록에 포함/미포함 되는지 여부 비교
	
	* <> 작거나 크다 즉, 같지 않다!*/
    
SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE
FROM EMPLOYEE
--WHERE DEPT_CODE <> 'D9';
--WHERE DEPT_CODE != 'D9';
WHERE DEPT_CODE ^= 'D9';

--EMPLOYEE 테이블에서 퇴사여부가 N인 직원을 조회하고 
--근무여부를 재직중으로 표시하여
--사번,이름 ,입사일, 근무여부를 조회하시오

SELECT EMP_ID, EMP_NAME, HIRE_DATE, '재직중' "근무여부"
FROM EMPLOYEE
WHERE ENT_YN = 'N';

-- EMPLOYEE  테이블에서 급여를 350만원 이상 550만원 이하를 받는 
-- 직원의 사번, 이름 ,급여, 부서코드, 직급코드 를 조회하시오

SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE SALARY >=3500000 AND SALARY<=5500000;

-- BETWEEN AND사용
-- 컬럼명 BETWEEN 하한값 AND 상한값  
-- 하한값 이상 상한값 이하의 값
-- 비교하려는 값이 지정한 범위 (상한값 하한값 의 경계를 포함)
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 5500000 ;

--350 만원 미만 또는 550 만원을 초과하는 
--직원의 사번, 이름, 급여, 부서코드, 직급코드를 조회하시오
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
--WHERE NOT SALARY BETWEEN 3500000 AND 5500000;
--WHERE SALARY NOT BETWEEN 3500000 AND 5500000;
WHERE SALARY < 3500000 OR SALARY > 5500000;


--LIKE 연산자: 문자 패턴이 일치하는 값을 조회 할때 사용 
--컬럼명 LIKE '문자패턴'
--문자패턴  : '글자%'(글자로 시작하는 값)
--           '%글자%'(글자가 포함된 값)
--           '%글자'(글자로 끝나는 값)

/*'%' 와 '_' 와일드 카드 로 사용할수있다 
와일드 카드 : 아무거나 대체해서 사용할수 있는 것 
_: 한문자
%:모든것
*/

-- EMPLOYEE 테이블에서 성이 김씨인 직원의 사번, 이름 , 입사일을 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE'김%';

-- EMPLOYEE 테이블에서 성이 김씨가아닌 직원의 사번, 이름 , 입사일을 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE NOT EMP_NAME LIKE'김%';

-- EMPLOYEE 테이블에서 '하' 가 이름에 포함된 직원의 이름 , 주민번호, 부서코드 조회
SELECT EMP_ID, EMP_NO, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME LIKE'%하%';

--EMPLOYEE 테이블에서 전화번호 ex(010X)  X->9 로 시작하는 
--직원의 사번, 이름, 전화번호를 조회하시오
-- 와일드카드 사용 : _(글자 한자리), %(0개 이상의 글자)
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE LIKE '___9%';

--EMPLOYEE 테이블에서 _앞글자가 3자리인 이메일 주소를 가진 사원의 사번, 이름, 이메일 주소를 조회 
--ESCAPE 
--LIKE '%[문자][실제문자로인식시킬문자]%' ESCAPE '[문자]
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___^_%' ESCAPE'^';

-NULL값 조회
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;

--IN연산자 : 비교하려는 값목록에 일치하는 값을 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN('D6','D9','D1');
--WHERE DEPT_CODE ='D6' 
--OR DEPT_CODE ='D9' 
--OR DEPT_CODE='D1';


-- 연산자 우선순위 
--1. 산술연산자
--2. 연결연산자
--3. 비교연산자
--4. IS NULL / IS NOT NULL / LIKE / NOT LIKE / IN / NOT IN
--5. BETWEEN AND / NOT BETWEEN AND
--6. NOT(논리연자)
--7. AND
--8. OR

--J2직급의 급여 200만원 이상받는 직원이거나 J7 직급의 직원의 
--이름, 급여, 직급 코드 조회
SELECT EMP_NAME, SALARY, JOB_CODE
FROM EMPLOYEE
WHERE 1=1
AND JOB_CODE ='J7' 
OR JOB_CODE='J2' AND SALARY >=2000000;--AND의 우선순위가 높아서 괄호 안쳐도 ㄱㅊ

-- J7 직급 이거나 J2 직급인 직원들 중에서 급여가 200만원 이상인 직원의
-- 이름, 급여, 직급 코드를 조회
SELECT EMP_NAME, SALARY, JOB_CODE
FROM EMPLOYEE
WHERE 1=1
--AND (JOB_CODE ='J7' OR JOB_CODE ='J2')
--AND SALARY >=2000000;
AND JOB_CODE IN('J7','J2')
AND SALARY >=2000000;


--2. DEPARTMENT테이블의 내용 전체를 출력하는 SELECT문을 작성하시오
SELECT *
FROM DEPARTMENT;

--3. EMPLOYEE 테이블에서 이름(EMP_NAME),이메일(EMAIL),전화번호(PHONE),고용일(HIRE_DATE)
--		만 출력하시오
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE
FROM EMPLOYEE;

--4. EMPLOYEE 테이블에서 고용일(HIRE_DATE) 이름(EMP_NAME),월급(SALARY)를 출력하시오
SELECT HIRE_DATE, EMP_NAME, SALARY
FROM EMPLOYEE;

--5. EMPLOYEE 테이블에서 월급(SALARY)이 2,500,000원이상인 사람의
-- 	EMP_NAME 과 SAL_LEVEL을 출력하시오 (힌트 : >(크다) , <(작다) 를 이용)
SELECT EMP_NAME, SAL_LEVEL
FROM EMPLOYEE
WHERE SALARY >= 2500000;

--6. EMPLOYEE 테이블에서 월급(SALARY)이 350만원 이상이면서 
-- 	JOB_CODE가 'J3' 인 사람의 이름(EMP_NAME)과 전화번호(PHONE)를 출력하시오
--	(힌트 : AND(그리고) , OR (또는))  
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE SALARY >=3500000
AND JOB_CODE ='J3';

--7. EMPLOYEE 테이블에서 이름,연봉, 총수령액(보너스포함), 실수령액(총 수령액-(월급*세금 3%))
--가 출력되도록 하시오
SELECT EMP_NAME 이름,
    SALARY*12 연봉,
    (SALARY+(SALARY*NVL(BONUS,0)))*12 총수령액,
    (SALARY+(SALARY*NVL(BONUS,0)))*12 -(SALARY*0.3) 실수령액
FROM EMPLOYEE;

--8. EMPLOYEE 테이블에서 이름, 근무 일수(반올림-ROUND)를 출력해보시오 (SYSDATE를 사용하면 현재 시간 출력)
SELECT EMP_NAME 이름,
    ROUND (SYSDATE - HIRE_DATE) "근무 일수"
FROM EMPLOYEE;

--9. EMPLOYEE 테이블에서 20년 이상 근속자의 이름,월급,보너스를 출력하시오
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE ROUND (SYSDATE - HIRE_DATE)>=(20*365);

--10.EMPLOYEE 테이블에서 고용일이 90/01/01 ~ 01/01/01 인 사원의
--전체 내용을 출력하시오
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

--11. EMPLOYEE 테이블에서 이름 끝이 연으로 끝나는 사원의 이름을 출력하시오
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

--12. EMPLOYEE 테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 출력하시오
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE NOT PHONE LIKE '010%';

--13. EMPLOYEE 테이블에서 메일주소 '_'의 앞이 4자이면서, DEPT_CODE가 D9 또는 D6이고
--고용일이 90/01/01 ~ 00/12/01이면서, 월급이 270만원 이상인 사원의 전체 정보를 출력하시오
SELECT *
FROM EMPLOYEE
WHERE EMAIL LIKE '____^_%' ESCAPE'^'
AND DEPT_CODE IN('D9','D6')
AND HIRE_DATE BETWEEN '90/01/01' AND '00/12/01'
AND SALARY >=2700000;

--7.이름(EMP_NAME), 급여(SALARY), 보너스(BONUS) 연봉(급여+(급여-보너스)*12를 조회하는 SELECT구문을 작성하시오(12점)

SELECT
    EMP_NAME,
    SALARY,
    NVL(BONUS,0),
    (SALARY + (SALARY* NVL(BONUS,0))) * 12
FROM EMPLOYEE;
--8.	EMP테이블에서 20년이상 근속자의
--이름(EMP_NAME), 월급(SALARY), 보너스(BONUS), 고용일(HIRE_DATE)를 조회하는
--SELECT문을 별칭을 부여하여 작성하시오.(20점)
SELECT
    EMP_NAME 이름,
    SALARY 월급,
    NVL(BONUS,0) 보너스,
    HIRE_DATE 고용일
FROM EMPLOYEE
WHERE MONTHS_BETWEEN(SYSDATE,HIRE_DATE)>=20*12;
--실습문제 
--1. JOB테이블에서 JOB_NAME의 정보만 출력되도록 하시오
SELECT JOB_NAME
FROM JOB;

-------------------------------------------------------------

--DEPT_CODE가 D9이거나 D6이고 SALARY이 300만원 이상이고 BONUS가 있고
--남자이고 이메일주소가 _ 앞에 3글자 있는
--사원의 EMP_NAME, EMP_NO, DEPT_CODE, SALARY를 조회
SELECT EMP_NAME, EMP_NO, DEPT_CODE, SALARY, EMAIL, BONUS
FROM EMPLOYEE
WHERE DEPT_CODE='D9' OR DEPT_CODE='D6'
AND SALARY > 3000000
AND EMAIL LIKE '____%'
AND BONUS IS NULL;

SELECT EMP_NAME, EMP_NO, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN('D9','D6') --AND 연산자가 OR 연산자보다 우선순위가 높기 때문에
--AND DEPT_CODE='D9' OR DEPT_CODE='D6'
AND SALARY >= 3000000 --이상인데 >비교 연산자를 잘못 씀
AND EMAIL LIKE '___^_%' ESCAPE '^' --와일드 카드 문자와 패턴의 특수문자가 동일한 경우
--와일드 카드 문자 패턴 기호 앞에 임의의 특수문자를 사용하고 ESCAPE OPTION으로 등록해야한다.
AND BONUS IS NOT NULL --IS NULL은 NULL값인 데이터를 찾는다.
AND SUBSTR(EMP_NO,8,1)=1; --남자인 경우를 뺐음

--1. SELECT의 오타
--2. NULL 여부를 비교하기 위해선 IS NULL 또는 IS NOT NULL 연산자를 사용해야하는데
--잘못된 연산자를 사용했다.
SELECT
    * 
FROM EMPLOYEE
WHERE BONUS IS NULL
AND MANAGER_ID IS NOT NULL;
