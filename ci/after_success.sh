#!/bin/bash

set -e

source ./ci/common.sh

if [[ -n "$ANACONDA_CLOUD_TOKEN" ]]; then
    OUTPUT=`conda build ./conda/sqm --output`
    anaconda -t $ANACONDA_CLOUD_TOKEN upload --label $ANACONDA_CLOUD_LABEL --force $OUTPUT
fi
