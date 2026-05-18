-- =============================================================================
--  CMPE343 — Ercan Airport Management Information System
--  File 3: 15 Management Queries + Views + Stored Procedures + Triggers + Transactions
-- =============================================================================

USE ercan_airport;

-- =============================================================================
--  SECTION A: 15 MANAGEMENT QUERIES
--  (Per spec: use JOIN, subquery, GROUP BY, aggregate functions, etc.)
-- =============================================================================

-- ----------------------------------------------------------------------------
-- Q1. Complete Fleet Status Report
--     Lists every aircraft at Ercan with airline, model, status and
--     how many days remain until the next scheduled inspection.
-- ----------------------------------------------------------------------------
SELECT
    a.plane_no                                          AS "Plane No",
    al.airline_name                                     AS "Airline",
    CONCAT(pm.manufacturer, ' ', pm.model_name)         AS "Aircraft Type",
    pm.seating_capacity                                 AS "Capacity",
    a.total_flight_hours                                AS "Total Hours",
    a.status                                            AS "Status",
    a.next_inspection_date                              AS "Next Inspection",
    DATEDIFF(a.next_inspection_date, CURDATE())         AS "Days Until Inspection"
FROM airplanes a
JOIN plane_models pm ON a.model_id  = pm.model_id
JOIN airlines    al  ON a.airline_id = al.airline_id
ORDER BY DATEDIFF(a.next_inspection_date, CURDATE()) ASC;

-- ----------------------------------------------------------------------------
-- Q2. Technician Workload & Performance Summary
--     For each technician: total tests performed, total hours spent,
--     average score, and pass/fail counts.
-- ----------------------------------------------------------------------------
SELECT
    CONCAT(e.first_name, ' ', e.last_name)      AS "Technician",
    t.specialization                             AS "Specialization",
    COUNT(th.history_id)                         AS "Tests Performed",
    ROUND(SUM(th.hours_spent), 1)                AS "Total Hours",
    ROUND(AVG(th.score), 2)                      AS "Avg Score",
    SUM(CASE WHEN th.result = 'Pass' THEN 1 ELSE 0 END)   AS "Passed",
    SUM(CASE WHEN th.result = 'Fail' THEN 1 ELSE 0 END)   AS "Failed",
    ROUND(
        SUM(CASE WHEN th.result = 'Pass' THEN 1 ELSE 0 END)
        / COUNT(th.history_id) * 100, 1
    )                                            AS "Pass Rate %"
FROM technicians t
JOIN employees e  ON t.employee_id    = e.employee_id
LEFT JOIN test_history th ON t.technician_id = th.technician_id
GROUP BY t.technician_id, e.first_name, e.last_name, t.specialization
ORDER BY SUM(th.hours_spent) DESC;

-- ----------------------------------------------------------------------------
-- Q3. Aircraft Currently Parked in Hangars (IN without OUT)
--     Management view: which planes are occupying hangar space right now.
-- ----------------------------------------------------------------------------
SELECT
    a.plane_no                                              AS "Plane No",
    al.airline_name                                         AS "Airline",
    CONCAT(pm.manufacturer, ' ', pm.model_name)             AS "Model",
    a.status                                                AS "Aircraft Status",
    h.hangar_no                                             AS "Hangar No",
    h.hangar_name                                           AS "Hangar",
    h.location                                              AS "Location",
    p.date_in                                               AS "Checked In",
    TIMESTAMPDIFF(HOUR, p.date_in, NOW())                   AS "Hours in Hangar",
    p.reason                                                AS "Reason",
    CONCAT(e.first_name, ' ', e.last_name)                  AS "Checked In By"
FROM airplane_parking p
JOIN airplanes   a  ON p.airplane_id    = a.airplane_id
JOIN airlines    al ON a.airline_id     = al.airline_id
JOIN plane_models pm ON a.model_id      = pm.model_id
JOIN hangars     h  ON p.hangar_id      = h.hangar_id
JOIN employees   e  ON p.checked_in_by  = e.employee_id
WHERE p.date_out IS NULL
ORDER BY p.date_in;

-- ----------------------------------------------------------------------------
-- Q4. Test Results Per Airplane — Airworthiness Overview
--     For each airplane: total tests, average score, and overall pass rate.
--     Uses GROUP BY + HAVING to flag aircraft with below-average performance.
-- ----------------------------------------------------------------------------
SELECT
    a.plane_no                                          AS "Plane No",
    CONCAT(pm.manufacturer, ' ', pm.model_name)         AS "Model",
    al.airline_name                                     AS "Airline",
    COUNT(th.history_id)                                AS "Total Tests",
    ROUND(AVG(th.score), 2)                             AS "Avg Score",
    SUM(CASE WHEN th.result = 'Pass' THEN 1 ELSE 0 END) AS "Passed",
    SUM(CASE WHEN th.result = 'Fail' THEN 1 ELSE 0 END) AS "Failed",
    ROUND(
        SUM(CASE WHEN th.result = 'Pass' THEN 1 ELSE 0 END)
        / COUNT(th.history_id) * 100, 1
    )                                                   AS "Pass Rate %"
FROM test_history th
JOIN airplanes   a  ON th.airplane_id = a.airplane_id
JOIN plane_models pm ON a.model_id    = pm.model_id
JOIN airlines    al  ON a.airline_id  = al.airline_id
GROUP BY a.airplane_id
HAVING AVG(th.score) < 90
ORDER BY AVG(th.score) ASC;

-- ----------------------------------------------------------------------------
-- Q5. Technician Expertise Matrix — Which Technician Can Service Which Model?
--     Uses 4-table JOIN. Critical for maintenance scheduling.
-- ----------------------------------------------------------------------------
SELECT
    CONCAT(e.first_name, ' ', e.last_name)              AS "Technician",
    t.specialization                                    AS "Specialization",
    pm.model_code                                       AS "Model Code",
    CONCAT(pm.manufacturer, ' ', pm.model_name)         AS "Aircraft Model",
    te.certification_level                              AS "Cert Level",
    te.certified_date                                   AS "Certified Since"
FROM technician_expertise te
JOIN technicians  t  ON te.technician_id = t.technician_id
JOIN employees    e  ON t.employee_id    = e.employee_id
JOIN plane_models pm ON te.model_id      = pm.model_id
ORDER BY e.last_name, te.certification_level DESC;

-- ----------------------------------------------------------------------------
-- Q6. Aircraft That Have Failed At Least One Test (EXISTS subquery)
--     Management alert: aircraft requiring immediate attention.
-- ----------------------------------------------------------------------------
SELECT
    a.plane_no                                          AS "Plane No",
    CONCAT(pm.manufacturer, ' ', pm.model_name)         AS "Model",
    al.airline_name                                     AS "Airline",
    a.status                                            AS "Current Status",
    a.next_inspection_date                              AS "Next Inspection"
FROM airplanes a
JOIN plane_models pm ON a.model_id  = pm.model_id
JOIN airlines    al  ON a.airline_id = al.airline_id
WHERE EXISTS (
    SELECT 1
    FROM test_history th
    WHERE th.airplane_id = a.airplane_id
      AND th.result      = 'Fail'
)
ORDER BY a.status;

-- ----------------------------------------------------------------------------
-- Q7. Employee Union Membership Report
--     Per spec: each employee has a union_membership_no.
--     Lists all employees with their union, membership number, and department.
-- ----------------------------------------------------------------------------
SELECT
    e.social_security_no                                AS "SSN",
    CONCAT(e.first_name, ' ', e.last_name)              AS "Employee",
    d.dept_name                                         AS "Department",
    u.union_name                                        AS "Union",
    u.union_code                                        AS "Code",
    e.union_membership_no                               AS "Membership No",
    u.monthly_fee                                       AS "Monthly Fee (TRY)"
FROM employees e
JOIN departments d ON e.dept_id  = d.dept_id
JOIN unions      u ON e.union_id = u.union_id
WHERE e.is_active = 1
ORDER BY u.union_name, e.last_name;

-- ----------------------------------------------------------------------------
-- Q8. Traffic Controller Medical Examination Status
--     Per spec: store date of most recent annual medical exam.
--     Flags controllers whose exam is overdue or expiring within 90 days.
-- ----------------------------------------------------------------------------
SELECT
    CONCAT(e.first_name, ' ', e.last_name)              AS "Controller",
    tc.license_number                                   AS "License No",
    tc.license_type                                     AS "Rating",
    tc.last_medical_exam_date                           AS "Last Medical Exam",
    tc.next_medical_exam_date                           AS "Next Medical Exam",
    DATEDIFF(tc.next_medical_exam_date, CURDATE())      AS "Days Until Exam",
    CASE
        WHEN tc.next_medical_exam_date < CURDATE()
            THEN '⚠ OVERDUE'
        WHEN DATEDIFF(tc.next_medical_exam_date, CURDATE()) <= 90
            THEN '⚠ DUE SOON'
        ELSE 'OK'
    END                                                 AS "Exam Status"
FROM traffic_controllers tc
JOIN employees e ON tc.employee_id = e.employee_id
ORDER BY tc.next_medical_exam_date ASC;

-- ----------------------------------------------------------------------------
-- Q9. Hangar Utilization Report (GROUP BY + aggregate)
--     Shows capacity vs. current occupancy for each hangar.
-- ----------------------------------------------------------------------------
SELECT
    h.hangar_no                                             AS "Hangar No",
    h.hangar_name                                           AS "Name",
    h.hangar_type                                           AS "Type",
    h.location                                              AS "Location",
    h.capacity                                              AS "Capacity",
    COUNT(p.parking_id)                                     AS "Occupied",
    h.capacity - COUNT(p.parking_id)                        AS "Free Slots",
    ROUND(COUNT(p.parking_id) / h.capacity * 100, 1)        AS "Utilization %",
    COALESCE(
        GROUP_CONCAT(a.plane_no ORDER BY a.plane_no SEPARATOR ', '),
        '—'
    )                                                       AS "Aircraft Inside"
FROM hangars h
LEFT JOIN airplane_parking p ON h.hangar_id  = p.hangar_id
    AND p.date_out IS NULL
LEFT JOIN airplanes        a ON p.airplane_id = a.airplane_id
GROUP BY h.hangar_id
ORDER BY COUNT(p.parking_id) / h.capacity DESC;

-- ----------------------------------------------------------------------------
-- Q10. Flight On-Time Performance by Airline (GROUP BY + HAVING)
--      Shows total flights, delayed flights, and average delay per airline.
-- ----------------------------------------------------------------------------
SELECT
    al.airline_name                                         AS "Airline",
    al.iata_code                                            AS "IATA",
    COUNT(f.flight_id)                                      AS "Total Flights",
    SUM(CASE WHEN f.delay_minutes = 0 THEN 1 ELSE 0 END)   AS "On Time",
    SUM(CASE WHEN f.delay_minutes > 0 THEN 1 ELSE 0 END)   AS "Delayed",
    ROUND(AVG(f.delay_minutes), 1)                          AS "Avg Delay (min)",
    MAX(f.delay_minutes)                                    AS "Max Delay (min)"
FROM flights f
JOIN airlines al ON f.airline_id = al.airline_id
WHERE f.flight_status IN ('Landed', 'Departed')
GROUP BY al.airline_id
HAVING COUNT(f.flight_id) > 0
ORDER BY AVG(f.delay_minutes) DESC;

-- ----------------------------------------------------------------------------
-- Q11. Top Revenue-Generating Flights (Derived table subquery + RANK)
--      Ranks completed flights by total ticket revenue.
-- ----------------------------------------------------------------------------
SELECT
    f.flight_number                                     AS "Flight No",
    al.airline_name                                     AS "Airline",
    f.origin_iata                                       AS "From",
    f.destination_iata                                  AS "To",
    rev.ticket_count                                    AS "Tickets",
    rev.total_revenue                                   AS "Revenue (TRY)",
    RANK() OVER (ORDER BY rev.total_revenue DESC)       AS "Revenue Rank"
FROM flights f
JOIN airlines al ON f.airline_id = al.airline_id
JOIN (
    SELECT
        tk.flight_id,
        COUNT(py.payment_id)    AS ticket_count,
        SUM(py.amount)          AS total_revenue
    FROM tickets  tk
    JOIN payments py ON tk.ticket_id = py.ticket_id
    WHERE py.payment_status = 'Completed'
    GROUP BY tk.flight_id
) AS rev ON f.flight_id = rev.flight_id
ORDER BY rev.total_revenue DESC;

-- ----------------------------------------------------------------------------
-- Q12. Maintenance Cost Summary Per Aircraft (LEFT JOIN + aggregate)
--      Lists total repair parts cost, labor cost, and grand total per plane.
-- ----------------------------------------------------------------------------
SELECT
    a.plane_no                                          AS "Plane No",
    CONCAT(pm.manufacturer, ' ', pm.model_name)         AS "Model",
    al.airline_name                                     AS "Airline",
    COUNT(r.repair_id)                                  AS "Repairs",
    COALESCE(SUM(r.parts_cost),  0)                     AS "Parts Cost",
    COALESCE(SUM(r.labor_cost),  0)                     AS "Labor Cost",
    COALESCE(SUM(r.total_cost),  0)                     AS "Grand Total"
FROM airplanes a
JOIN plane_models pm ON a.model_id  = pm.model_id
JOIN airlines    al  ON a.airline_id = al.airline_id
LEFT JOIN repairs r  ON a.airplane_id = r.airplane_id
GROUP BY a.airplane_id
ORDER BY COALESCE(SUM(r.total_cost), 0) DESC;

-- ----------------------------------------------------------------------------
-- Q13. Plane Models With NO Certified Technician (NOT IN subquery)
--      Identifies coverage gaps — management must act to train technicians.
-- ----------------------------------------------------------------------------
SELECT
    pm.model_code                                       AS "Model Code",
    CONCAT(pm.manufacturer, ' ', pm.model_name)         AS "Aircraft Type",
    pm.seating_capacity                                 AS "Capacity",
    pm.engine_type                                      AS "Engine Type"
FROM plane_models pm
WHERE pm.model_id NOT IN (
    SELECT DISTINCT te.model_id
    FROM technician_expertise te
)
ORDER BY pm.manufacturer;

-- ----------------------------------------------------------------------------
-- Q14. Test Category Difficulty Analysis (GROUP BY + aggregate)
--      Compares test categories by average score, pass rate, and hours spent.
--      Helps management identify which test types need more technician training.
-- ----------------------------------------------------------------------------
SELECT
    t.test_category                                         AS "Category",
    COUNT(th.history_id)                                    AS "Times Conducted",
    ROUND(AVG(th.hours_spent), 2)                           AS "Avg Hours Spent",
    ROUND(AVG(th.score), 2)                                 AS "Avg Score",
    MIN(th.score)                                           AS "Min Score",
    MAX(th.score)                                           AS "Max Score",
    SUM(CASE WHEN th.result = 'Pass' THEN 1 ELSE 0 END)     AS "Passed",
    SUM(CASE WHEN th.result = 'Fail' THEN 1 ELSE 0 END)     AS "Failed",
    ROUND(
        SUM(CASE WHEN th.result = 'Pass' THEN 1 ELSE 0 END)
        / COUNT(th.history_id) * 100, 1
    )                                                       AS "Pass Rate %"
FROM tests t
JOIN test_history th ON t.test_id = th.test_id
GROUP BY t.test_category
ORDER BY SUM(CASE WHEN th.result = 'Pass' THEN 1 ELSE 0 END) / COUNT(th.history_id) * 100 ASC;

-- ----------------------------------------------------------------------------
-- Q15. Department Payroll & Headcount Summary (GROUP BY + aggregate)
--      Full HR financial overview: headcount, total payroll, min/max salaries.
-- ----------------------------------------------------------------------------
SELECT
    d.dept_name                                         AS "Department",
    d.dept_code                                         AS "Code",
    COUNT(e.employee_id)                                AS "Headcount",
    ROUND(SUM(e.salary), 2)                             AS "Monthly Payroll",
    ROUND(AVG(e.salary), 2)                             AS "Avg Salary",
    MIN(e.salary)                                       AS "Min Salary",
    MAX(e.salary)                                       AS "Max Salary",
    ROUND(SUM(e.salary) * 12, 2)                        AS "Annual Payroll"
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id AND e.is_active = 1
GROUP BY d.dept_id
ORDER BY SUM(e.salary) DESC;

-- =============================================================================
--  SECTION B: VIEWS
-- =============================================================================

-- View 1: Active Fleet Overview
CREATE OR REPLACE VIEW vw_active_fleet AS
SELECT
    a.airplane_id,
    a.plane_no,
    CONCAT(pm.manufacturer, ' ', pm.model_name) AS aircraft_type,
    pm.model_code,
    pm.seating_capacity,
    al.airline_name,
    al.iata_code,
    a.status,
    a.total_flight_hours,
    a.next_inspection_date,
    DATEDIFF(a.next_inspection_date, CURDATE()) AS days_to_inspection
FROM airplanes a
JOIN plane_models pm ON a.model_id  = pm.model_id
JOIN airlines    al  ON a.airline_id = al.airline_id
WHERE a.status = 'Operational';

-- View 2: Current Hangar Occupancy
CREATE OR REPLACE VIEW vw_hangar_occupancy AS
SELECT
    h.hangar_id,
    h.hangar_no,
    h.hangar_name,
    h.hangar_type,
    h.capacity,
    COUNT(p.parking_id)                                    AS occupied_slots,
    h.capacity - COUNT(p.parking_id)                       AS free_slots,
    ROUND(COUNT(p.parking_id) / h.capacity * 100, 1)       AS utilization_pct,
    COALESCE(GROUP_CONCAT(a.plane_no SEPARATOR ', '), '')   AS aircraft_list
FROM hangars h
LEFT JOIN airplane_parking p ON h.hangar_id   = p.hangar_id AND p.date_out IS NULL
LEFT JOIN airplanes        a ON p.airplane_id  = a.airplane_id
GROUP BY h.hangar_id;

-- View 3: Traffic Controller Exam Status
CREATE OR REPLACE VIEW vw_controller_exam_status AS
SELECT
    tc.controller_id,
    CONCAT(e.first_name, ' ', e.last_name)          AS controller_name,
    tc.license_number,
    tc.license_type,
    tc.last_medical_exam_date,
    tc.next_medical_exam_date,
    DATEDIFF(tc.next_medical_exam_date, CURDATE())  AS days_until_exam,
    CASE
        WHEN tc.next_medical_exam_date < CURDATE()                                  THEN 'OVERDUE'
        WHEN DATEDIFF(tc.next_medical_exam_date, CURDATE()) <= 90                   THEN 'DUE SOON'
        ELSE 'VALID'
    END AS exam_status
FROM traffic_controllers tc
JOIN employees e ON tc.employee_id = e.employee_id;

-- View 4: Full Test History with Names
CREATE OR REPLACE VIEW vw_test_history_full AS
SELECT
    th.history_id,
    a.plane_no,
    CONCAT(pm.manufacturer,' ',pm.model_name)       AS aircraft_type,
    ts.test_code,
    ts.test_name,
    ts.test_category,
    CONCAT(e.first_name,' ',e.last_name)             AS technician,
    th.test_date,
    th.hours_spent,
    th.score,
    ts.passing_score,
    th.result,
    th.remarks
FROM test_history th
JOIN airplanes    a  ON th.airplane_id   = a.airplane_id
JOIN plane_models pm ON a.model_id       = pm.model_id
JOIN tests        ts ON th.test_id       = ts.test_id
JOIN technicians  t  ON th.technician_id = t.technician_id
JOIN employees    e  ON t.employee_id    = e.employee_id;

-- View 5: Flight Revenue Summary
CREATE OR REPLACE VIEW vw_flight_revenue AS
SELECT
    f.flight_id,
    f.flight_number,
    al.airline_name,
    f.origin_iata,
    f.destination_iata,
    f.flight_status,
    COUNT(tk.ticket_id)             AS passengers_booked,
    COALESCE(SUM(py.amount), 0)     AS total_revenue,
    COALESCE(SUM(CASE WHEN tk.booking_class='First'    THEN py.amount ELSE 0 END),0) AS first_class_rev,
    COALESCE(SUM(CASE WHEN tk.booking_class='Business' THEN py.amount ELSE 0 END),0) AS business_rev,
    COALESCE(SUM(CASE WHEN tk.booking_class='Economy'  THEN py.amount ELSE 0 END),0) AS economy_rev
FROM flights  f
JOIN airlines al ON f.airline_id  = al.airline_id
LEFT JOIN tickets  tk ON f.flight_id  = tk.flight_id
LEFT JOIN payments py ON tk.ticket_id = py.ticket_id AND py.payment_status = 'Completed'
GROUP BY f.flight_id;

-- =============================================================================
--  SECTION C: STORED PROCEDURES
-- =============================================================================

DELIMITER //

-- Procedure 1: Park an aircraft (with capacity and duplicate check)
CREATE PROCEDURE sp_park_aircraft(
    IN  p_plane_no      VARCHAR(20),
    IN  p_hangar_no     VARCHAR(10),
    IN  p_reason        VARCHAR(255),
    IN  p_emp_ssn       VARCHAR(20),
    OUT p_message       VARCHAR(300)
)
BEGIN
    DECLARE v_airplane_id   INT UNSIGNED;
    DECLARE v_hangar_id     INT UNSIGNED;
    DECLARE v_emp_id        INT UNSIGNED;
    DECLARE v_capacity      INT;
    DECLARE v_occupied      INT;
    DECLARE v_already_in    INT;

    SELECT airplane_id INTO v_airplane_id FROM airplanes  WHERE plane_no   = p_plane_no  LIMIT 1;
    SELECT hangar_id   INTO v_hangar_id   FROM hangars    WHERE hangar_no  = p_hangar_no LIMIT 1;
    SELECT employee_id INTO v_emp_id      FROM employees  WHERE social_security_no = p_emp_ssn LIMIT 1;

    IF v_airplane_id IS NULL THEN
        SET p_message = 'ERROR: Airplane not found.';
    ELSEIF v_hangar_id IS NULL THEN
        SET p_message = 'ERROR: Hangar not found.';
    ELSEIF v_emp_id IS NULL THEN
        SET p_message = 'ERROR: Employee SSN not found.';
    ELSE
        SELECT COUNT(*) INTO v_already_in
        FROM airplane_parking
        WHERE airplane_id = v_airplane_id AND date_out IS NULL;

        IF v_already_in > 0 THEN
            SET p_message = 'ERROR: Aircraft is already parked in a hangar.';
        ELSE
            SELECT h.capacity, COUNT(p.parking_id)
            INTO   v_capacity, v_occupied
            FROM hangars h
            LEFT JOIN airplane_parking p
                ON h.hangar_id = p.hangar_id AND p.date_out IS NULL
            WHERE h.hangar_id = v_hangar_id
            GROUP BY h.hangar_id;

            IF v_occupied >= v_capacity THEN
                SET p_message = CONCAT('ERROR: Hangar ', p_hangar_no, ' is full (', v_capacity, '/', v_capacity, ').');
            ELSE
                INSERT INTO airplane_parking
                    (airplane_id, hangar_id, date_in, reason, checked_in_by)
                VALUES
                    (v_airplane_id, v_hangar_id, NOW(), p_reason, v_emp_id);
                SET p_message = CONCAT('SUCCESS: ', p_plane_no, ' parked in ', p_hangar_no,
                                       '. Parking ID = ', LAST_INSERT_ID());
            END IF;
        END IF;
    END IF;
END //

-- Procedure 2: Release aircraft from hangar
CREATE PROCEDURE sp_release_aircraft(
    IN  p_plane_no  VARCHAR(20),
    IN  p_emp_ssn   VARCHAR(20),
    OUT p_message   VARCHAR(300)
)
BEGIN
    DECLARE v_airplane_id   INT UNSIGNED;
    DECLARE v_emp_id        INT UNSIGNED;
    DECLARE v_parking_id    INT UNSIGNED;

    SELECT airplane_id INTO v_airplane_id FROM airplanes WHERE plane_no = p_plane_no LIMIT 1;
    SELECT employee_id INTO v_emp_id      FROM employees WHERE social_security_no = p_emp_ssn LIMIT 1;

    IF v_airplane_id IS NULL THEN
        SET p_message = 'ERROR: Airplane not found.';
    ELSEIF v_emp_id IS NULL THEN
        SET p_message = 'ERROR: Employee not found.';
    ELSE
        SELECT parking_id INTO v_parking_id
        FROM airplane_parking
        WHERE airplane_id = v_airplane_id AND date_out IS NULL
        LIMIT 1;

        IF v_parking_id IS NULL THEN
            SET p_message = 'ERROR: No active parking record for this aircraft.';
        ELSE
            UPDATE airplane_parking
            SET    date_out        = NOW(),
                   checked_out_by  = v_emp_id
            WHERE  parking_id = v_parking_id;
            SET p_message = CONCAT('SUCCESS: ', p_plane_no, ' released. Parking ID = ', v_parking_id);
        END IF;
    END IF;
END //

-- Procedure 3: Record test result (auto-evaluates Pass/Fail from passing_score)
CREATE PROCEDURE sp_record_test(
    IN  p_plane_no      VARCHAR(20),
    IN  p_test_code     VARCHAR(20),
    IN  p_tech_cert_no  VARCHAR(50),
    IN  p_test_date     DATE,
    IN  p_hours_spent   DECIMAL(6,2),
    IN  p_score         DECIMAL(5,2),
    IN  p_remarks       TEXT
)
BEGIN
    DECLARE v_airplane_id   INT UNSIGNED;
    DECLARE v_test_id       INT UNSIGNED;
    DECLARE v_tech_id       INT UNSIGNED;
    DECLARE v_pass_score    DECIMAL(5,2);
    DECLARE v_result        ENUM('Pass','Fail','Inconclusive');

    SELECT airplane_id  INTO v_airplane_id FROM airplanes    WHERE plane_no        = p_plane_no    LIMIT 1;
    SELECT test_id, passing_score INTO v_test_id, v_pass_score FROM tests WHERE test_code = p_test_code LIMIT 1;
    SELECT technician_id INTO v_tech_id    FROM technicians  WHERE certification_no = p_tech_cert_no LIMIT 1;

    SET v_result = IF(p_score >= v_pass_score, 'Pass', 'Fail');

    INSERT INTO test_history
        (airplane_id, test_id, technician_id, test_date, hours_spent, score, result, remarks)
    VALUES
        (v_airplane_id, v_test_id, v_tech_id, p_test_date, p_hours_spent, p_score, v_result, p_remarks);

    SELECT CONCAT('Test recorded. Result: ', v_result,
                  ' (Score: ', p_score, ' / Pass: ', v_pass_score, ')',
                  ' — ID = ', LAST_INSERT_ID()) AS outcome;
END //

-- Procedure 4: Full service history for an aircraft
CREATE PROCEDURE sp_aircraft_history(IN p_plane_no VARCHAR(20))
BEGIN
    DECLARE v_id INT;
    SELECT airplane_id INTO v_id FROM airplanes WHERE plane_no = p_plane_no LIMIT 1;

    IF v_id IS NULL THEN
        SELECT CONCAT('Aircraft ', p_plane_no, ' not found.') AS message;
    ELSE
        SELECT '=== HANGAR HISTORY ===' AS section;
        SELECT h.hangar_no, h.hangar_name, p.date_in, p.date_out, p.reason,
               TIMESTAMPDIFF(HOUR, p.date_in, COALESCE(p.date_out, NOW())) AS hours_stayed
        FROM airplane_parking p
        JOIN hangars h ON p.hangar_id = h.hangar_id
        WHERE p.airplane_id = v_id ORDER BY p.date_in DESC;

        SELECT '=== TEST HISTORY ===' AS section;
        SELECT th.test_date, ts.test_name, ts.test_category,
               th.hours_spent, th.score, th.result,
               CONCAT(e.first_name,' ',e.last_name) AS technician
        FROM test_history th
        JOIN tests       ts ON th.test_id       = ts.test_id
        JOIN technicians t  ON th.technician_id  = t.technician_id
        JOIN employees   e  ON t.employee_id     = e.employee_id
        WHERE th.airplane_id = v_id ORDER BY th.test_date DESC;

        SELECT '=== REPAIR HISTORY ===' AS section;
        SELECT r.repair_date, r.repair_type, r.description,
               r.parts_cost, r.labor_cost, r.total_cost, r.status
        FROM repairs r
        WHERE r.airplane_id = v_id ORDER BY r.repair_date DESC;
    END IF;
END //

DELIMITER ;

-- =============================================================================
--  SECTION D: TRIGGERS
-- =============================================================================

DELIMITER //

-- Trigger 1: Auto-ground aircraft when a test fails
--   After a Fail result is inserted into test_history, the aircraft status
--   is automatically changed to 'Under Maintenance'.
CREATE TRIGGER trg_ground_on_test_fail
AFTER INSERT ON test_history
FOR EACH ROW
BEGIN
    IF NEW.result = 'Fail' THEN
        UPDATE airplanes
        SET    status = 'Under Maintenance'
        WHERE  airplane_id = NEW.airplane_id
          AND  status      = 'Operational';
    END IF;
END //

-- Trigger 2: Validate technician expertise before recording a test
--   Prevents a technician from being assigned to test an aircraft model
--   they are not certified for.
CREATE TRIGGER trg_check_expertise_before_test
BEFORE INSERT ON test_history
FOR EACH ROW
BEGIN
    DECLARE v_model_id  INT;
    DECLARE v_certified INT;

    SELECT model_id INTO v_model_id
    FROM airplanes WHERE airplane_id = NEW.airplane_id;

    SELECT COUNT(*) INTO v_certified
    FROM technician_expertise
    WHERE technician_id = NEW.technician_id
      AND model_id      = v_model_id;

    IF v_certified = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'INTEGRITY ERROR: Technician is not certified for this aircraft model.';
    END IF;
END //

-- Trigger 3: Prevent double-parking
--   Rejects a new parking record if the aircraft is already checked in.
CREATE TRIGGER trg_prevent_double_parking
BEFORE INSERT ON airplane_parking
FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM airplane_parking
    WHERE airplane_id = NEW.airplane_id
      AND date_out    IS NULL;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'INTEGRITY ERROR: Aircraft is already checked into a hangar.';
    END IF;
END //

-- Trigger 4: Auto-cancel tickets when flight is cancelled
CREATE TRIGGER trg_cancel_tickets_on_flight_cancel
AFTER UPDATE ON flights
FOR EACH ROW
BEGIN
    IF NEW.flight_status = 'Cancelled' AND OLD.flight_status <> 'Cancelled' THEN
        UPDATE tickets
        SET    ticket_status = 'Cancelled'
        WHERE  flight_id     = NEW.flight_id
          AND  ticket_status IN ('Confirmed', 'Checked-In');
    END IF;
END //

DELIMITER ;

-- =============================================================================
--  SECTION E: TRANSACTIONS
-- =============================================================================

-- Transaction 1: Book a ticket + record payment atomically
START TRANSACTION;

    INSERT INTO tickets
        (ticket_number, flight_id, passenger_id, booking_class,
         seat_number, price, baggage_kg)
    VALUES
        ('TKT-QR402-001', 15, 7, 'First', '1A', 2800.00, 40.0);

    INSERT INTO payments
        (ticket_id, amount, payment_method, transaction_ref, payment_status)
    VALUES
        (LAST_INSERT_ID(), 2800.00, 'Bank Transfer', 'TXN-QR402-001', 'Completed');

COMMIT;

-- Transaction 2: Schedule maintenance + park aircraft atomically
START TRANSACTION;

    INSERT INTO maintenance_schedules
        (airplane_id, technician_id, scheduled_date, maintenance_type,
         estimated_hours, status, hangar_id, notes)
    VALUES
        (2, 1, '2025-06-15', 'A-Check', 10.00, 'Scheduled', 1,
         'Routine A-Check for TC-YAB');

    -- Aircraft will be parked on the maintenance date; record advance entry
    INSERT INTO airplane_parking
        (airplane_id, hangar_id, date_in, reason, checked_in_by)
    VALUES
        (2, 1, '2025-06-15 08:00:00', 'A-Check Maintenance', 5);

COMMIT;

-- Transaction 3: Rollback demonstration
--   Attempts to record a test for a technician not certified for the model.
--   The trigger trg_check_expertise_before_test fires SQLSTATE 45000 → rollback.
START TRANSACTION;

    -- technician_id=4 (Leyla) is NOT certified for model_id=7 (B772).
    -- Airplane 12 (A7-ALB) is a B772. This insert will be blocked by the trigger.
    INSERT INTO test_history
        (airplane_id, test_id, technician_id, test_date,
         hours_spent, score, result, remarks)
    VALUES
        (12, 1, 4, CURDATE(), 4.0, 88.0, 'Pass',
         'This should be rolled back by trigger.');

ROLLBACK;
-- The ROLLBACK above ensures the invalid record is never committed.
-- In production, the application layer catches the trigger SIGNAL and rolls back.
