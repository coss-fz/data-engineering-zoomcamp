## PREVIOUS - Create an external table using the Yellow Taxi Trip Records.

```sql
CREATE OR REPLACE EXTERNAL TABLE `zoomcamp.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://ny-taxi-data-jcf/yellow_tripdata_*.parquet']
);
```


## PREVIOUS - Create a (regular/materialized) table in BQ using the Yellow Taxi Trip Records (do not partition or cluster this table).

```sql
CREATE OR REPLACE TABLE `zoomcamp.yellow_tripdata` AS
SELECT * FROM `zoomcamp.external_yellow_tripdata`;
```


## Q1 - What is count of records for the 2024 Yellow Taxi Data?

```sql
SELECT COUNT(*) -- 20332093
FROM `ny-rides-julian.zoomcamp.yellow_tripdata`;
```


## Q2 - Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables. What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

```sql
SELECT DISTINCT(PULocationID), COUNT(*)
FROM `ny-rides-julian.zoomcamp.external_yellow_tripdata`
GROUP BY PULocationID; -- 0 MB

SELECT DISTINCT(PULocationID), COUNT(*)
FROM `ny-rides-julian.zoomcamp.yellow_tripdata`
GROUP BY PULocationID; -- 155.12 MB
```


## Q3 - Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?

BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.


## Q4 - How many records have a fare_amount of 0?
```sql
SELECT COUNT(*) -- 8333
FROM `ny-rides-julian.zoomcamp.yellow_tripdata`
WHERE fare_amount = 0;
```


## Q5 - What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

```sql
CREATE OR REPLACE TABLE zoomcamp.yellow_tripdata_partitioned_clustered
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM zoomcamp.external_yellow_tripdata;
```


## Q6 - Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive). Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values?

```sql
SELECT DISTINCT(VendorID)
FROM `ny-rides-julian.zoomcamp.yellow_tripdata`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15'; -- 310.24 MB

SELECT DISTINCT(VendorID)
FROM `ny-rides-julian.zoomcamp.yellow_tripdata_partitioned_clustered`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15'; -- 26.84 MB
```

## Q7 - Where is the data stored in the External Table you created?

The data in external tables references a bucket in GCS.


## Q8 - It is best practice in Big Query to always cluster your data?

False, only for tables greater than 1 GB.


## Q9 - Write a `SELECT count(*)` query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

The estimated processing is **0 B**, this is because BigQuery is reading from metadata (*Number of rows*), not the actual data files.