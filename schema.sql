-- HR & Payroll Database with Compliance
-- GitHub Repository Starter: Database Schema and Logic

-- 1. Employee Master Data
CREATE TABLE Employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    national_id CHAR(12), -- Considered PII
    phone VARCHAR(20),
    hire_date DATE,
    role ENUM('Employee', 'Manager', 'HR', 'Admin') DEFAULT 'Employee',
    status ENUM('active', 'inactive') DEFAULT 'active'
);

-- 2. GDPR-Compliant Data Masking View Example (for limited access)
CREATE VIEW Employee_Safe_View AS
SELECT 
    id, 
    firstname, 
    lastname, 
    CONCAT('****', RIGHT(national_id, 4)) AS masked_national_id,
    email, 
    role
FROM Employees;

-- 3. Salary Slabs and Payroll
CREATE TABLE Salary_Slabs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    min_salary DECIMAL(10,2),
    max_salary DECIMAL(10,2),
    tax_rate DECIMAL(4,2) -- e.g., 0.1 for 10%
);

CREATE TABLE Payroll (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    salary DECIMAL(10,2),
    tax_amount DECIMAL(10,2),
    net_pay DECIMAL(10,2),
    paid_on DATE,
    FOREIGN KEY (employee_id) REFERENCES Employees(id)
);

-- 4. Payroll Calculation Procedure
DELIMITER $$
CREATE PROCEDURE CalculatePayroll()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE emp_id INT;
    DECLARE base_salary DECIMAL(10,2);

    DECLARE emp_cursor CURSOR FOR SELECT id FROM Employees WHERE status = 'active';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN emp_cursor;
    read_loop: LOOP
        FETCH emp_cursor INTO emp_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Example logic: Assume base salary comes from elsewhere or use fixed example
        SET base_salary = 3000.00;

        INSERT INTO Payroll (employee_id, salary, tax_amount, net_pay, paid_on)
        VALUES (emp_id, base_salary, base_salary * 0.2, base_salary * 0.8, CURDATE());
    END LOOP;
    CLOSE emp_cursor;
END $$
DELIMITER ;

-- 5. Salary History Tracking
CREATE TABLE Salary_History (
    id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    salary DECIMAL(10,2),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employees(id)
);

-- Trigger to track salary changes
DELIMITER $$
CREATE TRIGGER trg_salary_audit
BEFORE UPDATE ON Payroll
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO Salary_History (employee_id, salary)
        VALUES (OLD.employee_id, OLD.salary);
    END IF;
END $$
DELIMITER ;

-- 6. Sample Data Seeding
INSERT INTO Employees (firstname, lastname, email, national_id, phone, hire_date, role, status) VALUES
('Alice', 'Kariuki', 'alice.kariuki@example.com', '123456789012', '+254700000001', '2021-01-10', 'HR', 'active'),
('Brian', 'Otieno', 'brian.otieno@example.com', '234567890123', '+254700000002', '2020-06-15', 'Employee', 'active'),
('Clara', 'Wambui', 'clara.wambui@example.com', '345678901234', '+254700000003', '2022-03-20', 'Manager', 'active');

INSERT INTO Salary_Slabs (min_salary, max_salary, tax_rate) VALUES
(0, 1500, 0.10),
(1501, 3000, 0.20),
(3001, 10000, 0.30);

-- Simulate existing payroll entries
INSERT INTO Payroll (employee_id, salary, tax_amount, net_pay, paid_on) VALUES
(1, 2500.00, 500.00, 2000.00, '2024-12-31'),
(2, 1800.00, 360.00, 1440.00, '2024-12-31'),
(3, 3500.00, 1050.00, 2450.00, '2024-12-31');

-- END OF HR & PAYROLL SYSTEM STARTER SCRIPT
