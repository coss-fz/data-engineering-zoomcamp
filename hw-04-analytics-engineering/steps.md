## Q1 - If you run `dbt run --select int_trips_unioned`, what models will be built?

Since there´s no `+` flag, `int_trips_unioned` only.


## Q2 - Your model `fct_trips` has been running successfully for months. A new value 6 now appears in the source data. What happens when you run dbt test --select fct_trips?

Since the number is not between 1 and 5, dbt will fail the test (returning a non-zero exit code).


## Q3 - What is the count of records in the `fct_monthly_zone_revenue` model?

```sql
select count(*) -- 12184
from ny_taxi.prod.fct_monthly_zone_revenue;
```


## Q4 - Using the `fct_monthly_zone_revenue` table, find the pickup zone with the highest total revenue (revenue_monthly_total_amount) for Green taxi trips in 2020. Which zone had the highest revenue?

```sql
select
  pickup_zone, -- East Harlem North
  sum(revenue_monthly_total_amount) as total_revenue
from ny_taxi.prod.fct_monthly_zone_revenue
where service_type = 'Green'
  and revenue_month >= '2020-01-01'
group by pickup_zone
order by total_revenue desc
limit 1;
```


## Q5 - Using the `fct_monthly_zone_revenue` table, what is the total number of trips (total_monthly_trips) for Green taxis in October 2019?

```sql
select
  sum(total_monthly_trips) -- 384624
from ny_taxi.prod.fct_monthly_zone_revenue
where service_type = 'Green'
  and revenue_month = '2019-10-01';
```


## Q6 - What is the count of records in `stg_fhv_tripdata`?

```sql
select count(*) -- 43244693
from ny_taxi.prod.stg_fhv_tripdata
```