library(tidyverse)
library(jsonlite)
library(here)
library(furrr)

plan(multiprocess)

results_data <- read_csv(here("data/results_data.csv"))
division_data <- read_csv(here("data/division_data.csv"))

results_data %>%
    select_at(vars(starts_with("ball"), 'bonus')) %>%
    gather(key = "ball", value = "result") %>%
    group_by(result) %>%
    count() %>%
    ggplot(aes(x = result, y = n)) +
    geom_bar(stat = 'identity') +
    theme_minimal()
