#!/bin/bash
#
# takes a generated euroappa csv product and aligns names

set -x

geospatial=${1:-cntr-2024}
catalog=${2:-gbif}

cat <(cat euroappa-${geospatial}.csv.gz \
 | gunzip \
 | mlr --icsv --otsvlite cat \
 | head -1) \
 <(cat euroappa-${geospatial}.csv.gz \
 | gunzip \
 | mlr --icsv --otsvlite cat \
 | tail -n+2 \
 | bash align-names.sh ${catalog} source-taxon.properties \
 | bash align-names.sh ${catalog} target-taxon.properties \
 ) \
 | tee euroappa-${geospatial}-${catalog}.tsv \
 | mlr --itsvlite --ocsv cat \
 > euroappa-${geospatial}-${catalog}.csv

echo "COPY (FROM \"euroappa-${geospatial}-${catalog}.tsv\") TO \"euroappa-${geospatial}-${catalog}.parquet\";" | duckdb 
