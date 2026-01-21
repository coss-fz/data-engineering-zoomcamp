terraform {
    required_providers {
      google = {
        source  = "hashicorp/google"
        version = "5.6.0"
      }
    }
}

provider "google" {
  project = "ny-rides-julian"
  region = "us-central1"
}


resource "google_storage_bucket" "data-lake-bucket" {
  name = "ny-rides-bucket-jcf"
  location = "US"
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }

  force_destroy = true
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = "ny_rides_dataset"
  project = "ny-rides-julian"
  location = "US"
}