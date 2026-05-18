-- =============================================================================
--  CMPE343 — Ercan Airport Management Information System
--  DML Script — Sample Data
-- =============================================================================

USE ercan_airport;

SET FOREIGN_KEY_CHECKS = 0;

-- =============================================================================
-- UNIONS  (5 records)
-- =============================================================================
INSERT INTO unions (union_name, union_code, founded_year, contact_phone, monthly_fee) VALUES
('Aviation Workers Union of Cyprus',    'AWUC',  1980, '+35722123456', 45.00),
('Aircraft Technicians Federation',     'ATF',   1985, '+35722123457', 65.00),
('Air Traffic Controllers Association', 'ATCA',  1972, '+35722123458', 80.00),
('Ground & Cargo Services Union',       'GCSU',  1991, '+35722123459', 40.00),
('Pilots and Cabin Crew Association',   'PCCA',  1976, '+35722123460', 110.00);

-- =============================================================================
-- DEPARTMENTS  (8 records)
-- =============================================================================
INSERT INTO departments (dept_name, dept_code, location) VALUES
('Flight Operations',      'FLOPS', 'Terminal Building, Floor 3'),
('Aircraft Maintenance',   'AMNT',  'Maintenance Hangar Complex'),
('Air Traffic Control',    'ATC',   'ATC Tower, Level 5'),
('Ground Services',        'GRND',  'Terminal Building, Ground Floor'),
('Passenger Services',     'PASV',  'Terminal Building, Floor 1'),
('Cargo Operations',       'CARGO', 'Cargo Terminal'),
('Security',               'SEC',   'Central Security Hub'),
('Administration',         'ADMIN', 'Administrative Block, Floor 2');

-- =============================================================================
-- EMPLOYEES  (30 records)
-- SSN is the unique natural identifier per project specification.
-- =============================================================================
INSERT INTO employees
    (social_security_no, first_name, last_name, date_of_birth, gender,
     phone, email, address, hire_date, salary, employment_type,
     dept_id, union_id, union_membership_no)
VALUES
-- Flight Operations (dept 1) — include pilots
('SSN-CY-00001','Mehmet',  'Yılmaz',   '1972-03-14','M','+905321100001','m.yilmaz@ercan.cy',  'Lefkoşa, Atatürk St 14',   '2000-06-01',21000.00,'Full-Time',1,5,'PCCA-2000-001'),
('SSN-CY-00002','Ayşe',    'Kara',     '1980-07-22','F','+905321100002','a.kara@ercan.cy',    'Gazimağusa, Cumhuriyet 8', '2006-09-15',18500.00,'Full-Time',1,5,'PCCA-2006-001'),
('SSN-CY-00003','Hasan',   'Güneş',    '1978-11-05','M','+905321100003','h.gunes@ercan.cy',   'Girne, İnönü Cd 22',       '2004-02-20',19000.00,'Full-Time',1,5,'PCCA-2004-001'),
('SSN-CY-00004','Serhat',  'Arslan',   '1984-05-18','M','+905321100004','s.arslan@ercan.cy',  'Lefkoşa, Mavi St 9',       '2010-07-01',16500.00,'Full-Time',1,5,'PCCA-2010-001'),
-- Aircraft Maintenance (dept 2) — technicians
('SSN-CY-00005','Cengiz',  'Özdemir',  '1975-01-30','M','+905321100005','c.ozdemir@ercan.cy', 'Lefkoşa, Güneş Ave 5',    '2003-04-10',15200.00,'Full-Time',2,2,'ATF-2003-001'),
('SSN-CY-00006','Fatma',   'Çelik',    '1983-09-25','F','+905321100006','f.celik@ercan.cy',   'Gazimağusa, Zafer Cd 17', '2009-01-20',13800.00,'Full-Time',2,2,'ATF-2009-001'),
('SSN-CY-00007','Kemal',   'Demir',    '1979-12-03','M','+905321100007','k.demir@ercan.cy',   'Girne, Pınar St 3',       '2007-03-15',14500.00,'Full-Time',2,2,'ATF-2007-001'),
('SSN-CY-00008','Leyla',   'Şahin',    '1988-06-14','F','+905321100008','l.sahin@ercan.cy',   'Lefkoşa, Akdağ Blvd 21',  '2014-05-01',12800.00,'Full-Time',2,2,'ATF-2014-001'),
('SSN-CY-00009','Burak',   'Koç',      '1981-04-28','M','+905321100009','b.koc@ercan.cy',     'Gazimağusa, Deniz Cd 6',  '2008-11-10',14000.00,'Full-Time',2,2,'ATF-2008-001'),
('SSN-CY-00010','Zeynep',  'Kurt',     '1986-02-09','F','+905321100010','z.kurt@ercan.cy',    'Lefkoşa, Çiçek St 33',    '2012-07-01',13200.00,'Full-Time',2,2,'ATF-2012-001'),
-- ATC (dept 3) — traffic controllers
('SSN-CY-00011','Taner',   'Polat',    '1977-08-17','M','+905321100011','t.polat@ercan.cy',   'Girne, Kayalık Cd 11',    '2003-02-15',16800.00,'Full-Time',3,3,'ATCA-2003-001'),
('SSN-CY-00012','Elif',    'Yıldız',   '1985-10-31','F','+905321100012','e.yildiz@ercan.cy',  'Lefkoşa, Bahar Ave 44',   '2011-09-01',15300.00,'Full-Time',3,3,'ATCA-2011-001'),
('SSN-CY-00013','Orhan',   'Bulut',    '1980-01-22','M','+905321100013','o.bulut@ercan.cy',   'Gazimağusa, Marmara St 2','2005-05-01',17200.00,'Full-Time',3,3,'ATCA-2005-001'),
('SSN-CY-00014','Derya',   'Aydın',    '1990-07-08','F','+905321100014','d.aydin@ercan.cy',   'Lefkoşa, Lale St 18',     '2017-03-01',13500.00,'Full-Time',3,3,'ATCA-2017-001'),
-- Ground Services (dept 4)
('SSN-CY-00015','Volkan',  'Toprak',   '1982-03-19','M','+905321100015','v.toprak@ercan.cy',  'Girne, Bağlar Cd 7',      '2009-10-15',11800.00,'Full-Time',4,1,'AWUC-2009-001'),
('SSN-CY-00016','Gönül',   'Özcan',    '1991-05-27','F','+905321100016','g.ozcan@ercan.cy',   'Lefkoşa, Zafer Ave 55',   '2015-06-20',10500.00,'Full-Time',4,1,'AWUC-2015-001'),
('SSN-CY-00017','Murat',   'Kaplan',   '1987-09-04','M','+905321100017','m.kaplan@ercan.cy',  'Gazimağusa, Meşe St 12',  '2013-08-01',11200.00,'Full-Time',4,4,'GCSU-2013-001'),
('SSN-CY-00018','Selin',   'Şimşek',   '1993-11-16','F','+905321100018','s.simsek@ercan.cy',  'Lefkoşa, Kavak Blvd 29',  '2019-01-15',10000.00,'Full-Time',4,4,'GCSU-2019-001'),
-- Passenger Services (dept 5)
('SSN-CY-00019','Emre',    'Erdoğan',  '1989-04-07','M','+905321100019','e.erdogan@ercan.cy', 'Girne, Çam St 3',         '2016-12-01',10800.00,'Full-Time',5,1,'AWUC-2016-001'),
('SSN-CY-00020','Nihan',   'Ceylan',   '1994-08-21','F','+905321100020','n.ceylan@ercan.cy',  'Lefkoşa, Bahar Ave 16',   '2020-07-15',9500.00, 'Full-Time',5,1,'AWUC-2020-001'),
-- Cargo Operations (dept 6)
('SSN-CY-00021','Alper',   'Başaran',  '1983-02-14','M','+905321100021','a.basaran@ercan.cy', 'Gazimağusa, Akçay St 8',  '2009-03-01',12500.00,'Full-Time',6,4,'GCSU-2009-002'),
('SSN-CY-00022','Pınar',   'Kılıç',    '1990-06-30','F','+905321100022','p.kilic@ercan.cy',   'Lefkoşa, Pınar Blvd 41',  '2016-02-01',11000.00,'Full-Time',6,4,'GCSU-2016-001'),
-- Security (dept 7)
('SSN-CY-00023','Cem',     'Doğan',    '1980-12-05','M','+905321100023','c.dogan@ercan.cy',   'Girne, Akdağ St 14',      '2007-05-20',13000.00,'Full-Time',7,1,'AWUC-2007-001'),
('SSN-CY-00024','Neslihan','Tuncer',    '1988-03-18','F','+905321100024','n.tuncer@ercan.cy',  'Lefkoşa, Kavaklar Cd 25', '2014-11-10',12000.00,'Full-Time',7,1,'AWUC-2014-001'),
-- Administration (dept 8)
('SSN-CY-00025','Ahmet',   'Sönmez',   '1976-07-11','M','+905321100025','a.sonmez@ercan.cy',  'Gazimağusa, Dağ St 6',    '2004-04-01',14200.00,'Full-Time',8,1,'AWUC-2004-001'),
('SSN-CY-00026','Burcu',   'Karabey',  '1985-01-25','F','+905321100026','b.karabey@ercan.cy', 'Lefkoşa, Nehir Blvd 9',   '2012-08-20',13500.00,'Full-Time',8,1,'AWUC-2012-001'),
-- Additional maintenance technicians
('SSN-CY-00027','İlker',   'Sarı',     '1982-09-09','M','+905321100027','i.sari@ercan.cy',    'Girne, Bozkır St 32',     '2010-01-05',14300.00,'Full-Time',2,2,'ATF-2010-001'),
('SSN-CY-00028','Özge',    'Yıldırım', '1992-04-22','F','+905321100028','o.yildirim@ercan.cy','Lefkoşa, Kestane Ave 17', '2018-06-15',12000.00,'Full-Time',2,2,'ATF-2018-001'),
-- Additional pilots
('SSN-CY-00029','Tarık',   'Arslan',   '1975-10-15','M','+905321100029','t.arslan2@ercan.cy', 'Gazimağusa, Saray St 4',  '2002-09-01',20000.00,'Full-Time',1,5,'PCCA-2002-001'),
('SSN-CY-00030','Gizem',   'Öztürk',   '1987-05-28','F','+905321100030','g.ozturk@ercan.cy',  'Lefkoşa, Orman Cd 21',    '2014-10-01',17500.00,'Full-Time',1,5,'PCCA-2014-001');

-- =============================================================================
-- TECHNICIANS  (employees from dept 2 + some extra)
-- =============================================================================
INSERT INTO technicians
    (employee_id, certification_no, specialization, certification_date, certification_expiry, years_experience)
VALUES
(5,  'CERT-EASA-001', 'Avionics Systems',       '2003-04-10', '2028-04-10', 22),
(6,  'CERT-EASA-002', 'Engine Overhaul',        '2009-01-20', '2029-01-20', 15),
(7,  'CERT-EASA-003', 'Structural Inspection',  '2007-03-15', '2027-03-15', 17),
(8,  'CERT-EASA-004', 'Hydraulics & Landing',   '2014-05-01', '2029-05-01', 10),
(9,  'CERT-EASA-005', 'Electrical Systems',     '2008-11-10', '2028-11-10', 16),
(10, 'CERT-EASA-006', 'Navigation Systems',     '2012-07-01', '2027-07-01', 12),
(27, 'CERT-EASA-007', 'Fuel & Propulsion',      '2010-01-05', '2030-01-05', 14),
(28, 'CERT-EASA-008', 'Composite Structures',   '2018-06-15', '2033-06-15',  6);

-- =============================================================================
-- TRAFFIC_CONTROLLERS  (employees from dept 3)
-- Per spec: last_medical_exam_date is required.
-- =============================================================================
INSERT INTO traffic_controllers
    (employee_id, license_number, license_type, license_issued_date,
     license_expiry_date, last_medical_exam_date, next_medical_exam_date)
VALUES
(11, 'ATC-CY-001', 'Tower',    '2003-02-15', '2028-02-15', '2024-11-10', '2025-11-10'),
(12, 'ATC-CY-002', 'Approach', '2011-09-01', '2026-09-01', '2025-01-20', '2026-01-20'),
(13, 'ATC-CY-003', 'En-Route', '2005-05-01', '2025-05-01', '2024-09-05', '2025-09-05'),
(14, 'ATC-CY-004', 'Ground',   '2017-03-01', '2027-03-01', '2025-02-14', '2026-02-14');

-- =============================================================================
-- PLANE_MODELS  (8 records)
-- =============================================================================
INSERT INTO plane_models
    (manufacturer, model_name, model_code, seating_capacity, max_range_km,
     engine_type, engine_count, max_altitude_ft, cruise_speed_kmh)
VALUES
('Boeing',    '737-800',   'B738',  162, 5765,  'Jet',       2, 41000, 842),
('Boeing',    '737 MAX 8', 'B38M',  178, 6570,  'Jet',       2, 41000, 839),
('Airbus',    'A320neo',   'A20N',  165, 6300,  'Jet',       2, 39800, 833),
('Airbus',    'A321neo',   'A21N',  220, 7400,  'Jet',       2, 39800, 833),
('Airbus',    'A220-300',  'BCS3',  130, 6300,  'Jet',       2, 41000, 871),
('ATR',       'ATR 72-600','AT76',   70, 1528,  'Turboprop', 2, 25000, 510),
('Boeing',    '777-200ER', 'B772',  314,13080,  'Jet',       2, 43100, 905),
('Airbus',    'A330-200',  'A332',  247,13450,  'Jet',       2, 40000, 871);

-- =============================================================================
-- TECHNICIAN_EXPERTISE  (M:N)
-- =============================================================================
INSERT INTO technician_expertise
    (technician_id, model_id, certification_level, certified_date)
VALUES
-- Technician 1 (Cengiz — Avionics)
(1,1,'Senior','2005-06-01'),(1,2,'Senior','2020-03-15'),(1,3,'Lead','2008-09-01'),
-- Technician 2 (Fatma — Engine)
(2,1,'Senior','2011-05-20'),(2,3,'Senior','2014-11-10'),(2,6,'Junior','2020-04-01'),
-- Technician 3 (Kemal — Structural)
(3,1,'Lead','2009-08-01'),(3,4,'Senior','2013-02-15'),(3,5,'Junior','2019-06-01'),
-- Technician 4 (Leyla — Hydraulics)
(4,3,'Junior','2016-05-01'),(4,1,'Junior','2018-10-01'),
-- Technician 5 (Burak — Electrical)
(5,1,'Senior','2010-01-01'),(5,3,'Senior','2013-07-15'),(5,6,'Lead','2015-04-20'),
-- Technician 6 (Zeynep — Navigation)
(6,4,'Senior','2014-02-28'),(6,5,'Senior','2016-07-01'),(6,2,'Junior','2021-11-10'),
-- Technician 7 (İlker — Fuel)
(7,1,'Senior','2012-05-01'),(7,3,'Senior','2015-12-15'),
-- Technician 8 (Özge — Composite)
(8,5,'Junior','2020-01-01'),(8,6,'Senior','2019-08-20');

-- =============================================================================
-- AIRLINES  (8 records)
-- =============================================================================
INSERT INTO airlines
    (airline_name, iata_code, icao_code, country, contact_email, contact_phone)
VALUES
('Pegasus Airlines',           'PC', 'PGT', 'Turkey',         'ops@flypgs.com',      '+902164560000'),
('Turkish Airlines',           'TK', 'THY', 'Turkey',         'ops@thy.com',         '+902124443344'),
('AtlasGlobal',                'KK', 'KKK', 'Turkey',         'ops@atlasglb.com',    '+902165550000'),
('Sun Express',                'XQ', 'SXS', 'Turkey/Germany', 'ops@sunexpress.com',  '+902324449090'),
('Corendon Airlines',          'XC', 'CAI', 'Turkey',         'ops@corendon.com',    '+902165550001'),
('Turkish Airlines Cargo',     'TK', 'TKC', 'Turkey',         'cargo@thy.com',       '+902124443350'),
('Qatar Airways',              'QR', 'QTR', 'Qatar',          'ops@qatarairways.com','+97440229999'),
('Lufthansa',                  'LH', 'DLH', 'Germany',        'ops@lufthansa.com',   '+496996980000');

-- Fix: airline_id 6 has same IATA; give cargo a distinct code
UPDATE airlines SET iata_code = 'TZ', icao_code = 'TKC' WHERE airline_id = 6;

-- =============================================================================
-- AIRPLANES  (15 records)
-- =============================================================================
INSERT INTO airplanes
    (plane_no, model_id, airline_id, manufacture_year,
     total_flight_hours, last_inspection_date, next_inspection_date, status)
VALUES
('TC-YAA', 1, 1, '2014', 24100.0, '2024-11-01', '2025-11-01', 'Operational'),
('TC-YAB', 1, 1, '2015', 20800.5, '2024-12-01', '2025-12-01', 'Operational'),
('TC-YAC', 3, 1, '2017',  16500.0,'2025-01-05', '2026-01-05', 'Operational'),
('TC-YAD', 3, 1, '2019',   9800.0,'2025-01-20', '2026-01-20', 'Operational'),
('TC-YAE', 2, 2, '2020',   7600.0,'2024-12-10', '2025-12-10', 'Operational'),
('TC-YAF', 4, 2, '2018',  13200.0,'2024-10-20', '2025-10-20', 'Under Maintenance'),
('TC-YAG', 6, 4, '2016',  18700.0,'2024-09-15', '2025-09-15', 'Operational'),
('TC-YAH', 6, 4, '2017',  15400.0,'2025-02-01', '2026-02-01', 'Operational'),
('TC-YAI', 1, 3, '2013',  28900.0,'2024-07-01', '2025-07-01', 'Under Maintenance'),
('TC-YAJ', 3, 5, '2021',   5200.0,'2025-02-10', '2026-02-10', 'Operational'),
('TC-YAK', 5, 5, '2022',   3800.0,'2025-03-01', '2026-03-01', 'Operational'),
('A7-ALB', 7, 7, '2015',  19500.0,'2024-08-20', '2025-08-20', 'Operational'),
('D-AIXA', 4, 8, '2019',  10800.0,'2025-01-15', '2026-01-15', 'Operational'),
('TC-YAL', 2, 1, '2023',   1200.0,'2025-04-01', '2026-04-01', 'Operational'),
('TC-YAM', 3, 2, '2016',  22000.0,'2024-06-01', '2025-06-01', 'Grounded');

-- =============================================================================
-- HANGARS  (6 records)
-- =============================================================================
INSERT INTO hangars
    (hangar_no, hangar_name, location, capacity, hangar_type, area_sqm)
VALUES
('HGR-01', 'Hangar 1 — Main Maintenance',  'East Side, Row A', 4, 'Maintenance', 9200.00),
('HGR-02', 'Hangar 2 — Secondary Maint.',  'East Side, Row B', 3, 'Maintenance', 6800.00),
('HGR-03', 'Hangar 3 — Parking North',     'North Apron',      6, 'Parking',    12500.00),
('HGR-04', 'Hangar 4 — Parking South',     'South Apron',      6, 'Parking',    12500.00),
('HGR-05', 'Hangar 5 — Storage',           'West Side',        3, 'Storage',     5000.00),
('HGR-06', 'Hangar 6 — Emergency Bay',     'East Side, Row C', 2, 'Maintenance', 4800.00);

-- =============================================================================
-- AIRPLANE_PARKING  (IN/OUT history)
-- =============================================================================
INSERT INTO airplane_parking
    (airplane_id, hangar_id, date_in, date_out, reason, checked_in_by, checked_out_by, notes)
VALUES
-- Currently parked (date_out = NULL)
(6,  1, '2025-01-08 08:00:00', NULL,                    'B-Check Maintenance',    5,  NULL, 'Engine inspection ongoing'),
(9,  2, '2025-01-10 09:00:00', NULL,                    'C-Check Overhaul',       7,  NULL, 'Full C-Check; airframe and avionics'),
(15, 6, '2024-12-15 10:00:00', NULL,                    'Grounded — Engine Fault',5,  NULL, 'Engine 1 compressor damage — awaiting parts'),
-- Completed parking events
(1,  3, '2025-01-14 22:00:00', '2025-01-15 05:30:00',   'Overnight Parking',      15, 16,   NULL),
(2,  3, '2025-01-14 23:00:00', '2025-01-15 06:00:00',   'Overnight Parking',      15, 16,   NULL),
(3,  4, '2025-01-13 20:00:00', '2025-01-14 05:00:00',   'Overnight Parking',      17, 17,   NULL),
(5,  4, '2025-01-15 01:00:00', '2025-01-15 07:00:00',   'Overnight Parking',      15, 16,   NULL),
(7,  3, '2025-01-12 18:00:00', '2025-01-13 06:00:00',   'Overnight Parking',      17, 17,   NULL),
(12, 1, '2025-01-05 14:00:00', '2025-01-07 16:00:00',   'A-Check Maintenance',    5,  5,    'A-Check completed successfully'),
(4,  4, '2025-01-10 20:00:00', '2025-01-11 04:30:00',   'Technical Hold',         5,  9,    'Minor avionics check — cleared'),
(10, 5, '2025-01-01 00:00:00', '2025-01-02 06:00:00',   'Storage',                15, 15,   'Temporary storage between flights'),
(13, 3, '2025-01-08 22:00:00', '2025-01-09 06:00:00',   'Overnight Parking',      17, 17,   NULL);

-- =============================================================================
-- TESTS  (10 records)
-- =============================================================================
INSERT INTO tests
    (test_code, test_name, test_category, description, standard_hours, passing_score)
VALUES
('TST-001','Airframe Structural Integrity',  'Structural',   'Checks fuselage, wings, empennage for cracks and fatigue', 4.00, 80.00),
('TST-002','Avionics Systems Functionality', 'Avionics',     'Full test of FMS, autopilot, transponder, and ACARS',      3.50, 85.00),
('TST-003','Engine Performance Run-Up',      'Engine',       'Full engine run-up including FADEC and vibration analysis', 5.00, 90.00),
('TST-004','Emergency Systems Safety Check', 'Safety',       'ELT, fire suppression, oxygen, and evacuation slides',     2.50, 95.00),
('TST-005','Navigation & Communication',     'Navigation',   'VHF, HF, ILS, VOR, GPS, TCAS, ADS-B systems',             3.00, 85.00),
('TST-006','Hydraulic Systems Pressure',     'Structural',   'Landing gear, flight controls, brakes hydraulics',         2.00, 80.00),
('TST-007','Environmental Control System',   'Environmental','Cabin pressurisation, air conditioning, oxygen supply',    1.50, 75.00),
('TST-008','Fuel System Integrity',          'Engine',       'All fuel tanks, crossfeed valves, boost pumps',            2.50, 90.00),
('TST-009','APU Operational Check',          'Engine',       'Auxiliary Power Unit start, load, and bleed air test',     1.00, 85.00),
('TST-010','Landing Gear Functional',        'Structural',   'Extension, retraction, locking, and brake test',           2.00, 90.00);

-- =============================================================================
-- TEST_HISTORY  (20 records — core spec requirement)
-- Per spec: date, hours_spent, score for each airplane × technician × test event
-- =============================================================================
INSERT INTO test_history
    (airplane_id, test_id, technician_id, test_date,
     hours_spent, score, result, remarks, approved_by)
VALUES
(1,  1, 1, '2024-11-01', 4.5,  88.5, 'Pass',        'Minor surface corrosion on wing LE — monitored',     25),
(1,  3, 2, '2024-11-01', 5.2,  92.0, 'Pass',        'Engine 1 & 2 within all operational parameters',     25),
(2,  2, 1, '2024-12-01', 3.5,  91.0, 'Pass',        'FMS updated to v4.2; all systems nominal',           25),
(2,  5, 6, '2024-12-01', 3.0,  87.5, 'Pass',        'ILS Cat I operational; TCAS functioning',            25),
(6,  1, 3, '2025-01-08', 5.0,  76.0, 'Fail',        'Frame 55 shows micro-cracks — repair required',      25),
(6,  3, 2, '2025-01-09', 6.0,  88.0, 'Pass',        'Engine performance acceptable; B-Check in progress', 25),
(9,  1, 3, '2025-01-10', 5.5,  82.0, 'Pass',        'Structural integrity satisfactory for C-Check stage',25),
(9,  8, 7, '2025-01-11', 2.5,  94.0, 'Pass',        'No fuel leaks; all boost pumps functional',          25),
(3,  4, 4, '2025-01-13', 2.5,  97.0, 'Pass',        'All emergency systems fully operational',             25),
(3,  6, 5, '2025-01-13', 2.0,  85.0, 'Pass',        'Hydraulic pressures nominal throughout',              25),
(12, 3, 4, '2025-01-05', 5.5,  91.0, 'Pass',        'A-Check engine run-up completed',                    25),
(12, 9, 5, '2025-01-06', 1.2,  90.0, 'Pass',        'APU starts and loads correctly',                     25),
(15, 3, 2, '2024-12-15', 6.5,  52.0, 'Fail',        'Engine 1 compressor stall; aircraft grounded',       25),
(4,  2, 1, '2025-01-10', 4.0,  89.5, 'Pass',        'Avionics systems functional post-software update',   25),
(5,  5, 6, '2025-01-15', 3.5,  88.0, 'Pass',        'Navigation systems certified for EBR operations',    25),
(7,  7, 5, '2025-01-12', 1.5,  82.0, 'Pass',        'Cabin pressure differential within limits',           25),
(8,  10,4, '2025-01-14', 2.0,  91.0, 'Pass',        'Landing gear cycles tested — 150 cycles nominal',    25),
(10, 2, 1, '2025-01-01', 3.5,  93.5, 'Pass',        'All avionics newly calibrated after delivery',        25),
(11, 1, 8, '2025-02-01', 4.0,  86.0, 'Pass',        'Composite structures intact; no delamination',        25),
(14, 4, 3, '2025-03-10', 2.5,  98.0, 'Pass',        'New aircraft — all emergency systems certified',      25);

-- =============================================================================
-- MAINTENANCE_SCHEDULES
-- =============================================================================
INSERT INTO maintenance_schedules
    (airplane_id, technician_id, scheduled_date, maintenance_type,
     estimated_hours, actual_hours, status, hangar_id, notes)
VALUES
(6,  3, '2025-01-08', 'B-Check',     120.00, NULL,  'In Progress', 1, 'Focus on structural and engine systems'),
(9,  1, '2025-01-10', 'C-Check',     720.00, NULL,  'In Progress', 2, 'Full C-Check — avionics, structural, engines'),
(15, 2, '2024-12-15', 'Emergency',    48.00, NULL,  'In Progress', 6, 'Engine 1 compressor replacement'),
(12, 2, '2025-01-05', 'A-Check',      10.00, 9.50,  'Completed',   NULL,'A-Check completed; snags resolved'),
(1,  1, '2025-07-01', 'B-Check',     120.00, NULL,  'Scheduled',   NULL,'Scheduled B-Check'),
(2,  5, '2025-06-15', 'A-Check',      10.00, NULL,  'Scheduled',   NULL,'Routine A-Check'),
(4,  6, '2025-05-01', 'A-Check',      10.00, NULL,  'Scheduled',   NULL,'Routine A-Check'),
(13, 3, '2026-01-01', 'D-Check',    3000.00, NULL,  'Scheduled',   NULL,'Heavy maintenance due next year'),
(7,  7, '2025-04-20', 'B-Check',     120.00, NULL,  'Scheduled',   NULL,'B-Check for ATR aircraft'),
(3,  4, '2024-10-01', 'A-Check',      10.00, 10.50, 'Completed',   NULL,'Extended for wiring harness check');

-- =============================================================================
-- REPAIRS
-- =============================================================================
INSERT INTO repairs
    (airplane_id, technician_id, schedule_id, repair_date,
     repair_type, description, parts_cost, labor_cost, status)
VALUES
(6,  3, 1, '2025-01-12', 'Structural Repair',    'Composite patch repair on frame 55 micro-cracks',   35000.00, 12000.00, 'In Progress'),
(15, 2, 3, '2024-12-18', 'Engine Replacement',   'CFM56-7B Engine 1 compressor section replacement', 780000.00, 95000.00, 'In Progress'),
(9,  1, 2, '2025-01-14', 'Avionics Upgrade',     'FMS Gen4 installation and full avionics calibration', 42000.00, 18000.00, 'In Progress'),
(12, 2, 4, '2025-01-06', 'Engine Blade Repair',  'Replaced 6 HPT blades during A-Check',              28000.00,  9500.00, 'Completed'),
(3,  5, 10,'2024-10-02', 'Wiring Harness',       'Replaced damaged avionics wiring harness section',   4800.00,  3100.00, 'Completed'),
(4,  1, NULL,'2025-01-11','Avionics Software',   'FMS software update v4.5 and ILS recalibration',      1100.00,  3200.00, 'Completed');

-- =============================================================================
-- RUNWAYS
-- =============================================================================
INSERT INTO runways
    (runway_code, length_m, width_m, surface_type, ils_available, status)
VALUES
('06/24',   2694, 45, 'Asphalt',  1, 'Active'),
('12/30',   2500, 45, 'Asphalt',  1, 'Active'),
('18/36',   1800, 30, 'Concrete', 0, 'Active'),
('09L/27R', 3000, 60, 'Asphalt',  1, 'Under Repair');

-- =============================================================================
-- GATES
-- =============================================================================
INSERT INTO gates
    (gate_code, terminal, gate_type, has_jetbridge, max_aircraft_size, status)
VALUES
('A1', 'T1', 'International', 1, 'Large',   'Active'),
('A2', 'T1', 'International', 1, 'Large',   'Active'),
('A3', 'T1', 'Domestic',      1, 'Medium',  'Active'),
('A4', 'T1', 'Domestic',      1, 'Medium',  'Active'),
('A5', 'T1', 'Domestic',      0, 'Small',   'Active'),
('B1', 'T2', 'International', 1, 'Wide-Body','Active'),
('B2', 'T2', 'Both',          1, 'Large',   'Active'),
('B3', 'T2', 'Domestic',      0, 'Medium',  'Active');

-- =============================================================================
-- PILOTS  (sub-entity of employees)
-- =============================================================================
INSERT INTO pilots
    (employee_id, license_number, license_class, total_flight_hours,
     medical_cert_expiry, last_proficiency_check)
VALUES
(1,  'PIL-EASA-001', 'ATP',        16800.5, '2026-12-31', '2024-11-15'),
(2,  'PIL-EASA-002', 'ATP',        12200.0, '2026-11-30', '2024-10-20'),
(3,  'PIL-EASA-003', 'ATP',        19400.5, '2027-03-31', '2025-01-10'),
(4,  'PIL-EASA-004', 'ATP',        14700.0, '2026-10-31', '2024-12-05'),
(29, 'PIL-EASA-005', 'ATP',        22100.0, '2027-01-31', '2025-02-01'),
(30, 'PIL-EASA-006', 'Commercial',  9800.5, '2027-06-30', '2025-01-20');

-- =============================================================================
-- FLIGHTS  (15 records)
-- =============================================================================
INSERT INTO flights
    (flight_number, airline_id, airplane_id, origin_iata, destination_iata,
     scheduled_departure, scheduled_arrival, actual_departure, actual_arrival,
     departure_gate_id, arrival_gate_id, runway_id, flight_status, delay_minutes)
VALUES
('PC101', 1,  1,  'ECN','SAW','2025-01-15 07:00:00','2025-01-15 08:30:00','2025-01-15 07:05:00','2025-01-15 08:35:00',3,NULL,1,'Landed',   5),
('PC102', 1,  2,  'ECN','ADB','2025-01-15 09:00:00','2025-01-15 10:20:00','2025-01-15 09:00:00','2025-01-15 10:15:00',4,NULL,1,'Landed',   0),
('TK201', 2,  5,  'ECN','IST','2025-01-15 11:00:00','2025-01-15 12:30:00','2025-01-15 11:20:00','2025-01-15 12:55:00',1,NULL,2,'Landed',  20),
('TK202', 2,  3,  'ECN','IST','2025-01-15 14:00:00','2025-01-15 15:30:00','2025-01-15 14:40:00','2025-01-15 16:05:00',2,NULL,2,'Landed',  40),
('XQ301', 4,  7,  'ECN','AYT','2025-01-15 08:00:00','2025-01-15 09:40:00','2025-01-15 08:00:00','2025-01-15 09:35:00',5,NULL,1,'Landed',   0),
('XQ302', 4,  8,  'ECN','DLM','2025-01-15 10:30:00','2025-01-15 12:00:00','2025-01-15 10:45:00','2025-01-15 12:10:00',3,NULL,1,'Landed',  15),
('QR401', 7,  12, 'DOH','ECN','2025-01-15 05:00:00','2025-01-15 07:00:00','2025-01-15 05:00:00','2025-01-15 07:05:00',6,1,  2,'Landed',   0),
('LH501', 8,  13, 'FRA','ECN','2025-01-15 06:00:00','2025-01-15 10:30:00','2025-01-15 06:10:00','2025-01-15 10:40:00',7,2,  2,'Landed',  10),
('PC103', 1,  4,  'ECN','ESB','2025-01-16 08:00:00','2025-01-16 09:30:00',NULL,                 NULL,                 4,NULL,NULL,'Scheduled', 0),
('TK203', 2,  14, 'IST','ECN','2025-01-16 10:00:00','2025-01-16 11:30:00',NULL,                 NULL,                 NULL,1,NULL,'Scheduled', 0),
('PC104', 1,  1,  'SAW','ECN','2025-01-16 12:00:00','2025-01-16 13:30:00',NULL,                 NULL,                 NULL,3,NULL,'Scheduled', 0),
('XQ303', 4,  10, 'ECN','AYT','2025-01-16 09:00:00','2025-01-16 10:40:00',NULL,                 NULL,                 5,NULL,1,  'Scheduled', 0),
('PC105', 1,  11, 'ECN','SAW','2025-01-16 13:00:00','2025-01-16 14:30:00',NULL,                 NULL,                 3,NULL,1,  'Scheduled', 0),
('TK204', 2,  5,  'ECN','ADB','2025-01-16 15:00:00','2025-01-16 16:20:00',NULL,                 NULL,                 1,NULL,2,  'Scheduled', 0),
('QR402', 7,  12, 'ECN','DOH','2025-01-17 02:00:00','2025-01-17 06:30:00',NULL,                 NULL,                 6,NULL,2,  'Scheduled', 0);

-- =============================================================================
-- FLIGHT_CREW
-- =============================================================================
INSERT INTO flight_crew (flight_id, employee_id, crew_role) VALUES
(1,  1, 'Captain'),(1,  4, 'First Officer'),(1, 20, 'Cabin Crew'),
(2,  2, 'Captain'),(2,  3, 'First Officer'),(2, 19, 'Cabin Crew'),
(3,  29,'Captain'),(3,  1, 'First Officer'),(3, 20, 'Cabin Crew'),
(4,  3, 'Captain'),(4, 30, 'First Officer'),(4, 19, 'Cabin Crew'),
(5,  4, 'Captain'),(5,  2, 'First Officer'),
(7,  1, 'Captain'),(7, 29, 'First Officer'),
(8,  3, 'Captain'),(8,  4, 'First Officer'),
(9,  2, 'Captain'),(9, 30, 'First Officer');

-- =============================================================================
-- PASSENGERS  (20 records)
-- =============================================================================
INSERT INTO passengers
    (passport_no, first_name, last_name, date_of_birth, nationality,
     gender, email, phone, frequent_flyer_no)
VALUES
('TR-1111111','Ali',      'Özer',      '1982-03-10','Turkish',    'M','ali.ozer@email.com',       '+905301111111','PC-FF-0001'),
('TR-2222222','Sema',     'Akın',      '1990-07-15','Turkish',    'F','sema.akin@email.com',      '+905302222222','PC-FF-0002'),
('CY-1111111','Mustafa',  'Arap',      '1978-11-22','Cypriot',    'M','mustafa.arap@email.cy',    '+35799111111', NULL),
('CY-2222222','Hüseyin',  'Uçar',      '1985-04-08','Cypriot',    'M','huseyin.ucar@email.cy',   '+35799222222', 'PC-FF-0003'),
('GB-1111111','James',    'Thornton',  '1965-09-30','British',    'M','j.thornton@email.co.uk',  '+441234000001', NULL),
('DE-1111111','Klaus',    'Berger',    '1972-02-14','German',     'M','k.berger@email.de',        '+491234000001', 'LH-FF-0001'),
('QA-1111111','Ahmad',    'Al-Zahra',  '1980-06-19','Qatari',     'M','ahmad.alzahra@email.qa',  '+9741234000',  'QR-FF-0001'),
('TR-3333333','Nilüfer',  'Koca',      '1995-01-05','Turkish',    'F','nilufer.koca@email.com',   '+905303333333', NULL),
('TR-4444444','Ersin',    'Altun',     '1988-08-27','Turkish',    'M','ersin.altun@email.com',   '+905304444444','TK-FF-0001'),
('TR-5555555','Bahar',    'Temiz',     '1993-12-03','Turkish',    'F','bahar.temiz@email.com',   '+905305555555','PC-FF-0004'),
('CY-3333333','Nevzat',   'Karakaya',  '1970-05-17','Cypriot',    'M','nevzat.karakaya@email.cy','+35799333333', NULL),
('TR-6666666','Senem',    'Dinç',      '1997-02-22','Turkish',    'F','senem.dinc@email.com',    '+905306666666', NULL),
('RU-1111111','Ivan',     'Petrov',    '1975-10-09','Russian',    'M','ivan.petrov@email.ru',    '+71234000001',  NULL),
('FR-1111111','Camille',  'Moreau',    '1983-07-31','French',     'F','c.moreau@email.fr',       '+331234000001', NULL),
('CY-4444444','Tuncay',   'Güler',     '1960-03-25','Cypriot',    'M','tuncay.guler@email.cy',  '+35799444444','PC-FF-0005'),
('TR-7777777','Onur',     'Bozkurt',   '1991-09-14','Turkish',    'M','onur.bozkurt@email.com',  '+905307777777','TK-FF-0002'),
('JP-1111111','Yuki',     'Nakamura',  '1989-04-18','Japanese',   'F','yuki.nakamura@email.jp',  '+811234000001', NULL),
('TR-8888888','Büşra',    'Ertürk',    '1996-11-07','Turkish',    'F','busra.erturk@email.com',  '+905308888888', NULL),
('IT-1111111','Marco',    'Ricci',     '1977-06-23','Italian',    'M','marco.ricci@email.it',    '+391234000001', NULL),
('TR-9999999','Cihan',    'Yüksel',    '1984-08-30','Turkish',    'M','cihan.yuksel@email.com',  '+905309999999','PC-FF-0006');

-- =============================================================================
-- TICKETS  (20 records)
-- =============================================================================
INSERT INTO tickets
    (ticket_number, flight_id, passenger_id, booking_class,
     seat_number, price, ticket_status, baggage_kg)
VALUES
('TKT-PC101-001',1,  1, 'Economy', '14A', 180.00,'Boarded',  20.0),
('TKT-PC101-002',1,  2, 'Business','3B',  520.00,'Boarded',  30.0),
('TKT-PC101-003',1,  3, 'Economy', '22C', 165.00,'Boarded',  20.0),
('TKT-PC102-001',2,  4, 'Economy', '11A', 175.00,'Boarded',  20.0),
('TKT-PC102-002',2,  5, 'Business','2A',  560.00,'Boarded',  30.0),
('TKT-TK201-001',3,  9, 'Business','5C',  380.00,'Boarded',  30.0),
('TKT-TK201-002',3, 10, 'Economy', '28D', 210.00,'Boarded',  23.0),
('TKT-TK202-001',4,  6, 'Economy', '17B', 200.00,'No-Show',  23.0),
('TKT-XQ301-001',5, 11, 'Economy', '9A',  140.00,'Boarded',  20.0),
('TKT-XQ301-002',5, 12, 'Economy', '15B', 135.00,'Boarded',  20.0),
('TKT-QR401-001',7,  7, 'Business','8A', 1950.00,'Boarded',  35.0),
('TKT-LH501-001',8,  6, 'Business','4C', 1650.00,'Boarded',  32.0),
('TKT-LH501-002',8, 13, 'Economy', '31E', 480.00,'Boarded',  23.0),
('TKT-PC103-001',9, 14, 'Economy', '19A', 155.00,'Confirmed',20.0),
('TKT-PC103-002',9, 15, 'Business','2B',  490.00,'Confirmed',30.0),
('TKT-TK203-001',10,16, 'Economy', '24C', 195.00,'Confirmed',23.0),
('TKT-PC104-001',11,17, 'Economy', '8B',  170.00,'Confirmed',20.0),
('TKT-XQ303-001',12, 8, 'Economy', '12A', 145.00,'Confirmed',20.0),
('TKT-PC105-001',13,18, 'Economy', '6C',  180.00,'Confirmed',20.0),
('TKT-TK204-001',14,20, 'Business','3A',  420.00,'Confirmed',30.0);

-- =============================================================================
-- PAYMENTS
-- =============================================================================
INSERT INTO payments
    (ticket_id, amount, payment_method, payment_date, transaction_ref, payment_status)
VALUES
(1,  180.00,'Debit Card',   '2024-12-20 10:15:00','TXN-001','Completed'),
(2,  520.00,'Credit Card',  '2024-12-20 10:18:00','TXN-002','Completed'),
(3,  165.00,'Cash',         '2025-01-10 09:00:00','TXN-003','Completed'),
(4,  175.00,'Credit Card',  '2024-12-22 14:00:00','TXN-004','Completed'),
(5,  560.00,'Bank Transfer','2024-12-18 11:30:00','TXN-005','Completed'),
(6,  380.00,'Credit Card',  '2025-01-05 16:45:00','TXN-006','Completed'),
(7,  210.00,'Debit Card',   '2025-01-06 09:20:00','TXN-007','Completed'),
(8,  200.00,'Credit Card',  '2024-12-25 20:00:00','TXN-008','Completed'),
(9,  140.00,'Cash',         '2025-01-12 08:00:00','TXN-009','Completed'),
(10, 135.00,'Debit Card',   '2025-01-13 10:00:00','TXN-010','Completed'),
(11,1950.00,'Bank Transfer','2025-01-02 11:00:00','TXN-011','Completed'),
(12,1650.00,'Bank Transfer','2024-12-30 09:30:00','TXN-012','Completed'),
(13, 480.00,'Credit Card',  '2025-01-01 17:00:00','TXN-013','Completed'),
(14, 155.00,'Credit Card',  '2025-01-14 12:00:00','TXN-014','Completed'),
(15, 490.00,'Credit Card',  '2025-01-13 15:30:00','TXN-015','Completed'),
(16, 195.00,'Debit Card',   '2025-01-14 20:00:00','TXN-016','Completed'),
(17, 170.00,'Cash',         '2025-01-14 07:30:00','TXN-017','Completed'),
(18, 145.00,'Credit Card',  '2025-01-15 08:00:00','TXN-018','Completed'),
(19, 180.00,'Debit Card',   '2025-01-15 11:00:00','TXN-019','Completed'),
(20, 420.00,'Bank Transfer','2025-01-15 14:00:00','TXN-020','Completed');

SET FOREIGN_KEY_CHECKS = 1;
