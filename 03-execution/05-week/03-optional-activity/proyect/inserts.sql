-- =========================================
-- INSERTS: PASSWORD
-- =========================================
INSERT INTO password (passwordid, password) VALUES
(1, 'pass123'),
(2, 'admin456'),
(3, 'user789');


-- =========================================
-- INSERTS: EMAIL
-- =========================================
INSERT INTO email (emailid, email) VALUES
(1, 'user1@mail.com'),
(2, 'admin@mail.com'),
(3, 'user2@mail.com');


-- =========================================
-- INSERTS: ROLE
-- =========================================
INSERT INTO role (roleid, role, permissiondescription) VALUES
(1, 'ADMIN', 'Full access'),
(2, 'OPERATOR', 'Limited access'),
(3, 'VIEWER', 'Read-only access');


-- =========================================
-- INSERTS: PAGE
-- =========================================
INSERT INTO page (pageid, page, url) VALUES
(1, 'Dashboard', '/dashboard'),
(2, 'Reports', '/reports'),
(3, 'Settings', '/settings');


-- =========================================
-- INSERTS: ROLE_PAGE
-- =========================================
INSERT INTO role_page (rolepageid, roleid, pageid) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 2);


-- =========================================
-- INSERTS: USER
-- =========================================
INSERT INTO "user" (userid, username, passwordid, emailid, roleid, identification, phone, modificationtime) VALUES
(1, 'oscar', 1, 1, 1, 1234567890, 3001234567, 60),
(2, 'juan', 2, 2, 2, 9876543210, 3009876543, 30),
(3, 'maria', 3, 3, 3, 4567891230, 3014567890, 15);


-- =========================================
-- INSERTS: VEHICLE_TYPE
-- =========================================
INSERT INTO vehicle_type (vehicletypeid, vehicletype) VALUES
(1, 'Truck'),
(2, 'Car'),
(3, 'Van');


-- =========================================
-- INSERTS: VEHICLE
-- =========================================
INSERT INTO vehicle (vehicleid, vehicletypeid, plate, registrationdate, state) VALUES
(1, 1, 'ABC123', NOW(), true),
(2, 2, 'XYZ789', NOW(), true),
(3, 3, 'LMN456', NOW(), false);


-- =========================================
-- INSERTS: TYPE_MACHINERY
-- =========================================
INSERT INTO type_machinery (typemachineryid, typemachinery) VALUES
(1, 'Excavator'),
(2, 'Bulldozer'),
(3, 'Crane');


-- =========================================
-- INSERTS: MACHINE
-- =========================================
INSERT INTO machine (machineid, typemachineryid, plate, registrationdate, state) VALUES
(1, 1, 'EXC001', NOW(), true),
(2, 2, 'BULL002', NOW(), true),
(3, 3, 'CRN003', NOW(), false);


-- =========================================
-- INSERTS: DEPARTMENT
-- =========================================
INSERT INTO department (departmentid, departmentname, danecode) VALUES
(1, 'Huila', 41),
(2, 'Cundinamarca', 25),
(3, 'Antioquia', 5);


-- =========================================
-- INSERTS: MUNICIPALITY
-- =========================================
INSERT INTO municipality (municipalityid, departmentid, municipalityname, danecode) VALUES
(1, 1, 'Neiva', 41001),
(2, 2, 'Bogota', 11001),
(3, 3, 'Medellin', 5001);


-- =========================================
-- INSERTS: ACTIVITY
-- =========================================
INSERT INTO activity (activityid, activity) VALUES
(1, 'Transport'),
(2, 'Excavation'),
(3, 'Maintenance');


-- =========================================
-- INSERTS: WORK
-- =========================================
INSERT INTO work (workid, work) VALUES
(1, 'Road Construction'),
(2, 'Bridge Repair'),
(3, 'Building Project');


-- =========================================
-- INSERTS: MACHINERY_REPORT
-- =========================================
INSERT INTO machinery_report (
machineryreportid, datereport, municipalityid, machineid, workid, activityid,
initialhourmeter, finalhourmeter, totalhours, hoursvalue, totalvalue,
gallons, fuelvalue, tankhour, performance, gps, observation, userid, report
) VALUES
(1, CURRENT_DATE, 1, 1, 1, 2, 10, 20, 10, 50, 500, 5, 10000, 15, 2, 123.45, 'OK', 1, 101),
(2, CURRENT_DATE, 2, 2, 2, 1, 5, 15, 10, 40, 400, 4, 9000, 10, 2.5, 223.45, 'Normal', 2, 102),
(3, CURRENT_DATE, 3, 3, 3, 3, 8, 18, 10, 60, 600, 6, 11000, 12, 3, 323.45, 'Check', 3, 103);


-- =========================================
-- INSERTS: VEHICLE_REPORT
-- =========================================
INSERT INTO vehicle_report (
reportvehicleid, datereport, municipalityid, vehicleid, workid, activityid,
quantity, value, gallons, fuel, tankkm, performance, gps, maxspeed,
observation, userid, report
) VALUES
(1, CURRENT_DATE, 1, 1, 1, 1, 5, 100, 10, 20000, 150, 15, 123.45, 80, 'OK', 1, 201),
(2, CURRENT_DATE, 2, 2, 2, 2, 3, 150, 8, 18000, 120, 14, 223.45, 90, 'Normal', 2, 202),
(3, CURRENT_DATE, 3, 3, 3, 3, 4, 200, 12, 25000, 200, 16, 323.45, 100, 'Check', 3, 203);
