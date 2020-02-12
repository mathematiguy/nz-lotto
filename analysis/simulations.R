# A simple R-only simulation model
library(tidyverse)
library(MCMCpack)
library(here)

n_trials = 1000
n_balls = 40
n_draw = 6

alpha = rep(1, n_balls)
balls <- sort(rep(seq(1, n_balls), n_trials))
dim(balls) <- c(n_trials, n_balls)

draws <- rdirichlet(n_trials, alpha)
results <- t(apply(draws, 1, rank))

results_mask <- results %in% seq(n_balls - n_draw + 1, n_balls)
dim(results_mask) <- c(n_trials, n_balls)

results <- t(balls)[t(results_mask)]
dim(results) <- c(n_trials, n_draw)

dim(results) <- n_trials * n_draw

hist(results)

tibble(balls = results) %>%
  group_by(balls) %>%
  count() %>%
  ggplot(aes(x = balls, y = n)) +
  geom_bar(stat = 'identity') +
  theme_minimal()
