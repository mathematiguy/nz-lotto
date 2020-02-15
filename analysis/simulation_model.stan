data {
  int<lower=1> NBalls;
  int<lower=1> NDraw;
  int<lower=1> NSamples;
  real<lower=0> alpha;
}

parameters {
  simplex[NBalls] theta[NSamples];
}

model {
  for (i in 1:NSamples)
    theta[i] ~ dirichlet(rep_vector(alpha, NBalls));
}

generated quantities {
  matrix<lower=1>[NSamples, NBalls] ranking;
  matrix<lower=1>[NSamples, NDraw] draws;
  vector<lower=0>[NBalls] ball_prob;
  for (j in 1:NSamples)
    ranking[j] = to_row_vector(sort_indices_asc(theta[j]));
  for (j in 1:NSamples)
    draws[j] = to_row_vector(head(ranking[j], NDraw));
  for (i in 1:NBalls)
    ball_prob[i] = mean(theta[,i]);
}

