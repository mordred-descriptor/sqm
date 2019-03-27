#!/bin/bash -e

GODIFF_FLAGS="-a 0.02"

go_modify() {
    sed -i '' -e '/Electronic energy/d' -e '/Core-core repulsion/d' -e '/DIPOLE/d' -e '/xmin/d' -e "/Final Structure/,/Calculation Completed/d" $1
}

source ../../common.sh
