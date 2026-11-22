-- Run these and compare with docs/reconciliation_python.csv and the Power BI cards.
SELECT 'total_loans' metric, COUNT(*) oracle_value FROM loan_records
UNION ALL SELECT 'total_defaults', SUM(default_flag) FROM loan_records
UNION ALL SELECT 'default_rate_pct', ROUND(100*SUM(default_flag)/COUNT(*),2) FROM loan_records
UNION ALL SELECT 'total_loan_amount', SUM(loan_amount) FROM loan_records
UNION ALL SELECT 'default_loan_amount', SUM(CASE WHEN default_flag=1 THEN loan_amount END) FROM loan_records
UNION ALL SELECT 'defaults_grade_'||grade, SUM(default_flag) FROM loan_records GROUP BY grade
ORDER BY 1;
