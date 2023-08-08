#!/bin/bash

# Load necessary modules
module load apps/bayestraits apps/bcftools apps/samtools apps/tabix lib/htslib

# Install required Perl modules
module load lang/perl
curl -L https://cpanmin.us | perl - App::cpanminus
cpanm Archive::Zip
cpanm DBD::mysql

