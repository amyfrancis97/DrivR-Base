#!/bin/bash

variantDir="/usr/src/app/example/"
variantFileName="variants.bed"
outputDir=${variantDir}features/

mkdir -p $outputDir

# FG1: Get conservation features
./FG1_conservation/get_conservation2.sh "$variantDir" "$variantFileName" "$outputDir"
