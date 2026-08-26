WITH Milk AS (
    SELECT
        sl.State,
        SUM(mp.Value) AS Milk
    FROM milk_production mp
    INNER JOIN state_lookup sl
        ON mp.State_ANSI = sl.State_ANSI
    WHERE mp.Year = 2022
      AND mp.Period = 'YEAR'
    GROUP BY sl.State
),
Milk_Total AS (
    SELECT
        SUM(Value) AS Total_Milk
    FROM milk_production
    WHERE Year = 2022
      AND Period = 'YEAR'
),
Cheese AS (
    SELECT
        sl.State,
        SUM(cp.Value) AS Cheese
    FROM cheese_production cp
    INNER JOIN state_lookup sl
        ON cp.State_ANSI = sl.State_ANSI
    WHERE cp.Year = 2022
      AND cp.Period = 'YEAR'
    GROUP BY sl.State
),
Cheese_Total AS (
    SELECT
        SUM(Value) AS Total_Cheese
    FROM cheese_production
    WHERE Year = 2022
      AND Period = 'YEAR'
),
Yogurt AS (
    SELECT
        sl.State,
        SUM(yp.Value) AS Yogurt
    FROM yogurt_production yp
    INNER JOIN state_lookup sl
        ON yp.State_ANSI = sl.State_ANSI
    WHERE yp.Year = 2022
      AND yp.Period = 'YEAR'
    GROUP BY sl.State
),
Yogurt_Total AS (
    SELECT
        SUM(Value) AS Total_Yogurt
    FROM yogurt_production
    WHERE Year = 2022
      AND Period = 'YEAR'
),
Egg AS (
    SELECT
        sl.State,
        SUM(ep.Value) AS Egg
    FROM egg_production ep
    INNER JOIN state_lookup sl
        ON ep.State_ANSI = sl.State_ANSI
    WHERE ep.Year = 2022
      AND ep.Period = 'MARKETING YEAR'
    GROUP BY sl.State
),
Egg_Total AS (
    SELECT
        SUM(Value) AS Total_Egg
    FROM egg_production
    WHERE Year = 2022
      AND Period = 'MARKETING YEAR'
),
Honey AS (
    SELECT
        sl.State,
        SUM(hp.Value) AS Honey
    FROM honey_production hp
    INNER JOIN state_lookup sl
        ON hp.State_ANSI = sl.State_ANSI
    WHERE hp.Year = 2022
    GROUP BY sl.State
),
Honey_Total AS (
    SELECT
        SUM(Value) AS Total_Honey
    FROM honey_production
    WHERE Year = 2022
),
Coffee AS (
    SELECT
        sl.State,
        SUM(cfp.Value) AS Coffee
    FROM coffee_production cfp
    INNER JOIN state_lookup sl
        ON cfp.State_ANSI = sl.State_ANSI
    WHERE cfp.Year = 2022
    GROUP BY sl.State
),
Coffee_Total AS (
    SELECT
        SUM(Value) AS Total_Coffee
    FROM coffee_production
    WHERE Year = 2022
),
Shares AS (
    SELECT
        sl.State,
        m.Milk,
        m.Milk * 100.0 / mt.Total_Milk AS Milk_Share,
        c.Cheese,
        c.Cheese * 100.0 / ct.Total_Cheese AS Cheese_Share,
        y.Yogurt,
        y.Yogurt * 100.0 / yt.Total_Yogurt AS Yogurt_Share,
        e.Egg,
        e.Egg * 100.0 / et.Total_Egg AS Egg_Share,
        h.Honey,
        h.Honey * 100.0 / ht.Total_Honey AS Honey_Share,
        co.Coffee,
        co.Coffee * 100.0 / cot.Total_Coffee AS Coffee_Share
    FROM state_lookup sl
    LEFT JOIN Milk m
    ON sl.State = m.State
    CROSS JOIN Milk_Total mt
    LEFT JOIN Cheese c
    ON sl.State = c.State
    CROSS JOIN Cheese_Total ct
    LEFT JOIN Yogurt y
    ON sl.State = y.State
    CROSS JOIN Yogurt_Total yt
    LEFT JOIN Egg e
    ON sl.State = e.State
    CROSS JOIN Egg_Total et
    LEFT JOIN Honey h
    ON sl.State = h.State
    CROSS JOIN Honey_Total ht
    LEFT JOIN Coffee co
    ON sl.State = co.State
    CROSS JOIN Coffee_Total cot
)
SELECT
    State,
    Milk, Milk_Share,
    Cheese, Cheese_Share,
    Yogurt, Yogurt_Share,
    Egg, Egg_Share,
    Honey, Honey_Share,
    Coffee, Coffee_Share,
    CASE
	    WHEN Milk IS NULL
 		AND Cheese IS NULL
 		AND Yogurt IS NULL
 		AND Egg IS NULL
 		AND Honey IS NULL
 		AND Coffee IS NULL
		THEN 'No Data'
        WHEN COALESCE(Milk_Share, 0) >= COALESCE(Cheese_Share, 0)
         AND COALESCE(Milk_Share, 0) >= COALESCE(Yogurt_Share, 0)
         AND COALESCE(Milk_Share, 0) >= COALESCE(Egg_Share, 0)
         AND COALESCE(Milk_Share, 0) >= COALESCE(Honey_Share, 0)
         AND COALESCE(Milk_Share, 0) >= COALESCE(Coffee_Share, 0)
        THEN 'Milk'
        WHEN COALESCE(Cheese_Share, 0) >= COALESCE(Milk_Share, 0)
         AND COALESCE(Cheese_Share, 0) >= COALESCE(Yogurt_Share, 0)
         AND COALESCE(Cheese_Share, 0) >= COALESCE(Egg_Share, 0)
         AND COALESCE(Cheese_Share, 0) >= COALESCE(Honey_Share, 0)
         AND COALESCE(Cheese_Share, 0) >= COALESCE(Coffee_Share, 0)
        THEN 'Cheese'
        WHEN COALESCE(Yogurt_Share, 0) >= COALESCE(Milk_Share, 0)
         AND COALESCE(Yogurt_Share, 0) >= COALESCE(Cheese_Share, 0)
         AND COALESCE(Yogurt_Share, 0) >= COALESCE(Egg_Share, 0)
         AND COALESCE(Yogurt_Share, 0) >= COALESCE(Honey_Share, 0)
         AND COALESCE(Yogurt_Share, 0) >= COALESCE(Coffee_Share, 0)
        THEN 'Yogurt'
        WHEN COALESCE(Egg_Share, 0) >= COALESCE(Milk_Share, 0)
         AND COALESCE(Egg_Share, 0) >= COALESCE(Cheese_Share, 0)
         AND COALESCE(Egg_Share, 0) >= COALESCE(Yogurt_Share, 0)
         AND COALESCE(Egg_Share, 0) >= COALESCE(Honey_Share, 0)
         AND COALESCE(Egg_Share, 0) >= COALESCE(Coffee_Share, 0)
        THEN 'Egg'
        WHEN COALESCE(Honey_Share, 0) >= COALESCE(Milk_Share, 0)
         AND COALESCE(Honey_Share, 0) >= COALESCE(Cheese_Share, 0)
         AND COALESCE(Honey_Share, 0) >= COALESCE(Yogurt_Share, 0)
         AND COALESCE(Honey_Share, 0) >= COALESCE(Egg_Share, 0)
         AND COALESCE(Honey_Share, 0) >= COALESCE(Coffee_Share, 0)
        THEN 'Honey'
        WHEN COALESCE(Coffee_Share, 0) >= COALESCE(Milk_Share, 0)
         AND COALESCE(Coffee_Share, 0) >= COALESCE(Cheese_Share, 0)
         AND COALESCE(Coffee_Share, 0) >= COALESCE(Yogurt_Share, 0)
         AND COALESCE(Coffee_Share, 0) >= COALESCE(Egg_Share, 0)
         AND COALESCE(Coffee_Share, 0) >= COALESCE(Honey_Share, 0)
        THEN 'Coffee'
    END AS Dominant_Commodity
FROM Shares
ORDER BY
    CASE Dominant_Commodity
        WHEN 'Cheese' THEN 1
        WHEN 'Milk' THEN 2
        WHEN 'Yogurt' THEN 3
        WHEN 'Egg' THEN 4
        WHEN 'Honey' THEN 5
        WHEN 'Coffee' THEN 6
        WHEN 'No Data' THEN 7
    END;