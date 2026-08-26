WITH difference AS (
SELECT sl.State,
SUM(
	CASE
		WHEN cp.Year = 2021 THEN cp.Value
		ELSE 0
	END
	) AS Production_2021,
SUM(
	CASE
	WHEN cp.Year = 2022 THEN cp.Value
		ELSE 0
	END
	) AS Production_2022
FROM cheese_production cp 
INNER JOIN state_lookup sl 
ON cp.State_ANSI = sl.State_ANSI 
WHERE cp.Period = 'YEAR'
GROUP BY sl.State
),
Change AS( SELECT State, Production_2021, Production_2022, Production_2022 - Production_2021 AS Change
FROM difference 
)
SELECT *
FROM Change 
WHERE Change < 0
ORDER BY Change 