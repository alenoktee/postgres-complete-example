-- PostgreSQL Test Queries
-- These queries analyze the sample data from init.sql

-- ============================================================================
-- 1. Basic Statistics
-- ============================================================================

SELECT '=== TOTAL COUNTS ===' as section;
SELECT COUNT(*) as total_employees FROM employees;
SELECT COUNT(*) as total_projects FROM projects;
SELECT COUNT(*) as total_assignments FROM assignments;

-- ============================================================================
-- 2. Department Analysis
-- ============================================================================

SELECT '' as separator;
SELECT '=== DEPARTMENT ANALYSIS ===' as section;

SELECT 
    department,
    COUNT(*) as employee_count,
    AVG(salary)::DECIMAL(10,2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    SUM(salary) as total_salary
FROM employees
WHERE is_active = true
GROUP BY department
ORDER BY avg_salary DESC;

-- ============================================================================
-- 3. Top Earning Employees
-- ============================================================================

SELECT '' as separator;
SELECT '=== TOP 5 HIGHEST PAID EMPLOYEES ===' as section;

SELECT 
    name,
    email,
    department,
    position,
    salary
FROM employees
WHERE is_active = true
ORDER BY salary DESC
LIMIT 5;

-- ============================================================================
-- 4. Project Status Overview
-- ============================================================================

SELECT '' as separator;
SELECT '=== PROJECT STATUS OVERVIEW ===' as section;

SELECT 
    status,
    COUNT(*) as project_count,
    SUM(budget)::DECIMAL(12,2) as total_budget,
    AVG(budget)::DECIMAL(10,2) as avg_budget
FROM projects
GROUP BY status
ORDER BY project_count DESC;

-- ============================================================================
-- 5. Employee Utilization
-- ============================================================================

SELECT '' as separator;
SELECT '=== EMPLOYEE PROJECT ASSIGNMENTS ===' as section;

SELECT 
    e.name,
    e.department,
    COUNT(a.project_id) as project_count,
    SUM(a.hours_allocated)::DECIMAL(5,2) as total_hours_allocated
FROM employees e
LEFT JOIN assignments a ON e.id = a.employee_id
WHERE e.is_active = true
GROUP BY e.id, e.name, e.department
ORDER BY total_hours_allocated DESC NULLS LAST;

-- ============================================================================
-- 6. Project Team Composition
-- ============================================================================

SELECT '' as separator;
SELECT '=== PROJECT TEAM DETAILS ===' as section;

SELECT 
    p.name as project_name,
    p.status,
    COUNT(a.employee_id) as team_size,
    SUM(a.hours_allocated)::DECIMAL(5,2) as total_hours,
    SUM(e.salary)::DECIMAL(12,2) as team_salary_cost
FROM projects p
LEFT JOIN assignments a ON p.id = a.project_id
LEFT JOIN employees e ON a.employee_id = e.id
GROUP BY p.id, p.name, p.status
ORDER BY team_size DESC NULLS LAST;

-- ============================================================================
-- 7. Active vs Inactive Employees
-- ============================================================================

SELECT '' as separator;
SELECT '=== EMPLOYEE STATUS ===' as section;

SELECT 
    CASE WHEN is_active THEN 'Active' ELSE 'Inactive' END as employee_status,
    COUNT(*) as count,
    AVG(salary)::DECIMAL(10,2) as avg_salary
FROM employees
GROUP BY is_active
ORDER BY is_active DESC;

-- ============================================================================
-- 8. Salary Ranges
-- ============================================================================

SELECT '' as separator;
SELECT '=== SALARY DISTRIBUTION ===' as section;

SELECT 
    CASE 
        WHEN salary < 70000 THEN 'Below $70k'
        WHEN salary < 80000 THEN '$70k - $80k'
        WHEN salary < 90000 THEN '$80k - $90k'
        WHEN salary < 100000 THEN '$90k - $100k'
        ELSE 'Above $100k'
    END as salary_range,
    COUNT(*) as employee_count,
    ROUND(AVG(salary)::NUMERIC, 2) as avg_salary
FROM employees
WHERE is_active = true
GROUP BY salary_range
ORDER BY 
    CASE 
        WHEN salary_range = 'Below $70k' THEN 1
        WHEN salary_range = '$70k - $80k' THEN 2
        WHEN salary_range = '$80k - $90k' THEN 3
        WHEN salary_range = '$90k - $100k' THEN 4
        ELSE 5
    END;

-- ============================================================================
-- 9. Future Project Timeline
-- ============================================================================

SELECT '' as separator;
SELECT '=== PROJECT TIMELINE ===' as section;

SELECT 
    name,
    start_date,
    end_date,
    EXTRACT(DAY FROM end_date - start_date)::INT as duration_days,
    status,
    budget
FROM projects
WHERE end_date >= CURRENT_DATE
ORDER BY start_date;

-- ============================================================================
-- 10. Department Payroll Summary
-- ============================================================================

SELECT '' as separator;
SELECT '=== DEPARTMENT PAYROLL SUMMARY ===' as section;

SELECT 
    department,
    COUNT(*) as headcount,
    SUM(salary)::DECIMAL(12,2) as department_payroll,
    ROUND(AVG(salary)::NUMERIC, 2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM employees
WHERE is_active = true
GROUP BY department
ORDER BY department_payroll DESC;
