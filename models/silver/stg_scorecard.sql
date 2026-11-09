-- Silver: typed, cleaned College Scorecard. One row per institution (UNITID).
-- Scorecard encodes missing values as the text 'NULL' or 'PrivacySuppressed';
-- try_cast turns anything non-numeric into a true NULL instead of failing.
select
    try_cast(UNITID as integer)                 as unitid,
    trim(INSTNM)                                as institution_name,
    trim(STABBR)                                as state_code,
    try_cast(CONTROL as integer)                as control_code,
    try_cast(REGION as integer)                 as region_code,
    try_cast(PREDDEG as integer)                as predominant_degree_code,
    try_cast(ADM_RATE as double)                as admission_rate,
    try_cast(UGDS as integer)                   as undergrad_enrollment_sc,
    try_cast(C150_4 as double)                  as grad_rate_150_sc,
    try_cast(RET_FT4 as double)                 as retention_rate_ft,
    coalesce(
        try_cast(NPT4_PUB as double),
        try_cast(NPT4_PRIV as double)
    )                                           as avg_net_price,
    try_cast(TUITIONFEE_IN as double)           as tuition_in_state,
    try_cast(TUITIONFEE_OUT as double)          as tuition_out_of_state,
    try_cast(PCTPELL as double)                 as pell_grant_share,
    try_cast(MD_EARN_WNE_P10 as double)         as median_earnings_10yr
from {{ ref('brz_scorecard') }}
where try_cast(UNITID as integer) is not null
