CREATE DATABASE RFR_System;
USE RFR_System;

CREATE TABLE Reporter (
    reporter_id INT PRIMARY KEY,
    submitted_at DATE,
    is_anonymous BOOLEAN
);

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);

CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    name VARCHAR(100) UNIQUE,
    description TEXT
);

CREATE TABLE Report (
    report_id INT PRIMARY KEY,
    category_id INT,
    description TEXT,
    status VARCHAR(50),
    submitted_on DATE,
    reporter_id INT,
    dept_id INT,
    FOREIGN KEY (reporter_id) REFERENCES Reporter(reporter_id),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Reviewer (
    reviewer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Reviewer_Action (
    action_id INT PRIMARY KEY,
    report_id INT,
    reviewer_id INT,
    action_taken TEXT,
    action_date DATE,
    remarks TEXT,
    FOREIGN KEY (report_id) REFERENCES Report(report_id),
    FOREIGN KEY (reviewer_id) REFERENCES Reviewer(reviewer_id)
);

CREATE TABLE User_Feedback (
    feedback_id INT PRIMARY KEY,
    report_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    submitted_at DATE,
    FOREIGN KEY (report_id) REFERENCES Report(report_id)
);

INSERT INTO Reporter 
(reporter_id, submitted_at, is_anonymous) 	VALUES
(101, '2025-06-01', TRUE),
(102, '2025-06-02', TRUE),
(103, '2025-06-03', TRUE),
(104, '2025-06-04', TRUE),
(105, '2025-06-05', TRUE);


INSERT INTO Department
(dept_id, name) VALUES
(201, 'Information Technology'),
(202, 'Finance'),
(203, 'Business'),
(204, 'Marketing'),
(205, 'Psychological Department');

INSERT INTO Category 
(category_id, name, description) VALUES
(301, 'Harassment', 'Unwanted behavior.'),
(302, 'Safety Violation', 'Risk to safety.'),
(303, 'Workplace Bullying', 'Intimidating behavior.'),
(304, 'Unsafe Work Conditions', 'Hazards that risk employee safety.'),
(305, 'Dangerous Place', 'A place or situation felt unsafe.');

INSERT INTO Report 
(report_id, category_id, description, status, submitted_on, reporter_id, dept_id) VALUES
(401, 301, 'A colleague made repeated unwanted jokes.', 'Pending', '2025-06-01', 101, 201),
(402, 302, 'Emergency exit was blocked during work hours.', 'In Review', '2025-06-02', 102, 202),
(403, 303, 'Manager shouted at team in front of others.', 'Resolved', '2025-06-03', 103, 203),
(404, 304, 'Wet floor in hallway with no warning sign.', 'Pending', '2025-06-04', 104, 204),
(405, 305, 'Construction debris left near entrance.', 'In Review', '2025-06-05', 105, 205);

INSERT INTO Reviewer 
(reviewer_id, name, email, dept_id) VALUES
(501, 'Shehaan Khurram', 'shehaank@example.com', 201),
(502, 'Rumaisa Liaqat', 'rumaisa@example.com', 202),
(503, 'Mr Frenzy', 'mr.frenzy@example.com', 203),
(504, 'Taekook', 'taekook.bts@example.com', 204),
(505, 'Hammer', 'hammer.op@example.com', 205);

INSERT INTO Reviewer_Action 
(action_id, report_id, reviewer_id, action_taken, action_date, remarks) VALUES
(601, 401, 501, 'Investigation Started', '2025-06-06', 'Initial review completed.'),
(602, 402, 502, 'Requested More Info', '2025-06-06', 'Asked reporter for more details.'),
(603, 403, 503, 'Action Taken', '2025-06-07', 'Manager was warned formally.'),
(604, 404, 504, 'Issue Resolved', '2025-06-08', 'Safety team cleaned the area.'),
(605, 405, 505, 'Forwarded to HR', '2025-06-09', 'Sent to HR for further action.');

INSERT INTO User_Feedback 
(feedback_id, report_id, rating, comments, submitted_at) VALUES
(701, 401, 4, 'The process was quick and helpful.', '2025-06-10'),
(702, 402, 3, 'Still waiting for resolution.', '2025-06-11'),
(703, 403, 5, 'Very satisfied with the action taken.', '2025-06-12'),
(704, 404, 2, 'Issue was fixed, but it took time.', '2025-06-13'),
(705, 405, 4, 'Good follow-up by the team.', '2025-06-14');


-- ******************** Joins ********************

-- ______ INNER JOIN (Report and Category) ______
SELECT r.report_id, c.name AS category_name, r.description
FROM Report r
INNER JOIN Category c ON r.category_id = c.category_id;

-- ______ LEFT JOIN (Reviewer and Department) ______
SELECT rev.reviewer_id, rev.name, dept.name AS department_name
FROM Reviewer rev
LEFT JOIN Department dept ON rev.dept_id = dept.dept_id;

-- ______ RIGHT JOIN (Report and Reporter) ______
SELECT rep.report_id, rep.description, r.is_anonymous
FROM Report rep
RIGHT JOIN Reporter r ON rep.reporter_id = r.reporter_id;

-- ______ FULL OUTER JOIN (Report and User_Feedback) ______
SELECT rep.report_id, rep.description, fb.rating
FROM Report rep
LEFT JOIN User_Feedback fb ON rep.report_id = fb.report_id
UNION
SELECT rep.report_id, rep.description, fb.rating
FROM Report rep
RIGHT JOIN User_Feedback fb ON rep.report_id = fb.report_id;

-- ______ SELF JOIN (Reviewers in same department) ______
SELECT r1.reviewer_id AS reviewer1_id, r1.name AS reviewer1_name,
       r2.reviewer_id AS reviewer2_id, r2.name AS reviewer2_name
FROM Reviewer r1
JOIN Reviewer r2 ON r1.dept_id = r2.dept_id AND r1.reviewer_id != r2.reviewer_id;


-- LIKE operator: Get categories related to 'Unsafe'
SELECT * FROM Category WHERE name LIKE '%Unsafe%';

-- IN operator: Get reports with specific statuses
SELECT * FROM Report WHERE status IN ('Pending', 'Resolved');

-- NOT IN operator: Get reports not handled by specific reviewers
SELECT * FROM Reviewer_Action WHERE reviewer_id NOT IN (504, 505);

-- BETWEEN: Get reports submitted between two dates
SELECT * FROM Report WHERE submitted_on BETWEEN '2025-06-01' AND '2025-06-04';

-- IS NULL: Find reviewers without a department (if any exist)
SELECT * FROM Reviewer WHERE dept_id IS NULL;


-- ******************** Aggregate Functions ********************

-- ______ SUM (Total of all feedback ratings) ______
SELECT SUM(rating) AS total_rating FROM User_Feedback;


-- ______ MAX (Latest submitted report date) ______
SELECT MAX(submitted_on) AS latest_submission FROM Report;

-- ______ MIN (Earliest report submission) ______
SELECT MIN(submitted_on) AS earliest_submission FROM Report;

-- ______ COUNT (Total number of reports) ______
SELECT COUNT(*) AS total_reports FROM Report;

-- ______ SUM (Total report IDs) ______
SELECT SUM(report_id) AS sum_of_report_ids FROM Report;

-- ______ AVG (Average feedback rating) ______
SELECT AVG(rating) AS average_rating FROM User_Feedback;


-- ******************** Fetch Data ********************
--  ______ LIKE operator ______
SELECT * FROM Category WHERE name LIKE '%Unsafe%';

--  ______ IN operator ______
SELECT * FROM Report WHERE status IN ('Pending', 'Resolved');

-- ______ NOT IN operator ______
SELECT * FROM Reviewer_Action WHERE reviewer_id NOT IN (504, 505);

-- ______ BETWEEN ______
SELECT * FROM Report WHERE submitted_on BETWEEN '2025-06-01' AND '2025-06-04';

-- ______IS NULL ______
SELECT * FROM Reviewer WHERE dept_id IS NULL;


