-- Bronze: IPEDS graduation rates (GR), raw. Long format:
-- one row per institution per cohort/completion type code.
select *
from read_csv(
    '{{ var("raw_dir") }}/ipeds_gr/gr2023.csv',
    header = true,
    all_varchar = true,
    sample_size = -1
)
