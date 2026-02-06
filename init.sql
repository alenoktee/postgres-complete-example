-- PostgreSQL Database Initialization Script
-- This script creates all necessary tables and inserts sample data

-- Create employees table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    department VARCHAR(100) NOT NULL,
    position VARCHAR(100),
    salary DECIMAL(10, 2),
    hire_date DATE,
    is_active BOOLEAN DEFAULT true
);

-- Create projects table
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12, 2),
    status VARCHAR(50) DEFAULT 'active'
);

-- Create assignments table (many-to-many between employees and projects)
CREATE TABLE assignments (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL REFERENCES employees(id),
    project_id INT NOT NULL REFERENCES projects(id),
    role VARCHAR(100),
    assigned_date DATE,
    hours_allocated DECIMAL(5, 2)
);

-- Create an index for faster queries
CREATE INDEX idx_employees_department ON employees(department);
CREATE INDEX idx_assignments_employee ON assignments(employee_id);
CREATE INDEX idx_assignments_project ON assignments(project_id);

-- Insert sample employees data
INSERT INTO employees (name, email, department, position, salary, hire_date, is_active) VALUES
    ('Alice Johnson', 'alice.johnson@company.com', 'Engineering', 'Senior Developer', 95000, '2021-01-15', true),
    ('Bob Smith', 'bob.smith@company.com', 'Engineering', 'Developer', 75000, '2022-06-20', true),
    ('Carol White', 'carol.white@company.com', 'Sales', 'Sales Manager', 85000, '2020-03-10', true),
    ('David Brown', 'david.brown@company.com', 'Sales', 'Sales Representative', 65000, '2022-11-05', true),
    ('Eve Davis', 'eve.davis@company.com', 'HR', 'HR Manager', 72000, '2021-08-12', true),
    ('Frank Miller', 'frank.miller@company.com', 'Engineering', 'DevOps Engineer', 88000, '2022-02-28', true),
    ('Grace Lee', 'grace.lee@company.com', 'Product', 'Product Manager', 90000, '2021-09-01', true),
    ('Henry Wilson', 'henry.wilson@company.com', 'Engineering', 'QA Engineer', 70000, '2023-01-15', true);

-- Insert sample projects data
INSERT INTO projects (name, description, start_date, end_date, budget, status) VALUES
    ('Mobile App Development', 'Development of new mobile application for iOS and Android', '2024-01-01', '2024-06-30', 150000, 'active'),
    ('API Redesign', 'Redesigning legacy API to modern architecture', '2024-02-01', '2024-05-31', 100000, 'active'),
    ('Database Migration', 'Migrating from MySQL to PostgreSQL', '2024-03-01', '2024-04-30', 50000, 'planning'),
    ('Marketing Campaign', 'Q2 marketing campaign', '2024-04-01', '2024-06-30', 75000, 'active'),
    ('Infrastructure Upgrade', 'Upgrading cloud infrastructure', '2024-01-15', '2024-03-31', 120000, 'completed');

-- Insert sample assignments
INSERT INTO assignments (employee_id, project_id, role, assigned_date, hours_allocated) VALUES
    (1, 1, 'Tech Lead', '2024-01-01', 40),
    (2, 1, 'Developer', '2024-01-01', 35),
    (1, 2, 'Architect', '2024-02-01', 30),
    (6, 2, 'DevOps', '2024-02-01', 20),
    (8, 1, 'QA Lead', '2024-01-15', 25),
    (3, 4, 'Manager', '2024-04-01', 20),
    (4, 4, 'Coordinator', '2024-04-01', 30),
    (6, 5, 'DevOps Lead', '2024-01-15', 40),
    (7, 1, 'Product Owner', '2024-01-01', 15),
    (5, 5, 'HR Coordinator', '2024-01-15', 10);

-- Commit the transaction
COMMIT;
