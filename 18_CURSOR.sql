-- CURSOR
-- : 처리 결과가 여러 개의 행으로 구해지는 SELECT문을 처리하기 위해
--   처리 결과를 저장해 놓은 객체이다.
--   CURSOR~ OPEN~ FETCH~ CLOSE 단계로 진행된다.

--CURSOR : 커서의 선언
--OPEN : 커서 열기
--FETCH : 커서의 패치
--CLOSE : 커서 닫기

--> 커서에는 명시적 커서와 암시적 커서가 있음

--명시적 커서 : 사용자가 직접 쿼리의 결과에 접근해서 이를 사용하기 위해 명시적으로 선언한 커서 
--암시적 커서 : 커서를 처리하는 코드를 직접 작성할 필요가 없음
--> 일반적으로 사용하는 SQL 문으로 한번 실행에 하나의 결과 값을 얻어옴
--> 암시적 커서는 SQL 문이 실행되는 순간 자동으로 OPEN 과 CLOSE를 함


-- CURSOR의 속성
-- %NOTFOUND : 커서 영역의 자료가 모두 인출(FETCH)되어 
--             다음 영역이 존재하지 않으면 TRUE
-- %FOUND : 커서 영역에 FETCH 되지 않은자료가 아직 있으면 TRUE
-- %ISOPEN : 커서가 OPEN된 상태면 TRUE
-- %ROWCOUNT : 커서가 얻어온 레코드의 갯수



-- 명시적 커서 
--> 사용자가 직접 쿼리의 결과에 접근해서 이를 사용하기 위해 명시적으로 선언한 커서

--> 기존 PL/SQL 이나 프로시져에서는 하나의 결과만 나와야 했음 
--	- 기존은 하나씩 처리 해야 하므로 계속된 조회를 반복 하여 처리하였음
--> 명시적 커서를 이용하면 여러개의 대한 처리가 가능함




--# 명시적 커서의 형식 (4단계 : 선언-> 열기-> 처리-> 닫기)

DECLARE
	CURSOR CURSOR_NAME 			-- 커서 선언
IS STATEMENT;					-- 커서에 사용된 SQL 구문

BEGIN
	OPEN CURSOR_NAME;			-- 커서 열기
	FETCH CUR_NAME INTO VARIABLE_NAME;	-- 커서로부터 데이터를 읽어와 변수에 저장
	CLOSE CURSOR_NAME;			-- 커서 닫기
END;




--1 단계 : 커서 선언
--> 암시적 커서와 달리 사용할 커서에 이름을 부여하고 이 커서에 대한 쿼리를 선언 해야함
--> 명시적 커서란 것이 결과 데이터 집합을 로우별로 참조해서 무언가를 작업하기 위한 용도 이므로
--당연히 커서를 정의해 사용하는 쿼리문은 SELECT 문이여야 함


CURSOR 커서명(매개변수1,매개변수2,...)
IS
SELECT 문장;



--2 단계 : 커서 열기
--> 커서를 선언한 뒤 해당 커서를 사용하려면 커서를 열어야 함

OPEN 커서명 (매개변수1,매개변수2,....);




--3 단계 : 패치 단계에서 커서 사용
--> 정의한 커서를 열고 난 후에야 SELECT 문의 결과로 반환되는 로우에 접근할 수 있음
--> 결과 집합의 로우 수는 보통 1개 이상이므로 개별 로우에 접근하기 위해서는 반복문을 사용할 수 있음
--	- LOOP, WHILE, FOR 문 사용이 가능
--> 반복을 하게 되면 자동으로 다음 로우를 가리키게 됨


LOOP
	FETCH 커서명 INTO 변수1, 변수2, ...;	
	EXIT WHEN 커서명%NOTFOUND;		-- 커서의 속성을 이용하여 루프를 벗어남
END LOOP;



--4 단계 : 커서 닫기
--> 패치 작업이 끝나고 반복문을 빠져 나오면 커서 사용이 모두 끝났으므로 반드시 커서를 닫아 주어야 함
--	- 우리가 스트림을 열고 닫는 개념과 같음
CLOSE 커서명; 

--블럭 잡아서 돌리기!
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    V_DEPT DEPARTMENT%ROWTYPE;
    CURSOR C1 --커서 선언
    IS
    SELECT * FROM DEPARTMENT;
BEGIN
    OPEN C1; --커서 열기
    LOOP
        FETCH C1 --커서에 있는 한 행씩 인출
        INTO V_DEPT.DEPT_ID, --각 변수에 담기
             V_DEPT.DEPT_TITLE,
             V_DEPT.LOCATION_ID;
        EXIT WHEN C1%NOTFOUND; --커서에 더이상 다음 행이 존재하지 않으면 빠져나감
        
        DBMS_OUTPUT.PUT_LINE('부서코드 :' || V_DEPT.DEPT_ID || '부서명 : '|| V_DEPT.DEPT_TITLE ||'지역 : ' || V_DEPT.LOCATION_ID);
    END LOOP;
    CLOSE C1;
END;
/

EXEC CURSOR_DEPT;
SET SERVEROUTPUT ON;

----


CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    V_DEPT DEPARTMENT%ROWTYPE;
    CURSOR C1 --커서 선언
    IS
    SELECT * FROM DEPARTMENT;
BEGIN
   FOR V_DEPT IN C1 LOOP
        DBMS_OUTPUT.PUT_LINE('부서코드 :' || V_DEPT.DEPT_ID || '부서명 : '|| V_DEPT.DEPT_TITLE ||'지역 : ' || V_DEPT.LOCATION_ID);    
   END LOOP;
END;
/

EXEC CURSOR_DEPT;


--@ 암시적 커서 
--> 암시적 커서는 사용자가 직접 쿼리의 결과에 접근하지 못함 자동적으로 해줌

CREATE TABLE EMPLOYEE2
AS
SELECT * FROM EMPLOYEE;

CREATE OR REPLACE PROCEDURE TEST11
IS
    V_COUNT_ROW NUMBER;
BEGIN
    UPDATE EMPLOYEE2
    SET EMP_NAME = '유재석'
    WHERE EMP_ID = '201';
    
    V_COUNT_ROW := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('성공행 갯수: ' ||V_COUNT_ROW);
END;
/

EXEC TEST11;

SELECT * FROM EMPLOYEE2;



