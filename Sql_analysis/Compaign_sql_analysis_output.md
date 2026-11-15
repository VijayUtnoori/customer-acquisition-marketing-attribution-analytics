--===================

--REPORTING

--===============
## Query 1: Customer Segmentation Analysis


/*Group customers into three segments based on their spending behavior:
    - VIP: Customers with at least 6 months of history and spending more than $25,000.
    - Regular: Customers with at least 6 months of history but spending $25,000 or less.
    - New: Customers with a lifespan less than 6 months.
And find the total number of customers by each group
*/


**Business Objective:** Group customers into segments (New, Regular, and VIP) based on lifespan history and total spending to analyze customer base distribution.

| customer_segmentation | total_customers |
| :--- | :--- |
| New customers | 32 |
| Regular customer | 12|
| VIP customer | 3|

> **Key Insight:** New customers make up the largest portion of the customer base with 32 accounts, while VIP customers represent the most exclusive tier with 3 accounts.

## Query 2: Campaign Performance Segmentation Analysis

/* Group campaigns into three segments based on their performance and spend behavior:
   - High-Impact: Campaigns with a total spend greater than $10000 and an average click-through rate (CTR) above the overall average
   - Moderate: Campaigns with a total spend greater than $10000 and an average click-through rate (CTR) at or below the overall average
   - Low-Impact: Campaigns with a total spend of $5,000 or less
   And find the total number of campaigns by each group
*/


**Business Objective:** Group marketing campaigns into performance tiers (High Impact, Moderate, and Low Impact) based on total spend and click-through rates (CTR).

| campaign_name | total_spending | CTR | avg_ctr | campaign_segment |
| :--- | :--- | :--- | :--- | :--- |
| Black Friday | 28065.30 | 4.16 | 3.36| High Impact|
| Summer Sale | 14607.66| 2.88 | 3.36| Moderate |
| Spring Launch 2026 | 12143.87 | 3.08 | 3.36| Moderate|
| Back to School | 9209.84 | 4.19| 3.36| Low imapct|
| Spring Launch | 7625.36 | 2.94 | 3.36| Low imapct|
| New Year Clearance | 7188.62 | 2.92| 3.36| Low imapct|

> **Key Insight:** Black Friday stands out as the sole High Impact campaign due to its high spend and superior CTR above the 3.36 average.


---==============================

--Change over time

--=============================
--[Measure] by [Date dimention]

## Query 3: Total Spending by Campaign (`campaign_name`)

**Business Objective:** Evaluate total marketing expenditure across different promotional campaigns by year and month.

| Year | Month | campaign_name | Total_Spending |
| :--- | :--- | :--- | :--- |
| 2025 | March | Spring Launch | 7625.36 |
| 2025 | June | Summer Sale | 7472.64 |
| 2025 | July | Summer Sale | 7135.02 |
| 2025 | August | Back to School | 4934.90 |
| 2025 | September | Back to School | 4274.94 |
| 2025 | November | Black Friday | 28065.30 |
| 2026 | January | New Year Clearance | 7188.62 |
| 2026 | March | Spring Launch 2026 | 12143.87 |

> **Key Insight:** Black Friday 2025 recorded the highest spending by a wide margin at 28,065.30, followed by the Spring Launch 2026 campaign.

---

## Query 4: Average Sales by Product Category (`category`)
*(Note: Displaying a sample of 10 rows out of 88 total records)*

**Business Objective:** Track monthly average sales performance broken down by product category.

| Year | Month | category | avg_sales |
| :--- | :--- | :--- | :--- |
| 2025 | February | apparel | 3338.7 |
| 2025 | February | beauty | 1297.3 |
| 2025 | February | electronics | 764.2 |
| 2025 | February | home | 6068.9 |
| 2025 | February | industrial | 2120.4 |
| 2025 | February | sports | 4844.7 |
| 2025 | March | apparel | 4637.6 |
| 2025 | March | home | 2759.1 |
| 2025 | March | industrial | 3867.6 |
| 2025 | March | sports | 3518.2 |

> **Key Insight:** The 'home' category led February 2025 with the highest average sales at 6,068.9, while electronics recorded the lowest.

---

## Query 5: Total Sales by Region (`region`)
*(Note: Displaying a sample of 10 rows out of 52 total records)*

**Business Objective:** Monitor regional sales revenue distribution across different months and years.

| Year | Month | region | total_sales |
| :--- | :--- | :--- | :--- |
| 2025 | February | Asia Pacific | 7709.68 |
| 2025 | February | Europe | 1717.86 |
| 2025 | February | Middle East | 18911.31 |
| 2025 | February | North America | 1696.40 |
| 2025 | March | Europe | 7412.85 |
| 2025 | March | Latin America | 7760.81 |
| 2025 | March | North America | 23666.40 |
| 2025 | April | Asia Pacific | 13570.42 |
| 2025 | April | Europe | 29865.72 |
| 2025 | April | Latin America | 3637.35 |

> **Key Insight:** Europe peaked in April 2025 with the highest regional total sales of 29,865.72 among the sampled periods.

--=====================================
--Cummulative analysis
--====================================
--[Cummulative measure] by [Date dimention]

## Query 6: Cumulative Overall Sales Progression (`overall_sales`)

**Business Objective:** Track periodic revenue alongside running cumulative total sales across 2025 and 2026.

| MONTH | line_total | overall_sales |
| :--- | :--- | :--- |
| 2025 | 30035.25 | 30035.25 |
| 2025 | 38840.06 | 68875.31 |
| 2025 | 47073.49 | 115948.80 |
| 2025 | 18705.31 | 134654.11 |
| 2025 | 12716.23 | 147370.34 |
| 2025 | 22915.12 | 170285.46 |
| 2025 | 7556.28 | 177841.74 |
| 2025 | 16036.80 | 193878.54 |
| 2025 | 29060.04 | 222938.58 |
| 2025 | 43332.68 | 266271.26 |
| 2026 | 17664.33 | 283935.59 |
| 2026 | 36087.94 | 320023.53 |
| 2026 | 6742.06 | 326765.59 |
| 2026 | 28074.88 | 354840.47 |
| 2026 | 32734.04 | 387574.51 |
| 2026 | 6132.94 | 393707.45 |
| 2026 | 44633.82 | 438341.27 |
| 2026 | 21200.92 | 459542.19 |
| 2026 | 28645.27 | 488187.46 |
| 2026 | 38456.45 | 526643.91 |

> **Key Insight:** Cumulative sales nearly doubled from 266,271.26 at the end of 2025 to 526,643.91 in 2026.

---

## Query 5: Monthly Total vs. Running Average Spending (`Avg_spending`)

**Business Objective:** Compare individual monthly marketing spend against the cumulative moving average over time.

| Year | Month | total_spending | Avg_spending |
| :--- | :--- | :--- | :--- |
| 2025 | 3 | 7625.36 | 7625.36 |
| 2025 | 6 | 7472.64 | 7549.00 |
| 2025 | 7 | 7135.02 | 7411.01 |
| 2025 | 8 | 4934.90 | 6791.98 |
| 2025 | 9 | 4274.94 | 6288.57 |
| 2025 | 11 | 28065.30 | 9918.03 |
| 2026 | 1 | 7188.62 | 9528.11 |
| 2026 | 3 | 12143.87 | 9855.08 |

> **Key Insight:** November 2025 spending spiked to 28,065.30, pushing the running average up by over 57% to 9,918.03.


## Query 6: Year-over-Year Product Sales Performance & Average Comparison
*(Note: Displaying a sample of 10 rows out of 102 total records)*

**Business Objective:** Evaluate individual product sales against their historical averages and prior-year benchmarks to classify performance trends.

| order_year | product_name | current_sales | avg_sales | avg_difference | avg_difference_status | previous_year_sales | diff_previous_year_sales | PY_change_status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 2025 | Audio M002 | 5838.12 | 10703.22 | -4865.10 | Below Avg | NULL | NULL | Not change |
| 2026 | Audio M002 | 15568.32 | 10703.22 | 4865.10 | Above avg | 5838.12 | 9730.20 | increment in sales |
| 2025 | Audio M020 | 18914.22 | 10912.05 | 8002.17 | Above avg | NULL | NULL | Not change |
| 2026 | Audio M020 | 2909.88 | 10912.05 | -8002.17 | Below Avg | 18914.22 | -16004.34 | decrement in sales |
| 2025 | Audio M038 | 8588.50 | 5582.53 | 3005.98 | Above avg | NULL | NULL | Not change |
| 2026 | Audio M038 | 2576.55 | 5582.53 | -3005.98 | Below Avg | 8588.50 | -6011.95 | decrement in sales |
| 2025 | Audio M056 | 196.96 | 443.16 | -246.20 | Below Avg | NULL | NULL | Not change |
| 2026 | Audio M056 | 689.36 | 443.16 | 246.20 | Above avg | 196.96 | 492.40 | increment in sales |
| 2025 | Decor M026 | 7181.04 | 8078.67 | -897.63 | Below Avg | NULL | NULL | Not change |
| 2026 | Decor M026 | 8976.30 | 8078.67 | 897.63 | Above avg | 7181.04 | 1795.26 | increment in sales |

> **Key Insight:** Audio M002 achieved the strongest YoY growth (+9,730.20), whereas Audio M020 experienced the steepest decline (-16,004.34) in 2026.

---

## Query 8: Product Category Sales Contribution

**Business Objective:** Calculate individual product category sales and their percentage contribution to overall company revenue.

| product_category | sales | total_sales | contribution |
| :--- | :--- | :--- | :--- |
| electronics | 130897.58 | 525956.41 | 24.89% |
| apparel | 99589.15 | 525956.41 | 18.93% |
| home | 77619.36 | 525956.41 | 14.76% |
| sports | 77169.38 | 525956.41 | 14.67% |
| beauty | 74767.83 | 525956.41 | 14.22% |
| industrial | 65913.11 | 525956.41 | 12.53% |

> **Key Insight:** Electronics led all categories with a 24.89% contribution to total sales, generating over 130K in revenue.

---

## Query 9: Marketing Campaign Spending Contribution

**Business Objective:** Measure spending distribution across different marketing campaigns relative to overall campaign spending.

| campaign_name | total_spending | overall_sales | contribution |
| :--- | :--- | :--- | :--- |
| New Year Clearance | 7188.62 | 78840.65 | 9.12% |
| Spring Launch | 7625.36 | 78840.65 | 9.67% |
| Back to School | 9209.84 | 78840.65 | 11.68% |
| Spring Launch 2026 | 12143.87 | 78840.65 | 15.40% |
| Summer Sale | 14607.66 | 78840.65 | 18.53% |
| Black Friday | 28065.30 | 78840.65 | 35.60% |

> **Key Insight:** Black Friday accounted for the largest share of total marketing expenditure at 35.60%.

---

## Query 10: Marketing Channel Spending Contribution

**Business Objective:** Evaluate budget allocation and spending contribution across different marketing channels.

| channel_name | total_spending | overall_sales | contribution |
| :--- | :--- | :--- | :--- |
| Display | 9209.84 | 78840.65 | 11.68% |
| Email | 14813.98 | 78840.65 | 18.79% |
| Social | 26751.53 | 78840.65 | 33.93% |
| Paid Search | 28065.30 | 78840.65 | 35.60% |

> **Key Insight:** Paid Search and Social media combined absorbed nearly 70% of total marketing channel spending.


--
## Query 11: Campaign Budget vs. Total Spend Performance

**Business Objective:** Compare campaign budgets against actual spending to evaluate allocation efficiency and budget variances.

| campaign_name | budget | total_spend | budget_status |
| :--- | :--- | :--- | :--- |
| New Year Clearance | 7000 | 7188.62 | Spend more than budget allocation |
| Spring Launch | 8000 | 7625.36 | Spend less than budget allocation |
| Back to School | 9000 | 9209.84 | Spend more than budget allocation |
| Spring Launch 2026 | 12000 | 12143.87 | Spend more than budget allocation |
| Summer Sale | 15000 | 14607.66 | Spend less than budget allocation |
| Black Friday | 30000 | 28065.30 | Spend less than budget allocation |

> **Key Insight:** New Year Clearance, Back to School, and Spring Launch 2026 all slightly exceeded their initial budget allocations.

---

## Query 12: Product Category Sales Volume and Status

**Business Objective:** Analyze total units sold and revenue by product category to classify sales volume performance.

| category | total_units_sold | total_sales | volume_status |
| :--- | :--- | :--- | :--- |
| electronics | 253 | 130897.58 | High Volume |
| apparel | 189 | 99589.15 | High Volume |
| home | 197 | 77619.36 | High Volume |
| sports | 147 | 77169.38 | Low Volume |
| beauty | 162 | 74767.83 | High Volume |
| industrial | 143 | 65913.11 | Low Volume |

> **Key Insight:** Electronics dominated both in total units sold (253) and revenue, securing the top High Volume ranking.

---

## Query 13: Top Customer Value Segmentation
*(Note: Displaying a sample of 10 rows out of total customer records)*

**Business Objective:** Categorize customers based on cumulative sales performance into high-value and mid-value segments.

| customer_name | total_sales | customer_status |
| :--- | :--- | :--- |
| Summit Commerce | 32512.38 | High Value Customers |
| Cascade Retail | 29202.20 | High Value Customers |
| Pioneer Holdings | 29174.52 | High Value Customers |
| Vanguard Holdings | 24850.88 | High Value Customers |
| Cascade Commerce | 22256.78 | High Value Customers |
| Evergreen Partners | 22066.19 | High Value Customers |
| Meridian Partners | 21997.55 | High Value Customers |
| Catalyst Industries | 18117.54 | Mid Value Customers |
| Keystone Partners | 17770.86 | Mid Value Customers |
| Quantum Distribution | 17033.03 | Mid Value Customers |

> **Key Insight:** Summit Commerce led as the top account with over 32.5K in total sales, anchoring the High Value Customer segment.


