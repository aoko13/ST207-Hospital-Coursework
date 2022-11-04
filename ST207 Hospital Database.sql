BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "DOCTOR" (
	"doctor_ID"	INTEGER NOT NULL,
	"first_Name"	VARCHAR(50),
	"last_Name"	VARCHAR(50),
	"office"	VARCHAR(100),
	"speciality_ID"	INTEGER NOT NULL,
	PRIMARY KEY("doctor_ID" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "PATIENT" (
	"patient_ID"	INTEGER NOT NULL,
	"first_Name"	VARCHAR(50),
	"last_Name"	VARCHAR(50),
	"age"	INTEGER,
	"gender"	CHAR(1),
	"email"	VARCHAR(50),
	PRIMARY KEY("patient_ID" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "PROCEDURE" (
	"procedure_ID"	VARCHAR(5) NOT NULL,
	"procedure_Name"	CHAR(50),
	"duration"	INTEGER,
	"speciality_ID"	INTEGER NOT NULL,
	"speciality_ID2"	INTEGER,
	"speciality_ID3"	INTEGER,
	"cost"	REAL,
	PRIMARY KEY("procedure_ID")
);
CREATE TABLE IF NOT EXISTS "EXAM" (
	"exam_ID"	INTEGER NOT NULL,
	"patient_ID"	INTEGER NOT NULL,
	"doctor_ID"	INTEGER NOT NULL,
	"request_Date"	DATE,
	"exam_Date"	DATE,
	"results_Date"	DATE,
	"results"	VARCHAR(1000),
	"diagnosis"	VARCHAR(1000),
	PRIMARY KEY("exam_ID" AUTOINCREMENT),
	CHECK("request_Date" < "exam_Date" AND "exam_Date" < "results_Date"),
	FOREIGN KEY("patient_ID") REFERENCES "PATIENT"("patient_ID"),
	FOREIGN KEY("doctor_ID") REFERENCES "DOCTOR"("doctor_ID")
);
CREATE TABLE IF NOT EXISTS "MEDICATION" (
	"medication_ID"	VARCHAR(5) NOT NULL,
	"medication_Name"	CHAR(50),
	"fabrication_Date"	CHAR(50),
	"expiration_Date"	INTEGER,
	"controlled"	CHAR(1),
	"unit_Price"	REAL,
	"stock_Qty"	INTEGER,
	PRIMARY KEY("medication_ID"),
	CHECK("fabrication_Date" < "expiration_Date")
);
CREATE TABLE IF NOT EXISTS "APPOINTMENT" (
	"appt_ID"	INTEGER NOT NULL,
	"patient_ID"	INTEGER NOT NULL,
	"doctor_ID"	INTEGER NOT NULL,
	"appt_Date"	DATE,
	"duration"	INTEGER,
	"symptoms"	VARCHAR(1000),
	PRIMARY KEY("appt_ID" AUTOINCREMENT),
	FOREIGN KEY("patient_ID") REFERENCES "PATIENT"("patient_ID"),
	FOREIGN KEY("doctor_ID") REFERENCES "DOCTOR"("doctor_ID")
);
CREATE TABLE IF NOT EXISTS "PRESCRIPTION" (
	"appt_ID"	INTEGER NOT NULL,
	"prescription_ID"	VARCHAR(5) NOT NULL,
	FOREIGN KEY("appt_ID") REFERENCES "APPOINTMENT"("appt_ID")
);
INSERT INTO "DOCTOR" VALUES (1,'Sian','Gibson','G.01',1),
 (2,'Joe','Thomas','G.03',2),
 (3,'Lou','Sanders','G.02',3);
INSERT INTO "PATIENT" VALUES (1,'Greg','Davies',54,'M','greg.davies@gmail.com'),
 (2,'Alex','Horne',44,'M','alex.horne@hotmail.com'),
 (3,'Dara','O Briain',50,'M','d.obriain@gmail.com'),
 (4,'Fern','Brady',36,'F','brady.fern@gmail.com'),
 (5,'John','Kearns',35,'M','john.kearns@gmail.com'),
 (6,'Munya','Chawawa',29,'M','m.chawawa@gmail.com'),
 (7,'Sarah','Millican',47,'F','sarah.millican@gmail.com');
INSERT INTO "PROCEDURE" VALUES ('P1','Blood Test',5,1,NULL,NULL,4.5),
 ('P2','Urine Test',10,1,NULL,NULL,5.0),
 ('P3','Eye Test',30,1,2,NULL,10.0),
 ('P4','Biopsy',60,1,3,NULL,30.0),
 ('P5','Corneal Transplant',120,2,NULL,NULL,300.0),
 ('P6','LASIK',120,2,NULL,NULL,3000.0),
 ('P7','Pacemaker',150,3,NULL,NULL,1000.0),
 ('P8','Heart Bypass',550,3,NULL,NULL,5000.0),
 ('P9','Cardioversion',30,1,2,3,50.0);
INSERT INTO "EXAM" VALUES (1,1,2,'2022-09-01','2022-09-10','2022-09-20','Diagnosed','Flu'),
 (2,5,2,'2022-09-03','2022-09-05','2022-09-20','Diagnosed','Arthritis'),
 (3,4,3,'2022-10-03','2022-10-05','2022-10-20','No issue','Healthy'),
 (4,1,2,'2022-10-06','2022-10-10','2022-10-20','Diagnosis','Glaucoma'),
 (5,2,3,'2022-10-01','2022-10-02','2022-10-15','Diagnosis','Heart attack');
INSERT INTO "MEDICATION" VALUES ('M1','Saline solution','2020-10-01','2025-10-01','N',3.0,100),
 ('M2','Pacemaker','2022-10-01','2030-10-01','Y',1000.0,100),
 ('M3','Paracetamol','2020-03-01','2025-03-01','N',1.0,1000),
 ('M4','Penicillin','2020-03-01','2025-03-01','Y',30.0,750),
 ('M5','Inhaler','2020-05-01','2025-05-01','Y',10.0,1000);
INSERT INTO "APPOINTMENT" VALUES (1,1,2,'2022-09-01',20,'Cough, fever'),
 (2,5,2,'2022-09-03',30,'Severe knee pain'),
 (3,4,3,'2022-10-03',20,'Headache'),
 (4,1,2,'2022-10-06',40,'Blurred vision, circles in vision'),
 (5,2,3,'2022-10-01',10,'Chest pain'),
 (6,2,1,'2022-07-02',25,'Stress');
INSERT INTO "PRESCRIPTION" VALUES (1,'P3'),
 (2,'M4'),
 (3,'P3'),
 (4,'M5'),
 (5,'P7'),
 (4,'P1'),
 (4,'P4'),
 (4,'M1'),
 (4,'M1');


CREATE TRIGGER doctor_ID_ExistsAlready BEFORE INSERT ON doctor
BEGIN
	SELECT CASE
	WHEN ((SELECT doctor.doctor_ID FROM doctor WHERE doctor.doctor_ID = NEW.doctor_ID) IS NOT NULL)
	THEN RAISE(FAIL, 'ERROR: This doctor ID already exists.')
END;
END;
CREATE TRIGGER exam_ID_ExistsAlready BEFORE INSERT ON exam
BEGIN
	SELECT CASE
	WHEN ((SELECT exam.exam_ID FROM exam WHERE exam.exam_ID = NEW.exam_ID) IS NOT NULL)
	THEN RAISE(FAIL, 'ERROR: This exam ID already exists.')
END;
END;
CREATE TRIGGER exam_doctor_ID_DoesNotExist BEFORE INSERT ON exam
BEGIN
	SELECT CASE
	WHEN ((SELECT doctor.doctor_ID FROM doctor WHERE doctor.doctor_ID = NEW.doctor_ID) IS NULL)
	THEN RAISE(FAIL, 'ERROR: This doctor ID does not exist yet.')
END;
END;
CREATE TRIGGER exam_patient_ID_DoesNotExist BEFORE INSERT ON exam
BEGIN
	SELECT CASE
	WHEN ((SELECT patient.patient_ID FROM patient WHERE patient.patient_ID = NEW.patient_ID) IS NULL)
	THEN RAISE(FAIL, 'ERROR: This patient ID does not exist yet.')
END;
END;
CREATE TRIGGER medication_ID_ExistsAlready BEFORE INSERT ON medication
BEGIN
	SELECT CASE
	WHEN ((SELECT medication.medication_ID FROM medication WHERE medication.medication_ID = NEW.medication_ID) IS NOT NULL)
	THEN RAISE(FAIL, 'ERROR: This medication ID already exists.')
END;
END;
CREATE TRIGGER patient_ID_ExistsAlready BEFORE INSERT ON patient
BEGIN
	SELECT CASE
	WHEN ((SELECT patient.patient_ID FROM patient WHERE patient.patient_ID = NEW.patient_ID) IS NOT NULL)
	THEN RAISE(FAIL, 'ERROR: This patient ID already exists.')
END;
END;
CREATE TRIGGER prescription_appt_ID_DoesNotExist BEFORE INSERT ON "PRESCRIPTION"
BEGIN
	SELECT CASE
	WHEN ((SELECT appointment.appt_ID FROM appointment WHERE appointment.appt_ID = NEW.appt_ID) IS NULL)
	THEN RAISE(FAIL, 'ERROR: This appointment ID does not exist yet.')
END;
END;
CREATE TRIGGER procedure_ID_ExistsAlready BEFORE INSERT ON procedure
BEGIN
	SELECT CASE
	WHEN ((SELECT procedure.procedure_ID FROM procedure WHERE procedure.procedure_ID = NEW.procedure_ID) IS NOT NULL)
	THEN RAISE(FAIL, 'ERROR: This procedure ID already exists.')
END;
END;



CREATE VIEW "Question E)" AS SELECT doctor.doctor_ID, doctor.first_Name, doctor.last_Name, appointment.appt_ID, appointment.appt_Date FROM doctor
LEFT JOIN appointment ON appointment.doctor_ID = doctor.doctor_ID;
CREATE VIEW "Question F)" AS SELECT doctor.speciality_ID, appointment.appt_Date, patient.first_Name, patient.last_Name FROM doctor
LEFT JOIN appointment on doctor.doctor_ID = appointment.doctor_ID
LEFT JOIN patient on patient.patient_ID = appointment.patient_ID
ORDER BY doctor.speciality_ID;
CREATE VIEW "Question G)" AS SELECT doctor.doctor_ID, doctor.first_Name, doctor.last_Name, count(doctor.doctor_ID) FROM procedure, doctor
WHERE doctor.speciality_ID = procedure.speciality_ID OR doctor.speciality_ID = speciality_ID2 or doctor.speciality_ID = speciality_ID3
GROUP BY doctor.first_Name
ORDER BY count(doctor.doctor_ID) DESC;
CREATE VIEW "Question H)" AS SELECT medication.medication_ID, medication.medication_Name, count(prescription.prescription_ID) FROM medication, prescription
WHERE medication.medication_ID = prescription.prescription_ID
GROUP BY prescription.prescription_ID
ORDER BY count(prescription.prescription_ID) DESC;
COMMIT;
