#! /bin/bash

set -ex

export RUN= 

cd ..
make data/results_data.csv

cp lotto/output.json /output
cp data/*.csv /output
