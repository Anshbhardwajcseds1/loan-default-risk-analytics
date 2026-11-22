# Insights Summary

All figures come from the Oracle queries on `LOAN_RECORDS` / `V_LOAN_RISK` (32,409 cleaned loans, 7,088 defaults, 21.87% overall).

## 1. Loan grade is the strongest signal
| Grade | Loans | Default rate |
|---|---:|---:|
| A | 10,702 | 9.96% |
| B | 10,384 | 16.32% |
| C | 6,436 | 20.76% |
| D | 3,619 | 59.05% |
| E | 963 | 64.49% |
| F | 241 | 70.54% |
| G | 64 | 98.44% |

Default risk nearly triples between grade C (20.76%) and grade D (59.05%). Grades D to G hold only about 15% of loans (4,887 of 32,409) but default at 59% or more.

## 2. Low income borrowers default far more often
| Income band | Loans | Default rate |
|---|---:|---:|
| Under 30K | 3,642 | 47.20% |
| 30-60K | 13,939 | 25.86% |
| 60-100K | 10,281 | 13.21% |
| Over 100K | 4,547 | 8.95% |

Borrowers earning under 30K default about 5 times as often as those earning over 100K.

## 3. Debt consolidation and medical loans are riskiest by purpose
| Purpose | Loans | Default rate |
|---|---:|---:|
| Debt consolidation | 5,189 | 28.68% |
| Medical | 6,042 | 26.76% |
| Home improvement | 3,594 | 26.15% |
| Personal | 5,496 | 19.89% |
| Education | 6,409 | 17.26% |
| Venture | 5,679 | 14.86% |

## 4. The risk band separates borrowers well
| Band | Loans | Default rate |
|---|---:|---:|
| Low Risk | 21,670 | 9.72% |
| Medium Risk | 8,758 | 41.11% |
| High Risk | 1,981 | 69.71% |

High Risk is only about 6% of loans (1,981 of 32,409) but contains 1,381 defaults, which is about 19% of all defaults, with 29,307,375 in loan exposure.

## Recommendations
- Tighten approval or require collateral for grades D to G and for the High Risk band.
- Price loans to under-30K income borrowers with extra caution, or cap loan size relative to income.
- Review debt consolidation and medical loan policies, since they have the highest default rates by purpose.
- Monitor the Medium Risk band (41% default rate, 8,758 loans), where policy changes would affect the most borrowers.
