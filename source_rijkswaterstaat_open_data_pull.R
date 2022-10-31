
# Get data ----------------------------------------------------------------


# Date: 2022-10-24
# Data obtained via the website of Rijkswaterstaat: https://downloads.rijkswaterstaatdata.nl/filedata/


library(tidyverse)
dater <- stringr::str_remove_all(as.character(lubridate::today()), "\\-")

#meta <- read_delim(delim = ";", "https://downloads.rijkswaterstaatdata.nl/filedata/rws_filedata_metadata.csv")

links <- list(
  "2015-01_rws_filedata.csv", "2015-02_rws_filedata.csv", "2015-03_rws_filedata.csv", 
  "2015-04_rws_filedata.csv", "2015-05_rws_filedata.csv", "2015-06_rws_filedata.csv", 
  "2015-07_rws_filedata.csv", "2015-08_rws_filedata.csv", "2015-09_rws_filedata.csv", 
  "2015-10_rws_filedata.csv", "2015-11_rws_filedata.csv", "2015-12_rws_filedata.csv", 
  "2016-01_rws_filedata.csv", "2016-02_rws_filedata.csv", "2016-03_rws_filedata.csv", 
  "2016-04_rws_filedata.csv", "2016-05_rws_filedata.csv", "2016-06_rws_filedata.csv", 
  "2016-07_rws_filedata.csv", "2016-08_rws_filedata.csv", "2016-09_rws_filedata.csv", 
  "2016-10_rws_filedata.csv", "2016-11_rws_filedata.csv", "2016-12_rws_filedata.csv", 
  "2017-01_rws_filedata.csv", "2017-02_rws_filedata.csv", "2017-03_rws_filedata.csv", 
  "2017-04_rws_filedata.csv", "2017-05_rws_filedata.csv", "2017-06_rws_filedata.csv", 
  "2017-07_rws_filedata.csv", "2017-08_rws_filedata.csv", "2017-09_rws_filedata.csv", 
  "2017-10_rws_filedata.csv", "2017-11_rws_filedata.csv", "2017-12_rws_filedata.csv", 
  "2018-01_rws_filedata.csv", "2018-02_rws_filedata.csv", "2018-03_rws_filedata.csv", 
  "2018-04_rws_filedata.csv", "2018-05_rws_filedata.csv", "2018-06_rws_filedata.csv", 
  "2018-07_rws_filedata.csv", "2018-08_rws_filedata.csv", "2018-09_rws_filedata.csv", 
  "2018-10_rws_filedata.csv", "2018-11_rws_filedata.csv", "2018-12_rws_filedata.csv", 
  "2019-01_rws_filedata.csv", "2019-02_rws_filedata.csv", "2019-03_rws_filedata.csv", 
  "2019-04_rws_filedata.csv", "2019-05_rws_filedata.csv", "2019-06_rws_filedata.csv", 
  "2019-07_rws_filedata.csv", "2019-08_rws_filedata.csv", "2019-09_rws_filedata.csv", 
  "2019-10_rws_filedata.csv", "2019-11_rws_filedata.csv", "2019-12_rws_filedata.csv", 
  "2020-01_rws_filedata.csv", "2020-02_rws_filedata.csv", "2020-03_rws_filedata.csv", 
  "2020-04_rws_filedata.csv", "2020-05_rws_filedata.csv", "2020-06_rws_filedata.csv", 
  "2020-07_rws_filedata.csv", "2020-08_rws_filedata.csv", "2020-09_rws_filedata.csv", 
  "2020-10_rws_filedata.csv", "2020-11_rws_filedata.csv", "2020-12_rws_filedata.csv", 
  "2021-01_rws_filedata.csv", "2021-02_rws_filedata.csv", "2021-03_rws_filedata.csv", 
  "2021-04_rws_filedata.csv", "2021-05_rws_filedata.csv", "2021-06_rws_filedata.csv", 
  "2021-07_rws_filedata.csv", "2021-08_rws_filedata.csv", "2021-09_rws_filedata.csv", 
  "2021-10_rws_filedata.csv", "2021-11_rws_filedata.csv", "2021-12_rws_filedata.csv", 
  "2022-01_rws_filedata.csv", "2022-02_rws_filedata.csv", "2022-03_rws_filedata.csv", 
  "2022-04_rws_filedata.csv", "2022-05_rws_filedata.csv", "2022-06_rws_filedata.csv", 
  "2022-07_rws_filedata.csv", "2022-08_rws_filedata.csv", "2022-09_rws_filedata.csv", 
  "2022-10_rws_filedata.csv"
)

#reader <- function(x) {
  
  read_delim(
    file = str_c("https://downloads.rijkswaterstaatdata.nl/filedata/", x), 
    locale = locale(decimal_mark = ",")
  ) |> 
    janitor::clean_names() |> 
    mutate(
      set = x,
      uur_file_begin = hour(tijd_file_begin),
      file_type = case_when(
        uur_file_begin %in% c(6:9)   ~ "ochtendspits", 
        uur_file_begin %in% c(16:19) ~ "avondspits", 
        T                            ~ "geen spits"
      )
    )
  
}

# commented out, run to update 
# file_data <- map_df(
#   .x = links,
#   .f = reader
# )

#write_rds(file_data, here::here("data", str_c(dater, "_rws_file_data.rds")))



# Exploration -------------------------------------------------------------

# 
# file_data |> 
#   count(route_oms, sort = T)
# 
# file_data |> 
#   count(str_c(traj_van, traj_naar, sep = " - "), sort = T)
# 
# file_data |> 
#   count(str_c(kop_wegvak_van, kop_wegvak_naar, route_oms, sep = " - "), sort = T) |> 
#   View()
