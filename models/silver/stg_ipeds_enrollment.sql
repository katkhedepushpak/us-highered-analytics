-- Silver: IPEDS fall enrollment, collapsed from long format to ONE ROW PER
-- INSTITUTION (the grain fix). EFALEVEL codes arrive space-padded (' 1'), so
-- they are trimmed first. Codes: 1 = all students, 2 = undergraduate,
-- 12 = graduate (verified: undergraduate + graduate = total for Oregon State).
select
    try_cast(UNITID as integer) as unitid,
    max(case when trim(EFALEVEL) = '1'  then try_cast(EFTOTLT as integer) end) as total_enrollment,
    max(case when trim(EFALEVEL) = '2'  then try_cast(EFTOTLT as integer) end) as undergrad_enrollment,
    max(case when trim(EFALEVEL) = '12' then try_cast(EFTOTLT as integer) end) as graduate_enrollment
from {{ ref('brz_ipeds_ef') }}
where trim(EFALEVEL) in ('1', '2', '12')
group by 1
