SELECT sl.State, cp.Year, SUM(cp.Value) AS Total_Production
FROM cheese_production cp
JOIN state_lookup sl
ON cp.State_ANSI = sl.State_ANSI
WHERE cp.Period = 'YEAR'
GROUP BY sl.State, cp.Year
ORDER BY sl.State, cp.Year;