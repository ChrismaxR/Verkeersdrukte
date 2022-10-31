# Setup -------------------------
library(tidyverse)
library(lubridate)

# Source of data: https://www.knmi.nl/nederland-nu/klimatologie/daggegevens

# BRON: KONINKLIJK NEDERLANDS METEOROLOGISCH INSTITUUT (KNMI)
# Opmerking: door stationsverplaatsingen en veranderingen in waarneemmethodieken zijn deze tijdreeksen van dagwaarden mogelijk inhomogeen! Dat betekent dat deze ree
# ks van gemeten waarden niet geschikt is voor trendanalyse. Voor studies naar klimaatverandering verwijzen we naar de gehomogeniseerde reeks maandtemperaturen van
# De Bilt <http://www.knmi.nl/kennis-en-datacentrum/achtergrond/gehomogeniseerde-reeks-maandtemperaturen-de-bilt> of de Centraal Nederland Temperatuur <http://www.k
# nmi.nl/kennis-en-datacentrum/achtergrond/centraal-nederland-temperatuur-cnt>.
# SOURCE: ROYAL NETHERLANDS METEOROLOGICAL INSTITUTE (KNMI)
# Comment: These time series are inhomogeneous because of station relocations and changes in observation techniques. As a result, these series are not suitable for
# trend analysis. For climate change studies we refer to the homogenized series of monthly temperatures of De Bilt <http://www.knmi.nl/kennis-en-datacentrum/achterg
# rond/gehomogeniseerde-reeks-maandtemperaturen-de-bilt> or the Central Netherlands Temperature <http://www.knmi.nl/kennis-en-datacentrum/achtergrond/centraal-neder
# land-temperatuur-cnt>.

# YYYYMMDD  = Datum (YYYY=jaar MM=maand DD=dag) / Date (YYYY=year MM=month DD=day)
# DDVEC     = Vectorgemiddelde windrichting in graden (360=noord, 90=oost, 180=zuid, 270=west, 0=windstil/variabel). Zie http://www.knmi.nl/kennis-en-datacentrum/achtergrond/klimatologische-brochures-en-boeken / Vector mean wind direction in degrees (360=north, 90=east, 180=south, 270=west, 0=calm/variable)
# FHVEC     = Vectorgemiddelde windsnelheid (in 0.1 m/s). Zie http://www.knmi.nl/kennis-en-datacentrum/achtergrond/klimatologische-brochures-en-boeken / Vector mean windspeed (in 0.1 m/s)
# FG        = Etmaalgemiddelde windsnelheid (in 0.1 m/s) / Daily mean windspeed (in 0.1 m/s)
# FHX       = Hoogste uurgemiddelde windsnelheid (in 0.1 m/s) / Maximum hourly mean windspeed (in 0.1 m/s)
# FHXH      = Uurvak waarin FHX is gemeten / Hourly division in which FHX was measured
# FHN       = Laagste uurgemiddelde windsnelheid (in 0.1 m/s) / Minimum hourly mean windspeed (in 0.1 m/s)
# FHNH      = Uurvak waarin FHN is gemeten / Hourly division in which FHN was measured
# FXX       = Hoogste windstoot (in 0.1 m/s) / Maximum wind gust (in 0.1 m/s)
# FXXH      = Uurvak waarin FXX is gemeten / Hourly division in which FXX was measured
# TG        = Etmaalgemiddelde temperatuur (in 0.1 graden Celsius) / Daily mean temperature in (0.1 degrees Celsius)
# TN        = Minimum temperatuur (in 0.1 graden Celsius) / Minimum temperature (in 0.1 degrees Celsius)
# TNH       = Uurvak waarin TN is gemeten / Hourly division in which TN was measured
# TX        = Maximum temperatuur (in 0.1 graden Celsius) / Maximum temperature (in 0.1 degrees Celsius)
# TXH       = Uurvak waarin TX is gemeten / Hourly division in which TX was measured
# T10N      = Minimum temperatuur op 10 cm hoogte (in 0.1 graden Celsius) / Minimum temperature at 10 cm above surface (in 0.1 degrees Celsius)
# T10NH     = 6-uurs tijdvak waarin T10N is gemeten / 6-hourly division in which T10N was measured; 6=0-6 UT, 12=6-12 UT, 18=12-18 UT, 24=18-24 UT
# SQ        = Zonneschijnduur (in 0.1 uur) berekend uit de globale straling (-1 voor <0.05 uur) / Sunshine duration (in 0.1 hour) calculated from global radiation (-1 for <0.05 hour)
# SP        = Percentage van de langst mogelijke zonneschijnduur / Percentage of maximum potential sunshine duration
# Q         = Globale straling (in J/cm2) / Global radiation (in J/cm2)
# DR        = Duur van de neerslag (in 0.1 uur) / Precipitation duration (in 0.1 hour)
# RH        = Etmaalsom van de neerslag (in 0.1 mm) (-1 voor <0.05 mm) / Daily precipitation amount (in 0.1 mm) (-1 for <0.05 mm)
# RHX       = Hoogste uursom van de neerslag (in 0.1 mm) (-1 voor <0.05 mm) / Maximum hourly precipitation amount (in 0.1 mm) (-1 for <0.05 mm)
# RHXH      = Uurvak waarin RHX is gemeten / Hourly division in which RHX was measured
# PG        = Etmaalgemiddelde luchtdruk herleid tot zeeniveau (in 0.1 hPa) berekend uit 24 uurwaarden / Daily mean sea level pressure (in 0.1 hPa) calculated from 24 hourly values
# PX        = Hoogste uurwaarde van de luchtdruk herleid tot zeeniveau (in 0.1 hPa) / Maximum hourly sea level pressure (in 0.1 hPa)
# PXH       = Uurvak waarin PX is gemeten / Hourly division in which PX was measured
# PN        = Laagste uurwaarde van de luchtdruk herleid tot zeeniveau (in 0.1 hPa) / Minimum hourly sea level pressure (in 0.1 hPa)
# PNH       = Uurvak waarin PN is gemeten / Hourly division in which PN was measured
# VVN       = Minimum opgetreden zicht / Minimum visibility; 0: <100 m, 1:100-200 m, 2:200-300 m,..., 49:4900-5000 m, 50:5-6 km, 56:6-7 km, 57:7-8 km,..., 79:29-30 km, 80:30-35 km, 81:35-40 km,..., 89: >70 km)
# VVNH      = Uurvak waarin VVN is gemeten / Hourly division in which VVN was measured
# VVX       = Maximum opgetreden zicht / Maximum visibility; 0: <100 m, 1:100-200 m, 2:200-300 m,..., 49:4900-5000 m, 50:5-6 km, 56:6-7 km, 57:7-8 km,..., 79:29-30 km, 80:30-35 km, 81:35-40 km,..., 89: >70 km)
# VVXH      = Uurvak waarin VVX is gemeten / Hourly division in which VVX was measured
# NG        = Etmaalgemiddelde bewolking (bedekkingsgraad van de bovenlucht in achtsten, 9=bovenlucht onzichtbaar) / Mean daily cloud cover (in octants, 9=sky invisible)
# UG        = Etmaalgemiddelde relatieve vochtigheid (in procenten) / Daily mean relative atmospheric humidity (in percents)
# UX        = Maximale relatieve vochtigheid (in procenten) / Maximum relative atmospheric humidity (in percents)
# UXH       = Uurvak waarin UX is gemeten / Hourly division in which UX was measured
# UN        = Minimale relatieve vochtigheid (in procenten) / Minimum relative atmospheric humidity (in percents)
# UNH       = Uurvak waarin UN is gemeten / Hourly division in which UN was measured
# EV24      = Referentiegewasverdamping (Makkink) (in 0.1 mm) / Potential evapotranspiration (Makkink) (in 0.1 mm)

knmi_files <- fs::dir_ls(here::here("data"), regexp = "etmgeg")

knmi_reader <- function(x) {
  
  read_csv(x, skip = 51) |> 
    janitor::clean_names()
}

knmi_data <- map_df(
  .x = knmi_files,
  .f = knmi_reader
) |> 
  mutate(
    name_stn = case_when(
      number_stn == 215 ~ "Voorschoten",
      number_stn == 260 ~ "De Bilt",
      number_stn == 240 ~ "Schiphol",
    )
  )

knmi_clean <- knmi_data |> 
  tidylog::transmute(
    name_stn,
    date = lubridate::ymd(yyyymmdd), 
    min_temp = tn/10,
    max_temp = tx/10, 
    avg_temp = tg/10,
    min_temp_freeze_bool = if_else(tn < 0, T, F), 
    max_temp_freeze_bool = if_else(tx < 0, T, F), 
    max_wind_gust_ms = fhx/10,
    wind_gust_class = case_when(
      between(fhx/10,    0,  3.3) ~ "zwak",
      between(fhx/10,  3.4,  7.9) ~ "matig",
      between(fhx/10,  8.0, 13.8) ~ "krachtig",
      between(fhx/10, 13.9, 20.7) ~ "hard",
      fhx/10 > 20.8               ~ "storm",
      T                           ~ "error"
    ),
    min_visability = vvn,
    min_visability_class = case_when(
      vvn < 3                     ~ "very bad", 
      between(vvn, 3, 6)          ~ "bad",
      between(vvn, 6, 15)         ~ "medium",
      vvn >  12                   ~ "good", 
      T                           ~ "error"
    ),
    max_visability = vvx,
    max_visability_class = case_when(
      vvx < 3                    ~ "very bad", 
      between(vvx, 3, 6)         ~ "bad",
      between(vvx, 6, 15)        ~ "medium",
      vvx >  12                  ~ "good", 
      T                          ~ "error"
    ),
    precip_dur_hrs = dr/10,
    precip_amount_24h_mm = rh/10, 
    precip_amount_24h_class = case_when(
      rh/10 < 0.1                ~ "no rain", 
      between(rh/10,   0.1, 0.5) ~ "slight rain",
      between(rh/10, 0.5, 4.0)   ~ "moderate rain",
      between(rh/10, 4.0, 8.0)   ~ "heavy rain",
      rh/10 > 8                  ~ "very heavy rain",
      T                          ~ "error"
    ),
    max_precip_amount_p_h_mm = rhx/10,
    max_precip_amount_p_h_class = case_when(
      rhx/10 < 0.1                ~ "no rain", 
      between(rhx/10,  0.1,  4.0) ~ "slight rain",
      between(rhx/10,  4.0, 15.0) ~ "moderate rain",
      between(rhx/10, 15.0, 25.0) ~ "heavy rain",
      rhx/10 > 25                 ~ "very heavy rain",
      T                           ~ "error"
    )
  ) |> 
  tidylog::filter(date > ymd("2014-12-31")) |> 
  arrange(date, name_stn)

# Question is there an importance regarding which weather station I use?
knmi_groups <- knmi_clean |> 
  group_split(name_stn, .keep = F) |> 
  setNames(c("De Bilt", "Schiphol", "Voorschoten"))

# knmi_groups$Schiphol |> 
#   anti_join(knmi_groups$`De Bilt`, by = "date")

# Visual inspection of differences between the different weather stations
# visdat::vis_compare(knmi_groups$Schiphol, knmi_groups$Voorschoten)
# visdat::vis_compare(knmi_groups$Schiphol, knmi_groups$`De Bilt`)
# visdat::vis_compare(knmi_groups$Voorschoten, knmi_groups$`De Bilt`)

# Schiphol vs. Voorschoten shows a marked difference in precipition for a period
# Voorschoten is closer to the coast than Schiphol, so would make sense it would
# have less rain. On the whole not much difference...

knmi_model <- knmi_clean |> 
  filter(name_stn == "Schiphol")
