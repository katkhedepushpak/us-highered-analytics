-- Bronze: IPEDS fall enrollment by student level (EF), raw. Long format:
-- one row per institution per student-level code.
select *
from read_csv(
    '{{ var("raw_dir") }}/ipeds_ef/ef2023a.csv',
    header = true,
    all_varchar = true,
    sample_size = -1
)
