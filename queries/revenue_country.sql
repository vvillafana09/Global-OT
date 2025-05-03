WITH region_revenue AS (
	SELECT order_items.order_id,
			order_items.item_id,
			order_items.product_id,
			order_items.quantity,
			order_items.unit_price,
			DATE_TRUNC('month',orders.order_date)::DATE As order_date_month,
			warehouses.warehouse_name,
			countries.country_name
	FROM order_items_staging AS order_items
	LEFT JOIN orders_staging AS orders
		ON order_items.order_id=orders.order_id
	LEFT JOIN products_staging As products
		ON order_items.product_id=products.product_id
	INNER JOIN inventories
		ON products.product_id=inventories.product_id
	INNER JOIN warehouses
		ON inventories.warehouse_id=warehouses.warehouse_id
	INNER JOIN locations
		ON warehouses.location_id=locations.location_id
	INNER JOIN countries
		ON locations.country_id=countries.country_id
	INNER JOIN regions
		ON countries.region_id=regions.region_id
	WHERE orders.status='Shipped' 
)
SELECT order_date_month,
		warehouse_name,
		country_name,
		SUM(quantity * unit_price) AS revenue_country
FROM region_revenue
GROUP BY order_date_month,
		warehouse_name,
		country_name
;