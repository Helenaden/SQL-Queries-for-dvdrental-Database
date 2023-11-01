--Question 1: Display the customer names that share the same address (e.g husband and wife).
--Answer 1.1:
-- This condition might lead to some redundancy because it pairs each customer with all other customers, including itself.
/*SELECT c1.first_name, c1.last_name, c2.first_name, c2.last_name
FROM customer as c1
JOIN customer as c2
ON c1.customer_id <> c2.customer_id 
AND c1.address_id = c2.address_id;*/

--Answer 1.2:
--This condition will ensure unique and non-redundant pairs.
/*SELECT c1.first_name AS first_name1, c1.last_name AS last_name1,
c2.first_name AS first_name2, c2.last_name AS last_name2
FROM customer c1
JOIN customer c2
ON c1.customer_id < c2.customer_id -- Ensures unique pairs
AND c1.address_id = c2.address_id;*/

--Answer 1.3:
--This condition combines customer first and last name into a single "customer" column.
/*SELECT DISTINCT
CONCAT(c1.first_name, ' ', c1.last_name) AS customer1,
CONCAT(c2.first_name, ' ', c2.last_name) AS customer2
FROM customer c1
JOIN customer c2
ON c1.customer_id < c2.customer_id -- Ensures unique pairs
AND c1.address_id = c2.address_id;*/

--Question 2: What is the name of the customer who made the highest total payment?
--Answer 2.1: 
-- This query uses an explicit JOIN with a subquery in the FROM clause.
/*SELECT c.first_name, c.last_name
FROM customer c
JOIN (SELECT customer_id, SUM(amount) AS total_payment
FROM payment
GROUP BY customer_id
ORDER BY total_payment DESC
LIMIT 1) AS max_payment
ON c.customer_id = max_payment.customer_id;*/

--Answer 2.2:
--While this query uses a correlated subquery in the WHERE clause.
/*SELECT first_name, last_name
FROM customer
WHERE customer_id IN
(SELECT customer_id 
 FROM payment
 GROUP BY customer_id
 HAVING SUM(amount) =
 (SELECT SUM(amount)
 FROM payment
  GROUP BY customer_id
  ORDER BY SUM(amount) DESC LIMIT 1));*/
  
-- Question 3: What is the movie(s) that was rented the most?
-- Answer 3.1:
-- This query sorts the movie that was rented the most by counting how many times each film has been rented by its film_id.
/*SELECT film_id, count(film_id)
FROM rental R
JOIN inventory I
ON R.inventory_id = I.inventory_id
GROUP BY film_id
ORDER BY count(film_id) DESC 
LIMIT 1; --limits the result to only the first row to get the movie(s) that was rented the most.
*/

--Answer 3.2:
-- This query sorts the movie that was rented the most by providing the film_id, movie title and counts how many times each movie has been rented.
/*SELECT film.film_id, film.title AS movie_title, COUNT(rental.rental_id) AS rental_count
FROM film
JOIN inventory 
ON film.film_id = inventory.film_id
JOIN rental 
ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id, film.title
ORDER BY rental_count DESC
LIMIT 1;*/

--Question 4: Which movies have been rented so far.
--Answer 4.1:
--This query retrieves film id and title of movies that have been rented using a subquery to filter by film_id.
/*SELECT film_id, title
FROM film
WHERE film_id IN
(SELECT DISTINCT film_id
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id)
ORDER BY film_id;*/

--Answer 4.2:
--This query calculates and returns the count of movie titles rented as a single value.
/*SELECT count(title) 
FROM film
WHERE film_id IN
(SELECT DISTINCT film_id
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id);*/

--Question 5: Which movies have not been rented so far.
--Answer 5.1:
--This query retrieves film id and title of movies that have not been rented using a subquery to filter by film_id.
/*SELECT film_id, title 
FROM film
WHERE film_id NOT IN
(SELECT DISTINCT film_id
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id)
ORDER BY film_id;*/

--Answer 5.2:
--This query calculates and returns the count of movie titles not rented as a single value.
/*SELECT count(title)
FROM film
WHERE film_id NOT IN
(SELECT DISTINCT film_id
FROM rental
JOIN inventory
On rental.inventory_id = inventory.inventory_id);*/

--Question 6: Which customers have not rented any movies so far.
--Answer 6.1: 
--Using NOT IN
--This query selects customers that have not rented any movies by their customer ids, first name, and last name.
/*SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id NOT IN 
(SELECT DISTINCT customer_id
FROM rental);*/

--Answer 6.2:
--Using NOT EXISTS
--This query selects customers that have not rented any movies by their customer ids, first name and last name.
/*SELECT customer_id, first_name, last_name
FROM customer C
WHERE NOT EXISTS
(SELECT DISTINCT customer_id 
FROM rental R
WHERE C.customer_id = R.customer_id);*/

--Question 7: Display each movie and the number of times it got rented.
--Answer 7.1: 
--This query displays each movie by their film ids and the number of times it got rented.
/*SELECT film_id, count(film_id)
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
GROUP BY film_id
ORDER BY film_id;*/

--Answer 7.2:
--This query displays each movie by their film id, titles and the number of times it got rented.
/*SELECT film.film_id, film.title AS movie_title, COUNT(rental.rental_id) AS rental_count
FROM film
JOIN inventory 
ON film.film_id = inventory.film_id
JOIN rental 
ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id, film.title
ORDER BY film.title;*/

--Question 8: Show the first and the last name and the number of films each actor acted in.
--Answer 8.1:
--This query groups and orders the results based on the combination of first_name and last_name. 
--If there are multiple actors with the same name, their counts will be aggregated together. 
--This can result in different counts and a different order compared to the Code with actor_id (which is shown below).
/*SELECT DISTINCT
CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name, COUNT(film_actor.film_id) as number_of_films
FROM actor
JOIN film_actor
ON actor.actor_id = film_actor.actor_id
GROUP BY CONCAT(actor.first_name, ' ', actor.last_name)
ORDER BY number_of_films DESC;*/

--Answer 8.2:
--To ensure consistency,  to see individual actors and their counts of films, I will use the Code with actor_id.
/*SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(film_actor.film_id) as number_of_films
FROM actor
JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
ORDER BY actor.actor_id;*/

--Question 9: Display the names of the actors that acted in more than 20 movies.
--Answer 9.1: 
--This query groups and orders the results based on the combination of first_name and last_name. 
--If there are multiple actors with the same name, their counts will be aggregated together. 
--This can result in different counts and a different order compared to the Code with actor_id (which is shown below).
/*SELECT DISTINCT
CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name, COUNT(film_actor.film_id) as number_of_films
FROM actor
JOIN film_actor
ON actor.actor_id = film_actor.actor_id
GROUP BY CONCAT(actor.first_name, ' ', actor.last_name)
HAVING COUNT(film_actor.film_id) >20;*/

--Answer 9.2:
--To ensure consistency,  to see individual actors and their counts of films, I will use the Code with actor_id.
/*SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(film_actor.film_id) as number_of_films
FROM actor
JOIN film_actor 
ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(film_actor.film_id) >20
ORDER BY actor.actor_id;*/

--Question 10: For all the movies rated “PG” show me the movie and the number of times it got rented.
--Answer 10.1:
--This query selects and groups by movie titles.
/*SELECT f.film_id, f.title AS movie_title, COUNT(r.rental_id) AS rental_count
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE f.rating = 'PG'
GROUP BY f.film_id, f.title
ORDER BY f.film_id;*/

--Answer 10.2:
--This query selects and groups by film IDs.
/*SELECT inventory.film_id, COUNT(inventory.film_id) as movie_count
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film
ON inventory.film_id = film.film_id
WHERE rating = 'PG'
GROUP BY inventory.film_id
ORDER BY inventory.film_id;*/

--Question 11: Display the movies offered for rent in store_id 1 and not offered in store_id 2.
--Answer 11.1: 
--This query directly provides the movie titles that meet the condition.
/*SELECT film.film_id, film.title AS movie_title
FROM film
JOIN inventory AS i1 
ON film.film_id = i1.film_id 
AND i1.store_id = 1
LEFT JOIN inventory AS i2 
ON film.film_id = i2.film_id 
AND i2.store_id = 2
WHERE i2.store_id IS NULL
ORDER BY film.film_id;*/

--Answer 11.2:
--This query gives the count of the movies.
/*SELECT count(film_id)
FROM inventory
WHERE store_id = 1 AND film_id NOT IN (
SELECT film_id
FROM inventory
WHERE store_id = 2);*/

--Answer 11.3:
--The result from the codes above includes movies appearing multiple times, 
--which may be due to multiple copies of the same movie available for rent in store_id 1.
--To ensure that each movie appears only once in the result list, I will use the DISTINCT keyword in the query.
/*SELECT DISTINCT film.film_id, film.title AS movie_title
FROM film
JOIN inventory AS i1 
ON film.film_id = i1.film_id 
AND i1.store_id = 1
LEFT JOIN inventory AS i2 
ON film.film_id = i2.film_id 
AND i2.store_id = 2
WHERE i2.store_id IS NULL
ORDER BY film.film_id;*/

--Answer 11.4:
/*SELECT count(DISTINCT inventory.film_id)
FROM inventory
WHERE store_id = 1 AND film_id NOT IN (
SELECT film_id
FROM inventory
WHERE store_id = 2);*/

--Question 12: Display the movies offered for rent in any of the two stores 1 and 2.
--Answer 12.1:
--This query provides a list of distinct film ids and movie titles offered in either store 1 or store 2.
/*SELECT DISTINCT film.film_id, film.title AS movie_title
FROM film
JOIN inventory AS i 
ON film.film_id = i.film_id
WHERE i.store_id = 1 
OR i.store_id = 2
ORDER BY film.film_id;*/

--Answer 12.2:
--This query uses the UNION operator to combine the results of two subqueries, 
--eliminating duplicates to give a list of unique film_id values that correspond to movies offered in either store 1 or store 2.
/*(SELECT film_id
FROM inventory
WHERE store_id = 1)
UNION
(SELECT film_id
FROM inventory
WHERE store_id = 2)
ORDER by film_id;*/

--Answer 12.3:
--This query provides a count of unique movies offered in either store.
/*SELECT count(DISTINCT inventory.film_id)
FROM inventory
WHERE store_id = 1 OR store_id = 2;*/

--Question 13: Display the movie titles of those movies offered in both stores at the same time.
--Answer 13.1: 
--This query uses a subquery to find the film_id values for movies offered in store 1 and store 2.
/*SELECT film_id, title
FROM film
WHERE film_id IN 
(SELECT film_id
FROM inventory
WHERE store_id = 1
AND film_id IN
(SELECT film_id
FROM inventory 
WHERE store_id = 2))
ORDER BY film_id;*/

--Answer 13.2:
--This query uses JOIN operations to find the film_id values for movies offered in store 1 and store 2.
/*SELECT DISTINCT film.film_id, film.title AS movie_title
FROM film
JOIN inventory AS i1 
ON film.film_id = i1.film_id 
AND i1.store_id = 1
JOIN inventory AS i2 
ON film.film_id = i2.film_id 
AND i2.store_id = 2
ORDER BY film.film_id;*/

--Answer 13.3:
--This query uses intersect.
/*SELECT film_id, title
FROM film
WHERE film_id IN 
((SELECT film_id
FROM inventory
WHERE store_id = 1)
INTERSECT
(SELECT film_id
FROM inventory 
WHERE store_id = 2))
ORDER BY film_id;*/

--Answer 13.4:
--This query uses exists.
/*SELECT film_id, title
FROM film
WHERE film_id IN 
(SELECT film_id
FROM inventory i1
WHERE store_id = 1 
and EXISTS
(SELECT film_id
FROM inventory i2
WHERE store_id = 2
AND i1.film_id = i2.film_id))
ORDER BY film_id;*/

--Question 14: Display the movie title for the most rented movie in the store with store_id 1.
--Answer 14: 
/*SELECT film.film_id, film.title AS movie_title, i.store_id, COUNT(r.rental_id) AS number_of_times_rented
FROM film
JOIN inventory AS i 
ON film.film_id = i.film_id
JOIN rental AS r 
ON i.inventory_id = r.inventory_id
WHERE i.store_id = 1
GROUP BY film.film_id, film.title, i.store_id
ORDER BY COUNT(r.rental_id) DESC
LIMIT 1;*/

--Question 15: How many movies are not offered for rent in the stores yet. There are two stores only 1 and 2.
--Answer 15.1:
--This query explicitly finds movies not in store 1 and not in store 2 using NOT IN.
/*SELECT COUNT(film.film_id)
FROM film
WHERE film.film_id 
NOT IN (
SELECT DISTINCT i1.film_id
FROM inventory i1
WHERE i1.store_id = 1
)
AND film.film_id 
NOT IN (
SELECT DISTINCT i2.film_id
FROM inventory i2
WHERE i2.store_id = 2
);*/

--Answer 15.2:
--This query calculates the difference between the total number of movies and the number of movies in both stores combined.
/*SELECT (SELECT COUNT(*) FROM film)
-
(SELECT COUNT(DISTINCT film_id)
FROM
((SELECT film_id 
FROM inventory
WHERE store_id = 1)
UNION
(SELECT film_id
FROM inventory
WHERE store_id = 2)) temp);*/

--Question 16: Show the number of rented movies under each rating.
--Answer 16.1:
--This query uses LEFT JOIN to connect the film table with the inventory and rental tables.
--The query counts rentals.
/*SELECT film.rating, COUNT(rental.rental_id) AS rental_count
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.rating
ORDER BY COUNT(rental.rental_id);*/

--Answer 16.2:
--This  query uses a RIGHT JOIN to connect the film table with the inventory table through the rental table.
--The query counts the number of movies in the inventory.
/*SELECT film.rating, count(inventory.film_id)
FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
RIGHT JOIN film
ON inventory.film_id = film.film_id
GROUP BY film.rating
ORDER BY count(inventory.film_id) DESC;*/

--Question 17: Show the profit of each of the stores 1 and 2.
--Answer 17.1: 
--First, I will use this query to retrieve the total revenue.
--This query combines data from the payment, rental, and inventory tables to calculate the total payment amount for each store.
/*SELECT store_id, SUM(amount)
FROM payment
JOIN rental
ON payment.rental_id = rental.rental_id
JOIN inventory
ON inventory.inventory_id = rental.inventory_id
GROUP BY store_id
ORDER BY store_id;*/

--Answer 17.2:
--To calculate the profit for each store, I need to subtract the costs (rental rate) from the revenue (amounts) to get the profit.
/*SELECT inventory.store_id, SUM(payment.amount - film.rental_rate) AS profit
FROM payment
JOIN rental 
ON payment.rental_id = rental.rental_id
JOIN inventory 
ON rental.inventory_id = inventory.inventory_id
JOIN film 
ON inventory.film_id = film.film_id
GROUP BY inventory.store_id
ORDER BY profit DESC;*/
