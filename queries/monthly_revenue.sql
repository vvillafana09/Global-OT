WITH revenue_table AS (
	SELECT  order_items.order_id AS order_id,
			order_items.item_id AS item_id,
			order_items.product_id AS product_id,
			order_items.quantity AS quantity,
			order_items.unit_price AS unit_price,
			DATE_TRUNC('month',orders.order_date)::DATE As order_date_month
	FROM order_items_staging AS order_items
	LEFT JOIN orders_staging AS orders
		ON order_items.order_id=orders.order_id
	WHERE orders.status='Shipped'
)
	SELECT  order_date_month,
			SUM(quantity * unit_price) AS total_revenue,
			SUM(quantity) AS total_units_sold
	FROM revenue_table
	GROUP BY order_date_month
	ORDER BY order_date_month
;