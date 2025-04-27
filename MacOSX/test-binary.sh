#!/bin/bash

export BUILD_RELEASE_DIR=$QMSDEVDIR/build_QMapShack/release
export PROJ_DATA=$(brew --prefix proj)/share/proj
export QT_TRANSLATION_PATH=$(brew --prefix qt)/translations

# Lokale GDAL-Installation einbinden
export GDAL_DATA=$QMSDEVDIR/local/share/gdal
export ROUTINO_LIB_DIR=$QMSDEVDIR/local/lib
export GDAL_DRIVER_PATH=$QMSDEVDIR/local/lib/gdalplugins
export DYLD_LIBRARY_PATH=$QMSDEVDIR/local/lib:$BUILD_RELEASE_DIR/QMapShack.app/Contents/Frameworks
export DYLD_FRAMEWORK_PATH=$BUILD_RELEASE_DIR/QMapShack.app/Contents/Frameworks

$QMSDEVDIR/build_QMapShack/bin/qmapshack -d
