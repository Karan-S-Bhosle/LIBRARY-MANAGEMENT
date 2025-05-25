# LIBRARY-MANAGEMENT
📚 Library Management System (SQL-Based)
A robust, fully functional Library Management System built using MySQL, designed to manage books, members, and rental transactions efficiently. This project showcases a real-world backend solution using stored procedures, triggers, and relational integrity constraints to handle core library operations such as book lending, returns, and overdue tracking.

🚀 Key Features
📘 Books Management – Add, update, and monitor book inventory.

👤 Members Management – Add members with validation to prevent duplicate entries.

🔁 Rental Transactions – Issue and return books with validation checks.

⏱️ Overdue & Penalty Calculation – Automatically track late returns and compute fines.

🔄 Automated Triggers – Adjust book availability on rental and return.

📊 Analytical Reports – View rental history, available books, and member activity.

⚙️ System Architecture
Tables:
Books – Master record for all available books.

Members – Master record for registered library members.

Rental – Transactional record of all book rentals and returns.

Procedures:
AddMembers – Inserts new member with duplicate email check.

RentBook – Issues books with validations for stock and member validity.

ReturnBook – Returns books with validation on rental existence and return date.

Triggers:
Book_Decrement_counter – Decreases available copies after successful rental.

Book_Increment_counter – Increases available copies upon successful return.

📊 Sample Analytical Queries (Q&A Format)
❓ Q1: Which books are currently not borrowed by any member?
📌 Identify all books that have never been rented out.

sql
Copy
Edit
SELECT
    b.BookID,
    b.Title
FROM
    Books b
LEFT JOIN Rental r ON b.BookID = r.BookID
WHERE
    r.BookID IS NULL;

    
❓ Q2: What is the rental history for each member?
📌 Show all rentals made by each member, including book title and return status.

sql
Copy
Edit
SELECT 
    m.MemberID,
    m.Name,
    b.BookID,
    b.Title,
    r.RentalDate,
    r.ReturnDate
FROM 
    Members m
LEFT JOIN Rental r ON m.MemberID = r.MemberID
LEFT JOIN Books b ON b.BookID = r.BookID;

❓ Q3: Which books are overdue, and what are their penalties?
📌 Calculate how late each return was and apply a penalty of ₹5 per day beyond the 7-day limit.

sql
Copy
Edit
SELECT
    RentalID,
    RentalDate,
    ReturnDate,
    CASE
        WHEN DATEDIFF(COALESCE(ReturnDate, CURDATE()), DATE_ADD(RentalDate, INTERVAL 7 DAY)) < 0 THEN 0
        ELSE DATEDIFF(COALESCE(ReturnDate, CURDATE()), DATE_ADD(RentalDate, INTERVAL 7 DAY))
    END AS Delay,
    CASE
        WHEN DATEDIFF(COALESCE(ReturnDate, CURDATE()), DATE_ADD(RentalDate, INTERVAL 7 DAY)) > 0 THEN 
            DATEDIFF(COALESCE(ReturnDate, CURDATE()), DATE_ADD(RentalDate, INTERVAL 7 DAY)) * 5
        ELSE 0
    END AS Penalty
FROM Rental;

❓ Q4: Which members have never rented a book?
📌 List members with no rental activity.

sql
Copy
Edit
SELECT 
    m.MemberID,
    m.Name
FROM 
    Members m
LEFT JOIN Rental r ON m.MemberID = r.MemberID
WHERE 
    r.RentalID IS NULL;
