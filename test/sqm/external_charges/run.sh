#!/bin/bash -e

SPDIFF_FLAGS="-r 5.e-5"
GODIFF_FLAGS="-a 0.01"

go_modify() {
    sed -i '' -e '/Electronic energy/d' -e '/^  QMMM/d' -e '/Core-core repulsion/d' -e '/DIPOLE/d' $1
}

source ../../common.sh
