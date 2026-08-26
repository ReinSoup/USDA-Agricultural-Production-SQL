SELECT sl.State, SUM(mp.Value) AS Total_Production
FROM milk_production mp 
INNER JOIN state_lookup sl 
ON mp.State_ANSI = sl.State_ANSI 
WHERE Period = 'YEAR'
GROUP BY sl.State
ORDER BY Total_Production DESC