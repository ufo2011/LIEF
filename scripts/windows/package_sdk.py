from setuptools import msvc
import pathlib
import os
import subprocess

env = os.environ

CWD = pathlib.Path(__file__).parent
LIEF_SRC = CWD / ".." / ".."

BUILD_PATH = LIEF_SRC / "build"
BUILD_STATIC_PATH = BUILD_PATH / "static-release"
BUILD_SHARED_PATH = BUILD_PATH / "shared-release"

BUILD_PATH.mkdir(exist_ok=True)
BUILD_STATIC_PATH.mkdir(exist_ok=True)
BUILD_SHARED_PATH.mkdir(exist_ok=True)

arch = 'x64'
ninja_env = msvc.msvc14_get_vc_env(arch)
env.update(ninja_env)

cmake_config_static = [
    "-G", "Ninja",
    "-DLIEF_PYTHON_API=off",
    "-DLIEF_INSTALL_COMPILED_EXAMPLES=on",
    "-DLIEF_USE_CRT_RELEASE=MT",
    "-DCMAKE_BUILD_TYPE=Release",
]

cmake_config_shared = [
    "-G", "Ninja",
    "-DBUILD_SHARED_LIBS=on",
    "-DLIEF_PYTHON_API=off",
    "-DLIEF_INSTALL_COMPILED_EXAMPLES=off",
    "-DLIEF_USE_CRT_RELEASE=MT",
    "-DCMAKE_BUILD_TYPE=Release",
]


build_args = ['--config', 'Release']


configure_cmd = ['cmake', LIEF_SRC.absolute().as_posix()] + cmake_config_shared
print(" ".join(configure_cmd))

subprocess.check_call(configure_cmd, cwd=BUILD_SHARED_PATH.absolute().as_posix(), env=env)
subprocess.check_call(['cmake', '--build', '.', '--target', "all"] + build_args, cwd=BUILD_SHARED_PATH.absolute().as_posix(), env=env)


subprocess.check_call(configure_cmd, cwd=BUILD_STATIC_PATH.absolute().as_posix(), env=env)
subprocess.check_call(['cmake', '--build', '.', '--target', "all"] + build_args, cwd=BUILD_STATIC_PATH.absolute().as_posix(), env=env)

