create database practice;
use practice;


select * from global_sales_data;
describe global_sales_data;

-- inspect null rows

select * from global_sales_data
where transaction_id is null
or `date` is null
or product is null
or category is null
or `total_sales ($)` is null
or `unit_price ($)` is null;


select count(*) as null_count
from global_sales_data
where `unit_price ($)` is null;


-- removing useless rows

delete from final_practice 
where quantity is null
or transaction_id is null
or `date` is null
or product is null
or category is null
or `total_sales ($)` is null
or `unit_price ($)` is null;

-- cleanning text column

update global_sales_data
set 
transaction_id=trim(Transaction_ID),
product=trim(Product),
category=trim(Category),
sales_rep=trim(Sales_Rep),
country=trim(Country),
`channel` =trim(`Channel`),
quantity =trim(Quantity),
`unit_price ($)`=trim(`Unit_Price ($)`),
`total_sales ($)` =trim(`Total_Sales ($)`),
region =trim(Region),
`date` =trim(`Date`),
`cost ($)`=trim(`Cost ($)`),
`Profit ($)` =trim(`Profit ($)`),
payment_mode=trim(Payment_Mode),
promo_code=trim(Promo_Code),
returned=trim(Returned),
customer_id=trim(Customer_ID),
customer_age=trim(Customer_Age),
customer_segment=trim(Customer_Segment);
 

ALTER TABLE global_sales_data
CHANGE `Unit_Price ($)` `Unit Price` decimal (10,2);

ALTER TABLE global_sales_data
CHANGE `Total_Sales ($)` `Total Sales` decimal (10,2);

ALTER TABLE global_sales_data
CHANGE `Cost ($)` Cost decimal (10,2);

ALTER TABLE global_sales_data
CHANGE `Profit ($)` Profit decimal (10,2);

SELECT * FROM global_sales_data;

select sum(`Total Sales`) from global_sales_data;

select sum(`Unit Price`) from global_sales_data;

select sum(Cost) from global_sales_data;

select sum(Profit) as `Total Profit`from global_sales_data;

select sum((`Unit Price` - Cost) * Quantity) as  `Total Pro` from global_sales_data;

-- Checking Product which Cost is more than their Unit Price

SELECT
    Transaction_ID,
    `Unit Price`,
    Cost,
    Quantity,
    Product,
    (`Unit Price` - Cost) AS Unit_Profit,
    (`Unit Price` - Cost) * Quantity AS Profit
FROM global_sales_data
WHERE Cost > `Unit Price`;





-- BUSINESS INSIGHT

-- 1. Overall Business Performance Metrics

SELECT 
    COUNT(Transaction_ID) AS `Total Transactions`,
    SUM(`Total Sales`) AS `Total Revenue`,
    SUM(Cost) AS `Total Cost`,
    SUM(Profit) AS `Total Profit`,
    ROUND((SUM(Profit) / SUM(`Total Sales`)) * 100, 2) AS `Profit Margin %`
FROM global_sales_data;

-- 2.  Pricing and Cost Effiency

select avg(`Unit Price`) as `Avg Unit Price`,
avg(COST) AS `Avg Cost`
FROM global_sales_data;


-- 3. Product Performance Analysis (Identifies Top Selling Products)

SELECT 
    Product,
    SUM(`Total Sales`) AS `Total Sales`,
    SUM(Profit) AS `Total Profit`
FROM global_sales_data
GROUP BY Product
ORDER BY `Total sales` desc
limit 10;

-- 4. Region Performance (Identifies Top Performing Region by REVENUE)
SELECT 
    Region,
    SUM(`Total Sales`) AS `Total Sales`,
    SUM(Profit) AS `Total Profit`
FROM global_sales_data
GROUP BY Region
ORDER BY `Total Profit` DESC;

-- 5.  Country Performance (Identifies Top Performing Countries by REVENUE)
SELECT 
    Country,
    SUM(`Total Sales`) AS `Total Sales`,
    SUM(Profit) AS `Total Profit`
FROM global_sales_data
GROUP BY Country
ORDER BY `Total Profit` DESC;


-- 6.  Customer Segment Performance (Showing which Customer Segment is most Valuable)
SELECT 
    Customer_Segment,
    SUM(`Total Sales`) AS `Total Sales`,
    SUM(Profit) AS `Total Profit`
FROM global_sales_data
GROUP BY Customer_Segment
ORDER BY `Total Sales` DESC;

-- 7.  Performance by Sales Channel (Identifies Top Sales Channel)

SELECT 
    Channel,
    SUM(`Total Sales`) AS `Total Sales`,
    SUM(Profit) AS `Total Profit`
FROM global_sales_data
GROUP BY Channel;

-- 8.  Payment Mode Preference (Identifies Customer Payment Behavior)

SELECT 
    Payment_Mode,
    COUNT(*) AS Transactions,
    SUM(`Total Sales`) AS `Total Sales`
FROM global_sales_data
GROUP BY Payment_Mode;

-- 9.  Promotion Impact (Identifies if promotion increases profit)

SELECT 
    Promo_Code,
    COUNT(*) AS Transactions,
    SUM(`Total Sales`) AS `Total Sales`,
    SUM(Profit) AS `Total Profit`
FROM global_sales_data
WHERE Promo_Code IS NOT NULL
GROUP BY Promo_Code
ORDER BY `Total Profit` DESC;

-- 10.  Average Customer Age by Segment

SELECT 
    Customer_Segment,
    AVG(Customer_Age) AS `Average Age`
FROM global_sales_data
GROUP BY Customer_Segment;

-- 11. Rank products by profitability using window function

SELECT 
    Product,
    SUM(Profit) AS `Total Profit`,
    RANK() OVER (ORDER BY SUM(Profit) DESC) AS `Profit Rank`
FROM global_sales_data
GROUP BY Product;


-- 11.  Profitability classification
SELECT 
    Product,
    SUM(Profit) AS `Total Profit`,
    CASE 
        WHEN SUM(Profit) >= 100000 THEN 'High Profit'
        WHEN SUM(Profit) BETWEEN 50000 AND 99999 THEN 'Medium Profit'
        ELSE 'Low Profit'
    END AS `Profit Category`
FROM global_sales_data
GROUP BY Product;

