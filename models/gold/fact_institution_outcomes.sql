{{ config(post_hook="copy (select * from {{ this }}) to 'exports/fact_institution_outcomes.csv' (header)") }}

-- Gold fact: one row per institution with its outcome and enrollment measures.
-- Grain is guaranteed by the silver layer (every input is one row per unitid),
-- so these left joins cannot fan out rows. The unique test on unitid enforces that.
select
    sc.unitid,
    sc.admission_rate,
    sc.retention_rate_ft,
    sc.grad_rate_150_sc,
    gr.grad_rate_150_ipeds,
    gr.bachelors_cohort,
    gr.bachelors_completers_150,
    sc.avg_net_price,
    sc.tuition_in_state,
    sc.tuition_out_of_state,
    sc.pell_grant_share,
    sc.median_earnings_10yr,
    en.total_enrollment,
    en.undergrad_enrollment,
    en.graduate_enrollment
from {{ ref('stg_scorecard') }} as sc
left join {{ ref('stg_ipeds_enrollment') }} as en on sc.unitid = en.unitid
left join {{ ref('stg_ipeds_graduation') }} as gr on sc.unitid = gr.unitid
