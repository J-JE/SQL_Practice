-- PL/SQL (PROCEDURE LANGUAGE EXTENSION TO SQL)
-- 오라클 자체에 내장된 절차적 언어
-- SQL의 단점을 보완하여 SQL문장 내에서
-- 변수의 정의, 조건처리, 반복처리, 예외처리 등을 지원한다.

-- PL/SQL의 장점
-- BLOCK구조로 다수의 SQL문을 한 번에 ORACLE DB로 보내 처리하므로 수행 속도 향상
-- 단순, 복잡한 데이터 형태의 변수 및 테이블의 데이터 구조와 컬럼 명에 준하여 동적으로 변수 선언 가능

-- PL/SQL 구조
-- 선언부, 실행부, 예외처리부로 구성되어 있음
-- 선언부 : DECLARE로 시작, 변수나 상수를 선언하는 부분
-- 실행부 : BEGIN으로 시작, 제어문, 반복문, 함수의 정의등 로직 작성
-- 예외처리부 : EXCEPTION으로 시작, 예외처리 내용 작성


BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/

SET SERVEROUTPUT ON;

--1. DECLARE 선언부
-- 변수 및 상수 선언해 놓는 공간 (초기화도 가능)
-- 일반타입 변수, 레퍼런스 타입 변수, ROW 타입 변수 

--1-1) 일반타입 변수 선언 및 초기화
--[표현법] 
-- 변수명 [CONSTANT] 자료형(크기) [:=값];

DECLARE
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(30);
BEGIN
    EMP_ID := '888';
    EMP_NAME := '배장남';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : '||EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME :'||EMP_NAME);
END;
/


--1-2) 레퍼런스 타입 변수 선언및 초기화 (어떤테이블의 어떤 컬럼의 데이터 타입을 참조해서 그타입으로 지정)
--[표현법] 변수명 테이블명.컬럼명%TYPE;

DECLARE
    EMP_IDA EMPLOYEE.EMP_ID%TYPE;
    EMP_NAMEA EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EMP_IDA, EMP_NAMEA
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : '||EMP_IDA);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME :'||EMP_NAMEA);
END;
/


-- 레퍼런스 변수로 EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE,SALARY
-- 를 선언 하고 , EMPLOYEE 테이블에서 사번,이름, 직급코드, 부서코드, 급여를 조회하여
-- 선언한 레퍼런스 변수에 담아 출력하세요 
-- 단, 입력받은 이름과 일치하는 조건의 직원을 조회하세요

DECLARE
    EMP_ID EMPLOYEE.EMP_ID%TYPE;
    EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
    DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
    JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
    INTO EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME = '&EMP_NAME';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : '||EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME :'||EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_CODE :'||DEPT_CODE);
    DBMS_OUTPUT.PUT_LINE('JOB_CODE :'||JOB_CODE);
    DBMS_OUTPUT.PUT_LINE('SALARY :'||SALARY);

END;
/

--1_3) 한행에 대한 타입변수선언
--[표현법] 변수명 테이블명 %ROWTYPE;
-- 테이블의 한행의 모든 컬럼과 자료형을 참조하는 경우 사용

DECLARE
    EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : '||EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME :'||EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_CODE :'||EMP.DEPT_CODE);
    DBMS_OUTPUT.PUT_LINE('JOB_CODE :'||EMP.JOB_CODE);
    DBMS_OUTPUT.PUT_LINE('SALARY :'||EMP.SALARY);

END;
/

--2. BEGIN 
--조건문 
--1) IF 조건식 THEN 실행내용 END IF;(단일IF문)

-- 사번을 입력받은 후 해당사원의 사번, 이름 , 급여 , 보너스 율(%) 출력하기 
-- 단, 보너스를 받지않는 사원은 보너스율 출력전 '보너스를 지급받지않는 사원입니다 ' 출력
-- 사번 : 200 , 201
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 : '||EID);
    DBMS_OUTPUT.PUT_LINE('이름 :'||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 :'||SALARY);
    
    IF(BONUS =0)
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('보너스율(%) :'||BONUS * 100||'%');
END;
/

--2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF;(IF~ELSE문)
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO EID, ENAME, SALARY, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 : '||EID);
    DBMS_OUTPUT.PUT_LINE('이름 :'||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 :'||SALARY);
    
    IF(BONUS =0)
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE 
    DBMS_OUTPUT.PUT_LINE('보너스율(%) :'||BONUS * 100||'%');
    END IF;
END;
/


-- IF ~ ELSIF ~ ELSE ~ END IF
-- 점수를 입력받아 SCORE 변수에 저장하고 
-- 90점 이상은 'A', 80점 이상은 'B', 70점 이상은 'C'
-- 60점 이사은 'D' , 60 점 미만은 'F' 로 조건 처리하여 
-- GRADE 변수에 저장하여 
--' 당신의 점수는 90 점이고 , 학점은 A 학점 입니다.' 형태로 출력하세요


DECLARE
    SCORE NUMBER;
    GRADE VARCHAR2(2);
BEGIN
    SCORE :='&SCORE';
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 '||SCORE||'점이고'||GRADE||'학점입니다.');

END;
/
--오류 다시 확인 (ELSIF 오타)


-- CASE  비교대상자 
-- WHEN 동등 비교할 값1 THEN 결과값1 
-- WHEN 동등 비교할 값2 THEN 결과값2 
-- ELSE 결과값 
-- END;

-- 사번을 입력하여 해당사원의 사번 ,이름 , 부서명 출력

DECLARE
    VEMPNO EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VDEPTNO EMPLOYEE.DEPT_CODE%TYPE;
    VDNAME VARCHAR2(20) := NULL;
BEGIN
    SELECT
        EMP_ID,
        EMP_NAME,
        DEPT_CODE
    INTO VEMPNO, VENAME, VDEPTNO
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    VDNAME := CASE VDEPTNO
              WHEN 'D1' THEN '인사관리부'
              WHEN 'D2' THEN '회계관리부'
              WHEN 'D3' THEN '마케팅부'
              WHEN 'D4' THEN '국내영업부'
              WHEN 'D5' THEN '해외영업1부'
              WHEN 'D6' THEN '해외영업2부'
              WHEN 'D7' THEN '해외영업3부'
              WHEN 'D8' THEN '기술지원부'
              WHEN 'D9' THEN '총무부'
              END;
              
    DBMS_OUTPUT.PUT_LINE('사번 : '|| VEMPNO ||' 이름 : '|| VENAME ||' 부서명 : '|| VDNAME );
END;
/

-- ** 반복문 **

/*
    1) BASIC LOOP
    
    [표현식]
    LOOP 
        반복적으로 실행시킬 구문
        
        반복문을 빠져나갈 조건
    END LOOP;
    
    --> 반복문을 빠져나갈 조건문 (2가지 표현)
        IF 조건식 THEN EXIT; END IF;
        EXIT WHEN 조건식;
    
*/
-- 1부터 5 까지 순차적으로 출력

DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N:=N+1;
        IF N >5 THEN EXIT;
        END IF;
    END LOOP;
END;
/
--또는
DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N:=N+1;
        EXIT WHEN N > 5;
    END LOOP;
END;
/

/*
    2) FOR LOOP
    
    [표현식]
    FOR 변수 IN [REVERSE] 초기값..최종값
    LOOP
        반복적으로 실행할 구문;
    END LOOP;
*/

--1부터 5까지 출력
BEGIN
    FOR N IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/

--1부터 5까지 역으로 출력
BEGIN
    FOR N IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
    END LOOP;
END;
/

/*
    3) WHILE LOOP
    
    [표현식]
    WHILE 반복문이수행될조건
    LOOP
        반복적으로 실행할 구문;
    END LOOP;
*/
--1부터 5까지 출력
DECLARE
    N NUMBER :=1;
BEGIN
    WHILE N <= 5
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N:=N+1;
    END LOOP;
END;
/


CREATE TABLE TEST1(
    BNO NUMBER(3),
    BDATE DATE
);

BEGIN
    FOR I IN 1..10
    LOOP
        INSERT INTO TEST1
        (BNO, BDATE)
        VALUES
        (I,SYSDATE);
    END LOOP;
END;
/

SELECT * FROM TEST1;

-- 구구단 짝수단 출력하기
BEGIN
    FOR I IN 1..9
    LOOP
        IF MOD(I,2)=0 THEN
            DBMS_OUTPUT.PUT_LINE('-------');
            FOR J IN 1..9
            LOOP
            DBMS_OUTPUT.PUT_LINE(I||'*'||J||'='||I*J);
            END LOOP;
        END IF;
    END LOOP;
END;
/

--FOR문
DECLARE
    RESULT NUMBER;
BEGIN
    FOR DAN IN 1..9
    LOOP
        IF MOD(DAN,2)=0
            THEN FOR SU IN 1..9
            LOOP
                RESULT := DAN*SU;
                DBMS_OUTPUT.PUT_LINE(DAN||' * '||SU||' = '||RESULT);
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');
        END IF;
    END LOOP;
END;
/
--WHILE문
DECLARE
    RESULT NUMBER;
    DAN NUMBER :=2;
    SU NUMBER;
    
BEGIN
    WHILE DAN <= 9
    LOOP
        SU :=1;
        IF MOD(DAN,2) = 0
            THEN WHILE SU <= 9
                 LOOP
                    RESULT := DAN * SU;
                    DBMS_OUTPUT.PUT_LINE(DAN || ' * '|| SU ||' = '|| RESULT);
                    SU := SU + 1;
                 END LOOP;
        END IF;
        DAN := DAN + 1;
    END LOOP;
END;
/

-- 테이블 타입의 변수 선언 값 대입및 출력 
-- BINARY_INTEGER 로만 INDEX 선언할수있음 
-- 이렇게 선언된 테이블 타입을 가지는 변수 를 선언하게되면
-- 해당변수는 여러 데이터를 가질수있는 일차원배열 형태가 된다.


DECLARE
    TYPE EMP_ID_TABLE_TYPE IS TABLE OF EMPLOYEE.EMP_ID%TYPE
    INDEX BY BINARY_INTEGER;

    TYPE EMP_NAME_TABLE_TYPE IS TABLE OF EMPLOYEE.EMP_NAME%TYPE
    INDEX BY BINARY_INTEGER;

    EMP_ID_TABLE EMP_ID_TABLE_TYPE;
    EMP_NAME_TABLE EMP_NAME_TABLE_TYPE;
    
    I BINARY_INTEGER := 0;
BEGIN
    I :=1;
    FOR K IN (SELECT EMP_ID, EMP_NAME FROM EMPLOYEE) LOOP
        EMP_ID_TABLE(I) := K.EMP_ID;
        EMP_NAME_TABLE(I) := K.EMP_NAME;
--        DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID_TABLE(I) ||' EMP_NAME : '|| EMP_NAME_TABLE(I));
        I:= I+1;
    END LOOP;
        
    FOR J IN 1..I-1 LOOP
        DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP_ID_TABLE(J) ||' EMP_NAME : '|| EMP_NAME_TABLE(J) || '  ' ||I || '   ' || J);
    END LOOP;
END;
/
    
-- 레코드 타입의 변수 선언 및 값 대입 출력
-- 레코드 타입은 필드(여러가지 종류의 속성값)를 하나로 합쳐서 다루는 데이터 타입

DECLARE
    TYPE EMP_RECORD_TYPE IS RECORD(
        EMP_ID EMPLOYEE.EMP_ID%TYPE,
        EMP_NAME EMPLOYEE.EMP_NAME%TYPE,
        DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE,
        JOB_NAME JOB.JOB_NAME%TYPE
    );
    
    EMP_RECORD EMP_RECORD_TYPE;
    
BEGIN
    SELECT
        A.EMP_ID,
        A.EMP_NAME,
        B.DEPT_TITLE,
        C.JOB_NAME
    INTO EMP_RECORD
    FROM EMPLOYEE A
    LEFT JOIN DEPARTMENT B ON A.DEPT_CODE=B.DEPT_ID
    LEFT JOIN JOB C ON A.JOB_CODE=C.JOB_CODE
    WHERE A.EMP_NAME='&EMP_NAME';
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP_RECORD.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP_RECORD.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서 : ' || EMP_RECORD.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('직급 : ' || EMP_RECORD.JOB_NAME);
END;
/


/*
@ 시스템 오류 예외처리
-> 시스템 오류 (예를 들면, 메모리 초과, 인덱스 중복 키 등)는 오라클이 정의하는 에러로
보통 PL/SQL 실행 엔진이 오류 조건을 탐지하여 발생시키는 예외이다.
-> Exception 이름을 아는 경우와 모르는 경우에 대하여 사용하는 방법은 다름


# Exception 이름을 아는 경우
-> 오라클에서 미리 정의해 놓은 Exception 

ACCESS_INTO_NULL
초기화되지 않은 오브젝트에 값을 할당하려고 할 때

CASE_NOT_FOUND
CASE문장에서 ELSE구문도 없고 WHEN절에 명시된 조건을 만족하는 것이 없을 경우

COLLECTION_IS_NULL
초기화되지 않은 중첩 테이블이나 VARRAY같은 컬렉션을 
EXISTS외의 다른 메소드로 접근을 시도할 경우

CURSOR_ALREADY_OPEN
이미 오픈된 커서를 다시 오픈하려고 시도하는 경우

DUP_VAL_ON_INDEX
UNIQUE 인덱스가 설정된 컬럼에 중복 데이터를 입력할 경우

INVALID_CURSOR
허용되지 않은 커서에 접근할 경우 (OPEN되지 않은 커서를 닫으려고 할 경우)

INVALID_NUMBER
SQL문장에서 문자형 데이터를 숫자형으로 변환할 때 제대로 된 숫자로 변환되지 않을 경우

LOGIN_DENIED
잘못된 사용자명이나 비밀번호로 접속을 시도할 때

NO_DATA_FOUND
SELECT INTO 문장의 결과로 선택된 행이 하나도 없을 경우

*/

SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_ID = 2044;


--정의 된 예외
DECLARE
    NAME VARCHAR2(30);
BEGIN
    SELECT EMP_NAME
    INTO NAME
    FROM EMPLOYEE
    WHERE EMP_ID = 2044;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN DBMS_OUTPUT.PUT_LINE('조회된 결과가 없습니다.');
END;
/

--정의 되지 않은 예외
UPDATE EMPLOYEE
SET EMP_ID = 201
WHERE EMP_ID = 200;

DECLARE
    DUP_EMPID EXCEPTION;
    PRAGMA EXCEPTION_INIT(DUP_EMPID,-00001);
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = 201
    WHERE EMP_ID = 200;
EXCEPTION
    WHEN DUP_EMPID
    THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
END;
/

