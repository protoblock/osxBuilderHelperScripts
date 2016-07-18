#!/bin/bash 
#
#
# 88""Yb 88""Yb  dP"Yb  888888  dP"Yb  88""Yb 88      dP"Yb   dP""b8 88  dP 
# 88__dP 88__dP dP   Yb   88   dP   Yb 88__dP 88     dP   Yb dP   `" 88odP  
# 88"""  88"Yb  Yb   dP   88   Yb   dP 88""Yb 88  .o Yb   dP Yb      88"Yb  
# 88     88  Yb  YbodP    88    YbodP  88oodP 88ood8  YbodP   YboodP 88  Yb                                                                                                                       '                   
#
# 080 114 111 116 111 098 108 111 099 107
# 01010000 01110010 01101111 01110100 01101111 01000010 01101100 01101111 01100011 01101011
#
# contact@protoblock.com
#
#
# script to build and send to apples stores

## fixme gloabal var's
## the .app path 
## Example /Users/satoshi/Desktop/fc/ios/build-ProRoto2016-qt5_6-Release/Applications/ProtoBlock2016/ProtoBlock2016.app
APPFolder=$1    
## Qml Dir's 
QMLPLUGINS=$APPFolder/Contents/Resources/qml
## Ending point for libs that are not QMLPLUGINS
LIBSFOLDER=$APPFolder/Contents/Frameworks


## QTDIR this is needed for the macDeployQT
QTDIR=$2

## these are the QML(ONLY) libs that do not get pulled in by macdeployqt
EXQMLLIBSARRAY=($QTDIR/qml/ProRotoQml $QTDIR/qml/Communi $QTDIR/qml/Material $QTDIR/qml/QtQuick/XmlListModel )

## Add more if needed
EXLIBSARRAY=($QTDIR/lib/IrcCore.framework $QTDIR/lib/IrcModel.framework $QTDIR/lib/IrcUtil.framework $QTDIR/lib/libprotoblock-core.1.0.0.dylib )


###########
# use macdepolyqt 
###########

$QTDIR/bin/macdeployqt \
	$APPFolder \
	-qmldir=$QTDIR/qml \
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

echo "Where is the cortrect Info.plist ? followed by [ENTER]:"
read plist

cp $plist $APPFolder/Contents/



echo "Ok all done run stage 2"







