#!/bin/bash
#
#

set -x

SCRIPT_DIR=$(dirname $0)

mkdir -p ${SCRIPT_DIR}/../dist


cat ${SCRIPT_DIR}/euroappa.sql \
 | duckdb

cat ${SCRIPT_DIR}/euroappa-h3.sql \
 | duckdb

bash ${SCRIPT_DIR}/align.sh nuts-2021 gbif
bash ${SCRIPT_DIR}/align.sh nuts-2021 col 

bash ${SCRIPT_DIR}/align.sh cntr-2024 gbif
bash ${SCRIPT_DIR}/align.sh cntr-2024 col

