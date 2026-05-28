
-- check duplicate student_id
SELECT student_id, COUNT(*) as count
FROM students
GROUP BY student_id
HAVING COUNT(*) > 1;

-- check duplicate roll_number
SELECT roll_number, COUNT(*) as count
FROM students
GROUP BY roll_number
HAVING COUNT(*) > 1;

-- check duplicate email in students
SELECT email, COUNT(*) as count
FROM students
GROUP BY email
HAVING COUNT(*) > 1;

-- check duplicate enrollment records
SELECT student_id, course_id, COUNT(*) as count
FROM enrollments
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

-- check duplicate submission records
SELECT student_id, problem_id, submitted_at, COUNT(*) as count
FROM submissions
GROUP BY student_id, problem_id, submitted_at
HAVING COUNT(*) > 1;

-- check duplicate contest_problem records
SELECT contest_id, problem_id, COUNT(*) as count
FROM contest_problems
GROUP BY contest_id, problem_id
HAVING COUNT(*) > 1;

-- check duplicate attendance records
SELECT session_id, student_id, COUNT(*) as count
FROM attendance
GROUP BY session_id, student_id
HAVING COUNT(*) > 1;

-- check duplicate test result records
SELECT submission_id, test_case_id, COUNT(*) as count
FROM test_results
GROUP BY submission_id, test_case_id
HAVING COUNT(*) > 1;

-- check orphan submissions (student_id not in students)
SELECT submission_id, student_id
FROM submissions
WHERE student_id NOT IN (SELECT student_id FROM students);

-- check orphan submissions (problem_id not in problems)
SELECT submission_id, problem_id
FROM submissions
WHERE problem_id NOT IN (SELECT problem_id FROM problems);

-- check orphan enrollments (student_id not in students)
SELECT enrollment_id, student_id
FROM enrollments
WHERE student_id NOT IN (SELECT student_id FROM students);

-- check orphan enrollments (course_id not in courses)
SELECT enrollment_id, course_id
FROM enrollments
WHERE course_id NOT IN (SELECT course_id FROM courses);

-- check orphan test results (submission_id not in submissions)
SELECT result_id, submission_id
FROM test_results
WHERE submission_id NOT IN (SELECT submission_id FROM submissions);

-- check orphan attendance (student_id not in students)
SELECT attendance_id, student_id
FROM attendance
WHERE student_id NOT IN (SELECT student_id FROM students);

-- check orphan attendance (session_id not in sessions)
SELECT attendance_id, session_id
FROM attendance
WHERE session_id NOT IN (SELECT session_id FROM sessions);