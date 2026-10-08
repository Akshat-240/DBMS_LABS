CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;
-- 1. DEPARTMENT Table
CREATE TABLE Department (
DeptID INT AUTO_INCREMENT PRIMARY KEY,
DeptName VARCHAR(100) NOT NULL UNIQUE,
Location VARCHAR(100) NOT NULL
);
-- 2. EMPLOYEE Table
CREATE TABLE Employee (
EmpID INT AUTO_INCREMENT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE,
Salary DECIMAL(10,2) NOT NULL,
HireDate DATE NOT NULL,
DeptID INT,
FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
ON DELETE SET NULL
ON UPDATE CASCADE
);
-- Data Insertion: Departments
INSERT INTO Department (DeptID, DeptName, Location) VALUES
(1, 'Engineering', 'Bengaluru'),
(2, 'Human Resources', 'Mumbai'),
(3, 'Marketing', 'Delhi'),
(4, 'Finance', 'Hyderabad'),
(5, 'Sales', 'Pune');
-- Data Insertion: Employees
INSERT INTO Employee (EmpID, FirstName, LastName, Email, Salary, HireDate, DeptID)
VALUES
(1, 'Aarav', 'Sharma', 'aarav.sharma@company.com', 95000.00, '2021-03-15', 1),
(2, 'Vihaan', 'Verma', 'vihaan.verma@company.com', 88000.00, '2022-01-10', 1),
(3, 'Ananya', 'Rao', 'ananya.rao@company.com', 105000.00, '2020-06-01', 1),
(4, 'Diya', 'Patel', 'diya.patel@company.com', 72000.00, '2023-04-12', 1),
(5, 'Advait', 'Kulkarni', 'advait.kulkarni@company.com', 65000.00, '2024-02-01', 1),
(6, 'Ishaan', 'Nair', 'ishaan.nair@company.com', 115000.00, '2019-11-20', 1),
(7, 'Priya', 'Singh', 'priya.singh@company.com', 58000.00, '2022-08-15', 2),
(8, 'Kabir', 'Mehta', 'kabir.mehta@company.com', 62000.00, '2021-05-18', 2),
(9, 'Neha', 'Gupta', 'neha.gupta@company.com', 75000.00, '2020-02-11', 2),
(10, 'Rohan', 'Joshi', 'rohan.joshi@company.com', 52000.00, '2023-09-01', 2),
(11, 'Sanya', 'Reddy', 'sanya.reddy@company.com', 68000.00, '2021-07-22', 3),
(12, 'Aditya', 'Kumar', 'aditya.kumar@company.com', 74000.00, '2022-03-30', 3),
(13, 'Kavya', 'Deshmukh', 'kavya.deshmukh@company.com', 81000.00, '2020-10-05', 3),
(14, 'Arjun', 'Chopra', 'arjun.chopra@company.com', 59000.00, '2023-01-15', 3),
(15, 'Tara', 'Bhasin', 'tara.bhasin@company.com', 92000.00, '2019-04-18', 3),
(16, 'Manish', 'Tiwari', 'manish.tiwari@company.com', 110000.00, '2018-08-12', 4),
(17, 'Shreya', 'Iyer', 'shreya.iyer@company.com', 95000.00, '2021-12-01', 4),
(18, 'Karan', 'Saxena', 'karan.saxena@company.com', 87000.00, '2022-05-14', 4),
(19, 'Riya', 'Kapoor', 'riya.kapoor@company.com', 64000.00, '2023-07-19', 4),
(20, 'Varun', 'Bhatt', 'varun.bhatt@company.com', 78000.00, '2020-09-25', 4),
(21, 'Amit', 'Aggarwal', 'amit.aggarwal@company.com', 85000.00, '2021-02-10', 5),
(22, 'Pooja', 'Pillai', 'pooja.pillai@company.com', 69000.00, '2022-11-05', 5),
(23, 'Siddharth', 'Roy', 'siddharth.roy@company.com', 98000.00, '2019-07-01', 5),
(24, 'Sneha', 'Mishra', 'sneha.mishra@company.com', 61000.00, '2023-03-21', 5),
(25, 'Rahul', 'Nambiar', 'rahul.nambiar@company.com', 76000.00, '2021-10-10', 5),
(26, 'Meera', 'Sen', 'meera.sen@company.com', 89000.00, '2020-12-15', 5),
(27, 'Gaurav', 'Pandey', 'gaurav.pandey@company.com', 54000.00, '2024-01-08', 1),
(28, 'Nisha', 'Dube', 'nisha.dube@company.com', 97000.00, '2019-09-09', 4),
(29, 'Vikas', 'Thakur', 'vikas.thakur@company.com', 71000.00, '2022-06-17', 3),
(30, 'Simran', 'Kaur', 'simran.kaur@company.com', 83000.00, '2021-04-04', 2);
-- 1. SETUP: AUDIT LOG TABLE
-- Before creating triggers and procedures, we create a dedicated table to capture changes made
-- to employee records.
CREATE TABLE IF NOT EXISTS EmployeeAuditLog (
AuditID INT AUTO_INCREMENT PRIMARY KEY,
EmpID INT NOT NULL,
ActionType VARCHAR(50) NOT NULL,
OldDeptID INT,
NewDeptID INT,
OldSalary DECIMAL(10,2),
NewSalary DECIMAL(10,2),
ChangedBy VARCHAR(100) NOT NULL,
ChangedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- 2. TRIGGERS IMPLEMENTATION
-- A. Before Insert & Update Trigger: Salary Validation
-- Prevents setting an employee's salary below $30,000 or giving a single salary decrease greater
-- than 20%.
DELIMITER $$
CREATE TRIGGER trg_BeforeSalaryUpdate
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
-- Prevent salary below minimum threshold
IF NEW.Salary < 30000.00 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Validation Error: Salary cannot be less than 30,000.00.';
END IF;
-- Prevent drastic salary reductions (>20%)
IF NEW.Salary < (OLD.Salary * 0.80) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Validation Error: Salary reduction cannot exceed 20% of current salary.';
END IF;
END$$
DELIMITER ;
-- B. After Update Trigger: Audit Logging
-- Captures changes to an employee's department or salary and writes them to the
-- EmployeeAuditLog table.
DELIMITER $$
CREATE TRIGGER trg_AfterEmployeeUpdate
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
-- Log changes if Department or Salary has changed
IF OLD.DeptID <=> NEW.DeptID OR OLD.Salary <=> NEW.Salary THEN
INSERT INTO EmployeeAuditLog (
EmpID,
ActionType,
OldDeptID,
NewDeptID,
OldSalary,
NewSalary,
ChangedBy,
ChangedAt
) VALUES (
NEW.EmpID,
'UPDATE',
OLD.DeptID,
NEW.DeptID,
OLD.Salary,
NEW.Salary,
CURRENT_USER(),
NOW()
);
END IF;
END$$
DELIMITER ;
-- 3. STORED PROCEDURE: TRANSFER_EMPLOYEE
-- Includes parameter validation, checking for existence, handling redundant updates, and
-- transactional error handling via SQLEXCEPTION.
DELIMITER $$
CREATE PROCEDURE transfer_employee(
IN p_emp_id INT,
IN p_new_dept_id INT
)
PROC_BODY: BEGIN
DECLARE v_emp_exists INT DEFAULT 0;
DECLARE v_dept_exists INT DEFAULT 0;
DECLARE v_current_dept_id INT DEFAULT NULL;
-- Error handler for database/transaction failures
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
RESIGNAL;
END;
-- Step 1: Validate NULL inputs
IF p_emp_id IS NULL OR p_new_dept_id IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Transfer Error: Employee ID and Department ID cannot be NULL.';
END IF;
-- Step 2: Check if Employee exists and fetch current department
SELECT COUNT(*), DeptID INTO v_emp_exists, v_current_dept_id
FROM Employee
WHERE EmpID = p_emp_id;
IF v_emp_exists = 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Transfer Error: Specified Employee ID does not exist.';
END IF;
-- Step 3: Check if target Department exists
SELECT COUNT(*) INTO v_dept_exists
FROM Department
WHERE DeptID = p_new_dept_id;
IF v_dept_exists = 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Transfer Error: Specified Target Department ID does not exist.';
END IF;
-- Step 4: Check if employee is already in the target department
IF v_current_dept_id = p_new_dept_id THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Transfer Error: Employee is already assigned to this department.';
END IF;
-- Step 5: Perform the transfer within a transaction
START TRANSACTION;
UPDATE Employee
SET DeptID = p_new_dept_id
WHERE EmpID = p_emp_id;
COMMIT;
SELECT CONCAT('Successfully transferred Employee ', p_emp_id, ' to Department ',
p_new_dept_id) AS Result;
END$$
DELIMITER ;


-- Test Case 1: Successful Department Transfer
-- Valid transfer: Move EmpID 1 to DeptID 2
CALL transfer_employee(1, 2);
-- Verify update and audit entry
SELECT EmpID, FirstName, DeptID FROM Employee WHERE EmpID = 1;
SELECT * FROM EmployeeAuditLog WHERE EmpID = 1;
-- Test Case 2: Non-existent Employee ID
-- Fails: EmpID 9999 does not exist
CALL transfer_employee(9999, 1);
-- Test Case 3: Non-existent Target Department ID
-- Fails: DeptID 999 does not exist
CALL transfer_employee(1, 999);
-- Test Case 4: Redundant Transfer (Same Department)
-- Fails: EmpID 1 is already in DeptID 2 (from Test Case 1)
CALL transfer_employee(1, 2);
-- Test Case 5: Salary Validation Trigger (Minimum Threshold)
-- Fails: Salary is below 30,000
UPDATE Employee SET Salary = 20000.00 WHERE EmpID = 1;
-- Test Case 6: Salary Validation Trigger (Excessive Reduction)
-- Assuming EmpID 1 salary is 95,000.00, reducing to 50,000.00 (>20% drop)
UPDATE Employee SET Salary = 50000.00 WHERE EmpID = 1;
