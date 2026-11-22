# Reconciliation: Python vs Oracle vs Power BI

Counts must match exactly. Amounts within 0.1%.

| Metric | Python (`docs/reconciliation_python.csv`) | Oracle (`sql/04_reconciliation.sql`) | Power BI card | Match? |
|---|---:|---:|---:|---|
| Total loans | __fill__ | 32,409 | 32,409 | |
| Total defaults | __fill__ | 7,088 | 7,088 | |
| Default rate % | __fill__ | 21.87 | 0.22 (average of DEFAULT_FLAG) | |
| Total loan amount | __fill__ | 310,882,900 | 311M (shown shortened) | |
| Capital at risk (defaulted loan amount) | __fill__ | __run query below__ | __card on Page 1__ | |

Oracle query for the last row:
```sql
SELECT SUM(loan_amount) AS capital_at_risk FROM loan_records WHERE default_flag = 1;
```

Fill the `__fill__` cells from `docs/reconciliation_python.csv`, add screenshots of the three tools to `docs/screenshots/`, and tick "Match?".
