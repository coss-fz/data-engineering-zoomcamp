"""Template for building a `dlt` pipeline to ingest data from a REST API."""

import dlt
from dlt.sources.rest_api import rest_api_source


# if no argument is provided, `access_token` is read from `.dlt/secrets.toml`
@dlt.source
def taxi_pipeline_rest_api_source():
    """Define dlt resources from REST API endpoints."""
    return rest_api_source({
        "client": {
            "base_url": "https://us-central1-dlthub-analytics.cloudfunctions.net/data_engineering_zoomcamp_api",
        },
        "resources": [
            {
                "name": "rides",
                "endpoint": {
                    "path": "",
                    "paginator": {
                        "type": "page_number",
                        "page_param": "page",
                        "base_page": 1,
                        "total_path": None,
                        "stop_after_empty_page": True,
                    },
                },
            }
        ],
    })


pipeline = dlt.pipeline(
    pipeline_name='taxi_pipeline',
    destination='duckdb',
    dataset_name="taxi_data",
    progress="log",
)


if __name__ == "__main__":
    load_info = pipeline.run(taxi_pipeline_rest_api_source())
    print(load_info)  # noqa: T201
