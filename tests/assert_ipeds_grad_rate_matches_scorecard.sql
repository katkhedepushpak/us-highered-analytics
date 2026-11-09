{{ config(severity='warn') }}

-- Cross-source reconciliation: two independent sources (IPEDS completers/cohort
-- vs Scorecard's C150_4) should agree on graduation rate. They cover slightly
-- different cohort years, so allow a 15-point gap and only look at cohorts of 100+.
-- Returns institutions that disagree; any rows surface as a warning to investigate.
select
    unitid,
    grad_rate_150_sc,
    grad_rate_150_ipeds,
    abs(grad_rate_150_sc - grad_rate_150_ipeds) as gap
from {{ ref('fact_institution_outcomes') }}
where grad_rate_150_sc is not null
  and grad_rate_150_ipeds is not null
  and bachelors_cohort >= 100
  and abs(grad_rate_150_sc - grad_rate_150_ipeds) > 0.15
