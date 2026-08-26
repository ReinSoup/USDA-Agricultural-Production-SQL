WITH Cheese AS (
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
WHERE Period = 'YEAR'
GROUP BY sl.State 
),
Milk AS (
SELECT sl.State,
SUM(
	CASE
		WHEN mp.Year = 2021 THEN  mp.Value
		ELSE 0
	END
	) AS Production_2021,
SUM(
	CASE
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
Cheese_Change AS (
SELECT State, Production_2021, Production_2022, Production_2022 - Production_2021 AS Cheese_Change
FROM Cheese
),
Milk_Change AS (
SELECT State, Production_2021, Production_2022, Production_2022 - Production_2021 AS Milk_Change
FROM Milk
)
SELECT cc.State, cc.Production_2021 AS Cheese_2021, cc.Production_2022 AS Cheese_2022, cc.Cheese_Change,
mc.Production_2021 AS Milk_2021, mc.Production_2022 AS Milk_2022, mc.Milk_Change,
CASE WHEN Cheese_Change > Milk_Change THEN 'Cheese'
	 WHEN Cheese_Change = Milk_Change THEN 'Equal'
	 WHEN Cheese_Change < Milk_Change THEN 'Milk'
	 END AS Larger_Change
FROM Cheese_Change cc
INNER JOIN Milk_Change mc
ON cc.State = mc.State 
ORDER BY CASE Larger_Change  
	WHEN 'Cheese' THEN 1
	WHEN 'Equal' THEN 2
	WHEN 'Milk' THEN 3
	END, 
	Cheese_Change DESC, Milk_Change DESC
	
--PREFERRING CTE'S AND JOINS OVER SUBQUERIES (Personal Choice, might change in the future)


