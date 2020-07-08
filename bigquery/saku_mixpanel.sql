# mixpanel_engage

SELECT * FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 

SELECT * FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` LIMIT 10

# How many unique key, id, name have engaged with jobsbot? (161)

SELECT COUNT(DISTINCT key) 
FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 

SELECT COUNT(DISTINCT id) 
FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 

SELECT COUNT(DISTINCT(name)) FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 

# How many male & female users engaged with jobsbot? (50 male, 110 female)

SELECT COUNT(gender) FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 
WHERE gender = 'male'

SELECT COUNT(gender) FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 
WHERE gender = 'female'

# How many people chose on optin_email? (0 true, 161 false)

SELECT COUNT(optin_email) FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 
WHERE optin_email = false

# How many people chose optin_phone? (0 true, 161 false)

SELECT COUNT(optin_phone) FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 
WHERE optin_phone = false

# How many distinct locale are represented in mixpanel_engage? (4)

SELECT COUNT(DISTINCT locale) FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 

# What are the four distinct locale ? (en_GB, en_US, th_TH, vi_VN)

SELECT DISTINCT(locale) FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 

# How many people from each locale? (22 en_GB, 39 en_US, 99 th_TH, 1 vi_VN)

SELECT COUNT(*) FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 
WHERE locale = 'en_GB'

# What are the distinct timezones of users who interact with jobbot? (UTC+07, UTC-05, UTC-07)
(UTC-05: East Coast, UTC-07: West Coast, UTC+07: Thailand)

SELECT DISTINCT timezone FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 

# How many users are from each timezone? 
UTC-05: East Coast 1
UTC-07: West Coast 1
UTC+07: Thailand 159


SELECT COUNT(*) FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 
WHERE timezone = 'UTC+07'

# When was the earliest last_seen with the jobsbot? (2020-05-24) (Poom Shetshotisak)

SELECT * FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 
ORDER BY last_seen ASC

# When was the latest last_seen with the jobsbot? (2020-07-06) (Anemone Fedora)

SELECT * FROM `jobsbot-276604.saku_mixpanel.mixpanel_engage` 
ORDER BY last_seen DESC




