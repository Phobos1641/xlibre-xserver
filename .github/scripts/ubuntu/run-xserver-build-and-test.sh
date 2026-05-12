#!/bin/bash

set -e

# . .github/scripts/util.sh

echo "STEP1 X11_BUILD_DIR=$X11_BUILD_DIR"
echo "STEP1 X11_PREFIX=$X11_PREFIX"
echo "STEP1 PATH=$PATH"
echo "STEP1 PKG_CONFIG_PATH=$PKG_CONFIG_PATH"

. .github/scripts/conf.sh

echo "STEP2 X11_BUILD_DIR=$X11_BUILD_DIR"
echo "STEP2 X11_PREFIX=$X11_PREFIX"
echo "STEP2 PATH=$PATH"
echo "STEP2 PKG_CONFIG_PATH=$PKG_CONFIG_PATH"

if [ ! "$X11_BUILD_DIR" ]; then
    echo "missing X11_BUILD_DIR" >&2
    exit 1
fi

if [ ! "$MESON_BUILDDIR" ]; then
    echo "missing MESON_BUILDDIR" >&2
    exit 1
fi

echo "=== X11_BUILD_DIR=$X11_BUILD_DIR"
echo "=== MESON_BUILDDIR=$MESON_BUILDDIR"

export XTEST_DIR="$X11_BUILD_DIR/xts"
export PIGLIT_DIR="$X11_BUILD_DIR/piglit"

.github/scripts/ubuntu/install-prereq.sh

.github/scripts/meson-build.sh

echo '[xts]' > $X11_BUILD_DIR/piglit/piglit.conf
echo "path=$X11_BUILD_DIR/xts" >> $X11_BUILD_DIR/piglit/piglit.conf

meson test -C "$MESON_BUILDDIR" --print-errorlogs

.github/scripts/check-ddx-build.sh

.github/scripts/manpages-check
