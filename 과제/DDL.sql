--1.
CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);

--2.
CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10)
);

--3.
ALTER TABLE TB_CATEGORY
ADD PRIMARY KEY (NAME);

--4.
ALTER TABLE TB_CLASS_TYPE
MODIFY NAME NOT NULL;

--5.
ALTER TABLE TB_CLASS_TYPE
MODIFY NO VARCHAR2(10)
MODIFY NAME VARCHAR2(20);

ALTER TABLE TB_CATEGORY
MODIFY NAME VARCHAR2(20);

--6.
ALTER TABLE TB_CATEGORY
RENAME COLUMN NAME TO CATEGORY_NAME;

ALTER TABLE TB_CLASS_TYPE
RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE
RENAME COLUMN NAME TO CLASS_TYPE_NAME;

--7.
ALTER TABLE TB_CATEGORY
RENAME CONSTRAINT SYS_C007398 TO PK_CATEGORY_NAME;

ALTER TABLE TB_CLASS_TYPE
RENAME CONSTRAINT SYS_C007397 TO PK_CLASS_TYPE_NO;

--8.
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT;

--9.
ALTER TABLE TB_DEPARTMENT
ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY (CATEGORY) REFERENCES TB_CATEGORY(CATEGORY_NAME);

--10.
CREATE OR REPLACE VIEW VW_학생일반정보
(학번, 학생이름, 주소)
AS
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
FROM TB_STUDENT;

--11.
CREATE OR REPLACE VIEW VW_지도면담
AS
SELECT A.STUDENT_NAME "학생이름", B.DEPARTMENT_NAME "학과이름", C.PROFESSOR_NAME "지도교수이름"
FROM TB_STUDENT A
LEFT JOIN TB_DEPARTMENT B ON A.DEPARTMENT_NO=B.DEPARTMENT_NO
LEFT JOIN TB_PROFESSOR C ON A.COACH_PROFESSOR_NO=C.PROFESSOR_NO
ORDER BY B.DEPARTMENT_NAME;

--12.
CREATE OR REPLACE VIEW VW_학과별학생수
AS
SELECT DEPARTMENT_NAME, COUNT(*) "STUDENT_COUNT"
FROM TB_DEPARTMENT A
JOIN TB_STUDENT B ON A.DEPARTMENT_NO=B.DEPARTMENT_NO
GROUP BY ROLLUP(DEPARTMENT_NAME);

--13.
SELECT *
FROM "VW_학생일반정보"
WHERE "학번"='A213046';

UPDATE "VW_학생일반정보"
SET "학생이름"='전재은'
WHERE "학번"='A213046';

--14.
CREATE OR REPLACE VIEW VW_학생일반정보
(학번, 학생이름, 주소)
AS
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
FROM TB_STUDENT
WITH READ ONLY;

--15.
--최근 3년동안의 수강인원이 가장 많은 과목의 3년동안의 누적학생수 3위 까지
--최근 3년동안 수강인원이 가장 많은 과목 3위까지 중  의 전체 누적학생수 3위까지

--수정 전----수정 전----수정 전----수정 전----수정 전----수정 전----수정 전--

SELECT DISTINCT SUBSTR(TERM_NO,1,4) FROM TB_GRADE ORDER BY 1 DESC;
--최근 3년

SELECT B.CLASS_NO "과목번호", B.CLASS_NAME "과목이름", COUNT(*) "누적수강생수(명)"
FROM TB_GRADE A
JOIN TB_CLASS B ON A.CLASS_NO=B.CLASS_NO
WHERE SUBSTR(TERM_NO,1,4) BETWEEN '2007' AND '2009'
GROUP BY B.CLASS_NO, B.CLASS_NAME
ORDER BY 3 DESC;
--과목별 최근 3년의 누적 수강생수

SELECT *
FROM (
    SELECT A.CLASS_NO "과목번호", B.CLASS_NAME "과목이름", COUNT(*) "누적수강생수(명)"
    FROM TB_GRADE A
    JOIN TB_CLASS B ON A.CLASS_NO=B.CLASS_NO
    WHERE SUBSTR(A.TERM_NO,1,4) BETWEEN '2007' AND '2009'
    GROUP BY A.CLASS_NO, B.CLASS_NAME
    ORDER BY 3 DESC)
WHERE ROWNUM <=3;
--과목별 최근 3년의 누적 수강생수 3위까지

SELECT A.CLASS_NO "과목번호", B.CLASS_NAME "과목이름", COUNT(*) "누적수강생수(명)"
FROM TB_GRADE A
JOIN TB_CLASS B ON A.CLASS_NO=B.CLASS_NO
WHERE A.CLASS_NO IN (
    SELECT "과목번호"
    FROM (
        SELECT A.CLASS_NO "과목번호", B.CLASS_NAME "과목이름", COUNT(*) "누적수강생수(명)"
        FROM TB_GRADE A
        JOIN TB_CLASS B ON A.CLASS_NO=B.CLASS_NO
        WHERE SUBSTR(A.TERM_NO,1,4) BETWEEN '2007' AND '2009'
        GROUP BY A.CLASS_NO, B.CLASS_NAME
        ORDER BY 3 DESC)
    WHERE ROWNUM <=3)
GROUP BY A.CLASS_NO, B.CLASS_NAME
ORDER BY 3 DESC;
--최근 3년동안 수강인원이 가장 많은 과목 3위까지의 전체 누적학생수

--수정 전----수정 전----수정 전----수정 전----수정 전----수정 전----수정 전--

SELECT *
FROM (SELECT SUBSTR(TERM_NO,1,4)
      FROM TB_GRADE
      GROUP BY SUBSTR(TERM_NO,1,4)
      ORDER BY 1 DESC) A
WHERE ROWNUM <=3;
--최근 3년

SELECT B.CLASS_NO "과목번호", B.CLASS_NAME "과목이름",
       COUNT(*) "누적수강생수(명)", DENSE_RANK() OVER(ORDER BY COUNT(A.STUDENT_NO) DESC) "순위"
FROM TB_GRADE A
JOIN TB_CLASS B ON A.CLASS_NO=B.CLASS_NO
WHERE SUBSTR(TERM_NO,1,4) IN (SELECT *
                              FROM (SELECT SUBSTR(TERM_NO,1,4)
                                    FROM TB_GRADE
                                    GROUP BY SUBSTR(TERM_NO,1,4)
                                    ORDER BY 1 DESC) A
                              WHERE ROWNUM <=3)
GROUP BY B.CLASS_NO, B.CLASS_NAME
ORDER BY 3 DESC;
--과목별 최근 3년의 누적 수강생수

SELECT *
FROM (
    SELECT B.CLASS_NO "과목번호", B.CLASS_NAME "과목이름",
           COUNT(*) "누적수강생수(명)", DENSE_RANK() OVER(ORDER BY COUNT(A.STUDENT_NO) DESC) "순위"
    FROM TB_GRADE A
    JOIN TB_CLASS B ON A.CLASS_NO=B.CLASS_NO
    WHERE SUBSTR(TERM_NO,1,4) IN (SELECT *
                                  FROM (SELECT SUBSTR(TERM_NO,1,4)
                                        FROM TB_GRADE
                                        GROUP BY SUBSTR(TERM_NO,1,4)
                                        ORDER BY 1 DESC) A
                                  WHERE ROWNUM <=3)
    GROUP BY B.CLASS_NO, B.CLASS_NAME
    ORDER BY 3 DESC)
WHERE 순위 <= 3;
--과목별 최근 3년의 누적 수강생수 3위까지

SELECT A.CLASS_NO "과목번호", B.CLASS_NAME "과목이름", COUNT(*) "누적수강생수(명)"
FROM TB_GRADE A
JOIN TB_CLASS B ON A.CLASS_NO=B.CLASS_NO
WHERE A.CLASS_NO IN (
    SELECT "과목번호"
    FROM (
    SELECT B.CLASS_NO "과목번호", B.CLASS_NAME "과목이름",
           COUNT(*) "누적수강생수(명)", DENSE_RANK() OVER(ORDER BY COUNT(A.STUDENT_NO) DESC) "순위"
    FROM TB_GRADE A
    JOIN TB_CLASS B ON A.CLASS_NO=B.CLASS_NO
    WHERE SUBSTR(TERM_NO,1,4) IN (SELECT *
                                  FROM (SELECT SUBSTR(TERM_NO,1,4)
                                        FROM TB_GRADE
                                        GROUP BY SUBSTR(TERM_NO,1,4)
                                        ORDER BY 1 DESC) A
                                  WHERE ROWNUM <=3)
    GROUP BY B.CLASS_NO, B.CLASS_NAME
    ORDER BY 3 DESC)
WHERE 순위 <= 3)
GROUP BY A.CLASS_NO, B.CLASS_NAME
ORDER BY 3 DESC;
--최근 3년동안 수강인원이 가장 많은 과목 3위까지의 전체 누적학생수

SELECT *
FROM (
    SELECT B.CLASS_NO "과목번호", B.CLASS_NAME "과목이름", COUNT(*) "누적수강생수(명)"
    FROM TB_GRADE A
    JOIN TB_CLASS B ON A.CLASS_NO=B.CLASS_NO
    WHERE SUBSTR(A.TERM_NO,1,4) BETWEEN '2005' AND '2009'
    GROUP BY B.CLASS_NO, B.CLASS_NAME
    ORDER BY 3 DESC)
WHERE ROWNUM <=3;
--문제 예시와 같은 결과가 나오기 위해서는 2005~2009까지의 누적 수강생 수를 구해야 한다.


--답----답----답----답----답----답----답----답----답----답----답----답--
SELECT A.*
FROM(
    SELECT A.CLASS_NO, B.CLASS_NAME, COUNT(A.STUDENT_NO), DENSE_RANK() OVER( ORDER BY COUNT(A.STUDENT_NO) DESC) RANKCNT
    FROM TB_GRADE A
    LEFT JOIN TB_CLASS B ON A.CLASS_NO = B.CLASS_NO
    WHERE SUBSTR(A.TERM_NO, 1, 4) IN (
        SELECT SUBSTR(V.TERM_NO, 1, 4)
        FROM(
            SELECT SUBSTR(A.TERM_NO, 1, 4) TERM_NO
            FROM TB_GRADE A
            GROUP BY SUBSTR(A.TERM_NO, 1, 4)
            ORDER BY 1 DESC ) V
        WHERE ROWNUM <= 3 )
    GROUP BY A.CLASS_NO, B.CLASS_NAME ) A
WHERE RANKCNT <= 3;
-----------------------------------------------------------------------------
--최근 3년동안 수강인원이 가장 많은 과목 3위까지 중  의 전체 누적학생수 3위까지
SELECT *
FROM(
    SELECT A.CLASS_NO, B.CLASS_NAME, COUNT(A.STUDENT_NO)
    FROM TB_GRADE A
    INNER JOIN (
        SELECT A.*
        FROM(
            SELECT A.CLASS_NO, B.CLASS_NAME, COUNT(A.STUDENT_NO), DENSE_RANK() OVER( ORDER BY COUNT(A.STUDENT_NO) DESC) RANKCNT
            FROM TB_GRADE A
            LEFT JOIN TB_CLASS B ON A.CLASS_NO = B.CLASS_NO
            WHERE SUBSTR(A.TERM_NO, 1, 4) IN (
                SELECT SUBSTR(V.TERM_NO, 1, 4)
                FROM(
                    SELECT SUBSTR(A.TERM_NO, 1, 4) TERM_NO
                    FROM TB_GRADE A
                    GROUP BY SUBSTR(A.TERM_NO, 1, 4)
                    ORDER BY 1 DESC ) V
                WHERE ROWNUM <= 3 )
        GROUP BY A.CLASS_NO, B.CLASS_NAME ) A
    WHERE RANKCNT <= 3 ) B ON A.CLASS_NO = B.CLASS_NO
GROUP BY A.CLASS_NO, B.CLASS_NAME
ORDER BY 3 DESC ) A
WHERE ROWNUM <= 3;