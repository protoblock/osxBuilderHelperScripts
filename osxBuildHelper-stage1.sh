#!/bin/bash 


##script to build and send to apples stores

## fixme gloabal var's
## the .app path 
## Example /Users/satoshi/Desktop/fc/ios/build-ProRoto2016-qt5_6-Release/Applications/ProtoBlock2016/ProtoBlock2016.app
APPFolder=$1    
## Qml Dir's 
QMLPLUGINS=$APPFolder/Contents/Resources/qml
## Ending point for libs that are not QMLPLUGINS
LIBSFOLDER=$APPFolder/Contents/Frameworks

## key to sign with
## EXAMPLE: 3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)
KeyAppliciotnString=$2
## example: 3rd Party Mac Developer Installer: Satoshi Fantasy LLC (TT9VX67592) 
KeyInstallerString=$3

## QTDIR this is needed for the macDeployQT
QTDIR=$4

## these are the QML(ONLY) libs that do not get pulled in by macdeployqt
EXQMLLIBSARRAY=($QTDIR/qml/ProRotoQml $QTDIR/qml/Communi $QTDIR/qml/Material $QTDIR/qml/QtQuick/XmlListModel )

## Add more if needed
EXLIBSARRAY=($QTDIR/lib/IrcCore.framework $QTDIR/lib/IrcModel.framework $QTDIR/lib/IrcUtil.framework $QTDIR/lib/libprotoblock-core.1.0.0.dylib )


###########
# use macdepolyqt 
###########

$QTDIR/bin/macdeployqt \
	$APPFolder \
	-qmldir=$QTDIR/qml
	-verbose=3

############
# copy 3rdparty and misc libs
############


##FIXME
## All Qt plugins and libs for QML depend on such
## Maybe we should move these over then run oTools
## Most system's should have this by default but 
## Some do Not < 10.7 OSX ! 
# /System/Library/Frameworks/OpenGL.framework/Versions/A/OpenGL 
# /System/Library/Frameworks/AGL.framework/Versions/A/AGL 
# /usr/lib/libc++.1.dylib 
# /usr/lib/libSystem.B.dylib 


for i in ${EXQMLLIBSARRAY[@]}; 
do
	cp -r ${i} $QMLPLUGINS/
done


for ii in ${EXLIBSARRAY[@]};
do
	cp -r ${ii} $LIBSFOLDER/
done

##### TODO 
## REMOVE ALL THE DEBUGING LIBS, 



##############
# Run install_name_tool -change on 3rd party libs
##############

## For the IRC mods
cd $QMLPLUGINS/Communi/

install_name_tool -change \
	/Users/satoshi/Qt/5.6/clang_64/lib/IrcUtil.framework/Versions/3/IrcUtil \
	@rpath/IrcUtil.framework/Versions/3/IrcUtil \
	IrcUtil 

install_name_tool -change \
	/Users/satoshi/Qt/5.6/clang_64/lib/IrcModel.framework/Versions/3/IrcIrcModel \
	@rpath/IrcModel.framework/Versions/3/IrcModel \
	IrcModel

install_name_tool -change \
	/Users/satoshi/Qt/5.6/clang_64/lib/IrcCore.framework/Versions/3/IrcCore \
	@rpath/IrcCore.framework/Versions/3/IrcCore \
	IrcCore


## For Lib protoblock-qml plugin
cd $QMLPLUGINS/Protoblock

install_name_tool -change \
	libprotoblock-core.1.dylib \
	@rpath/libprotoblock-core.1.dylib \
	libprotoblock-core.1.dylib

## For some reason levelDB is getting linked into the wrong place (most likly deps.pri)
install_name_tool -change \
	/usr/local/opt/leveldb/lib/libleveldb.1.dylib \
	@rpath/libleveldb.1.dylib

# and at last change up the libprotoblock-core
## Again with the damn leveldb

cd $LIBSFOLDER
install_name_tool -change \
	/usr/local/opt/leveldb/lib/libleveldb.1.dylib \
	@rpath/libleveldb.1.dylib




## FIXME  
## FIX the Info.plist




###########
## Sign all the Qt Frameworks and 3rdparty Libs
###########

cd $APPFolder/

## framework files
find Contents  -name "*.framework" -exec codesign --verbose --force --sign  "3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)" {} \;
##dylibs dylib
find Contents  -name "*.dylib" -exec codesign --verbose --force --sign "3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)" {} \;
## .a
find Contents  -name "*.a" -exec codesign --verbose --force --sign "3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)" {} \;
## .qml
find Contents  -name "*.qml" -exec codesign --verbose --force --sign "3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)" {} \;
## qmldir
find Contents  -name "qmldir" -exec codesign --verbose --force --sign "3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)" {} \;
## .js
find Contents  -name "*.js" -exec codesign --verbose --force --sign "3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)" {} \;
# *.qmltypes
find Contents  -name "*.qmltypes" -exec codesign --verbose --force --sign "3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)" {} \;
# .png
find Contents  -name "*.png" -exec codesign --verbose --force --sign "3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)" {} \;

## cd up a level to sign the app
cd ../

## Sign the app
#codesign --verbose --force --sign "3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)"  --entitlements ProtoBlock2016.app/Contents/ProtoBlock2016.entitlements ProtoBlock2016.app ;

codesign --verbose --force --sign "3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)"  ProtoBlock2016.app

# move up to the build dir ???????
cd ../ 
## Build the application into a pkg
productbuild --component ProtoBlock2016.app /Applications --sign "3rd Party Mac Developer Installer: Satoshi Fantasy LLC (TT9VX67592)" ProtoBlock2016.pkg


## make sure that it is ok for store
sudo installer -store -pkg ProtoBlock2016.pkg -target /Applications



