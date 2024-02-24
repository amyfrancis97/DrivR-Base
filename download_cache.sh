#!/bin/bash
# download_cache.sh

# Download the hg38 cache
perl /opt/vep/src/ensembl-vep/INSTALL.pl -a cf -s homo_sapiens -y GRCh38 --CACHEDIR /data

# Execute the command specified as arguments to this script (e.g., starting a shell)
exec "$@"

