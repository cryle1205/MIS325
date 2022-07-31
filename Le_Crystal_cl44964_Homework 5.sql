------Homework 5; Crystal Le- cl44964-------

-----Problem 1; author: Crystal Le (cl44964)
SELECT DISTINCT title, format, genre, isbn
FROM title
WHERE title_id IN 
      (SELECT title_id 
       FROM patron_title_holds
       )
ORDER BY genre, title;

-----Problem 2; author: Crystal Le (cl44964)
SELECT title, publisher, number_of_pages, genre
FROM title 
WHERE number_of_pages > ALL (SELECT AVG(number_of_pages)
                         FROM title);
                         

-----Problem 3; author: Crystal Le (cl44964)                         
SELECT first_name, last_name, email
FROM patron 
WHERE patron_id NOT IN 
      (SELECT patron_id
       FROM patron_phone 
       )
ORDER BY last_name;
       
-----Problem 4; author: Crystal Le (cl44964)
SELECT a.title, a.publisher, a.genre, a.ISBN 
FROM title a  INNER JOIN (SELECT publisher, count(title) as title_count 
                   FROM title 
                   GROUP BY publisher
                   HAVING count(title) > 3
                   )  sub ON a.publisher = sub.publisher
ORDER BY a.publisher;


-----Problem 5; author: Crystal Le (cl44964)
SELECT patron_id, email, accrued_fees, primary_branch
FROM patron 
WHERE accrued_fees > 0 AND patron_id IN 
      (SELECT DISTINCT patron_id
       FROM checkouts
       WHERE date_in IS NULL 
       )
ORDER BY primary_branch, email;

-----Problem 6; author: Crystal Le (cl44964)
SELECT  sysdate,
        TO_CHAR(sysdate, 'YEAR') as formatted1,
        TRIM(TO_CHAR(sysdate,'DAY')) ||', '|| TO_CHAR(sysdate,'MON-YY') as formatted2,
        TO_CHAR(sysdate, 'HH')         as formatted3,
        TO_DATE('01-JAN-22')- sysdate as formatted4,
        TO_CHAR(sysdate,'mon dy, YYYY') as formatted5
FROM dual;

-----Problem 7; author: Crystal Le (cl44964)
SELECT first_name || ' ' || last_name AS patron, 
       'Checkout ' || checkout_id || ' due back on ' || due_back_date AS checkout_due_back,
       NVL2(date_in, 'Returned', 'Not returned yet') AS return_status,
       'Accrued fee total is:' || to_char(accrued_fees, '$99.99')   AS fees
FROM patron p INNER JOIN checkouts c
     ON p.patron_id = c.patron_id
ORDER BY NVL2(date_in, 'Returned', 'Not returned yet'), due_back_date;

-----Problem 8; author: Crystal Le (cl44964)
SELECT LOWER(SUBSTR(first_name, 1, 1)) ||'. '|| UPPER(last_name) AS inactive_patron
FROM patron 
WHERE patron_id NOT IN 
    (SELECT patron_id 
     FROM checkouts
     )
ORDER BY last_name;

-----Problem 9; author: Crystal Le (cl44964)
SELECT title as "Title.Title", 
       LENGTH(title) AS "Length of Title", 
       publish_date AS "Title.Publish_Date",
       FLOOR((sysdate -  publish_date)/365.25) AS "Age_of_Book"
FROM title
WHERE ((sysdate -  publish_date)/365.25) >=5
ORDER BY ((sysdate -  publish_date)/365.25);

-----Problem 10; author: Crystal Le (cl44964)
SELECT branch_id,
       SUBSTR(branch_name,1,instr(branch_name,' ')) as district,
       SUBSTR(address,1,instr(address,' ')) as street_num,
       SUBSTR(address,instr(address, ' ') +1) as street_name
FROM location;      
       
----Problem 11; author: Crystal Le (cl44964)
SELECT first_name, last_name,
       REPLACE(email, SUBSTR(email,0,instr(email, '@')-1), '*******') AS redacted_email,
       phone_type,
       replace(phone,substr(phone,1,7) , '***-***') AS redacted_phone
FROM PATRON p  JOIN patron_phone pp
     ON p.patron_id = pp.patron_id
ORDER BY last_name;


----Problem 12; author: Crystal Le (cl44964)
select  title,
        publisher, 
        number_of_pages,
        genre,
        CASE 
            WHEN number_of_pages > 700 THEN 'College'
            WHEN (number_of_pages between 250 and 700) THEN 'High-School'
            ELSE 'Middle-School'
        END as reading_level
from title
order by reading_level, title;

----Problem 13; author: Crystal Le (cl44964)
SELECT  title,
        count(DISTINCT checkout_id) as number_of_checkouts, 
        dense_rank() OVER (order by count( DISTINCT checkout_id)) as popularity_rank
FROM title_loc_linking tt left join checkouts c on tt.title_copy_id = c.title_copy_id 
               left join title t on t.title_id = tt.title_id
group by title; 


----Problem 14; author: Crystal Le (cl44964)
Select * 
FROM (SELECT title, 
      count(DISTINCT checkout_id) as number_of_checkouts,
      ROW_NUMBER() OVER(ORDER BY count(DISTINCT checkout_id)) AS row_number
      FROM title_loc_linking tt left join checkouts c on tt.title_copy_id = c.title_copy_id 
               left join title t on t.title_id = tt.title_id
group by title)
WHERE Row_Number = 58;

