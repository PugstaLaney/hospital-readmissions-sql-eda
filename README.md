# Hospital Readmissions SQL EDA

## Project Overview

This project performs SQL-driven exploratory data analysis and predictive modeling on the **UCI Diabetes 130-US Hospitals dataset** to investigate drivers of **30-day hospital readmission risk**.

The analysis begins with SQL-based cohort segmentation and progresses to patient-level predictive modeling using logistic regression and tree-based models.

The project demonstrates an end-to-end analytics workflow combining:

- SQL-based exploratory analysis
- cohort risk segmentation
- statistical testing
- feature engineering
- predictive modeling
- probability calibration
- model interpretation

---

## Analytical Workflow

The project follows a reproducible analytics pipeline.

### 1. Data Ingestion

The raw diabetes dataset is loaded into a SQLite database.

### 2. SQL Exploratory Analysis

Structured SQL queries generate:

- overall readmission rates
- age-stratified risk estimates
- cohort-level segmentation
- feature distributions
- statistical association tests

### 3. Cohort Segmentation

Patients are grouped by clinical complexity.

Features used:

- `age`
- `number_diagnoses`
- `num_medications`

Complexity buckets:

| Feature | Buckets |
|--------|--------|
| Diagnosis burden | Low / Medium / High |
| Medication burden | Low / Medium / High |

Small cohorts are filtered using:

```sql
HAVING COUNT(*) >= 50
```

This reduces statistical noise from small sample groups.

### 4. Python-Based Analysis

SQL outputs are exported and analyzed in Jupyter using:

- pandas
- numpy
- matplotlib
- seaborn
- scikit-learn

This stage includes:

- visualization
- statistical tests
- predictive modeling

---

## Key SQL Findings

- Overall **30-day readmission rate: 11.16%**
- Age group **20–30** exhibited the highest proportional readmission rate.
- Patients with **high diagnosis burden and high medication count** consistently ranked among the highest-risk cohorts.
- Younger patients within high-complexity cohorts demonstrated elevated readmission rates relative to older groups.

Chi-square testing confirmed a statistically significant association between **age and readmission**:

```
p < 0.001
```

---

## Example Cohort Insight

**Highest-risk segment identified**

| Feature | Value |
|--------|------|
| Age | 20–30 |
| Diagnosis burden | High |
| Medication burden | High |
| Readmission Rate | **19.69%** |

This suggests that **clinical complexity is a stronger predictor of readmission than age alone**, with age acting as a modifier within high-complexity populations.

---

## Predictive Modeling

After SQL-based cohort analysis, patient-level predictive models were developed.

The goal was to determine whether individual patient features could predict readmission risk more effectively than cohort segmentation alone.

---

## Baseline Cohort Model

Features:

- age
- diagnosis burden bucket
- medication burden bucket

Model:

- Logistic Regression

Performance:

| Metric | Value |
|------|------|
| ROC AUC | **0.56** |

This confirms that coarse cohort segmentation provides **limited predictive discrimination**.

---

## Expanded Administrative Feature Model

A larger feature set was constructed using administrative, utilization, and treatment variables.

Feature categories included:

- hospital utilization metrics
- prior inpatient and emergency visits
- lab summaries (A1C, glucose)
- medication indicators
- admission and discharge codes
- demographic attributes

Model:

- Logistic Regression

Performance:

| Metric | Value |
|------|------|
| ROC AUC | **0.67** |
| PR AUC | **0.22** |

Risk stratification improved substantially:

- **Top 10% highest-risk patients:** 26.9% readmission rate  
- **Population baseline:** 11.2%

This demonstrates strong enrichment in high-risk segments.

---

## Medication Association Analysis (Per-Drug Logistic Regression)

To further interpret treatment effects, a series of **single-variable logistic regression models** were trained for each diabetes medication indicator.

Each model estimated the **odds ratio for 30-day readmission associated with that medication**, controlling for the presence or absence of that specific drug.

This analysis allows interpretation of medication associations independent of the full multivariate model.

Notable associations included increased readmission odds for:

- repaglinide
- insulin
- glipizide
- nateglinide

These medications exhibited positive coefficients, indicating higher observed readmission rates among patients receiving these treatments.

Important interpretation note:

These associations **do not imply causal effects**, since medications are typically prescribed to patients with more severe disease or complications.

Instead, the results suggest that certain medications act as **markers of higher clinical severity** within the dataset.

---

## Random Forest Model Comparison

A nonlinear **Random Forest classifier** was trained to evaluate whether interaction effects or nonlinear relationships improved predictive performance.

Performance:

| Metric | Value |
|------|------|
| ROC AUC | **0.65** |
| PR AUC | **0.21** |

The tree-based model did not outperform logistic regression.

This suggests that the dominant predictive relationships in the dataset are **largely additive rather than strongly nonlinear**.

This finding highlights the importance of **empirical model comparison rather than assuming more complex models yield better performance**.

---

## Model Calibration & Probability Reliability

While logistic regression achieved good discrimination, calibration analysis revealed that predicted probabilities were **systematically overconfident**.

### Uncalibrated Model

| Metric | Value |
|------|------|
| Brier Score | **0.226** |

Calibration curves showed predicted probabilities exceeding observed outcome frequencies.

---

### Post-Hoc Calibration

Two calibration techniques were evaluated:

- **Platt scaling (sigmoid)**
- **Isotonic regression**

Calibrated model results:

| Metric | Value |
|------|------|
| Brier Score | **≈ 0.095** |

Key observations:

- ROC AUC remained unchanged
- predicted probabilities aligned closely with observed outcomes
- calibration curve approached the ideal diagonal

This demonstrates the important distinction between:

| Concept | Meaning |
|------|------|
| Discrimination | ability to rank high-risk patients |
| Calibration | accuracy of predicted probabilities |

For operational healthcare decision support, **calibrated probabilities are preferred** because they allow reliable threshold selection for interventions.

---

## Technologies Used

- **SQL (SQLite)**
- **Python**
- pandas
- numpy
- matplotlib
- seaborn
- scikit-learn
- Jupyter Notebook

---

## Project Structure

```
hospital-readmissions-sql-eda

data/
  raw/

sql/
  queries/

src/
  run_query.py

notebooks/
  modeling_and_visualization.ipynb

outputs/
  tables/
  figures/

README.md
```

---

## Key Takeaways

- Administrative healthcare data can provide meaningful readmission risk signals.
- Cohort-level segmentation reveals strong population patterns but limited predictive power.
- Patient-level features significantly improve model discrimination.
- Logistic regression performed competitively against nonlinear models.
- Probability calibration is essential before deploying risk predictions in clinical workflows.
- Medication indicators can act as **proxies for disease severity**, highlighting the importance of careful interpretation.