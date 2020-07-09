# R Queries in SQL ----

# Libraries ----
library(tidyverse)
library(dbplyr)

# SQL Statement Fundamentals ----

# SELECT * FROM table; 
# SELECT columns FROM table;
# SELECT col1, col2 FROM table;
# SELECT DISTINCT(column) FROM table;
# SELECT COUNT(col) FROM table; -- more useful when combined with DISTINCT
# SELECT COUNT(*) FROM table; show number of rows
# SELECT COUNT(DISTINCT column_value) FROM table;
# SELECT col1, col2 FROM table WHERE conditions;
# Advantage SQL > R - SELECT single_column FROM table WHERE condition_from_other_columns
# CHALLENGE SELECT WHERE
# In dplyr use filter() before select() to get closest SELECT FROM WHERE results to SQL
# SELECT col1, col2 FROM table ORDER BY col1 ASC / DESC
# SELECT * FROM table ORDER BY col1 DESC LIMIT 5
# BETWEEN operator is same as `>= low AND <= high`
# BETWEEN 'YYYY-MM-DD' AND 'YYYY-MM-DD'
# LIKE , ILIKE -- `WHERE name LIKE '_her%'`
                                # C her yl
                                # T her esa
                                # S her ri

# SELECT * FROM 
# WHERE
# ORDER BY
# LIMIT

# filter
# arrange
# select
# head

# 



# Challenge: SELECT
# Business Situation: send promotional email to all existing customers
# SELECT first_name, last_name, email  FROM customer;
translate_sql(customer %>% select(first_name, last_name, email))

# In order to demonstrate sql_translations, 
# need to make TEMPORARY database with a couple of tables
con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
flights <- copy_to(con, nycflights13::flights)
airports <- copy_to(con, nycflights13::airports)

# <SQL>
# SELECT `dep_delay`, `arr_delay`
# FROM `nycflights13::flights`
flights %>%
    select(contains("delay")) %>%
    show_query()


# <SQL>
# SELECT `year`, `month`, `day`, `dep_time`, `sched_dep_time`, `dep_delay`, `arr_time`, `sched_arr_time`, `arr_delay`, `carrier`, `flight`, `tailnum`, `origin`, `dest`, `air_time`, `distance`, `hour`, `minute`, `time_hour`
# FROM `nycflights13::flights`
flights %>% 
    select(everything()) %>% 
    show_query()

# DISTINCT
# SELECT DISTINCT(release_year) FROM film;
film %>%
    distinct(release_year)

# <SQL>
# SELECT DISTINCT `month`
# FROM `nycflights13::flights`
flights %>%
    distinct(month) %>% 
    show_query()

# SELECT COUNT(*) FROM table; show number of rows
# note: in regular dataframe, use str() or dim(), 
# but in database, use summarize(n()) 
flights %>%
    summarize(n()) %>%
    show_query()

# SELECT COUNT(DISTINCT month) FROM flights;

flights %>%
    distinct(month) %>%
    summarize(n()) %>%
    show_query()

# NOTE: count() != summarize(n())
# Count membership of group, NOT number of rows
# <SQL>
# SELECT `month`, COUNT() AS `n`
# FROM `nycflights13::flights`
# GROUP BY `month`

flights %>% 
    group_by(month) %>%
    tally() %>%
    show_query()

flights %>%
    count(month) %>%
    show_query()


# SELECT col1, col2 FROM table WHERE conditions;
# Example: SELECT name, choice FROM table WHERE name = 'David'

# <SQL>
# SELECT *
# FROM (SELECT `month`, `dep_time`
# FROM `nycflights13::flights`)
# WHERE (`month` = 1.0)
flights %>%
    select(month, dep_time) %>%
    filter(month==1) %>%
    show_query()

# SELECT c1,c2 FROM table
# WHERE conditions
# ORDER BY c1 ASC, c2 DESC

flights %>%
    filter(month==1) %>%
    select(month, dep_time) %>%
    arrange(month, desc(dep_time)) %>%
    show_query()



# <SQL>
# SELECT `month`, `sched_arr_time`
# FROM `nycflights13::flights`
# WHERE (`month` = 1.0 AND `sched_arr_time` > 1000.0)

flights %>%
    filter(month==1 & sched_arr_time > 1000) %>%
    select(month, sched_arr_time) %>%
    show_query()


# NOTE one advantage SQL > R
# in SQL, you can select one column, but filter conditionally from values in other columns
# in R, you'd need to select ALL columns you'd want to use - even for filtering

SELECT title FROM film
WHERE rental_rate > 4 AND replacement_cost >= 19.99
AND rating='R';


SELECT COUNT(*) FROM flights
WHERE month = 1 AND sched_arr_time > 1000;

flights %>%
    filter(month==1 & sched_arr_time > 1000) %>%
    select(month, sched_arr_time) %>%
    summarize(n()) %>%
    show_query()

SELECT COUNT(*) FROM film
WHERE rating='R' OR rating='PG-13';

flights %>%
    filter(arr_time < 900 | sched_arr_time < 900) %>%
    select(month, arr_time, sched_arr_time) %>%
    summarize(n()) %>%
    show_query()


flights %>%
    filter(arr_time > 900 & sched_arr_time < 500) %>%
    # select(arr_time, sched_arr_time) %>%
    summarize(n()) %>%
    show_query()


SELECT * FROM film
WHERE rating !='R';

flights %>%
    select(everything()) %>%
    filter(month != 1) %>%
    summarize(n()) %>%
    show_query()

# CHALLENGE SELECT WHERE
# What is the email for customer named Nancy Thomas

SELECT email FROM customer
WHERE first_name='Nancy' AND last_name='Thomas';

customer %>%
    select(email, first_name, last_name) %>%
    filter(first_name == 'Nancy' & last_name == 'Thomas')

flights %>%
    select(month, day, arr_time) %>%
    filter(month==2 & day==2) %>%
    show_query()

SELECT description FROM film
WHERE title = 'Outlaw Hanky';

film %>%
    select(title, description) %>%
    filter(title == "Outlaw Hanky")

airports %>%
    filter(name == 'Lansdowne Airport') %>%
    select(lat) %>%
    show_query()


SELECT phone FROM address
WHERE address = '259 Ipoh Drive';

# In dplyr use filter() before select() to get closest SELECT FROM WHERE results to SQL
# <SQL>
# SELECT `month`, `day`
# FROM `nycflights13::flights`
# WHERE (`sched_arr_time` = 1022.0)

flights %>%
    filter(sched_arr_time==1022) %>%
    select(month, day) %>%
    show_query()


SELECT * FROM customer
ORDER BY first_name DESC;

# <SQL>
# SELECT *
# FROM `nycflights13::airports`
# ORDER BY `tzone` DESC

airports %>%
    arrange(desc(tzone)) %>%
    show_query()

# ORDER BY TWO COLUMNS
SELECT store_id, first_name, last_name FROM customer
ORDER BY store_id DESC, first_name ASC;


# <SQL>
# SELECT `faa`, `name`, `lat`
# FROM `nycflights13::airports`
# ORDER BY `faa` DESC, `name`

airports %>%
    select(faa, name, lat) %>%
    arrange(desc(faa), name) %>%
    show_query()

# SELECT * FROM table ORDER BY col1 DESC LIMIT 5

# <SQL>
# SELECT *
# FROM `nycflights13::flights`
# ORDER BY `month` DESC, `day` DESC
# LIMIT 6

flights %>%
    arrange(desc(month), day) %>%
    head(n = 8) %>%
    show_query()



# SELECT * FROM table 
# WHERE col3 != 0.00 
# ORDER BY col1 DESC 
# LIMIT 5

# <SQL>
# SELECT *
# FROM `nycflights13::flights`
# WHERE (`month` != 1.0)
# ORDER BY `month`, `day` DESC
# LIMIT 6

flights %>%
    filter(month != 1) %>%
    arrange(month, desc(day)) %>%
    head() %>%
    show_query()

# SEE GENERAL LAYOUT OF TABLE
# <SQL>
# SELECT *
# FROM `nycflights13::flights`
# LIMIT 1

flights %>%
    head(n = 1) %>%
    show_query()

# CHALLENGE ORDER BY

SELECT customer_id FROM payment
WHERE amount > 0
ORDER BY payment_date
LIMIT 10

# <SQL>
# SELECT `name`
# FROM (SELECT *
# FROM (SELECT *
# FROM `nycflights13::airports`
# WHERE (`alt` > 2000.0))
# ORDER BY `faa` DESC)
# LIMIT 10

airports %>%
    filter(alt > 2000) %>%
    arrange(desc(faa)) %>%
    #select(name) %>%
    head(n=10) %>%
    show_query()

# BETWEEN Operator can use NOT and AND

SELECT * FROM payment
WHERE amount BETWEEN 8 AND 9

SELECT * FROM payment
WHERE amount NOT BETWEEN 8 AND 9

# includes Date and hour, mins
SELECT * FROM payment
WHERE payment_date BETWEEN '2007-02-01' AND '2007-02-15'

flights %>%
    #filter(month==2) %>%
    filter(day > 1 & day < 15) %>%
    #select(dep_time) %>%
    show_query()


# SELECT WHERE IN
SELECT * FROM customer
WHERE first_name IN ('John', 'Jake', 'Julie')

airports %>% 
    filter(tzone %in% c("America/New_York", "America/Los_Angeles")) %>% 
    show_query()

# SAME as...LIKE ILIKE 

SELECT * FROM customer
WHERE first_name LIKE 'J%';

# WHERE LIKE 'L%'
airports %>%
    collect() %>%
    filter(str_detect(name, "^L")) %>%


# COUNT
SELECT COUNT(*) FROM customer
WHERE first_name LIKE 'J%';

airports %>%
    collect() %>%
    filter(str_detect(name, "^L")) %>%
    summarize(n())

# ILIKE - case insentive
SELECT * FROM customer
WHERE first_name ILIKE '%er%' 

# Long Chain of CUSTOM LIKE
SELECT * FROM customer
WHERE first_name LIKE 'A%' AND last_name NOT LIKE 'B%'
ORDER BY last_name

airports %>%
    collect() %>%
    filter(str_detect(name, 'er'))

library(data.table)

airports %>%
    collect() %>%
    filter(name %like% 'ff')


# GENERAL CHALLENGE

# How many payment transactions were greater than $5.00 (n = 3618)

SELECT COUNT(amount) FROM payment
WHERE amount > 5;

# How many actors have a first name that starts with the letter P? (n = 5)

SELECT COUNT(first_name) FROM actor
WHERE first_name LIKE 'P%';

# How many unique districts are our customers from?

SELECT COUNT(DISTINCT(district)) FROM address;

# Retrieve list of names from those Distinct districts

SELECT DISTINCT(district) FROM address;

# How many filmes have a rating of R and a replacement cost between $5 and $15? (n = 52)

SELECT COUNT(*) FROM film
WHERE rating = 'R' AND replacement_cost BETWEEN 5 AND 15

# How many films have the word Truman somewhere in the title?

SELECT COUNT(title) FROM film
WHERE title LIKE '%Truman%'








# GROUP BY Statements ----

#### Aggregate Functions
- AVG() 
- ROUND(AVG())
- COUNT()
- MAX()
- MIN()
- SUM()

# SQL Aggregate Functions

# MIN
SELECT MIN(c1) FROM table
# MAX
SELECT MAX(c1) FROM table
# SUM
SELECT SUM(c1) FROM table
# COUNT
SELECT COUNT(c1) FROM table
# AVG (2 decimal)
SELECT ROUND(AVG(c1),2) FROM table

# R Equivalent of Aggregate Functions summarize()

# MIN
airports %>%
    summarize(min_lat = min(lat))
# MAX
airports %>%
    summarize(max_lat = max(lat))
# SUM
airports %>%
    summarize(sum_lat = sum(lat))
# COUNT (four alternatives)
airports %>%
    select(lat) %>%
    summarize(n())

airports %>%
    summarize(count_lat = count(lat))

airports %>%
    collect() %>%
    nrow()

airports %>% 
    collect() %>%
    view()

# AVG / MEAN
airports %>%
    summarize(mean_lat = mean(lat))
    
###### GROUP BY STATEMENTS

# SQL GROUP BY

SELECT c1 FROM table
GROUP BY c1

# SQL GROUP BY with SUM and ORDER BY

SELECT c1, SUM(c2) FROM table
GROUP BY c1 
ORDER BY SUM(c2)

# SQL GROUP BY with COUNT and ORDER BY

SELECT c1, COUNT(c2) FROM table
GROUP BY c1 
ORDER BY COUNT(c2)

# SQL GROUP BY TWO COLUMNS with SUM and ORDER BY
SELECT c1, c2, SUM(c3) FROM table
GROUP BY c2, c1
ORDER BY c1

# SQL GROUP BY DATE - require using DATE() function
# DATE() extracts date from Time Stamp
SELECT DATE(payment_date), SUM(amount) FROM payment
GROUP BY DATE(payment_date)
ORDER BY SUM(amount) DESC

# SQL GROUP BY CHALLENGE

# Which staff should get a bonus based on number of handled transactions
SELECT staff_id, COUNT(payment_date) FROM payment
GROUP BY staff_id

# What are the average replacement costs by film ratings?
SELECT rating, ROUND(AVG(replacement_cost),2) FROM film
GROUP BY rating

# What are the customer ids of the top 5 customers by total spend?
SELECT customer_id, SUM(amount) FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 5



# R GROUP BY

# subtle differences between distinct() AND group_by() w/ tally() AND count() w/ arrange()
airports %>%
    distinct(tzone)

airports %>%
    group_by(tzone) %>%
    tally(sort = TRUE)

airports %>%
    count(tzone) %>%
    arrange(desc(n))

# R GROUP BY with SUM and ORDER BY (arrange)
airports %>%
    group_by(tzone) %>%
    summarize(sum_alt = sum(alt)) %>%
    arrange(desc(sum_alt))

# R GROUP BY with COUNT and ORDER BY (arrange)
airports %>%
    group_by(tzone) %>%
    summarize(count_lat = count(lat), sum_lat = sum(lat)) %>%
    arrange(desc(sum_lat))

# R GROUP BY  TWO COLUMNS with SUM - - 
# key to mirroring ORDER BY in SQL is to use arrange()
# can arrange() by three columns here
flights %>%
    group_by(month, day) %>%
    summarize(sum_dep_time = sum(dep_time)) %>%
    arrange(sum_dep_time)

# TO group_by date in R, need lubridate package for 
# time stamp conversion to date / dttm 

###### SQL HAVING
## filter AFTER GROUP BY
## CANNOT use WHERE AFTER GROUP BY

SELECT rating, SUM(rental_rate) FROM film
GROUP BY rating
HAVING SUM(rental_rate) > 600


SELECT customer_id, SUM(amount) FROM payment
WHERE customer_id NOT IN (184, 87, 477)
GROUP BY customer_id
HAVING SUM(amount) > 100


SELECT store_id, COUNT(customer_id) FROM customer
GROUP BY store_id
HAVING COUNT(customer_id) > 300



# R Equivalent of HAVING
# You can use filter() for BOTH WHERE AND HAVING
# the only difference is filtering-as-HAVING has to come after summarize()
# where the new variable is created
flights %>%
    group_by(day) %>%
    filter(day < 10) %>%
    summarize(sum_dep_time = sum(dep_time)) %>%
    filter(sum_dep_time > 15000000)

# HAVING clause CHALLENGE

# Customers with 40 or more transaction count get platinum status,
# which customer_ids should get platinum status?
SELECT customer_id, COUNT(*) FROM payment
GROUP BY customer_id
HAVING COUNT(*) >= 40

# What customer_ids who have spent more than $100 in payment transactions
# with staff_id member 2?

SELECT customer_id, staff_id, SUM(amount) FROM payment
WHERE staff_id != 1
GROUP BY staff_id, customer_id
HAVING SUM(amount) > 100







# Assessment Test 1 ----

# 1. Return customer IDs for those who spent at least $110 with staff member ID 2
SELECT customer_id, staff_id, SUM(amount) FROM payment
WHERE staff_id != 1
GROUP BY staff_id, customer_id
HAVING SUM(amount) >= 110

# 2. How many films begin with the letter 'J' ?
SELECT COUNT(title) FROM film
WHERE title LIKE 'J%';

# 3. What customer has the highest customer ID number whose name starts with an 
# 'E' and has an address ID lower than 500?
SELECT first_name, last_name, customer_id, address_id FROM customer
WHERE first_name LIKE 'E%' AND address_id < 500
ORDER BY customer_id DESC
LIMIT 1


# JOINS ----

#### AS statement

# SQL
SELECT c1 AS c2 FROM table;

# R
flights %>%
    mutate(monthly = month) %>%
    select(monthly)

# SQL
SELECT SUM(c1) AS c2 FROM table

# R
flights %>%
    summarize(sum_day = sum(day))

## Alias can only be used in SELECT statements

# This Works
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100

# This DOES NOT work 
# (because Alias exists at very end, as data output, cannot filter w them)
SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING total_spent > 100

# This works
SELECT customer_id, amount AS new_name
FROM payment
WHERE amount > 2

# This does NOT work
# ALIAS does nOT work outside of SELECT
SELECT customer_id, amount AS new_name
FROM payment
WHERE new_name > 2

####### JOINS
## NOTE: The main reason for the different JOIN types 
## is to decide how to deal with information only present in ONE of the joined tables

## INNER JOIN (rows exist in BOTH Table A and Table B)
## INNER JOIN is symmetrical venn diagram
SELECT * FROM tableA
INNER JOIN tableB
ON tableA.col_match = tableB.col_match

tableA %>%
    inner_join(tableB, by = '.col_match')

SELECT payment_id, payment.customer_id, first_name 
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id

## FULL OUTER JOINS
SELET * FROM tableA 
FULL OUTER JOIN tableB 
ON tableA.col_match = tableB.col_match 

# New Privacy Law situation: 
# We don't want any customer_id for someone who has NOT made a payment
SELECT * FROM customer
FULL OUTER JOIN payment
ON customer.customer_id = payment.customer_id
WHERE customer.customer_id IS null 
OR payment.payment_id IS null

## LEFT JOIN / LEFT OUTER JOIN
## venn diagram no longer symmetrical
## ORDER MATERS!!
## NOT returning anything exclusive to Table B


## WHERE statement add for unique to Table A (NOT found in Table B)
SELECT * FROM TableA 
LEFT OUTER JOIN TableB 
ON TableA.col_match = TableB.col_match 
WHERE TableB.id IS null

## LEFT JOIN 
## note: title, inventory_id, store_id are unique, no need to specify table 
SELECT film.film_id, title, inventory_id, store_id FROM film
LEFT JOIN inventory ON
inventory.film_id = film.film_id
WHERE inventory.film_id IS null

## RIGHT JOIN
## essentially same as LEFT JOIN, but switch tables around
SELECT * FROM TableA    
RIGHT OUTER JOIN TableB   
ON TableA.col_match = TableB.col_match 

## WHERE statement add for exclusivity of Table B (NOT found in Table A)
SELECT * FROM TableA 
RIGHT OUTER JOIN TableB  
ON TableA.col_match = TableB.col_match  
WHERE TableA.id IS null 

## UNION --> rbind()

## JOIN Challenge Tasks

# What are the emails of customers who live in California?

# Join address and customer table
# Select district (from address) and email (from customer); both unique so no need to specify
# INNER JOIN address & customer (order doesn't matter, symmetrical)
# ON address.address_id = customer.address_id 
# filter WHERE district = 'California'
SELECT district, email FROM address
INNER JOIN customer 
ON address.address_id = customer.address_id 
WHERE district = 'California'

# Get a list of movies "Nick Wahlberg" has been in
SELECT title, first_name, last_name FROM film_actor
LEFT JOIN actor
ON actor.actor_id = film_actor.actor_id
INNER JOIN film
ON film.film_id = film_actor.film_id
WHERE first_name = 'Nick' AND last_name = 'Wahlberg'

# Can also do Two INNER JOINS or LEFT JOINS 
SELECT title, first_name, last_name FROM film_actor
INNER JOIN actor
ON actor.actor_id = film_actor.actor_id
INNER JOIN film
ON film.film_id = film_actor.film_id
WHERE first_name = 'Nick' AND last_name = 'Wahlberg'






# Advanced SQL ----

# Assessment Test 2 ----

# Creating Databases and Tables ----

# Assessment Test 3 ----

# Conditional Expressions and Procedures ----

# Extra: PostGreSQL with Python ----

# Bonus ----