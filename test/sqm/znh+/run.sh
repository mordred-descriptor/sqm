#!/bin/bash -e

GODIFF_FLAGS="-a 0.05"

go_modify() {
    sed -i '' -e '/Electronic energy/d' -e '/QMMM:  /d' -e '/Core-core repulsion/d' -e '/DIPOLE/d' $1
}

source ../../common.sh
