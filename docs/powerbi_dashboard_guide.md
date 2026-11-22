# Power BI build guide (Power BI Desktop, 2 pages)

1. **Get data**: Oracle Database connector (or Text/CSV: export `final_loan_risk_analysis`). Load `final_loan_risk_analysis`.
2. **New measures**: paste everything from `powerbi/measures.dax`.
3. **Sort order**: sort `income_band` as is (prefixed 1-4), `age_group` manually 18-25, 26-35, 36-50, 51+.
4. **Page 1 - Executive Overview**
   - KPI cards (5): Total Loans, Total Exposure, Default Rate %, Capital at Risk, High Risk Share %
   - Clustered bar: Default Rate % by `credit_risk_band` (must rise Low -> High)
   - Column chart: Default Rate % by `grade`
   - Column chart: Default Rate % by `income_band`
   - Bar: Default Rate % by `purpose`
   - Slicers (3+): `credit_risk_band`, `age_group`, `home_ownership`, `purpose`
5. **Page 2 - Drill-down**
   - Matrix with hierarchy `grade > purpose > income_band` (drill-down #1, #2, #3), values Loans, Defaults, Default Rate %
   - Scatter: `loan_to_income_pct` (x) vs `interest_rate` (y), legend `default_flag`
   - Stacked column: Capital at Risk by `age_group` and `credit_risk_band`
   - Table: top 20 High Risk loans by `loan_amount` (use `loan_size_rank_in_purpose`)
6. **Check**: card values equal `docs/reconciliation_python.csv`. Screenshot for README.
7. Save as `dashboard/loan_risk_dashboard.pbix`; export page images to `dashboard/`.
