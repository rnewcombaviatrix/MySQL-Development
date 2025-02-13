create view v_ReleaseWindows AS 
SELECT 
    `v_Releases`.`Type` AS `Type`,
    CAST(`v_Releases`.`PORdate` AS DATE) AS `creStart`,
    CAST(
        (LEAD(`v_Releases`.`PORdate`) 
         OVER (PARTITION BY `v_Releases`.`Type` ORDER BY `v_Releases`.`GAdate`) - INTERVAL 1 DAY
        ) AS DATE
    ) AS `creEnd`,
    CAST(
        LEAD(`v_Releases`.`GAdate`) 
        OVER (PARTITION BY `v_Releases`.`Type` ORDER BY `v_Releases`.`GAdate`) 
        AS DATE
    ) AS `ResolveEnd`
FROM `v_Releases` 
WHERE 
    `v_Releases`.`Type` = 'Controller' 
    AND `v_Releases`.`GAdate` >= '2025-01-24'

UNION 

SELECT 
    `v_Releases`.`Type` AS `Type`,
    CAST(COALESCE(`v_Releases`.`PORdate`, '2024-11-12') AS DATE) AS `creStart`,
    CAST(
        (LEAD(`v_Releases`.`PORdate`) 
         OVER (PARTITION BY `v_Releases`.`Type` ORDER BY `v_Releases`.`GAdate`) - INTERVAL 1 DAY
        ) AS DATE
    ) AS `creEnd`,
    CAST(
        LEAD(`v_Releases`.`GAdate`) 
        OVER (PARTITION BY `v_Releases`.`Type` ORDER BY `v_Releases`.`GAdate`) 
        AS DATE
    ) AS `ResolveEnd`
FROM `v_Releases` 
WHERE 
    `v_Releases`.`Type` = 'CoPilot' 
    AND `v_Releases`.`Release` <> '[Admiral Ackbar]';
