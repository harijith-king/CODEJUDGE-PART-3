## Priority 1: Critical Fixes (Constraint Violations)

    | Issue | Records | Fix | Action |
    |-------|---------|-----|--------|
    | Invalid enrollment status | E00042 | `ongoing` → `Enrolled` | Update |
    | Invalid difficulty | P0010 | `Very Hard` → `Hard` | Update |
    | Invalid attendance status | A000046 | `joined` → `Present` | Update |
    | Typo in student status | S0089 | `actve` → `Active` | Update |
    | Invalid submission status | SUB000208 | `OK` → `Accepted` | Update |

---

## Priority 2: Status Mapping Fixes

    **Contest Status (CT001, CT004, CT006, CT009, CT010)**
    - `published` → `Active`
    - `scheduled` → Upcoming (not in enum, needs design decision)
    - `done` → `Completed`

**Regrade Request Status (RG0001, RG0022, etc.)**

    - `open` → `Pending`
    - `closed` → `Rejected`
    - `done` → `Approved`

**Plagiarism Flag Status (PF0001, PF0008, etc.)**
    
    - `new` → `Pending`
    - `cleared` → Dismissed (not in enum, needs design decision)
    - `reviewing` → `Pending`

---

## Priority 3: Data Quality Issues

    | Issue | Records | Action |
    |-------|---------|--------|
    | Score > max_score | SUB000103 (score: 999, max: 75) | Move to staging → Manual review |
    | Negative score | SUB000056 (score: -10) | Move to staging → Manual review |
    | Similarity > 100 | PF0015 (similarity: 125.0%) | Move to staging → Manual review |
    | Swapped timestamps | CT005 (ends 11:00, starts 12:00) | Swap start/end times |

---

## Priority 4: Referential Integrity Issues (Orphan Records)

**Move to staging table for review:**

    - **Submissions:** SUB000013 (student S9999 missing), SUB000038 (problem P9999 missing)
    - **Enrollments:** E00718 (student S9999 missing), E00719 (course C999 missing)
    - **Attendance:** A000018 & others (student S9999 missing), A000032 (session SES9999 missing)

---

## Priority 5: Missing/Invalid Email Addresses

**Requires manual verification & correction:**

    - S0005 (Ayaan Gupta) — empty email
    - S0018 (Anika Patel) — no `@` symbol
    - S0077 (Nisha Chatterjee) — empty email

---

## Priority 6: Duplicate Records

**Remove:**
- S0001 enrolled in C006 twice (keep 1, delete 1)

---

## Summary

    | Priority | Category | Count | Status |
    |----------|----------|-------|--------|
    | 1 | Constraint violations | 5 | Quick UPDATE |
    | 2 | Status mappings | 9 | UPDATE with mapping |
    | 3 | Out-of-range values | 4 | MOVE to staging |
    | 4 | Orphan records | 6+ | MOVE to staging |
    | 5 | Missing data | 3 | Manual review |
    | 6 | Duplicates | 1 | DELETE |

**Total: ~28 records need attention**

---

## Execution Order

    1. **Update** constraints violations (5 records)
    2. **Update** status mappings (9 records) — confirm enum values first
    3. **Swap** contest timestamps (CT005)
    4. **Move** orphans + out-of-range to staging (10+ records)
    5. **Verify** emails manually, update as needed
    6. **Remove** duplicates
    7. **Validate** all foreign keys after cleanup
