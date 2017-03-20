#!/bin/bash
export ELECTRUM_VERSION=$(grep -h ELECTRUM_VERSION lib/version.py |cut -d "'" -f 2)
echo Electrum-DASH $ELECTRUM_VERSION
save_cd=`pwd`

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
# Install some custom requirements on OS X
brew install protobuf zbar upx
# VirtualEnv
if source $HOME/virtualenv/bin/activate; then 
  python --version
else
  rm -rf $HOME/virtualenv
  pip install --upgrade pip virtualenv
  virtualenv --no-site-packages $HOME/virtualenv
  source $HOME/virtualenv/bin/activate
  python --version
fi
export PYTHONPATH=$HOME/virtualenv/lib/python2.7
# Qt
which qmake
if [ "$(which qmake)" == "" ]; then
#wget https://download.qt.io/archive/qt/5.5/5.5.1/submodules/qtbase-opensource-src-5.5.1.tar.gz
#gunzip qtbase-opensource-src-5.5.1.tar.gz
#tar -xf qtbase-opensource-src-5.5.1.tar
#cd qtbase-opensource-src-5.5.1
wget https://download.qt.io/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz
gunzip qt-everywhere-opensource-src-4.8.7.tar.gz
tar -xf qt-everywhere-opensource-src-4.8.7.tar
cd qt-everywhere-opensource-src-4.8.7
./configure -prefix $HOME/virtualenv -release -opensource -confirm-license -nomake examples -nomake tests -nomake demos -no-cups -no-sql-psql -no-sql-sqlite -qt-zlib -qt-libjpeg -qt-libpng -qt-libmng -qt-libtiff -no-qt3support -no-webkit 
make -j4 2>&1 >> /tmp/make_qt.log &
pid=$!
while kill -0 $pid 2>/dev/null
do
  echo -ne '.'
  sleep 1
done
echo Done make.
make install
cd ..
which qmake
fi
# SIP
if [ "$(which sip)" == "" ]; then
wget "https://sourceforge.net/projects/pyqt/files/sip/sip-4.19.1/sip-4.19.1.tar.gz"
tar xzf sip-4.19.1.tar.gz
cd sip-4.19.1
python configure.py --incdir="$(python -c 'import sys; print(sys.prefix)')"/include/python"$PYTHON_VERSION"
make -j4 2>&1 >> /tmp/make_sip.log &
pid=$!
while kill -0 $pid 2>/dev/null
do
  echo -ne '.'
  sleep 1
done
echo Done make.
make install
cd ..
rm -f sip-4.19.1.tar.gz
fi
# PyQt4
if [ "$(which pyrcc4)" == "" ]; then
wget "http://sourceforge.net/projects/pyqt/files/PyQt4/PyQt-4.12/PyQt4_gpl_x11-4.12.tar.gz"
tar xzf PyQt4_gpl_x11-4.12.tar.gz
cd PyQt4_gpl_x11-4.12
python configure.py --verbose --confirm-license --no-designer-plugin --no-qsci-api --no-timestamp
make -j4 2>&1 >> /tmp/make_pyqt4.log &
pid=$!
while kill -0 $pid 2>/dev/null
do
  echo -ne '.'
  sleep 1
done
echo Done make.
make install
cd ..
fi
# Additional pip
pip install dnspython jsonrpclib qrcode pyaes PySocks wheel pytest coverage py2app tox cython
pip install certifi cffi configparser crypto cryptography dnspython ecdsa gi gmpy html http jsonrpclib 
pip install mercurial numpy ordereddict packaging ply pyOpenSSL pyasn1 pyasn1-modules pycparser pycrypto 
pip install setuptools setuptools-svn simplejson wincertstore trezor mock zbar
pip install pygame Pillow buildozer 
USE_OSX_FRAMEWORKS=0 pip install https://github.com/kivy/kivy/archive/master.zip
hash -r
python setup.py sdist
pip install --pre dist/Electrum-*tar.gz
#
else
# Install some custom requirements on Linux
# SIP
if [ "$(which sip)" == "" ]; then
wget "https://sourceforge.net/projects/pyqt/files/sip/sip-4.19.1/sip-4.19.1.tar.gz"
tar xzf sip-4.19.1.tar.gz
cd sip-4.19.1
python configure.py --incdir="$(python -c 'import sys; print(sys.prefix)')"/include/python"$PYTHON_VERSION"
make -j4 2>&1 >> /tmp/make_sip.log &
pid=$!
while kill -0 $pid 2>/dev/null
do
  echo -ne '.'
  sleep 1
done
echo Done make.
make install
cd ..
rm -f sip-4.19.1.tar.gz
fi
# PyQt4
if [ "$(which pyrcc4)" == "" ]; then
wget "http://sourceforge.net/projects/pyqt/files/PyQt4/PyQt-4.12/PyQt4_gpl_x11-4.12.tar.gz"
tar xzf PyQt4_gpl_x11-4.12.tar.gz
cd PyQt4_gpl_x11-4.12
python configure.py --confirm-license --no-designer-plugin --no-qsci-api --no-timestamp
make -j4 2>&1 >> /tmp/make_pyqt4.log &
pid=$!
while kill -0 $pid 2>/dev/null
do
  echo -ne '.'
  sleep 1
done
echo Done make.
make install
cd ..
fi
# Additional pip
pip install --upgrade pip
pip install dnspython jsonrpclib qrcode pyaes PySocks wheel pytest coverage py2app tox cython
pip install certifi cffi configparser crypto cryptography dnspython ecdsa gi html http jsonrpclib 
pip install mercurial numpy ordereddict packaging ply pyOpenSSL pyasn1 pyasn1-modules pycparser pycrypto 
pip install 'setuptools>=19.0.0' setuptools-svn simplejson wincertstore trezor
pip install kivy pygame Pillow protobuf buildozer 
pip install --upgrade protobuf
python setup.py install
#
fi

cd $save_cd
