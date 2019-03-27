#!/bin/bash

set -e

source ./ci/common.sh

info conda build ./conda/sqm --no-anaconda-upload
