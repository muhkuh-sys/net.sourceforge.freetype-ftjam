#! /bin/bash
set -e

PRJ_DIR=${PWD}

# Set the build folder. All generated content will be below this path.
BUILD_DIR="${PRJ_DIR}/build"

CMAKE_COMPILER="-DCMAKE_C_FLAGS=-m64 -DCMAKE_CXX_FLAGS=-m64 -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++ -DCMAKE_RC_COMPILER=x86_64-w64-mingw32-windres"

# Create all folders.
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
mkdir -p ${BUILD_DIR}/install

# Unpack the sources.
tar --extract --file ${PRJ_DIR}/ftjam-2.5.2.tar.gz --gzip --directory ${BUILD_DIR}

# Copy the build script.
cp ${PRJ_DIR}/copy_over/CMakeLists.txt ${BUILD_DIR}/ftjam-2.5.2/
cp -R ${PRJ_DIR}/copy_over/cmake ${BUILD_DIR}/ftjam-2.5.2/

# Configure and make
mkdir -p ${BUILD_DIR}/ftjam-2.5.2/build
pushd ${BUILD_DIR}/ftjam-2.5.2/build
cmake ${CMAKE_COMPILER} ..
make
make test
popd

# Copy the file.
cp ${BUILD_DIR}/ftjam-2.5.2/build/jam.exe ${BUILD_DIR}/install
