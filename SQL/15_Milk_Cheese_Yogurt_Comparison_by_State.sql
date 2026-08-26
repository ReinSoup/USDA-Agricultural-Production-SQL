WITH Cheese_2022_SUM AS(
SELECT sl.State, SUM(cp.Value) AS Cheese_2022_SUM
FROM cheese_production cp 
INNER JOIN state_lookup sl 
ON cp.State_ANSI = sl.State_ANSI 
WHERE Year = 2022
AND Period = 'YEAR'
GROUP BY sl.State
),
Milk_2022_SUM AS(
SELECT sl.State, SUM(mp.Value) AS Milk_2022_SUM
FROM milk_production mp 
INNER JOIN state_lookup sl 
ON mp.State_ANSI = sl.State_ANSI 
WHERE Year = 2022
AND Period = 'YEAR'
GROUP BY sl.State
),
Yogurt_2022_SUM AS(
SELECT sl.State, SUM(yp.Value) AS Yogurt_2022_SUM
FROM yogurt_production yp 
LEFT JOIN state_lookup sl 
ON yp.State_ANSI = sl.State_ANSI 
WHERE Year = 2022 --YOGURT TABLE ONLY HAS 2 STATES IN 2022 not an error
AND Period = 'YEAR'
GROUP BY sl.State
)
SELECT c.State,c.Cheese_2022_SUM AS Cheese_Produced , m.Milk_2022_SUM AS Milk_Produced, y.Yogurt_2022_SUM AS Yogurt_Produced 
FROM Cheese_2022_SUM  c		--USING Cheese AS BASE TABLE
LEFT JOIN Milk_2022_SUM m
ON m.State = c.State 
LEFT JOIN Yogurt_2022_SUM y
on m.State = y.State
