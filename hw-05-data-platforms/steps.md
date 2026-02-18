## Q1  -In a Bruin project, what are the required files/directories?

A valid Bruin project requires:
- .bruin.yml → Project configuration file
- pipeline/ directory containing:
    - pipeline.yml → Pipeline definition
    - assets/ → Pipeline assets (SQL, Python, etc.)


## Q2 - You're building a pipeline that processes NYC taxi data organized by month based on pickup_datetime. Which materialization strategy should you use for the staging layer that deduplicates and cleans the data?

The staging layer should process data incrementally based on time partitions.


## Q3 - How do you override a the `taxi_types` variable when running the pipeline to only process yellow taxis?

```bash
bruin run --var 'taxi_types=["yellow"]'
```


## Q4 - You've modified the ingestion/trips.py asset and want to run it plus all downstream assets. Which command should you use?

```bash
bruin run --select ingestion.trips+
```


## Q5 - You want to ensure the pickup_datetime column in your trips table never has NULL values. Which quality check should you add to your asset definition?

```yml
not_null: true
```


## Q6 - After building your pipeline, you want to visualize the dependency graph between assets. Which Bruin command should you use?

```bash
bruin lineage assets/staging/trips.sql 
```
```
Lineage: 'staging.trips'

Upstream Dependencies
========================
- ingestion.trips (assets\ingestion\trips.py)
- ingestion.payment_lookup (assets\ingestion\payment_lookup.asset.yml)

Total: 2


Downstream Dependencies
========================
- reports.report_trips_monthly (assets\reports\trips_report.sql)

Total: 1
```


## Q7 - You're running a Bruin pipeline for the first time on a new DuckDB database. What flag should you use to ensure tables are created from scratch?

```bash
bruin run \
--start-date 2025-02-01T00:00:00.000Z \
--end-date 2025-02-10T23:59:59.999999999Z \
--environment default \
"c:\_repos_git\data-engineering-zoomcamp\hw-05-data-platforms\zoomcamp\pipeline\pipeline.yml" \
--full-refresh
```