#!/bin/bash

#bash packages
# Load required modules
module load apps/bedops/2.4.38 apps/bedtools/2.30.0 apps/bcftools apps/samtools/1.9 apps/tabix/0.2.5 lib/htslib/1.10.2-gcc apps/bayestraits apps/bcftools apps/samtools apps/tabix lib/htslib lang/perl

# Install required Perl modules
curl -L https://cpanmin.us | perl - App::cpanminus
cpanm --local-lib=~/perl5 local::lib
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
cpanm Archive::Zip
cpanm DBD::mysql
cpanm DBI

