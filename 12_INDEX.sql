-- 인덱스(INDEX)
-- : SQL명령문의 처리 속도를 향상시키기 위해서 
--  컬럼에 대해서 생성하는 오라클 객체이다.
--  인덱스를 생성하기 위한 시간이 필요하고, 인덱스를 위한 추가
--  저장공간이 필요하기 때문에 반드시 좋은 것은 아니다.
--  => DML작업이 빈번한 경우 처리속도가 느려진다.

-- 장점
-- 검색 속도가 빨라짐
-- 시스템에 걸리는 부하를 줄여서 시스템 전체의 성능을 향상시킴

-- 단점
-- 인덱스를 위한 추가 저장공간이 필요함
-- 인덱스를 생성하는데 시간이 걸림
-- 데이터의 변경작업(INSERT/UPDATE/DELETE)이 자주 일어나는 경우(목차를 계속 갱신한다고 이해)
-- 오히려 성능이 저하됨
-- 기존 데이터의 대하여 알고리즘을 이용하여 INDEX를 생성하였는데
-- 데이터가 변경되면 다시 새롭게 알고리즘을 사용하여 INDEX를 생성하여야 
--	하기 때문에 오히려 성능 저하가 발생할 수 있음

/*
@ 효율적인 인덱스 사용 예
-> 전체 데이터 중에서 10% ~ 15% 이내의 데이터를 검색하는 경우
-> 두 개 이상의 칼럼이 WHERE절이나 조인(join) 조건으로 자주 사용되는 경우
-> 한 번 입력된 데이터의 변경이 자주 일어나지 않는 경우
-> 한 테이블에 저장된 데이터 용량이 상당히 클 경우
*/


SELECT * FROM USER_IND_COLUMNS;



--> 행을 찾아 가기위한 가상 컬럼 
--> INDEX 정보를 조회하게되면 이미생성된 INDEX를 확인할수 있는데 INDEX는 실제로 유저가 생성하지않아도 기본키나
--> 유일키같은 제약조건을 지정하면 자동으로 인덱스를 생성함 

/* 인덱스 구조 

ROWID: DB내 데이터 공유주소값 , ROWID 를 이용해 데이터 접근가능
1~6 번째 : 데이터 오브젝트 번호
7~9 번째 : 파일번호
10~15 번째 : BLOCK 번호
16~18 번째 : ROW 번호

*/

/* 인덱스의 원리
인덱스 생성시 지정한 컬럼값은 (KEY), ROWID는 (VALUE) 가 되어 MAP처럼 구성되어있다 
SELECT 시 WHERE 절에 인덱스가 생성되어있는 컬럼을 가지고 조건을 수행하면 
데이터 조회시테이블의 모든 데이터에 접근 하는 것이 아닌
해당 컬럼(KEY) 과 매칭되는 ROWID(VALUE) 가 가리키는 ROW 주소 의 값을 조회 해주는 방식 이므로 속도 향상.
*/


SELECT ROWID, A.*
FROM EMPLOYEE A;


SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME = '윤은해';--F10 ->계획 설명->FULL

SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_ID = '210';--F10-> BY INDEX ROWID, UNIQUE SCAN -> 속도 향상

/* WHERE 절에 
    INDEX 가 부여되지 않은 컬럼으로 조회시 --> 윤은해가 어느곳에 있는지 모르기 때문에 EMPLOYEE테이블 데이터 전부를 
                                         DB BUFFER캐시로 복사한뒤 FULLSCAN 으로 찾게됨
    INDEX 가 부여된 컬럼으로 조회시 -->  INDEX 에 먼저 가서 210정보가 어떤 ROWID 를 가지고 있는지 확인한뒤 
                                     해당 ROWID 에 있는 블럭만 찾아가서 DB BUFFER캐쉬에 복사. 
*/

-- 인덱스 종류
-- 1. 고유인덱스(UNIQUE INDEX)
-- 2. 비고유인덱스(NONUNIQUE INDEX)
-- 3. 단일인덱스(SINGLE INDEX)
-- 4. 결합인덱스(COMPOSITE INDEX)
-- 5. 함수 기반 인덱스(FUNCTION BASED INDEX)                    

--1.
-- UNIQUE INDEX
-- UNIQUE INDEX로 생성된 컬럼에는 중복값이 포함될 수 없음(-- 중복값이 있는 컬럼은 UNIQUE 인덱스 생성하지 못함)
-- 오라클 PRIMARY KEY 제약조건을 생성하면
-- 자동으로 해당 컬럼에 UNIQUE INDEX가 생성됨
-- PRIMARY KEY를 이용하여 ACCESS 경우에 성능 향상에 효과가 있음

-- 2.NONUNIQUE INDEX
-- WHERE절에서 빈번하게 사용되는 일반 컬럼을 대상으로 생성
-- 주로 성능 향상을 위한 목적으로 생성함
--CREATE INDEX IDX_DEPTCODE
--ON EMPLOYEE(DEPT_CODE);

-- 3. 단일인덱스
--CREATE INDEX IDX_DEPTCODE
--ON EMPLOYEE(DEPT_CODE);

-- 4.결합인덱스(COMPOSITE INDEX)
--CREATE INDEX IDX_DEPT
--ON DEPARTMENT(DEPT_ID, DEPT_TITLE);

-- 5.함수 기반 인덱스
-- SELECT절이나 WHERE절에서 산술계산식이나 함수가 사용된 경우
-- 계산에 포함된 컬럼은 인덱스의 적용을 받지 않는다.
-- 계산식으로 검색하는 경우가 많다면, 수식이나 함수를 이용하여
-- 인덱스로 만들 수도 있다.
--CREATE INDEX IDX_EMP02_SALCALC
--ON EMP02 ((SALARY + (SALARY * NVL(BONUS,0))) * 12);

-- 인덱스 삭제
--DROP INDEX IDX_EMP02_SALCALC;

SELECT *
FROM SYS.USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMPLOYEE';

CREATE UNIQUE INDEX IDX_ENM ON EMPLOYEE(EMP_NAME); --인덱스 추가

DROP INDEX IDX_ENM;

