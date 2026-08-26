WITH diff AS (SELECT
sl.State,
SUM(CASE
	WHEN mp.Year = 2021 THEN mp.Value
	ELSE 0
	END
	) AS Production_2021,
SUM(CASE
	WHEN mp.Year = 2022 THEN  mp.Value
	ELSE 0
	END
	) AS Production_2022
FROM milk_production mp
INNER JOIN state_lookup sl 
ON mp.State_ANSI = sl.State_ANSI 
WHERE Period = 'YEAR'
GROUP BY sl.State
)
SELECT State, Production_2021, Production_2022, Production_2022 - Production_2021 AS Change
FROM diff;
 	

