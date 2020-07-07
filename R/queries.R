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
    count(month) %>%
    summarize(n()) %>%
    show_query()

# or

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

# <SQL>
# SELECT *
# FROM (SELECT `month`, `sched_arr_time`
# FROM `nycflights13::flights`)
# WHERE (`month` = 1.0 AND `sched_arr_time` > 1000.0)
flights %>%
    select(month, sched_arr_time) %>%
    filter(month==1 & sched_arr_time > 1000) %>%
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
    select(month, sched_arr_time) %>%
    filter(month==1 & sched_arr_time > 1000) %>%
    summarize(n()) %>%
    show_query()

SELECT COUNT(*) FROM film
WHERE rating='R' OR rating='PG-13';

flights %>%
    select(month, arr_time, sched_arr_time) %>%
    filter(arr_time < 900 | sched_arr_time < 900) %>%
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
    arrange(desc(month), desc(day)) %>%
    head() %>%
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



# GROUP BY Statements ----

# Assessment Test 1 ----

# JOINS ----

# Advanced SQL ----

# Assessment Test 2 ----

# Creating Databases and Tables ----

# Assessment Test 3 ----

# Conditional Expressions and Procedures ----

# Extra: PostGreSQL with Python ----

# Bonus ----