# Problem Statement & KPI Definitions

**Problem.** A lender wants to know which borrowers default, how much money is at risk, and which segments
(grade, income band, purpose, risk band) drive losses, so approval and pricing rules can be tightened.

| KPI | Definition | Where computed |
|---|---|---|
| Total Loans | Count of cleaned loan records | Python / Oracle / DAX |
| Total Exposure | Sum of loan_amount | all three |
| Total Defaults | Count where default_flag = 1 | all three |
| Default Rate % | Defaults / Total Loans x 100 | all three |
| Capital at Risk | Sum of loan_amount where default_flag = 1 | all three |
| Loss Exposure % | Capital at Risk / Total Exposure x 100 | DAX |
| Loan-to-Income % | loan_amount / income x 100 (NOT true DTI; no debt data in source) | Python |
| Risk Score | grade points (A=0..G=6) + LTI points (>=30%:2, >=20%:1) + prior default (Y:2) | Oracle view |
| Risk Band | High >= 6, Medium 3-5, Low <= 2 (cut-offs tuned on real data, see README) | Oracle view |

Default = `loan_status = 1`. Class imbalance (about 1 in 5 loans default) means accuracy is not used; default rate and capital at risk are.
