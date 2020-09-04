-- Get distinct applicanttypename and count each category
SELECT DISTINCT(jobannounce.applicanttypename) AS name, COUNT(*) AS count_name
FROM `jobsbot-276604.internalmongo.crawl_smartjob` 
GROUP BY name
LIMIT 100

-- Get distinct jobfieldname and count each category
SELECT DISTINCT(jobannounce.jobfieldname) AS jobfieldname, COUNT(*) AS count_jobfieldname
FROM `jobsbot-276604.internalmongo.crawl_smartjob` 
GROUP BY jobfieldname 
ORDER BY count_jobfieldname DESC
LIMIT 100

