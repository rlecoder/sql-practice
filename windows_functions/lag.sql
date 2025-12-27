SELECT
  customer_id,
  order_id,
  order_date,
  LAG(order_date) OVER (
    PARTITION BY customer_id
    ORDER BY order_date
  ) AS prev_order_date
FROM orders;
