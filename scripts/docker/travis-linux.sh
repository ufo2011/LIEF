#!/usr/bin/sh
set -ex

export CXXFLAGS='-ffunction-sections -fdata-sections -fvisibility-inlines-hidden -static-libstdc++ -static-libgcc'
export CFLAGS='-ffunction-sections -fdata-sections -static-libstdc++ -static-libgcc'
export LDFLAGS='-Wl,--gc-sections -Wl,--exclude-libs,ALL'

$PYTHON_BINARY setup.py --ninja --lief-test build \
  bdist_wheel --dist-dir wheel_stage

auditwheel repair -w dist --plat manylinux1_x86_64 wheel_stage/*.whl

mkdir -p build/linux-x86-64/static-release && mkdir -p build/linux-x86-64/shared-release
pushd build/linux-x86-64/shared-release

cmake ../../.. -GNinja \
  -DCMAKE_LINK_WHAT_YOU_USE=on \
  -DBUILD_SHARED_LIBS=on \
  -DLIEF_PYTHON_API=off \
  -DLIEF_INSTALL_COMPILED_EXAMPLES=off \
  -DCMAKE_BUILD_TYPE=Release

ninja

popd
pushd build/linux-x86-64/static-release

cmake ../../.. -GNinja \
  -DCMAKE_LINK_WHAT_YOU_USE=on \
  -DBUILD_SHARED_LIBS=off \
  -DLIEF_PYTHON_API=off \
  -DLIEF_INSTALL_COMPILED_EXAMPLES=on \
  -DCMAKE_BUILD_TYPE=Release

ninja

popd

pushd build/linux-x86-64
cpack --config ../../cmake/cpack.config.cmake
popd

/bin/mv build/linux-x86-64/*.tar.gz build/
ls -alh build

chown -R 1000:1000 build dist wheel_stage
