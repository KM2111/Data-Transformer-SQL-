-----------------------------
-------    DATABASE   -------
-----------------------------
SHOW DATABASES;
CREATE DATABASE DataTransformer;
USE DataTransformer;

--------------------------------
----  1. CUSTOMERS TABLE   -----
--------------------------------

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    RegistrationDate DATE
);

INSERT INTO Customers VALUES
(1, 'John', 'Doe', ' john.doe@email.com ', '2022-03-15'),
(2, 'Jane', 'Smith', ' jane.smith@email.com ', '2021-11-02');

-----------------------------
-----  2. ORDERS TABLE  -----
-----------------------------

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders VALUES
(101, 1, '2023-07-01', 150.50),
(102, 2, '2023-07-03', 200.75);

--------------------------------
----   3. EMPLOYEES TABLE   ----
--------------------------------
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);

INSERT INTO Employees VALUES
(1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000),
(2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000);

----------------------------
--------  JOINS   ----------
----------------------------


-- INNER JOIN
SELECT c.*, o.*
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

-- LEFT JOIN
SELECT c.*, o.*
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- RIGHT JOIN
SELECT c.*, o.*
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- FULL OUTER JOIN (MySQL workaround)
SELECT c.*, o.*
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT c.*, o.*
FROM Customers c
RIGHT JOIN Orders o ON c.CustomerID = o.CustomerID;

--------------------------------
-------   SUBQUERIES   ---------
--------------------------------


-- Customers with orders above average amount
SELECT *
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE TotalAmount > (SELECT AVG(TotalAmount) FROM Orders)
);

-- Employees with salary above average
SELECT *
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

-----------------------------
----   DATE FUNCTIONS   -----
-----------------------------

-- Extract year & month
SELECT OrderID, YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month
FROM Orders;

-- Difference in days
SELECT OrderID, DATEDIFF(CURDATE(), OrderDate) AS DaysDifference
FROM Orders;

-- Format date
SELECT OrderID, DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedDate
FROM Orders;

--------------------------------
-----   STRING FUNCTIONS  ------
--------------------------------


-- Full name
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers;

-- Replace string
SELECT REPLACE(FirstName, 'John', 'Jonathan') FROM Customers;

-- Uppercase & lowercase
SELECT UPPER(FirstName), LOWER(LastName) FROM Customers;

-- Trim email
SELECT TRIM(Email) FROM Customers;

------------------------------
----   WINDOW FUNCTIONS  -----
------------------------------


-- Running total
SELECT OrderID, TotalAmount,
SUM(TotalAmount) OVER (ORDER BY OrderDate) AS RunningTotal
FROM Orders;

-- Rank orders
SELECT OrderID, TotalAmount,
RANK() OVER (ORDER BY TotalAmount DESC) AS RankOrder
FROM Orders;

----------------------------------
------   CONDITIONAL LOGIC   -----
----------------------------------


-- Discount assignment
SELECT OrderID, TotalAmount,
CASE
    WHEN TotalAmount > 1000 THEN '10% Discount'
    WHEN TotalAmount > 500 THEN '5% Discount'
    ELSE 'No Discount'
END AS Discount
FROM Orders;

-- Salary categorization
SELECT EmployeeID, Salary,
CASE
    WHEN Salary >= 60000 THEN 'High'
    WHEN Salary >= 45000 THEN 'Medium'
    ELSE 'Low'
END AS SalaryCategory
FROM Employees;


----------------------------------
----------- RESULTS --------------
----------------------------------

+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
| CustomerID | FirstName | LastName | Email                  | RegistrationDate | OrderID | CustomerID | OrderDate  | TotalAmount |
+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
|          1 | John      | Doe      |  john.doe@email.com    | 2022-03-15       |     101 |          1 | 2023-07-01 |      150.50 |
|          2 | Jane      | Smith    |  jane.smith@email.com  | 2021-11-02       |     102 |          2 | 2023-07-03 |      200.75 |
+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
2 rows in set (0.010 sec)

Query OK, 0 rows affected (0.001 sec)

+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
| CustomerID | FirstName | LastName | Email                  | RegistrationDate | OrderID | CustomerID | OrderDate  | TotalAmount |
+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
|          1 | John      | Doe      |  john.doe@email.com    | 2022-03-15       |     101 |          1 | 2023-07-01 |      150.50 |
|          2 | Jane      | Smith    |  jane.smith@email.com  | 2021-11-02       |     102 |          2 | 2023-07-03 |      200.75 |
+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
2 rows in set (0.011 sec)

Query OK, 0 rows affected (0.002 sec)

+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
| CustomerID | FirstName | LastName | Email                  | RegistrationDate | OrderID | CustomerID | OrderDate  | TotalAmount |
+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
|          1 | John      | Doe      |  john.doe@email.com    | 2022-03-15       |     101 |          1 | 2023-07-01 |      150.50 |
|          2 | Jane      | Smith    |  jane.smith@email.com  | 2021-11-02       |     102 |          2 | 2023-07-03 |      200.75 |
+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
2 rows in set (0.003 sec)

Query OK, 0 rows affected (0.002 sec)

+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
| CustomerID | FirstName | LastName | Email                  | RegistrationDate | OrderID | CustomerID | OrderDate  | TotalAmount |
+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
|          1 | John      | Doe      |  john.doe@email.com    | 2022-03-15       |     101 |          1 | 2023-07-01 |      150.50 |
|          2 | Jane      | Smith    |  jane.smith@email.com  | 2021-11-02       |     102 |          2 | 2023-07-03 |      200.75 |
+------------+-----------+----------+------------------------+------------------+---------+------------+------------+-------------+
2 rows in set (0.017 sec)

+------------+-----------+----------+------------------------+------------------+
| CustomerID | FirstName | LastName | Email                  | RegistrationDate |
+------------+-----------+----------+------------------------+------------------+
|          2 | Jane      | Smith    |  jane.smith@email.com  | 2021-11-02       |
+------------+-----------+----------+------------------------+------------------+
1 row in set (0.006 sec)

Query OK, 0 rows affected (0.001 sec)

+------------+-----------+----------+------------+------------+----------+
| EmployeeID | FirstName | LastName | Department | HireDate   | Salary   |
+------------+-----------+----------+------------+------------+----------+
|          2 | Susan     | Lee      | HR         | 2021-03-20 | 55000.00 |
+------------+-----------+----------+------------+------------+----------+
1 row in set (0.004 sec)

+---------+------+-------+
| OrderID | Year | Month |
+---------+------+-------+
|     101 | 2023 |     7 |
|     102 | 2023 |     7 |
+---------+------+-------+
2 rows in set (0.004 sec)

Query OK, 0 rows affected (0.001 sec)

+---------+----------------+
| OrderID | DaysDifference |
+---------+----------------+
|     101 |            917 |
|     102 |            915 |
+---------+----------------+
2 rows in set (0.012 sec)

Query OK, 0 rows affected (0.001 sec)

+---------+---------------+
| OrderID | FormattedDate |
+---------+---------------+
|     101 | 01-Jul-2023   |
|     102 | 03-Jul-2023   |
+---------+---------------+
2 rows in set (0.005 sec)

+------------+
| FullName   |
+------------+
| John Doe   |
| Jane Smith |
+------------+
2 rows in set (0.004 sec)

Query OK, 0 rows affected (0.001 sec)

+----------------------------------------+
| REPLACE(FirstName, 'John', 'Jonathan') |
+----------------------------------------+
| Jonathan                               |
| Jane                                   |
+----------------------------------------+
2 rows in set (0.004 sec)

Query OK, 0 rows affected (0.000 sec)

+------------------+-----------------+
| UPPER(FirstName) | LOWER(LastName) |
+------------------+-----------------+
| JOHN             | doe             |
| JANE             | smith           |
+------------------+-----------------+
2 rows in set (0.005 sec)

Query OK, 0 rows affected (0.001 sec)

+----------------------+
| TRIM(Email)          |
+----------------------+
| john.doe@email.com   |
| jane.smith@email.com |
+----------------------+
2 rows in set (0.001 sec)

+---------+-------------+--------------+
| OrderID | TotalAmount | RunningTotal |
+---------+-------------+--------------+
|     101 |      150.50 |       150.50 |
|     102 |      200.75 |       351.25 |
+---------+-------------+--------------+
2 rows in set (0.008 sec)

Query OK, 0 rows affected (0.001 sec)

+---------+-------------+-----------+
| OrderID | TotalAmount | RankOrder |
+---------+-------------+-----------+
|     102 |      200.75 |         1 |
|     101 |      150.50 |         2 |
+---------+-------------+-----------+
2 rows in set (0.003 sec)

+---------+-------------+-------------+
| OrderID | TotalAmount | Discount    |
+---------+-------------+-------------+
|     101 |      150.50 | No Discount |
|     102 |      200.75 | No Discount |
+---------+-------------+-------------+
2 rows in set (0.002 sec)

Query OK, 0 rows affected (0.001 sec)

+------------+----------+----------------+
| EmployeeID | Salary   | SalaryCategory |
+------------+----------+----------------+
|          1 | 50000.00 | Medium         |
|          2 | 55000.00 | Medium         |
+------------+----------+