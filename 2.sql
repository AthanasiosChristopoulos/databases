-- 2)
-- 2.1)

-- SELECT am FROM "Student";
SELECT p.name, p.surname, st.am, cc.course_code, st.amka, p.amka
FROM "Student" st JOIN 
"Register" r USING(amka) JOIN 
(SELECT course_code FROM "Course" c WHERE c.typical_season = 'spring' AND c.course_code = 'ΜΑΘ 202') cc USING(course_code) 
JOIN "Person" p USING(amka);

-- 2.2)

(SELECT pep.name, pep.surname, p.amka 
FROM "Professor" p JOIN "Person" pep USING(amka)
WHERE p.labjoins = 1)
UNION
(SELECT pep.name, pep.surname, pt.amka
FROM "LabTeacher" pt JOIN "Person" pep USING(amka)
WHERE pt.labworks = 1);

-- 2.3)

SELECT * FROM "Professor" p
WHERE p.rank = (SELECT p_instance.rank 
				FROM "Professor" p_instance 
				WHERE p_instance.amka = '12076607950');

-- 2.4)

-- (SELECT pep.name, pep.surname, p.amka 
-- FROM "Professor" p JOIN "Person" pep USING(amka))
-- UNION
-- (SELECT pep.name, pep.surname, p.amka
-- FROM "LabTeacher" p JOIN "Person" pep USING(amka))
-- UNION
-- (SELECT pep.name, pep.surname, p.amka
-- FROM "Student" p JOIN "Person" pep USING(amka));

-- 2.5)

SELECT c.course_code, c.course_title 
FROM "Course" c JOIN (	SELECT *
						FROM "CourseRun" cr JOIN "Semester" s 
						ON(cr.semesterrunsin = s.semester_id and s.academic_year = '2025')) cc USING(course_code)
WHERE c.typical_season = 'spring'

