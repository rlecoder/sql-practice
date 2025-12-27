SELECT *
FROM (
  SELECT
    customer_id,
    order_id,
    order_date,
    order_total,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY order_date DESC
    ) AS rn
  FROM orders
) ranked
WHERE rn = 1;
