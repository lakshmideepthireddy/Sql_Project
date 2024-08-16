create database projectsql3;
use projectsql3;
-- Part 3:  Triggers
-- Question 1:
-- Create two called Student_details and Student_details_backup.
-- Table 1: Attributes 		Table 2: Attributes
-- Student id, Student name, mail id, mobile no.	Student id, student name, mail id, mobile no.
-- You have the above two tables Students Details and Student Details Backup. Insert some records into Student details. 
-- Problem:
-- Let’s say you are studying SQL for two weeks. In your institute, there is an employee who has been maintaining the student’s details and Student Details Backup tables. 
-- He / She is deleting the records from the Student details after the students completed the course and 
-- keeping the backup in the student details backup table by inserting the records every time. 
-- You are noticing this daily and now you want to help him/her by not inserting the records for backup purpose when he/she delete the records.
-- write a trigger that should be capable enough to insert the student details in the backup table whenever the employee deletes records from the student details table.
-- Note: Your query should insert the rows in the backup table before deleting the records from student details.

create table Student_details(
Student_id varchar(20),
Student_name varchar(20),
Mail_id varchar(30),
Mobile_no bigint);
create table Student_details_backup(
Student_id varchar(20),
Student_name varchar(20),
Mail_id varchar(30),
Mobile_no bigint);

insert into Student_details values(101,"Aisha","Aisha@101gmail.com",9898741311),
(102,"Raj","Raj@102gmail.com",9898741312),
(103,"Swapna","Swapna@103gmail.com",9898741313),
(104,"krish","krish@104gmail.com",9898741314),
(105,"Adithya","Adithya@105gmail.com",9898741315),
(106,"Akshaya","Akshaya@106gmail.com",9898741316),
(107,"Raviteja","Raviteja@107mail.com",9898741317),
(108,"Mayur","Mayur@108gmail.com",9898741318),
(109,"Aryan","Aryan@109gmail.com",9898741319),
(110,"Bhoomika","Bhoomika@101gmail.com",9898741320);

DELIMITER $$
create trigger temp_table
before delete on Student_details
for each row
begin
 insert into Student_details_backup(Student_id,Student_name,Mail_id,Mobile_no) values
 (old.Student_id,old.Student_name,old.Mail_id,old.Mobile_no);
 end;
 $$


select*from Student_details;
Delete from Student_details where Student_name="Raj";
select*from Student_details_backup;