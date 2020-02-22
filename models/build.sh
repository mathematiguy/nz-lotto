#! /bin/bash

set -ex

export RUN= 

cp /input/nz-lotto-scraper/output.json lotto/output.json
cp /input/nz-lotto-scraper/*.csv data

cd ..
make models/simulation_model.rds

cp data/*.csv /output
cp models/*.rds /output
