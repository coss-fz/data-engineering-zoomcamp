## Q1 - What is the start date and end date of the dataset?

```sql
SELECT
  MIN(trip_pickup_date_time AT TIME ZONE 'UTC')::TIMESTAMP::DATE AS first_pickup, -- '2009-06-01'
  MAX(trip_dropoff_date_time AT TIME ZONE 'UTC')::TIMESTAMP::DATE AS last_dropoff -- '2009-07-01'
FROM taxi_pipeline.taxi_data.rides;
```


## Q2 - What proportion of trips are paid with credit card?

```sql
SELECT
  (SUM(CASE WHEN payment_type = 'Credit' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS credit_payment_pct -- 26.66%
FROM taxi_pipeline.taxi_data.rides;
```


## Q3 - What is the total amount of money generated in tips?

```sql
SELECT
  SUM(tip_amt) as total_tips -- $6063.41
FROM taxi_pipeline.taxi_data.rides;
```