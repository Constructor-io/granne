#!/bin/bash
set -ex

curl https://sh.rustup.rs -sSf | sh -s -- -y
export PATH="$HOME/.cargo/bin:$PATH"

cd /io
mytmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')

for PYBIN in /opt/python/{cp39-cp39,cp310-cp310,cp311-cp311,cp312-cp312,cp313-cp313}/bin; do
    export PYTHON_SYS_EXECUTABLE="$PYBIN/python"

    "${PYBIN}/pip" install -U build
    "${PYBIN}/python" -m build -v -w . -o $mytmpdir
done

for whl in $mytmpdir/*.whl; do
    auditwheel repair "$whl" -w $OUTPUT_DIST
    done
