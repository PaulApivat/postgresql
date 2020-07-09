
# Smartjob Fields can be broken into these large buckets:

- JobAnnounce, basic descriptions
*JobPosition (ie thai v eng; พนักงาน, วิศวกร, เจ้าหน้าที่, ช่าง)
- JobAnnounce Qualifications
*ComputerSkill

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