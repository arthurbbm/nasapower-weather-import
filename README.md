# Weather Data Collection and Transformation Pipeline

## Overview

This project is designed to automate the process of fetching, transforming, and exporting weather data for agricultural trials using the NASA Power API. The pipeline is modular, allowing each step (fetching data, transforming it, and exporting it) to be handled by a separate R script for ease of use and maintainability.

The workflow involves: 1. Fetching initial weather data from the NASA Power API for specified trial environments. 2. Retrying to fetch data for environments that fail in the initial attempt. 3. Transforming the data into a suitable format for further analysis. 4. Exporting the transformed data to a CSV file.

## Directory Structure

The project is divided into the following scripts:

-   **`main.R`**: The main script orchestrating the workflow.
-   **`fetch.R`**: Script responsible for fetching weather data from the NASA Power API.
-   **`transform.R`**: Handles the transformation of the raw weather data.
-   **`export.R`**: Manages exporting the processed data to a CSV file.

## Prerequisites

-   **R version**: Ensure that R (\>= 3.6.0) is installed.
-   **Libraries**: The following R packages are required:
    -   `dplyr`
    -   `nasapower`
    -   `furrr`
    -   `future`
    -   `beepr`
    -   `geosphere`

You can install the required packages using the command:

``` r
install.packages(c("dplyr", "nasapower", "furrr", "future", "beepr", "geosphere"))
```

## Expected Input Format

The input data is provided in a CSV file named `trials_info.csv`, which contains information about the trial environments. Each row represents a specific environment, and the required columns are as follows:

-   **`environment_id`**: A unique identifier for the trial environment.
-   **`latitude`**: Latitude of the trial location.
-   **`longitude`**: Longitude of the trial location.
-   **`start_date`**: Start date for the weather data collection (in `YYYY-MM-DD` format).
-   **`end_date`**: End date for the weather data collection (in `YYYY-MM-DD` format).

Make sure that the `trials_info.csv` file is placed in the working directory before running the script.

## Running the Project

1.  Place the input CSV file (`trials_info.csv`) in the working directory.
2.  Run the `main.R` script to execute the entire workflow:

``` r
source("main.R")
```

The workflow will: - Fetch initial weather data and retry for any missing data. - Transform the collected data into a suitable format. - Export the final transformed data to a CSV file named `trials_weather.csv`.

## Description of Scripts

### `main.R`

-   Orchestrates the entire workflow by sourcing other scripts.
-   Sets up parallel processing using the `furrr` package to speed up data fetching.
-   Loads the trial information from `trials_info.csv`.
-   Calls functions from `fetch.R`, `transform.R`, and `export.R` to complete the process.

### `fetch.R`

-   **`get_weather_data()`**: Fetches weather data for a given environment, with retries if rate-limited.
-   **`fetch_initial_data()`**: Fetches data for all environments in parallel.
-   **`retry_missing_data()`**: Retries fetching data for environments that failed during the initial fetch.

### `transform.R`

-   **`transform_data()`**: Renames columns, performs unit conversions, and selects specific columns for the output dataset.

### `export.R`

-   **`export_data()`**: Exports the final transformed dataset to a CSV file.

## Output

The output is a CSV file named `trials_weather.csv`, which contains the transformed weather data for the specified trial environments.

The final output columns are: - **`environment_id`**: Unique identifier for the environment. - **`date`**: Date in `YYYY-MM-DD` format. - **`srad`**: Solar radiation. - **`tmax`**: Maximum temperature. - **`tmin`**: Minimum temperature. - **`rain`**: Precipitation. - **`rhum`**: Relative humidity.

## Notes

-   The NASA Power API may impose rate limits; therefore, the script has a retry mechanism with an exponential backoff strategy.
-   Ensure a stable internet connection, as fetching data requires accessing the NASA Power API.
-   Adjust the working directory in `main.R` if necessary to match your project structure.

## Contact

If you encounter issues or have questions, feel free to contact the project maintainer.
