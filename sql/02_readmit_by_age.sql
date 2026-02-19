-- Readmission rate by age group

SELECT 
    age,
    COUNT(*) AS total_patients,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*),
    2) AS readmit_rate_percent
FROM readmissions
GROUP BY age
ORDER BY age;
