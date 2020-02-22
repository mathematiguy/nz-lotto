# A stan simulation model
library(tidyverse)
library(rstan)
library(here)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

results_data <- read_csv(here("data/results_data.csv"))

draws <- results_data %>%
    select(starts_with("ball")) %>%
    as.matrix()

ball_counts <- results_data %>%
    select(starts_with("ball")) %>%
    gather(key = 'ball', value = 'value') %>%
    group_by(value) %>%
    count()

prior_simulations <- stan(
    here('models/simulation_model.stan'),
    model_name = 'simulation_model',
    data = list(NBalls = 40, NDraw=6, NSamples = nrow(draws), alpha = 1, draws = draws),
    chains = 4)

theta <- extract(prior_simulations)$theta
ranking <- extract(prior_simulations)$ranking
draws <- extract(prior_simulations)$draws
ball_prob <- extract(prior_simulations)$ball_prob

ball_probs <- as_tibble(ball_prob)

write_csv(here("data/ball_probs.csv"))
