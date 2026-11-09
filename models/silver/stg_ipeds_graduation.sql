-- Silver: IPEDS bachelor's graduation, collapsed to ONE ROW PER INSTITUTION.
-- GRTYPE codes are inferred, not taken from an official dictionary:
--   2 = bachelor's-seeking cohort, 3 = completers within 150% of normal time.
-- Validated against Scorecard by the assert_ipeds_grad_rate_matches_scorecard test.
select
    try_cast(UNITID as integer) as unitid,
    max(case when trim(GRTYPE) = '2' then try_cast(GRTOTLT as integer) end) as bachelors_cohort,
    max(case when trim(GRTYPE) = '3' then try_cast(GRTOTLT as integer) end) as bachelors_completers_150,
    max(case when trim(GRTYPE) = '3' then try_cast(GRTOTLT as double) end)
        / nullif(max(case when trim(GRTYPE) = '2' then try_cast(GRTOTLT as double) end), 0)
                                                                              as grad_rate_150_ipeds
from {{ ref('brz_ipeds_gr') }}
where trim(GRTYPE) in ('2', '3')
group by 1
