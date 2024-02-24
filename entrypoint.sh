#!/bin/bash
source /opt/conda/etc/profile.d/conda.sh
conda activate DrivR-Base
# Download the hg38 cache
perl /opt/vep/src/ensembl-vep/INSTALL.pl -a cf -s homo_sapiens -y GRCh38 --CACHEDIR /data

# Execute the command specified as arguments to this script (e.g., starting a shell)
exec "$@"

