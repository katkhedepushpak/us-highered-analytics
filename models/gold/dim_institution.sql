{{ config(post_hook="copy (select * from {{ this }}) to 'exports/dim_institution.csv' (header)") }}

-- Gold dimension: one row per institution. Scorecard is the spine (it lists
-- the institutions we report on); IPEDS adds city and coordinates.
select
    sc.unitid,
    sc.institution_name,
    ip.city,
    sc.state_code,
    sc.control_code,
    sc.region_code,
    sc.predominant_degree_code,
    case sc.predominant_degree_code
        when 1 then 'Certificate'
        when 2 then 'Associate'
        when 3 then 'Bachelor''s'
        when 4 then 'Graduate'
        else 'Not classified'
    end                                  as predominant_degree,
    sc.state_code = 'OR'                 as is_oregon,
    ip.latitude,
    ip.longitude
from {{ ref('stg_scorecard') }} as sc
left join {{ ref('stg_ipeds_institution') }} as ip
    on sc.unitid = ip.unitid
