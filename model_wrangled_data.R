library(tidyverse)

source(here::here("code", "wrangle_source_data.R"))

#make this example reproducible
set.seed(1)

# total aggregated models -------------------------------------------------

#create ID column
file_data_agg$id <- 1:nrow(file_data_agg)

#use 70% of dataset as training set and 30% as test set 
total_train <- file_data_agg %>% dplyr::sample_frac(0.70)
total_test  <- anti_join(file_data_agg, total_train, by = 'id')

# Set up A4 modesls
total_mod1 <- lm(files ~ min_temp + min_visability + precip_dur_hrs, data = total_train) 
total_mod2 <- lm(files ~ min_temp + min_visability + precip_dur_hrs * is_holiday * is_meeting_day, data = total_train) 
total_mod3 <- lm(files ~ is_holiday + is_meeting_day, data = total_train) 
total_mod4 <- lm(files ~ is_holiday + ongeval, data = total_train) 

total_check <- total_test |> 
  select(
    datum_file_begin, files, min_temp, min_visability, 
    precip_dur_hrs, is_holiday, is_meeting_day, ongeval
  ) |> 
  modelr::add_predictions(model = total_mod1, var = "mod1") |> 
  modelr::add_predictions(model = total_mod2, var = "mod2") |> 
  modelr::add_predictions(model = total_mod3, var = "mod3") |> 
  modelr::add_predictions(model = total_mod4, var = "mod4") |> 
  modelr::add_residuals(model = total_mod1, var = "resid_mod1") |> 
  modelr::add_residuals(model = total_mod2, var = "resid_mod2") |> 
  modelr::add_residuals(model = total_mod3, var = "resid_mod3") |> 
  modelr::add_residuals(model = total_mod4, var = "resid_mod4")

# models
total_check |> 
  ggplot(aes(datum_file_begin, files)) + 
  geom_line() +
  geom_point() +
  geom_line(aes(y = mod1), colour = "green") +
  geom_point(aes(y = mod1), colour = "green") +
  geom_line(aes(y = mod2), colour = "red") +
  geom_point(aes(y = mod2), colour = "red") +
  geom_line(aes(y = mod3), colour = "blue") +
  geom_point(aes(y = mod3), colour = "blue") +
  geom_line(aes(y = mod4), colour = "grey88", alpha = 0.6) +
  geom_point(aes(y = mod4), colour = "grey88", alpha = 0.5)

# residuals
total_check |> 
  ggplot(aes(datum_file_begin, files)) + 
  geom_line() +
  geom_point() +
  geom_line(aes(y = resid_mod1), colour = "green", alpha = .5) +
  geom_point(aes(y = resid_mod1), colour = "green", alpha = .5)

# A4 aggregated file model -----------------------------


#create ID column
a4_file_data_agg$id <- 1:nrow(a4_file_data_agg)

#use 70% of dataset as training set and 30% as test set 
a4_train <- a4_file_data_agg %>% dplyr::sample_frac(0.70)
a4_test  <- dplyr::anti_join(a4_file_data_agg, train, by = 'id')

# Set up A4 modesls
mod1 <- lm(files ~ min_temp + min_visability + precip_dur_hrs, data = a4_train) 
mod2 <- lm(files ~ min_temp + min_visability + precip_dur_hrs + is_holiday + is_meeting_day, data = a4_train) 
mod3 <- lm(files ~ is_holiday + is_meeting_day, data = a4_train) 

check <- test |> 
  select(
    datum_file_begin, files, min_temp, min_visability, 
    precip_dur_hrs, is_holiday, is_meeting_day
  ) |> 
  modelr::add_predictions(model = mod1, var = "mod1") |> 
  modelr::add_predictions(model = mod2, var = "mod2") |> 
  modelr::add_predictions(model = mod3, var = "mod3") 

file_data_agg |> 
  ggplot(aes(datum_file_begin, files)) + 
  geom_line() +
  geom_point()

check |> 
  ggplot(aes(datum_file_begin, files)) + 
  geom_line() +
  geom_point() +
  geom_line(aes(y = mod1), colour = "green") +
  #geom_point(aes(y = mod1), colour = "green") +
  geom_line(aes(y = mod2), colour = "red") +
  #geom_point(aes(y = mod2), colour = "red") +
  geom_line(aes(y = mod3), colour = "blue") #+
  #geom_point(aes(y = mod3), colour = "blue")


