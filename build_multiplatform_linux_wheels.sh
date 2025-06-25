#!/usr/bin/env bash
set -euxo pipefail

echo "PWD ${PWD}"

rm -rf dist/linux || true
rm -rf build

# Cross-platform way to create a temporary dir.
mytmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')

# Build ARM wheels, put in a temp folder.
docker run --platform=linux/arm64/v8 --rm -v `pwd`:/io \
  -e OUTPUT_DIST=/io/dist/linux/aarch64 \
  quay.io/pypa/manylinux_2_28_aarch64 /io/build-wheels.sh
rm -rf build

# Build x86 wheels, put in a temp folder.
docker run --platform=linux/amd64 --rm -v `pwd`:/io \
  -e OUTPUT_DIST=/io/dist/linux/amd64 \
  quay.io/pypa/manylinux_2_28_x86_64 /io/build-wheels.sh
rm -rf build
