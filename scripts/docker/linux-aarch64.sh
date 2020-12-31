#!/usr/bin/bash

set -ex

export CXXFLAGS='-ffunction-sections -fdata-sections -fvisibility-inlines-hidden -static-libgcc -static-libstdc++'
export CFLAGS='-ffunction-sections -fdata-sections -static-libgcc -static-libstdc++'
export LDFLAGS='-Wl,--gc-sections -Wl,--exclude-libs,ALL'

ARCH_DIR="linux-aarch64"

mkdir -p build/$ARCH_DIR/static-release && mkdir -p build/$ARCH_DIR/shared-release
pushd build/$ARCH_DIR/shared-release

cmake ../../.. -GNinja \
  -DCMAKE_LINK_WHAT_YOU_USE=on \
  -DBUILD_SHARED_LIBS=on \
  -DLIEF_PYTHON_API=off \
  -DLIEF_INSTALL_COMPILED_EXAMPLES=off \
  -DCMAKE_BUILD_TYPE=Release

ninja

popd
pushd build/$ARCH_DIR/static-release

cmake ../../.. -GNinja \
  -DCMAKE_LINK_WHAT_YOU_USE=on \
  -DBUILD_SHARED_LIBS=off \
  -DLIEF_PYTHON_API=off \
  -DLIEF_INSTALL_COMPILED_EXAMPLES=on \
  -DCMAKE_BUILD_TYPE=Release

ninja

popd

pushd build/$ARCH_DIR
cpack --config ../../cmake/cpack.config.cmake
popd

/bin/mv build/$ARCH_DIR/*.tar.gz build/

chown -R 1000:1000 build/$ARCH_DIR
