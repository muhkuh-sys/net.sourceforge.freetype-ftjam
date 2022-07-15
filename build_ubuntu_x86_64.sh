#! /bin/bash
set -e

PRJ_DIR=${PWD}

# Set the build folder. All generated content will be below this path.
BUILD_DIR="${PRJ_DIR}/build"
# Here are the patches.
PATCHES="${PRJ_DIR}/patches"

# Create all folders.
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
mkdir -p ${BUILD_DIR}/install

# Unpack the sources.
tar --extract --file ${PRJ_DIR}/ftjam-2.5.2.tar.gz --gzip --directory ${BUILD_DIR}

# Apply patches.
for PATCH in `ls ${PATCHES}`
do
    patch --directory=${BUILD_DIR}/ftjam-2.5.2 --input=${PATCHES}/${PATCH} -p1
done

# Copy the build script.
cp ${PRJ_DIR}/copy_over/CMakeLists.txt ${BUILD_DIR}/ftjam-2.5.2/
cp -R ${PRJ_DIR}/copy_over/cmake ${BUILD_DIR}/ftjam-2.5.2/

# Configure and make
mkdir -p ${BUILD_DIR}/ftjam-2.5.2/build
pushd ${BUILD_DIR}/ftjam-2.5.2/build
cmake ..
make
make test
popd

# Copy the file.
cp ${BUILD_DIR}/ftjam-2.5.2/build/jam ${BUILD_DIR}/install
