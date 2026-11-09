{{ config(post_hook="copy (select * from {{ this }}) to 'exports/dim_control.csv' (header)") }}

-- Gold dimension: institutional control (ownership) type, from the Scorecard code book.
select * from (values
    (1, 'Public'),
    (2, 'Private nonprofit'),
    (3, 'Private for-profit')
) as t(control_code, control_type)
