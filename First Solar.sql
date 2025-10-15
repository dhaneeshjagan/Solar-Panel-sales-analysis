show databases;
use marketing;
show table status;

SELECT 
    *
FROM
    solar;
show columns from solar;

ALTER TABLE solar
CHANGE COLUMN `Discount_%` Discount int;

select count(*) from solar; #total number of count 	


-- which Type of Panel have the most orders
SELECT 
    panel_type, COUNT(*) AS Count_of_Orders
FROM
    solar
GROUP BY Panel_Type
ORDER BY count_of_orders DESC;

-- analyze orders and the sum of quantity by the priority level
SELECT 
    order_priority,
    SUM(quantity) AS Quantity_sum,
    COUNT(order_id) AS Order_count
FROM
    solar
GROUP BY Order_Priority
ORDER BY order_count DESC;

-- year wise order
SELECT 
    EXTRACT(YEAR FROM order_date) AS years,
    COUNT(customer_id) AS total_orders
FROM
    solar
GROUP BY years
ORDER BY total_orders DESC;

-- Total sales by the panel type and segment
SELECT 
    panel_type,
    segment,
    SUM(quantity * unit_price_USD) AS total_sales
FROM
    solar
GROUP BY panel_type , segment
ORDER BY total_sales DESC;


-- profit by current year by month
SELECT 
    EXTRACT(YEAR FROM order_date) AS years,
    MONTH(order_date) AS quater,
    ROUND(SUM(profit_usd), 2) AS profit_info
FROM
    solar
GROUP BY years , quater
HAVING years = 2025
ORDER BY years ASC;

-- top 10 sales city 
SELECT 
    city, ROUND(SUM(total_sales_usd), 2) AS sales
FROM
    solar
GROUP BY city
ORDER BY sales DESC
LIMIT 10;

-- analysis of sales, profit and the quantity by the sales category--
SELECT 
    CASE
        WHEN total_sales_usd < 10000 THEN 'low sales(<$10K)'
        WHEN total_sales_usd BETWEEN 10001 AND 20000 THEN 'Medium sales ($10K to $20K)'
        ELSE 'High Sales (>$20K)'
    END AS sales_info,
    COUNT(*) AS sales_count,
    ROUND(AVG(profit_usd), 2) AS avg_profit,
    SUM(quantity) AS sum_of_qunatity
FROM
    solar
GROUP BY sales_info
ORDER BY avg_profit;

-- Analysis by the capacity by the Kw with the quantity sold with WRT panel type
SELECT 
    CASE
        WHEN Capacity_kW < 5 THEN 'Low Capacity (<5kw)'
        WHEN Capacity_kW BETWEEN 5 AND 8 THEN 'Mid capacity (5kW - 8kW)'
        ELSE 'high capacity (> 8kW)'
    END AS Capacity_by_KW,
    COUNT(*) AS KW_sold_count,
    SUM(quantity) AS no_of_quantity_sold,
    panel_type
FROM
    solar
GROUP BY Capacity_by_kW,Panel_Type
ORDER BY KW_sold_count desc;

-- Top 10 sales WRT geography with the average shipping cost-- 
SELECT 
    city,
    state,
    Country,
    ROUND(SUM(total_sales_usd), 2) AS total_sales,
    ROUND(AVG(shipping_cost_usd), 2) AS Avg_shipping_cost
FROM
    solar
GROUP BY city , State , Country
ORDER BY total_sales DESC
LIMIT 10;

-- analysis by product model WRT total sales
SELECT 
    product_model,
    Panel_Type,
    city,
    state,
    Country,
    Total_Sales_USD
FROM
    solar
GROUP BY product_model , Panel_Type , Total_Sales_USD , city , state , Country
ORDER BY Total_Sales_USD DESC
LIMIT 10;

-- compare the average sales and the profit WRT customer_segment
SELECT 
    Customer_Segment,
    ROUND(AVG(Total_Sales_USD), 2) AS avg_sales,
    ROUND(AVG(Profit_USD), 2) AS Avg_profit
FROM
    solar
GROUP BY Customer_Segment
ORDER BY avg_sales DESC;

-- the top 10 most profitable orders WRT county and the city
SELECT 
    country,
    City,
    ROUND(AVG(total_sales_usd), 2) AS sales,
    ROUND(SUM(profit_usd), 2) AS profit
FROM
    solar
GROUP BY Country , city
ORDER BY profit desc
LIMIT 10;

-- the top 10 least profitable orders WRT county and the city
SELECT 
    country,
    City,
    ROUND(AVG(total_sales_usd), 2) AS sales,
    ROUND(SUM(profit_usd), 2) AS profit
FROM
    solar
GROUP BY Country , city
ORDER BY profit ASC
LIMIT 10;

-- Top 10 order count WRT country and the profit of that country
SELECT 
    country,
    COUNT(order_id) AS order_count,
    ROUND(AVG(Profit_USD), 2) AS profit
FROM
    solar
GROUP BY country
ORDER BY order_count desc
limit 10;

-- Below 10 order count WRT country and the profit of that country
SELECT 
    country,
    COUNT(order_id) AS order_count,
    ROUND(AVG(Profit_USD), 2) AS profit
FROM
    solar
GROUP BY country
ORDER BY order_count ASC
LIMIT 10;

-- year wise average profit analysis
SELECT 
    EXTRACT(YEAR FROM order_date) AS years,
    AVG(profit_usd) AS avg_profit
FROM
    solar
GROUP BY years
ORDER BY avg_profit DESC;

-- average Kw ordered by the customer segment 
SELECT 
    Customer_Segment,
    ROUND(AVG(Capacity_kW), 2) AS avg_Kw_ordered
FROM
    solar
GROUP BY customer_segment
ORDER BY avg_Kw_ordered DESC;

-- customer acquisition trend over month wise
SELECT 
    MONTH(order_date) AS month, COUNT(order_id) AS counts
FROM
    solar
GROUP BY month
ORDER BY counts DESC;

-- region wise sales and profit analysis 
SELECT 
    region,
    COUNT(order_id) AS order_count,
    ROUND(AVG(capacity_kw), 2) AS avg_Kw_by_region,
    ROUND(AVG(profit_usd), 2) AS Avg_profit_earned
FROM
    solar
GROUP BY region
ORDER BY Avg_profit_earned DESC
LIMIT 5; 

-- days requried for the delivery
SELECT 
    city,
    country,
    region,
    customer_segment,
    DATEDIFF(ship_date, order_date) AS delivery_date_diff
FROM
    solar
ORDER BY delivery_date_diff DESC;


-- Max discount and the Max Profit (yes or No)
SELECT 
    panel_type, Discount, Profit_usd
FROM
    solar
WHERE
    Discount = (SELECT 
            MAX(Discount)
        FROM
            solar)
        AND Profit_usd = (SELECT 
            MAX(Profit_usd)
        FROM
            solar);

