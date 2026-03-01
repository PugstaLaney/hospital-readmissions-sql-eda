# Hospital Readmissions SQL EDA

## Project Overview

This project performs SQL-driven exploratory data analysis on the **UCI Diabetes 130-US Hospitals dataset** to investigate drivers of 30-day hospital readmission risk.

The analysis focuses on cohort-based risk stratification using age, diagnosis complexity, and medication burden to identify high-risk patient segments.

The workflow demonstrates:

- Structured SQL query design  
- Automated SQL execution pipeline (`run_query.py`)  
- Conditional aggregation and KPI computation  
- Cohort-level risk segmentation  
- Statistical testing (chi-square)  
- Heatmap-based visualization in Jupyter  

---

## Analytical Approach

The project follows a reproducible pipeline:

1. Raw diabetes dataset loaded into SQLite.  
2. SQL queries generate:
   - Overall readmission rates  
   - Age-stratified readmission rates  
   - Multi-factor cohort segmentation  
3. Cohorts defined by:
   - `age`
   - `number_diagnoses` (bucketed into Low / Med / High)
   - `num_medications` (bucketed into Low / Med / High)
4. Minimum cohort size threshold applied (`HAVING COUNT(*) >= 50`) to reduce noise from small samples.  
5. Results visualized using pivot tables and heatmaps in Python.

---

## Key Findings

- Overall 30-day readmission rate: **11.16%**
- Age group **20–30** exhibited the highest proportional readmission rate among age buckets.
- Clinical complexity (high diagnoses + high medication count) consistently ranked among the highest-risk cohorts across nearly all age groups.
- Within high-complexity cohorts, younger patients demonstrated elevated readmission rates relative to older cohorts.
- Chi-square testing confirmed a statistically significant association between age and readmission (p < 0.001).

---

## Example Cohort Insight

**Top high-risk segment identified:**

- Age: 20–30  
- Diagnosis Burden: High  
- Medication Burden: High  
- Readmission Rate: **19.69%**

This suggests that medical complexity is a stronger predictor of readmission than age alone, with age acting as a modifier within high-complexity populations.

---

## Predictive Modeling

Following SQL-based cohort segmentation, patient-level predictive models were developed using the expanded administrative feature set.

### Baseline Cohort-Bucket Model
Features:
- `age`
- Diagnosis burden bucket
- Medication burden bucket

Performance:
- ROC AUC: **0.56**

This demonstrated limited discrimination when using coarse cohort-level features alone.

---

### Expanded Administrative Feature Model (Logistic Regression)

Features included:
- Utilization metrics (hospital stay length, prior inpatient/emergency visits)
- Lab summaries (A1C, glucose)
- Medication indicators
- Administrative admission/discharge codes
- Demographics

Performance:
- ROC AUC: **0.67**
- PR AUC: **0.22**
- Top 10% highest-risk group: **26.9% readmission rate**  
  (vs. 11.2% overall baseline)

This indicates meaningful enrichment in the highest-risk segment and demonstrates that granular utilization and treatment features substantially improve discrimination.

---

### Random Forest Comparison

A nonlinear Random Forest model was trained to evaluate whether interaction effects or nonlinear thresholds improved performance.

Performance:
- ROC AUC: **0.65**
- PR AUC: **0.21**

The tree-based model did not outperform logistic regression, suggesting that readmission risk in this dataset is largely additive rather than strongly nonlinear.

This highlights the importance of empirical model comparison rather than assuming increased complexity yields better results.

---

## Model Calibration & Probability Reliability

Although logistic regression demonstrated strong discrimination (AUC ≈ 0.67), calibration analysis revealed systematic overconfidence in predicted probabilities.

Uncalibrated Model:
- Brier Score: **0.226**
- Calibration curve showed predicted risks consistently exceeded observed frequencies.

Post-Hoc Calibration Applied:
- Sigmoid (Platt scaling)
- Isotonic regression

Calibrated Model:
- Brier Score improved to ≈ **0.095**
- ROC AUC remained unchanged
- Calibration curve closely aligned with diagonal

This demonstrates the distinction between:

- **Discrimination** (ranking ability)
- **Calibration** (probability accuracy)

For operational deployment in healthcare settings, calibrated probabilities are preferred to support threshold selection and resource allocation decisions.

The final model preserves discrimination while producing reliable risk estimates suitable for real-world use.