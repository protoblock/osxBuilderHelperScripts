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


## fixme gloabal var's
## the .app path 
## Example /Users/satoshi/Desktop/fc/ios/build-ProRoto2016-qt5_6-Release/Applications/ProtoBlock2016/ProtoBlock2016.app
APPFolder=$1

## key to sign with
## EXAMPLE: 3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)
KeyAppliciotnString=$2
## example: 3rd Party Mac Developer Installer: Satoshi Fantasy LLC (TT9VX67592) 
KeyInstallerString=$3

###########
## Sign all the Qt Frameworks and 3rdparty Libs
###########

cd $APPFolder/
## framework files
find Contents  -name "*.framework" -exec codesign --verbose --force --sign $2 {} \;
##dylibs dylib
find Contents  -name "*.dylib" -exec codesign --verbose --force --sign $2 {} \;
## .a
find Contents  -name "*.a" -exec codesign --verbose --force --sign $2 {} \;
## .qml
find Contents  -name "*.qml" -exec codesign --verbose --force --sign $2 {} \;
## qmldir
find Contents  -name "qmldir" -exec codesign --verbose --force --sign $2 {} \;
## .js
find Contents  -name "*.js" -exec codesign --verbose --force --sign $2 {} \;
# *.qmltypes
find Contents  -name "*.qmltypes" -exec codesign --verbose --force --sign $2 {} \;
# .png
find Contents  -name "*.png" -exec codesign --verbose --force --sign $2 {} \;

## cd up a level to sign the app
cd $APPFolder
cd ../

## Sign the app
## With entitlements
#codesign --verbose --force --sign "3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)"  --entitlements ProtoBlock2016.app/Contents/ProtoBlock2016.entitlements ProtoBlock2016.app ;

## without entitlements
codesign --verbose --force --sign $2 ProtoBlock2016.app

## Build the application into a pkg
productbuild --component ProtoBlock2016.app /Applications --sign $3 ProtoBlock2016.pkg

## make sure that it is ok for store
sudo installer -store -pkg ProtoBlock2016.pkg -target /Applications