#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIPO="xcrun -sdk iphoneos lipo"
STRIP="xcrun -sdk iphoneos strip"

SRCDIR=$DIR/luajit-2.1
DESTDIR=$DIR/prebuilt/ios
IXCODE=`xcode-select -print-path`
ISDK=$IXCODE/Platforms/iPhoneOS.platform/Developer
INFOPLIST_PATH=$IXCODE/Platforms/iPhoneOS.platform/version.plist
BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "${INFOPLIST_PATH}")
ISDKVER=iPhoneOS${BUNDLE_ID}.sdk
ISDKP=$IXCODE/usr/bin/

rm "$DESTDIR"/*.a
cd $SRCDIR

make clean
ISDKF="-arch armv7 -isysroot $ISDK/SDKs/$ISDKVER"
make HOST_CC="gcc -m32 -arch i386" TARGET_FLAGS="$ISDKF" TARGET=arm TARGET_SYS=iOS
mv "$SRCDIR"/src/libluajit.a "$DESTDIR"/libluajit-armv7.a

make clean
ISDKF="-arch arm64 -isysroot $ISDK/SDKs/$ISDKVER"
make HOST_CC="gcc" TARGET_FLAGS="$ISDKF" TARGET=arm64 TARGET_SYS=iOS
mv "$SRCDIR"/src/libluajit.a "$DESTDIR"/libluajit-arm64.a

make clean
make CC="gcc -arch x86_64" clean all
mv "$SRCDIR"/src/libluajit.a "$DESTDIR"/libluajit-x86_64.a

$LIPO -create "$DESTDIR"/libluajit-*.a -output "$DESTDIR"/libluajit.a
$STRIP -S "$DESTDIR"/libluajit.a
$LIPO -info "$DESTDIR"/libluajit.a

rm "$DESTDIR"/libluajit-*.a

make clean
