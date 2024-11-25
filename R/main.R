r_base_directory <- file.path(getwd(), "R")
source(file.path(r_base_directory, "fetch.R"))
source(file.path(r_base_directory, "transform.R"))
source(file.path(r_base_directory, "export.R"))

library(beepr)

# Set up parallel processing
plan(multisession)

# Load environment data
trials_raw <- read.csv("trials_info.csv")

# Fetch initial data
initial_result <- fetch_initial_data(trials_raw)

# Retry for missing data
retry_result <- retry_missing_data(trials_raw, initial_result)
beepr::beep()

# Combine results
final_nasapower_raw <- bind_rows(initial_result, retry_result)

# Transform data
nasapower <- transform_data(final_nasapower_raw)

# Export data
export_data(nasapower)
