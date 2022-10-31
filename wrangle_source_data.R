
# Set up ------------------------------------------------------------------
library(tidyverse)

# Get data ----------------------------------------------------------------

# data provenance: see here::here("code", "rijkswaterstaat_open_data_pull.R")
file_data <- read_rds(here::here("data", "20221025_rws_file_data.rds"))

# Script for adding extra data points, such as: 
## - calender variables (holidays, school holidays):
source(here::here("code", "source_holidays.R"))

# Adding weather variables
source(here::here("code", "source_knmi_open_data.R"))


# Wrangling data -----------------------------------------------------------

## unaggregated rijkswaterstaat file data
# congestion per day, timestamp, road, "traject" and "wegvak".

file_data_unagg <- file_data |> 
  mutate(
    datum_file_begin,
    day_of_month = lubridate::day(datum_file_begin),
    wday = lubridate::wday(datum_file_begin, label = T), 
    is_weekend = if_else(wday %in% c("Sat", "Sun"), T, F), 
    is_meeting_day = if_else(wday %in% c("Tue", "Thu"), T, F), 
    is_holiday = if_else(datum_file_begin %in% holiday_vector, T, F), 
    is_school_holiday = if_else(datum_file_begin %in% school_holiday_vector, T, F)
  ) |> 
  left_join(knmi_model, by = c("datum_file_begin" = "date"))

## unaggregated rijkswaterstaat data for A4 (Schiphol-Den Haag)

a4_file_data_unagg <- file_data |>
  filter(
    route_oms == "A4", 
    traj_van %in% c("Amsterdam", "Delft", "Den Haag"),
    traj_naar %in% c("Amsterdam", "Delft", "Den Haag"),
  ) |> 
  mutate(
    datum_file_begin,
    day_of_month = lubridate::day(datum_file_begin),
    wday = lubridate::wday(datum_file_begin, label = T), 
    is_weekend = if_else(wday %in% c("Sat", "Sun"), T, F), 
    is_meeting_day = if_else(wday %in% c("Tue", "Thu"), T, F), 
    is_holiday = if_else(datum_file_begin %in% holiday_vector, T, F), 
    is_school_holiday = if_else(datum_file_begin %in% school_holiday_vector, T, F)
  ) |> 
  left_join(knmi_model, by = c("datum_file_begin" = "date"))

## aggregated rijkswaterstaat file data to overall number of congestions per day

file_data_agg <- file_data |> 
  group_by(datum_file_begin) |> 
  summarise(
    files = n(), 
    totale_gem_lengte_km = sum(gem_lengte)/1000,
    totale_file_duur_uur = sum(file_duur)/60, 
    aantal_wegen = n_distinct(route_oms)
  ) |> 
  ungroup() |> 
  left_join(
    y = file_data |> 
      count(datum_file_begin, file_type) |> 
      pivot_wider(names_from = file_type, values_from = n) |> 
      janitor::clean_names(),
    by = "datum_file_begin"
  ) |> 
  left_join(
    y = file_data |> 
      count(datum_file_begin, oorzaak_4) |> 
      pivot_wider(names_from = oorzaak_4, values_from = n) |> 
      janitor::clean_names(), 
    by = "datum_file_begin"
  ) |> 
  mutate(
    datum_file_begin,
    day_of_month = lubridate::day(datum_file_begin),
    wday = lubridate::wday(datum_file_begin, label = T), 
    is_weekend = if_else(wday %in% c("Sat", "Sun"), T, F), 
    is_meeting_day = if_else(wday %in% c("Tue", "Thu"), T, F), 
    is_holiday = if_else(datum_file_begin %in% holiday_vector, T, F), 
    is_school_holiday = if_else(datum_file_begin %in% school_holiday_vector, T, F)
  ) |> 
  left_join(knmi_model, by = c("datum_file_begin" = "date"))

## aggregated rijkswaterstaat file data to overall number of congestions per day  for A4 (Schiphol-Den Haag)

a4_file_data_agg <- file_data |> 
  filter(
    route_oms == "A4", 
    traj_van %in% c("Amsterdam", "Delft", "Den Haag"),
    traj_naar %in% c("Amsterdam", "Delft", "Den Haag"),
  ) |> 
  group_by(datum_file_begin) |> 
  summarise(
    files = n(), 
    totale_gem_lengte_km = sum(gem_lengte)/1000,
    totale_file_duur_uur = sum(file_duur)/60, 
    aantal_wegen = n_distinct(route_oms)
  ) |> 
  ungroup() |> 
  left_join(
    y = file_data |> 
      count(datum_file_begin, file_type) |> 
      pivot_wider(names_from = file_type, values_from = n) |> 
      janitor::clean_names(),
    by = "datum_file_begin"
  ) |> 
  left_join(
    y = file_data |> 
      count(datum_file_begin, oorzaak_4) |> 
      pivot_wider(names_from = oorzaak_4, values_from = n) |> 
      janitor::clean_names(), 
    by = "datum_file_begin"
  ) |> 
  mutate(
    datum_file_begin,
    day_of_month = lubridate::day(datum_file_begin),
    wday = lubridate::wday(datum_file_begin, label = T), 
    is_weekend = if_else(wday %in% c("Sat", "Sun"), T, F), 
    is_meeting_day = if_else(wday %in% c("Tue", "Thu"), T, F), 
    is_holiday = if_else(datum_file_begin %in% holiday_vector, T, F), 
    is_school_holiday = if_else(datum_file_begin %in% school_holiday_vector, T, F)
  ) |> 
  left_join(knmi_model, by = c("datum_file_begin" = "date"))



