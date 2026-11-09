{{ config(post_hook="copy (select * from {{ this }}) to 'exports/dim_region.csv' (header)") }}

-- Gold dimension: BEA region, from the Scorecard code book.
select * from (values
    (0, 'U.S. Service Schools'),
    (1, 'New England'),
    (2, 'Mid East'),
    (3, 'Great Lakes'),
    (4, 'Plains'),
    (5, 'Southeast'),
    (6, 'Southwest'),
    (7, 'Rocky Mountains'),
    (8, 'Far West'),
    (9, 'Outlying Areas')
) as t(region_code, region_name)
