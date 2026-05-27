# SQL 데이터베이스 설계 및 쿼리 실습 미션

## 1. 미션 개요

이번 미션은 백엔드 프레임워크 없이 SQL만 사용하여 직접 데이터베이스를 설계하고, 샘플 데이터를 입력한 뒤, 실제 요구사항을 SQL 쿼리로 해결하는 것을 목표로 한다.

데이터베이스가 엑셀과 다른 점은 단순히 데이터를 많이 저장하는 것이 아니라, 여러 테이블 사이의 관계를 PK와 FK로 연결하고 데이터의 무결성을 지킬 수 있다는 점이다.

본 프로젝트에서는 `[주제명 입력]` 도메인을 기준으로 최소 4개 이상의 테이블을 설계하고, 1:N 관계, 제약조건, JOIN, GROUP BY, 서브쿼리, UPDATE, DELETE, INDEX를 직접 작성하였다.

---

## 2. 개발 환경

| 항목 | 내용 |
|---|---|
| 사용 DB | `[ SQLite ]` |
| SQL 실행 도구 | `[ CLI ]` |
| 운영체제 | `[ macOS ]` |
| 제출 파일 형식 | `.sql`, `.md`, 이미지 또는 텍스트 결과 파일 |

---

## 3. 제출물 구성

```text
B5-1/
├── 01_schema.sql
├── 02_insert_data.sql
├── 03_queries.sql
├── README.md
├── results/
│   ├── q01.png
│   ├── q02.png
│   ├── q03.png
│   ├── ...
│   └── q15.png 
```

| 파일 / 폴더 | 설명 |
|---|---|
| `01_schema.sql` | 테이블 생성, PK, FK, 제약조건 정의 |
| `02_insert_data.sql` | 각 테이블별 샘플 데이터 INSERT |
| `03_queries.sql` | 핵심 SQL 쿼리 15개 작성 |
| `results/` | 각 쿼리 실행 결과 캡처 또는 텍스트 |

---

## 4. 도메인 소개

### 4.1 주제

`학급 성적 관리 시스템`

### 4.2 주제 선정 이유

학급 성적 관리 시스템은 학생, 교사, 과목, 성적 기록이 자연스럽게 나누어지는 주제이다.

학생 한 명은 여러 과목의 성적을 가질 수 있고, 과목 하나도 여러 학생의 성적 기록을 가질 수 있다. 또한 교사 한 명이 여러 과목을 담당할 수 있기 때문에 1:N 관계를 표현하기 좋다.

따라서 PK, FK, JOIN, GROUP BY, 집계 함수, 서브쿼리 등을 연습하기에 적합하다고 판단하였다.

---

## 5. 테이블 설계

### 5.1 전체 테이블 목록

| 테이블명 | 역할 |
|---|---|
| `student` | 학생 정보를 저장한다. |
| `teacher` | 교사 정보를 저장한다. |
| `subject` | 과목 정보를 저장하고 담당 교사와 연결한다. |
| `score` | 학생별 과목 점수 기록을 저장한다. |

### 5.2 테이블별 컬럼 설명

#### `student`

| 컬럼명 | 타입 | 제약조건 | 설명 |
|---|---|---|---|
| `student_id` | `INTEGER` | `PRIMARY KEY` | 학생을 구분하는 기본키 |
| `name` | `TEXT` | `NOT NULL`, `UNIQUE` | 학생 이름 |
| `grade` | `INTEGER` | `NOT NULL` | 학년 |

#### `teacher`

| 컬럼명 | 타입 | 제약조건 | 설명 |
|---|---|---|---|
| `teacher_id` | `INTEGER` | `PRIMARY KEY` | 교사를 구분하는 기본키 |
| `name` | `TEXT` | `NOT NULL`, `UNIQUE` | 교사 이름 |

#### `subject`

| 컬럼명 | 타입 | 제약조건 | 설명 |
|---|---|---|---|
| `subject_id` | `INTEGER` | `PRIMARY KEY` | 과목을 구분하는 기본키 |
| `teacher_id` | `INTEGER` | `NOT NULL`, `FOREIGN KEY` | 담당 교사 ID |
| `subject_name` | `TEXT` | `NOT NULL`, `UNIQUE` | 과목명 |

#### `score`

| 컬럼명 | 타입 | 제약조건 | 설명 |
|---|---|---|---|
| `score_id` | `INTEGER` | `PRIMARY KEY` | 성적 기록을 구분하는 기본키 |
| `student_id` | `INTEGER` | `NOT NULL`, `FOREIGN KEY` | 학생 ID |
| `subject_id` | `INTEGER` | `NOT NULL`, `FOREIGN KEY` | 과목 ID |
| `score` | `INTEGER` | `NOT NULL`, `CHECK` | 점수, 0점 이상 100점 이하 |
| `exam_date` | `TEXT` | `NOT NULL` | 시험 날짜 |

---

## 6. 테이블 관계 설명

| 부모 테이블 | 자식 테이블 | 관계 | 설명 |
|---|---|---|---|
| `teacher` | `subject` | `1:N` | 교사 1명은 여러 과목을 담당할 수 있다. |
| `student` | `score` | `1:N` | 학생 1명은 여러 성적 기록을 가질 수 있다. |
| `subject` | `score` | `1:N` | 과목 1개는 여러 학생의 성적 기록을 가질 수 있다. |

---

## 7. 제약조건 적용 내용

| 제약조건 | 적용 위치 | 적용 이유 |
|---|---|---|
| `PRIMARY KEY` | `student_id`, `teacher_id`, `subject_id`, `score_id` | 각 행을 고유하게 식별하기 위해 사용 |
| `FOREIGN KEY` | `subject.teacher_id` | 과목이 실제 존재하는 교사와 연결되도록 하기 위해 사용 |
| `FOREIGN KEY` | `score.student_id` | 성적 기록이 실제 존재하는 학생과 연결되도록 하기 위해 사용 |
| `FOREIGN KEY` | `score.subject_id` | 성적 기록이 실제 존재하는 과목과 연결되도록 하기 위해 사용 |
| `NOT NULL` | 각 테이블의 주요 컬럼 | 반드시 입력되어야 하는 값이기 때문에 사용 |
| `UNIQUE` | `student.name`, `teacher.name`, `subject.subject_name` | 중복을 막기 위해 사용 |
| `CHECK` | `score.score` | 점수가 0점 이상 100점 이하만 입력되도록 제한하기 위해 사용 |

---

## 8. 샘플 데이터 입력

각 테이블에는 최소 10행 이상의 샘플 데이터를 입력하였다.

| 테이블명 | 데이터 수 |
|---|---:|
| `student` | 10행 |
| `teacher` | 10행 |
| `subject` | 10행 |
| `score` | 20행 |

데이터 입력은 FK 관계를 고려하여 부모 테이블을 먼저 입력하고, 자식 테이블을 나중에 입력하였다.

입력 순서:

```text
1. student
2. teacher
3. subject
4. score
```

---

## 9. 핵심 SQL 쿼리 15개

아래 쿼리들은 `03_queries.sql` 파일에 작성하였다.

### 9.1 기본 조회 쿼리

| 번호 | 쿼리 설명 | 사용 문법 | 결과 파일 |
|---|---|---|---|
| Q01 | 전체 학생 조회 | `SELECT` | `results/q01.png` |
| Q02 | 2학년 학생 조회 | `WHERE` | `results/q02.png` |
| Q03 | 점수를 높은 순으로 조회 | `ORDER BY` | `results/q03.png` |
| Q04 | 상위 점수 5개 조회 | `ORDER BY`, `LIMIT` | `results/q04.png` |

### 9.2 JOIN 쿼리

| 번호 | 쿼리 설명 | 사용 문법 | 결과 파일 |
|---|---|---|---|
| Q05 | 과목과 담당 교사 조회 | `INNER JOIN` | `results/q05.png` |
| Q06 | 학생별 점수 조회 | `INNER JOIN` | `results/q06.png` |
| Q07 | 학생, 과목, 점수 함께 조회 | `INNER JOIN` | `results/q07.png` |
| Q08 | 모든 학생과 점수 조회 | `LEFT JOIN` | `results/q08.png` |

### 9.3 집계 쿼리

| 번호 | 쿼리 설명 | 사용 문법 | 결과 파일 |
|---|---|---|---|
| Q09 | 학생별 시험 응시 횟수 조회 | `COUNT`, `GROUP BY` | `results/q09.png` |
| Q10 | 과목별 평균 점수 조회 | `AVG`, `GROUP BY` | `results/q10.png` |
| Q11 | 학년별 총점 조회 | `SUM`, `GROUP BY` | `results/q11.png` |

### 9.4 서브쿼리

| 번호 | 쿼리 설명 | 사용 문법 | 결과 파일 |
|---|---|---|---|
| Q12 | 전체 평균보다 높은 점수 조회 | `SUBQUERY` | `results/q12.png` |

### 9.5 데이터 수정 및 삭제

| 번호 | 쿼리 설명 | 사용 문법 | 결과 파일 |
|---|---|---|---|
| Q13 | 학생 이름 수정 후 확인 | `UPDATE` | `results/q13.png` |
| Q14 | 테스트 학생 추가 후 삭제 | `DELETE` | `results/q14.png` |

### 9.6 인덱스

| 번호 | 쿼리 설명 | 사용 문법 | 결과 파일 |
|---|---|---|---|
| Q15 | 점수 컬럼에 인덱스 생성 후 확인 | `CREATE INDEX` | `results/q15.png` |

인덱스 적용 이유:

> 점수 기준 조회와 정렬을 수행할 수 있기 때문에 `score.score` 컬럼에 인덱스를 생성하였다.

---

## 10. 쿼리 실행 결과

각 쿼리 실행 결과는 `results/` 폴더에 저장하였다.

```text
results/
├── q01.png
├── q02.png
├── q03.png
├── q04.png
├── q05.png
├── q06.png
├── q07.png
├── q08.png
├── q09.png
├── q10.png
├── q11.png
├── q12.png
├── q13.png
├── q14.png
└── q15.png
```

---

## 11. 주요 쿼리 설명

가장 핵심적인 JOIN 쿼리는 Q07이다.

```sql
SELECT st.name, su.subject_name, sc.score
FROM score sc
INNER JOIN student st ON sc.student_id = st.student_id
INNER JOIN subject su ON sc.subject_id = su.subject_id;
```

이 쿼리는 `score` 테이블에 저장된 `student_id`, `subject_id`를 각각 `student`, `subject` 테이블과 연결하여 학생 이름, 과목명, 점수를 함께 조회한다.

---

## 12. 주요 개념 정리

### 12.1 PK와 FK

PK는 각 테이블의 행을 고유하게 식별하기 위해 사용한다.

FK는 다른 테이블의 PK를 참조하여 테이블 사이의 관계를 연결하기 위해 사용한다.

예를 들어 `score.student_id`는 `student.student_id`를 참조하기 때문에 존재하지 않는 학생 ID로 성적 데이터를 입력하는 것을 막을 수 있다.

### 12.2 INNER JOIN과 LEFT JOIN

`INNER JOIN`은 양쪽 테이블에 모두 연결되는 데이터만 조회한다.

`LEFT JOIN`은 왼쪽 테이블의 데이터는 모두 보여주고, 오른쪽 테이블에 연결되는 데이터가 없으면 NULL로 표시한다.

### 12.3 GROUP BY와 집계 함수

`GROUP BY`는 특정 컬럼을 기준으로 데이터를 묶고, `COUNT`, `SUM`, `AVG` 같은 집계 함수를 사용하여 통계 결과를 구할 때 사용한다.

| 함수 | 의미 | 사용 예시 |
|---|---|---|
| `COUNT` | 개수 계산 | 학생별 시험 응시 횟수 |
| `SUM` | 합계 계산 | 학년별 총점 |
| `AVG` | 평균 계산 | 과목별 평균 점수 |

---

## 13. FK 제약조건 확인

존재하지 않는 부모 데이터를 참조하는 INSERT를 시도하면 FK 제약조건에 의해 입력이 실패한다.

```sql
INSERT INTO score VALUES (999, 999, 1, 80, '2026-05-20');
```

위 쿼리는 `student_id = 999`인 학생이 `student` 테이블에 없기 때문에 실패한다.

```text
FOREIGN KEY constraint failed
```

이를 통해 잘못된 관계의 데이터 입력이 막히고, 데이터 무결성이 지켜지는 것을 확인할 수 있다.

---

## 14. 엑셀과 데이터베이스의 차이

엑셀은 하나의 표 안에 데이터를 직접 입력하고 관리하는 방식에 가깝다. 반면 데이터베이스는 데이터를 여러 테이블로 나누어 저장하고, PK와 FK를 통해 테이블 사이의 관계를 명확하게 표현할 수 있다.

예를 들어 학생 이름, 학년, 과목명, 교사명, 점수를 하나의 표에 모두 넣으면 같은 학생 정보나 교사 정보가 여러 번 반복된다. 하지만 데이터베이스에서는 `student`, `teacher`, `subject`, `score` 테이블로 분리하고 필요한 경우 JOIN으로 다시 연결할 수 있다.

---

## 15. 어려웠던 점과 해결 방법

### 어려웠던 점

처음에는 학생, 과목, 교사, 점수를 하나의 테이블에 모두 넣어도 된다고 생각할 수 있다. 하지만 그렇게 하면 같은 학생 정보, 교사 정보, 과목 정보가 여러 번 반복되어 데이터 중복이 발생한다.

### 해결 방법

학생 정보는 `student`, 교사 정보는 `teacher`, 과목 정보는 `subject`, 실제 점수 기록은 `score` 테이블로 나누었다.

그리고 `subject.teacher_id`, `score.student_id`, `score.subject_id`를 FK로 설정하여 테이블 사이의 관계를 표현하였다.

---

## 16. 평가항목 체크리스트

- [x] 최소 4개 이상의 테이블을 생성하였다.
- [x] 각 테이블에 PK를 정의하였다.
- [x] FK를 사용한 1:N 관계가 최소 2개 이상 존재한다.
- [x] 각 테이블에 최소 10행 이상의 샘플 데이터를 입력하였다.
- [x] 기본 조회 4개, 조인 4개, 집계 3개, 서브쿼리 1개, 수정/삭제 2개, 인덱스 1개를 포함하여 총 15개 이상의 쿼리를 작성하였다.
- [x] 각 쿼리의 실행 결과를 스크린샷 또는 텍스트로 첨부하였다.
- [x] DB와 엑셀의 차이, PK/FK, JOIN, GROUP BY, 인덱스의 역할을 설명할 수 있다.

---

## 17. 최종 정리

이번 미션을 통해 테이블을 나누는 이유, PK와 FK를 통한 관계 설정, JOIN을 통한 데이터 연결, GROUP BY를 통한 집계 방식, 그리고 인덱스의 필요성을 학습하였다.

이번 프로젝트에서는 학급 성적 관리 시스템을 기준으로 `student`, `teacher`, `subject`, `score` 테이블을 설계하였다. 이를 통해 학생, 교사, 과목, 성적 기록을 분리해서 관리하고, 필요한 경우 SQL JOIN으로 다시 연결하여 조회할 수 있음을 확인하였다.
