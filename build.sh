#!/bin/sh

# Script to fetch dependencies to build packages with theos system.
# https://github.com/bitst0rm/AppSync
# Copyright (c) 2014 bitst0rm <bitst0rm@users.noreply.github.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

TOP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMP_DIR=${TOP_DIR}/tmp
THEOS_DIR=${TOP_DIR}/theos

mkdir $TMP_DIR
cd $TMP_DIR

# get dpkg-deb for Mac OS X
echo "Checking for dpkg-deb..."
if [ -z "$(type -P dpkg-deb)" ]; then
	echo "Downloading dpkg-deb..."
	curl -O http://test.saurik.com/francis/dpkg-deb-fat
	chmod a+x dpkg-deb-fat
	echo ""
	echo "Installing dpkg-deb..."
	sudo mkdir -p /usr/local/bin
	sudo mv dpkg-deb-fat /usr/local/bin/dpkg-deb
	if [ -z "$(type -P dpkg-deb)" ]; then
		echo "Fatal: Could not install dpkg-deb."
		exit 1;
	fi
fi

# get ldid for Mac OS X
echo ""
echo "Downloading ldid..."
git clone git://git.saurik.com/ldid.git
cd ldid
git submodule update --init
./make.sh
chmod a+x ldid
mv ./ldid $THEOS_DIR/bin/ldid
cd $TMP_DIR

# get libsubstrate.dylib
echo ""
echo "Downloading MobileSubstrate header and library..."
SUBSTRATE_REPO="http://apt.saurik.com"
curl -OL "${SUBSTRATE_REPO}/cydia/Packages.bz2"
PACKAGE_PATH=$(bzcat Packages.bz2 | grep "debs/mobilesubstrate" | awk '{print $2}')
PACKAGE=$(basename $PACKAGE_PATH)
curl -OL "${SUBSTRATE_REPO}/${PACKAGE_PATH}"

for FILE in $(ar -t "$PACKAGE")
do
  case $FILE in
    data.tar) ar -p "$PACKAGE" data.tar | tar -zxf - ./Library/Frameworks/CydiaSubstrate.framework/Headers/CydiaSubstrate.h ./Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate;;
    data.tar.gz) ar -p "$PACKAGE" data.tar.gz | tar -zxf - ./Library/Frameworks/CydiaSubstrate.framework/Headers/CydiaSubstrate.h ./Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate;;
    data.tar.bz2) ar -p "$PACKAGE" data.tar.bz2 | tar -zxf - ./Library/Frameworks/CydiaSubstrate.framework/Headers/CydiaSubstrate.h ./Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate;;
    data.tar.xz) ar -p "$PACKAGE" data.tar.xz | tar -zxf - ./Library/Frameworks/CydiaSubstrate.framework/Headers/CydiaSubstrate.h ./Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate;;
    data.tar.lzma) ar -p "$PACKAGE" data.tar.lzma | tar -zxf - ./Library/Frameworks/CydiaSubstrate.framework/Headers/CydiaSubstrate.h ./Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate;;
  esac
done
mv ./Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate $THEOS_DIR/lib/libsubstrate.dylib
mv ./Library/Frameworks/CydiaSubstrate.framework/Headers/CydiaSubstrate.h $THEOS_DIR/include/substrate.h
rm -rf ./*.deb
cd $TOP_DIR

# build deb
echo ""
echo "Building package..."
make package
mkdir -p release
mv -f $TMP_DIR/*.deb ./release
make clean
rm -rf $TMP_DIR
rm -rf ./.theos
echo "Done."
