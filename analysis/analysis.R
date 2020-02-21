library(tidyverse)
library(jsonlite)
library(here)
library(furrr)

plan(multiprocess)

results_data <- read_csv(here("data/results_data.csv"))
division_data <- read_csv(here("data/division_data.csv"))
ball_probs <- read_csv(here("data/ball_probs.csv"))

results_data %>%
    select_at(vars(starts_with("ball"), 'bonus')) %>%
    gather(key = "ball", value = "result") %>%
    group_by(result) %>%
    count() %>%
    ggplot(aes(x = result, y = n)) +
    geom_bar(stat = 'identity') +
    theme_minimal()

results_data %>%
  select_at(vars(starts_with("ball"))) %>%
  gather(key = "ball", value = "result") %>%
  group_by(result) %>%
  count() %>%
  ggplot(aes(x = result, y = n)) +
  geom_bar(stat = 'identity') +
  theme_minimal()

results_data %>%
  ggplot(aes(x = date, y = number_of_winners)) +
  geom_line() +
  theme_minimal()

results_data %>%
  filter(number_of_winners == max(number_of_winners)) %>%
  print(width = Inf)

results_data %>%
  ggplot(aes(x = date, y = total_prize_pool)) +
  geom_line() +
  theme_minimal()

division_data %>%
  filter(draw_number == 1373) %>%
  print(width = Inf)

division_data %>%
  filter(game == "powerball", division == 1) %>%
  left_join(select(results_data, draw_number, number_of_winners)) %>%
  select(draw_number, number_of_winners, payout)

names(results_data)

results_data %>%
  ggplot(aes(x = number_of_winners, y = total_prize_pool)) +
  geom_point() +
  theme_minimal()

ball_probs %>%
  mutate(sims = 1:4000) %>%
  gather(starts_with("V"), key = "ball", value = "prob") %>%
  mutate(ball = factor(str_remove(ball, "V"), levels = 1:40)) %>%
  ggplot(aes(x = prob, fill = ball)) +
  geom_histogram() +
  facet_wrap(~ball) +
  geom_vline(xintercept = 1 / 40) +
  guides(fill = FALSE) +
  theme_minimal()

