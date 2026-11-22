-- Risk score = grade points (0-6) + loan-to-income points (0-2) + prior default points (0/2)
-- Bands: High >= 6, Medium 3-5, Low <= 2.   TUNE the cut-offs after you see the real data
-- (run section B below), then write the final cut-offs in README/KPI definitions.

CREATE OR REPLACE VIEW v_loan_risk AS
WITH scored AS (
  SELECT l.*,
         g.grade_points
         + CASE WHEN l.loan_to_income_pct >= 30 THEN 2
                WHEN l.loan_to_income_pct >= 20 THEN 1 ELSE 0 END
         + CASE WHEN l.prior_default = 'Y' THEN 2 ELSE 0 END AS risk_score
  FROM loan_records l
  JOIN dim_grade g ON g.grade = l.grade
)
SELECT s.*,
       CASE WHEN risk_score >= 6 THEN 'High Risk'
            WHEN risk_score >= 3 THEN 'Medium Risk'
            ELSE 'Low Risk' END                                             AS credit_risk_band,
       -- window functions: compare each borrower to their income-band peers
       ROUND(PERCENT_RANK() OVER (PARTITION BY income_band
                                  ORDER BY loan_to_income_pct) , 3)         AS lti_percentile_in_band,
       ROUND(interest_rate - AVG(interest_rate) OVER (PARTITION BY grade), 2) AS rate_vs_grade_avg,
       RANK() OVER (PARTITION BY purpose ORDER BY loan_amount DESC)         AS loan_size_rank_in_purpose
FROM scored s;

-- Materialise for Power BI (fast import; Oracle 12c+ syntax)
BEGIN EXECUTE IMMEDIATE 'DROP TABLE final_loan_risk_analysis PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
CREATE TABLE final_loan_risk_analysis AS SELECT * FROM v_loan_risk;

-- Default rate summary view (grade / income band / purpose / risk band)
CREATE OR REPLACE VIEW v_default_summary AS
SELECT 'grade' AS dimension, grade AS category, COUNT(*) AS loans, SUM(default_flag) AS defaults,
       ROUND(100*SUM(default_flag)/COUNT(*),2) AS default_rate_pct, SUM(loan_amount) AS exposure
FROM loan_records GROUP BY grade
UNION ALL
SELECT 'income_band', income_band, COUNT(*), SUM(default_flag), ROUND(100*SUM(default_flag)/COUNT(*),2), SUM(loan_amount)
FROM loan_records GROUP BY income_band
UNION ALL
SELECT 'purpose', purpose, COUNT(*), SUM(default_flag), ROUND(100*SUM(default_flag)/COUNT(*),2), SUM(loan_amount)
FROM loan_records GROUP BY purpose
UNION ALL
SELECT 'risk_band', credit_risk_band, COUNT(*), SUM(default_flag), ROUND(100*SUM(default_flag)/COUNT(*),2), SUM(loan_amount)
FROM v_loan_risk GROUP BY credit_risk_band;

-- B. Band calibration check: default rate must rise Low < Medium < High
SELECT credit_risk_band, COUNT(*) loans, ROUND(100*COUNT(*)/SUM(COUNT(*)) OVER (),1) pct_of_loans,
       ROUND(100*SUM(default_flag)/COUNT(*),2) default_rate_pct
FROM v_loan_risk GROUP BY credit_risk_band ORDER BY default_rate_pct;
