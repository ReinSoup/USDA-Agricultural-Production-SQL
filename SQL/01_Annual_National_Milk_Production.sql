SELECT mp.Year, SUM(mp.Value)
FROM milk_production mp 
WHERE Period = 'YEAR'
GROUP BY mp.Year  
ORDER BY mp.Year;