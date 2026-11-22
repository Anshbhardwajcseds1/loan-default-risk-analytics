-- Oracle SQL: run in SQL Developer / SQL*Plus as your schema user
-- ER: one fact table (LOAN_RECORDS) + two lookup tables used by the views (star-style)

BEGIN EXECUTE IMMEDIATE 'DROP TABLE loan_records PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE dim_grade PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE dim_income_band PURGE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE dim_grade (
  grade        VARCHAR2(1) PRIMARY KEY,
  grade_points NUMBER(1)   NOT NULL        -- A=0 (safest) ... G=6
);
INSERT INTO dim_grade VALUES ('A',0); INSERT INTO dim_grade VALUES ('B',1);
INSERT INTO dim_grade VALUES ('C',2); INSERT INTO dim_grade VALUES ('D',3);
INSERT INTO dim_grade VALUES ('E',4); INSERT INTO dim_grade VALUES ('F',5);
INSERT INTO dim_grade VALUES ('G',6);

CREATE TABLE dim_income_band (
  income_band VARCHAR2(20) PRIMARY KEY
);
INSERT INTO dim_income_band VALUES ('1. <30K');
INSERT INTO dim_income_band VALUES ('2. 30-60K');
INSERT INTO dim_income_band VALUES ('3. 60-100K');
INSERT INTO dim_income_band VALUES ('4. >100K');

CREATE TABLE loan_records (
  loan_id               NUMBER(10)    PRIMARY KEY,
  age                   NUMBER(3)     NOT NULL,
  income                NUMBER(12,2)  NOT NULL CHECK (income > 0),
  home_ownership        VARCHAR2(20),
  emp_length_yrs        NUMBER(4,1),
  purpose               VARCHAR2(30)  NOT NULL,
  grade                 VARCHAR2(1)   NOT NULL REFERENCES dim_grade(grade),
  loan_amount           NUMBER(12,2)  NOT NULL CHECK (loan_amount > 0),
  interest_rate         NUMBER(5,2),
  default_flag          NUMBER(1)     NOT NULL CHECK (default_flag IN (0,1)),
  prior_default         VARCHAR2(1)   CHECK (prior_default IN ('Y','N')),
  credit_hist_yrs       NUMBER(3),
  extreme_loan_flag     NUMBER(1),
  interest_rate_imputed NUMBER(1),
  loan_to_income_pct    NUMBER(8,2),
  income_band           VARCHAR2(20)  REFERENCES dim_income_band(income_band),
  age_group             VARCHAR2(10)
);
COMMIT;
