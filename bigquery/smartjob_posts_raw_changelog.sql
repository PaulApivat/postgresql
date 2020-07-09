# What operations are done in this table?
CREATE
DELETE 


# How many of those operations were executed? 
CREATE: 1
DELETE: 6325

SELECT operation, COUNT(*)
FROM `jobsbot-276604.jobsbot.smartjob_posts_raw_changelog` 
GROUP BY operation
LIMIT 1000

# Description: This table stores smartjob - CHANGELOG - events to and from smartjob database


# How many distinct event_ids are there? 6326

SELECT COUNT(DISTINCT(event_id)) FROM `jobsbot-276604.jobsbot.smartjob_posts_raw_changelog` 
LIMIT 1000

# How many distinct document_name are there 6325

SELECT COUNT(DISTINCT(document_name))
FROM `jobsbot-276604.jobsbot.smartjob_posts_raw_changelog` 
LIMIT 10



# Earliest timestamp 2020-05-17

SELECT timestamp 
FROM `jobsbot-276604.jobsbot.smartjob_posts_raw_changelog` 
ORDER BY timestamp ASC
LIMIT 10

# Latest timestamp 2020-05-24

SELECT timestamp 
FROM `jobsbot-276604.jobsbot.smartjob_posts_raw_changelog` 
ORDER BY timestamp DESC
LIMIT 10

