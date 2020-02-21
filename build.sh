#! /bin/bash

set -ex

export RUN= 

make all

cp data/* /output
cp models/* /output
