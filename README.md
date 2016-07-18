## OSX Builder Scripts

Run stage 1 then stage 2 

There is a example of how to use called 

````bash
osxBuildHelper-example.sh
````

If you would like to debug these scripts just uncomment the flag 

````bash
#set -x
````




#### Stage One

This is the first thing that happens it takes two arguments 

1. the FULL path to the .app
    - Example:  /Users/someone/deploy/ProtoBlock2016.app
2. The place where Qt is installed and the version with the toolchain
    - Example:  /Qt/5.6/clang_64 ****Important**** Make sure that you do NOT add a / at the end of the path



****IMPORTANT****

At the End of this script you will be asked where the Info.plist is located. This is needed because Qmake is dumb sometimes and does not understand how to not deploy the default Info.plist that comes with Qt



#### Stage Two 

This is where the signing happens and the pkg is made.

This script takes in 3 arguments
1. The full path to the .app
    - Example:  /Users/someone/deploy/ProtoBlock2016.app
2. The ****APPLICATION**** developers key. This must be in quotes
    - Example "3rd Party Mac Developer Application: Satoshi Fantasy LLC (XXXXXXXXXX)"
3. The ****INSTALLERS**** developers key. This must be in quotes
    - Example: "3rd Party Mac Developer Installer: Satoshi Fantasy LLC (XXXXXXXXXX)"


At the end of this you will be asked for your password. This is used for the installer tool. 

