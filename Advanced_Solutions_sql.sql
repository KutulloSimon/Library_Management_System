-- Project Tasks
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status,author,publisher)
VALUES 
(
  '978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'
);
SELECT * FROM books;


-- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '121 Main St'
WHERE member_id = 'C101';
SELECT * FROM members;

-- Task 3: Delete a Record from the Issued Status Table -- Objective:
--Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
where issued_id = 'IS121';


-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective:
--Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM employees 
     WHERE emp_id = 'E111' OR emp_id = 'E121';

--Task 5: List Members Who Have Issued More Than One Book -- Objective:
--Use GROUP BY to find members who have issued more than one book.

SELECT
    issued_emp_id,
    --COUNT(issued_id) AS total_book_issued
FROM issued_status
GROUP BY 1
HAVING COUNT(issued_id) > 1;

--Task 6: Create Summary Tables:
--Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_cnts
AS 
SELECT 
    b.isbn,
	b.book_title,
    COUNT(ist.issued_id) AS no_issued
FROM books AS b
     JOIN
        issued_status AS ist
      ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2
 
-- Task 7. Retrieve All Books in a Specific Category:
SELECT * FROM books
       WHERE books.category = 'Classic'


-- Task 8: Find Total Rental Income by Category:
SELECT
     b.category,
	 SUM (b.rental_price),
	 COUNT(*)
FROM books AS b
JOIN issued_status AS ist
    ON ist.issued_book_isbn = b.isbn
GROUP BY 1

--Task 9: List Members Who Registered in the Last 180 Days:
SELECT * FROM members
   	WHERE members.reg_date >= CURRENT_DATE - INTERVAL '180 days';

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
SELECT e1.*,
       b.manager_id,
       e2.emp_name AS manager
FROM employees AS e1
JOIN branch AS b
    ON b.branch_id = e1.branch_id
JOIN employees AS e2
    ON b.manager_id = e2.emp_id;
    
-- ask 11. Create a Table of Books with Rental Price Above a Certain Threshold 10USD:
Create TABLE books_price_grt_than_svn
AS
SELECT * FROM books
    WHERE books.rental_price > 7;
	SELECT * FROM books_price_grt_than_svn;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

--ADVANCED SQL TASKS:
/*
Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books
(assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
*/

-- issued_status == members == books == return_status
-- filter books returned
-- overdue >30

SELECT 
  ist.issued_member_id,
  m.member_id,
  bk.book_title,
  ist.issued_date,
 -- rst.return_date,
  CURRENT_DATE - ist.issued_date AS overdue_count
FROM issued_status AS ist
JOIN 
members AS m
        ON m.member_id = ist.issued_member_id
JOIN 
books AS bk
      ON bK.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status AS rst
     ON rst.issued_id = ist.issued_id

	 WHERE rst.return_date IS NULL
     AND (CURRENT_DATE - ist.issued_date) > 30 
ORDER BY 1


/*Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned
(based on entries in the return_status table).
*/





