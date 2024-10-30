Q1. Who is the senior-most employee based on the job title?
A1. select * from employee
order by levels desc
limit 1;

Q2. Which country has the most invoices?
A2. select count(*) as c, billing_country
from invoice
group by billing_country
order by c desc

Q3. What are the top 3 values of total invoice
A3. select total
from invoice 
order by total desc
limit 3

Q4. Write a query that returns one city that has the highest sum of invoice totals. Return
both city name and sum of invoice total.
A4. select sum(total) as total, billing_city
from invoice
group by billing_city
order by total desc
limit 1

Q5. Write a query that returns the person who has spent the most money
A5. select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
from customer join invoice
on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

Q6. Write a query to return the email, first name, last name, and genre of all rock music
listeners. Return your list ordered alphabetically by email
A6. select distinct email, first_name, last_name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in (
select track_id from track
join genre on track.genre_id=genre.genre_id
where genre.name like 'Rock'
)
order by email

Q7. Write a query that returns the artist name and total track count of top-10 rock bands
A7. select a.artist_id, a.name, count(a.artist_id) as number_of_songs
from track t join album al on al.album_id=t.album_id
join artist a on a.artist_id=al.artist_id
join genre g on g.genre_id=t.genre_id
where g.name like 'Rock'
group by a.artist_id
order by number_of_songs desc
limit 10;

Q8. Return all the track names that have a song length longer than avg song length. Return
the name and milliseconds for each track. Order by the song length with longest songs
listed first
A8. select name, milliseconds
from track
where milliseconds > (
select avg(milliseconds) as avg_song_time from track
) order by milliseconds desc

Q9. Find how much amount spent by each customer on best selling artist. Write a query to write
customer name, artist name and total spent
A9. with best_selling_artist as (
select a.artist_id as artist_id, a.name as artist_name, sum(il.unit_price*il.quantity) as total_sales
from invoice_line il
join track t on il.track_id=t.track_id
join album al on al.album_id=t.album_id
join artist a on a.artist_id=al.artist_id
group by 1
order by 3 desc
limit 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name,
sum(il.unit_price*il.quantity) as total_sales
from invoice i
join customer c on c.customer_id=i.customer_id
join invoice_line il on il.invoice_id=i.invoice_id
join track t on t.track_id=il.track_id
join album al on al.album_id=t.album_id
join best_selling_artist bsa on bsa.artist_id=al.artist_id
group by 1, 2, 3, 4
order by 5 desc;

Q10. We want to find out most popular music genre for each country. We determine most
popular genre as the genre with highest amont of purchases. Write a query that returns
each country along with the top genre. For country where maximum number of purchases is 
shared return all genres
A10. with popular_genre as
(select count(invoice_line.quantity) as purchases, customer.country, genre. name, genre.genre_id,
row_number()over(partition by customer.country order by count(invoice_line.quantity) desc) as row_no
from invoice_line
join invoice on invoice.invoice_id=invoice_line.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
group by 2, 3, 4
order by 2 asc, 1 desc
)
select * from popular_genre where row_no <=1