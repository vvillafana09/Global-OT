SELECT DATE_TRUNC('month',orders.order_date)::DATE As order_date_month,
		product_categories.category_name AS product_category,
		SUM(order_items.quantity * order_items.unit_price) AS revenue
FROM order_items_staging AS order_items
LEFT JOIN orders_staging AS orders
	ON order_items.order_id=orders.order_id
LEFT JOIN products_staging AS products
	ON order_items.product_id=products.product_id
INNER JOIN product_categories_staging AS product_categories
	ON products.category_id=product_categories.category_id
WHERE orders.status = 'Shipped'
GROUP BY order_date_month, product_categories.category_name
ORDER BY order_date_month DESC
;