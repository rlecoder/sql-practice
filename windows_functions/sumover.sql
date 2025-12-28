SELECT
  customer_id,
  order_date,
  order_total,
  SUM(order_total) OVER (
    PARTITION BY customer_id
    ORDER BY order_date ASC
  ) AS running_total
FROM orders;
