data {
  // The number of unique balls in the lottery
  int<lower=1> NBalls;
  // The number of balls in each draw
  int<lower=1> NDraws;
  // The number of draws on record
  int<lower=1> NSample;
  // The alpha parameter for the dirichlet distribution
  real<lower=0> alpha;
  // The lottery results table
  matrix<lower=1>[NSample, NDraws] results;
}

parameters {
  simplex[NBalls] theta;
}

model {
  for (i in 1:NSample) {
    theta ~ dirichlet(rep_vector(alpha, NBalls));
  }
}

generated quantities {
  int<lower = 1> ranking[NBalls];
  ranking = sort_indices_asc(theta);
  //results = head(ranking, N);
}

