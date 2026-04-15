select * from projects;

-- 6(a) total amount raised for successful projects
SELECT SUM(pledged) AS total_amount_raised 
FROM projects 
WHERE state = 'successful';

-- 6(b)total no of backers for successful projects
SELECT SUM(backers_count) AS total_backers 
FROM projects 
WHERE state = 'successful';

-- 6(c) avg no of days for successful projects
SELECT AVG(DATEDIFF(FROM_UNIXTIME(successful_at), FROM_UNIXTIME(launched_at))) AS avg_days_successful_projects
FROM projects
WHERE state = 'successful';

-- 7(a)top successful projects based on backers
SELECT name, 
		backers_count, 
		usd_pledged, 
		category_id
FROM projects 
WHERE state = 'successful' 
ORDER BY backers_count DESC 
LIMIT 10;


-- 7(b)top successful projects based on amount raised
SELECT 
    name, 
    usd_pledged, 
    backers_count, 
    category_id
FROM projects 
WHERE state = 'successful' 
ORDER BY usd_pledged DESC 
LIMIT 10;

-- 8(a)Percentage of Successful Projects overall
SELECT (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) / COUNT(*) * 100) AS overall_success_rate_percentage
FROM projects;

-- 8(b)Percentage of Successful Projects  by Category
SELECT 
    category_id, 
    COUNT(*) AS total_projects,
    (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) / COUNT(*) * 100) AS success_rate_percentage
FROM projects
GROUP BY category_id
ORDER BY success_rate_percentage DESC;

-- 8(c)Percentage of Successful Projects by year
SELECT 
    YEAR(FROM_UNIXTIME(created_at)) AS project_year,
    COUNT(*) AS total_projects,
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
    (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) / COUNT(*) * 100) AS success_rate_percentage
FROM projects
GROUP BY project_year
ORDER BY project_year DESC;

-- 8(c)Percentage of Successful Projects by month
SELECT 
    monthname(FROM_UNIXTIME(created_at)) AS project_month,
    COUNT(*) AS total_projects,
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
    (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) / COUNT(*) * 100) AS success_rate_percentage
FROM projects
GROUP BY project_month
ORDER BY project_month DESC;

--  8(d)Percentage of Successful Projects  by goal range
SELECT
    ProjectID,
    usd_pledged,
    goal,
    CASE 
    WHEN goal < 5000 THEN 'Below 5k'
    ELSE '5k or more' 
    END AS goal_range_category
FROM projects;

SELECT 
    CASE 
	WHEN goal < 5000 THEN '< 5k'
	WHEN goal BETWEEN 5000 AND 10000 THEN '5k - 10k'
    when goal > 10000 then '> 10k'
   END AS goal_range,
    (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) / COUNT(*) * 100) AS success_rate_percentage
FROM projects
GROUP BY goal_range;