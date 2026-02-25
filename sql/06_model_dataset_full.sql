SELECT
    CASE WHEN readmitted = '<30' THEN 1 ELSE 0 END AS readmit_binary,
    age,
    gender,
    race,
    time_in_hospital,
    num_lab_procedures,
    num_procedures,
    num_medications,
    number_outpatient,
    number_emergency,
    number_inpatient,
    number_diagnoses,
    A1Cresult,
    max_glu_serum,
    insulin,
    change,
    diabetesMed,
    admission_type_id,
    discharge_disposition_id,
    admission_source_id
FROM readmissions
WHERE readmitted IN ('<30','>30','NO');
