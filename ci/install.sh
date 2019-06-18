#!/bin/bash

set -e

source ./ci/common.sh

EXTENSION=sh
if [[ "$OS_NAME" == Windows ]]; then
    EXTENSION=exe
elif [[ "$OS_NAME" == Linux ]]; then
    sudo apt update -y
    sudo apt install nkf cmake gfortran gcc
elif [[ "$OS_NAME" == MacOSX ]]; then
    brew list gcc &> /dev/null || brew install gcc
    brew list cmake &> /dev/null || brew install cmake
fi

MINICONDA_INSTALLER=Miniconda3-latest-${OS_NAME}-x86_64.$EXTENSION

if [[ ! -f "$MINICONDA_INSTALLER" ]]; then
    info wget -q https://repo.continuum.io/miniconda/$MINICONDA_INSTALLER
else
    rm -rf $HOME/miniconda
fi

if [[ "$OS_NAME" == Windows ]]; then
    cmd.exe /C "$MINICONDA_INSTALLER /InstallationType=JustMe /RegisterPython=0 /S /D=%UserProfile%\\miniconda"
else
    info bash $MINICONDA_INSTALLER -b -p $HOME/miniconda
fi

# setup conda
hash -r

info conda config --set always_yes yes --set changeps1 no
info conda update -y --all

info conda install conda-build anaconda-client
