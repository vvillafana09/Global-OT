WITH revenue_table AS (
	SELECT DATE_TRUNC('month', orders.order_date)::DATE AS monthly_date,
		SUM(order_items.unit_price * order_items.quantity) AS revenue_amount
	FROM order_items
	LEFT JOIN orders
		ON order_items.order_id=orders.order_id
	LEFT JOIN products
		ON order_items.product_id=products.product_id
	WHERE orders.status = 'Shipped'
	GROUP BY monthly_date
), cost_table AS (
	SELECT DATE_TRUNC('month', orders.order_date)::DATE AS monthly_date,
	SUM(products.standard_cost * order_items.quantity) AS cost_amount
	FROM order_items
	LEFT JOIN orders
		ON order_items.order_id=orders.order_id
	LEFT JOIN products
		ON order_items.product_id=products.product_id
	WHERE orders.status = 'Shipped'
	GROUP BY monthly_date
)
SELECT  revenue_table.monthly_date,
		revenue_table.revenue_amount,
	((revenue_table.revenue_amount-cost_table.cost_amount)/revenue_table.revenue_amount)*100 AS profit_margin
FROM revenue_table
INNER JOIN cost_table
	ON revenue_table.monthly_date=cost_table.monthly_date
ORDER BY revenue_table.monthly_date
;