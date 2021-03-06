#!/bin/bash

export MINICONDA=$HOME/miniconda

if [[ "$TRAVIS_OS_NAME" == osx ]]; then
    export OS_NAME=MacOSX
elif [[ "$TRAVIS_OS_NAME" == linux ]]; then
    export OS_NAME=Linux
elif [[ "$TRAVIS_OS_NAME" == windows ]]; then
    export OS_NAME=Windows
fi

if [[ "$OS_NAME" == Windows ]]; then
    export PYTHONIOENCODING=utf-8
    chcp.com 65001
    export PATH="$MINICONDA:$MINICONDA/Scripts:$MINICONDA/Library/bin:$PATH"
else
    export PATH="$HOME/miniconda/bin:$PATH"
fi

if [[ -z "$TRAVIS_TAG" ]]; then
    ANACONDA_CLOUD_LABEL=dev
    export SQM_VERSION_SUFFIX=b1
else
    ANACONDA_CLOUD_LABEL=main
fi

info() {
    echo ">>> $@"
    "$@"
}

banner() {
    line="=================="
    echo "$line $@ $line"
}
