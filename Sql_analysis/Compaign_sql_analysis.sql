USE MarketingCustomerAnalytics
---==============================
--Change over time
--=============================
--[Measure] by [Date dimention]

--Total spending compaign over time
SELECT
    DATENAME(YEAR, S.date) AS Year,
    DATENAME(MONTH, S.date) AS Month,
    C.campaign_name,
    ROUND(SUM(spend), 2) AS Total_Spending
FROM fact_compaign_spending S
LEFT JOIN dim_compaign C 
    ON S.compaign_key = C.compaign_key
GROUP BY 
    YEAR(S.date),
    MONTH(S.date),
    DATENAME(YEAR,S.date),
    DATENAME(MONTH,S.date),
    C.campaign_name
ORDER BY 
    YEAR(S.date),
    MONTH(S.date),
    C.campaign_name;


--Total sales by Customer region over time
SELECT
    DATENAME(YEAR, order_date) AS Year,
    DATENAME(MONTH, order_date) AS Month,
    C.region,
    ROUND(SUM(line_total), 2) AS total_sales
FROM fact_sales S
LEFT JOIN dim_customers C 
    ON S.customer_id = C.customer_id
GROUP BY 
    YEAR(order_date),
    MONTH(order_date),
    DATENAME(YEAR, order_date),
    DATENAME(MONTH, order_date),
    C.region
ORDER BY 
    YEAR(order_date),
    MONTH(order_date),
    C.region;
--Product category AVG over time
SELECT 
    DATENAME(YEAR, order_date) AS Year,
    DATENAME(MONTH, order_date) AS Month,
    P.category,
    ROUND(AVG(line_total),1) AS avg_sales
FROM fact_sales S
LEFT JOIN dim_products P
ON S.product_key=P.product_key
WHERE P.category IS NOT NULL 
GROUP BY YEAR(order_date),
         MONTH(order_date),
         DATENAME(YEAR, order_date),
         DATENAME(MONTH, order_date),
         P.category
ORDER BY YEAR(order_date),
         MONTH(order_date),
         P.category

--=====================================
--Cummulative analysis
--====================================
--[Cummulative measure] by [Date dimention]
--Running total sales by year
WITH Yearly_sales AS(
SELECT
    YEAR(order_date) AS Year,
    MONTH(order_date) AS MONTH,
    SUM(line_total) AS total_sales
FROM fact_sales
GROUP BY MONTH(order_date),YEAR(order_date)
)
SELECT
    Year
    MONTH,
    ROUND(total_sales,2) AS line_total,
    ROUND(SUM(total_sales) OVER(ORDER BY Year,MONTH),2) AS overall_sales
FROM Yearly_sales

--moving avg of compaign speding
WITH monthly_sales AS(
SELECT
    YEAR(S.date) AS Year,
    MONTH(S.date) AS Month,
    C.campaign_name,
    SUM(spend) AS total_spending
FROM fact_compaign_spending S
LEFT JOIN dim_compaign C
ON S.compaign_key=C.compaign_key
GROUP BY YEAR(S.date),MONTH(S.date),C.campaign_name
)
SELECT
    Year,
    Month,
    ROUND(total_spending,2) AS total_spending,
    ROUND(AVG(total_spending) OVER(ORDER BY Year,Month),2) AS Avg_spending
FROM monthly_sales
ORDER BY Year,Month
--====================================
--Performance Analysis
--=================================
--Current[Measure]-Target[Measure]
--Analyze the yearly performance of product by comparing their sales to both the avg sales performance of the product and the previous years sales
WITH product_sales AS(
SELECT
    YEAR(order_date) AS order_year,
    P.product_name AS product_name,
    SUM(line_total) AS current_sales
FROM fact_sales S
LEFT JOIN dim_products P
ON S.product_key=P.product_key
WHERE P.product_name IS NOT NULL
GROUP BY P.product_name,YEAR(order_date)
)
SELECT 
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
    current_sales-AVG(current_sales) OVER(PARTITION BY product_name) AS avg_difference,
    CASE WHEN current_sales-AVG(current_sales) OVER(PARTITION BY product_name)>0 THEN 'Above avg'
         WHEN current_sales-AVG(current_sales) OVER(PARTITION BY product_name)<0 THEN  'Below Avg'
         ELSE 'No change' END AS avg_difference_status,
    LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS previous_year_sales,
    current_sales-LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_previous_year_sales,
    CASE WHEN current_sales-LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year)>0 THEN 'increment in sales'
         WHEN current_sales-LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year)<0 THEN 'decrement in sales'
         ELSE 'Not change' END AS PY_change_status
FROM product_sales
ORDER BY product_name,order_year

--Analyze the yearly performance of customers by comparing their sales to both the avg sales performance of the customers and the previous years sales


WITH customer_summary AS(
SELECT 
    YEAR(order_date) AS order_year,
    C.Customer_name AS customer_name,
    SUM(S.line_total) AS current_sales
FROM fact_sales S
LEFT JOIN dim_customers C
ON S.customer_id=C.customer_id
GROUP BY C.customer_name,YEAR(order_date)
)
SELECT * FROM(
SELECT
    order_year,
    customer_name,
    current_sales,
    AVG(current_sales) OVER(PARTITION BY customer_name) AS avg_sales,
    current_sales-AVG(current_sales) OVER(PARTITION BY customer_name) AS avg_difference_status,
    CASE WHEN current_sales-AVG(current_sales) OVER(PARTITION BY customer_name)>0 THEN 'above avg'
         WHEN current_sales-AVG(current_sales) OVER(PARTITION BY customer_name)<0 THEN 'bellow avg'
         ELSE 'No change' END AS avg_sales_status,
    LAG(current_sales) OVER(PARTITION BY customer_name ORDER BY order_year) AS py_sales,
    current_sales-LAG(current_sales) OVER(PARTITION BY customer_name ORDER BY order_year) AS diff_py_sales,
    CASE WHEN current_sales-LAG(current_sales) OVER(PARTITION BY customer_name ORDER BY order_year)> 0 THEN 'Increment sales'
         WHEN current_sales-LAG(current_sales) OVER(PARTITION BY customer_name ORDER BY order_year) <0 THEN 'decrement sales'
         ELSE 'No change' END AS py_sales_status
FROM customer_summary
)t
WHERE py_sales IS NOT NULL AND diff_py_sales IS NOT NULL

--===================================
--part to whole analysis
--===================================
--[Measure]/Total[Measure]*100 By [Dimention]
WITH product_summary AS(
SELECT 
    P.category AS product_category,
    SUM(line_total) AS sales
FROM fact_sales S
LEFT JOIN dim_products P
ON S.product_key=P.product_key
WHERE category IS NOT NULL
GROUP BY P.category
)
SELECT
    product_category,
    sales,
    SUM(sales) OVER() AS total_sales,
    CONCAT(ROUND((sales/SUM(sales) OVER())*100,2),'%') AS contribution
FROM product_summary
ORDER BY contribution DESC


--
WITH compaign_summary AS(
SELECT
C.campaign_name AS campaign_name,
SUM(spend) AS total_spending
FROM fact_compaign_spending S
LEFT JOIN dim_compaign C
ON S.compaign_key=C.compaign_key
GROUP BY C.campaign_name
)
SELECT 
    campaign_name,
    total_spending,
    SUM(total_spending) OVER() AS overall_sales,
    CONCAT(ROUND(((total_spending/SUM(total_spending) OVER())*100),2),'%') AS contribution
FROM compaign_summary
ORDER BY total_spending,contribution DESC

--
WITH channel_summary AS(
SELECT
C.channel AS channel_name,
SUM(spend) AS total_spending
FROM fact_compaign_spending S
LEFT JOIN dim_compaign C
ON S.compaign_key=C.compaign_key
GROUP BY C.channel
)
SELECT 
    channel_name,
    total_spending,
    SUM(total_spending) OVER() AS overall_sales,
    CONCAT(ROUND(((total_spending/SUM(total_spending) OVER())*100),2),'%') AS contribution
FROM channel_summary
ORDER BY total_spending,contribution DESC

--==============================
--Data Segmentation
--==============================
--[Measure] by [Measure]

--Segment the campaign dudget with spending if spending exceded the budget then Say "Spend more then the budget allocation" else "Spending less than the budget allocation" 
WITH budget_summary AS(
SELECT
    campaign_name,
    budget,
    SUM(spend) AS total_spend
FROM fact_compaign_spending S
LEFT JOIN dim_compaign C
ON S.compaign_key=C.compaign_key
GROUP BY campaign_name,budget
)
SELECT
campaign_name,
budget,
total_spend,
CASE WHEN total_spend>budget THEN 'Spend more than budget allocation'
     WHEN total_spend<budget THEN 'Spend less than budget allocation'
     ELSE 'No Change' END AS budget_status
FROM budget_summary

--Segment customers if there sales greater then the threshold(20000) THEN we can say that high value customers if sales between the 20000-10000 mid value customer else low value customers
WITH customer_sales AS(
SELECT
C.customer_name AS customer_name,
SUM(line_total) AS total_sales
FROM fact_sales S
LEFT JOIN dim_customers C
ON S.customer_id=C.customer_id
GROUP BY C.customer_name
)
SELECT
customer_name,
total_sales,
CASE WHEN total_sales>=20000 THEN 'High Value Customers'
     WHEN total_sales<20000 AND total_sales>10000 THEN 'Mid Value Customers'
     ELSE 'Low value Customers' END AS customer_status
FROM customer_sales
ORDER BY total_sales DESC

--Segment the category quantity count according to there solds if quantity sold more then 150 then High volume otherwise Low volume 
SELECT
    P.category,
    SUM(S.quantity) AS total_units_sold,
    ROUND(SUM(S.line_total), 2) AS total_sales,
    CASE 
        WHEN SUM(S.quantity) > 150 THEN 'High Volume'
        ELSE 'Low Volume' 
    END AS volume_status
FROM fact_sales S
LEFT JOIN dim_products P
    ON S.product_key = P.product_key
WHERE P.category IS NOT NULL
GROUP BY P.category
ORDER BY total_sales DESC;
--==============================
--Reporting
--================================
--reporting

/*Group customers into three segments based on their spending behavior:
    - VIP: Customers with at least 6 months of history and spending more than $25,000.
    - Regular: Customers with at least 6 months of history but spending $25,000 or less.
    - New: Customers with a lifespan less than 6 months.
And find the total number of customers by each group
*/
WITH customer_summary AS(
SELECT
    C.customer_name AS customer,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS lifespan,
    SUM(line_total) AS Total_sales
FROM fact_sales S
LEFT JOIN dim_customers C
ON S.customer_id=c.customer_id
GROUP BY C.customer_name
)
SELECT
customer_segmentation,
COUNT(customer) AS total_customers
FROM(
SELECT
    customer,
    lifespan,
    Total_sales,
    CASE WHEN Total_sales>=25000 AND lifespan>=6 THEN 'VIP customer'
         WHEN Total_sales<25000 AND Total_sales>=10000 AND lifespan>=6 THEN 'Regular customer'
         ELSE 'New customers' END AS customer_segmentation
FROM customer_summary
)T
GROUP BY customer_segmentation

/* Group campaigns into three segments based on their performance and spend behavior:
   - High-Impact: Campaigns with a total spend greater than $10000 and an average click-through rate (CTR) above the overall average
   - Moderate: Campaigns with a total spend greater than $10000 and an average click-through rate (CTR) at or below the overall average
   - Low-Impact: Campaigns with a total spend of $5,000 or less
   And find the total number of campaigns by each group
*/
WITH compaign_summary AS(
SELECT
    campaign_name,
    ROUND(SUM(spend),2) AS total_spending,
    SUM(clicks) AS No_clicks,
    SUM(impressions) AS No_impressions,
    ROUND((CAST(SUM(clicks) AS FLOAT)/CAST(SUM(impressions) AS FLOAT)*100),2) AS CTR
FROM fact_compaign_spending S
LEFT JOIN dim_compaign C
ON S.compaign_key=C.compaign_key
GROUP BY campaign_name
),
overall_metrics AS(
SELECT
    AVG(CTR) AS avg_ctr
    FROM compaign_summary
),
compaign_segments AS(
SELECT
    c.campaign_name,
    c.total_spending,
    c.CTR,
    o.avg_ctr,
    CASE WHEN c.total_spending >10000 AND c.CTR>o.avg_ctr THEN 'High Impact'
         WHEN c.total_spending >10000 AND c.CTR<=o.avg_ctr THEN 'Moderate'
         ELSE 'Low imapct' END AS campaign_segment
FROM compaign_summary c
CROSS JOIN overall_metrics o
)
SELECT 
campaign_name,
total_spending,
CTR,
ROUND(avg_ctr,2) AS avg_ctr, 
campaign_segment
FROM compaign_segments
ORDER BY total_spending DESC





