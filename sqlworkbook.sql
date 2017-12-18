/*2.1 SELECT*/
Select * from Employee;
Select * from Employee where LastName='King';
Select * from Employee where FirstName='Andrew' and REPORTSTO IS NULL;

/*2.2 ORDER BY*/
Select * from Album 
    order by Title DESC;
Select * from Customer order by City ASC;

/*2.3 INSERT INTO*/
Select * from Genre;
insert into Genre (Genreid, Name) values ('26', 'Trash');
insert into Genre (Genreid, Name) values ('27', 'Dumb');

select * from Employee;
insert into Employee (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, REPORTSTO, BIRTHDATE, HIREDATE, ADDRESS, CITY, STATE, COUNTRY, POSTALCODE, PHONE, FAX, EMAIL) values ('9', 'Snow', 'Jon', 'King in the North', '1', '01-JAN-88', '04-NOV-99', '200 Winter Castle', 'Winterfell', 'Westeros', 'WF', 'T2A 8P0', '+1 (301) 456-1234', '+1 (323) 123-4566', 'jsnow@gmail.com'); 
insert into Employee values ('10', 'Gib','Bob',null,null,null,null,null,null,null,null,null,null,null,null);


select * from customer;
insert into customer values ('100','Josh','Groban',null,null,null,null,null,null,null,null,'nothing.@gmai.com',null);
insert into customer values ('200', 'Grinch', 'Mr', null,null,null,null,null,null,null,null,'grinch@gmail.com',null);

/*2.4 UPDATE*/
update Customer set LastName='Walter', FirstName='Robert' where LastName='Mitchell' and FirstName='Aaron';
select * from Customer order by LastName ASC;
update Artist set name='CCR' where name='Creedence Clearwater Revival';
select * from Artist order by Name ASC;


/*2.5 LIKE*/
select * from invoice where billingaddress like 'T%';

/*2.6 BETWEEN */
select * from invoice where total between 15 and 30;
select * from employee;
select * from employee where hiredate between '01-JAN-03' and '01-MAR-04';

/*2.7 DELETE */
select * from customer order by CuSTOMERID ASC;
select * from Invoiceline order by invoiceID ASC;
select * from invoice where CustomerId='32';
delete from invoiceline where invoiceid ='267';
delete from invoiceline where invoiceid ='50';
delete from invoiceline where invoiceid='342';
delete from invoiceline where invoiceid='61';
delete from invoiceline where invoiceid='116';
delete from invoiceline where invoiceid='245';
delete from invoiceline where invoiceid='268';
delete from invoiceline where invoiceid='290';

delete from invoice where customerid='32';
Delete from customer where lastname='Walter'and firstName='Robert';

/*3.0 SQL FUNCTIONS*/


/*3.1 System Defined Functions*/

CREATE OR REPLACE FUNCTION TELLTIME RETURN TIMESTAMP
IS
rec timestamp;
BEGIN
    rec := CURRENT_TIMESTAMP;
    RETURN rec;
end;
/
select TELLTIME from dual;


--create a function that returns the length of a mediatype from the mediatype table
create or replace function medialength (X in NUMBER) return number IS 
rec number;
BEGIN
    select LENGTH(NAME) into rec FROM MEDIATYPE WHERE MEDIATYPEID=x;
    return rec;
end;
/
select medialength(1) from dual;


select length(name) from MEDIATYPE where mediatypeid='2';

--3.2 System Defined Aggregate Functions

CREATE OR REPLACE FUNCTION AVGINV return NUMBER IS
rec number;
s number;
a number;
BEGIN
    select count(*) into rec from invoice;
    select sum(total) into s from invoice;
    a:= s/rec;
    return a;    
END;
/
select AVGINV from dual;

CREATE OR REPLACE FUNCTION MOST_EXPENSIVE RETURN NUMBER IS
rec number;
BEGIN
    select MAX(UNITPRICE) into rec from TRACK;
    return rec;
END;
/
SELECT MOST_EXPENSIVE FROM DUAL;    

/*3.3 User Defined Functions*/
--create a function that returns the average price of invoiceline items with invoiceable table



CREATE OR REPLACE FUNCTION AVGPRICE RETURN NUMBER IS
cs number;
tot number;
BEGIN
tot := 0;
cs := 0;
    for i in (SELECT unitprice from INVOICELINE) 
    LOOP
        cs:= cs + i.unitprice;
        tot:= tot + 1;
    END LOOP; 
    return cs / tot;
END;
/
select AVGPRICE FROM DUAL;


CREATE OR REPLACE FUNCTION SIXTY_EIGHT (S OUT SYS_REFCURSOR) RETURN SYS_REFCURSOR AS
BEGIN
    OPEN S FOR
    SELECT FIRSTNAME, LASTNAME, BIRTHDATE FROM EMPLOYEE WHERE BIRTHDATE > '31-DEC-68';
    return S;
END;
/
DECLARE
    S SYS_REFCURSOR;
    SOME_FIRSTNAME  EMPLOYEE.FIRSTNAME%TYPE;
    SOME_LASTNAME  EMPLOYEE.LASTNAME%TYPE;
    SOME_BIRTHDATE  EMPLOYEE.BIRTHDATE%TYPE;
BEGIN
    S := SIXTY_EIGHT(S);
   LOOP
        FETCH S INTO SOME_FIRSTNAME, SOME_LASTNAME, SOME_BIRTHDATE;
        EXIT WHEN S%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(SOME_FIRSTNAME ||' '|| SOME_LASTNAME ||' IS CURRENT NAME WHO WAS BORN ' || SOME_BIRTHDATE);
    END LOOP;
    CLOSE S;
END;
/


/*4.0 Stored Procedures*/
/*4.1 Basic Stored Procedure*/
select firstname, lastname from employee;

create or replace procedure EMPLOYEE_FULL_NAME (S OUT SYS_REFCURSOR) AS
begin
    open S For
    select firstname, lastname from employee;
END;
/
DECLARE
    S SYS_REFCURSOR;
    SOME_FIRST_NAME EMPLOYEE.FIRSTNAME%TYPE;
    SOME_LAST_NAME EMPLOYEE.LASTNAME%TYPE;
BEGIN
    EMPLOYEE_FULL_NAME(S);
    LOOP
        FETCH S INTO SOME_FIRST_NAME, SOME_LAST_NAME;
        EXIT WHEN S%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(SOME_FIRST_NAME||' IS CURRENT FIRST NAME' || SOME_LAST_NAME || ' IS CURRENT LAST NAME');
    END LOOP;    
    CLOSE S;
END;
/

/*4.2 Stored Procedure Input Parameters*/
create or replace procedure UPDATE_EMPLOYEE (E_ID IN NUMBER, L_NAME IN VARCHAR2, F_NAME IN VARCHAR2, PHONE_IN IN VARCHAR2, EMAIL_IN IN VARCHAR2) AS
begin
IF TRUE THEN
        DBMS_OUTPUT.PUT_LINE('VALID PAIR');
    ELSE
        DBMS_OUTPUT.PUT_LINE('INVALID PAIR');
    END IF;
    UPDATE EMPLOYEE SET LASTNAME = L_NAME, FIRSTNAME = F_NAME, PHONE = PHONE_IN, EMAIL = EMAIL_IN
    WHERE EMPLOYEEID = E_ID;
    DBMS_OUTPUT.PUT_LINE('UPDATED EMPLOYEE' ||F_NAME|| ' '||L_NAME|| ' '||PHONE_IN || ' ' || EMAIL_IN);
    COMMIT;
    
    EXCEPTION
        WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('FAILED TO UPDATE EMPLOYEE');
        ROLLBACK;
END;
/        

BEGIN
    UPDATE_EMPLOYEE(9, 'SNUR', 'JOHN', '301-221-4567', 'jsnow@gmail.com');
END;
/

CREATE OR REPLACE PROCEDURE
MANAGE_EMPLOYEE(S OUT SYS_REFCURSOR) AS
BEGIN
    OPEN S FOR
    SELECT A.FIRSTNAME AS EMPLOYEE_NAME, A.LASTNAME AS EMPLOYEE_LASTNAME, B.FIRSTNAME AS MANAGER_NAME, B.LASTNAME AS MANAGER_LASTNAME 
    from EMPLOYEE  A, EMPLOYEE B
    WHERE A.EMPLOYEEID <> B.EMPLOYEEID
AND A.REPORTSTO = B.EMPLOYEEID;
END;
/

DECLARE
    S SYS_REFCURSOR;
    SOME_FIRSTNAME EMPLOYEE.FIRSTNAME%TYPE;
    SOME_LASTNAME EMPLOYEE.LASTNAME%TYPE;
    EMPLOYEE_NAME EMPLOYEE.FIRSTNAME%TYPE;
    EMPLOYEE_LAST_NAME EMPLOYEE.LASTNAME%TYPE;
    
BEGIN
    MANAGE_EMPLOYEE(S);
    LOOP
        FETCH S INTO SOME_FIRSTNAME, SOME_LASTNAME, EMPLOYEE_NAME, EMPLOYEE_LAST_NAME;
        EXIT WHEN S%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(SOME_FIRSTNAME||' '||SOME_LASTNAME|| ' MANAGED BY ' || EMPLOYEE_NAME || ' ' || EMPLOYEE_LAST_NAME);
    END LOOP;
    CLOSE S;
END;
/


select firstname, lastname, company from customer where firstname = 'Daan' and lastname='Peeters';

/*4.3 Stored Procedure Output Parameters*/
create or replace procedure CUST_COMPANY (S OUT SYS_REFCURSOR, C_ID in NUMBER)
IS
BEGIN
    OPEN S FOR    
    SELECT FIRSTNAME, LASTNAME, COMPANY from CUSTOMER WHERE CUSTOMERID=C_ID;
END;
/
DECLARE
    S SYS_REFCURSOR;
    SOME_FIRST_NAME CUSTOMER.FIRSTNAME%TYPE;
    SOME_LAST_NAME CUSTOMER.LASTNAME%TYPE;
    SOME_C_NAME CUSTOMER.COMPANY%TYPE; 
BEGIN
    CUST_COMPANY(S, 10);
    LOOP
        FETCH S INTO SOME_FIRST_NAME, SOME_LAST_NAME, SOME_C_NAME;
        EXIT WHEN S%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(SOME_FIRST_NAME||' ' || SOME_LAST_NAME || ' works for ' || SOME_C_NAME);
    END LOOP;    
    CLOSE S;
END;
/
/*5.0 Transactions*/

CREATE OR REPLACE PROCEDURE TRANS_INVOICE(I_ID in NUMBER)  IS
BEGIN
    IF TRUE THEN
        DBMS_OUTPUT.PUT_LINE('VALID PARAM');
    ELSE
        DBMS_OUTPUT.PUT_LINE('INVALID PARAM');
    END IF;
    
    DELETE FROM INVOICELINE WHERE INVOICEID=I_ID;
    DELETE FROM INVOICE WHERE INVOICEID=I_ID;
    COMMIT;
    
    EXCEPTION
        WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('FAILED TO DELETE INVOICE');
        ROLLBACK;       
END;
/
BEGIN
    TRANS_INVOICE(2);
END;
/
SELECT * FROM INVOICE order by INVOICEID ASC;
SELECT * FROM CUSTOMER;



CREATE OR REPLACE PROCEDURE INS_CUST(C_ID IN NUMBER, F_NAME IN VARCHAR2, L_NAME IN VARCHAR2, E_MAIL IN VARCHAR2) IS
BEGIN
    IF TRUE THEN
        DBMS_OUTPUT.PUT_LINE('VALID PARAM');
    ELSE
        DBMS_OUTPUT.PUT_LINE('INVALID PARAM');
    END IF;
    INSERT INTO CUSTOMER
    VALUES (C_ID, F_NAME, L_NAME, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, E_MAIL, NULL);
    COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN DBMS_OUTPUT.PUT_LINE('FAILED TO DELETE INVOICE');
        ROLLBACK;        
END;
/
BEGIN
    INS_CUST(60, 'HERCULE', 'SATAN', 'Hsatan@gmail.com');
END;
/
SELECT * FROM CUSTOMER ORDER BY CUSTOMERID ASC;

/*6.0 Triggers*/

/*6.1 AFTER/FOR*/
--Create before insert trigger
CREATE OR REPLACE TRIGGER TR_INSERT_EMPLOYEE
AFTER INSERT ON EMPLOYEE
BEGIN
    DBMS_OUTPUT.PUT_LINE('A NEW EMPLOYEE HAS BEEN ADDED');
END;
/

CREATE OR REPLACE TRIGGER TR_UPDATE_ALBUM
AFTER UPDATE ON ALBUM
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('A NEW ROW HAS BEEN INSERTED');
END;
/
CREATE OR REPLACE TRIGGER TR_DELETE_CUST
AFTER DELETE ON CUSTOMER
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('A ROW HAS BEEN DELETED');
END;
/


/*7.0*/
/*7.1 Inner*/
select firstname, lastname, invoiceid
from customer
inner join invoice  on customer.customerid = invoice.customerid;

/*7.2 Outer*/

select Customer.customerid, Customer.firstname, Customer.lastname, Invoice.invoiceid, Invoice.total
from customer
full outer join invoice on customer.customerid = invoice.customerid;

/*7.3 Right */
Select name, title
from artist
right join album on artist.artistid = album.artistid;

/*7.4 Cross */
Select *
from artist
cross join album
order by artist.name ASC;


/*7.5 Self*/
SELECT A.FirstName AS FirstName, A.LastName as LastName, B.FirstName as FirstName, B.lastname as LastName, A.REPORTSTO
FROM EMPLOYEE A, EMPLOYEE B
Where A.REPORTSTO <> B.REPORTSTO;


/*7.6 Complicated Join assignment*/

SELECT il.INVOICELINEID, il.INVOICEID, cust.customerid, emp.employeeid, tr.trackid, g.genreid, m.mediatypeid, a.albumid, ar.artistid, plt.playlistid, p.name FROM INVOICELINE IL 
inner join invoice inv on inv.invoiceid=il.invoiceid
inner join customer cust on cust.customerid = inv.customerid
inner join employee emp on emp.employeeid = cust.supportrepid
inner join track tr on tr.trackid = il.trackid
inner join genre g on g.genreid = tr.genreid
inner join mediatype m on m.mediatypeid = tr.mediatypeid
inner join album a on a.albumid = tr.albumid
inner join artist ar on ar.artistid = a.artistid
inner join playlisttrack plt on plt.trackid = tr.trackid
inner join playlist p on p.playlistid = plt.playlistid;


/*9.0 Administration*/


