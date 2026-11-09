-- Silver: IPEDS institutional characteristics. One row per institution.
select
    try_cast(UNITID as integer)         as unitid,
    trim(INSTNM)                        as institution_name_ipeds,
    trim(CITY)                          as city,
    trim(STABBR)                        as state_code_ipeds,
    try_cast(SECTOR as integer)         as sector_code,
    try_cast(ICLEVEL as integer)        as institution_level_code,
    try_cast(LATITUDE as double)        as latitude,
    try_cast(LONGITUD as double)        as longitude
from {{ ref('brz_ipeds_hd') }}
where try_cast(UNITID as integer) is not null
