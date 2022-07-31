------Homework 8: ETL Assignment; author: cl44964-------


-----Problem 1; author: Crystal Le cl44964------
--select *
--from patron_dw;

---Fields in common: first_name, last_name, email, phone, zip, and maybe "ID"

-----Problem 2; author: Crystal Le cl44964------
CREATE TABLE patron_dw
(  data_source           VARCHAR(4),
   user_id               number,
   first_name            varchar(50),
   last_name             varchar(50),
   email                 varchar(50),
   phone                 varchar(12),
   zip                   varchar(10),
   CONSTRAINT  pk_id_source   PRIMARY KEY (data_source, user_id)
);



-----Problem 3; author: Crystal Le cl44964------
CREATE OR REPLACE VIEW patron_view AS
SELECT      'PATR' AS data_source,
            patron_id AS user_id,
            first_name,
            last_name,
            email,
            phone,
            zip
FROM        patron;

CREATE OR REPLACE VIEW book_club_signup_view AS
SELECT      'CLUB' AS data_source,
            book_club_signup_id AS user_id,
            bc_first_name AS first_name,
            bc_last_name AS last_name,
            bc_email AS email,
            SUBSTR(bc_phone, 2, 3) || '-' || SUBSTR(bc_phone, 6, 3) || SUBSTR(bc_phone, 9, 5) AS phone,
            bc_zip_code AS zip
FROM        book_club_signup;


-----Problem 4; author: Crystal Le cl44964------
CREATE OR REPLACE PROCEDURE insert_patron_dw_proc
AS 
BEGIN

    
        INSERT INTO patron_dw
        SELECT pv.data_source, pv.user_id, pv.first_name, pv.last_name, pv.email, pv.phone, pv.zip
        FROM patron_view pv LEFT JOIN patron_dw dw
            ON pv.user_id = dw.user_id
            AND pv.data_source = dw.data_source
        WHERE dw.user_id IS NULL; 
        
       INSERT INTO patron_dw
       SELECT bv.data_source, bv.user_id, bv.first_name, bv.last_name, bv.email, bv.phone, bv.zip
        FROM book_club_signup_view bv LEFT JOIN patron_dw dw
            ON bv.user_id = dw.user_id
            AND bv.data_source = dw.data_source
        WHERE dw.user_id IS NULL; 
        
END;
/


-----Problem 5; author: Crystal Le cl44964------
CREATE OR REPLACE PROCEDURE update_patron_dw_proc
AS 
BEGIN


        MERGE INTO patron_dw dw
            USING patron_view pv
            ON (dw.user_id = pv.user_id AND dw.data_source = 'PATR')
        WHEN MATCHED THEN 
            UPDATE SET  dw.first_name = pv.first_name, 
                        dw.last_name = pv.last_name,
                        dw.email = pv.email,
                        dw.phone = pv.phone,
                        dw.zip = pv.zip;
                    
        MERGE INTO patron_dw dw
            USING book_club_signup_view bv
            ON (dw.user_id = bv.user_id AND dw.data_source = 'CLUB')
        WHEN MATCHED THEN 
            UPDATE SET  dw.first_name = bv.first_name, 
                        dw.last_name = bv.last_name,
                        dw.email = bv.email,
                        dw.phone = bv.phone,
                        dw.zip = bv.zip; 
END;
/

-----Problem 6; author: Crystal Le cl44964------
CREATE OR REPLACE PROCEDURE user_etl_proc
AS 
BEGIN
      
      ---insert statement for patron_view table into patron_dw
        INSERT INTO patron_dw
        SELECT pv.data_source, pv.user_id, pv.first_name, pv.last_name, pv.email, pv.phone, pv.zip
        FROM patron_view pv LEFT JOIN patron_dw dw
            ON pv.user_id = dw.user_id
            AND pv.data_source = dw.data_source
        WHERE dw.user_id IS NULL; 
       
       ---insert statement for book_club_signup_view table into patron_dw 
       INSERT INTO patron_dw
       SELECT bv.data_source, bv.user_id, bv.first_name, bv.last_name, bv.email, bv.phone, bv.zip
        FROM book_club_signup_view bv LEFT JOIN patron_dw dw
            ON bv.user_id = dw.user_id
            AND bv.data_source = dw.data_source
        WHERE dw.user_id IS NULL; 
        
         ---Merge/update statement for patron_view table into patron_dw
        MERGE INTO patron_dw dw
            USING patron_view pv
            ON (dw.user_id = pv.user_id AND dw.data_source = 'PATR')
        WHEN MATCHED THEN 
            UPDATE SET  dw.first_name = pv.first_name, 
                        dw.last_name = pv.last_name,
                        dw.email = pv.email,
                        dw.phone = pv.phone,
                        dw.zip = pv.zip;
     
      ---Merge/update statement for book_club_signup_view table into patron_dw           
        MERGE INTO patron_dw dw
            USING book_club_signup_view bv
            ON (dw.user_id = bv.user_id AND dw.data_source = 'CLUB')
        WHEN MATCHED THEN 
            UPDATE SET  dw.first_name = bv.first_name, 
                        dw.last_name = bv.last_name,
                        dw.email = bv.email,
                        dw.phone = bv.phone,
                        dw.zip = bv.zip; 
        
END;
/


-----Problem 7; author: Crystal Le cl44964------
----call proc to check for no errors
CALL user_etl_proc();

----checking patron_dw table
select *
from patron_dw;

---INSERTS FOR TESTING RECORDS
INSERT INTO patron VALUES (35, 'Jane', 'Doe', 'janedoe@mac.com','1234 Hookem St', 'NULL', 'Austin', 'TX', '78705', '123-456-7890', '0', '1');
INSERT INTO book_club_signup VALUES (25, 'Jane', 'Doe', 'janedoe@mac.com', '(123)456-7890', '78705');

---UPDATES FOR TESTING RECORDS
UPDATE patron
SET first_name = 'John', email = 'johndoe@mac.com', phone = '111-111-1111' 
WHERE patron_id = 35;

UPDATE book_club_signup
SET bc_first_name = 'John', bc_email = 'johndoe@mac.com', bc_phone = '111-111-1111' 
WHERE book_club_signup_id = 25;

--commit;


-----DROP STATEMENTS FOR TESTING
DROP TABLE patron_dw;
DROP VIEW patron_view; 
DROP VIEW book_club_signup_view;
DROP PROCEDURE user_etl_proc;