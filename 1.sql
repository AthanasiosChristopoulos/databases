CREATE
OR REPLACE FUNCTION RANDOM_SURNAMES (N INTEGER) RETURNS TABLE (SURNAME CHARACTER VARYING, ID INTEGER) AS $$
BEGIN
	RETURN QUERY 
	SELECT snam.surname, row_number() OVER ()::integer
	FROM (SELECT "Surname".surname
		  FROM "Surname"
		  ORDER BY random() LIMIT n) as snam; 
END;
$$ LANGUAGE 'plpgsql' VOLATILE;

----------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION RANDOM_NAMES (N INTEGER) RETURNS TABLE (NAME CHARACTER VARYING, ID INTEGER) AS $$
BEGIN
	RETURN QUERY 
	SELECT snam.name, row_number() OVER ()::integer
	FROM (SELECT "Name".name
		  FROM "Name"
		  ORDER BY random() LIMIT n) as snam; 
END;
$$ LANGUAGE 'plpgsql' VOLATILE;

CREATE OR REPLACE FUNCTION RANDOM_NAME () RETURNS TABLE (NAME CHARACTER VARYING) AS $$
BEGIN
	RETURN QUERY 
	SELECT nnn.name
	FROM "Name" nnn
	ORDER BY random() 
	LIMIT 1; 
END;
$$ LANGUAGE 'plpgsql' VOLATILE;


----------------------------------------------------------------------------------------------------------------------------

-- CREATE OR REPLACE FUNCTION generate_amka(N INTEGER)
-- RETURNS TABLE (amka character varying) AS $$
-- BEGIN
--     RETURN QUERY
--     SELECT DISTINCT lpad(floor(random() * 100000000000)::text, 11, '0')::character varying
--     FROM generate_series(1, N * 10) gs
--     LIMIT N;
-- END;
-- $$ LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION generate_amka()
RETURNS TABLE (amka character varying) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT lpad(floor(random() * 100000000000)::text, 11, '0')::character varying;
END;
$$ LANGUAGE plpgsql VOLATILE;


-- SELECT * FROM generate_amka(5);
----------------------------------------------------------------------------------------------------------------------------

-- CREATE OR REPLACE FUNCTION random_lab(N INTEGER)
-- RETURNS TABLE (lab_code integer) AS $$
-- BEGIN
--     RETURN QUERY
--     SELECT l.lab_code 
--     FROM "Lab" l
--     ORDER BY random()  -- Order rows randomly
--     LIMIT N;           -- Limit to N rows
-- END;
-- $$ LANGUAGE plpgsql VOLATILE;

CREATE OR REPLACE FUNCTION random_lab()
RETURNS TABLE (lab_code integer) AS $$
BEGIN
    RETURN QUERY
    SELECT l.lab_code 
    FROM "Lab" l
    ORDER BY random()  -- Order rows randomly
    LIMIT 1;           -- Limit to N rows
END;
$$ LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------------------------------------------------------------------

-- Creating the function to generate N random ranks
CREATE OR REPLACE FUNCTION generate_rank()
RETURNS TABLE (rank public.rank_type) AS $$
BEGIN
    RETURN QUERY
    SELECT enumlabel::public.rank_type
    FROM pg_enum
    WHERE enumtypid = 'public.rank_type'::regtype
    ORDER BY random()
    LIMIT 1;
END;
$$ LANGUAGE plpgsql VOLATILE;

----------------------------------------------------------------------------------------------------------------------------

	CREATE OR REPLACE FUNCTION greek_to_latin(greek_text text)
RETURNS text LANGUAGE sql AS $$
    SELECT translate(
        greek_text,
        'αβγδεζηθικλμνξοπρστυφχψωάέήίϊΐόύϋΰώΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩΆΈΉΊΪΊΌΎΫΰΏ',
        'abgdeziiklmnxoprstufchpswaeiiyioyyoabgdeziiklmnxoprstufchpswaeiiyioyyo'
    );
$$;

----------------------------------------------------------------------------------------------------------------------------

-- DROP FUNCTION generate_professors(integer);
-- CREATE OR REPLACE FUNCTION generate_professors (N INTEGER) 
-- RETURNS TABLE (name character varying, surname character varying, amka character varying, labjoins integer, 
-- rank rank_type, father_name character varying, email character varying)
-- AS $$
-- BEGIN
-- 	RETURN QUERY 
-- 	-- SELECT n1.name, s.surname, generate_amka().amka, random_lab().lab_code, generate_rank().rank
-- 	SELECT n1.name, s.surname, generate_amka(), random_lab(), generate_rank(), random_name(), CONCAT(s.surname, '@tuc.gr')
-- 	FROM random_names(N) n1 JOIN random_surnames(N) s USING (id); 
-- END;
-- $$ LANGUAGE 'plpgsql' VOLATILE;


-- DECLARE
--     amka1 character varying;
--     labjoins1 integer;
--     rank1 rank_type;
--     name1 character varying;
--     father_name1 character varying;
--     surname1 character varying;
--     email1 character varying;

-- SELECT amka, labjoins, rank, name, father_name, surname, email INTO amka1, labjoins1, rank1, name1, father_name1, surname1, email1 FROM generate_professors(100);

-- INSERT INTO "Professor" (amka, labjoins, rank) VALUES (amka1, labjoins1, rank1);
-- INSERT INTO "Professor" SELECT amka, labjoins, rank FROM generate_professors(100);
-- INSERT INTO "Person" SELECT amka, name, father_name, surname, email FROM generate_professors(100);

----------------------------------------------------------------------------------------------------------------------------


-- DROP FUNCTION IF EXISTS generate_professors(integer);

-- CREATE OR REPLACE FUNCTION generate_professors (N INTEGER) 
-- RETURNS TABLE (name character varying, surname character varying, amka character varying, labjoins integer, rank rank_type, father_name character varying) AS $$
-- DECLARE
--     random_amka character varying;
--     random_name character varying;
--     random_father_name character varying;
--     random_surname character varying;
--     random_father_name character varying;
--     random_email character varying;
--     random_lab_code integer;
--     random_rank rank_type;
-- BEGIN
--     -- Generate N random professors
--     RETURN QUERY
--     SELECT 
--         (SELECT name1 INTO random_name FROM n1 LIMIT 1) AS name1,
--         (SELECT surname FROM s LIMIT 1) AS surname,
        
--         (SELECT generate_amka() INTO random_amka) AS amka,
--         (SELECT random_lab(N) INTO random_lab_code) AS labjoins,
--         (SELECT generate_rank(N) INTO random_rank) AS rank,
        
--         (SELECT random_name() INTO random_father_name) AS father_name,
--         (SELECT CONCAT(random_surname.surname, '@example.com') INTO random_email) AS email
--     FROM random_names(N) n1 
--     JOIN random_surnames(N) s 
--     USING (id);

--     -- Insert data into "Person" table
--     INSERT INTO "Person" (amka, name, father_name, surname, email) 
--     VALUES (random_amka, random_name, random_father_name, random_surname.surname, random_email);

--     -- Insert data into "Professor" table
--     INSERT INTO "Professor" (amka, labjoins, rank) 
--     VALUES (random_amka, random_lab_code, random_rank);
-- END;
-- $$ LANGUAGE 'plpgsql' VOLATILE;

----------------------------------------------------------------------------------------------------------------------------

-- SELECT * FROM random_surnames(100);
-- SELECT * FROM random_lab(100);
-- SELECT * FROM generate_rank(100);

-- SELECT * FROM generate_professors(100);

----------------------------------------------------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS generate_professors(integer);

CREATE OR REPLACE FUNCTION generate_professors (N INTEGER) 
RETURNS void
AS $$
BEGIN
    -- Insert data into both Person and Professor tables at once
    WITH generated_data AS (
        SELECT 
            n1.name, 
            s.surname, 
            generate_amka() AS amka, 
            random_lab() AS labjoins, 
            generate_rank() AS rank, 
            random_name() AS father_name,
            CONCAT(LOWER(greek_to_latin(s.surname)), '@tuc.gr') AS email
        FROM random_names(N) n1 
        JOIN random_surnames(N) s USING (id)
    )
    INSERT INTO "Person" (amka, name, father_name, surname, email)
    SELECT amka, name, father_name, surname, email FROM generated_data;

    -- INSERT INTO "Professor" (amka, labjoins, rank)
    -- SELECT amka, labjoins, rank FROM generated_data;
END;
$$ LANGUAGE 'plpgsql' VOLATILE;

SELECT generate_professors(100);
SELECT * FROM "Person";

