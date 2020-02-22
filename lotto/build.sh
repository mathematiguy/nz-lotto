#! /bin/bash

set -ex

export RUN= 

cd ..
make crawl

cp lotto/output.json /output
