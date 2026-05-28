Before and After Evidence

Issue 1 involved a typo in the student enrollment status.
Before correction, student S0089 (Kunal Gupta) had the value `actve`. After cleaning, the value was updated to `active`. This confirmed that the typo was fixed successfully.

Issue 2 involved an invalid difficulty level in the problems table.
Before correction, problem P0010 (Knapsack 10) had the difficulty value `Very Hard`. Since this was not part of the allowed categories, it was updated to `Hard`. The record now contains a valid difficulty value.

Issue 3 involved inconsistent contest status values.
Before cleaning:

* CT001 → published
* CT004 → published
* CT006 → published
* CT008 → scheduled
* CT009 → published
* CT010 → done

After correction:

* CT001 → active
* CT004 → active
* CT006 → active
* CT008 → upcoming
* CT009 → active
* CT010 → completed

All contest statuses were successfully mapped to standardized values.

Issue 4 involved an invalid submission status.
Submission SUB000208 originally contained the value `OK`. Since this likely represented a successful submission, it was changed to `Accepted`.

Issue 5 involved a score greater than the maximum allowed score.
Submission SUB000103 had a score of `999` even though the related problem P0040 has a maximum score of `75`. Since the correct score could not be safely determined, the record was moved to a `suspicious_submissions` table for manual review instead of being modified directly.

Issue 6 involved a negative submission score.
Before correction, submission SUB000056 for student S0148 had a score of `-10`. Since negative scores are invalid, the value was temporarily updated to `0` until further verification.

Issue 7 involved invalid contest timing data.
Contest CT005 originally had:

* start time → 2025-04-05 12:00:00
* end time → 2025-04-05 11:00:00

After correction:

* start time → 2025-04-05 11:00:00
* end time → 2025-04-05 12:00:00

The start and end times were swapped successfully.

Issue 8 involved an invalid attendance status.
Attendance record A000046 originally contained the value `joined`. Since this likely meant the student attended the session, the value was updated to `Present`.

Issue 9 involved inconsistent regrade request statuses.
Before correction:

* RG0001 → open
* RG0003 → closed
* RG0023 → done

After correction:

* RG0001 → pending
* RG0003 → rejected
* RG0023 → approved

All regrade request statuses were normalized successfully.

Issue 10 involved inconsistent plagiarism flag statuses.
Before correction:

* PF0001 → new
* PF0003 → cleared
* PF0005 → reviewing

After correction:

* PF0001 → pending
* PF0003 → dismissed
* PF0005 → pending

The statuses were standardized to valid values.

Issue 11 involved an invalid similarity score.
Plagiarism record PF0015 had a similarity score of `125.0`, which is outside the valid range. Since the correct value could not be identified confidently, the record was moved to a `suspicious_flags` table for manual verification.

Issue 12 involved an invalid enrollment status.
Enrollment record E00042 originally contained the value `ongoing`. Since the meaning indicated that the enrollment was currently active, the value was updated to `active`.

Issue 13 involved missing or invalid student emails.
Examples included:

* S0005 (Ayaan Gupta) → empty email
* S0018 (Anika Patel) → invalid email format
* S0077 (Nisha Chatterjee) → empty email

Since the correct email addresses could not be guessed safely, these records were moved to a `students_bad_email` table for manual review.

Issue 14 involved duplicate enrollment records.
Student S0001 was found to be enrolled in course C006 twice. After removing the duplicate row, the enrollment count was reduced from 2 to 1.

Issue 15 involved orphan records that violated referential integrity.
Examples included:

* SUB000013 referencing missing student S9999
* SUB000038 referencing missing problem P9999
* E00718 referencing missing student S9999
* E00719 referencing missing course C999
* A000032 referencing invalid session SES9999

These records were not deleted directly. Instead, they were moved to an `orphan_records` table for further review and verification.
