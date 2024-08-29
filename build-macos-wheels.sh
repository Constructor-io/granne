#!/usr/bin/env bash
set -euxo pipefail

rm -rf macos_dist || true

# Cross-platform way to create a temporary dir.
mytmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')

pip wheel . -w $mytmpdir --no-deps

delocate-wheel $mytmpdir/*macosx*.whl -w macos_dist/
