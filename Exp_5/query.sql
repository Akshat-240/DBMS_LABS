

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
INSERT INTO Employee (EmpID, FirstName, LastName, Email, Salary, HireDate, DeptID) VALUES
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


-- Add ManagerID column to Employee table
ALTER TABLE Employee 
ADD COLUMN ManagerID INT NULL,
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (ManagerID) REFERENCES Employee(EmpID)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- Assign managers to employees to create a reporting hierarchy
UPDATE Employee SET ManagerID = NULL WHERE EmpID IN (6, 16);     -- Top Executives/Department Heads

UPDATE Employee SET ManagerID = 6 WHERE EmpID IN (1, 2, 3, 27);  -- Report to Ishaan (EmpID 6)
UPDATE Employee SET ManagerID = 1 WHERE EmpID IN (4, 5);         -- Report to Aarav (EmpID 1)
UPDATE Employee SET ManagerID = 16 WHERE EmpID IN (17, 18, 28);  -- Report to Manish (EmpID 16)
UPDATE Employee SET ManagerID = 17 WHERE EmpID IN (19, 20);      -- Report to Shreya (EmpID 17)


CREATE OR REPLACE VIEW vw_DepartmentSalarySummary AS
SELECT 
    d.DeptID,
    d.DeptName,
    COUNT(e.EmpID) AS TotalEmployees,
    COALESCE(SUM(e.Salary), 0.00) AS TotalSalary,
    ROUND(COALESCE(AVG(e.Salary), 0.00), 2) AS AvgSalary,
    COALESCE(MAX(e.Salary), 0.00) AS MaxSalary,
    COALESCE(MIN(e.Salary), 0.00) AS MinSalary
FROM Department d
LEFT JOIN Employee e ON d.DeptID = e.DeptID
GROUP BY d.DeptID, d.DeptName;

CREATE OR REPLACE VIEW vw_EmployeeHierarchy AS
SELECT 
    e.EmpID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    e.Email,
    e.Salary,
    e.DeptID,
    e.ManagerID,
    CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName
FROM Employee e
LEFT JOIN Employee m ON e.ManagerID = m.EmpID;


UPDATE vw_DepartmentSalarySummary 
SET DeptName = 'Software Engineering' 
WHERE DeptID = 1;


-- Updating an employee's salary through the view
UPDATE Employee 
SET Salary = 98000.00 
WHERE EmpID = 1;

-- Verify update on both View and Base Table
SELECT EmpID, EmployeeName, Salary FROM vw_EmployeeHierarchy WHERE EmpID = 1;
SELECT EmpID, FirstName, Salary FROM Employee WHERE EmpID = 1;


WITH RECURSIVE ReportingChain AS (
    -- Anchor Member: Top-level managers (Employees with no Manager)
    SELECT 
        EmpID,
        FirstName,
        LastName,
        ManagerID,
        1 AS HierarchyLevel,
        CAST(CONCAT(FirstName, ' ', LastName) AS CHAR(500)) AS ReportingPath
    FROM Employee
    WHERE ManagerID IS NULL
    
    UNION ALL
    
    -- Recursive Member: Join employees to their managers in the CTE
    SELECT 
        e.EmpID,
        e.FirstName,
        e.LastName,
        e.ManagerID,
        rc.HierarchyLevel + 1 AS HierarchyLevel,
        CAST(CONCAT(rc.ReportingPath, ' -> ', e.FirstName, ' ', e.LastName) AS CHAR(500)) AS ReportingPath
    FROM Employee e
    INNER JOIN ReportingChain rc ON e.ManagerID = rc.EmpID
)
SELECT 
    EmpID,
    CONCAT(FirstName, ' ', LastName) AS EmployeeName,
    ManagerID,
    HierarchyLevel,
    ReportingPath
FROM ReportingChain
ORDER BY HierarchyLevel, EmpID;

