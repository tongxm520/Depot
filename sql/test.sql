SELECT s1.id,s1.sName,s1.GPA,s2.id,s2.sName,s2.GPA from students s1,students s2 WHERE s1.GPA=s2.GPA;

SELECT s1.id,s1.sName,s1.GPA,s2.id,s2.sName,s2.GPA from students s1,students s2 WHERE s1.GPA=s2.GPA AND s1.id<>s2.id;

SELECT s1.id,s1.sName,s1.GPA,s2.id,s2.sName,s2.GPA from students s1,students s2 WHERE s1.GPA=s2.GPA AND s1.id<s2.id;

SELECT s1.id,s1.sName from students s1,students s2 WHERE s1.sName=s2.sName AND s1.id<s2.id;

SELECT DISTINCT s1.id,s1.sName from students s1,students s2 WHERE s1.sName=s2.sName AND s1.id<>s2.id;

SELECT DISTINCT s1.sName,COUNT(s1.sName) AS conflict_count from students s1,students s2 WHERE s1.sName=s2.sName AND s1.id<>s2.id GROUP BY s1.sName;

/*
SELECT student_id FROM applies WHERE major='CS' 
INTERSECT 
SELECT student_id FROM applies WHERE major='EE';

NOT SUPPORTED
*/


/*INTERSECT*/
SELECT DISTINCT a.student_id FROM applies a,applies b WHERE a.student_id=b.student_id AND a.major='CS' AND b.major='EE';

/*
SELECT student_id FROM applies WHERE major='CS' EXCEPT SELECT student_id FROM applies WHERE major='EE';

NOT SUPPORTED
*/

SELECT id,sName FROM students WHERE id in (SELECT student_id FROM applies WHERE major='CS') AND
NOT id in (SELECT student_id FROM applies WHERE major='EE');



SELECT cName,state FROM colleges c1 WHERE EXISTS (SELECT * FROM colleges c2 WHERE c1.state=c2.state AND c1.cName<>c2.cName);

/*find the college which has the highest enrollment*/
SELECT cName,enrollment FROM colleges c1 WHERE NOT EXISTS (SELECT * FROM colleges c2 WHERE c2.enrollment>c1.enrollment);

SELECT Max(enrollment) AS highest FROM colleges;


SELECT id,sName FROM students ORDER BY RAND() LIMIT 10;
/*order by rand() is very slow if the table is large*/


/*I would like to know is there a way to select randomly generated number between 100 and 500 along with a select query. 
Generically, FLOOR(RAND() * (<max> - <min> + 1)) + <min> generates a number between <min> and <max> inclusive.
*/
SELECT sName, FLOOR(RAND()*401)+100 AS `random_number`  FROM students;



CREATE FUNCTION myrandom(
    pmin INTEGER,
    pmax INTEGER
)
RETURNS INTEGER(11)
DETERMINISTIC
NO SQL
SQL SECURITY DEFINER
BEGIN
  RETURN FLOOR(pmin+RAND()*(pmax-pmin));
END; 

SELECT myrandom(100,300);
/*This gives you random number between 100 and 300*/

/*google: mysql random*/


SELECT id,sName,GPA FROM students WHERE GPA >= ALL (SELECT GPA FROM students);

SELECT id,sName,GPA FROM students s1 WHERE GPA > ALL (SELECT GPA FROM students s2 WHERE s2.id<>s1.id);

SELECT id,cName FROM colleges c1 WHERE NOT enrollment <= ANY (SELECT enrollment FROM colleges c2 WHERE c2.id<>c1.id);

SELECT id,sName FROM students WHERE id = any (SELECT student_id FROM applies WHERE major='CS') AND NOT id = any (SELECT student_id FROM applies WHERE major='EE');














