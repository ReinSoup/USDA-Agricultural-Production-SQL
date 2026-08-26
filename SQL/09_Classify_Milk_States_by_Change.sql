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
),
bystate AS(
SELECT State, Production_2021, Production_2022, Production_2022 - Production_2021 AS Change
FROM diff
)
SELECT *,
CASE
	WHEN Change > 0 THEN 'Increased' 
	WHEN Change < 0 THEN 'Decreased'
	ELSE 'No change' -- acts as = 0 value
END AS Production_Status
FROM bystate
ORDER BY CASE
	WHEN Change > 0 THEN 1 -- 1, 2, 3 are priorities for order by
	WHEN Change = 0 THEN 2
	WHEN Change < 0 THEN 3
END,
Change DESC
