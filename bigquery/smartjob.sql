
# Smartjob Fields can be broken into these large buckets:

- JobAnnounce, basic descriptions
*EmployerName (ไทยรวมสินพัฒนาอุตสาหกรรม, บริษัท ซันเมอรี่)
*JobPosition (ie thai v eng; พนักงาน, วิศวกร, เจ้าหน้าที่, ช่าง)

- JobAnnounce Qualifications
*ComputerSkill (Office, Excel, PPT)
*CurriculumName (Acct, Electric, Motor, Marketing)
*DegreeName (Bach, 9th, ม.ศ.3)



- JobAnnounce Condition
- JobAnnounce Interview

- Employer, basic descriptions
- Employer, logo
- Employer, company
- Employer

- Geo-coordinates: Lat, Lng, utm_x, utm_y, 

#############################################################
######          JobAnnounce, basic descriptions        ######
#############################################################

# What are the top 10 companies that had the most JobAnnouncement? 

SELECT DISTINCT( JobAnnounce_EmployerName ) AS empname, COUNT(*) AS num 
FROM `jobsbot-276604.jobsbot.smartjob` 
GROUP BY empname
ORDER BY num DESC
LIMIT 1000 

# What are the top 5 Provinces in terms of JobAnnoucement location?

SELECT DISTINCT( JobAnnounce_ProvinceName ) AS provincename, COUNT(*) AS num 
FROM `jobsbot-276604.jobsbot.smartjob` 
GROUP BY provincename
ORDER BY num DESC
LIMIT 1000 

# What are the SalaryRequirementUnitName in the job postings? (total out of 6428)

SELECT DISTINCT( JobAnnounce_SalaryRequireUnitName ) AS salaryreq, COUNT(*) AS num 
FROM `jobsbot-276604.jobsbot.smartjob` 
GROUP BY salaryreq
ORDER BY num DESC
LIMIT 1000 

# What are the JobAnnoucement_TypeName in the job postings? (out of 6428)

SELECT DISTINCT( JobAnnounce_TypeName ) AS typename, COUNT(*) AS num 
FROM `jobsbot-276604.jobsbot.smartjob` 
GROUP BY typename
ORDER BY num DESC
LIMIT 1000 

# What are the top 5 JobAnnounce_JobPosition in the postings? (out of 6428)

SELECT DISTINCT( JobAnnounce_JobPosition ) AS jobposition, COUNT(*) AS num 
FROM `jobsbot-276604.jobsbot.smartjob` 
GROUP BY jobposition
ORDER BY num DESC
LIMIT 1000 


# What are the top 5 JobAnnounce_JobDescription in the postings? (out of 6428)

SELECT DISTINCT( JobAnnounce_JobDescription ) AS jobdesc, COUNT(*) AS num 
FROM `jobsbot-276604.jobsbot.smartjob` 
GROUP BY jobdesc
ORDER BY num DESC
LIMIT 1000 

# What are the top 5 JobAnnounce_JobFieldID in the postings? (out of 6428)
# Need data dictionary for FieldID codes 

SELECT DISTINCT( JobAnnounce_JobFieldID ) AS jfieldid, COUNT(*) AS num 
FROM `jobsbot-276604.jobsbot.smartjob` 
GROUP BY jfieldid
ORDER BY num DESC
LIMIT 1000 

# What are the top 5 JobAnnounce_Wage_Min (wage-minumum) rates posted? 

SELECT DISTINCT( JobAnnounce_Wage_Min ) AS wagemin, COUNT(*) AS num 
FROM `jobsbot-276604.jobsbot.smartjob` 
GROUP BY wagemin
ORDER BY num DESC
LIMIT 1000 




# Count of distinct degree requirements
# DISTINT(JobAnnounce_Qualification_DegreeName)

1	ป.ตรี               1177
2	ม.3, ม.ศ.3          1156
3	ป.4, ป.6, ป.7       996
4	ปวช., ปวท.          989
5	ปวส., ปทส.          851
6	ม.6, ม.ศ.5          634
7	ต่ำกว่าประถม            587
8	อนุปริญญา               36
9	ป.โท                  2



SELECT DISTINCT(JobAnnounce_Qualification_DegreeName) AS distinct_degree, COUNT(*) AS num 
FROM `jobsbot-276604.jobsbot.smartjob` 
GROUP BY distinct_degree 
ORDER BY num DESC
LIMIT 1000



1   null 5616
2	ไม่จำกัดวุฒิ 247
3	การบัญชี 91
4	ไฟฟ้ากำลัง 75
5	ยานยนต์ 30
6	การตลาด 17
7	เครื่องกลอุตสาหกรรม 15

SELECT DISTINCT(JobAnnounce_Qualification_CurriculumName) AS curriculum, COUNT(*) AS num 
FROM `jobsbot-276604.jobsbot.smartjob` 
GROUP BY curriculum 
ORDER BY num DESC
LIMIT 1000 

# How many JobAnnounce_Qualification_ComputerSkill is not null? 319 rows (out of 6428)

SELECT JobAnnounce_Qualification_ComputerSkill
FROM `jobsbot-276604.jobsbot.smartjob` 
WHERE JobAnnounce_Qualification_ComputerSkill is not null
LIMIT 1000 



# How many JobAnnouncement_Qualification_ComputerSkill contains "microsoft office"? 73

SELECT JobAnnounce_Qualification_ComputerSkill 
FROM `jobsbot-276604.jobsbot.smartjob` 
WHERE UPPER(JobAnnounce_Qualification_ComputerSkill) LIKE UPPER('%Microsoft Office%')
LIMIT 1000 

# How many JobAnnounce_Qualification_ComputerSkill contain "excel"? 90 
# contains: "word"? 78 "power point" 9, "powerpoint" 20, "SAP" 3, "คอม" 70 (no surprise), "พื้นฐาน" (basic) 57

SELECT JobAnnounce_Qualification_ComputerSkill 
FROM `jobsbot-276604.jobsbot.smartjob` 
WHERE UPPER(JobAnnounce_Qualification_ComputerSkill) LIKE UPPER('%Excel%')
LIMIT 1000 


# Explore JOB descriptions

SELECT DISTINCT( JobAnnounce_JobDescription ) AS jd, COUNT(*) AS num 
FROM `jobsbot-276604.jobsbot.smartjob` 
GROUP BY jd  
ORDER BY num DESC
LIMIT 1000




