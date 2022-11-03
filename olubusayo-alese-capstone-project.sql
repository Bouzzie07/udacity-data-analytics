/***Getting Information on Top Paying Customers****/
SELECT CONCAT(first_name, ' ', last_name) AS customer_name, email, SUM(payment.amount) AS total_amount
FROM customer
JOIN payment
ON customer.customer_id = payment.customer_id
Group BY customer_name, email
ORDER BY total_amount DESC
LIMIT 10;

/***Getting Information on Bottom Paying Customers****/
SELECT CONCAT(first_name, ' ', last_name) AS customer_name, email, SUM(payment.amount) AS total_amount
FROM customer
JOIN payment
ON customer.customer_id = payment.customer_id
Group BY customer_name, email
ORDER BY total_amount ASC
LIMIT 10;

/***Getting the Most Profitable Genre (Rating)****/
SELECT name AS genre, SUM(amount) AS total_amount
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN film
ON film_category.film_id = film.film_id
JOIN inventory
ON inventory.film_id = film.film_id
JOIN rental
ON rental.inventory_id = inventory.inventory_id
JOIN payment
ON payment.rental_id = rental.rental_id
GROUP BY genre
ORDER BY total_amount DESC;

/****Customer Base in the Countries Where We Have Presence****/
SELECT country, COUNT(country.country_id) AS customer_base
FROM country
JOIN city
ON city.country_id = country.country_id
JOIN address
ON address.city_id = city.city_id
JOIN customer
ON address.address_id = customer.address_id
GROUP BY country
ORDER BY 2 DESC;


/****Most Profitable Country****/
SELECT country, 
	COUNT(payment.customer_id) AS total_rental_times, SUM(amount) AS total_amount
FROM country
JOIN city
ON city.country_id = country.country_id
JOIN address
ON address.city_id = city.city_id
JOIN customer
ON address.address_id = customer.address_id
JOIN payment
ON payment.customer_id = customer.customer_id
GROUP BY country
ORDER BY 2 DESC;

/***Average Rental Rate Per Genre (Rating)****/
SELECT name AS genre, ROUND(AVG(rental_rate),2) AS avg_rental_rate
FROM category
JOIN film_category
ON category.category_id = film_category.category_id
JOIN film
ON film_category.film_id = film.film_id
GROUP BY genre
ORDER BY avg_rental_rate DESC;

/***How many movies were returned early, late and on time****/
SELECT
	CASE WHEN rental_duration > DATE_PART('day', return_date::timestamp - rental_date::timestamp) THEN 'Early'
		WHEN rental_duration = DATE_PART('day', return_date::timestamp - rental_date::timestamp) THEN 'On Time'
		ELSE 'Late' END AS return_status,
	COUNT (*) AS total_films
FROM film
JOIN inventory
ON inventory.film_id = film.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
GROUP BY 1;
