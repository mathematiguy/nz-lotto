data {
  int<lower = 1> NBalls;
  int<lower = 1> NDraw;
  real<lower = 0> alpha;
}

generated quantities {
  vector[NBalls] theta = dirichlet_rng(rep_vector(alpha, NBalls));
  int<lower = 1> ranking[NBalls];
  int<lower = 1> draws[NDraw];
  ranking = sort_indices_asc(theta);
  draws = head(ranking, NDraw);
}
