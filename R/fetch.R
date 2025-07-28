library(dplyr)
library(nasapower)
library(furrr)
library(purrr)
library(future)


# Function to fetch weather data for each environment
get_weather_data <- function(lat, lon, START, END, retries = 5) {
  tryCatch({
    weather_partial <- nasapower::get_power(
      community = "ag",
      temporal_api = "daily",
      lonlat = c(lon, lat),
      dates = c(START, END),
      pars = c("PRECTOTCORR", 
               "T2M_MAX", 
               "T2M_MIN", 
               "RH2M", 
               "ALLSKY_SFC_SW_DWN",
               "T2MDEW", 
               "WS10M", 
               "ALLSKY_SFC_PAR_TOT")
    ) 
    return(as.data.frame(weather_partial))
  }, error = function(e) {
    if (grepl("HTTP \\(429\\)", e$message) && retries > 0) {
      delay <- 10 * (6 - retries) # Exponential backoff strategy
      message("Rate limit exceeded for longitude/latitude ", lon, "/", lat, ". Retrying after ", delay, " seconds...")
      Sys.sleep(delay) # Delay before retrying
      return(as.data.frame(get_weather_data(lat, lon, START, END, retries - 1)))
    } else {
      message("Error occurred for longitude/latitude ", lon, "/", lat, ": ", e$message)
      return(NULL)
    }
  })
}

# Fetch initial data function
fetch_initial_data <- function(df.cords) {
  nasapower_raw_list <- future_pmap(
    df.cords,
    get_weather_data,
    .options = furrr_options(seed = TRUE)
  )
  
  return(nasapower_raw_list)
}

# Retry fetching missing data
retry_missing_data <- function(df.cords, nasapower_raw_list) {
  missing.df.cords <- df.cords[map_lgl(nasapower_raw_list, is.null), ]
  
  if (nrow(missing.df.cords) > 0) {
    message("Retrying for missing data...")
    nasapower_raw <- fetch_initial_data(missing.df.cords)
    return(nasapower_raw)
  } else {
    return(data.frame()) # Return empty data frame if no missing data
  }
}
