-- Clinic Booking System Database Schema
-- Author:Nicole Ochieng
-- Description: SQL script to create the core schema for a Clinic Booking System
-- Includes patients, doctors, appointments, medical records, prescriptions, insurance, and patient-doctor many-to-many mapping

-- Table: patients
Use clinic_db;
CREATE TABLE patients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    phone VARCHAR(20),
    email VARCHAR(255) UNIQUE,
    address TEXT
);

-- Table: insurance_profiles (1-to-1 with patients)
CREATE TABLE insurance_profiles (
    patient_id INT PRIMARY KEY,
    provider_name VARCHAR(255) NOT NULL,
    policy_number VARCHAR(100) UNIQUE NOT NULL,
    coverage_details TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

-- Table: doctors
CREATE TABLE doctors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    specialization VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255) UNIQUE
);

-- Table: patient_doctor_map (M-M between patients and doctors)
CREATE TABLE patient_doctor_map (
    patient_id INT,
    doctor_id INT,
    PRIMARY KEY (patient_id, doctor_id),
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

-- Table: appointments
CREATE TABLE appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    reason TEXT,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

-- Table: medical_records
CREATE TABLE medical_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    diagnosis TEXT,
    treatment TEXT,
    visit_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

-- Table: prescriptions
CREATE TABLE prescriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    medical_record_id INT NOT NULL,
    medicine_name VARCHAR(255),
    dosage VARCHAR(100),
    instructions TEXT,
    FOREIGN KEY (medical_record_id) REFERENCES medical_records(id)
);

-- Sample data for testing purposes
INSERT INTO patients (full_name, date_of_birth, gender, phone, email, address)
VALUES ('Wendy Akinyi', '1990-06-15', 'Female', '0712345678', 'akiwe@gmail.com', '123 Matibabu Rd');

INSERT INTO insurance_profiles (patient_id, provider_name, policy_number, coverage_details)
VALUES (1, 'SHA', 'NH123456789', 'Covers general consultations and medication');

INSERT INTO doctors (full_name, specialization, phone, email)
VALUES ('Dr. Jackson Avery', 'Pediatrics', '0700123456', 'javery@matibabu.com');

INSERT INTO patient_doctor_map (patient_id, doctor_id)
VALUES (1, 1);

INSERT INTO appointments (patient_id, doctor_id, appointment_date, reason)
VALUES (1, 1, '2025-05-15 10:00:00', 'Routine check-up');

INSERT INTO medical_records (patient_id, doctor_id, diagnosis, treatment, visit_date)
VALUES (1, 1, 'Common cold', 'Rest and fluids', '2025-05-15');

INSERT INTO prescriptions (medical_record_id, medicine_name, dosage, instructions)
VALUES (1, 'Paracetamol', '500mg', 'Take one tablet every 8 hours for 3 days');
