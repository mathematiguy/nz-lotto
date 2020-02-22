#! /bin/bash

set -ex

export RUN= 

cp /input/nz-lotto-scraper/lotto.json

cd ..
make models/simulation_model.rds

cp data/*.csv /output
cp models/*.rds /output
