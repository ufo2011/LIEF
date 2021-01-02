#!/usr/bin/bash

# Script to be run with liefproject/manylinux2014-aarch64. Example with Python 3.9:
# ==============================================================================================
# docker run \
#  -e CCACHE_DIR=/ccache \
#  -e PYTHON_BINARY=/opt/python/cp39-cp39/bin/python3.9 \
#  -v $LIEF_SRC:/work \
#  -v $HOME/.ccache:/ccache \
#  --rm liefproject/manylinux2014-aarch64:base bash /work/scripts/docker/manylinux2014-aarch64.sh
# ==============================================================================================
#
set -ex
CXXFLAGS='-static-libgcc -static-libstdc++' \
$PYTHON_BINARY setup.py --ninja \
  build -t /tmp bdist_wheel \
  --plat-name manylinux2014_aarch64

chown -R 1000:1000 /work/dist
chown -R 1000:1000 /work/build
