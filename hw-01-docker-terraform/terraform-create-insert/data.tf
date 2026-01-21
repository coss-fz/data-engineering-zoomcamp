resource "google_storage_bucket_object" "ny_rides_csv" {
  name   = "green_taxi_rides.csv"
  bucket = google_storage_bucket.data-lake-bucket.name
  source = "./../data/taxi_zone_lookup.csv"
  content_type = "text/csv"
}

resource "google_storage_bucket_object" "ny_rides_parquet" {
  name   = "zones.parquet"
  bucket = google_storage_bucket.data-lake-bucket.name
  source = "./../data/green_tripdata_2025-11.parquet"
  content_type = "application/octet-stream"
}

resource "google_bigquery_table" "rides_parquet_table" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "green_taxi_rides_pq"
  project    = "ny-rides-julian"

  external_data_configuration {
    source_uris = ["gs://${google_storage_bucket_object.ny_rides_parquet.bucket}/${google_storage_bucket_object.ny_rides_parquet.name}"]
    source_format = "PARQUET"

    autodetect = true
  }

  deletion_protection = false

  depends_on = [
    google_storage_bucket_object.ny_rides_parquet
  ]
}

resource "google_bigquery_table" "rides_csv_table" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "zones_csv"
  project    = "ny-rides-julian"

  external_data_configuration {
    source_uris = ["gs://${google_storage_bucket_object.ny_rides_csv.bucket}/${google_storage_bucket_object.ny_rides_csv.name}"]
    source_format = "CSV"

    csv_options {
      skip_leading_rows = 1
      allow_quoted_newlines = true
      quote = "\""
    }

    autodetect = true
  }

  deletion_protection = false

  depends_on = [
    google_storage_bucket_object.ny_rides_csv
  ]
}