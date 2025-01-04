CREATE DATABASE company_db;

USE company_db;

CREATE TABLE departments (
    department_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(50)
);

CREATE TABLE employee_details (
    employeeid INT PRIMARY KEY,
    employeename VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    department_id VARCHAR(10),
    job_title VARCHAR(50),
    hire_date DATE,
    salary DECIMAL(10, 2),
    manager_id INT,
    location VARCHAR(50),
    performance_score VARCHAR(20),
    certifications VARCHAR(100),
    experience_years INT,
    shift VARCHAR(20),
    remarks TEXT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
CREATE TABLE attendance_records (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employeeid INT NOT NULL,
    date DATE NOT NULL,
    check_in_time TIME,
    check_out_time TIME,
    total_hours DECIMAL(4, 2),
    location VARCHAR(50),
    shift VARCHAR(20),
    manager_id INT,
    overtime_hours DECIMAL(4, 2),
    days_present INT,
    days_absent INT,
    sick_leaves INT,
    vacation_leaves INT,
    late_check_ins INT,
    remarks TEXT,
    FOREIGN KEY (employeeid) REFERENCES employee_details(employeeid)
);
CREATE TABLE project_assignments (
    project_id INT PRIMARY KEY,
    employeeid INT NOT NULL,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    project_status VARCHAR(50),
    client_name VARCHAR(100),
    budget DECIMAL(15, 2),
    team_size INT,
    manager_id INT,
    technologies_used VARCHAR(200),
    location VARCHAR(50),
    hours_worked DECIMAL(10, 2),
    milestones_achieved INT,
    risks_identified VARCHAR(200),
    FOREIGN KEY (employeeid) REFERENCES employee_details(employeeid)
);

CREATE TABLE Training_Programs (
    program_id INT PRIMARY KEY,
    employeeid INT,
    program_name VARCHAR(255),
    start_date DATE,
    end_date DATE,
    duration VARCHAR(50),
    trainer_name VARCHAR(255),
    cost DECIMAL(10, 2),
    location VARCHAR(255),
    certificate_awarded VARCHAR(5),
    completion_status VARCHAR(50),
    feedback_score DECIMAL(3, 2),
    technologies_covered TEXT,
    remarks TEXT,
    FOREIGN KEY (employeeid) REFERENCES employee_details(employeeid)
);

INSERT INTO departments (department_id, department_name)
VALUES ('DPT001', 'IT'),
       ('DPT002', 'Networks'),
       ('DPT003', 'Data Science'),
       ('DPT004', 'Cloud Solutions');

## 1. Employee productivity Analysis
SELECT e.employeeid, e.employeename, a.total_hours, a.days_absent
FROM employee_details e
JOIN attendance_records a ON e.employeeid = a.employeeid
ORDER BY a.total_hours DESC, a.days_absent ASC
;

### 2. Departmental Training Impact
SELECT d.department_name, AVG(t.feedback_score) AS avg_feedback_score, AVG(e.performance_score) AS avg_performance_score
FROM departments d
JOIN employee_details e ON d.department_id = e.department_id
JOIN training_programs t ON e.employeeid = t.employeeid
GROUP BY d.department_name
ORDER BY avg_feedback_score DESC;

##3. Project Budget Efficiency
SELECT p.project_id, p.project_name, p.budget, SUM(p.hours_worked) AS total_hours_worked,
       (p.budget / SUM(p.hours_worked)) AS cost_per_hour
FROM project_assignments p
GROUP BY p.project_id, p.project_name, p.budget
ORDER BY cost_per_hour ASC;

###4. Attendance Consistency
SELECT d.department_name, AVG(a.days_present) AS avg_days_present, AVG(a.days_absent) AS avg_days_absent
FROM departments d
JOIN employee_details e ON d.department_id = e.department_id
JOIN attendance_records a ON e.employeeid = a.employeeid
GROUP BY d.department_name
ORDER BY avg_days_present DESC, avg_days_absent ASC;

###5. Training and Project Success Correlation
SELECT t.technologies_covered, p.project_name, SUM(p.milestones_achieved) AS milestones_achieved
FROM training_programs t
JOIN project_assignments p ON FIND_IN_SET(t.technologies_covered, p.technologies_used) > 0
GROUP BY t.technologies_covered, p.project_name
ORDER BY milestones_achieved DESC;

###6. High-Impact Employees
SELECT e.employeeid, e.employeename, p.project_name, p.budget, e.performance_score
FROM employee_details e
JOIN Project_Assignments p ON e.employeeid = p.employeeid
WHERE p.budget > 100000 AND e.performance_score = 'Excellent'
ORDER BY p.budget DESC;

###7. Cross-Analysis of Training and Project Success
SELECT e.employeeid, e.employeename, t.technologies_covered, p.project_name, p.milestones_achieved
FROM employee_details e
JOIN training_programs t ON e.employeeid = t.employeeid
JOIN project_assignments p ON e.employeeid = p.employeeid
WHERE FIND_IN_SET(t.technologies_covered, p.technologies_used) > 0
ORDER BY p.milestones_achieved DESC;


###8. Overall Insights into Training Costs
SELECT d.department_name, SUM(t.cost) AS total_training_cost
FROM departments d
JOIN training_programs t ON d.department_id = t.department_id
GROUP BY d.department_name
ORDER BY total_training_cost DESC;

