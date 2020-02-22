#! /bin/bash

set -ex

export RUN= 

cd ..
make data/results_data.csv

cp data/*.csv /output
cp lotto/output.json /output
