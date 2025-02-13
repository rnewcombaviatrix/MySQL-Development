CREATE VIEW `v_Releases` AS 
WITH RECURSIVE cte1 AS (
    SELECT 
        jira.all_Issues.`Key`, 
        jira.all_Issues.Summary 
    FROM jira.all_Issues 
    WHERE jira.all_Issues.Key = 'AVX-49498'
), 
cte2 AS (
    SELECT 
        j.Key, 
        j.Parent_Key, 
        j.Summary, 
        j.target_end, 
        j.code_name, 
        j.desired_version 
    FROM jira.all_Issues j 
    JOIN cte1 c1 ON j.Parent_Key = c1.Key
), 
cte3 AS (
    SELECT 
        j.Key, 
        j.Parent_Key, 
        j.Summary, 
        j.target_end, 
        j.code_name, 
        j.desired_version 
    FROM jira.all_Issues j 
    JOIN cte2 c2 ON j.Parent_Key = c2.Key 
    WHERE j.Summary LIKE '%Milestone%'
), 
cte4 AS (
    SELECT 
        CASE 
            WHEN j.Summary LIKE '%CoPilot%' THEN j.desired_version 
            ELSE j.code_name 
        END AS `Release`, 
        j.Summary, 
        j.target_end, 
        j.code_name, 
        j.desired_version 
    FROM jira.all_Issues j 
    JOIN cte3 c3 ON j.Parent_Key = c3.Key 
    WHERE j.Summary LIKE '%POR%' OR j.Summary LIKE '%GA%'
) 
SELECT 
    CASE 
        WHEN cte4.`Release` LIKE '%CoPilot%' THEN 'CoPilot' 
        ELSE 'Controller' 
    END AS Type, 
    cte4.Release, 
    MAX(CASE WHEN cte4.Summary LIKE '%POR%' THEN cte4.target_end END) AS PORdate, 
    MAX(CASE WHEN cte4.Summary LIKE '%GA%' THEN cte4.target_end END) AS GAdate 
FROM cte4 
GROUP BY cte4.`Release`;
