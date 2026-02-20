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
    COUNT(*) AS total_patients
FROM readmissions
GROUP BY age, dx_bucket, med_bucket
ORDER BY total_patients DESC
LIMIT 20;
