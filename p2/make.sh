#!/bin/bash
#
#

set -x

cat euroappa.sql euroappa-h3.sql \
 | duckdb

bash align.sh nuts-2021 gbif
bash align.sh nuts-2021 col 

bash align.sh cntr-2024 gbif
bash align.sh cntr-2024 col

