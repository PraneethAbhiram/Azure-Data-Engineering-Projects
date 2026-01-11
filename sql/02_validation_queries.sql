-- Total records loaded
SELECT COUNT(*) AS total_records FROM customers_raw;

-- Check for null customer IDs
SELECT COUNT(*) AS null_ids 
FROM customers_raw 
WHERE customer_id IS NULL;

-- Check duplicate customers
SELECT customer_id, COUNT(*) AS cnt
FROM customers_raw
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check invalid spend values
SELECT COUNT(*) AS invalid_spend
FROM customers_raw
WHERE total_spent < 0;

-- Country distribution
SELECT country, COUNT(*) AS cnt
FROM customers_raw
GROUP BY country
ORDER BY cnt DESC;
