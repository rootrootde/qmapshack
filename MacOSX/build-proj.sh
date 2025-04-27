#!/bin/sh

source $QMSDEVDIR/qmapshack/MacOSX/config.sh   # check for important parameters
echo "${ATTN}Building PROJ ...${NC}"
echo "${ATTN}-----------------${NC}"

######################################################################## 
# Build PROJ

PROJ_PKG=proj-9.6.0
PROJ_DATA_PKG=proj-data-1.21
CACHE_DIR="$QMSDEVDIR/.cache"
PROJ_CACHE_DIR="$CACHE_DIR/$PROJ_PKG"
PROJ_DATA_CACHE_DIR="$CACHE_DIR/$PROJ_DATA_PKG"

# Ensure cache directory exists
mkdir -p "$CACHE_DIR"

# Build PROJ
cd $QMSDEVDIR
if [ -d "$PROJ_CACHE_DIR" ]; then
    echo "${ATTN}Using cached PROJ from $PROJ_CACHE_DIR${NC}"
    cp -r "$PROJ_CACHE_DIR" "$QMSDEVDIR/$PROJ_PKG"
else
    echo "${ATTN}Downloading and extracting PROJ...${NC}"
    curl https://download.osgeo.org/proj/$PROJ_PKG.tar.gz | tar xzf -
    echo "${ATTN}Caching PROJ to $PROJ_CACHE_DIR${NC}"
    cp -r "$QMSDEVDIR/$PROJ_PKG" "$PROJ_CACHE_DIR"
fi

# --> folder $QMSVERDIR/$PROJ_PKG/ created
cd $QMSDEVDIR/$PROJ_PKG
mkdir -p build
cd build
$PACKAGES_PATH/bin/cmake .. -DCMAKE_INSTALL_PREFIX=$LOCAL_ENV
$PACKAGES_PATH/bin/cmake --build . -j4
$PACKAGES_PATH/bin/cmake --build . --target install

# Download and extract proj-data
if [ -d "$PROJ_DATA_CACHE_DIR" ]; then
    echo "${ATTN}Using cached proj-data from $PROJ_DATA_CACHE_DIR${NC}"
    cp -r "$PROJ_DATA_CACHE_DIR"/* "$LOCAL_ENV/share/proj"
else
    echo "${ATTN}Downloading and extracting proj-data...${NC}"
    mkdir -p "$LOCAL_ENV/share/proj"
    cd $LOCAL_ENV/share/proj
    curl https://download.osgeo.org/proj/$PROJ_DATA_PKG.tar.gz | tar xzf -
    echo "${ATTN}Caching proj-data to $PROJ_DATA_CACHE_DIR${NC}"
    cp -r "$LOCAL_ENV/share/proj" "$PROJ_DATA_CACHE_DIR"
fi

cd $QMSDEVDIR
