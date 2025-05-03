SELECT DATE_TRUNC('month',orders.order_date)::DATE As order_date_month,
	ROUND(SUM(CASE WHEN status='Shipped' THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS shipped_percentage,
	ROUND(SUM(CASE WHEN status='Canceled' THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS canceled_percentage,
	ROUND(SUM(CASE WHEN status='Pending' THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS progress_percentage
FROM orders
GROUP BY order_date_month
ORDER BY order_date_month
;
