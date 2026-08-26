SELECT sl.State, mp.Year, SUM(mp.Value) AS Total_Production
FROM state_lookup sl 
INNER JOIN milk_production mp 
ON sl.State_ANSI = mp.State_ANSI 
WHERE Period = 'YEAR'
GROUP BY 1,2
ORDER BY 1,2;