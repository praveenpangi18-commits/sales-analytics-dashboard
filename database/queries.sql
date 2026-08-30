-- =========================================
-- Sales Analytics SQL Analysis
-- =========================================

USE sales_analytics;


-- 1. Total Revenue
SELECT
    SUM(revenue) AS total_revenue
FROM sales_analysis;


-- 2. Total Profit
SELECT
    SUM(profit) AS total_profit
FROM sales_analysis;


-- 3. Total Quantity Sold
SELECT
    SUM(quantity) AS total_quantity
FROM sales_analysis;


-- 4. Revenue by Region
SELECT
    region,
    SUM(revenue) AS total_revenue
FROM sales_analysis
GROUP BY region
ORDER BY total_revenue DESC;


-- 5. Revenue by Category
SELECT
    category,
    SUM(revenue) AS total_revenue
FROM sales_analysis
GROUP BY category
ORDER BY total_revenue DESC;
-- 6. Monthly Revenue Trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(revenue) AS total_revenue
FROM sales_analysis
GROUP BY month
ORDER BY month;


-- 7. Top 10 Products by Revenue
SELECT
    product_name,
    SUM(revenue) AS total_revenue
FROM sales_analysis
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;


-- 8. Customer Segmentation
SELECT
    customer_segment,
    COUNT(DISTINCT customer_id) AS customer_count
FROM sales_analysis
GROUP BY customer_segment
ORDER BY customer_count DESC;


-- 9. Revenue by Payment Method
SELECT
    payment_method,
    SUM(revenue) AS total_revenue
FROM sales_analysis
GROUP BY payment_method
ORDER BY total_revenue DESC;


-- 10. Revenue by State
SELECT
    state,
    SUM(revenue) AS total_revenue
FROM sales_analysis
GROUP BY state
ORDER BY total_revenue DESC;
-- 11. Revenue by Customer
SELECT
    customer_id,
    customer_name,
    SUM(revenue) AS total_revenue
FROM sales_analysis
GROUP BY customer_id, customer_name
ORDER BY total_revenue DESC;


-- 12. Revenue by Product Category and Region
SELECT
    region,
    category,
    SUM(revenue) AS total_revenue
FROM sales_analysis
GROUP BY region, category
ORDER BY total_revenue DESC;


-- 13. Profit by Category
SELECT
    category,
    SUM(profit) AS total_profit
FROM sales_analysis
GROUP BY category
ORDER BY total_profit DESC;


-- 14. Average Order Value
SELECT
    SUM(revenue) / COUNT(DISTINCT order_id) AS average_order_value
FROM sales_analysis;


-- 15. Orders by Payment Method
SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders
FROM sales_analysis
GROUP BY payment_method
ORDER BY total_orders DESC;
-- 16. Customer Orders using INNER JOIN
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.region
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;


-- 17. Customers with their Order Count
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC;


-- 18. Products and Order Details
SELECT
    p.product_id,
    p.product_name,
    p.category,
    od.quantity,
    od.discount
FROM products p
INNER JOIN order_details od
    ON p.product_id = od.product_id;


-- 19. Revenue by Customer and Region
SELECT
    c.customer_name,
    o.region,
    SUM(od.quantity * p.price) AS total_revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_details od
    ON o.order_id = od.order_id
INNER JOIN products p
    ON od.product_id = p.product_id
GROUP BY c.customer_name, o.region
ORDER BY total_revenue DESC;


-- 20. Product Sales Performance
SELECT
    p.product_name,
    p.category,
    SUM(od.quantity) AS total_quantity_sold,
    SUM(od.quantity * p.price) AS total_revenue
FROM products p
INNER JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC;
-- 21. Profit Margin by Category
SELECT
    category,
    SUM(profit) AS total_profit,
    SUM(revenue) AS total_revenue,
    ROUND(SUM(profit) / SUM(revenue) * 100, 2) AS profit_margin
FROM sales_analysis
GROUP BY category
ORDER BY profit_margin DESC;
-- 22. High-Value Customers
SELECT
    customer_id,
    customer_name,
    SUM(revenue) AS total_revenue
FROM sales_analysis
GROUP BY customer_id, customer_name
HAVING SUM(revenue) > 10000
ORDER BY total_revenue DESC;
-- 23. Products with High Sales
SELECT
    product_name,
    SUM(quantity) AS total_quantity
FROM sales_analysis
GROUP BY product_name
HAVING SUM(quantity) > 100
ORDER BY total_quantity DESC;
-- 24. Revenue by Year
SELECT
    YEAR(order_date) AS sales_year,
    SUM(revenue) AS total_revenue
FROM sales_analysis
GROUP BY YEAR(order_date)
ORDER BY sales_year;
-- 25. Profit by Region
SELECT
    region,
    SUM(profit) AS total_profit
FROM sales_analysis
GROUP BY region
ORDER BY total_profit DESC;
-- 26. Revenue Performance
SELECT
    order_id,
    customer_name,
    revenue,
    CASE
        WHEN revenue >= 1000 THEN 'High'
        WHEN revenue >= 500 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_level
FROM sales_analysis;
-- 27. Customers with Multiple Orders
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM sales_analysis
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY total_orders DESC;
-- 28. Most Profitable Products
SELECT
    product_name,
    SUM(profit) AS total_profit
FROM sales_analysis
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 10;
-- 29. Product Revenue Ranking
SELECT
    product_name,
    SUM(revenue) AS total_revenue,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM sales_analysis
GROUP BY product_name
ORDER BY revenue_rank;
-- 30. Regional Revenue Ranking
SELECT
    region,
    SUM(revenue) AS total_revenue,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS region_rank
FROM sales_analysis
GROUP BY region
ORDER BY region_rank;
SELECT order_id,customer_name,
ROW_NUMBER() OVER(ORDER BY order_date) row_no
FROM sales_analysis;
SELECT product_name,SUM(revenue) revenue,
DENSE_RANK() OVER(ORDER BY SUM(revenue) DESC) rank_no
FROM sales_analysis
GROUP BY product_name;
SELECT month,revenue,
LAG(revenue) OVER(ORDER BY month) previous_revenue
FROM (
    SELECT DATE_FORMAT(order_date,'%Y-%m') month,
           SUM(revenue) revenue
    FROM sales_analysis
    GROUP BY month
) x;
SELECT month,revenue,
LEAD(revenue) OVER(ORDER BY month) next_revenue
FROM (
    SELECT DATE_FORMAT(order_date,'%Y-%m') month,
           SUM(revenue) revenue
    FROM sales_analysis
    GROUP BY month
) x;
SELECT order_date,revenue,
SUM(revenue) OVER(ORDER BY order_date) running_total
FROM sales_analysis;
SELECT region,AVG(revenue) avg_revenue
FROM sales_analysis
GROUP BY region
ORDER BY avg_revenue DESC;
SELECT category,product_name,revenue
FROM (
    SELECT category,product_name,
           SUM(revenue) revenue,
           RANK() OVER(
             PARTITION BY category
             ORDER BY SUM(revenue) DESC
           ) r
    FROM sales_analysis
    GROUP BY category,product_name
) x
WHERE r=1;
SELECT region,customer_name,revenue
FROM (
    SELECT region,customer_name,
           SUM(revenue) revenue,
           RANK() OVER(
             PARTITION BY region
             ORDER BY SUM(revenue) DESC
           ) r
    FROM sales_analysis
    GROUP BY region,customer_name
) x
WHERE r=1;
SELECT customer_name,SUM(revenue) revenue
FROM sales_analysis
GROUP BY customer_name
HAVING SUM(revenue) > (
    SELECT AVG(revenue)
    FROM sales_analysis
);
WITH sales AS (
    SELECT category,SUM(revenue) revenue
    FROM sales_analysis
    GROUP BY category
)
SELECT *
FROM sales
ORDER BY revenue DESC;
-- 41. Total Orders
SELECT COUNT(DISTINCT order_id) total_orders
FROM sales_analysis;
-- 42. Average Order Value
SELECT SUM(revenue)/COUNT(DISTINCT order_id) avg_order_value
FROM sales_analysis;
-- 43. Total Discount
SELECT SUM(discount) total_discount
FROM sales_analysis;
-- 44. Revenue After Discount
SELECT SUM(revenue*(1-discount)) net_revenue
FROM sales_analysis;
-- 45. Discount by Category
SELECT category,AVG(discount) avg_discount
FROM sales_analysis
GROUP BY category
ORDER BY avg_discount DESC;
-- 46. Profit by Payment Method
SELECT payment_method,SUM(profit) profit
FROM sales_analysis
GROUP BY payment_method
ORDER BY profit DESC;
-- 47. Quantity by Category
SELECT category,SUM(quantity) quantity
FROM sales_analysis
GROUP BY category
ORDER BY quantity DESC;
-- 48. Orders by Region
SELECT region,COUNT(DISTINCT order_id) orders
FROM sales_analysis
GROUP BY region
ORDER BY orders DESC;
-- 49. Customers by Region
SELECT region,COUNT(DISTINCT customer_id) customers
FROM sales_analysis
GROUP BY region
ORDER BY customers DESC;
-- 50. Revenue and Profit
SELECT
    SUM(revenue) revenue,
    SUM(profit) profit,
    ROUND(SUM(profit)/SUM(revenue)*100,2) margin
FROM sales_analysis;
-- 51. Revenue by City
SELECT city,SUM(revenue) revenue
FROM sales_analysis
GROUP BY city
ORDER BY revenue DESC;


-- 52. Profit by State
SELECT state,SUM(profit) profit
FROM sales_analysis
GROUP BY state
ORDER BY profit DESC;


-- 53. Average Quantity per Order
SELECT AVG(quantity) avg_quantity
FROM (
    SELECT order_id,SUM(quantity) quantity
    FROM sales_analysis
    GROUP BY order_id
) x;


-- 54. Highest Revenue Order
SELECT order_id,SUM(revenue) revenue
FROM sales_analysis
GROUP BY order_id
ORDER BY revenue DESC
LIMIT 1;


-- 55. Highest Profit Order
SELECT order_id,SUM(profit) profit
FROM sales_analysis
GROUP BY order_id
ORDER BY profit DESC
LIMIT 1;


-- 56. Lowest Revenue Product
SELECT product_name,SUM(revenue) revenue
FROM sales_analysis
GROUP BY product_name
ORDER BY revenue
LIMIT 1;


-- 57. Lowest Profit Product
SELECT product_name,SUM(profit) profit
FROM sales_analysis
GROUP BY product_name
ORDER BY profit
LIMIT 1;


-- 58. Products with Negative Profit
SELECT product_name,SUM(profit) profit
FROM sales_analysis
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY profit;


-- 59. Products Above Average Revenue
SELECT product_name,category,SUM(revenue) revenue
FROM sales_analysis
GROUP BY product_name,category
HAVING SUM(revenue) > (
    SELECT AVG(total_revenue)
    FROM (
        SELECT SUM(revenue) total_revenue
        FROM sales_analysis
        GROUP BY product_name
    ) x
);


-- 60. Monthly Profit
SELECT DATE_FORMAT(order_date,'%Y-%m') month,
SUM(profit) profit
FROM sales_analysis
GROUP BY month
ORDER BY month;


-- 61. Monthly Quantity
SELECT DATE_FORMAT(order_date,'%Y-%m') month,
SUM(quantity) quantity
FROM sales_analysis
GROUP BY month
ORDER BY month;


-- 62. Best Selling Category
SELECT category,SUM(quantity) quantity
FROM sales_analysis
GROUP BY category
ORDER BY quantity DESC
LIMIT 1;


-- 63. Most Used Payment Method
SELECT payment_method,COUNT(DISTINCT order_id) orders
FROM sales_analysis
GROUP BY payment_method
ORDER BY orders DESC
LIMIT 1;


-- 64. Customer Revenue Ranking
SELECT customer_name,SUM(revenue) revenue,
RANK() OVER(ORDER BY SUM(revenue) DESC) rank_no
FROM sales_analysis
GROUP BY customer_name;


-- 65. Customer Profit Ranking
SELECT customer_name,SUM(profit) profit,
RANK() OVER(ORDER BY SUM(profit) DESC) rank_no
FROM sales_analysis
GROUP BY customer_name;
-- 61. Employee Project Details
SELECT e.employee_name, d.department_name, p.project_name,
       c.client_name, ep.role, ep.hours_worked
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
JOIN clients c ON p.client_id = c.client_id;

-- 62. Projects Above 10 Lakh
SELECT d.department_name, p.project_name, c.client_name, p.budget
FROM projects p
JOIN departments d ON p.department_id = d.department_id
JOIN clients c ON p.client_id = c.client_id
WHERE p.budget > 1000000
ORDER BY p.budget DESC;

-- 63. Employees Without Projects
SELECT e.employee_name
FROM employees e
LEFT JOIN employee_projects ep
ON e.employee_id = ep.employee_id
WHERE ep.project_id IS NULL;

-- 64. Departments Without Employees
SELECT d.department_name
FROM departments d
LEFT JOIN employees e
ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

-- 65. Employees Earning More Than Manager
SELECT e.employee_name, e.salary employee_salary,
       m.employee_name manager_name, m.salary manager_salary
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;