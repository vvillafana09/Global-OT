WITH cte_table AS (
	SELECT order_items.order_id AS order_id,
			DATE_TRUNC('year',orders.order_date)::DATE As yearly_orders,
			order_items.product_id AS product_id,
			products.category_id AS category_id,
			product_categories.category_name AS category_name,
			order_items.quantity AS quantity,
			order_items.unit_price AS unit_price,
			products.product_name AS product_name,
			products.description AS description, 
			products.standard_cost AS standard_cost
	FROM order_items_staging AS order_items
	LEFT JOIN orders_staging AS orders
		ON order_items.order_id=orders.order_id
	LEFT JOIN products_staging AS products
		ON order_items.product_id=products.product_id
	LEFT JOIN product_categories 
		ON products.category_id=product_categories.category_id
	WHERE orders.status = 'Shipped'
), calc_table AS (
	SELECT yearly_orders,
			product_id,
			product_name,
			category_id,
			category_name,
			description,
			SUM(quantity * unit_price) AS revenue,
			SUM(quantity * standard_cost) AS cogs,
			SUM(quantity * unit_price) - SUM(quantity * standard_cost) AS gross_profit
	FROM cte_table
	GROUP BY yearly_orders, 
			product_id,
			 product_name,
			category_id,
			category_name,
			 description
)
SELECT 
		yearly_orders,
		product_id,
		product_name,
		category_id,
		category_name,
		description,
		revenue, 
		cogs,
		ROUND((gross_profit/ revenue)*100,4) AS profit_margin,
		CASE WHEN ROUND((gross_profit/ revenue)*100,4) < 12 THEN 'Low'
		ELSE 'Not Low' END AS low_margin_flag
FROM calc_table
ORDER BY yearly_orders
;