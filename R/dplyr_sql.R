# SQL - basic select
SELECT c1,c2 FROM table

# R - basic select
table %>% 
      select(c1,c2)

# SQL - select on conditions and re-ordering
SELECT c1,c2 FROM table
WHERE conditions
ORDER BY c1 ASC, c2 DESC

# filter() before select() is the general pattern that most closely resembles SQL
# filter() parallels WHERE
# arrange() parallels ORDER BY
table %>%
     filter(conditions) %>%
     select(c1, c2) %>%
     arrange(c1, desc(c2)) 

# SQL - selecting distinct rows from column
SELECT DISTINCT(c1) FROM table

# R - also has a distinct function
table %>% 
     distinct(c1)

# SQL - counting distinct elements
SELECT COUNT(DISTINCT c1) FROM table

# R - summarize(n()) mirrors COUNT
table %>%
     distinct(c1) %>%
     summarize(n())

# SQL - count based on conditions
SELECT COUNT(*) FROM table
WHERE c1 < 900 AND c2 > 500

# R  - filters first, then count
table %>%
     filter(c1 < 900 & c2 > 500) %>%
     summarize(n())

# SQL - select from one column based on condition from another column
SELECT c2 FROM table
WHERE c1 = 'A Name';

# R - filter on one column, but select another column
table %>%
	  filter(c1 == 'A Name') %>%
      select(c2)

# SQL - Select all rows where c1 is ordered in descending order
SELECT * FROM table
ORDER BY c1 DESC

# R - arrange() parallels ORDER BY 
table %>%
	  arrange(desc(c1))


# SQL
SELECT * FROM table
ORDER BY c2 DESC, c1 ASC
LIMIT 12

# R - head() or tail() functions like LIMIT
table %>%
	arrange(desc(c2), c1) %>%
	head(n=12)

# SQL - select all rows where column contains (IN) certain names
SELECT * FROM table
WHERE c1 IN ('Peter', 'Paul', 'Mary')

# R - filter column that contains %in% certain names
table %>%
	filter(c1 %in% c('Peter', 'Paul', 'Mary')

# SQL select all rows from columns where string starts with P
SELECT * FROM table
WHERE c1 LIKE 'P%';
       
# R - filter str_detect words that start with P in a column
table %>%
     collect() %>%
     filter(str_detect(c1, "^P")) 
       

# SQL - return all rows where column c1 has strings containing 'ff'
SELECT * FROM table
WHERE c1 LIKE '%ff%'
           
# R - %like% comes from data.table package
library(data.table)
           
table %>%
     collect() %>%
     filter(name %like% 'ff')

###----------------###
# AGGREGATE FUNCTION #
###----------------###

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


# R Equivalent 

# MIN
table %>%
    summarize(min_c1 = min(c1))
# MAX
table %>%
    summarize(max_c1 = max(c1))
# SUM
table %>%
    summarize(sum_c1 = sum(c1))

# COUNT (and some alternatives)
table %>%
    select(c1) %>%
    summarize(n())

table %>%
    summarize(count_c1 = count(c1))


# AVG / MEAN
table %>%
    summarize(mean_c1 = mean(c1))

#----------#
# GROUP BY #
#----------#

# SQL GROUP BY
SELECT c1 FROM table
GROUP BY c1

# R equivalent
# note: not using select() actually yields more information here

table %>%
    group_by(c1) %>%
    tally(sort = TRUE) %>%
    select(c1)  			# this line: optional

# the count() is group_by() and tally() without sort = TRUE
table %>%
    count(c1)


# SQL GROUP BY with SUM and ORDER BY (descending order)
SELECT c1, SUM(c2) FROM table
GROUP BY c1 
ORDER BY SUM(c2) DESC


# R equivalent (descending) 
table %>%
    group_by(c1) %>%
    summarize(sum_c2 = sum(c2)) %>%
    arrange(desc(sum_c2))



# SQL GROUP BY TWO COLUMNS with SUM and ORDER BY
SELECT c1, c2, SUM(c3) FROM table
GROUP BY c2, c1
ORDER BY c1


# R equivalent
table %>%
    group_by(c1, c2) %>%
    summarize(sum_c3 = sum(c3)) %>%
    arrange(c1)


