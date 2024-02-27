#!/bin/bash

parentDir="/opt/vep/.vep/example"
file="${parentDir}/variants_with_driver_stat.bed"

python merge_features.py $file ${parentDir}/features/
