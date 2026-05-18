-- =============================================================================
--  CMPE343 — Database Management Systems and Programming I
--  Term Project: Ercan Airport Management Information System
--  Database: ercan_airport
--  MySQL 8.0+   |   Encoding: utf8mb4
-- =============================================================================

DROP DATABASE IF EXISTS ercan_airport;
CREATE DATABASE ercan_airport
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE ercan_airport;

-- =============================================================================
-- TABLE 1: UNIONS
-- Every employee belongs to a union. Stored separately for normalization.
-- =============================================================================
CREATE TABLE unions (
    union_id        INT             UNSIGNED AUTO_INCREMENT,
    union_name      VARCHAR(120)    NOT NULL,
    union_code      VARCHAR(20)     NOT NULL UNIQUE,
    founded_year    YEAR            NOT NULL,
    contact_phone   VARCHAR(20)     NOT NULL,
    monthly_fee     DECIMAL(8,2)    NOT NULL DEFAULT 0.00,
    CONSTRAINT pk_unions    PRIMARY KEY (union_id),
    CONSTRAINT chk_u_fee    CHECK (monthly_fee >= 0)
) ENGINE=InnoDB COMMENT='Aviation labor unions';

-- =============================================================================
-- TABLE 2: DEPARTMENTS
-- Airport organizational units.
-- =============================================================================
CREATE TABLE departments (
    dept_id         INT             UNSIGNED AUTO_INCREMENT,
    dept_name       VARCHAR(100)    NOT NULL UNIQUE,
    dept_code       CHAR(6)         NOT NULL UNIQUE,
    location        VARCHAR(100)    NOT NULL,
    CONSTRAINT pk_depts PRIMARY KEY (dept_id)
) ENGINE=InnoDB COMMENT='Airport departments';

-- =============================================================================
-- TABLE 3: EMPLOYEES  (super-entity — all airport staff)
-- Each employee is uniquely identified by SSN (social_security_no).
-- Each employee belongs to exactly one union → union_membership_no stored here.
-- =============================================================================
CREATE TABLE employees (
    employee_id         INT             UNSIGNED AUTO_INCREMENT,
    social_security_no  VARCHAR(20)     NOT NULL UNIQUE,   -- unique identifier per spec
    first_name          VARCHAR(60)     NOT NULL,
    last_name           VARCHAR(60)     NOT NULL,
    date_of_birth       DATE            NOT NULL,
    gender              ENUM('M','F','Other') NOT NULL,
    phone               VARCHAR(20)     NOT NULL,
    email               VARCHAR(120)    NOT NULL UNIQUE,
    address             VARCHAR(255)    NOT NULL,
    hire_date           DATE            NOT NULL,
    salary              DECIMAL(10,2)   NOT NULL,
    employment_type     ENUM('Full-Time','Part-Time','Contract') NOT NULL DEFAULT 'Full-Time',
    is_active           TINYINT      NOT NULL DEFAULT 1,
    dept_id             INT             UNSIGNED NOT NULL,
    union_id            INT             UNSIGNED NOT NULL,
    union_membership_no VARCHAR(30)     NOT NULL UNIQUE,   -- per spec: store membership number
    CONSTRAINT pk_employees     PRIMARY KEY (employee_id),
    CONSTRAINT fk_emp_dept      FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_emp_union     FOREIGN KEY (union_id)
        REFERENCES unions(union_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_emp_salary   CHECK (salary > 0),
    CONSTRAINT chk_emp_dob      CHECK (date_of_birth < hire_date)
) ENGINE=InnoDB COMMENT='All airport employees; SSN is the natural key';

-- =============================================================================
-- TABLE 4: TECHNICIANS  (sub-entity of employees, 1:1)
-- Technicians test and repair aircraft.
-- =============================================================================
CREATE TABLE technicians (
    technician_id           INT         UNSIGNED AUTO_INCREMENT,
    employee_id             INT         UNSIGNED NOT NULL UNIQUE,   -- 1:1 with employees
    certification_no        VARCHAR(50) NOT NULL UNIQUE,
    specialization          VARCHAR(100) NOT NULL,
    certification_date      DATE        NOT NULL,
    certification_expiry    DATE        NOT NULL,
    years_experience        TINYINT     UNSIGNED NOT NULL DEFAULT 0,
    CONSTRAINT pk_technicians   PRIMARY KEY (technician_id),
    CONSTRAINT fk_tech_emp      FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_tech_dates   CHECK (certification_expiry > certification_date)
) ENGINE=InnoDB COMMENT='Technician-specific data; sub-entity of employees';

-- =============================================================================
-- TABLE 5: TRAFFIC_CONTROLLERS  (sub-entity of employees, 1:1)
-- Per spec: must store date of most recent annual medical exam.
-- =============================================================================
CREATE TABLE traffic_controllers (
    controller_id           INT         UNSIGNED AUTO_INCREMENT,
    employee_id             INT         UNSIGNED NOT NULL UNIQUE,   -- 1:1 with employees
    license_number          VARCHAR(50) NOT NULL UNIQUE,
    license_type            ENUM('Tower','Approach','En-Route','Ground') NOT NULL,
    license_issued_date     DATE        NOT NULL,
    license_expiry_date     DATE        NOT NULL,
    last_medical_exam_date  DATE        NOT NULL,    -- REQUIRED per spec (annual medical exam)
    next_medical_exam_date  DATE        NOT NULL,
    CONSTRAINT pk_controllers   PRIMARY KEY (controller_id),
    CONSTRAINT fk_ctrl_emp      FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_ctrl_license CHECK (license_expiry_date > license_issued_date),
    CONSTRAINT chk_ctrl_medical CHECK (next_medical_exam_date > last_medical_exam_date)
) ENGINE=InnoDB COMMENT='ATC staff; stores annual medical exam dates per spec';

-- =============================================================================
-- TABLE 6: PLANE_MODELS
-- Generic aircraft model specifications (manufacturer, capacity, range…).
-- =============================================================================
CREATE TABLE plane_models (
    model_id            INT         UNSIGNED AUTO_INCREMENT,
    manufacturer        VARCHAR(100) NOT NULL,
    model_name          VARCHAR(100) NOT NULL,
    model_code          VARCHAR(20) NOT NULL UNIQUE,  -- e.g. B738, A20N
    seating_capacity    SMALLINT    UNSIGNED NOT NULL,
    max_range_km        INT         UNSIGNED NOT NULL,
    engine_type         ENUM('Jet','Turboprop','Piston','Electric') NOT NULL DEFAULT 'Jet',
    engine_count        TINYINT     UNSIGNED NOT NULL DEFAULT 2,
    max_altitude_ft     INT         UNSIGNED NOT NULL,
    cruise_speed_kmh    SMALLINT    UNSIGNED NOT NULL,
    CONSTRAINT pk_models        PRIMARY KEY (model_id),
    CONSTRAINT chk_pm_seats     CHECK (seating_capacity > 0),
    CONSTRAINT chk_pm_range     CHECK (max_range_km > 0),
    CONSTRAINT chk_pm_engines   CHECK (engine_count BETWEEN 1 AND 8)
) ENGINE=InnoDB COMMENT='Generic aircraft model specifications';

-- =============================================================================
-- TABLE 7: TECHNICIAN_EXPERTISE  (M:N — technicians ↔ plane_models)
-- Per spec: each technician is an expert on one or more models; expertise may overlap.
-- =============================================================================
CREATE TABLE technician_expertise (
    expertise_id        INT         UNSIGNED AUTO_INCREMENT,
    technician_id       INT         UNSIGNED NOT NULL,
    model_id            INT         UNSIGNED NOT NULL,
    certification_level ENUM('Junior','Senior','Lead') NOT NULL DEFAULT 'Junior',
    certified_date      DATE        NOT NULL,
    CONSTRAINT pk_expertise     PRIMARY KEY (expertise_id),
    CONSTRAINT fk_te_tech       FOREIGN KEY (technician_id)
        REFERENCES technicians(technician_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_te_model      FOREIGN KEY (model_id)
        REFERENCES plane_models(model_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT uq_tech_model    UNIQUE (technician_id, model_id)
) ENGINE=InnoDB COMMENT='M:N — which technician is certified for which model';

-- =============================================================================
-- TABLE 8: AIRLINES
-- Airlines operating flights through Ercan Airport.
-- =============================================================================
CREATE TABLE airlines (
    airline_id      INT         UNSIGNED AUTO_INCREMENT,
    airline_name    VARCHAR(150) NOT NULL UNIQUE,
    iata_code       CHAR(2)     NOT NULL UNIQUE,
    icao_code       CHAR(3)     NOT NULL UNIQUE,
    country         VARCHAR(80) NOT NULL,
    contact_email   VARCHAR(120) NOT NULL,
    contact_phone   VARCHAR(20) NOT NULL,
    is_active       TINYINT  NOT NULL DEFAULT 1,
    CONSTRAINT pk_airlines PRIMARY KEY (airline_id)
) ENGINE=InnoDB COMMENT='Airlines using Ercan Airport';

-- =============================================================================
-- TABLE 9: AIRPLANES  (individual aircraft instances)
-- Per spec: stores plane_no, model_no, capacity and other airplane details.
-- =============================================================================
CREATE TABLE airplanes (
    airplane_id             INT         UNSIGNED AUTO_INCREMENT,
    plane_no                VARCHAR(20) NOT NULL UNIQUE,   -- e.g. TC-YAA (per spec: plane_no)
    model_id                INT         UNSIGNED NOT NULL,
    airline_id              INT         UNSIGNED NOT NULL,
    manufacture_year        YEAR        NOT NULL,
    total_flight_hours      DECIMAL(10,1) NOT NULL DEFAULT 0.0,
    last_inspection_date    DATE        NOT NULL,
    next_inspection_date    DATE        NOT NULL,
    status                  ENUM('Operational','Under Maintenance','Grounded','Retired')
                            NOT NULL DEFAULT 'Operational',
    CONSTRAINT pk_airplanes     PRIMARY KEY (airplane_id),
    CONSTRAINT fk_ap_model      FOREIGN KEY (model_id)
        REFERENCES plane_models(model_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ap_airline    FOREIGN KEY (airline_id)
        REFERENCES airlines(airline_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_ap_insp      CHECK (next_inspection_date > last_inspection_date),
    CONSTRAINT chk_ap_hours     CHECK (total_flight_hours >= 0)
) ENGINE=InnoDB COMMENT='Individual aircraft instances registered at Ercan';

-- =============================================================================
-- TABLE 10: HANGARS
-- Physical hangar locations at Ercan Airport.
-- =============================================================================
CREATE TABLE hangars (
    hangar_id       INT         UNSIGNED AUTO_INCREMENT,
    hangar_no       VARCHAR(10) NOT NULL UNIQUE,    -- per spec: hangar_no
    hangar_name     VARCHAR(100) NOT NULL,
    location        VARCHAR(100) NOT NULL,           -- per spec: location
    capacity        TINYINT     UNSIGNED NOT NULL,
    hangar_type     ENUM('Maintenance','Parking','Storage') NOT NULL DEFAULT 'Parking',
    area_sqm        DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_hangars   PRIMARY KEY (hangar_id),
    CONSTRAINT chk_hg_cap   CHECK (capacity > 0),
    CONSTRAINT chk_hg_area  CHECK (area_sqm > 0)
) ENGINE=InnoDB COMMENT='Hangar facilities at Ercan Airport';

-- =============================================================================
-- TABLE 11: AIRPLANE_PARKING  (airplane ↔ hangar IN/OUT history)
-- Per spec: airplanes are not in hangars forever → store IN and OUT dates/times.
-- =============================================================================
CREATE TABLE airplane_parking (
    parking_id      INT         UNSIGNED AUTO_INCREMENT,
    airplane_id     INT         UNSIGNED NOT NULL,
    hangar_id       INT         UNSIGNED NOT NULL,
    date_in         DATETIME    NOT NULL,             -- per spec: IN date/time
    date_out        DATETIME    NULL,                 -- per spec: OUT date/time (NULL = still parked)
    reason          VARCHAR(255) NOT NULL DEFAULT 'Scheduled Parking',
    checked_in_by   INT         UNSIGNED NOT NULL,    -- employee who recorded check-in
    checked_out_by  INT         UNSIGNED NULL,
    notes           TEXT        NULL,
    CONSTRAINT pk_parking       PRIMARY KEY (parking_id),
    CONSTRAINT fk_pk_airplane   FOREIGN KEY (airplane_id)
        REFERENCES airplanes(airplane_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pk_hangar     FOREIGN KEY (hangar_id)
        REFERENCES hangars(hangar_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pk_in_emp     FOREIGN KEY (checked_in_by)
        REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pk_out_emp    FOREIGN KEY (checked_out_by)
        REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_pk_dates     CHECK (date_out IS NULL OR date_out > date_in)
) ENGINE=InnoDB COMMENT='IN/OUT history of airplanes in hangars — per spec';

-- =============================================================================
-- TABLE 12: TESTS  (master catalog of test types)
-- The airport has a number of tests to ensure airworthiness — per spec.
-- =============================================================================
CREATE TABLE tests (
    test_id         INT         UNSIGNED AUTO_INCREMENT,
    test_code       VARCHAR(20) NOT NULL UNIQUE,
    test_name       VARCHAR(150) NOT NULL,
    test_category   ENUM('Structural','Avionics','Engine','Safety','Navigation','Environmental')
                    NOT NULL,
    description     TEXT        NULL,
    standard_hours  DECIMAL(5,2) NOT NULL,
    passing_score   DECIMAL(5,2) NOT NULL DEFAULT 70.00,
    CONSTRAINT pk_tests         PRIMARY KEY (test_id),
    CONSTRAINT chk_test_hrs     CHECK (standard_hours > 0),
    CONSTRAINT chk_test_score   CHECK (passing_score BETWEEN 0 AND 100)
) ENGINE=InnoDB COMMENT='Catalog of airworthiness tests — per spec';

-- =============================================================================
-- TABLE 13: TEST_HISTORY  (per spec core requirement)
-- Tracks each time a given airplane is tested by a given technician using a given test.
-- Stores: date, hours spent by technician, score received by airplane.
-- =============================================================================
CREATE TABLE test_history (
    history_id      INT         UNSIGNED AUTO_INCREMENT,
    airplane_id     INT         UNSIGNED NOT NULL,
    test_id         INT         UNSIGNED NOT NULL,
    technician_id   INT         UNSIGNED NOT NULL,
    test_date       DATE        NOT NULL,             -- per spec: date
    hours_spent     DECIMAL(6,2) NOT NULL,            -- per spec: hours technician spent
    score           DECIMAL(5,2) NOT NULL,            -- per spec: score airplane received
    result          ENUM('Pass','Fail','Inconclusive') NOT NULL,
    remarks         TEXT        NULL,
    approved_by     INT         UNSIGNED NULL,
    CONSTRAINT pk_test_hist     PRIMARY KEY (history_id),
    CONSTRAINT fk_th_airplane   FOREIGN KEY (airplane_id)
        REFERENCES airplanes(airplane_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_th_test       FOREIGN KEY (test_id)
        REFERENCES tests(test_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_th_tech       FOREIGN KEY (technician_id)
        REFERENCES technicians(technician_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_th_approver   FOREIGN KEY (approved_by)
        REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_th_hours     CHECK (hours_spent > 0),
    CONSTRAINT chk_th_score     CHECK (score BETWEEN 0 AND 100)
) ENGINE=InnoDB COMMENT='Per-airplane test execution records — per spec';

-- =============================================================================
-- TABLE 14: MAINTENANCE_SCHEDULES  (extended feature)
-- =============================================================================
CREATE TABLE maintenance_schedules (
    schedule_id         INT         UNSIGNED AUTO_INCREMENT,
    airplane_id         INT         UNSIGNED NOT NULL,
    technician_id       INT         UNSIGNED NOT NULL,
    scheduled_date      DATE        NOT NULL,
    maintenance_type    ENUM('A-Check','B-Check','C-Check','D-Check','Emergency','Repair')
                        NOT NULL,
    estimated_hours     DECIMAL(6,2) NOT NULL,
    actual_hours        DECIMAL(6,2) NULL,
    status              ENUM('Scheduled','In Progress','Completed','Cancelled')
                        NOT NULL DEFAULT 'Scheduled',
    hangar_id           INT         UNSIGNED NULL,
    notes               TEXT        NULL,
    CONSTRAINT pk_maint         PRIMARY KEY (schedule_id),
    CONSTRAINT fk_ms_airplane   FOREIGN KEY (airplane_id)
        REFERENCES airplanes(airplane_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ms_tech       FOREIGN KEY (technician_id)
        REFERENCES technicians(technician_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_ms_hangar     FOREIGN KEY (hangar_id)
        REFERENCES hangars(hangar_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_ms_hrs       CHECK (estimated_hours > 0)
) ENGINE=InnoDB COMMENT='Scheduled maintenance events per aircraft';

-- =============================================================================
-- TABLE 15: REPAIRS  (extended feature — with auto-calculated total_cost)
-- =============================================================================
CREATE TABLE repairs (
    repair_id       INT         UNSIGNED AUTO_INCREMENT,
    airplane_id     INT         UNSIGNED NOT NULL,
    technician_id   INT         UNSIGNED NOT NULL,
    schedule_id     INT         UNSIGNED NULL,
    repair_date     DATE        NOT NULL,
    repair_type     VARCHAR(100) NOT NULL,
    description     TEXT        NOT NULL,
    parts_cost      DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    labor_cost      DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    total_cost      DECIMAL(12,2) GENERATED ALWAYS AS (parts_cost + labor_cost) STORED,
    status          ENUM('Pending','In Progress','Completed') NOT NULL DEFAULT 'Pending',
    CONSTRAINT pk_repairs       PRIMARY KEY (repair_id),
    CONSTRAINT fk_rep_airplane  FOREIGN KEY (airplane_id)
        REFERENCES airplanes(airplane_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_rep_tech      FOREIGN KEY (technician_id)
        REFERENCES technicians(technician_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_rep_sched     FOREIGN KEY (schedule_id)
        REFERENCES maintenance_schedules(schedule_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_rep_costs    CHECK (parts_cost >= 0 AND labor_cost >= 0)
) ENGINE=InnoDB COMMENT='Repair work orders — total_cost is a generated column';

-- =============================================================================
-- TABLE 16: RUNWAYS  (extended feature)
-- =============================================================================
CREATE TABLE runways (
    runway_id       INT         UNSIGNED AUTO_INCREMENT,
    runway_code     VARCHAR(10) NOT NULL UNIQUE,
    length_m        INT         UNSIGNED NOT NULL,
    width_m         SMALLINT    UNSIGNED NOT NULL,
    surface_type    ENUM('Asphalt','Concrete','Gravel') NOT NULL DEFAULT 'Asphalt',
    ils_available   TINYINT  NOT NULL DEFAULT 0,
    status          ENUM('Active','Closed','Under Repair') NOT NULL DEFAULT 'Active',
    CONSTRAINT pk_runways   PRIMARY KEY (runway_id),
    CONSTRAINT chk_rw_len   CHECK (length_m > 0),
    CONSTRAINT chk_rw_wid   CHECK (width_m  > 0)
) ENGINE=InnoDB COMMENT='Runway inventory at Ercan Airport';

-- =============================================================================
-- TABLE 17: GATES  (extended feature)
-- =============================================================================
CREATE TABLE gates (
    gate_id             INT         UNSIGNED AUTO_INCREMENT,
    gate_code           VARCHAR(10) NOT NULL UNIQUE,
    terminal            VARCHAR(10) NOT NULL,
    gate_type           ENUM('Domestic','International','Both') NOT NULL DEFAULT 'Both',
    has_jetbridge       TINYINT  NOT NULL DEFAULT 1,
    max_aircraft_size   ENUM('Small','Medium','Large','Wide-Body') NOT NULL DEFAULT 'Medium',
    status              ENUM('Active','Closed','Under Maintenance') NOT NULL DEFAULT 'Active',
    CONSTRAINT pk_gates PRIMARY KEY (gate_id)
) ENGINE=InnoDB COMMENT='Departure/arrival gates';

-- =============================================================================
-- TABLE 18: PILOTS  (sub-entity of employees, extended feature)
-- =============================================================================
CREATE TABLE pilots (
    pilot_id                INT         UNSIGNED AUTO_INCREMENT,
    employee_id             INT         UNSIGNED NOT NULL UNIQUE,
    license_number          VARCHAR(50) NOT NULL UNIQUE,
    license_class           ENUM('ATP','Commercial','Private') NOT NULL DEFAULT 'ATP',
    total_flight_hours      DECIMAL(8,1) NOT NULL DEFAULT 0.0,
    medical_cert_expiry     DATE        NOT NULL,
    last_proficiency_check  DATE        NOT NULL,
    CONSTRAINT pk_pilots        PRIMARY KEY (pilot_id),
    CONSTRAINT fk_pilot_emp     FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_pilot_hrs    CHECK (total_flight_hours >= 0)
) ENGINE=InnoDB COMMENT='Pilot-specific data; sub-entity of employees';

-- =============================================================================
-- TABLE 19: FLIGHTS  (extended feature)
-- =============================================================================
CREATE TABLE flights (
    flight_id               INT         UNSIGNED AUTO_INCREMENT,
    flight_number           VARCHAR(10) NOT NULL,
    airline_id              INT         UNSIGNED NOT NULL,
    airplane_id             INT         UNSIGNED NOT NULL,
    origin_iata             CHAR(3)     NOT NULL,
    destination_iata        CHAR(3)     NOT NULL,
    scheduled_departure     DATETIME    NOT NULL,
    scheduled_arrival       DATETIME    NOT NULL,
    actual_departure        DATETIME    NULL,
    actual_arrival          DATETIME    NULL,
    departure_gate_id       INT         UNSIGNED NULL,
    arrival_gate_id         INT         UNSIGNED NULL,
    runway_id               INT         UNSIGNED NULL,
    flight_status           ENUM('Scheduled','Boarding','Departed','In Air',
                                 'Landed','Delayed','Cancelled')
                            NOT NULL DEFAULT 'Scheduled',
    delay_minutes           SMALLINT    UNSIGNED NOT NULL DEFAULT 0,
    CONSTRAINT pk_flights       PRIMARY KEY (flight_id),
    CONSTRAINT fk_fl_airline    FOREIGN KEY (airline_id)
        REFERENCES airlines(airline_id)    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_fl_airplane   FOREIGN KEY (airplane_id)
        REFERENCES airplanes(airplane_id)  ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_fl_dep_gate   FOREIGN KEY (departure_gate_id)
        REFERENCES gates(gate_id)          ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_fl_arr_gate   FOREIGN KEY (arrival_gate_id)
        REFERENCES gates(gate_id)          ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_fl_runway     FOREIGN KEY (runway_id)
        REFERENCES runways(runway_id)      ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_fl_times     CHECK (scheduled_arrival > scheduled_departure),
    CONSTRAINT chk_fl_iata      CHECK (origin_iata <> destination_iata),
    UNIQUE KEY uq_flight_dep (flight_number, scheduled_departure)
) ENGINE=InnoDB COMMENT='Flight schedule and status';

-- =============================================================================
-- TABLE 20: FLIGHT_CREW  (M:N — flights ↔ employees, extended feature)
-- =============================================================================
CREATE TABLE flight_crew (
    crew_id         INT         UNSIGNED AUTO_INCREMENT,
    flight_id       INT         UNSIGNED NOT NULL,
    employee_id     INT         UNSIGNED NOT NULL,
    crew_role       ENUM('Captain','First Officer','Flight Engineer','Purser','Cabin Crew')
                    NOT NULL,
    CONSTRAINT pk_crew      PRIMARY KEY (crew_id),
    CONSTRAINT fk_fc_flight FOREIGN KEY (flight_id)
        REFERENCES flights(flight_id)      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_fc_emp    FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)  ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE KEY uq_crew_flight (flight_id, employee_id)
) ENGINE=InnoDB COMMENT='Crew assignments per flight';

-- =============================================================================
-- TABLE 21: PASSENGERS  (extended feature)
-- =============================================================================
CREATE TABLE passengers (
    passenger_id    INT         UNSIGNED AUTO_INCREMENT,
    passport_no     VARCHAR(30) NOT NULL UNIQUE,
    first_name      VARCHAR(60) NOT NULL,
    last_name       VARCHAR(60) NOT NULL,
    date_of_birth   DATE        NOT NULL,
    nationality     VARCHAR(60) NOT NULL,
    gender          ENUM('M','F','Other') NOT NULL,
    email           VARCHAR(120) NOT NULL,
    phone           VARCHAR(20) NOT NULL,
    frequent_flyer_no VARCHAR(30) NULL UNIQUE,
    CONSTRAINT pk_passengers    PRIMARY KEY (passenger_id),
    CONSTRAINT chk_pass_dob     CHECK (date_of_birth < '2010-01-01')
) ENGINE=InnoDB COMMENT='Passenger registry';

-- =============================================================================
-- TABLE 22: TICKETS  (extended feature)
-- =============================================================================
CREATE TABLE tickets (
    ticket_id       INT         UNSIGNED AUTO_INCREMENT,
    ticket_number   VARCHAR(30) NOT NULL UNIQUE,
    flight_id       INT         UNSIGNED NOT NULL,
    passenger_id    INT         UNSIGNED NOT NULL,
    booking_class   ENUM('Economy','Business','First') NOT NULL DEFAULT 'Economy',
    seat_number     VARCHAR(5)  NOT NULL,
    price           DECIMAL(10,2) NOT NULL,
    booking_date    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ticket_status   ENUM('Confirmed','Checked-In','Boarded','No-Show','Cancelled')
                    NOT NULL DEFAULT 'Confirmed',
    baggage_kg      DECIMAL(5,1) NOT NULL DEFAULT 23.0,
    CONSTRAINT pk_tickets       PRIMARY KEY (ticket_id),
    CONSTRAINT fk_tk_flight     FOREIGN KEY (flight_id)
        REFERENCES flights(flight_id)       ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_tk_pass       FOREIGN KEY (passenger_id)
        REFERENCES passengers(passenger_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_tk_price     CHECK (price > 0),
    CONSTRAINT chk_tk_baggage   CHECK (baggage_kg >= 0),
    UNIQUE KEY uq_flight_seat (flight_id, seat_number)
) ENGINE=InnoDB COMMENT='Passenger ticket records';

-- =============================================================================
-- TABLE 23: PAYMENTS  (extended feature)
-- =============================================================================
CREATE TABLE payments (
    payment_id      INT         UNSIGNED AUTO_INCREMENT,
    ticket_id       INT         UNSIGNED NOT NULL,
    amount          DECIMAL(10,2) NOT NULL,
    payment_method  ENUM('Credit Card','Debit Card','Bank Transfer','Cash','Voucher')
                    NOT NULL,
    payment_date    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transaction_ref VARCHAR(80) NOT NULL UNIQUE,
    payment_status  ENUM('Pending','Completed','Refunded','Failed') NOT NULL DEFAULT 'Pending',
    CONSTRAINT pk_payments      PRIMARY KEY (payment_id),
    CONSTRAINT fk_pay_ticket    FOREIGN KEY (ticket_id)
        REFERENCES tickets(ticket_id)  ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_pay_amount   CHECK (amount > 0)
) ENGINE=InnoDB COMMENT='Payment transactions for tickets';

-- =============================================================================
-- INDEXES  — on all FK columns and frequently filtered fields
-- =============================================================================
CREATE INDEX idx_emp_dept            ON employees(dept_id);
CREATE INDEX idx_emp_union           ON employees(union_id);
CREATE INDEX idx_emp_active          ON employees(is_active);
CREATE INDEX idx_ap_model            ON airplanes(model_id);
CREATE INDEX idx_ap_airline          ON airplanes(airline_id);
CREATE INDEX idx_ap_status           ON airplanes(status);
CREATE INDEX idx_parking_airplane    ON airplane_parking(airplane_id);
CREATE INDEX idx_parking_hangar      ON airplane_parking(hangar_id);
CREATE INDEX idx_parking_open        ON airplane_parking(date_out);
CREATE INDEX idx_th_airplane         ON test_history(airplane_id);
CREATE INDEX idx_th_technician       ON test_history(technician_id);
CREATE INDEX idx_th_date             ON test_history(test_date);
CREATE INDEX idx_th_result           ON test_history(result);
CREATE INDEX idx_fl_airline          ON flights(airline_id);
CREATE INDEX idx_fl_airplane         ON flights(airplane_id);
CREATE INDEX idx_fl_status           ON flights(flight_status);
CREATE INDEX idx_fl_dep_date         ON flights(scheduled_departure);
CREATE INDEX idx_tk_flight           ON tickets(flight_id);
CREATE INDEX idx_tk_passenger        ON tickets(passenger_id);
CREATE INDEX idx_ms_airplane         ON maintenance_schedules(airplane_id);
CREATE INDEX idx_ms_status           ON maintenance_schedules(status);
