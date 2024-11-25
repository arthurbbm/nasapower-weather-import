# Export transformed data
export_data <- function(nasapower) {
  write.csv(nasapower, "trials_weather.csv", row.names = F)
}
