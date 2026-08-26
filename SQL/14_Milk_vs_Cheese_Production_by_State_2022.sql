WITH Cheese AS (
SELECT sl.State, SUM(cp.Value) AS Total_Cheese_Production
FROM cheese_production cp
INNER JOIN state_lookup sl 
ON cp.State_ANSI = sl.State_ANSI 
WHERE cp.Period = 'YEAR'
AND cp.Year = 2022
GROUP BY sl.State
),
Milk AS(
SELECT sl.State, SUM(mp.Value) AS Total_Milk_Production
FROM Milk_production mp
INNER JOIN state_lookup sl
ON sl.State_ANSI = mp.State_ANSI 
WHERE mp.Period = 'YEAR'
AND mp.Year = 2022
GROUP BY 1
)
SELECT m.State, m.Total_Milk_Production, c.Total_Cheese_Production, m.Total_Milk_Production - c.Total_Cheese_Production AS Difference,
CASE
	WHEN c.Total_Cheese_Production > m.Total_Milk_Production THEN 'Cheese'
	WHEN c.Total_Cheese_Production = m.Total_Milk_Production THEN 'Equal'
	WHEN c.Total_cheese_production < m.Total_Milk_Production THEN 'Milk'
END AS Higher_Producton
FROM Cheese c
INNER JOIN Milk m 
ON c.State = m.State 
ORDER BY 3 DESC

