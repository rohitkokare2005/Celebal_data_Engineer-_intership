CREATE DATABASE celebal_week3;

USE celebal_week3;

-- Step 3: Verify the Data

SELECT *
FROM superstore_raw
LIMIT 10;

-- Step 4: Check the Structure

DESCRIBE superstore_raw;

SELECT COUNT(*) AS total_rows
FROM superstore_raw;

-- Step 5: Create the customers Table

CREATE TABLE customers AS
SELECT DISTINCT
    `Customer ID` AS Customer_ID,
    `Customer Name` AS Customer_Name,
    Segment
FROM superstore_raw;


-- Step 6: Create the orders Table

CREATE TABLE orders AS
SELECT DISTINCT
    `Order ID` AS Order_ID,
    `Order Date` AS Order_Date,
    `Ship Date` AS Ship_Date,
    `Ship Mode` AS Ship_Mode,
    `Customer ID` AS Customer_ID,
    `Product ID` AS Product_ID,
    Sales,
    Quantity,
    Discount,
    Profit
FROM superstore_raw;

-- Step 7: Create the products Table

CREATE TABLE products AS
SELECT DISTINCT
    `Product ID` AS Product_ID,
    Category,
    `Sub-Category` AS Sub_Category,
    `Product Name` AS Product_Name
FROM superstore_raw;

-- Customers with Above-Average Sales

SELECT *
FROM orders
WHERE Sales >
(
    SELECT AVG(Sales)
    FROM orders
);

-- Highest Order per Customer

SELECT *
FROM orders o
WHERE Sales =
(
    SELECT MAX(Sales)
    FROM orders
    WHERE Customer_ID = o.Customer_ID
);

-- Total Sales Per Customer

WITH CustomerSales AS
(
    SELECT Customer_ID,
           SUM(Sales) AS Total_Sales
    FROM orders
    GROUP BY Customer_ID
)

SELECT *
FROM CustomerSales
ORDER BY Total_Sales DESC;

-- ROW_NUMBER()

SELECT Customer_ID,
       Sales,
       ROW_NUMBER() OVER
       (
           ORDER BY Sales DESC
       ) AS Row_Num
FROM orders;

-- RANK()

SELECT Customer_ID,
       Sales,
       RANK() OVER
       (
           ORDER BY Sales DESC
       ) AS Sales_Rank
FROM orders;

-- JOIN + CTE + Window Function
WITH CustomerSales AS
(
    SELECT Customer_ID,
           SUM(Sales) AS Total_Sales
    FROM orders
    GROUP BY Customer_ID
)

SELECT
c.Customer_ID,
c.Customer_Name,
cs.Total_Sales,
RANK() OVER
(
    ORDER BY cs.Total_Sales DESC
) AS Customer_Rank

FROM customers c
JOIN CustomerSales cs
ON c.Customer_ID = cs.Customer_ID;

-- Top 10 Customers

SELECT
Customer_ID,
SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Customer_ID
ORDER BY Total_Sales DESC
LIMIT 10;

-- Lowest 10 Customers
SELECT
Customer_ID,
SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Customer_ID
ORDER BY Total_Sales ASC
LIMIT 10;

-- Customers with Only One Order

SELECT
Customer_ID,
COUNT(Order_ID) AS Total_Orders
FROM orders
GROUP BY Customer_ID
HAVING COUNT(Order_ID)=1;

-- Customers with Above-Average Total Sales

SELECT
Customer_ID,
SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Customer_ID
HAVING SUM(Sales) >
(
SELECT AVG(Customer_Total)
FROM
(
SELECT SUM(Sales) AS Customer_Total
FROM orders
GROUP BY Customer_ID
) AS AvgSales
);



--  Final Result (Customer Name + Total Sales + Rank)

WITH CustomerSales AS
(
SELECT
Customer_ID,
SUM(Sales) AS Total_Sales
FROM orders
GROUP BY Customer_ID
)

SELECT
c.Customer_ID,
c.Customer_Name,
cs.Total_Sales,
RANK() OVER
(
ORDER BY cs.Total_Sales DESC
) AS Rank_No
FROM customers c
JOIN CustomerSales cs
ON c.Customer_ID=cs.Customer_ID
ORDER BY Rank_No;