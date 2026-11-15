USE MarketingCustomerAnalytics

--================
--report
--==============
SELECT 'Unique campaign count' AS Measure_Name,COUNT(DISTINCT(campaign_name)) AS Measure_value FROM dim_compaign
UNION ALL
SELECT 'Unique channels count used in camapaign' AS Measure_name,COUNT(DISTINCT(channel)) AS Measure_Value FROM dim_compaign
UNION ALL
SELECT 'Unique Customers Count' AS Measure_name,COUNT(DISTINCT(customer_id)) AS Measure_value FROM dim_customers
UNION ALL
SELECT 'Unique Product Count' AS Measure_name,COUNT(DISTINCT(product_name)) AS Measure_Value FROM dim_products
UNION ALL
SELECT 'Unique Category Count' AS Measure_name,COUNT(DISTINCT(category)) AS Measure_Value FROM dim_products
UNION ALL
SELECT 'Total Spending' AS Measure_name,ROUND(SUM(spend),2) AS Measure_Value FROM fact_compaign_spending
UNION ALL
SELECT 
'avg delivery days' AS Measure_name,AVG(DATEDIFF(DAY,order_date,delivery_date)) AS Measure_Value
FROM fact_order_process
UNION ALL
SELECT 'Total order count' AS Measure_name,COUNT(DISTINCT(order_id)) AS Measure_value FROM fact_sales 
UNION ALL
SELECT 'Total Sales Generated' AS Measure_name,ROUND(SUM(line_total),2) AS Measure_value FROM fact_sales 
UNION ALL
SELECT 'Active customers' AS Measure_name,COUNT(DISTINCT(customer_id)) AS Measure_value FROM fact_sales 
--===================
--Dimention exploration
--===================
--Total unique customers 
SELECT  
	COUNT(DISTINCT(customer_id)) AS Total_unique_customers
FROM dim_customers
--Total customers in Europe region
SELECT 
	COUNT(customer_id) AS total_customer
FROM dim_customers
WHERE region='Europe'

--find out 2nd highest budget compaign
SELECT * FROM(
SELECT
*,
ROW_NUMBER() OVER(ORDER BY budget DESC) AS rn
FROM dim_compaign
)t
WHERE rn=2

--Select all locations except (new york,london,tokyo,sao paulo)
SELECT * FROM dim_location
WHERE city_name NOT IN ('New York','London','Tokyo','Sau Paulo')

--Count total delivered products
SELECT
	status,
	COUNT(status) AS deliverd_count
FROM dim_orders_flag
WHERE status='Delivered'
GROUP BY status

----Print only Electronic product categorys
SELECT *
FROM dim_products
WHERE category='electronics'

SELECT * FROM dim_products
--Print matching conditions primary_supplier should be Supplier A and category must in sports
SELECT
*
FROM dim_products
WHERE primary_supplier='Supplier A' OR category='sports'

---Total Sprnding channel Email
SELECT
channel,
SUM(spend) AS total_spending FROM fact_compaign_spending S
LEFT JOIN dim_compaign C
ON S.compaign_key=C.compaign_key
WHERE C.channel='Email'
GROUP BY channel

--=========================
--DATE EXPLORATION 
---=========================
--find out the when all compaigns are start and when end 
SELECT 
MIN(start_date) AS compaign_first_date,
MAX(end_date) AS compaign_last_date
FROM dim_compaign

--first order date and last order date
SELECT * FROM fact_order_process
SELECT 
MIN(order_date) AS first_order_date,
MAX(order_date) AS letest_order_date
FROM fact_order_process

--calculate the avg days between order date and delivery date 
SELECT 
AVG(DATEDIFF(DAY,order_date,delivery_date)) AS days_difference
FROM fact_order_process

--how many year pass compare first date to todays date
SELECT
	DATEDIFF(DAY,MIN(order_date),GETDATE()) AS days_difference
FROM fact_order_process

--=====================
--MEASURE EXPLORATION(big number)
--===========================
--count total number of orders 
SELECT 
	COUNT(DISTINCT(order_id)) AS total_distinct_orders,
	COUNT(order_id) AS Total_orders
FROM fact_sales

--find total distinct products and total products
SELECT * FROM dim_products

SELECT 
	COUNT(product_key) AS Total_products,
	COUNT(DISTINCT(product_key)) AS Total_distinct_product
FROM dim_products

-- find customers count who are not place any order
SELECT
	COUNT(C.customer_id) AS customer_count
FROM dim_customers C
LEFT JOIN fact_order_process P
ON P.customer_id=C.customer_id
WHERE P.customer_id IS NULL


--find customers count who are active
SELECT 
	COUNT(DISTINCT(customer_id)) AS active_customer_count 
FROM fact_order_process

--total budget allocatation
SELECT 
	SUM(budget) AS Total_budget
FROM dim_compaign

---total sales
SELECT
SUM(quantity*unit_price) AS Total_sales_generated
FROM fact_sales


---avg sales
SELECT
AVG(quantity*unit_price) AS Total_sales_generated
FROM fact_sales

--Total disticnt product count
SELECT * FROM dim_products
SELECT
COUNT(DISTINCT(product_code)) AS total_product_count
FROM dim_products

---total spending 
SELECT
SUM(spend) AS total_spend
FROM fact_compaign_spending

SELECT
AVG(spend) AS total_spend
FROM fact_compaign_spending

--==========================
---Magnitude analysis
--=======================
--total spending by compaign channel
SELECT 
SUM(spend) AS total_speding
FROM fact_compaign_spending S
LEFT JOIN dim_compaign C
ON S.compaign_key=C.compaign_key
WHERE channel='Email'

--total sales by product category
SELECT
category,
SUM(quantity*unit_price) AS total_sale
FROM fact_sales S
LEFT JOIN dim_products P
ON S.product_key=P.product_key
WHERE category IS NOT NULL
GROUP BY category

--find sales by customer reigion wise
SELECT
C.region,
SUM(S.quantity*S.unit_price) AS total_sales
FROM fact_sales S
LEFT JOIN dim_customers C
ON S.customer_id=C.customer_id
GROUP BY region
ORDER BY total_sales DESC

---COUNT customers from Europe region
SELECT 
	COUNT(customer_id) AS customer_count
FROM dim_customers
WHERE region='Europe'

--==========================
--Ranking analysis
--==============================
--rank region by total sales
WITH rank_region AS(
SELECT 
region,
SUM(line_total) AS Total_sales,
ROW_NUMBER() OVER(ORDER BY SUM(line_total) DESC) AS rn
FROM fact_sales S
LEFT JOIN dim_customers C
ON S.customer_id=C.customer_id
GROUP BY region
)
SELECT 
region,
Total_sales,
rn
FROM rank_region

---RANK THE product category BEASED ON sales
SELECT 
P.category,
SUM(line_total) AS Total_sales,
ROW_NUMBER() OVER(ORDER BY SUM(line_total) DESC) AS RN
FROM fact_sales S
LEFT JOIN dim_products P
ON S.product_key=P.product_key
WHERE P.category IS NOT NULL
GROUP BY P.category


--RANK comapaign based on spending
SELECT 
C.campaign_name,
SUM(S.spend) as total_spending,
ROW_NUMBER() OVER(ORDER BY SUM(S.spend) DESC) AS rn
FROM fact_compaign_spending S
LEFT JOIN dim_compaign C
ON S.compaign_key=C.compaign_key
GROUP BY C.campaign_name 




