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
schema_parse=${2:-${SCRIPT_DIR}/source-taxon-parse.properties}
schema_align=${2:-${SCRIPT_DIR}/source-taxon.properties}

align() {
  nomer replace --properties ${schema_parse} globi-correct \
    | nomer replace --properties ${schema_parse} gbif-parse \
    | nomer replace --properties ${schema_align} ${taxonomy}
}

align
