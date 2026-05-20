#!/bin/bash
#
# takes a generated euroappa csv product and aligns names

set -x

SCRIPT_DIR=$(dirname $0)
DIST_DIR=${SCRIPT_DIR}/../dist

mkdir -p "${DIST_DIR}"

geospatial=${1:-cntr-2024}
catalog=${2:-gbif}

cat <(cat ${DIST_DIR}/euroappa-${geospatial}.csv.gz \
 | gunzip \
 | mlr --icsv --otsvlite cat \
 | head -1) \
 <(cat ${DIST_DIR}/euroappa-${geospatial}.csv.gz \
 | gunzip \
 | mlr --icsv --otsvlite cat \
 | tail -n+2 \
 | bash ${SCRIPT_DIR}/align-names.sh ${catalog} ${SCRIPT_DIR}/source-taxon-parse.properties ${SCRIPT_DIR}/source-taxon.properties \
 | bash ${SCRIPT_DIR}/align-names.sh ${catalog} ${SCRIPT_DIR}/target-taxon-parse.properties ${SCRIPT_DIR}/target-taxon.properties \
 ) \
 | tee ${DIST_DIR}/euroappa-${geospatial}-${catalog}.tsv \
 | mlr --itsvlite --ocsv cat \
 > ${DIST_DIR}/euroappa-${geospatial}-${catalog}.csv

echo "COPY (FROM \"${DIST_DIR}/euroappa-${geospatial}-${catalog}.tsv\") TO \"${DIST_DIR}/euroappa-${geospatial}-${catalog}.parquet\";" | duckdb 
