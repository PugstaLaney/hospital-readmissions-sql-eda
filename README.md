Hospital Readmissions SQL EDA
Project Overview

This project performs SQL-driven exploratory data analysis on the UCI Diabetes 130-US Hospitals dataset to investigate drivers of 30-day hospital readmission risk.

The analysis focuses on cohort-based risk stratification using age, diagnosis complexity, and medication burden to identify high-risk patient segments.

The workflow demonstrates:

Structured SQL query design

Automated SQL execution pipeline (run_query.py)

Conditional aggregation and KPI computation

Cohort-level risk segmentation

Statistical testing (chi-square)

Heatmap-based visualization in Jupyter

Analytical Approach

The project follows a reproducible pipeline:

Raw diabetes dataset loaded into SQLite.

SQL queries generate:

Overall readmission rates

Age-stratified readmission rates

Multi-factor cohort segmentation

Cohorts defined by:

age

number_diagnoses (bucketed into Low / Med / High)

num_medications (bucketed into Low / Med / High)

Minimum cohort size threshold applied (HAVING COUNT(*) >= 50) to reduce noise from small samples.

Results visualized using pivot tables and heatmaps in Python.

Key Findings

Overall 30-day readmission rate: 11.16%

Age group 20–30 exhibited the highest proportional readmission rate among age buckets.

Clinical complexity (high diagnoses + high medication count) consistently ranked among the highest-risk cohorts across nearly all age groups.

Within high-complexity cohorts, younger patients demonstrated elevated readmission rates relative to older cohorts.

Chi-square testing confirmed a statistically significant association between age and readmission (p < 0.001).
