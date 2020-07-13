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
    tally(sort = TRUE) %>%
    select(tzone) 

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

flights %>%
    group_by(month) %>%
    summarize(sum_dep_time = sum(dep_time)) %>%
    filter(month > 6)
    #filter(sum_dep_time > 38000000)


SELECT customer_id, SUM(amount) FROM payment
WHERE customer_id NOT IN (184, 87, 477)
GROUP BY customer_id
HAVING SUM(amount) > 100

flights %>%
    filter(!(month %in% c(5,7,9))) %>%
    group_by(month) %>%
    summarize(sum_dep_time = sum(dep_time)) %>%
    filter(sum_dep_time < 37000000)
    

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

# Time Information Data Types

# TIME - only time Hours, Minutes, Seconds
# DATE - only date Day, Month, year 
# TIMESTAMP - date and time 
# TIMESTAMPZ - date, time and timezone 

# SQL - show current timezone
SHOW TIMEZONE
# R - show current timezone
Sys.timezone()

# SQL - get timestamp and timezone for right NOW()
SELECT NOW() 
# R - show current timestamp
Sys.time()

# SQL - timestamp with date
SELECT TIMEOFDAY()

# SQL - current date
SELECT CURRENT_DATE
# R - date
Sys.Date()



### ------ EXTRACT(), AGE(), TO_CHAR() -------###

### R - equivalents ###
### LUBRIDATE in R to achieve similar results ###
# BORROW FROM bike_orderlines_tbl <- read_rds("../00_data/bike_sales/data_wrangled/bike_orderlines.rds")

borrow_bike_tbl <- read_rds("../../business_science/DS4B_101/00_data/bike_sales/data_wrangled/bike_orderlines.rds")

borrow_bike_tbl

library(lubridate)
# Extract YEAR from Timestamp

SELECT EXTRACT(YEAR FROM payment_date) AS myyear
FROM payment

borrow_bike_tbl %>%
    mutate(year_only = as.character(order_date) %>% ymd() %>% year()) %>% view()

# Extract MONTH from Timestamp

SELECT EXTRACT(MONTH FROM payment_date) AS pay_month
FROM payment

borrow_bike_tbl %>%
    mutate(month_only = as.character(order_date) %>% ymd() %>% month()) %>% view()

# Extract QUARTER from Timestamp

SELECT EXTRACT(QUARTER FROM payment_date) 
AS pay_quarter
FROM payment

borrow_bike_tbl %>%
    mutate(quarter_only = as.character(order_date) %>% ymd() %>% quarter()) %>% view()


# How OLD a timestamp is - AGE()

SELECT AGE(payment_date)
FROM payment

borrow_bike_tbl %>%
    mutate(date = as.character(order_date) %>% ymd()) %>% 
    mutate(age = as.period(interval(start = date, end = Sys.Date()))) %>% view()



###  TO_CHAR - convert timestamp to string
# convert timestamp to MONTH(full caps) and YYYY(four digit year)
# different formatting - consult SQL DOCUMENATION***

SELECT TO_CHAR(payment_date, 'MONTH-YYYY')
FROM payment


SELECT TO_CHAR(payment_date, 'MM/dd/YYYY')
FROM payment

SELECT TO_CHAR(payment_date, 'dd-MM-YYYY')
FROM payment

# TIMESTAMPS and EXTRACT - CHALLENGE TASKS

# During which months (unique) did payment occur?
SELECT DISTINCT(TO_CHAR(payment_date, 'MONTH'))
FROM payment

# Challenge in R
borrow_bike_tbl %>%
    mutate(month_format = as.character(order_date) %>% month(label = TRUE, abbr = FALSE)) %>% 
    count(month_format) %>% view()


# How many payments occurred on a Monday? 

# my solution - use GROUP BY
SELECT TO_CHAR(payment_date, 'DAY') AS payment_day, COUNT(*)
FROM payment
GROUP BY payment_day

# Challenge # 2 solution in R
borrow_bike_tbl %>%
    mutate(month_format = as.character(order_date) %>% month(label = TRUE, abbr = FALSE)) %>% 
    count(month_format)


borrow_bike_tbl %>%
    mutate(day_format = as.character(order_date) %>% day()) %>% 
    count(day_format)

# alternative solution DOW - 'day of week' (dow) - use GROUP BY

SELECT EXTRACT(DOW FROM payment_date) AS payment_day, COUNT(*) 
FROM payment
GROUP BY payment_day

# ideal course solution - use WHERE
SELECT COUNT(*) 
FROM payment
WHERE EXTRACT(DOW FROM payment_date) = 1

# MATHEMATICAL FUNCTIONS 

# Find proportion between two numbers (2 decimals)
SELECT ROUND(rental_rate/replacement_cost, 2) FROM film
# format as percentage
SELECT ROUND(rental_rate/replacement_cost, 2)*100 FROM film


# equivalent in R
borrow_bike_tbl %>%
    mutate(proportion_price = sprintf('%0.2f',price/total_price)) %>% view()

# turn proportion, two decimal, into percentage in R
borrow_bike_tbl %>%
    mutate(proportion_price = sprintf('%0.4f',(price/total_price)*100)) %>% view()


# SQL use multiplication operator (deposit)
SELECT 0.1 * replacement_cost AS deposit
FROM film

# equivalent in R
borrow_bike_tbl %>%
    mutate(deposit = total_price * 0.1) %>% view()

## STRING FUNCTIONS and OPERATORS

# concatenate strings very simple in SQL
SELECT first_name || last_name FROM customer
# add space
SELECT first_name || ' ' || last_name FROM customer
# upper case
SELECT upper(first_name) || ' ' || upper(last_name) AS full_name FROM customer




# paste() from base-R concatenates, no need sep = 
borrow_bike_tbl %>%
    mutate(concatenate_string = paste(frame_material, city)) %>% view()

# R concatenate string with custom separator
borrow_bike_tbl %>%
    mutate(concatenate_string = paste(frame_material, city, sep = "---")) %>% view()

# R concatenate strings and turn into UPPERCASE
borrow_bike_tbl %>%
    mutate(concatenate_string = paste(str_to_upper(frame_material), str_to_upper(city), sep = "---")) %>% view()

## Creating CUSTOM email in SQL
## note take first letter of first_name with left(first_name,1); '1' for first lettter, 2 for first two letters etc. 
## make all letter LOWER CASE
SELECT LOWER(left(first_name,1)) || LOWER(last_name) || '@gmail.com' 
AS custom_email
FROM customer

# nearly equivalent in R
# paste0 has no spacing, paste has automatic spacing. 
borrow_bike_tbl %>%
    mutate(concatenate_string = paste0(substring(str_to_lower(frame_material),1,1), str_to_lower(city), '@gmail.com')) %>% view()

## SubQuery and EXIST function (instead of doing two separate queries)
## Query on results of another Query - - use TWO SELECT statements

## Example: Query list of all students who scored better than average
## subquery, inside parentheses is done first
SELECT student,grade
FROM test_scores
WHERE grade > (SELECT AVG(grade) FROM test_scores)

## Another example:
SELECT student,grade
FROM test_scores
WHERE student IN (SELECT student FROM honor_rolls)

# Sub Query
SELECT title, rental_rate 
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film)

# R-equivalent Sub Query
borrow_bike_tbl %>%
    filter(total_price > mean(total_price)) %>%
    arrange(desc(total_price)) %>% view()

# JOIN ALONG WITH SUBQUERY
# SubQuery and IN operator
# step 1: create the subquery - select inventory.film_id, but inner_join rental & inventory ON inventory_id 
# to access film_id from inventory --> returns a list of film_id
# step 2: get title associated with each film_id from film, using the sub-query as a filtering condition
# step 3: order by film_id or title
SELECT film_id, title 
FROM film
WHERE film_id IN
(SELECT inventory.film_id 
    FROM rental
    INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
    WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30')
ORDER BY film_id

# EXIST operator
# Select all customers where  one payment amount is greater than 11
SELECT first_name, last_name
FROM customer AS c
WHERE EXISTS
(SELECT * FROM payment as p 
    WHERE p.customer_id = c.customer_id
    AND amount > 11)

## SELF JOIN
# a query which a table is joined to itself
# good for comparing values in a column within the same table? 
# looks same as standard join, but use the same table
# MUST use TWO alias for same table for self-join


# Example: Select all films with the same length
# my own rough solution
SELECT title, length 
FROM film
GROUP BY length, title
ORDER BY length DESC

# ideal solutio: need to join the SAME table
SELECT f1.title, f2.title, f1.length 
FROM film AS f1
INNER JOIN film AS f2 ON
f1.film_id != f2.film_id
AND f1.length = f2.length



# Assessment Test 2 ----

# Q1: How can you retrieve all the information from the cd.facilities table?
SELECT * FROM cd.facilities

# Q2: You want to print out a list of all of the facilities and their cost to members. 
# How would you retrieve a list of only facility names and costs?
SELECT name, membercost FROM cd.facilities

# Q3: How can you produce a list of facilities that charge a fee to members?
SELECT name, membercost 
FROM cd.facilities
WHERE membercost > 0

# Q4: How can you produce a list of facilities that charge a fee to members,
# and that fee is less than 1/50th of the monthly maintenance cost? 
# Return: facid, facility name, member cost and monthly maintenance
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0 AND membercost < (monthlymaintenance/50)

# Q5: Can you produce a list of all facilities with the word "Tennis" in their name?
SELECT *
    FROM cd.facilities
WHERE name LIKE '%Tennis%'

# Q6: Retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator. 
SELECT *
    FROM cd.facilities
WHERE name LIKE '%2%'

# Q7: How can you produce a list of members who joined after the start of September 2012?
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate BETWEEN '2012-09-01' AND '2012-09-27'

# Q8: How can you produce an ordered list of the first 10 surnames in the members table? 
# my solution (slightly problematic)
SELECT DISTINCT(surname) AS distinct_surname,  memid
FROM cd.members
ORDER BY distinct_surname

# better solution
SELECT DISTINCT(surname)
FROM cd.members
ORDER BY surname
LIMIT 10

# Q9: You'd like to get the signup date of your last member. How can you retrieve this information? 
SELECT joindate
FROM cd.members
ORDER BY joindate DESC
LIMIT 1

# Q10: Produce a count of the number of facilities that have a cost to guests of 10 or more
SELECT COUNT(guestcost)
FROM cd.facilities
WHERE guestcost >= 10

# Q11: Produce a list of total number of slots booked per facility in the month
# of September 2012 NOTE: see end date
SELECT SUM(slots), facid
FROM cd.bookings
WHERE starttime BETWEEN '2012-09-01' AND '2012-10-01'
GROUP BY facid
ORDER BY SUM(slots) ASC


# Q12 Produce a lit of facilities with more thatn 1000 slots booked 
# output: facility id, total slots, sorted by facility id
SELECT SUM(slots), facid
FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) > 1000
ORDER BY facid

## Q13 How can you produce a list of start times for bookings for tennis courts,
## for the date '2012-09-21'?

SELECT starttime, name FROM cd.facilities
INNER JOIN cd.bookings
ON cd.facilities.facid = cd.bookings.facid
WHERE TO_CHAR(starttime, 'YYYY-MM-dd') = '2012-09-21' AND name LIKE '%Tennis Court%'
ORDER BY starttime, name ASC 

## 014 How can you produce a list of the start times for bookings by members named 
## 'David Farrell' (34 rows)

SELECT starttime, firstname, surname FROM cd.facilities
INNER JOIN cd.bookings
ON cd.facilities.facid = cd.bookings.facid
INNER JOIN cd.members 
ON cd.members.memid = cd.bookings.memid
WHERE firstname = 'David' AND surname = 'Farrell'


# Creating Databases and Tables ----

# General Syntax to create tables in SQL -

CREATE TABLE table_name(
    column_name TYPE column_constraint,
    column_name TYPE column_constraint,
    table_constraint table_constraint
) INHERITS existing_table_name


# Instructions for Creating Database Table in POSTGRESQL
# PostgreSQL -> Databases -> create & name database (ie. learning)

# Creating first 'account' table in 'learning' database
CREATE TABLE account(
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(250) UNIQUE NOT NULL,
    created_on TIMESTAMP NOT NULL,
    last_login TIMESTAMP 
)

# create job table
CREATE TABLE job(
    job_id SERIAL PRIMARY KEY,
    job_name VARCHAR(200) UNIQUE NOT NULL
)

# create account_job table
# how to reference a foreign key
CREATE TABLE account_job(
    user_id INTEGER REFERENCES account(user_id),   # reference primary key in account table
    job_id INTEGER REFERENCES job(job_id),         # reference primary key in job table
    hire_date TIMESTAMP
)



# Assessment Test 3 ----

# Conditional Expressions and Procedures ----

# Extra: PostGreSQL with Python ----

# Bonus ----