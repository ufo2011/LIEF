#!/usr/bin/bash
set -ex

mkdir -p build/linux-aarch64 && cd build/linux-aarch64

export CXXFLAGS='-ffunction-sections -fdata-sections -fvisibility-inlines-hidden -static-libgcc -static-libstdc++'
export LDFLAGS='-Wl,--gc-sections -Wl,--exclude-libs,ALL'


#cmake ../.. -GNinja \
#  -DBUILD_SHARED_LIBS=off \
#  -DLIEF_PYTHON_API=off \
#  -DCMAKE_BUILD_TYPE=Release \
#  -DCMAKE_INSTALL_PREFIX=/work/build/linux-aarch64/install

#ninja install

cmake ../.. -GNinja \
  -DBUILD_SHARED_LIBS=on \
  -DLIEF_PYTHON_API=off \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/work/build/linux-aarch64/install

ninja install

# Fix permissions
chown -R 1000:1000 /work/build/linux-aarch64
