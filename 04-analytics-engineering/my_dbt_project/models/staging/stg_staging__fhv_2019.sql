{{
    config(
        materialized='view'
    )
}}

with fhv_data as 
(
  select *
  from {{ source('staging','fhv_2019') }}
)
select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['pulocationid', 'pickup_datetime']) }} as tripid,
    {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,
    
    -- timestamps
    cast(pickup_datetime as timestamp) as fhv_pickup_datetime,
    cast(dropoff_datetime as timestamp) as fhv_dropoff_datetime,
    
    -- other info
    sr_flag,
    dispatching_base_num
    affiliated_base_number,

from fhv_data
 where EXTRACT(YEAR FROM pickup_datetime) = 2019


-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}