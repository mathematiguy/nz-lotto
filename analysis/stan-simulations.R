# A stan simulation model
library(rstan)
library(here)

options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

prior_simulations <- stan(
    here('analysis/simulations.stan'),
    model_name = 'prior_simulations',
    data = list(K = 40, N=6, alpha = 1), algorithm = 'Fixed_param')

theta <- extract(prior_simulations)$theta
ranking <- extract(prior_simulations)$ranking
results <- extract(prior_simulations)$results

results
