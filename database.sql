set serveroutput on;
drop SEQUENCE appointments_id_seq;
drop SEQUENCE patients_id_seq;
drop SEQUENCE doctors_id_seq;
drop table appointments;
drop table doctors;
drop table patients;
---------------------------------------------------------------------------------------
--************* Q1*****************
-- Create a patient id sequence
CREATE SEQUENCE patients_id_seq 
    START WITH 1000 
    INCREMENT BY 1;

-- Create a patients Table
CREATE TABLE patients(
        pid NUMBER DEFAULT patients_id_seq.NEXTVAL PRIMARY KEY,
        first_name VARCHAR2(50) NOT NULL,
        last_name VARCHAR2(50) NOT NULL,
        date_of_birth DATE NOT NULL,
        gender VARCHAR2(10) NOT NULL,
        age NUMBER NOT NULL,
        contact_number VARCHAR2(20) NOT NULL,
        address VARCHAR2(100) NOT NULL,
        blood_group VARCHAR2(5),
        nic VARCHAR2(15)
);


-- Create a doctor id sequence

CREATE SEQUENCE doctors_id_seq
    START WITH 1 
    INCREMENT BY 1;

--create a doctors table

CREATE TABLE doctors(
    did NUMBER DEFAULT doctors_id_seq.NEXTVAL PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    nic VARCHAR2(15) NOT NULL,
    specialize VARCHAR2(100) NOT NULL
  );
  

-- Create a appointments id sequence
CREATE SEQUENCE appointments_id_seq
    START WITH 15000
    INCREMENT BY 1;

--create a appointments table
CREATE TABLE appointments(
    aid NUMBER DEFAULT appointments_id_seq.NEXTVAL PRIMARY KEY,
    patient_id NUMBER NOT NULL,
    doctor_id NUMBER NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time VARCHAR2(20) NOT NULL,
    description VARCHAR2(255) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(pid),
    FOREIGN KEY (doctor_id) REFERENCES doctors(did)
);


-- ************* Q2 *****************

--Insert Data into the patients table
INSERT INTO patients (first_name, last_name, date_of_birth, gender, age, contact_number, address, blood_group, nic)
    VALUES ('Maleesha', 'Perera', TO_DATE('2001-11-10', 'YYYY-MM-DD'), 'Male', 22, '1234567890', '81b Main St colombo', 'O+', '200158421124');
INSERT INTO patients (first_name, last_name, date_of_birth, gender, age, contact_number, address, blood_group, nic) 
    VALUES ('Sandun', 'Silva', TO_DATE('2004-02-17', 'YYYY-MM-DD'), 'Male', 19, '4567890123', '123 Kurana', 'A+','200412458421');
INSERT INTO patients (first_name, last_name, date_of_birth, gender, age, contact_number, address, blood_group, nic)
    VALUES ('Samu', 'Vihangi', TO_DATE('1985-05-20', 'YYYY-MM-DD'), 'Female', 38, '9876543210', '456a Wattala', 'A-', '198512458425');
INSERT INTO patients (first_name, last_name, date_of_birth, gender, age, contact_number, address, blood_group, nic)
    VALUES ('Sara', 'Malithi', TO_DATE('1996-09-21', 'YYYY-MM-DD'), 'Female', 27, '7777555666', '712 Kandy', 'B+', '199612452184');


--Insert Data into the doctors table
INSERT INTO doctors (name, nic, specialize)     VALUES ('Dr. Sagara Fernando', '19605612345', 'Cardiology');
INSERT INTO doctors (name, nic, specialize)     VALUES ('Dr. Vihara Perera', '198056789012', 'Dermatologist');
INSERT INTO doctors (name, nic, specialize)     VALUES ('Dr. Sanduni Welikala', '197056789018', 'Orthodentist');
INSERT INTO doctors (name, nic, specialize)     VALUES ('Dr. Nadun Vihangana', '199656789016', 'Neurologist');
INSERT INTO doctors (name, nic, specialize)     VALUES ('Dr. Vihara Fernando', '19705612345', 'Cardiology');
INSERT INTO doctors (name, nic, specialize)     VALUES ('Dr. Senali Fonseka', '19978612345', 'Cardiology');


--Insert Data into the appointments table
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, description)
    VALUES (1003, 1, TO_DATE('2023-11-16', 'YYYY-MM-DD'), '10:00 AM', 'Routine checkup');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, description)
    VALUES (1000, 3, TO_DATE('2023-11-15', 'YYYY-MM-DD'), '10:00 AM', 'Body checkup');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, description)
    VALUES (1002, 2, TO_DATE('2023-11-20', 'YYYY-MM-DD'), '8:00 AM', 'Skin checkup');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, description)
    VALUES (1001, 2, TO_DATE('2023-12-01', 'YYYY-MM-DD'), '7:00 PM', 'Brain checkup');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, description)
    VALUES (1003, 2, TO_DATE('2023-12-02', 'YYYY-MM-DD'), '7:00 PM', 'Brain checkup');
    
SELECT * FROM patients;
SELECT * FROM doctors;
SELECT * FROM appointments;


-- ************* Q3 *****************

-- SELECT with WHERE
SELECT  pid, first_name, last_name, date_of_birth, gender, age, contact_number, address, blood_group, nic
FROM patients 
WHERE age < 30;


-- SELECT with GROUP BY
SELECT  doctor_id, COUNT(*) AS appointment_count
FROM appointments 
GROUP BY doctor_id;


-- SELECT with HAVING
SELECT doctor_id, COUNT(*) AS appointment_count 
FROM appointments 
GROUP BY doctor_id 
HAVING COUNT(*) >= 2;


-- SELECT with ORDER BY
SELECT did, name, nic, specialize 
FROM doctors 
ORDER BY did DESC;




-- ************* Q4 *****************

-- Single-Row Subquery
SELECT pid, first_name, last_name, date_of_birth, gender, age, contact_number, address, blood_group, nic
FROM patients 
WHERE age = (SELECT MAX(age) FROM patients);


-- Multiple-Row Subquery
SELECT specialize, count(*) as doctor_count  
FROM doctors
GROUP BY specialize
HAVING count(*) IN
(SELECT count(*) FROM doctors
WHERE specialize = 'Cardiology');



-- ************* Q5 *****************
-- LEFT JOIN

SELECT p.pid, p.first_name, p.last_name, p.blood_group, p.nic, a.appointment_date, a.appointment_time, a.description 
FROM patients p
LEFT JOIN appointments a
ON p.pid = a.patient_id;

-- RIGHT JOIN
SELECT p.pid, p.first_name, p.last_name, p.blood_group, p.nic, a.appointment_date, a.appointment_time, a.description 
FROM patients p
RIGHT JOIN appointments a
ON p.pid = a.patient_id;


-- FULL OUTER JOIN
SELECT d.did, d.name, d.nic, d.specialize, a.appointment_date, a.appointment_time 
FROM doctors d
FULL OUTER JOIN appointments a 
ON d.did = a.doctor_id;


-- ************* Q6 *****************
-- create a view
CREATE VIEW name_combined_view AS
SELECT pid,
    first_name || ' ' || last_name AS full_name
FROM patients;

SELECT pid, fullname FROM name_combined_view;





-- ************* Q7 *****************
DECLARE
    v_patient_id patients.pid%TYPE;
    v_first_name patients.first_name%TYPE;
    v_last_name patients.last_name%TYPE;
    v_date_of_birth patients.date_of_birth%TYPE;
    v_gender patients.gender%TYPE;
    v_age patients.age%TYPE;
    v_contact_number patients.contact_number%TYPE;
    v_address patients.address%TYPE;
    v_blood_group patients.blood_group%TYPE;
    v_nic patients.nic%TYPE;
BEGIN
 -- take the user input
    v_patient_id := &input_patient_id;
    
    SELECT first_name, last_name, date_of_birth, gender, age, contact_number, address, blood_group, nic
    INTO v_first_name, v_last_name, v_date_of_birth, v_gender, v_age, v_contact_number, v_address, v_blood_group, v_nic
    FROM patients
    WHERE pid = v_patient_id;  
    
    if v_patient_id is NULL then
     DBMS_OUTPUT.PUT_LINE('no employee');
     END if;
    
    DBMS_OUTPUT.PUT_LINE('Patient Information:'); DBMS_OUTPUT.PUT_LINE('ID: ' || v_patient_id);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_first_name || ' ' || v_last_name);
    DBMS_OUTPUT.PUT_LINE('Date of Birth: ' || v_date_of_birth);
    DBMS_OUTPUT.PUT_LINE('Gender: ' || v_gender);
    DBMS_OUTPUT.PUT_LINE('Age: ' || v_age);
    DBMS_OUTPUT.PUT_LINE('Contact Number: ' || v_contact_number);
    DBMS_OUTPUT.PUT_LINE('Address: ' || v_address);
    DBMS_OUTPUT.PUT_LINE('Blood Group: ' || v_blood_group);
    DBMS_OUTPUT.PUT_LINE('NIC: ' || v_nic);
    EXCEPTION
    WHEN ERROR THEN 
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
      RETURN NULL;
    
END;

CREATE OR REPLACE FUNCTION get_employee_details(p_employee_id IN NUMBER)
RETURN employees%ROWTYPE
IS
   v_employee_rec employees%ROWTYPE;
   v_error_message VARCHAR2(100);
BEGIN
   -- Attempt to fetch the employee record
   SELECT *
   INTO v_employee_rec
   FROM employees
   WHERE employee_id = p_employee_id;

   -- If the employee is not found, raise a custom exception
   IF v_employee_rec.employee_id IS NULL THEN
      v_error_message := 'No such employee!';
      RAISE_APPLICATION_ERROR(-20001, v_error_message);
   END IF;

   -- Print employee details
   DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_employee_rec.employee_id);
   DBMS_OUTPUT.PUT_LINE('First Name: ' || v_employee_rec.first_name);
   DBMS_OUTPUT.PUT_LINE('Last Name: ' || v_employee_rec.last_name);
   DBMS_OUTPUT.PUT_LINE('Salary: ' || v_employee_rec.salary);

   -- Add more fields as needed
   RETURN v_employee_rec;
EXCEPTION
   WHEN OTHERS THEN
      -- Handle exceptions
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      RETURN NULL;
END;/


-- ************* Q8 *****************
DECLARE
    v_patient_id patients.pid%TYPE;
    v_new_address patients.address%TYPE;

BEGIN
    v_patient_id := &input_patient_id;
    v_new_address := '&input_new_address';
    
    UPDATE patients
    SET address = v_new_address
    WHERE pid = v_patient_id;

    DBMS_OUTPUT.PUT_LINE('Record updated successfully for Patient ID: ' || v_patient_id);
    DBMS_OUTPUT.PUT_LINE('Record updated successfully for Patient Address: ' || v_new_address);
END;


-- ************* Q9 *****************
DECLARE
    v_apointment_id appointments.aid%TYPE;
BEGIN
    v_apointment_id := &input_apointment_id;
    
    DELETE FROM appointments
    WHERE aid = v_apointment_id;

    DBMS_OUTPUT.PUT_LINE('Record deleted successfully for Appointment ID: ' || v_apointment_id);
END;


-- ************* Q10 *****************
DECLARE
    v_apointment_id appointments.aid%TYPE;
    v_rows_deleted NUMBER;
BEGIN
    v_apointment_id := &input_apointment_id;
    
    DELETE FROM appointments
    WHERE aid = v_apointment_id;
    v_rows_deleted := SQL%ROWCOUNT;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Record deleted successfully for Appointment ID: ' || v_apointment_id);
    DBMS_OUTPUT.PUT_LINE('Number of rows deleted: ' || v_rows_deleted);
END;

DECLARE
    
   v_salary employees.salary%TYPE;
   v_stars VARCHAR2(4000);
   
   CURSOR c_employee IS
      SELECT employee_id, salary
      FROM employees
      FOR UPDATE OF stars;
BEGIN
   FOR emp_rec IN c_employee LOOP
      -- Calculate the number of asterisks based on the salary
      v_stars := RPAD('*', TRUNC(emp_rec.salary / 1000), '*');
      
      -- Update the STARS column for the current employee
      UPDATE employees
      SET stars = v_stars
      WHERE CURRENT OF c_employee;
   END LOOP;
   
   COMMIT;
END;
/

DECLARE
i number(1);
j number(1);
BEGIN
<< outer_loop >>
FOR i IN 1..3 LOOP
<< inner_loop >>
FOR j IN 1..3 LOOP
dbms_output.put_line('i is: '|| i || ' and j is: ' || j);
END loop inner_loop;
END loop outer_loop;
END;
/

set serveroutput on
DECLARE
a number(2):=10;
begin
WHILE a<20 LOOP
   a:=a+1;
   IF a=15 THEN
    continue; -- Skip the Loop
   end if;
   DBMS_OUTPUT.PUT_LINE('Value of a is ' ||a);
END LOOP;
END;


DECLARE
a number(2):=10;
begin
while a<20 loop
DBMS_OUTPUT.PUT_LINE('Value of a is ' ||a);
a:=a+1;

END LOOP;
END;



























   