-- Calculate overall 30-day readmission rate

SELECT 
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
    2) AS readmit_30_rate_percent
FROM readmissions;
