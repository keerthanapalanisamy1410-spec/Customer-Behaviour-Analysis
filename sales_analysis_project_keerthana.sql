create database sales_details;
use sales_details;
CREATE TABLE Customers (
    Customer_ID VARCHAR(10),
    Customer_Name VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    City VARCHAR(50)
);
INSERT INTO Customers (Customer_ID, Customer_Name, Gender, Age, City)
VALUES
('C101', 'Arun', 'Male', 24, 'Chennai'),
('C102', 'Priya', 'Female', 29, 'Coimbatore'),
('C103', 'Rahul', 'Male', 35, 'Erode'),
('C104', 'Divya', 'Female', 31, 'Salem'),
('C105', 'Karthik', 'Male', 27, 'Madurai');
CREATE TABLE Product (
    Product_ID VARCHAR(10),
    Product_Name VARCHAR(50),
    Category VARCHAR(30),
    Price DECIMAL(10,2)
);
INSERT INTO Products (Product_ID, Product_Name, Category, Price)
VALUES
('P101', 'Laptop', 'Electronics', 55000),
('P102', 'Mobile', 'Electronics', 20000),
('P103', 'Headphones', 'Accessories', 2500),
('P104', 'Smart Watch', 'Electronics', 5000),
('P105', 'Backpack', 'Bags', 1500);
CREATE TABLE Orders (
    Order_ID VARCHAR(10),
    Customer_ID VARCHAR(10),
    Product_ID VARCHAR(10),
    Quantity INT,
    Sales_Amount DECIMAL(10,2),
    Order_Date DATE
);
INSERT INTO Orders (Order_ID, Customer_ID, Product_ID, Quantity, Sales_Amount, Order_Date)
VALUES
('O1001', 'C101', 'P101', 1, 55000, '2026-01-10'),
('O1002', 'C102', 'P102', 2, 40000, '2026-01-15'),
('O1003', 'C103', 'P103', 3, 7500, '2026-02-02'),
('O1004', 'C104', 'P104', 1, 5000, '2026-02-18'),
('O1005', 'C105', 'P105', 4, 6000, '2026-03-05');
-- 1. Total Sales Analysis
select sum(Sales_Amount) as Total_Amount from Orders;
-- 2. Monthly Sales Trend
select date_format(Order_Date, '%y-%m')as Month_Sale,
sum(Sales_Amount) as Total_Monthly_Sales,
count(Order_ID) as Total_Order from Orders
group by date_format(Order_Date, '%y-%m')
order by Month_Sale;
-- 3. Top Selling Products
SELECT 
    p.Product_ID,
    p.Product_Name,
    p.Category,
    SUM(o.Quantity) AS Total_Quantity_Sold, 
    SUM(o.Sales_Amount) AS Total_Revenue
FROM Orders o
JOIN Products p ON o.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name, p.Category
ORDER BY Total_Revenue DESC;
-- Lowest Selling Products
SELECT 
    p.Product_ID,
    p.Product_Name,
    p.Category,
    SUM(o.Quantity) AS Total_Quantity_Sold, 
    SUM(o.Sales_Amount) AS Total_Revenue
FROM Orders o
JOIN Products p ON o.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name, p.Category
ORDER BY Total_Revenue asc;
-- 5. Customer Purchase Analysis
SELECT 
    c.Customer_ID,
    c.Customer_Name,
    c.City,
    COUNT(o.Order_ID) AS Total_Orders_Placed,
    SUM(o.Sales_Amount) AS Total_Amount_Spent
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name, c.City
ORDER BY Total_Orders_Placed DESC;
-- 6. Region-wise Sales Analysis
SELECT 
    c.City AS Region, 
    COUNT(o.Order_ID) AS Total_Orders,
    SUM(o.Quantity) AS Total_Products_Sold,
    SUM(o.Sales_Amount) AS Total_Revenue
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.City
ORDER BY Total_Revenue DESC;
-- 7. Category-wise Sales Performance
SELECT p.Category,
       SUM(o.Sales_Amount) AS Total_Sales
FROM Orders o
JOIN Products p
ON o.Product_ID = p.Product_ID
GROUP BY p.Category;
-- 8. Average Order Value
SELECT AVG(Sales_Amount) AS Avg_Order_Value
FROM Orders;
-- 9. Daily Sales Report
SELECT Order_Date,
       SUM(Sales_Amount) AS Daily_Sales
FROM Orders
GROUP BY Order_Date;
-- 10. Customer Retention Analysis
SELECT Customer_ID,
       COUNT(Order_ID) AS Purchase_Count
FROM Orders
GROUP BY Customer_ID
HAVING COUNT(Order_ID) > 1;
 -- 11. Peak Sales Month
 SELECT MONTH(Order_Date) AS Month,
       SUM(Sales_Amount) AS Total_Sales
FROM Orders
GROUP BY MONTH(Order_Date)
ORDER BY Total_Sales DESC
LIMIT 1;
-- 12. Product Quantity Analysis
SELECT Product_ID,
       SUM(Quantity) AS Total_Quantity
FROM Orders
GROUP BY Product_ID
ORDER BY Total_Quantity DESC;
-- 13. Sales by Gender
SELECT c.Gender,
       SUM(o.Sales_Amount) AS Total_Sales
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
GROUP BY c.Gender;
-- 14. New vs Existing Customers
SELECT Customer_ID,
       COUNT(Order_ID) AS Total_Orders
FROM Orders
GROUP BY Customer_ID;
-- 15. High Revenue Customers
SELECT Customer_ID,
       SUM(Sales_Amount) AS Total_Revenue
FROM Orders
GROUP BY Customer_ID
ORDER BY Total_Revenue DESC;
-- 16. Product Stock Demand Analysis
SELECT Product_ID,
       SUM(Quantity) AS Demand
FROM Orders
GROUP BY Product_ID
ORDER BY Demand DESC;
-- 17. Weekend vs Weekday Sales
SELECT DAYNAME(Order_Date) AS Day_Name,
       SUM(Sales_Amount) AS Total_Sales
FROM Orders
GROUP BY DAYNAME(Order_Date);
-- 18. Sales Performance by Year
SELECT YEAR(Order_Date) AS Year,
       SUM(Sales_Amount) AS Total_Sales
FROM Orders
GROUP BY YEAR(Order_Date);
-- 19. Customer Age Group Analysis
SELECT
CASE
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    ELSE '36+'
END AS Age_Group,
COUNT(Customer_ID) AS Total_Customers
FROM Customers
GROUP BY Age_Group;
-- 20. Complete Business Performance Dashboard
SELECT 
    c.Customer_Name,
    c.City,
    p.Product_Name,
    p.Category,
    o.Quantity,
    o.Sales_Amount,
    o.Order_Date
FROM Orders o
JOIN Customers c
ON o.Customer_ID = c.Customer_ID
JOIN Products p
ON o.Product_ID = p.Product_ID;