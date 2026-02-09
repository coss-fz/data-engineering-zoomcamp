with trips as (
    select * from {{ ref("inter_trips") }}
)
select distinct
    vendor_id,
    {{ get_vendor_data('vendor_id') }} as vendor_name
from trips