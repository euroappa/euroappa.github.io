#!/bin/bash 
#
# Generate country level pollinator lists as well as pollinators of Europe

generateCountryLists() {
  cat select-insect-pollinators-of-ireland.sql \
    | duckdb -csv > insect-pollinators-of-ireland.csv

  cat select-insect-pollinators-of-europe.sql \
   | duckdb -csv > insect-pollinators-of-europe.csv 

  cat select-insect-pollinators-of-netherlands.sql \
   | duckdb -csv > insect-pollinators-of-netherlands.csv
}

downloadSnapshot() { 
  curl "https://depot.globalbioticinteractions.org/snapshot/target/data/tsv/interactions.tsv.gz" \
   > interactions.tsv.gz
}

compileEuroAPPA() {
  cat generate-euroappa.sql | duckdb  
}

compileEuroAPPA
downloadSnapshot
generateCountryLists
