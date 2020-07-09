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

# Aggregate Functions
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
    



# Assessment Test 1 ----

# JOINS ----

# Advanced SQL ----

# Assessment Test 2 ----

# Creating Databases and Tables ----

# Assessment Test 3 ----

# Conditional Expressions and Procedures ----

# Extra: PostGreSQL with Python ----

# Bonus ----