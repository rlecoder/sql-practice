SELECT
  customer_id,
  order_id,
  order_date,
  LEAD(order_date) OVER (
    PARTITION BY customer_id
    ORDER BY order_date
  ) AS next_order_date
FROM orders;
