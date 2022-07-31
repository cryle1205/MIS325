----Homework 4: Summary/Subquery Assignment----


----Problem 1; Author Crystal Le (cl44964)----
SELECT first_name || ' ' || last_name AS full_name, phone_type, phone
FROM patron p  INNER JOIN patron_phone t 
            ON p.patron_id = t.patron_id
ORDER BY last_name ASC, phone_type DESC; 

----Problem 2; Author Crystal Le (cl44964)----
SELECT first_name, last_name, email, accrued_fees
FROM patron LEFT OUTER JOIN location
            ON patron.primary_branch = location.branch_id
WHERE accrued_fees <> 0 AND branch_name = 'Northeast Central Branch' 
ORDER BY accrued_fees DESC;

----Problem 3; Author Crystal Le (cl44964)----
SELECT title AS fiction_title, number_of_pages, first_name || ' ' || last_name AS author_name 
FROM title t INNER JOIN title_author_linking lat ON t.title_id = lat.title_id
             INNER JOIN author a ON a.author_id = lat.author_id
WHERE genre = 'FIC' AND format = 'B'
ORDER BY author_name, fiction_title; 

----Problem 4; Author Crystal Le (cl44964)----
SELECT title, format, genre, isbn
FROM title t LEFT OUTER JOIN patron_title_holds hl
        ON t.title_id = hl.title_id
WHERE hold_id IS NOT NULL
ORDER BY genre, title;

----Problem 5; Author Crystal Le (cl44964)----
SELECT title, first_name, last_name, hold_id
FROM title t FULL JOIN patron_title_holds hl ON t.title_id = hl.title_id
             FULL JOIN patron p ON p.patron_id = hl.patron_id 
WHERE hold_id IS NULL OR genre = 'SCI';

----Problem 6; Author Crystal Le (cl44964)----
SELECT 'Middle School' AS reading_level, title, publisher, number_of_pages, genre
FROM title
WHERE (format = 'B' OR format= 'E') AND number_of_pages < 250
    UNION
SELECT 'High School' AS reading_level, title, publisher, number_of_pages, genre
FROM title
WHERE (Format = 'B' OR 'Format'= 'E') AND number_of_pages BETWEEN 250 AND 700
    UNION
SELECT 'College' AS reading_level, title, publisher, number_of_pages, genre
FROM title
WHERE (Format = 'B' OR 'Format'= 'E') AND number_of_pages > 700;

----Problem 7; Author Crystal Le (cl44964)----
SELECT COUNT (*) AS patron_count,
       COUNT (DISTINCT zip) AS distinct_zipcodes,
       MIN (accrued_fees) AS lowest_fees,
       AVG (accrued_fees) AS average_fees,
       MAX (accrued_fees) AS highest_fees
FROM patron;

----Problem 8; Author Crystal Le (cl44964)----
SELECT branch_name, count(first_name) AS patron_count
FROM patron FULL OUTER JOIN location 
    ON patron.primary_branch = location.branch_id
GROUP BY branch_name
ORDER BY branch_name; 

----Problem 9; Author Crystal Le (cl44964)----
SELECT zip, round(avg(accrued_fees),2) as average_accrued_fees
FROM patron INNER JOIN checkouts
    ON patron.patron_id = checkouts.patron_id
WHERE late_flag = 'N' 
GROUP BY zip
ORDER BY average_accrued_fees DESC;

----Problem 10; Author Crystal Le (cl44964)----
SELECT branch_name, round(avg(SYSDATE - due_back_date)) as avg_days_overdue
FROM location lo INNER JOIN title_loc_linking tl ON lo.branch_id = tl.last_location
                 INNER JOIN checkouts c ON tl.title_copy_id = c.title_copy_id
WHERE (SYSDATE - due_back_date) > 0 AND date_in IS NOT NULL 
GROUP BY branch_name
HAVING avg(SYSDATE - due_back_date) >= 10;

----Problem 11; Author Crystal Le (cl44964)----
SELECT t.title, t.genre, count(author_id) as author_count
FROM title_author_linking tal JOIN title t ON t.title_id = tal.title_id
group by t.genre, t.title
HAVING count(author_id) > 1
ORDER BY genre DESC, title ASC; 


----Problem 12; Author Crystal Le (cl44964)----
SELECT t.title, t.genre, count(tal.author_id) as author_count
FROM title_author_linking tal JOIN title t ON t.title_id = tal.title_id
    JOIN author a ON tal.author_id = a.author_id
where a.last_name like '%PhD%'
group by t.genre, t.title
HAVING count(tal.author_id) > 1
ORDER BY genre DESC, title ASC; 

----Problem 13; Author Crystal Le (cl44964)----
--Part A--
SELECT city, sum(accrued_fees) as average_accrued_fees
FROM patron
GROUP BY rollup(city);

--- This gives us the insight on collectively how much late fees were accrued per city and a subtotal of how much in total of all cities---
--- This can be used to see patrons in which city do better with turning in books on time---

--Part B--
SELECT city, SUM(accrued_fees) AS average_accrued_fees, zip
FROM patron
GROUP BY rollup(city, zip)
HAVING SUM(accrued_fees) > 0;

--- As for this part, this query allows us to see clearly which zip codes are accruing fees the most which are: 73946 and 73940---


----Problem 14; Author Crystal Le(cl44964)----
SELECT lo.branch_id, lo.branch_name, count(tl.title_id) AS count_of_title_copies
FROM location lo FULL OUTER JOIN title_loc_linking tl ON lo.branch_id = tl.last_location
GROUP BY lo.branch_id, lo.branch_name
HAVING count(tl.title_id) NOT BETWEEN 40 and 50;







