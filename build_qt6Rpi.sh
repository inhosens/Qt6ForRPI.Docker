#!/bin/bash

# vim: tabstop=4 shiftwidth=4 softtabstop=4
# -*- sh-basic-offset: 4 -*-

set -exuo pipefail

BUILD_TARGET=/opt/qthost-build
SRC=/src/qt6
QT_BRANCH="6.6.1"
DEBIAN_VERSION=$(lsb_release -cs)
MAKE_CORES="$(expr $(nproc) + 2)"
BUILD_TARGET_PI=/opt/qtpi-build

mkdir -p "$BUILD_TARGET_PI"

/usr/games/cowsay -f tux "Building QT version $QT_BRANCH."

function build_qtpi () {

    local STAGING_PREFIX="/opt/qt-raspi"

    mkdir -p "$STAGING_PREFIX"

    pushd "$BUILD_TARGET_PI"

    "$SRC"/configure \
            -confirm-license \
            -release \
            -opengl es2 \
            -nomake tests \
            -qt-host-path /opt/qt-host \
            -extprefix $STAGING_PREFIX \
            -prefix /usr/local/qt6 \
            -skip qtopcua \
            -device linux-rasp-pi4-aarch64 \
            -device-option CROSS_COMPILE=aarch64-linux-gnu- -- \
            -DCMAKE_TOOLCHAIN_FILE=/usr/local/bin/toolchain.cmake \
            -DQT_FEATURE_xcb=ON -DFEATURE_xcb_xlib=ON -DQT_FEATURE_xlib=ON \
            -DQT_FEATURE_egl=ON -DFEATURE_opengl=ON

    /usr/games/cowsay -f tux "Making QT Pi version $QT_BRANCH."
    cmake --build . --parallel "$MAKE_CORES"

    /usr/games/cowsay -f tux "Installing QT Pi version $QT_BRANCH."
    cmake --install .
    popd
}

build_qtpi
