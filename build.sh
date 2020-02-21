#! /bin/bash

set -ex

make all

cp data/* /output
cp models/* /output
