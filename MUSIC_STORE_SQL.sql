create database music;
use music;
select * from album2;

/*	Question Set 1 - Easy */

/* Q1: Who is the senior most employee based on job title? */

SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1;

/* Q2: Which countries have the most Invoices? */

SELECT 
    billing_country AS country, COUNT(invoice_id) AS count
FROM
    invoice
GROUP BY country
ORDER BY count DESC;

/* Q3: What are top 3 values of total invoice? */

SELECT *
FROM invoice
ORDER BY total DESC
LIMIT 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT 
    billing_city AS city, SUM(total) AS sum
FROM
    music.invoice
GROUP BY city
ORDER BY sum DESC;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

use music;
select first_name, last_name ,customer.customer_id , billing_address from customer join invoice on customer.customer_id = invoice.customer_id;

SELECT 
    customer.customer_id,
    ANY_VALUE(customer.first_name),
    SUM(invoice.total) AS sum
FROM invoice
JOIN customer ON invoice.customer_id = customer.customer_id
GROUP BY invoice.customer_id;

/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

/*Method 1 */
               
SELECT DISTINCT customer.email, first_name,last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

/* Method 2 */

SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName, genre.name AS Name
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;

/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT artist.artist_id,any_value(artist.name) as artist_name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album2 ON album2.album_id = track.album_id
JOIN artist ON artist.artist_id = album2.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT name,milliseconds
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_track_length
	FROM track )
ORDER BY milliseconds DESC;

