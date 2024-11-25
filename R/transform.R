library(dplyr)
library(geosphere)


# Data transformation
transform_data <- function(final_nasapower_raw) {
  nasapower <- final_nasapower_raw %>% 
    rename(date = YYYYMMDD,
           month = MM,
           day = DD,
           year = YEAR,
           rain = PRECTOTCORR,
           tmax = T2M_MAX,
           tmin = T2M_MIN,
           srad = ALLSKY_SFC_SW_DWN,
           par = ALLSKY_SFC_PAR_TOT,
           wind = WS10M,
           dewp = T2MDEW,
           rhum = RH2M) %>% 
    mutate(date = paste(year,str_pad(month,2,pad=0),str_pad(day,2,pad=0),sep = "-"),
           wind = wind * 24 * 60 * 60 / 10**3,
           par = (par*2.02 * geosphere::daylength(LAT,DOY)*3600)/1e6) %>%
    select(environment_id,date,srad,tmax,tmin,rain,rhum) %>% 
    as.data.frame()
  
  return(nasapower)
}
