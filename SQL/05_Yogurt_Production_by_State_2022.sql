SELECT
    sl.State,
    SUM(yp.Value) AS Yogurt_Production
FROM yogurt_production yp
JOIN state_lookup sl
    ON yp.State_ANSI = sl.State_ANSI
WHERE yp.Year = 2022
  AND yp.Period = 'YEAR'
GROUP BY sl.State
ORDER BY Yogurt_Production DESC;