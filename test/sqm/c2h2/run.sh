#!/bin/bash -e

GODIFF_FLAGS="-a 0.01"

go_modify() {
    sed -i '' -e '/Electronic energy/d' -e '/Core-core repulsion/d' $1
}

source ../../common.sh
