-- 03_queries.sql
-- 핵심 쿼리 15개

PRAGMA foreign_keys = ON;

-- SERCH
-- Q01. 전체 학생 조회
SELECT * FROM student;

-- Q02. 2학년 학생 조회
SELECT * FROM student
WHERE grade = 2;

-- Q03. 점수를 높은 순으로 조회
SELECT * FROM score
ORDER BY score DESC;

-- Q04. 상위 점수 5개 조회
SELECT * FROM score
ORDER BY score DESC
LIMIT 5;


-- JOIN
-- Q05. 과목과 담당 교사 조회 INNER JOIN
SELECT su.subject_name, t.name AS teacher_name
FROM subject su
INNER JOIN teacher t ON su.teacher_id = t.teacher_id;

-- Q06. 학생별 점수 조회 INNER JOIN
SELECT st.name, sc.score
FROM score sc
INNER JOIN student st ON sc.student_id = st.student_id;

-- Q07. 학생, 과목, 점수 조회 JOIN
SELECT st.name, su.subject_name, sc.score
FROM score sc
INNER JOIN student st ON sc.student_id = st.student_id
INNER JOIN subject su ON sc.subject_id = su.subject_id;

-- Q08. 모든 학생과 점수 조회 LEFT JOIN
SELECT st.name, sc.score
FROM student st
LEFT JOIN score sc ON st.student_id = sc.student_id;




-- Q09. 학생별 시험 응시 횟수 COUNT
SELECT st.name, COUNT(sc.score_id) AS test_count
FROM student st
LEFT JOIN score sc ON st.student_id = sc.student_id
GROUP BY st.student_id, st.name;

-- Q10. 과목별 평균 점수 AVG
SELECT su.subject_name, AVG(sc.score) AS avg_score
FROM subject su
INNER JOIN score sc ON su.subject_id = sc.subject_id
GROUP BY su.subject_id, su.subject_name;

-- Q11. 학년별 총점 SUM
SELECT st.grade, SUM(sc.score) AS total_score
FROM student st
INNER JOIN score sc ON st.student_id = sc.student_id
GROUP BY st.grade;



-- Q12. 전체 평균보다 높은 점수 조회 서브쿼리
SELECT *
FROM score
WHERE score > (SELECT AVG(score) FROM score);



-- Q13. 학생 이름 수정 UPDATE
UPDATE student
SET name = '김민준수정'
WHERE student_id = 1;

SELECT * FROM student
WHERE student_id = 1;

-- Q14. 테스트 학생 추가 후 삭제 DELETE
INSERT INTO student VALUES (99, '삭제테스트', 1);

DELETE FROM student
WHERE student_id = 99;

SELECT * FROM student
WHERE student_id = 99;




-- Q15. 점수 검색용 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_score_score
ON score(score);

SELECT name, tbl_name
FROM sqlite_master
WHERE type = 'index'
AND name = 'idx_score_score';
