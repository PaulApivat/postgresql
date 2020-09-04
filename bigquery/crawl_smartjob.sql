-- Table: BigQuery > internalmongo > crawl_smartjob

-- Get distinct applicanttypename and count each category
SELECT DISTINCT(jobannounce.applicanttypename) AS name, COUNT(*) AS count_name
FROM `jobsbot-276604.internalmongo.crawl_smartjob` 
GROUP BY name
LIMIT 100

-- Get distinct jobfieldname and count each category
-- note: only 34 distinct jobfieldnames, most popular is sales/marketing
SELECT DISTINCT(jobannounce.jobfieldname) AS jobfieldname, COUNT(*) AS count_jobfieldname
FROM `jobsbot-276604.internalmongo.crawl_smartjob` 
GROUP BY jobfieldname 
ORDER BY count_jobfieldname DESC
LIMIT 100

-- Get distinct jobpositiontrans and count each category
-- note: misspelling and word; data needs cleanup
SELECT DISTINCT(jobannounce.jobpositiontrans) AS jobpositiontrans, COUNT(*) AS count_jobpositiontrans
FROM `jobsbot-276604.internalmongo.crawl_smartjob` 
GROUP BY jobpositiontrans 
ORDER BY count_jobpositiontrans DESC
LIMIT 400

-- Get distinct minimum wage and count each
SELECT DISTINCT(jobannounce.wage_min) AS wage_min, COUNT(*) AS count_wage_min
FROM `jobsbot-276604.internalmongo.crawl_smartjob` 
GROUP BY wage_min 
ORDER BY count_wage_min DESC
LIMIT 300

-- note change min_wage to numeric, but still cannot arrange
SELECT DISTINCT(jobannounce.wage_min) AS wage_min, COUNT(*) AS count_wage_min
FROM `jobsbot-276604.internalmongo.crawl_smartjob` 
GROUP BY wage_min 
ORDER BY safe_cast(wage_min AS NUMERIC) DESC
LIMIT 300

-- note: Change data type from string to numeric; tried getting rid of decimals
SELECT DISTINCT(jobannounce.wage_min) AS wage_min, 
        COUNT(*) AS count_wage_min
FROM `jobsbot-276604.internalmongo.crawl_smartjob` 
GROUP BY wage_min 
ORDER BY ROUND(safe_cast(wage_min AS NUMERIC)) DESC
LIMIT 300


-- Count Unique Job Descriptions
SELECT DISTINCT(jobannounce.jobdescription) AS job_desc, 
        COUNT(*) AS count_job_desc
FROM `jobsbot-276604.internalmongo.crawl_smartjob` 
GROUP BY job_desc
ORDER BY count_job_desc DESC
LIMIT 300

-- Got a basic WHERE clause to work
SELECT jobannounce.jobpositiontrans 
FROM `jobsbot-276604.internalmongo.crawl_smartjob` 
WHERE jobannounce.jobpositiontrans = 'Contractor'

-- Got WHERE column LIKE '%ผลิต'
-- n = 996 out 14700
SELECT jobannounce.jobpositiontrans 
FROM `jobsbot-276604.internalmongo.crawl_smartjob` 
WHERE jobannounce.jobpositiontrans LIKE '%ผลิต'