-- 01_schema.sql
-- SQLite 기준, 학급 성적 관리 DB

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS score;
DROP TABLE IF EXISTS subject;
DROP TABLE IF EXISTS teacher;
DROP TABLE IF EXISTS student;

CREATE TABLE student (
    student_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    grade INTEGER NOT NULL
);

CREATE TABLE teacher (
    teacher_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE subject (
    subject_id INTEGER PRIMARY KEY,
    teacher_id INTEGER NOT NULL,
    subject_name TEXT NOT NULL UNIQUE,
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

CREATE TABLE score (
    score_id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    score INTEGER NOT NULL CHECK (score BETWEEN 0 AND 100),
    exam_date TEXT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id)
);
