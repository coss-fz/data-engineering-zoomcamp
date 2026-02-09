
"""
Docstring for analytics-engineering.taxi_rides_ny.ingest_data
"""

from pathlib import Path
import duckdb
import requests




BASE_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv"

def download_and_convert_files(): # pylint: disable=redefined-outer-name
    """
    Docstring for download_and_convert_files
    """
    data_dir = Path("data")
    data_dir.mkdir(exist_ok=True, parents=True)

    for year in [2019]:
        for month in range(1, 13):
            parquet_filename = f"fhv_tripdata_{year}-{month:02d}.parquet"
            parquet_filepath = data_dir / parquet_filename

            if parquet_filepath.exists():
                print(f"Skipping {parquet_filename} (already exists)")
                continue

            # Download CSV.gz file
            csv_gz_filename = f"fhv_tripdata_{year}-{month:02d}.csv.gz"
            csv_gz_filepath = data_dir / csv_gz_filename

            response = requests.get(f"{BASE_URL}/{csv_gz_filename}", stream=True) # pylint: disable=missing-timeout
            response.raise_for_status()

            with open(csv_gz_filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)

            print(f"Converting {csv_gz_filename} to Parquet...")
            con = duckdb.connect() # pylint: disable=redefined-outer-name
            con.execute(f"""
                COPY (SELECT * FROM read_csv_auto('{csv_gz_filepath}'))
                TO '{parquet_filepath}' (FORMAT PARQUET)
            """)
            con.close()

            # Remove the CSV.gz file to save space
            csv_gz_filepath.unlink()
            print(f"Completed {parquet_filename}")

if __name__ == "__main__":

    download_and_convert_files()

    con = duckdb.connect("taxi_rides_ny.duckdb")
    con.execute("CREATE SCHEMA IF NOT EXISTS prod")

    con.execute(f"""
        CREATE OR REPLACE TABLE prod.fhv_tripdata AS
        SELECT * FROM read_parquet('data/*.parquet', union_by_name=true)
    """)

    con.close()
