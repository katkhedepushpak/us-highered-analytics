-- Bronze: IPEDS institutional characteristics (HD), raw.
select *
from read_csv(
    '{{ var("raw_dir") }}/ipeds_hd/HD2024.csv',
    header = true,
    all_varchar = true,
    sample_size = -1
)
