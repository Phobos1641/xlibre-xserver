#!/bin/bash

set -e

. .github/scripts/util.sh

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

(
#    rm $X11_PREFIX/*.DONE

    mkdir -p $X11_BUILD_DIR
    cd $X11_BUILD_DIR

#    rm -f $X11_PREFIX/xorgproto.DONE
#    build_meson   xorgproto         $(fdo_mirror xorgproto)                    $PKG_XORGPROTO_REF

    echo "=== going to clone piglit ... my cwd is"
    pwd
    clone_source piglit $(fdo_mirror piglit)  $PKG_PIGLIT_REF

    rm -f $X11_PREFIX/xts.DONE
    build_ac_xts  xts   $(fdo_mirror xts)     $PKG_XTS_REF
#    clone_source  xts   $(fdo_mirror xts)     $PKG_XTS_REF
)

mkdir -p $X11_BUILD_DIR/piglit

.github/scripts/meson-build.sh

echo '[xts]' > $X11_BUILD_DIR/piglit/piglit.conf
echo "path=$X11_BUILD_DIR/xts" >> $X11_BUILD_DIR/piglit/piglit.conf

meson test -C "$MESON_BUILDDIR" --print-errorlogs

.github/scripts/check-ddx-build.sh

.github/scripts/manpages-check
