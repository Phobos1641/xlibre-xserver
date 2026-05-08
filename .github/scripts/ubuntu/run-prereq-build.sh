#!/bin/bash

set -e

if [ ! "$X11_PREFIX" ]; then
    echo "missing X11_PREFIX " >&2
    exit 1
fi

TARBALL=$HOME/x11-prereq.tar.gz

if [ -f "${TARBALL}" ]; then
    echo "Cached tarball existing: skipping rebuild"
fi

.github/scripts/ubuntu/install-prereq.sh

( cd $X11_PREFIX && tar -czf "$TARBALL" * )
