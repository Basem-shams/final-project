select *
from ['Superstore Sales Dataset$'] 



--  search about NULLS 
select count(*) as OrderDate_Total_nulls
from ['Superstore Sales Dataset$']
where [Order Date] is null 

select count(*) as OrderID_Total_nulls
from ['Superstore Sales Dataset$']
where [Order ID] is null 

select count(*)as ShipDate_Total_nulls
from ['Superstore Sales Dataset$']
where [Ship Date] is null 

select count(*)as Shipmode_Total_nulls
from ['Superstore Sales Dataset$']
where [Ship Mode] is null 

select count(*)as customerID_Total_nulls
from ['Superstore Sales Dataset$']
where [Customer ID] is null 

select count(*)as postalcode_Total_nulls
from ['Superstore Sales Dataset$']
where [Postal Code] is null 


---- «·‰ ÌÃÂ »⁄œ ›’· «·Êﬁ  ⁄‰ «· «—ÌŒ ›Ì python
select * 
from final

-- ## Check NULLS 
select count(*) as OrderDate_Total_nulls
from final
where [Order_Date] is null 

select count(*) as OrderID_Total_nulls
from final
where [OrderID] is null 

select count(*)as ShipDate_Total_nulls
from final
where [Ship_Date] is null 

select count(*)as Shipmode_Total_nulls
from final
where [Ship_Mode] is null 

select count(*)as customerID_Total_nulls
from final
where [Customer_ID] is null 

select count(*)as sales_Total_nulls
from final
where [Sales] is null 


-----   ⁄„· «Ã—«¡ «· ‘ÌÌﬂ ⁄·Ì «·ÕﬁÊ· «·›«—€Â ⁄·Ì ﬂ«›… «·«⁄„œ… ›Ì ﬂ· «·Ãœ«Ê· 
SELECT *
FROM Sales,Products,Customers,Orders          
WHERE amount IS NULL;


-----  «ﬂ»— ﬁÌ„Â 
select max(amount)
from Sales

----- «ﬁ· ﬁÌ„Â
select min(amount)
from Sales


-------  «·»ÕÀ ⁄‰ ÊÃÊœ «Ì «‰Õ—«›«  
SELECT *
FROM sales           
WHERE amount < 0.444 OR amount > 22638.48;




----  ⁄œÌ· »Ì«‰«  »⁄÷ «·«⁄„œÂ „À· ( order id - customer  id - product  id ) 
---- ·ﬂÌ   ‰«”» „⁄ «·Ã—«¡«  «· Ì ”  „ ⁄·ÌÂ«



-- ≈÷«›… ⁄„Êœ ÃœÌœ · Œ“Ì‰ «·—ﬁ„ «·„›’Ê·
ALTER TABLE supersales ADD order_number INT;

--  ÕœÌÀ «·⁄„Êœ «·ÃœÌœ »«·ﬁÌ„… «·„›’Ê·…
UPDATE supersales
SET order_number = 
                CAST(SUBSTRING([Order ID], 
                LEN([Order ID]) - CHARINDEX('-', REVERSE([Order ID])) + 2,
                LEN([Order ID])) AS INT);


----** ﬁ„  » €ÌÌ— «”„ Column «·Ì OrderID
EXEC sp_rename 'supersales.order_number', 'orderID', 'COLUMN'; 





--Customer ID
ALTER TABLE supersales    --- «‰‘«¡ ⁄„Êœ ÃœÌœ ·›’· «·ﬁÌ„ «·Õ—›ÌÂ 
ADD Letters VARCHAR(50);



--  ÕœÌÀ «·⁄„Êœ «·ÃœÌœ »«·ﬁÌ„… «·„›’Ê·…
UPDATE supersales
SET Letters = 
           LEFT([Customer ID], 
		   CHARINDEX('-', [Customer ID]) - 1),

   [Customer ID] = 
   RIGHT([Customer ID],
   LEN([Customer ID]) - CHARINDEX('-', [Customer ID]))
WHERE [Customer ID] IS NOT NULL;





--Product ID
ALTER TABLE Supersales    -- «‰‘«¡ CoLumn ·›’· «·ﬁÌ„ «·Õ—›ÌÂ ›ÌÂ 
ADD Letters_2 VARCHAR(50);


UPDATE Supersales
SET 
    Letters = 
	        LEFT([Product ID],
			PATINDEX('%[0-9]%',[Product ID]) - 1),

    [Product ID] = 
	        SUBSTRING([Product ID], 
			PATINDEX('%[0-9]%', [Product ID]),
			LEN([Product ID]))
WHERE [Product ID] IS NOT NULL;


select *  from supersales

----  Õ–› «·„”«›«  »Ì‰ «”„«¡ «·«⁄„œÂ
EXEC sp_rename 'supersales.[orderdate]', 'order_date','COLUMN';
EXEC sp_rename 'supersales.[ship date]', 'ship_date','COLUMN';
EXEC sp_rename 'supersales.[ship mode]', 'ship_mode','COLUMN';
EXEC sp_rename 'supersales.[customer ID]', 'customer_ID','COLUMN';
EXEC sp_rename 'supersales.[customer name]', 'customer_Name','COLUMN';
EXEC sp_rename 'supersales.[postal code]', 'postal_code','COLUMN';
EXEC sp_rename 'supersales.[product id]', 'product_id','COLUMN'
EXEC sp_rename 'supersales.[product name]', 'product_name','COLUMN'
EXEC sp_rename 'supersales.[sub-category]', 'sub_category','COLUMN'


---- «” œ⁄«¡ «·«⁄„œÂ »⁄œ «· ⁄œÌ· ( «” »⁄«œ ⁄„Êœ Postal code)
select orderID,order_date,ship_date,ship_mode,customer_id,customer_name,Segment,Country,City,State,
Region,Product_id,Category,sub_category,product_name,Sales
from supersales


---- «· √ﬂœ „‰ ⁄œ„ ÊÃÊœ »Ì«‰«  €Ì— ’«·ÕÂ ﬁ»·  €ÌÌ— ‰Ê⁄ «·»Ì«‰« 
SELECT OrderID, Customer_ID, Product_ID
FROM supersales
WHERE ISNUMERIC(OrderID) = 0
   OR ISNUMERIC(Customer_ID) = 0
   OR ISNUMERIC(Product_ID) = 0;


ALTER TABLE supersales
ALTER COLUMN OrderID INT;

ALTER TABLE supersales
ALTER COLUMN Customer_ID INT;

ALTER TABLE supersales
ALTER COLUMN Product_ID INT;


--- Õ–› ⁄„Êœ order id »⁄œ  ⁄œÌ·Â 
ALTER TABLE supersales
drop column [order id] ;



--- ____________________________________________________________________---

--- create Modeling

CREATE TABLE Orders (
    OrderID int PRIMARY KEY,  -- Order ID
    Order_Date DATETIME,                -- Order Date
    Ship_Date DATETIME,                 -- Ship Date
    Ship_Mode NVARCHAR(255)              -- Ship Mode
);

CREATE TABLE Customers (
    Customer_ID int PRIMARY KEY, -- Customer ID
    Customer_Name NVARCHAR(255),          -- Customer Name
    Segment NVARCHAR(50),                -- Segment
    Country NVARCHAR(50),                -- Country
    City NVARCHAR(50),                   -- City
    State NVARCHAR(50),                  -- State
    Region NVARCHAR(50)                  -- Region
);


CREATE TABLE Products (
    Product_ID int PRIMARY KEY,  -- Product ID
    Category NVARCHAR(50),               -- Category
    Sub_Category NVARCHAR(50),            -- Sub-Category
    Product_Name NVARCHAR(255)            -- Product Name
);


CREATE TABLE Sales (
    RowID int PRIMARY KEY ,      -- Row ID
    OrderID int   ,              -- Order ID
    Product_ID int ,              -- Product ID
    Customer_ID int,              -- Customer ID
    Sales FLOAT,                         -- Sales
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);


------- ####################### ------------

---- ‰ﬁ· «·»Ì«‰«  «·Ì «·Ãœ«Ê· 

----- Orders Table
INSERT INTO Orders (OrderID, Order_Date, Ship_Date, Ship_Mode)
SELECT DISTINCT [OrderID], [Order_Date], [Ship_Date], [Ship_Mode]
FROM supersales;



----- Customers Table
WITH RankedCustomers AS (
    SELECT 
        [Customer_ID], 
        [Customer_Name], 
        Segment, 
        Country, 
        City, 
        State, 
        Region,
        ROW_NUMBER() OVER (PARTITION BY [Customer_ID] ORDER BY [Customer_Name]) AS rn
    FROM supersales
)

INSERT INTO Customers (Customer_ID, Customer_Name, Segment, Country, City, State, Region)
SELECT 
    [Customer_ID], 
    [Customer_Name], 
    Segment, 
    Country, 
    City, 
    State, 
    Region
FROM RankedCustomers
WHERE rn = 1;  -- «Œ — «·’› «·√Ê· ›ﬁÿ ·ﬂ· ⁄„Ì·




---- Products Table
WITH RankedProducts AS (
    SELECT 
        [Product_ID], 
        [Product_Name], 
        Category, 
        [Sub_Category], 
        ROW_NUMBER() OVER (PARTITION BY [Product_ID] ORDER BY [Product_Name]) AS rn
    FROM supersales
)

INSERT INTO Products (Product_ID, Product_Name, Category, Sub_Category)
SELECT 
    [Product_ID], 
    [Product_Name], 
    Category, 
   [Sub_Category]
FROM RankedProducts
WHERE rn = 1;  -- «Œ Ì«— «·’› «·√Ê· ›ﬁÿ ·ﬂ· „‰ Ã






--- Sales Table
WITH RankedSales AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowID, --  Ê·Ìœ RowID  ·ﬁ«∆Ì
        OrderID, 
        product_id, 
        customer_id, 
        sales
    FROM 
        [Finalsheet]
)
INSERT INTO Sales (RowID, OrderID, product_id, customer_id, sales)
SELECT 
    RowID, 
    OrderID, 
    product_id, 
    customer_id, 
    sales
FROM 
    RankedSales;

--- ____________________________________________________________________---

	----- @@ Exploring Data After cleaning @@ ------ 

SELECT * FROM customers WHERE customer_id IS NULL;

SELECT * FROM products WHERE product_id IS NULL;

SELECT * FROM orders WHERE orderid IS NULL;

SELECT * FROM sales WHERE RowID IS NULL;


SELECT 
    COUNT(*) AS total_customers,
    COUNT(customer_id) AS non_null_customer_id,
    COUNT(customer_name) AS non_null_customer_name,
    COUNT(region) AS non_null_region,
    COUNT(Segment) AS non_null_Segment,
    COUNT(City) AS non_null_City,
    COUNT(Country) AS non_null_Country,
    COUNT(State) AS non_null_State

FROM customers;



SELECT 
    COUNT(*) AS total_products,
    COUNT(product_id) AS non_null_product_id,
    COUNT(product_name) AS non_null_product_name,
    COUNT(category) AS non_null_category,
    COUNT(Sub_Category) AS non_null_cub_category
FROM products;



SELECT 
    COUNT(*) AS total_orders,
    COUNT(orderid) AS non_null_order_id,
    COUNT(Ship_Mode) AS non_null_Ship_Mode,
    COUNT(order_date) AS non_null_order_date,
    COUNT(ship_date) AS non_null_ship_date
FROM orders;



SELECT 
    COUNT(*) AS total_sales,
    COUNT(RowID) AS non_null_RowID,
    COUNT(orderid) AS non_null_order_id,
    COUNT(product_id) AS non_null_product_id,
    COUNT(Customer_ID) AS non_null_Customer_ID,
    COUNT(amount) AS non_null_total_amount
FROM sales;