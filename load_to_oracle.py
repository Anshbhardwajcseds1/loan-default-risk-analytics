"""
Loads data/clean/loans_clean.csv into Oracle table LOAN_RECORDS (no import wizard needed).

Put this file inside the project folder (next to the 'scripts' folder) and run from there:
    pip install oracledb
    python load_to_oracle.py
"""
import sys
from pathlib import Path
import pandas as pd
import oracledb

HOST, PORT, SERVICE = "localhost", 1522, "xepdb1"   # your port is 1522
USER, PASSWORD = "loanuser", "loan123"

csv = Path(__file__).resolve().parent / "data" / "clean" / "loans_clean.csv"
if not csv.exists():
    sys.exit(f"File not found: {csv}\nFirst run:  python scripts/01_clean_loans.py")

df = pd.read_csv(csv)
cols = ["loan_id", "age", "income", "home_ownership", "emp_length_yrs", "purpose", "grade",
        "loan_amount", "interest_rate", "default_flag", "prior_default", "credit_hist_yrs",
        "extreme_loan_flag", "interest_rate_imputed", "loan_to_income_pct", "income_band", "age_group"]
df = df[cols].astype(object).where(df[cols].notna(), None)   # NaN -> NULL
rows = [tuple(r) for r in df.itertuples(index=False, name=None)]

conn = oracledb.connect(user=USER, password=PASSWORD, dsn=f"{HOST}:{PORT}/{SERVICE}")
cur = conn.cursor()
cur.execute("DELETE FROM loan_records")          # safe to run again
sql = f"INSERT INTO loan_records ({','.join(cols)}) VALUES ({','.join(':%d' % (i + 1) for i in range(len(cols)))})"
cur.executemany(sql, rows)
conn.commit()
cur.execute("SELECT COUNT(*), SUM(default_flag) FROM loan_records")
total, defaults = cur.fetchone()
print(f"Loaded {total} rows into LOAN_RECORDS. Defaults: {defaults}")
conn.close()