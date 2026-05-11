#!/bin/bash
#
# aligns names with some taxonomy after some preprocessing
#
# usage:
#
#   zcat euroappa.tsv.gz | gunzip | align-names col

set -x
SCRIPT_DIR=$(dirname $0)


taxonomy=${1:-col}
schema=${2:-${SCRIPT_DIR}/source-taxon.properties}

align() {
  nomer replace --properties ${schema} globi-correct \
    | nomer replace --properties ${schema} gbif-parse \
    | nomer replace --properties ${schema} ${taxonomy}
}

align
