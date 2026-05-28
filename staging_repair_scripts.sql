-- staging repair scripts

-- create staging tables
CREATE TABLE students_staging AS SELECT * FROM students;
CREATE TABLE submissions_staging AS SELECT * FROM submissions;
CREATE TABLE contests_staging AS SELECT * FROM contests;
CREATE TABLE attendance_staging AS SELECT * FROM attendance;
CREATE TABLE regrade_requests_staging AS SELECT * FROM regrade_requests;
CREATE TABLE plagiarism_flags_staging AS SELECT * FROM plagiarism_flags;
CREATE TABLE enrollments_staging AS SELECT * FROM enrollments;
CREATE TABLE problems_staging AS SELECT * FROM problems;

-- Issue 1 - fix typo in student status
-- before
SELECT student_id, full_name, enrollment_status
FROM students_staging
WHERE enrollment_status = 'actve';

-- fix
UPDATE students_staging
SET enrollment_status = 'active'
WHERE enrollment_status = 'actve';

-- after
SELECT student_id, full_name, enrollment_status
FROM students_staging
WHERE student_id = 'S0089';

-- Issue 2 - fix invalid problem difficulty
-- before
SELECT problem_id, title, difficulty
FROM problems_staging
WHERE difficulty = 'Very Hard';

-- fix
UPDATE problems_staging
SET difficulty = 'Hard'
WHERE difficulty = 'Very Hard';

-- after
SELECT problem_id, title, difficulty
FROM problems_staging
WHERE problem_id = 'P0010';

-- Issue 3 - fix invalid contest status
-- before
SELECT contest_id, contest_title, contest_status
FROM contests_staging
WHERE contest_status IN ('published', 'scheduled', 'done');

-- fix
UPDATE contests_staging
SET contest_status = 'active'
WHERE contest_status = 'published';

UPDATE contests_staging
SET contest_status = 'upcoming'
WHERE contest_status = 'scheduled';

UPDATE contests_staging
SET contest_status = 'completed'
WHERE contest_status = 'done';

-- after
SELECT contest_id, contest_title, contest_status
FROM contests_staging
WHERE contest_id IN ('CT001','CT004','CT006','CT008','CT009','CT010');

-- Issue 4 - fix wrong submission status
-- before
SELECT submission_id, status
FROM submissions_staging
WHERE status = 'OK';

-- fix
UPDATE submissions_staging
SET status = 'Accepted'
WHERE status = 'OK';

-- after
SELECT submission_id, status
FROM submissions_staging
WHERE submission_id = 'SUB000208';

-- Issue 5 - score greater than max score
-- before
SELECT s.submission_id, s.score, p.max_score
FROM submissions_staging s
JOIN problems p ON s.problem_id = p.problem_id
WHERE s.score > p.max_score;

-- move to separate table for review
CREATE TABLE suspicious_submissions AS
SELECT s.*
FROM submissions_staging s
JOIN problems p ON s.problem_id = p.problem_id
WHERE s.score > p.max_score;

-- Issue 6 - fix negative score
-- before
SELECT submission_id, student_id, score
FROM submissions_staging
WHERE score < 0;

-- fix
UPDATE submissions_staging
SET score = 0
WHERE score < 0;

-- after
SELECT submission_id, student_id, score
FROM submissions_staging
WHERE submission_id = 'SUB000056';

-- Issue 7 - fix contest end time before start time
-- before
SELECT contest_id, start_time, end_time
FROM contests_staging
WHERE end_time < start_time;

-- fix by swapping times
UPDATE contests_staging
SET start_time = end_time,
end_time = start_time
WHERE contest_id = 'CT005';

-- after
SELECT contest_id, start_time, end_time
FROM contests_staging
WHERE contest_id = 'CT005';

-- Issue 8 - fix wrong attendance status
-- before
SELECT attendance_id, attendance_status
FROM attendance_staging
WHERE attendance_status = 'joined';

-- fix
UPDATE attendance_staging
SET attendance_status = 'Present'
WHERE attendance_status = 'joined';

-- after
SELECT attendance_id, attendance_status
FROM attendance_staging
WHERE attendance_id = 'A000046';

-- Issue 9 - fix wrong regrade request status
-- before
SELECT request_id, request_status
FROM regrade_requests_staging
WHERE request_status IN ('open', 'closed', 'done');

-- fix
UPDATE regrade_requests_staging
SET request_status = 'pending'
WHERE request_status = 'open';

UPDATE regrade_requests_staging
SET request_status = 'rejected'
WHERE request_status = 'closed';

UPDATE regrade_requests_staging
SET request_status = 'approved'
WHERE request_status = 'done';

-- after
SELECT request_id, request_status
FROM regrade_requests_staging
WHERE request_id IN ('RG0001','RG0003','RG0023')
LIMIT 5;

-- Issue 10 - fix wrong plagiarism flag status
-- before
SELECT flag_id, flag_status
FROM plagiarism_flags_staging
WHERE flag_status IN ('new', 'cleared', 'reviewing');

-- fix
UPDATE plagiarism_flags_staging
SET flag_status = 'pending'
WHERE flag_status = 'new';

UPDATE plagiarism_flags_staging
SET flag_status = 'dismissed'
WHERE flag_status = 'cleared';

UPDATE plagiarism_flags_staging
SET flag_status = 'pending'
WHERE flag_status = 'reviewing';

-- after
SELECT flag_id, flag_status
FROM plagiarism_flags_staging
WHERE flag_id IN ('PF0001','PF0003','PF0005')
LIMIT 5;

-- Issue 11 - similarity score out of range
-- before
SELECT flag_id, similarity_score
FROM plagiarism_flags_staging
WHERE similarity_score > 1;

-- move to review table
CREATE TABLE suspicious_flags AS
SELECT * FROM plagiarism_flags_staging
WHERE similarity_score > 1;

-- Issue 12 - fix wrong enrollment status
-- before
SELECT enrollment_id, enrollment_status
FROM enrollments_staging
WHERE enrollment_status = 'ongoing';

-- fix
UPDATE enrollments_staging
SET enrollment_status = 'active'
WHERE enrollment_status = 'ongoing';

-- after
SELECT enrollment_id, enrollment_status
FROM enrollments_staging
WHERE enrollment_id = 'E00042';

-- Issue 13 - flag missing emails for manual review
-- before
SELECT student_id, full_name, email
FROM students_staging
WHERE email IS NULL OR email NOT LIKE '%@%.%';

-- move to review table
CREATE TABLE students_bad_email AS
SELECT * FROM students_staging
WHERE email IS NULL OR email NOT LIKE '%@%.%';

-- Issue 14 - fix duplicate enrollment
-- before
SELECT student_id, course_id, COUNT(*) as count
FROM enrollments_staging
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

-- fix by keeping only one record
DELETE FROM enrollments_staging
WHERE rowid NOT IN (
    SELECT MIN(rowid)
    FROM enrollments_staging
    GROUP BY student_id, course_id
);

-- after
SELECT student_id, course_id, COUNT(*) as count
FROM enrollments_staging
WHERE student_id = 'S0001' AND course_id = 'C006'
GROUP BY student_id, course_id;

-- Issue 15 - move orphan records to review table

-- orphan submissions
CREATE TABLE orphan_records AS
SELECT 'submission' as record_type, submission_id as record_id, student_id as bad_reference
FROM submissions_staging
WHERE student_id NOT IN (SELECT student_id FROM students);

-- orphan enrollments
INSERT INTO orphan_records
SELECT 'enrollment', enrollment_id, student_id
FROM enrollments_staging
WHERE student_id NOT IN (SELECT student_id FROM students);

-- orphan attendance
INSERT INTO orphan_records
SELECT 'attendance', attendance_id, student_id
FROM attendance_staging
WHERE student_id NOT IN (SELECT student_id FROM students);