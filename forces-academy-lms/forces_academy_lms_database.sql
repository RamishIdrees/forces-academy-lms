-- ============================================================
--  FORCES ACADEMY LMS  —  Full Database (Week 1 + 2 + 3)
-- ============================================================
--  HOW TO IMPORT:
--    1. Open phpMyAdmin  ->  http://localhost/phpmyadmin
--    2. Click the "Import" tab at the top
--    3. Choose this file (forces_academy_lms_database.sql) and press "Go"
--       -- OR -- paste the whole file into the "SQL" tab and run it.
-- ============================================================

CREATE DATABASE IF NOT EXISTS forces_academy_lms;
USE forces_academy_lms;

-- ------------------------------------------------------------
--  WEEK 1  —  core tables
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS students (
    id           INT(11) PRIMARY KEY AUTO_INCREMENT,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(100) UNIQUE NOT NULL,
    password     VARCHAR(255) NOT NULL,
    roll_number  VARCHAR(20)  UNIQUE NOT NULL,
    class        VARCHAR(50)  NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS admins (
    id        INT(11) PRIMARY KEY AUTO_INCREMENT,
    username  VARCHAR(50) UNIQUE NOT NULL,
    password  VARCHAR(255) NOT NULL,
    email     VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS courses (
    id            INT(11) PRIMARY KEY AUTO_INCREMENT,
    course_name   VARCHAR(100) NOT NULL,
    description   TEXT,
    teacher_name  VARCHAR(100),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS notices (
    id          INT(11) PRIMARY KEY AUTO_INCREMENT,
    title       VARCHAR(200) NOT NULL,
    content     TEXT,
    posted_by   VARCHAR(100),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS course_materials (
    id             INT(11) PRIMARY KEY AUTO_INCREMENT,
    course_id      INT(11) NOT NULL,
    material_title VARCHAR(150) NOT NULL,
    material_type  VARCHAR(50) NOT NULL DEFAULT 'Notes',
    description    TEXT,
    resource_link  VARCHAR(255),
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_course_materials_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- ------------------------------------------------------------
--  WEEK 3  —  assignments, submissions, results
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS assignments (
    id          INT(11) PRIMARY KEY AUTO_INCREMENT,
    title       VARCHAR(200) NOT NULL,
    description TEXT,
    course_id   INT(11),
    due_date    DATE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_assignments_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS submissions (
    id            INT(11) PRIMARY KEY AUTO_INCREMENT,
    assignment_id INT(11),
    student_id    INT(11),
    file_path     VARCHAR(255),
    submitted_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status        ENUM('submitted','graded') DEFAULT 'submitted',
    CONSTRAINT fk_sub_assignment FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE,
    CONSTRAINT fk_sub_student    FOREIGN KEY (student_id)    REFERENCES students(id)    ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS results (
    id           INT(11) PRIMARY KEY AUTO_INCREMENT,
    student_id   INT(11),
    course_id    INT(11),
    subject      VARCHAR(100),
    marks        INT(11),
    total_marks  INT(11),
    grade        VARCHAR(10),
    exam_type    VARCHAR(50),
    CONSTRAINT fk_results_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- ============================================================
--  SAMPLE DATA
-- ============================================================

-- Admin account
--   Username: admin
--   Password: admin123
INSERT INTO admins (username, password, email) VALUES
('admin', '$2b$10$49UV05NJGa1VOZrvdNz5ueEVlkda9zryy4b73NNP/VnwZbHEd7fI2', 'admin@forcesacademy.edu.pk')
ON DUPLICATE KEY UPDATE password = VALUES(password), email = VALUES(email);

-- Demo student
--   Email:    ramish.idrees@student.forces.edu.pk
--   Password: 12345
INSERT INTO students (full_name, email, password, roll_number, class) VALUES
('Ramish Idrees', 'ramish.idrees@student.forces.edu.pk', '$2b$10$HXqwM8RqBAECy8c50YpMCuQ3YGolHUm.qD5y2Nmy5.JTzs4yYfd9W', 'FA22-BSSE-045', 'BS Software Engineering - 6th');

-- Courses (new set with distinct instructors)
INSERT INTO courses (course_name, description, teacher_name) VALUES
('Programming Fundamentals', 'Variables, loops, functions and problem solving using the C language.', 'Sir Zohaib Nasir'),
('Linear Algebra', 'Vectors, matrices, determinants and linear transformations for computing.', 'Dr. Saima Riaz'),
('Digital Image Processing', 'Image filtering, enhancement, segmentation and edge detection basics.', 'Sir Kashif Mehmood'),
('Human Computer Interaction', 'Usability principles, interface design and user-centered evaluation.', 'Ms. Iqra Waqar'),
('Information Security', 'Confidentiality, cryptography, access control and secure system design.', 'Dr. Owais Bhatti'),
('Mobile App Development', 'Building cross-platform mobile apps with modern UI frameworks.', 'Ms. Fatima Zubair');

-- Notices
INSERT INTO notices (title, content, posted_by) VALUES
('Final Year Project Titles Due', 'Submit your proposed FYP titles to your supervisor by 29 July. Late proposals will not be entertained.', 'FYP Committee'),
('Assignment Upload Portal Live', 'Assignments can now be submitted online from the Assignments page. Only PDF and image files are accepted.', 'Academic Office'),
('Hackathon 2026 Registration', 'Team registrations for the annual 24-hour hackathon are open until Friday. Form teams of up to four.', 'Computing Society'),
('Scholarship Applications Open', 'Merit and need-based scholarship applications for the new term are now open in the student portal.', 'Financial Aid Office');

-- Course materials
INSERT INTO course_materials (course_id, material_title, material_type, description, resource_link) VALUES
(1, 'Getting Started with C', 'PDF', 'Setting up a compiler and writing your first programs.', '#'),
(2, 'Matrix Operations Slides', 'PPT', 'Addition, multiplication and inverse of matrices.', '#'),
(3, 'Image Filters Explained', 'PDF', 'Mean, median and Gaussian filters with examples.', '#'),
(4, 'Usability Heuristics Handout', 'Notes', 'Nielsen\'s ten usability heuristics summarised.', '#'),
(5, 'Symmetric vs Asymmetric Encryption', 'PDF', 'Comparison with simple diagrams and use cases.', '#');

-- Assignments (Week 3) — tied to courses above
INSERT INTO assignments (title, description, course_id, due_date) VALUES
('C Programming Exercises', 'Solve the given ten C programming problems and upload your source code report as a PDF.', 1, '2026-07-25'),
('Matrix Operations Worksheet', 'Solve the matrix problems by hand and upload a scanned image of your work.', 2, '2026-07-28'),
('Apply Three Image Filters', 'Apply mean, median and Gaussian filters to the sample image and submit a PDF of your results.', 3, '2026-07-31'),
('Design a Mobile App Wireframe', 'Create a wireframe for a simple to-do app and submit it as an image.', 6, '2026-08-04');

-- Results (Week 3) — for the demo student (student_id = 1)
INSERT INTO results (student_id, course_id, subject, marks, total_marks, grade, exam_type) VALUES
(1, 1, 'Programming Fundamentals',   46, 50, 'A+', 'Midterm'),
(1, 2, 'Linear Algebra',             39, 50, 'B+', 'Midterm'),
(1, 3, 'Digital Image Processing',   43, 50, 'A',  'Midterm'),
(1, 4, 'Human Computer Interaction', 41, 50, 'A',  'Quiz'),
(1, 5, 'Information Security',        36, 50, 'B',  'Quiz');
