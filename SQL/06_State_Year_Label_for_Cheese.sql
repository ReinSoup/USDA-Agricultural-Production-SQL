SELECT CONCAT(sl.State, '-', cp.Year) AS State_Year, SUM(cp.Value) AS Total_Production
FROM cheese_production cp 
INNER JOIN state_lookup sl 
ON cp.State_ANSI = sl.State_ANSI 
WHERE Period = 'YEAR'
Group by sl.State, cp.Year
Order by sl.State, cp.Year