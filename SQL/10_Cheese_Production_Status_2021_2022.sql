WITH diff AS(
SELECT State,
SUM(CASE
	WHEN cp.Year = 2021 THEN cp.Value
	ELSE 0
END
) AS Production_2021,
SUM(CASE
	WHEN cp.Year = 2022 THEN cp.Value
	ELSE 0
END  
) AS Production_2022
FROM cheese_production cp 
INNER JOIN state_lookup sl 
ON cp.State_ANSI = sl.State_ANSI 
WHERE Period = 'YEAR'
GROUP BY State
),
Change AS (
SELECT State, Production_2021, Production_2022, Production_2022 - Production_2021 AS Change
FROM diff
)
SELECT  *,
CASE
	WHEN Change > 0 THEN 'Increased'
	WHEN Change = 0 THEN 'No Change'
	WHEN CHANGE < 0 THEN 'Decreased'
END AS Status
FROM Change
ORDER BY
CASE
	WHEN Change > 0 THEN 1
	WHEN CHANGE = 0 THEN 2
	WHEN CHANGE < 0 THEN 3
END,
Change DESC


