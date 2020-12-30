#!/usr/bin/bash
set -ex

export CXXFLAGS='-ffunction-sections -fdata-sections -fvisibility-inlines-hidden -static-libstdc++ -static-libgcc'
export CFLAGS='-ffunction-sections -fdata-sections -static-libstdc++ -static-libgcc'
export LDFLAGS='-Wl,--gc-sections -Wl,--exclude-libs,ALL'

mkdir -p build/linux-x86-64/static-release && mkdir -p build/linux-x86-64/shared-release
pushd build/linux-x86-64/shared-release

cmake ../../.. -GNinja \
  -DCMAKE_LINK_WHAT_YOU_USE=on \
  -DLIEF_PE=off \
  -DLIEF_ELF=off \
  -DLIEF_ENABLE_JSON=on \
  -DLIEF_OAT=off \
  -DLIEF_DEX=off \
  -DLIEF_VDEX=off \
  -DLIEF_ART=off \
  -DBUILD_SHARED_LIBS=on \
  -DLIEF_PYTHON_API=off \
  -DLIEF_INSTALL_COMPILED_EXAMPLES=off \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$(pwd)/install

ninja

popd
pushd build/linux-x86-64/static-release

cmake ../../.. -GNinja \
  -DCMAKE_LINK_WHAT_YOU_USE=on \
  -DLIEF_PE=off \
  -DLIEF_ELF=off \
  -DLIEF_ENABLE_JSON=on \
  -DLIEF_OAT=off \
  -DLIEF_DEX=off \
  -DLIEF_VDEX=off \
  -DLIEF_ART=off \
  -DBUILD_SHARED_LIBS=off \
  -DLIEF_PYTHON_API=off \
  -DLIEF_INSTALL_COMPILED_EXAMPLES=on \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$(pwd)/install

ninja package

popd
pushd build/linux-x86-64
cpack --config ../../cmake/cpack.config.cmake
popd

/bin/mv build/linux-x86-64/*.tar.gz build/
ls -alh build

# Fix permissions
chown -R 1000:1000 /src/build/linux-x86-64
