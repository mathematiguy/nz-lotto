# A stan simulation model
library(rstan)
library(here)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

prior_simulations <- stan(
    here('analysis/simulations.stan'),
    model_name = 'prior_simulations',
    data = list(K = 40, alpha = 1), algorithm = 'Fixed_param')

predictions <- extract(prior_simulations)$theta
