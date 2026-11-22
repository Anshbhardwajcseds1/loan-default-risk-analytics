-- SQL*Loader control file.  Run from the project root:
--   sqlldr userid=USER/PASSWORD@XEPDB1 control=sql/02_load_data.ctl log=sql/load.log bad=sql/load.bad
-- (Alternative: SQL Developer > right-click table LOAN_RECORDS > Import Data > pick data/clean/loans_clean.csv)
OPTIONS (SKIP=1)
LOAD DATA
INFILE 'data/clean/loans_clean.csv'
TRUNCATE INTO TABLE loan_records
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  loan_id, age, income, home_ownership, emp_length_yrs, purpose, grade, loan_amount,
  interest_rate, default_flag, prior_default, credit_hist_yrs, extreme_loan_flag,
  interest_rate_imputed, loan_to_income_pct, income_band, age_group
)
