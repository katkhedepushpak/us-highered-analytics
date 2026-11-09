-- Bronze: raw College Scorecard file, untouched. Every column is read as text so
-- nothing is silently coerced; typing and cleaning happen in silver.
select *
from read_csv(
    '{{ var("raw_dir") }}/scorecard/Most-Recent-Cohorts-Institution.csv',
    header = true,
    all_varchar = true,
    sample_size = -1
)
