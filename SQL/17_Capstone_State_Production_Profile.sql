WITH Cheese AS(
SELECT sl.State, SUM(cp.Value) AS Cheese
FROM cheese_production cp 
INNER JOIN state_lookup sl 
ON cp.State_ANSI = sl.State_ANSI 
WHERE Year = 2022
AND Period = 'YEAR'
GROUP BY sl.State
),
Milk AS(
SELECT sl.State, SUM(mp.Value) AS Milk
FROM milk_production mp 
INNER JOIN state_lookup sl 
ON mp.State_ANSI = sl.State_ANSI 
WHERE Year = 2022
AND Period = 'YEAR'
GROUP BY sl.State
),
Yogurt AS(
SELECT sl.State, SUM(yp.Value) AS Yogurt
FROM yogurt_production yp 
LEFT JOIN state_lookup sl 
ON yp.State_ANSI = sl.State_ANSI 
WHERE Year = 2022 --YOGURT TABLE ONLY HAS 2 STATES IN 2022 not an error
AND Period = 'YEAR'
GROUP BY sl.State
),
Egg AS(
SELECT sl.State, SUM(ep.Value) AS Egg
FROM egg_production ep  
INNER JOIN state_lookup sl 
ON ep.State_ANSI = sl.State_ANSI 
WHERE Year = 2022
AND Period = 'MARKETING YEAR' -- instead of 'YEAR'
GROUP BY sl.State
),
Honey AS(
SELECT sl.State, SUM(hp.Value) AS Honey
FROM honey_production hp 
LEFT JOIN state_lookup sl 
ON hp.State_ANSI = sl.State_ANSI 
WHERE Year = 2022 --no period column in honey
GROUP BY sl.State
),
Coffee AS(
SELECT sl.State, SUM(cfp.Value) AS Coffee
FROM coffee_production cfp 
INNER JOIN state_lookup sl 
ON cfp.State_ANSI = sl.State_ANSI 
WHERE Year = 2022 --no need of period as the only period availible is 'YEAR'
GROUP BY sl.State
)
SELECT
    sl.State,
    m.Milk,
    c.Cheese,
    y.Yogurt,
    e.Egg,
    h.Honey,
    co.Coffee,
    CASE 
	    WHEN Milk IS NULL
 		AND Cheese IS NULL
 		AND Yogurt IS NULL
 		AND Egg IS NULL
 		AND Honey IS NULL
 		AND Coffee IS NULL
		THEN 'No Data'
    	WHEN COALESCE(Milk, 0) >= COALESCE(Cheese, 0)
    	AND  COALESCE(Milk, 0) >= COALESCE(Yogurt, 0)
    	AND	 COALESCE(Milk, 0) >= COALESCE(Egg, 0)
    	AND  COALESCE(Milk, 0) >= COALESCE(Honey, 0)
    	AND  COALESCE(Milk, 0) >= COALESCE(Coffee, 0)
    	THEN 'Milk'
    	WHEN COALESCE(Cheese, 0) >= COALESCE(Milk, 0)
    	AND  COALESCE(Cheese, 0) >= COALESCE(Yogurt, 0)
    	AND	 COALESCE(Cheese, 0) >= COALESCE(Egg, 0)
    	AND  COALESCE(Cheese, 0) >= COALESCE(Honey, 0)
    	AND  COALESCE(Cheese, 0) >= COALESCE(Coffee, 0)
    	THEN 'Cheese'
    	WHEN COALESCE(Yogurt, 0) >= COALESCE(Cheese, 0)
    	AND  COALESCE(Yogurt, 0) >= COALESCE(Milk, 0)
    	AND	 COALESCE(Yogurt, 0) >= COALESCE(Egg, 0)
    	AND  COALESCE(Yogurt, 0) >= COALESCE(Honey, 0)
    	AND  COALESCE(Yogurt, 0) >= COALESCE(Coffee, 0)
    	THEN 'Yogurt'
    	WHEN COALESCE(Egg, 0) >= COALESCE(Cheese, 0)
    	AND  COALESCE(Egg, 0) >= COALESCE(Yogurt, 0)
    	AND	 COALESCE(Egg, 0) >= COALESCE(Milk, 0)
    	AND  COALESCE(Egg, 0) >= COALESCE(Honey, 0)
    	AND  COALESCE(Egg, 0) >= COALESCE(Coffee, 0)
    	THEN 'Egg'
    	WHEN COALESCE(Honey, 0) >= COALESCE(Cheese, 0)
    	AND  COALESCE(Honey, 0) >= COALESCE(Yogurt, 0)
    	AND	 COALESCE(Honey, 0) >= COALESCE(Egg, 0)
    	AND  COALESCE(Honey, 0) >= COALESCE(Milk, 0)
    	AND  COALESCE(Honey, 0) >= COALESCE(Coffee, 0)
    	THEN 'Honey'
    	WHEN COALESCE(Coffee, 0) >= COALESCE(Cheese, 0)
    	AND  COALESCE(Coffee, 0) >= COALESCE(Yogurt, 0)
    	AND	 COALESCE(Coffee, 0) >= COALESCE(Egg, 0)
    	AND  COALESCE(Coffee, 0) >= COALESCE(Honey, 0)
    	AND  COALESCE(Coffee, 0) >= COALESCE(Milk, 0)
    	THEN 'Coffee'
    END AS Dominant_Commodity
FROM state_lookup sl --base table as we need one record for each state
LEFT JOIN Milk m
    ON sl.State = m.State
LEFT JOIN Cheese c
    ON sl.State = c.State
LEFT JOIN Yogurt y
    ON sl.State = y.State
LEFT JOIN Egg e
    ON sl.State = e.State
LEFT JOIN Honey h
    ON sl.State = h.State
LEFT JOIN Coffee co -- has no records in 2022 so keep as last column
    ON sl.State = co.State
ORDER BY CASE Dominant_Commodity
	WHEN 'Cheese' THEN 1
	WHEN 'Milk' THEN 2
	WHEN 'Yogurt' THEN 3
	WHEN 'Egg' THEN 4
	WHEN 'Honey' THEN 5
	WHEN 'Coffee' THEN 6
	WHEN 'No Data'THEN 7
	END