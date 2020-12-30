#!/usr/bin/sh
set -ex

$PYTHON_BINARY setup.py --lief-test --sdk build -j8 \
  bdist_wheel --dist-dir wheel_stage

auditwheel repair -w dist --plat manylinux1_x86_64 wheel_stage/*.whl
chown -R 1000:1000 build dist wheel_stage
