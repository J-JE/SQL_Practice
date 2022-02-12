-- TCL (Transaction Controll Language)
-- 트랜젝션 제어 언어
-- COMMIT과 ROLLBACK이 있다.

-- 트랜젝션이란?
-- 한꺼번에 수행되어야 할 최소의 작업 단위를 말한다.
-- 논리적 작업 단위(Logical Unit of Work : LUW)
-- 하나의 트랜젝션으로 이루어진 작업은 반드시 한꺼번에 완료(COMMIT)
-- 되어야 하며, 그렇지 않은 경우에는 한꺼번에 취소(ROLLBACK)되어야 함

-- EX) ATM기기 인출을 함
-- 1. 카드 삽입
-- 2. 메뉴 선택(인출)
-- 3. 금액 확인, 비밀번호 인증
-- 4. 금액 입력(만약 3번에서 에러가 발생했다면 3번 수행하기 이전으로 되돌려야되고 ,3번까지 정상적으로 진행되면 진행된 작업모두 반영처리해야함 )

-- 5. 인출구에서 현금 수령
-- 6. 카드 받기
-- 7. 명세표 받기

-- COMMIT : 트랜젝션 작업이 정상 완료되면 변경 내용을 영구히 저장
-- ROLLBACK : 트랜젝션 작업을 취소하고 최근 COMMIT한 시점으로 이동
-- SAVEPOINT 세이브포인트명 : 현재 트랜젝션 작업 시점에 이름을 정해줌
--                          하나의 트랜젝션 안에 구역을 나눔 
-- ROLLBACK TO 세이브포인트명 : 트랜젝션 작업을 취소하고
--                            SAVEPOINT 시점으로 이동

CREATE TABLE USER_TBL(
    USERNO NUMBER UNIQUE,
    ID VARCHAR(20) PRIMARY KEY,
    PASSWORD CHAR(20) NOT NULL
);

INSERT INTO USER_TBL
VALUES(1,'test1','pass1');

INSERT INTO USER_TBL
VALUES(2,'test2','pass2');

INSERT INTO USER_TBL
VALUES(3,'test3','pass3');


SELECT * FROM USER_TBL;
COMMIT;

INSERT INTO USER_TBL
VALUES(4,'test4','pass4');

ROLLBACK; --COMMIT 한 값은 안 돌아감


INSERT INTO USER_TBL
VALUES(4,'test4','pass4');

SAVEPOINT SP1;

INSERT INTO USER_TBL
VALUES(5,'test5','pass5');

ROLLBACK TO SP1; --세이브 포인트 지정한 곳 까지 롤백

ROLLBACK; --최근 커밋 지점까지 롤백

SELECT * FROM USER_TBL;