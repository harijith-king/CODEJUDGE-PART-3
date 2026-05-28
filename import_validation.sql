
-- row count of each table
SELECT 'students' as table_name, COUNT(*) as row_count FROM students
UNION ALL
SELECT 'batches', COUNT(*) FROM batches
UNION ALL
SELECT 'courses', COUNT(*) FROM courses
UNION ALL
SELECT 'enrollments', COUNT(*) FROM enrollments
UNION ALL
SELECT 'problems', COUNT(*) FROM problems
UNION ALL
SELECT 'contests', COUNT(*) FROM contests
UNION ALL
SELECT 'contest_problems', COUNT(*) FROM contest_problems
UNION ALL
SELECT 'submissions', COUNT(*) FROM submissions
UNION ALL
SELECT 'test_cases', COUNT(*) FROM test_cases
UNION ALL
SELECT 'test_results', COUNT(*) FROM test_results
UNION ALL
SELECT 'sessions', COUNT(*) FROM sessions
UNION ALL
SELECT 'attendance', COUNT(*) FROM attendance
UNION ALL
SELECT 'regrade_requests', COUNT(*) FROM regrade_requests
UNION ALL
SELECT 'plagiarism_flags', COUNT(*) FROM plagiarism_flags
UNION ALL
SELECT 'operation_requests', COUNT(*) FROM operation_requests
UNION ALL
SELECT 'raw_student_import', COUNT(*) FROM raw_student_import;

-- check NULL in important columns in students
SELECT 'students - null student_id', COUNT(*) FROM students WHERE student_id IS NULL
UNION ALL
SELECT 'students - null full_name', COUNT(*) FROM students WHERE full_name IS NULL
UNION ALL
SELECT 'students - null email', COUNT(*) FROM students WHERE email IS NULL
UNION ALL
SELECT 'students - null batch_id', COUNT(*) FROM students WHERE batch_id IS NULL;

-- check NULL in submissions
SELECT 'submissions - null submission_id', COUNT(*) FROM submissions WHERE submission_id IS NULL
UNION ALL
SELECT 'submissions - null student_id', COUNT(*) FROM submissions WHERE student_id IS NULL
UNION ALL
SELECT 'submissions - null problem_id', COUNT(*) FROM submissions WHERE problem_id IS NULL
UNION ALL
SELECT 'submissions - null submitted_at', COUNT(*) FROM submissions WHERE submitted_at IS NULL;

-- check NULL in problems
SELECT 'problems - null problem_id', COUNT(*) FROM problems WHERE problem_id IS NULL
UNION ALL
SELECT 'problems - null course_id', COUNT(*) FROM problems WHERE course_id IS NULL
UNION ALL
SELECT 'problems - null title', COUNT(*) FROM problems WHERE title IS NULL;

-- check NULL in enrollments
SELECT 'enrollments - null student_id', COUNT(*) FROM enrollments WHERE student_id IS NULL
UNION ALL
SELECT 'enrollments - null course_id', COUNT(*) FROM enrollments WHERE course_id IS NULL
UNION ALL
SELECT 'enrollments - null enrolled_on', COUNT(*) FROM enrollments WHERE enrolled_on IS NULL;

-- check if any expected table is empty
SELECT 'batches is empty' as check_name, COUNT(*) as row_count FROM batches
UNION ALL
SELECT 'courses is empty', COUNT(*) FROM courses
UNION ALL
SELECT 'students is empty', COUNT(*) FROM students;