--1. EMPLOYEE와 레코드가 모두 같은 EMPLOYEE_COPY3테이블을 만들고
--이 테이블에서 아시아 이외의 지역에서 근무하는 직원들의 BONUS를 10% 인상하여라
--(EX  BONUS 0.2 - 0.3, 만약 이 직원들의 보너스가 없다면 10%로 설정하기)
CREATE TABLE EMPLOYEE_COPY3
AS SELECT * FROM EMPLOYEE;

UPDATE EMPLOYEE_COPY3
SET BONUS = NVL(BONUS,0)+0.1
WHERE EMP_ID IN (
    SELECT A.EMP_ID
    FROM EMPLOYEE A
    JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
    JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
    WHERE C.LOCAL_NAME NOT LIKE 'ASIA%');


--2. EMPLOYEE_COPY3테이블에서 부서가 없는 직원들의 부서를 기술지원부로 지정하고 급여를 10% 인상하여라.
UPDATE EMPLOYEE_COPY3
SET DEPT_CODE = (SELECT DEPT_ID FROM DEPARTMENT WHERE DEPT_TITLE='기술지원부'),
    SALARY = SALARY*1.1
WHERE DEPT_CODE IS NULL;


--3. EMPLOYEE 테이블에서 77년생 중에 이메일주소를 hanmail로 바꾸고
--인사관리부를 제외한 직원의 이름, 사번 , 근무지역, 연봉, 이메일을 출력하세요
SELECT
    A.EMP_NAME 이름,
    A.EMP_ID 사번,
    C.LOCAL_NAME 근무지역,
    (A.SALARY*(NVL(BONUS,0)+1))*12 연봉,
    DECODE(SUBSTR(A.EMP_NO,1,2),'77', SUBSTR(A.EMAIL,1,INSTR(A.EMAIL,'@'))||'hanmail.net',SUBSTR(A.EMAIL,1,LENGTH(A.EMAIL))) 이메일
FROM EMPLOYEE A
JOIN DEPARTMENT B ON A.DEPT_CODE = B.DEPT_ID
JOIN LOCATION C ON B.LOCATION_ID = C.LOCAL_CODE
WHERE B.DEPT_ID <> 'D1';


--4. EMPLOYEE테이블에서 사번, 직원명과, 직급명을 출력 단 근무지가 일본인 사람만 
--사번 내림차순으로 출력
SELECT A.EMP_ID, A.EMP_NAME, B.JOB_NAME
FROM EMPLOYEE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
JOIN DEPARTMENT C ON A.DEPT_CODE = C.DEPT_ID
JOIN LOCATION D ON C.LOCATION_ID = D.LOCAL_CODE
JOIN NATIONAL E ON D.NATIONAL_CODE = E.NATIONAL_CODE
WHERE E.NATIONAL_NAME ='일본'
ORDER BY A.EMP_ID DESC;

--5. (EMPLOYEE 테이블을 똑같이 복제하여 EMPOYEE_UPDATE 테이블을 생성하세요)
--전형돈이 새해를 맞이하여 과장으로 직급이 오르면서 급여도 김해술과 같은 급여로 올랐다!
--EMPOYEE_UPDATE 테이블의 컬럼명들을 각각 사번, 이름, 주민번호, 이메일, 전화번호, 부서코드,
--직급코드, 급여, 보너스율, 관리자사번, 입사일, 퇴사일, 퇴사여부로 주석구문을 작성해주고
--EMPOYEE_UPDATE 테이블을 이용하여 김해술과 전형돈의 사번,이름,직급코드,연봉을 조회하세요.
CREATE TABLE EMPOYEE_UPDATE AS
SELECT * FROM EMPLOYEE;

COMMENT ON COLUMN EMPOYEE_UPDATE.EMP_ID IS '사번';
COMMENT ON COLUMN EMPOYEE_UPDATE.EMP_NAME IS '이름';
COMMENT ON COLUMN EMPOYEE_UPDATE.EMP_NO IS '주민번호';
COMMENT ON COLUMN EMPOYEE_UPDATE.EMAIL IS '이메일';
COMMENT ON COLUMN EMPOYEE_UPDATE.PHONE IS '전화번호';
COMMENT ON COLUMN EMPOYEE_UPDATE.DEPT_CODE IS '부서코드';
COMMENT ON COLUMN EMPOYEE_UPDATE.JOB_CODE IS '직급코드';
COMMENT ON COLUMN EMPOYEE_UPDATE.SALARY IS '급여';
COMMENT ON COLUMN EMPOYEE_UPDATE.BONUS IS '보너스율';
COMMENT ON COLUMN EMPOYEE_UPDATE.MANAGER_ID IS '관리자사번';
COMMENT ON COLUMN EMPOYEE_UPDATE.HIRE_DATE IS '입사일';
COMMENT ON COLUMN EMPOYEE_UPDATE.ENT_DATE IS '퇴사일';
COMMENT ON COLUMN EMPOYEE_UPDATE.ENT_YN IS '퇴직여부';

UPDATE EMPOYEE_UPDATE
SET (JOB_CODE,SALARY) = (SELECT JOB_CODE, SALARY FROM EMPOYEE_UPDATE WHERE EMP_NAME = '김해술')
WHERE EMP_NAME ='전형돈';

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPOYEE_UPDATE 
WHERE EMP_NAME IN('전형돈','김해술'); 

--6. 정형돈의 직급이 오른게 부러운 하동운이 선동일과 얘기를 하였지만 직급은 오르지 못했다.
--다만, 급여협상은 성공하여 장쯔위와 같은 급여를 받게 되었다.
--장쯔위와 하동운의 사번, 이름, 보너스를 포함한 연봉을 조회하세요
UPDATE EMPOYEE_UPDATE
SET SALARY = (SELECT SALARY FROM EMPOYEE_UPDATE WHERE EMP_NAME = '장쯔위')
WHERE EMP_NAME ='하동운';

SELECT A.EMP_ID, A.EMP_NAME, B.JOB_NAME, ((A.SALARY+(A.SALARY*A.BONUS)))*12 연봉
FROM EMPOYEE_UPDATE A
JOIN JOB B ON A.JOB_CODE = B.JOB_CODE
WHERE EMP_NAME IN('장쯔위','하동운');

-- 7. EMP_EX1 테이블에 EMPLOYEE의 사번, 이름, 이메일, 부서코드, 입사일, 보너스의 틀(껍데기)을 가져오시오
-- EMP_EX1 테이블에 EMPLOYEE테이블에서 이메일 앞부분이 3자리이면서 급여가 3500000이하인
-- 직원을 조회해서 사번, 이름, 이메일, 부서코드, 입사일, 보너스을 삽입하고,
-- EMP_EX1 테이블에서 부서명이 '해외영업'인 직원의 보너스를 0.45로 변경하시오


--8.
--1) EMP_EX2의 테이블에는 EMPLOYEE의 사번 , 이름, 부서코드, 직급코드,퇴직 여부의 틀(껍데기)를 가져오시오
--2) 각 컬럼별로 코멘트 생성해주세요(사번, 이름, 부서코드, 직급코드, 퇴직 여부)
--3) EMPLOYEE테이블에서 부서코드가 'D2'와 'D5'인
--   직원들의 사번 , 이름, 부서코드, 직급코드,퇴직 여부를 조회하여 EMP_EX2 테이블에 삽입해주세요
--4) EMP_EX2 테이블에서 직급코드가 'J5'인 직원의 퇴직 여부를 Y로 바꿔주세요


--9.  EMPLOYEE 테이블에서 봉급이 3500000 이상 이하 를 나타내서
-- 사원의 사번, 이름, 입사일, 급여를 조회하여
-- 이상이면 EMP_HIGH 테이블에 삽입하고
-- 이하인 사원은 EMP_LOW 테이블에 삽입하세요


--10. 99년한해에 입사한 동기 모두 봉급을 2500000 으로 일치
-- 94년한해에 입사한 동기 모두 봉급을 2700000 으로 일치
-- 직원 실수로 유하진의 입사날짜가 실수로 더 일찍 들어온거로 되어있다 원래는 하이유와 같은 입사일이었다.
-- 하이유 와 같은 입사일자로 변경하시요.