with source as (
    select * from {{ source('raw_data', 'fhv_tripdata') }}
), renamed as (
    select
        -- base_numbers
        cast(dispatching_base_num as string) as dispatching_base_number,
        cast(Affiliated_base_number as string) as affiliated_base_number,
        -- identifiers
        cast(PUlocationID as integer) as pickup_location_id,
        cast(DOlocationid as integer) as dropoff_location_id,
        -- timestamps
        cast(pickup_datetime as timestamp) as pickup_datetime,
        cast(dropOff_datetime as timestamp) as dropoff_datetime,
        -- trip info
        cast(SR_Flag as string) as shared_ride_flag
    from source
    where dispatching_base_num is not null
)
select * from renamed

{% if target.name == 'dev' %}
where pickup_datetime >= '2019-01-01' and pickup_datetime < '2019-02-01'
{% endif %}