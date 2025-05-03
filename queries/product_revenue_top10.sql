WITH cte_table AS (
	SELECT order_items.order_id AS order_id,
			order_items.product_id AS product_id,
			order_items.quantity AS quantity,
			order_items.unit_price AS unit_price,
			DATE_TRUNC('month',orders.order_date)::DATE As order_date_month,
			products.product_name AS product_name,
			products.description AS product_desc,
			products.category_id AS category_id,
			product_categories.category_name AS category_name
	FROM order_items_staging AS order_items
	LEFT JOIN orders_staging AS orders
		ON order_items.order_id=orders.order_id
	LEFT JOIN products_staging As products
		ON order_items.product_id=products.product_id
	LEFT JOIN product_categories 
		ON products.category_id=product_categories.category_id
	WHERE orders.status='Shipped' 
)
SELECT order_date_month,
		product_id,
		category_id,
		category_name,
		product_name,
		product_desc,
		SUM(quantity * unit_price) AS product_revenue
FROM cte_table
GROUP BY order_date_month, product_id, category_id, category_name, product_name, product_desc
ORDER BY order_date_month, product_revenue DESC 
;