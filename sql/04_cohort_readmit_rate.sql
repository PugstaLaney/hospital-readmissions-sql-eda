SELECT
    age,
    CASE
        WHEN number_diagnoses <= 3 THEN 'Low Dx'
        WHEN number_diagnoses <= 6 THEN 'Med Dx'
        ELSE 'High Dx'
    END AS dx_bucket,
    CASE
        WHEN num_medications <= 10 THEN 'Low Meds'
        WHEN num_medications <= 20 THEN 'Med Meds'
        ELSE 'High Meds'
    END AS med_bucket,

    COUNT(*) AS total_patients,
    SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) AS readmit_30,
    ROUND(
        SUM(CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS readmit_30_rate_percent

FROM readmissions
GROUP BY age, dx_bucket, med_bucket
HAVING COUNT(*) >= 50
ORDER BY readmit_30_rate_percent DESC
LIMIT 25;
