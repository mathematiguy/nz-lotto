data {
  int<lower = 1> K;
  int<lower = 1> N;
  real<lower = 0> alpha;
  int<lower = 1> results[N];
}

parameters {
  vector[K] theta;
}

model {
  theta ~ dirichlet(rep_vector(alpha, K));
}

generated quantities {
  int<lower = 1> ranking[K];
  ranking = sort_indices_asc(theta);
  results = head(ranking, N);
}
