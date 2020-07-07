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