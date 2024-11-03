-----  √œ«¡ «·„»Ì⁄«  Õ”» «·›∆…
--- √Ã„«·Ì ⁄œœ ÿ·»Ì«  «·›∆« 
select p.category , count(o.orderID) as Total_Orders
from Products p join Sales s 
on p.Product_ID = s.Product_ID
join Orders o on o.OrderID=s.OrderID
group by p.category


---„« ÂÌ ›∆«  «·„‰ Ã«  «· Ì  Õﬁﬁ √⁄·Ï ÿ·»Ì« ° ÊﬂÌ› Ì „  Ê“Ì⁄ «·ÿ·»«  »Ì‰ „Œ ·› «·›∆«  «·›—⁄Ì…ø
select p.category ,p.sub_category, count(o.orderID) as Total_Orders,SUM(s.amount) as Total_Amount
from Products p join Sales s 
on p.Product_ID = s.Product_ID
join Orders o on o.OrderID=s.OrderID
group by p.category,p.sub_category
order by Total_Orders desc


----- «⁄·Ì «·„‰«ÿﬁ ÿ·»« 

select c.region, State,count(o.orderID) as Total_Orders, sum(s.amount)as Invoice_Amount
from Customers c join Sales s 
on c.Customer_ID = s.Customer_ID
join Orders o on o.OrderID=s.OrderID
group by c.region,State
order by Invoice_amount desc




-------- «·«’‰«› «·«ﬂÀ— «— »«ÿ« 

WITH RankedProducts AS (
    SELECT 
        p1.product_name AS product1, 
        p2.product_name AS product2, 
        COUNT(*) AS order_count,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) as rank
    FROM 
        sales a
    JOIN 
        sales b ON a.orderID = b.orderID AND a.product_ID < b.product_ID
    JOIN 
        products p1 ON a.product_ID = p1.Product_ID
    JOIN 
        products p2 ON b.product_ID = p2.Product_ID
    GROUP BY 
        p1.product_name, p2.product_name,a.OrderID
)
SELECT 
    product1,
    product2, 
    order_count
FROM 
    RankedProducts
WHERE 
    rank <= 20;  --  ⁄œÌ· «·⁄œœ Õ”» «·Õ«Ã…






SELECT a.OrderID
FROM sales a
JOIN Products p1 ON a.Product_ID = p1.Product_ID
JOIN sales b ON a.OrderID = b.OrderID
JOIN Products p2 ON b.Product_ID = p2.Product_ID
WHERE p1.Product_Name = 'Adjustable Personal File Tote' 
  and p2.Product_Name = 'Avery 499'
GROUP BY a.OrderID
HAVING COUNT(DISTINCT p1.Product_Name) > 0 AND COUNT(DISTINCT p2.Product_Name) > 0;



 

	

----·„»Ì⁄«  «·„— »ÿ… »√⁄·Ï orderID ›Ì ﬂ· ›∆…
SELECT p.category, count(s.orderID) as highest_orderID, SUM(s.amount) as total_sales
FROM sales s join products p
on p.product_id=s.product_id
GROUP BY p.category;



-----«·«— »«ÿ »Ì‰ orderID Ê«·› —«  «·“„‰Ì…
select   year(o.order_date) as years, MONTH(o.order_date) as 'months',
count(s.orderid) as total_invoice,sum(s.amount) as total_sales, AVG(s.amount) as AVG_sales
from Orders o join Sales s
on s.orderid=o.orderid
group by year(o.order_date) , MONTH(o.order_date) 
order by total_sales desc




----Õ·Ì· „⁄œ· «·„»Ì⁄«  Õ”» „‰ÿﬁ… «·‘Õ‰ √Ê ›∆… «·‘Õ‰
SELECT o.ship_mode, count(o.orderID) AS Total_Invoice,sum(s.amount) as total_amount
FROM Orders o join sales s
on o.orderid=s.orderid
GROUP BY ship_mode
ORDER BY  Total_Invoice DESC;


--- Õ·Ì· «·“»«∆‰ «·–Ì‰ Ì”«Â„Ê‰ »√⁄·Ï ‰”»… „‰ «·„»Ì⁄« 

SELECT top 20 c.customer_name, count(s.orderid)as Total_Invoice,SUM(s.amount) AS total_sales
FROM Customers c join sales s 
on c.Customer_ID=s.customer_id
join Orders o on o.orderid=s.orderid
GROUP BY  customer_name
ORDER BY Total_Invoice DESC;




SELECT c.customer_name ,o.order_date, o.ship_date ,o.ship_mode 
FROM Orders o join sales s
on o.orderid=s.orderid 
join Customers c on c.Customer_ID=s.customer_id
where Customer_Name='Jonathan Doherty' and YEAR(o.order_date)=2017




----›Ì Â–« «·«” ⁄·«„° ”√ﬁÊ„ »Õ”«» ‰”»… «·“Ì«œ… ›Ì «·ÿ·»«  ·ﬂ· ”‰…
--° Êﬂ–·ﬂ Õ”«» ‰”»… «·“Ì«œ… ·ﬂ· ‘Â— „ﬁ«—‰… »‰›” «·‘Â— ›Ì «·”‰… «·”«»ﬁ….
WITH YearlyInvoices AS (
    SELECT 
        YEAR(order_date) AS year, 
        COUNT(orderID) AS yearly_invoice_count
    FROM 
        Orders
    GROUP BY 
        YEAR(order_date)
),

MonthlyInvoices AS (
    SELECT 
        YEAR(order_date) AS year, 
        MONTH(order_date) AS month, 
        COUNT(orderID) AS monthly_invoice_count
    FROM 
        Orders
    GROUP BY 
        YEAR(order_date), MONTH(order_date)
)

-- Õ”«» ‰”»… «· €ÌÌ— «·”‰ÊÌ
SELECT 
    a.year AS current_year,
    a.yearly_invoice_count AS current_yearly_count,
    b.yearly_invoice_count AS previous_yearly_count,
    CASE 
        WHEN b.yearly_invoice_count IS NOT NULL THEN 
            ((a.yearly_invoice_count - b.yearly_invoice_count) * 100.0 / b.yearly_invoice_count)
        ELSE 
            NULL 
    END AS yearly_percentage_change,

    -- Õ”«» ‰”»… «· €ÌÌ— «·‘Â—Ì
    c.month AS current_month,
    c.monthly_invoice_count AS current_monthly_count,
    d.monthly_invoice_count AS previous_monthly_count,
    CASE 
        WHEN d.monthly_invoice_count IS NOT NULL THEN 
            ((c.monthly_invoice_count - d.monthly_invoice_count) * 100.0 / d.monthly_invoice_count)
        ELSE 
            NULL 
    END AS monthly_percentage_change
FROM 
    YearlyInvoices a
LEFT JOIN 
    YearlyInvoices b ON a.year = b.year + 1  -- „ﬁ«—‰… «·»Ì«‰«  «·”‰ÊÌ…
LEFT JOIN 
    MonthlyInvoices c ON a.year = c.year      -- —»ÿ «·”‰… „⁄ «·»Ì«‰«  «·‘Â—Ì…
LEFT JOIN 
    MonthlyInvoices d ON c.year = d.year + 1 AND c.month = d.month  -- „ﬁ«—‰… «·»Ì«‰«  «·‘Â—Ì…
ORDER BY 
    a.year, c.month;







-------Õ”«» ‰”»… «·“Ì«œ… »‰«¡ ⁄·Ï «·›’Ê· (—»⁄ ”‰ÊÌ…)
WITH QuarterlyInvoices AS (
    SELECT 
        YEAR(order_date) AS year, 
        DATEPART(QUARTER, order_date) AS quarter, 
        COUNT(orderID) AS quarterly_invoice_count
    FROM 
        Orders
    GROUP BY 
        YEAR(order_date), DATEPART(QUARTER, order_date)
)

SELECT 
    a.year AS current_year,
    a.quarter AS current_quarter,
    a.quarterly_invoice_count AS current_quarterly_count,
    b.quarterly_invoice_count AS previous_quarterly_count,
    CASE 
        WHEN b.quarterly_invoice_count IS NOT NULL THEN 
            ((a.quarterly_invoice_count - b.quarterly_invoice_count) * 100.0 / b.quarterly_invoice_count)
        ELSE 
            NULL 
    END AS quarterly_percentage_change
FROM 
    QuarterlyInvoices a
LEFT JOIN 
    QuarterlyInvoices b ON a.year = b.year + 1 AND a.quarter = b.quarter  -- „ﬁ«—‰… «·›’Ê· „‰ ”‰… ·√Œ—Ï
ORDER BY 
    a.year, a.quarter;





