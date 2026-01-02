WITH orders_enhanced AS (
  SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_total,

    ROW_NUMBER() OVER (
      PARTITION BY o.customer_id
      ORDER BY o.order_date DESC, o.order_id DESC
    ) AS order_rank,

    LAG(o.order_date) OVER (
      PARTITION BY o.customer_id
      ORDER BY o.order_date, o.order_id
    ) AS prev_order_date,

    DATEDIFF(
      DAY,
      LAG(o.order_date) OVER (
        PARTITION BY o.customer_id
        ORDER BY o.order_date, o.order_id
      ),
      o.order_date
    ) AS days_since_previous_order,

    SUM(o.order_total) OVER (
      PARTITION BY o.customer_id
      ORDER BY o.order_date, o.order_id
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total,

    AVG(o.order_total) OVER (
      PARTITION BY o.customer_id
      ORDER BY o.order_date, o.order_id
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3_order_avg
  FROM orders o
)
SELECT
  c.customer_id,
  c.customer_name,
  oe.order_id,
  oe.order_date,
  oe.order_total,
  oe.order_rank,
  oe.prev_order_date,
  oe.days_since_previous_order,
  oe.running_total,
  oe.rolling_3_order_avg
FROM customers c
JOIN orders_enhanced oe
  ON oe.customer_id = c.customer_id
ORDER BY c.customer_id, oe.order_date, oe.order_id;
