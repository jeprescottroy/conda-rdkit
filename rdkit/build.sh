#!/bin/bash

#echo `date "+%Y%m%d"` > $SRC_DIR/__conda_buildnum__.txt

$PYTHON "$RECIPE_DIR/fetch_inchi.py"
$PYTHON "$RECIPE_DIR/fetch_avalontools.py"
PY_INC=`$PYTHON -c "from distutils import sysconfig; print (sysconfig.get_python_inc(0, '$PREFIX'))"`

cmake \
    -D RDK_INSTALL_INTREE=OFF \
    -D RDK_INSTALL_STATIC_LIBS=OFF \
    -D RDK_BUILD_INCHI_SUPPORT=ON \
    -D RDK_BUILD_AVALON_SUPPORT=ON \
    -D RDK_USE_FLEXBISON=OFF \
    -D AVALONTOOLS_DIR=$SRC_DIR/External/AvalonTools/src/SourceDistribution \
    -D CMAKE_SYSTEM_PREFIX_PATH=$PREFIX \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    -D Python_ADDITIONAL_VERSIONS=${PY_VER} \
    -D PYTHON_EXECUTABLE=$PYTHON \
    -D PYTHON_INCLUDE_DIR=${PY_INC} \
    -D PYTHON_NUMPY_INCLUDE_PATH=$SP_DIR/numpy/core/include \
    -D BOOST_ROOT=$PREFIX -D Boost_NO_SYSTEM_PATHS=ON \
    -D CMAKE_BUILD_TYPE=Release \
    .

make

if [[ `uname` == 'Linux' ]]; then
    RDBASE=$SRC_DIR LD_LIBRARY_PATH="$PREFIX/lib;$SRC_DIR/lib" PYTHONPATH=$SRC_DIR make test
fi

make install
