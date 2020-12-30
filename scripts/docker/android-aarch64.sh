#!/usr/bin/bash
set -ex
apt-get --no-install-recommends install -y ccache

mkdir -p build/android-aarch64 && cd build/android-aarch64

cmake ../.. -GNinja \
  -DLIEF_PYTHON_API=off \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/work/build/android-aarch64/install

ninja install

# Fix permissions
chown -R 1000:1000 /work/build/android-aarch64
