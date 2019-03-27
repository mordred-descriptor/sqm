#!/bin/bash -e

shopt -s nullglob

TEST_DIR=$(cd $(dirname $BASH_SOURCE); pwd)
export AMBERHOME=$TEST_DIR/..
SQM=$AMBERHOME/bin/sqm
DACDIF=$TEST_DIR/dacdif
SPDIFF="$DACDIF $SPDIFF_FLAGS"
GODIFF="$DACDIF $GODIFF_FLAGS"

SPTESTS=*.sp.in
GOTESTS=*.go.in

# single point tests
for input in $SPTESTS; do
    output=${input%.*}.out
    $SQM -O -i $input -o $output || exit 1
    nkf -Lu --in-place $output
    $SPDIFF $output.save $output
done

# geometry optimization tests
for input in $GOTESTS; do
    output=${input%.*}.out
    $SQM -O -i $input -o $output || exit 1
    nkf -Lu --in-place $output
    type go_modify &> /dev/null && go_modify $output
    $GODIFF $output.save $output
done
