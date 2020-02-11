library(tidyverse)
library(jsonlite)
library(here)
library(furrr)

plan(multiprocess)

results_data <- read_csv(here("data/results_data.csv"))
division_data <- read_csv(here("data/division_data.csv"))

