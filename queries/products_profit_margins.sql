WITH revenue_table AS (
	SELECT 	products.product_id,
		products.product_name,
		products.description,
		SUM(order_items.unit_price * order_items.quantity) AS revenue_amount
	FROM order_items
	LEFT JOIN orders
		ON order_items.order_id=orders.order_id
	LEFT JOIN products
		ON order_items.product_id=products.product_id
	WHERE orders.status = 'Shipped'
	GROUP BY products.product_id, products.product_name, products.description
), cost_table AS (
		SELECT 	products.product_id,
		products.product_name,
		products.description,
		SUM(products.standard_cost * order_items.quantity) AS cost_amount
	FROM order_items
	LEFT JOIN orders
		ON order_items.order_id=orders.order_id
	LEFT JOIN products
		ON order_items.product_id=products.product_id
	WHERE orders.status = 'Shipped'
	GROUP BY products.product_id, products.product_name, products.description
)
SELECT revenue_table.product_id,
		revenue_table.product_name,
		revenue_table.description,
		ROUND(((revenue_table.revenue_amount-cost_table.cost_amount)/revenue_table.revenue_amount)*100,3) AS profit_margin
FROM revenue_table
JOIN cost_table
	ON revenue_table.product_id=cost_table.product_id AND
	revenue_table.product_name=cost_table.product_name AND
	revenue_table.description=cost_table.description
;