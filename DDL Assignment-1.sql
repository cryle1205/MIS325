--DDL Script Assignment--
--Crystal Le's Homework 2--
--- DROP TABLE SEQUENCE ; Author: Crystal Le cl44964---
DROP TABLE Checkouts; 
DROP TABLE Patron_Title_Holds;
DROP TABLE Patron_Phone; 
DROP TABLE Patron; 
DROP TABLE Title_Loc_Linking;
DROP TABLE Title_Author_Linking;
DROP TABLE Title;
DROP TABLE "Location";
DROP TABLE Author; 

---DROP SEQUENCES; Author: Crystal Le cl44964---
DROP SEQUENCE Patron_ID_seq;
DROP SEQUENCE Phone_ID_seq;
DROP SEQUENCE Title_ID_seq;
DROP SEQUENCE Author_ID_seq;
DROP SEQUENCE Title_Copy_ID_seq;

---- CREATE SEQUENCES FOR SPECIFIC IDs ; Author: Crystal Le cl44964----    
CREATE SEQUENCE Patron_ID_seq
    START WITH 1 
    INCREMENT BY 1;
CREATE SEQUENCE Phone_ID_seq
    START WITH 1 
    INCREMENT BY 1;
CREATE SEQUENCE Title_ID_seq
    START WITH 1 
    INCREMENT BY 1;
CREATE SEQUENCE Author_ID_seq
    START WITH 1 
    INCREMENT BY 1;
CREATE SEQUENCE Title_Copy_ID_seq
    START WITH 100001 
    INCREMENT BY 1; 

---- CREATE Author Table ; Author: Crystal Le cl44964----
CREATE TABLE Author
(
    Author_ID       number(10)  primary key,
    First_Name      varchar(20) not null,
    Middle_Name     varchar(20),
    Last_Name       varchar(30) not null,
    Bio_Notes       varchar(100)
);

---- CREATE Location Table ; Author: Crystal Le cl44964----
CREATE TABLE "Location"
(
    Branch_ID       number(10)  primary key,
    Branch_Name     varchar(20) not null      UNIQUE,
    Address         varchar(20) not null,
    City            varchar(30) not null,
    "State"         char   (2)  not null,
    Zip             char   (5)  not null,
    Phone           char   (12) not null
);

---- CREATE Title Table ; Author: Crystal Le cl44964----
CREATE TABLE  Title
(
    Title_ID        number(10)  primary key,
    Title           varchar(45) not null,
    Publisher       varchar(45) not null,
    Publish_Date    date        not null,
    Number_of_pages varchar(5),
    "Format"        varchar(15) not null,
    Genre           char(3)     not null,
    ISBN            char(17)    not null    unique
);

---- CREATE Title_Author_Linking Table ; Author: Crystal Le cl44964----
CREATE TABLE Title_Author_Linking
(
    Author_ID   number(10)  not null,
    Title_ID    number(10)  not null, 
    CONSTRAINT author_title_pk PRIMARY KEY (Author_ID, Title_ID),
    CONSTRAINT author_id_fk FOREIGN KEY (Author_ID) REFERENCES Author (Author_ID),
    CONSTRAINT title_id_fk FOREIGN KEY (Title_ID) REFERENCES Title (Title_ID)
);

---- CREATE Title_Loc_Linking Table ; Author: Crystal Le cl44964----
CREATE TABLE Title_Loc_Linking 
(
    Title_Copy_ID  number(10)   ,
    Title_ID       number(10)   not null,
    Last_Location  number(10)   not null,
    Status         char(1)      not null,
    CONSTRAINT status_check CHECK (status in ('T','P','A','O')),
    CONSTRAINT title_copy_id_pk PRIMARY KEY (Title_Copy_ID),
    CONSTRAINT title_id_fk_1 FOREIGN KEY (Title_ID) REFERENCES Title (Title_ID),
    CONSTRAINT last_location_fk FOREIGN KEY (Last_Location) REFERENCES "Location" (Branch_ID)
);

---- CREATE Patron Table ; Author: Crystal Le cl44964----
CREATE TABLE Patron
(
    Patron_ID       number(10)  primary key,
    First_Name      varchar(20) not null, 
    Last_Name       varchar(30) not null,
    Email           varchar(25) not null    UNIQUE,
    Address_Line_1  varchar(40) not null,
    Address_Line_2  varchar(40), 
    City            varchar(30) not null,
    "State"         char   (2)  not null,
    Zip             char   (5)  not null, 
    Accrued_Fees    number (5)  DEFAULT 0, 
    Primary_Branch  number(10) not null,
    CONSTRAINT primary_branch_id_fk FOREIGN KEY (Primary_Branch) REFERENCES "Location" (Branch_ID),
    CONSTRAINT email_length_check   CHECK(LENGTH(Email) >7)
);

---- CREATE Patron_Phone Table ; Author: Crystal Le cl44964----
CREATE TABLE Patron_Phone
(
    Phone_ID        number (10) not null,
    Patron_ID       number (10) not null,
    Phone_Type      varchar(15) not null,
    Phone           char   (12) not null,
    CONSTRAINT phone_id_pk PRIMARY KEY (Phone_ID),
    CONSTRAINT patron_id_fk FOREIGN KEY (Patron_ID) REFERENCES Patron (Patron_ID)
);

---- CREATE Patron_Title_Holds Table ; Author: Crystal Le cl44964----
CREATE TABLE Patron_Title_Holds
(
    Hold_ID         number(10),
    Patron_ID       number(10)  not null,
    Title_ID        number(10)  not null,
    Date_Held       date        not null,
    CONSTRAINT hold_id_pk PRIMARY KEY (Hold_ID),
    CONSTRAINT patron_id_fk_1 FOREIGN KEY (Patron_ID) REFERENCES Patron (Patron_ID),
    CONSTRAINT title_id_fk_3 FOREIGN KEY (Title_ID) REFERENCES Title (Title_ID)
);
---- CREATE Checkouts Table ; Author: Crystal Le cl44964----
CREATE TABLE Checkouts
(
    Checkout_ID     number(10)  ,
    Patron_ID       number(10)  not null,
    Title_Copy_ID   number(10)  not null,
    Date_Out        date        DEFAULT SYSDATE,
    Due_Back_Date   date        not null,
    Date_In         date,
    Times_Renewed   char(1)     DEFAULT 0,
    Late_Flag       char(1)     DEFAULT 'N',
    CONSTRAINT checkout_id_pk PRIMARY KEY (Checkout_ID),
    CONSTRAINT times_renewed_ck CHECK (Times_Renewed <= 2),
    CONSTRAINT patron_id_fk_2 FOREIGN KEY (Patron_ID) REFERENCES Patron (Patron_ID),
    CONSTRAINT title_copy_id_fk FOREIGN KEY (Title_Copy_ID) REFERENCES Title_Loc_Linking (Title_Copy_ID)
);

-------Inputting Data; Author: Crystal Le cl44964------
------Created 6 Locations; Author: Crystal Le cl44964----
INSERT INTO "Location" 
VALUES ('0001', 'Cypress HC', '123 Main St', 'Cypress', 'TX', '78705', '123-456-7890');
INSERT INTO "Location" 
VALUES ('0002', 'Houston HC', '345 Not Main St', 'Houston', 'TX', '78705', '111-222-3333');
INSERT INTO "Location" 
VALUES ('0003', 'Katy FB', '678 North St', 'Katy', 'TX', '78705', '444-555-6666');
INSERT INTO "Location" 
VALUES ('0004', 'Memorial HC', '901 South St', 'Houston', 'TX', '78705', '777-888-9999');
INSERT INTO "Location" 
VALUES ('0005', 'Tomball HC', '111 West St', 'Tomball', 'TX', '78705', '101-202-3030');
INSERT INTO "Location" 
VALUES ('0006', 'Spring HC', '222 East St', 'Spring', 'TX', '78705', '404-505-6060');

COMMIT;
--Created 2 patrons; Author: Crystal Le cl44964----
INSERT INTO Patron
VALUES ('1205', 'Crystal', 'Le', 'cl44964@utexas.edu', '2815 Guadalupe St.', NULL, 'Austin', 'TX', '78705', NULL, '000001');
INSERT INTO Patron
VALUES ('1305', 'Jane', 'Doe', 'jd0000@utexas.edu', '1234 Hook Horns Rd', NULL, 'Austin', 'TX', '78705', NULL, '000001');

COMMIT;
--Created 3 Patron Phones; Author: Crystal Le cl44964----
INSERT INTO Patron_Phone
VALUES ('0001', '1305', 'Mobile', '000-000-0000');
INSERT INTO Patron_Phone
VALUES ('0002', '1205', 'Home', '010-020-3021');
INSERT INTO Patron_Phone
VALUES ('0003', '1205', 'Work', '999-512-4563');

COMMIT;
--Created 4 Titles; Author: Crystal Le cl44964----
INSERT INTO Title 
VALUES ('00001', 'I like Cheese', 'Horn House', DATE '2000-01-01', '112', 'HB', 'FUN', '12345678900000004');
INSERT INTO Title 
VALUES ('00002', 'I like to Sleep', 'Aggie House', DATE '2001-01-01', '311', 'HB', 'MYS', '12345678900000003');
INSERT INTO Title 
VALUES ('00003', 'Cooking with Ks', 'Jessie Publisher', DATE '2002-01-01', '256', 'HB', 'GEO', '12345678900000002');
INSERT INTO Title 
VALUES ('00004', 'How to Learn', 'Cherry Publisher', DATE '2003-01-01', '206', 'AH', 'SCI', '12345678900000001');

COMMIT;
--Create 4 Authors; Author: Crystal Le cl44964----
INSERT INTO Author
VALUES ('11', 'Johnny', NULL, 'Appleseed', NULL);
INSERT INTO Author
VALUES ('12', 'Crystal', NULL, 'Le', NULL);
INSERT INTO Author
VALUES ('13', 'Taylor', NULL, 'Swift', NULL);
INSERT INTO Author
VALUES ('14', 'Ariana', NULL, 'G', NULL);

COMMIT;
--Created Authors Link Data ; Author: Crystal Le cl44964----
INSERT INTO Title_Author_Linking
VALUES ('11' , '00001');
INSERT INTO Title_Author_Linking
VALUES ('12' , '00001');
INSERT INTO Title_Author_Linking
VALUES ('11' , '00002');
INSERT INTO Title_Author_Linking
VALUES ('13' , '00003');
INSERT INTO Title_Author_Linking
VALUES ('14' , '00004');

COMMIT;
--Created Title Loc Linkings; Author: Crystal Le cl44964----
INSERT INTO Title_Loc_Linking
VALUES ('1', '00001', '0001', 'P');
INSERT INTO Title_Loc_Linking
VALUES ('2', '00002', '0002', 'A');

COMMIT;
--Created Patron_title_holds with Patrons; Author: Crystal Le cl44964---- 
INSERT INTO Patron_Title_Holds
VALUES ('01', '1205', '00001', DATE '2020-02-01');
INSERT INTO Patron_Title_Holds
VALUES ('02', '1205', '00002', DATE '2020-02-02');
INSERT INTO Patron_Title_Holds
VALUES ('03', '1305', '00003', DATE '2019-03-06');

COMMIT;
--Created 3 checkouts; Author: Crystal Le cl44964---- 
INSERT INTO Checkouts 
VALUES ('120', '1205', '1', DATE '2020-03-04', DATE '2020-03-14', DATE '2020-03-20', '0', 'N');
INSERT INTO Checkouts 
VALUES ('121', '1205', '2', DATE '2020-03-04', DATE '2020-03-14', DATE '2020-03-12', '0', 'N');
INSERT INTO Checkouts 
VALUES ('123', '1305', '2', DATE '2020-03-04', DATE '2020-03-14', DATE '2020-03-11', '0', 'N');

COMMIT;
---- CREATE INDEXES FOR FOREIGN KEYS ; Author: Crystal Le cl44964----
CREATE INDEX Patron_Phone_Patron_ID_ix
    ON  Patron_Phone(Patron_ID);
CREATE INDEX Patron_Primary_Branch_ix
    ON  Patron(Primary_Branch);
CREATE INDEX Patron_Title_Holds_Patron_ID_ix
    ON  Patron_Title_Holds(Patron_ID);
CREATE INDEX Patron_Title_Holds_Patron_Title_ID_ix
    ON  Patron_Title_Holds(Title_ID);
CREATE INDEX Checkouts_Patron_ID_ix
    ON  Checkouts(Patron_ID);
CREATE INDEX Checkouts_Title_Copy_ID_ix
    ON  Checkouts(Title_Copy_ID);
CREATE INDEX Title_Loc_Linking_Title_ID_ix
    ON Title_Loc_Linking(Title_ID);
CREATE INDEX Title_Loc_Linking_Last_Location_ix
    ON Title_Loc_Linking(Last_Location);

---Created 2 own indexes; Author: Crystal Le cl44964---
CREATE INDEX Author_Last_Name_ix
    ON Author(Last_Name);
CREATE INDEX Title_Title_ix
    ON Title(Title);

