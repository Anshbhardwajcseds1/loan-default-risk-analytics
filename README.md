# Loan Default Analysis and Risk Dashboard

An end-to-end analytics project (Python, Oracle SQL, Power BI) that shows which borrowers default, how much capital is at risk, and which segments drive the losses.

## Problem
A lender wants to know where defaults come from, so approval and pricing rules can be tightened. The dashboard answers: what is the default rate overall, by loan grade, income band, purpose and risk band, and how much money sits in the riskiest segment?

## Tools
- **Python (pandas):** cleaning, validation, feature engineering
- **Oracle SQL (XE 21c):** tables, constraints, joins, GROUP BY, window functions (PERCENT_RANK, AVG OVER, RANK), views
- **Power BI Desktop:** KPI cards, charts, slicers, 3-level drill-down matrix

## Dataset
Kaggle "Credit Risk Dataset" (`credit_risk_dataset.csv`), 32,581 raw rows.

## Pipeline
1. `scripts/01_clean_loans.py`: cleans the raw CSV, writes `data/clean/loans_clean.csv`, `docs/data_quality_report.md`
2. `load_to_oracle.py`: loads the clean CSV into Oracle table `LOAN_RECORDS`
3. `sql/`: table DDL, risk-band views, summary view, reconciliation and test queries
4. `dashboard/loan_risk_dashboard.pbix`: 2-page Power BI report

## Data model
`LOAN_RECORDS` (fact) with lookups `DIM_GRADE` and `DIM_INCOME_BAND`, then views `V_LOAN_RISK` and `V_DEFAULT_SUMMARY`, and table `FINAL_LOAN_RISK_ANALYSIS` for Power BI. See `docs/er_diagram.png`.

## Data quality (details in `docs/data_quality_report.md`)
| Step | Rows |
|---|---:|
| Raw rows | 32,581 |
| Exact duplicates removed | 165 |
| Age outside 18-100 removed | 5 |
| Employment length above 60 years removed | 2 |
| **Clean rows** | **32,409** |
| Missing interest rates filled (median of the same grade, flagged) | 3,094 |

## Risk band definition
Risk score = grade points (A=0 ... G=6) + loan-to-income points (>=30%: 2, >=20%: 1) + prior default on file (2). **High** >= 6, **Medium** 3-5, **Low** <= 2.
Loan-to-income is used instead of DTI because the dataset has no debt data.

## Results (Oracle)
- 32,409 loans, 7,088 defaults, **21.87% default rate**, total loan amount 310,882,900.
- Default rate rises with risk band: **Low 9.72%, Medium 41.11%, High 69.71%**.
- Grade A 9.96% to grade G 98.44%.

See `docs/insights_summary.md` for the full findings and `docs/reconciliation_table.md` for the Python / Oracle / Power BI match.

## Dashboard
Page 1: KPI cards, default rate by risk band, grade, income band and purpose, slicers for risk band, age group and purpose.
Page 2: drill-down matrix Grade > Purpose > Income band.

## Limitations
- No debt data, so loan-to-income replaces DTI.
- Interest rate imputation uses the grade median.
- Risk bands are a transparent rule-based score, not a predictive model. The data is imbalanced (about 22% defaults), so default rate and capital at risk are reported instead of accuracy.

## How to run
1. `pip install pandas numpy oracledb`
2. Put the Kaggle CSV in `data/raw/credit_risk_dataset.csv`
3. `python scripts/01_clean_loans.py`
4. Run `sql/01_create_tables.sql` in Oracle, then `python load_to_oracle.py`
5. Run `sql/03_views_risk_bands.sql`, `sql/04_reconciliation.sql`, `sql/05_test_cases.sql`
6. Open the `.pbix` in Power BI Desktop
