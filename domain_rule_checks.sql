-- domain rule checks

-- check invalid enrollment_status in students
SELECT student_id, full_name, enrollment_status
FROM students
WHERE LOWER(enrollment_status) NOT IN ('active', 'inactive', 'dropped', 'graduated');

-- check typo in enrollment_status
SELECT student_id, full_name, enrollment_status
FROM students
WHERE enrollment_status = 'actve';

-- check invalid difficulty in problems
SELECT problem_id, title, difficulty
FROM problems
WHERE difficulty NOT IN ('Easy', 'Medium', 'Hard');

-- check invalid batch_status
SELECT batch_id, batch_code, batch_status
FROM batches
WHERE LOWER(batch_status) NOT IN ('active', 'inactive', 'completed', 'upcoming');

-- check invalid contest_status
SELECT contest_id, contest_title, contest_status
FROM contests
WHERE LOWER(contest_status) NOT IN ('active', 'inactive', 'completed', 'upcoming');

-- check invalid submission status
SELECT submission_id, status
FROM submissions
WHERE status NOT IN ('Accepted', 'Wrong Answer', 'Runtime Error', 'Time Limit Exceeded', 'Compilation Error');

-- check scores greater than max allowed
SELECT s.submission_id, s.problem_id, s.score, p.max_score
FROM submissions s
JOIN problems p ON s.problem_id = p.problem_id
WHERE s.score > p.max_score;

-- check negative scores
SELECT submission_id, student_id, score
FROM submissions
WHERE score < 0;

-- check end time before start time in contests
SELECT contest_id, contest_title, start_time, end_time
FROM contests
WHERE end_time < start_time;

-- check invalid attendance status
SELECT attendance_id, attendance_status
FROM attendance
WHERE LOWER(attendance_status) NOT IN ('present', 'absent', 'late');

-- check invalid request_status in regrade_requests
SELECT request_id, request_status
FROM regrade_requests
WHERE LOWER(request_status) NOT IN ('pending', 'approved', 'rejected');

-- check invalid approval_status in operation_requests
SELECT operation_id, approval_status
FROM operation_requests
WHERE LOWER(approval_status) NOT IN ('pending', 'approved', 'rejected');

-- check invalid flag_status in plagiarism_flags
SELECT flag_id, flag_status
FROM plagiarism_flags
WHERE LOWER(flag_status) NOT IN ('pending', 'confirmed', 'dismissed');

-- check similarity score out of range
SELECT flag_id, similarity_score
FROM plagiarism_flags
WHERE similarity_score < 0 OR similarity_score > 1;

-- check invalid enrollment_status in enrollments
SELECT enrollment_id, enrollment_status
FROM enrollments
WHERE LOWER(enrollment_status) NOT IN ('active', 'inactive', 'dropped', 'completed');

-- check missing email
SELECT student_id, full_name, email
FROM students
WHERE email IS NULL OR email = '';

-- check invalid email format
SELECT student_id, full_name, email
FROM students
WHERE email NOT LIKE '%@%.%';

-- check NULL batch_id in students
SELECT student_id, full_name, batch_id
FROM students
WHERE batch_id IS NULL;

-- check max_score is valid in problems
SELECT problem_id, title, max_score
FROM problems
WHERE max_score <= 0 OR max_score IS NULL;