
# Smartjob Fields can be broken into these large buckets:

- JobAnnounce, basic descriptions
*JobPosition (ie thai v eng; พนักงาน, วิศวกร, เจ้าหน้าที่, ช่าง)
- JobAnnounce Qualifications
*ComputerSkill
*CurriculumName
*
- JobAnnounce Condition
- JobAnnounce Interview

- Employer, basic descriptions
- Employer, logo
- Employer, company
- Employer

- Geo-coordinates: Lat, Lng, utm_x, utm_y, 

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




