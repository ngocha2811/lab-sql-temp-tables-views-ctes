#create a customer summary report that summarizes key information about customers in the Sakila database, 
#including their rental history and payment details. The report will be generated using a combination of views, 
#CTEs, and temporary tables.
USE sakila;

CREATE VIEW rental_history AS
SELECT customer_id, COUNT(*) AS rental_count,
MAX(rental_date) AS last_rental_date
FROM rental
GROUP BY customer_id;

CREATE TEMPORARY TABLE customer_spent AS 
SELECT customer_id,
AVG(amount) AS avg_paid,
SUM(amount) AS total_paid
FROM payment
GROUP BY customer_id;

SELECT c.customer_id, first_name, last_name, email, rental_count, avg_paid, total_paid, last_rental_date
FROM customer c
LEFT JOIN rental_history nu
ON nu.customer_id = c.customer_id
LEFT JOIN customer_spent cu
ON cu.customer_id = nu.customer_id;

WITH customer_report AS (
SELECT c.customer_id, first_name, last_name, email, rental_count, avg_paid, total_paid, last_rental_date
FROM customer c
LEFT JOIN rental_history nu
ON nu.customer_id = c.customer_id
LEFT JOIN customer_spent cu
ON cu.customer_id = nu.customer_id)
SELECT *, total_paid/rental_count AS average_payment_per_rental
FROM customer_report
;





