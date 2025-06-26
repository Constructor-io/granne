#!/usr/bin/env bash
set -euxo pipefail

rm -rf dist/macos/arm64
mkdir -p dist/macos/arm64

trap "rm -rf generated-venv-*" EXIT
python_versions=(3.13 3.12 3.11 3.10 3.9)

mytmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')

for PYTHON_VERSION in "${python_versions[@]}"; do
    export VIRTUAL_ENV="generated-venv-${PYTHON_VERSION}"
    uv venv --python ${PYTHON_VERSION} $VIRTUAL_ENV
    source $VIRTUAL_ENV/bin/activate
    uv pip install build delocate

    python -m build -v -w . -o $mytmpdir
    delocate-wheel $mytmpdir/*macosx*.whl -w dist/macos/arm64/
    rm -rf $mytmpdir
    deactivate
done

rm -rf build
