# Set up
library(tidyverse)
library(lubridate)

# Official holidays in NL in 2015-2022
# manually pulled from http://www.overzicht-feestdagen.nl/ and rijksoverheid.nl

holidays <- c(
  "01-01-2015", "03-04-2015", "05-04-2015", "06-04-2015", "27-04-2015",
  "05-05-2015", "14-05-2015", "24-05-2015", "25-05-2015", "25-12-2015", 
  "26-12-2015", "31-12-2015", "01-01-2016", "25-03-2016", "27-03-2016", 
  "28-03-2016", "27-04-2016", "05-05-2016", "15-05-2016", "16-05-2016", 
  "25-12-2016", "26-12-2016", "31-12-2016", "01-01-2017", "14-04-2017", 
  "16-04-2017", "17-04-2017", "27-04-2017", "05-05-2017", "25-05-2017", 
  "04-06-2017", "05-06-2017", "25-12-2017", "26-12-2017", "31-12-2017",
  "01-01-2018", "30-03-2018", "01-04-2018", "02-04-2018", "27-04-2018", 
  "05-05-2018", "10-05-2018", "20-05-2018", "21-05-2018", "25-12-2018", 
  "26-12-2018", "31-12-2018", "01-01-2019", "19-04-2019", "21-04-2019", 
  "22-04-2019", "27-04-2019", "05-05-2019", "30-05-2019", "09-06-2019", 
  "10-06-2019", "25-12-2019", "26-12-2019", "12-04-2020", "13-04-2020", 
  "27-04-2020", "05-05-2020", "21-05-2020", "31-05-2020", "01-06-2020", 
  "25-12-2020", "26-12-2020", "01-01-2021", "02-04-2021", "04-04-2021", 
  "05-04-2021", "27-04-2021", "05-05-2021", "13-05-2021", "23-05-2021", 
  "24-05-2021", "25-12-2021", "26-12-2021", "01-01-2022", "15-04-2022", 
  "17-04-2022", "18-04-2022", "27-04-2022", "05-05-2022", "26-05-2022",
  "05-06-2022", "06-06-2022", "25-12-2022", "26-12-2022"
)
holiday_vector <- dmy(holidays)
  
# School holidays
# get the data from the following R script:
source(here::here("code", "schoolholiday_data_collatoin.R"))

school_holidays_clean <- school_holiday_complete |> 
  mutate(
    begin_datum = lubridate::dmy(begin_datum), 
    eind_datum = lubridate::dmy(eind_datum), 
    sequences = map2(
      .x = begin_datum, 
      .y = eind_datum, 
      .f = ~seq(.x, .y, "days") # sequence every date in between begin and end date
    )
  )

# get every date in a school holiday into a single vector by appending everything
school_holiday_vector <- reduce(.x = school_holidays_clean$sequences, .f = append)



