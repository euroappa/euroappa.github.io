#!/bin/bash
#
# aligns names with catalogue of life after some preprocessing
#
# usage:
#
#   zcat euroappa.csv.gz | gunzip | align-names col

set -x

taxonomy=${1:-col}
schema=${2:-source-taxon.properties}

align() {
  mlr --icsv --otsvlite cat \
    | nomer replace --properties ${schema} globi-correct \
    | nomer replace --properties ${schema} gbif-parse \
    | nomer replace --properties ${schema} ${taxonomy}
}

align
