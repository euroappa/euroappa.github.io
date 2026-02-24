#!/bin/bash 
#
# Generate country level pollinator lists as well as pollinators of Europe

set -x 

generateChecklists() {
  cat insect-pollinators-of-ireland.sql \
    | duckdb -csv > insect-pollinators-of-ireland.csv

  cat insect-pollinators-of-europe.sql \
   | duckdb -csv > insect-pollinators-of-europe.csv 

  cat insect-pollinators-of-netherlands.sql \
   | duckdb -csv > insect-pollinators-of-netherlands.csv
}

generateInteractionRecords() {
  cat insect-pollinator-plant-associations-of-ireland.sql \
  | duckdb -csv > insect-pollinator-plant-associations-of-ireland.csv

  cat insect-pollinator-plant-associations-of-netherlands.sql \
  | duckdb -csv > insect-pollinator-plant-associations-of-netherlands.csv
  
  cat insect-pollinator-plant-associations-of-europe.sql \
  | duckdb -csv > insect-pollinator-plant-associations-of-europe.csv
}

downloadSnapshot() { 
  curl "https://depot.globalbioticinteractions.org/snapshot/target/data/tsv/interactions.tsv.gz" \
   > interactions.tsv.gz
}

compileEuroAPPA() {
  cat generate-euroappa.sql | duckdb  
}

#compileEuroAPPA
#downloadSnapshot
generateChecklists
generateInteractionRecords
