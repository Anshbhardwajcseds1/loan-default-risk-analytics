-- Key test cases from the project brief. Every query should return 0 rows / 0.
SELECT COUNT(*) AS bad_status_codes   FROM loan_records WHERE default_flag NOT IN (0,1);
SELECT COUNT(*) AS missing_income     FROM loan_records WHERE income IS NULL OR income <= 0;
SELECT COUNT(*) AS duplicate_ids      FROM (SELECT loan_id FROM loan_records GROUP BY loan_id HAVING COUNT(*)>1);
SELECT COUNT(*) AS impossible_age     FROM loan_records WHERE age NOT BETWEEN 18 AND 100;
SELECT COUNT(*) AS unbanded_rows      FROM v_loan_risk WHERE credit_risk_band IS NULL;
-- Extreme loans are kept but flagged; list them for the report:
SELECT loan_id, income, loan_amount, loan_to_income_pct FROM loan_records WHERE extreme_loan_flag = 1;
