------Homework 6; Crystal Le- cl44964-------

CONNECT
SET SERVEROUTPUT ON;
-----Problem 1; author: Crystal Le (cl44964)
DECLARE
  count_holds NUMBER;
BEGIN
  SELECT COUNT(hold_id) 
  INTO count_holds
  FROM patron_title_holds p INNER JOIN title t
       ON p.title_id = t.title_id
  WHERE t.genre = 'FAN';

  IF count_holds > 4 THEN
    DBMS_OUTPUT.PUT_LINE('More than 4 Fantasy titles have holds on them');
  ELSE
    DBMS_OUTPUT.PUT_LINE('4 or less Fantasy titles have holds on them');
  END IF;
  
END;
/

---------------------
---Test Problem #1---
---------------------
DELETE FROM patron_title_holds
WHERE hold_id IN (
            SELECT hold_id
            FROM patron_title_holds p INNER JOIN title t
                ON p.title_id = t.title_id
            WHERE patron_id = 20 and genre = 'FAN');

Rollback;


-----Problem 2; author: Crystal Le (cl44964)
SET DEFINE ON;

DECLARE
    count_holds     NUMBER;
    genre_var       CHAR(3);
  
BEGIN
    genre_var := &genre;
  
    SELECT COUNT(hold_id), t.genre 
    INTO count_holds, genre_var
    FROM patron_title_holds p INNER JOIN title t
        ON p.title_id = t.title_id
    WHERE t.genre = genre_var
    GROUP BY t.genre;

  IF count_holds > 4 THEN
    DBMS_OUTPUT.PUT_LINE('There are at least 4 holds on ' || genre_var || ' titles. Actual Count = ' || count_holds);
  ELSE
    DBMS_OUTPUT.PUT_LINE('There are 4 or less holds on ' || genre_var || ' titles. Actual Count = ' || count_holds);
  END IF;
    
END;
/    

-----Problem 3; author: Crystal Le (cl44964)
BEGIN 
    INSERT INTO patron_phone
    VALUES (phone_id_seq.nextval, 2, 'mobile', '555-123-4567');
   
    DBMS_OUTPUT.PUT_LINE('1 row was inserted into the patron_phone table.');
   
    EXCEPTION
        WHEN OTHERS THEN
           DBMS_OUTPUT.PUT_LINE('Row was not inserted. Unexpected exception occurred.');
END;
/


-----Problem 4; author: Crystal Le (cl44964)
CREATE OR REPLACE PROCEDURE insert_phone
(
    patron_id_param      patron_phone.patron_id%TYPE,
    phone_type_param     patron_phone.phone_type%TYPE,
    phone_param          patron_phone.phone%TYPE
)
AS
BEGIN
   INSERT INTO patron_phone
   VALUES(phone_id_seq.NEXTVAL, patron_id_param, phone_type_param, phone_param); 

COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    
END;
/

CALL insert_phone (2, 'work', '512-987-6543');

BEGIN 
     insert_phone (2, 'fax', '512-321-1234');

END;
/
-----Problem 5; author: Crystal Le (cl44964)
DECLARE 
    TYPE fiction_table IS TABLE OF VARCHAR2(100); 
    fiction_title	   fiction_table;      
BEGIN 
    SELECT DISTINCT title
    BULK COLLECT INTO fiction_title 
    FROM title
    WHERE genre = 'FIC'
    ORDER BY title;


    FOR i IN 1..fiction_title.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Fiction title ' || i || ': ' ||
                          fiction_title(i));
    END LOOP;
END;
/

-----Problem 6; author: Crystal Le (cl44964)
DECLARE 
    CURSOR author_cursor IS
        SELECT DISTINCT(t.title), a.first_name, a.last_name 
        FROM author a JOIN title_author_linking tal ON  a.author_id = tal.author_id 
                JOIN title t ON t.title_id = tal.title_id
        WHERE genre = 'FIC'
        ORDER BY t.title;
        
    author_row author%ROWTYPE; 

BEGIN
    FOR author_row IN author_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(author_row.first_name ||' ' || author_row.last_name || ' wrote the book ' || author_row.title);
       
    END LOOP; 

END;
/
-----Problem 6 with BONUS; author: Crystal Le (cl44964)
DECLARE 
    genre_var CHAR(3);
    
    CURSOR author_cursor IS
        SELECT DISTINCT(t.title), a.first_name, a.last_name 
        FROM author a JOIN title_author_linking tal ON  a.author_id = tal.author_id 
                JOIN title t ON t.title_id = tal.title_id
        WHERE genre = genre_var
        ORDER BY t.title;
        
    author_row author%ROWTYPE; 

BEGIN
    genre_var := &genre; 
    
    FOR author_row IN author_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(author_row.first_name ||' ' || author_row.last_name || ' wrote the book ' || author_row.title);
       
    END LOOP; 

END;
/

-----Problem 7; author: Crystal Le (cl44964)
CREATE OR REPLACE FUNCTION count_holds
(
    title_id_param NUMBER
)
RETURN NUMBER
AS
    count_holds_id NUMBER;
BEGIN
    SELECT COUNT(title_id)
    INTO count_holds_id
    FROM patron_title_holds
    WHERE title_id = title_id_param;
    
    RETURN count_holds_id;
END;
/


---------------------
---Test Problem #7---
---------------------
SELECT title, count_holds(title_id)
FROM title;