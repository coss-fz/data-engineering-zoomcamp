## Q1 - Run docker with the python:3.13 image. Use an entrypoint bash to interact with the container.

First, I have to run the docker image
```
docker run -it \
    --rm \
    --entrypoint=bash \
    python:3.13
```

Then, I have to check the pip verion
```
pip --version   # pip 25.3
```


## Q2 - Given the following docker-compose.yaml, what is the hostname and port that pgadmin should use to connect to the postgres database?

First, I have to create the container
```
docker-compose up -d
```

Then, I have to create the connection in `pgAdmin`:
- host: postgres
- port: 5432
- username: postgres
- pwd: postgres


## Q3 - For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a trip_distance of less than or equal to 1 mile?

```
select count(*) -- 8007
from green_taxi_data
where 1=1
and date(lpep_pickup_datetime) between '2025-11-01'::date and '2025-12-30'::date
and trip_distance <= 1;
```


## Q4 - Which was the pick up day with the longest trip distance? Only consider trips with trip_distance less than 100 miles (to exclude data errors).

```
select date(lpep_pickup_datetime) -- 2025-11-14
from green_taxi_data
where 1=1
and trip_distance = (
	select max(trip_distance) from green_taxi_data
	where trip_distance <= 100
);
```


## Q5 - Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?

```
select "PULocationID", "Zone", count(*) -- East Harlem North
from green_taxi_data g
left join zones z on g."PULocationID" = z."LocationID"
where 1=1
and date(lpep_pickup_datetime) = '2025-11-18'::date
group by "PULocationID", "Zone"
order by count(*) desc
limit 1;
```


## Q6 - For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

```
select "DOLocationID", "Zone" -- Yorkville West
from green_taxi_data g
left join zones z on g."DOLocationID" = z."LocationID"
where 1=1
and tip_amount = (
	select max(tip_amount)
	from green_taxi_data
	where "PULocationID" = (select "LocationID" from zones where "Zone" = 'East Harlem North')
	and date(lpep_pickup_datetime) between '2025-11-01'::date and '2025-11-30'::date
);
```


## Q7 - Terraform Workflow

First, create the files `terraform-create/main.tf` and `terraform-create/data.tf`
```
terraform init
terraform apply -auto-approve
```

After everything is done and tested, delete all resources
```
terraform destroy
```