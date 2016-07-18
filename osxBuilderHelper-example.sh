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
# This is a simple example of how to run the osxBuilderHelper scripts
#

osxBuildHelper-stage1.sh \
	$HOME/deploy/ProtoBlock2016.app \
	$HOME/Qt/5.6/clang_64

osxBuildHelper-stage2.sh \
	$HOME/deploy/ProtoBlock2016.app \
	"3rd Party Mac Developer Application: Satoshi Fantasy LLC (TT9VX67592)" \
	"3rd Party Mac Developer Installer: Satoshi Fantasy LLC (TT9VX67592)"

