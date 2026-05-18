#  Ercan Airport Management Information System


> **CMPE343 — Database Management Systems and Programming I**  
> Term Project  
> Ercan Airport Management Information System — MySQL 8.0+
>Student Number |   Name               | Group
>     22312336  |LAITH Y A FARARJEH    | 2
>     22326035  |AUGUSTIN KABWE KALIMBA| 2
>     22213119  |Ahmad Haj Kasem       | 2

https://github.com/laith22312336/ercan-airport-db 
---

##  Table of Contents

- [Project Overview](#-project-overview)
- [Features](#-features)
- [Database Schema](#-database-schema)
- [ERD Overview](#-erd-overview)
- [Technologies](#-technologies)
- [Setup Instructions](#-setup-instructions)
- [Sample Queries](#-sample-queries)
- [Advanced Features](#-advanced-features)
- [Contributors](#-contributors)

---

##  Project Overview

This project designs and implements a full **Relational Database Management System (RDBMS)** for **Ercan Airport** that stores, manipulates, and retrieves all airport-related information.

The system covers all requirements stated in the CMPE343 specification:

| Requirement | Implementation |
|---|---|
| Airplane information (plane_no, model_no, capacity) |  `airplanes` + `plane_models` tables |
| Hangar locations with IN/OUT dates |  `hangars` + `airplane_parking` tables |
| Periodic airworthiness tests |  `tests` catalog table |
| Test tracking (date, hours, score) per airplane/technician/test |  `test_history` table |
| Technician expertise on plane models (M:N) |  `technician_expertise` bridge table |
| Traffic controller annual medical exam date |  `traffic_controllers.last_medical_exam_date` |
| Union membership number per employee |  `employees.union_membership_no` |
| SSN as unique employee identifier |  `employees.social_security_no UNIQUE` |
| At least 8 tables |  23 tables total |
| 15 management queries |  Implemented in `03_QUERIES_VIEWS_PROCEDURES.sql` |

---

##  Features

### Core (Per Specification)
-  **Aircraft Registry** — `plane_no`, model specifications, airline ownership, operational status
-  **Hangar & Parking** — Full IN/OUT history (`date_in`, `date_out`) per aircraft per hangar
-  **Airworthiness Tests** — Structured test catalog; every test event records date, hours, and score
-  **Technician Management** — Expertise matrix (M:N) linking technicians to certified plane models
-  **Traffic Controllers** — Annual medical exam date tracking with renewal alerts
-  **Union Membership** — Every employee linked to a union with a unique membership number
-  **SSN Identity** — Each employee uniquely identified by `social_security_no`

### Extended Features (Above Minimum)
-  **Flights** — Schedule, status, gate and runway assignments
-  **Passengers & Tickets** — Booking lifecycle, seat assignment, payment records
-  **Pilots** — License, flight hours, proficiency checks
-  **Maintenance Schedules** — A/B/C/D-Check planning
-  **Repairs** — Work orders with auto-calculated `total_cost` (generated column)
-  **Runways & Gates** — Physical infrastructure management

---

##  Database Schema

The database contains **23 tables** across 5 modules:

```
ercan_airport
│
├── HR Module (Core)
│   ├── unions                  — Labor unions
│   ├── departments             — Organizational units
│   └── employees               — All staff; SSN + union_membership_no per spec
│
├── Specialist Sub-Entities (Core)
│   ├── technicians             — 1:1 with employees; EASA certification
│   ├── traffic_controllers     — 1:1 with employees; annual medical exam date
│   └── pilots                  — 1:1 with employees (extended)
│
├── Fleet Module (Core)
│   ├── plane_models            — Generic model specs (B738, A20N…)
│   ├── airlines                — Airline operators
│   ├── airplanes               — Individual aircraft (plane_no per spec)
│   ├── hangars                 — Hangar_no + location per spec
│   └── airplane_parking        — IN/OUT history (date_in, date_out per spec)
│
├── Maintenance & Testing Module (Core)
│   ├── tests                   — Test catalog (per spec)
│   ├── technician_expertise    — M:N technician ↔ plane model (per spec)
│   ├── test_history            — date + hours_spent + score per spec
│   ├── maintenance_schedules   — A/B/C/D-Check scheduling
│   └── repairs                 — Repair work orders
│
└── Operations & Commercial Module (Extended)
    ├── runways
    ├── gates
    ├── flights
    ├── flight_crew             — M:N flights ↔ employees
    ├── passengers
    ├── tickets
    └── payments
```

---

##  ERD Overview

### Key Relationships

| Entity A | Entity B | Type | Bridge Table / FK |
|---|---|---|---|
| employees | technicians | 1:1 | `technicians.employee_id UNIQUE` |
| employees | traffic_controllers | 1:1 | `traffic_controllers.employee_id UNIQUE` |
| employees | pilots | 1:1 | `pilots.employee_id UNIQUE` |
| employees | unions | M:1 | `employees.union_id` + `union_membership_no` |
| technicians | plane_models | **M:N** | `technician_expertise` |
| airplanes | hangars | **M:N (history)** | `airplane_parking` (date_in / date_out) |
| airplanes | tests | **M:N (history)** | `test_history` |
| flights | employees | **M:N** | `flight_crew` |
| flights | passengers | **M:N** | `tickets` |
| tickets | payments | 1:M | `payments.ticket_id` |

> **Tip:** Import `01_DDL.sql` into **MySQL Workbench** → Database → Reverse Engineer to auto-generate the visual ERD.

---

##  Technologies

- **RDBMS:** MySQL 8.0+
- **SQL Features:**
  - DDL: `CREATE`, `ALTER`, `DROP`, named `CONSTRAINT`
  - DML: `INSERT`, `UPDATE`, `DELETE`
  - DQL: `SELECT` with `JOIN`, `GROUP BY`, `HAVING`, `ORDER BY`, `EXISTS`, `NOT IN`, subqueries, window functions (`RANK OVER`)
  - Advanced: Views, Stored Procedures, Triggers (`SIGNAL SQLSTATE`), Transactions
  - Generated column: `repairs.total_cost`
- **Normalization:** 3NF throughout

USE ercan_airport;

SHOW TABLES;                        -- 23 tables expected
SELECT COUNT(*) FROM employees;     -- 30
SELECT COUNT(*) FROM airplanes;     -- 15
SELECT COUNT(*) FROM test_history;  -- 20
SELECT COUNT(*) FROM flights;       -- 15
```

---

##  Sample Queries

### Q3 — Aircraft Currently in Hangars
```sql
SELECT a.plane_no, h.hangar_no, p.date_in, p.reason,
       TIMESTAMPDIFF(HOUR, p.date_in, NOW()) AS hours_in_hangar
FROM airplane_parking p
JOIN airplanes a ON p.airplane_id = a.airplane_id
JOIN hangars   h ON p.hangar_id   = h.hangar_id
WHERE p.date_out IS NULL;
```

### Q6 — Aircraft With Test Failures (EXISTS)
```sql
SELECT a.plane_no, a.status
FROM airplanes a
WHERE EXISTS (
    SELECT 1 FROM test_history th
    WHERE th.airplane_id = a.airplane_id AND th.result = 'Fail'
);
```

### Q8 — Controller Medical Exam Status (per spec)
```sql
SELECT CONCAT(e.first_name,' ',e.last_name) AS controller,
       tc.last_medical_exam_date,
       tc.next_medical_exam_date,
       DATEDIFF(tc.next_medical_exam_date, CURDATE()) AS days_until_exam
FROM traffic_controllers tc
JOIN employees e ON tc.employee_id = e.employee_id
ORDER BY days_until_exam;
```

### Q13 — Models With No Certified Technician (NOT IN)
```sql
SELECT pm.model_code, CONCAT(pm.manufacturer,' ',pm.model_name) AS model
FROM plane_models pm
WHERE pm.model_id NOT IN (
    SELECT DISTINCT model_id FROM technician_expertise
);
```

---

##  Advanced Features

### Views (5 total)
| View | Purpose |
|---|---|
| `vw_active_fleet` | Operational aircraft with days to next inspection |
| `vw_hangar_occupancy` | Real-time hangar capacity and aircraft list |
| `vw_controller_exam_status` | ATC medical exam validity with alerts |
| `vw_test_history_full` | Test history joined with all names |
| `vw_flight_revenue` | Revenue per flight by booking class |

### Stored Procedures (4 total)
| Procedure | Purpose |
|---|---|
| `sp_park_aircraft(plane_no, hangar_no, reason, emp_ssn, OUT msg)` | Park with capacity check |
| `sp_release_aircraft(plane_no, emp_ssn, OUT msg)` | Release from hangar |
| `sp_record_test(plane_no, test_code, cert_no, date, hours, score, remarks)` | Record test with auto pass/fail |
| `sp_aircraft_history(plane_no)` | Full hangar + test + repair history |

### Triggers (4 total)
| Trigger | Event | Purpose |
|---|---|---|
| `trg_ground_on_test_fail` | AFTER INSERT test_history | Auto-grounds aircraft on Fail result |
| `trg_check_expertise_before_test` | BEFORE INSERT test_history | Blocks uncertified technician (SIGNAL 45000) |
| `trg_prevent_double_parking` | BEFORE INSERT airplane_parking | Prevents duplicate parking |
| `trg_cancel_tickets_on_flight_cancel` | AFTER UPDATE flights | Auto-cancels tickets on cancellation |

### Transactions
1. **Ticket + Payment** — atomic booking insert
2. **Maintenance + Parking** — atomic schedule + hangar allocation
3. **Rollback Demo** — trigger-blocked insert with full rollback

---

##  Contributors

| Name | Student No | Role |
|---|---|---|
| [Member 1] | [No] | ERD Design, DDL, Normalization |
| [Member 2] | [No] | DML, Sample Data |
| [Member 3] | [No] | SQL Queries (Q1–Q8) |
| [Member 4] | [No] | SQL Queries (Q9–Q15), Views, Procedures |

---

##  Notes

- All monetary values in **Turkish Lira (TRY)**
- All `DATETIME` values in **UTC**
- Employee soft-delete via `is_active` flag (preserves FK integrity)
- IATA/ICAO codes follow industry standard conventions
- `repairs.total_cost` is a **MySQL GENERATED ALWAYS** column


