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
    model_name = 'prior_simulations',
    data = list(NBalls = 40, NDraw=6, NSamples = nrow(draws), alpha = 1, draws = draws),
    chains = 4)

prior_simulations

theta <- extract(prior_simulations)$theta
ranking <- extract(prior_simulations)$ranking
draws <- extract(prior_simulations)$draws
ball_prob <- extract(prior_simulations)$ball_prob

print(dim(theta))
print(dim(ranking))
print(dim(draws))
print(dim(ball_prob))

ball_probs <- as_tibble(ball_prob)

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
