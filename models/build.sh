#! /bin/bash

set -ex

export RUN= 

cd ..

cp /input/nz-lotto-scraper/output.json lotto/output.json
cp /input/nz-lotto-scraper/*.csv data

make models/simulation_model.rds

cp data/*.csv /output
cp models/*.rds /output
