-- PACKAGE
--> 자바의 패키지와 동일한 개념
-- : 프로시져와 함수를 효율적으로 관리하기 위해 묶는 단위
-- : 패키지명.함수명() <- 이런 형태로 사용함

/*
-- 패키지 선언 방법

CREATE [OR REPLACE] PACKAGE 패키지명
IS
	정의될 저장프로시저와 저장함수
END;
/

-- 패키지에 소속된 프로시저나 함수 실행

EXEC 패키지명.저장프로시저명 [(전달값,...)];




-- 패키지의 형식

CREATE [OR REPLACE] PACKAGE package_name

IS
	PROCEDURE procedure_name1;
	PROCEDURE procedure_name2;
END;
/

CREATE [OR REPLACE] PACKAGE package_name
IS
	PROCEDURE procedure_name1
	IS
	...
	END;
END;
/
*/


-- 패키지는 프로시저를 먼저 만들어주고 선언 하는것이 아니고 패키지를 만들고 프로시져만들기
--------------------------------------------------------------------------------

--1. 먼저 패키지를 만들고 어떤 프로시저를 넣겠다고 정의한다.
CREATE OR REPLACE PACKAGE UNI_PACK
IS
    PROCEDURE SHOW_EMP;
    FUNCTION BONUS_CAL(V_EMP IN EMPLOYEE.EMP_ID%TYPE) RETURN NUMBER;
END;
/

--2. 해당 패키지에 넣을 프로시저를 정의한다.

CREATE OR REPLACE PACKAGE BODY UNI_PACK
IS
    PROCEDURE SHOW_EMP
    IS
        V_EMP EMPLOYEE%ROWTYPE;
        CURSOR C1
        IS
        SELECT EMP_ID,
               EMP_NAME,
               EMP_NO
        FROM EMPLOYEE;
    BEGIN
        FOR V_EMP IN C1 LOOP
        DBMS_OUTPUT.PUT_LINE('사번 :'|| V_EMP.EMP_ID || '이름 :'|| V_EMP.EMP_NAME ||'주민등록번호 :'|| V_EMP.EMP_NO );
        END LOOP;
    END;
    
    FUNCTION BONUS_CAL(V_EMP EMPLOYEE.EMP_ID%TYPE)
    RETURN NUMBER
    IS
        V_SAL EMPLOYEE.SALARY%TYPE;
        CAL_BONUS NUMBER;
    BEGIN
        SELECT SALARY
        INTO V_SAL
        FROM EMPLOYEE
        WHERE EMP_ID = V_EMP;
        
        CAL_BONUS :=V_SAL*2;
        RETURN CAL_BONUS;
    END;
END;
/

EXEC UNI_PACK.SHOW_EMP;

VARIABLE VAR_CAL NUMBER;
EXEC :VAR_CAL := UNI_PACK.BONUS_CAL('&EMP_ID');

SELECT UNI_PACK.BONUS_CAL(EMP_ID) VAL FROM EMPLOYEE;

SELECT * FROM USER_SOURCE WHERE TYPE='PACKAGE';
