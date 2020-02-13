# A stan simulation model
library(tidyverse)
library(rstan)
library(here)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

results_data <- read_csv(here("data/results_data.csv"))

results <- results_data %>%
    select(starts_with("ball")) %>%
    as.matrix()

prior_simulations <- stan(
    here('analysis/simulation_model.stan'),
    model_name = 'prior_simulations',
    data = list(NBalls = 40, NDraws=6, NSample=nrow(results_data), alpha=1, results=results),
    algorithm = 'Fixed_param')

prior_simulations

theta <- extract(prior_simulations)$theta
ranking <- extract(prior_simulations)$ranking
results <- extract(prior_simulations)$results
