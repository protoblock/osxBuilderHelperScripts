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


At the end of this you will be asked for your password.  This is used for the installer tool. See the documentation below for isntaller tools




#### Tools Used


****Install_name_tool****

DESCRIPTION:

       Install_name_tool changes the dynamic shared library install names  and
       or  adds,  changes  or  deletes the rpaths recorded in a Mach-O binary.
       For this tool to work when the install names or rpaths are  larger  the
       binary  should  be  built  with  the ld(1) -headerpad_max_install_names
       option.

see also 
````bash
installer_name_tool
````


****installer****

DESCRIPTION:

The installer command is used to install Mac OS X installer packages to a
specified domain or volume.  The installer command installs a single
package per invocation, which is specified with the -package parameter (
-pkg is accepted as a synonym).  It may be either a single package or a
metapackage.  In the case of the metapackage, the packages which are part
of the default install will be installed unless disqualified by a package's
check tool(s).

see also 
````bash
man installer
````


****macdeployqt****

DESCRIPTION:

The Mac deployment tool can be found in QTDIR/bin/macdeployqt. It is designed to automate the process of creating a deployable application bundle that contains the Qt libraries as private frameworks.



****codesign****

DESCRIPTION:

     The codesign command is used to create, check, and display code signa-
     tures, as well as inquire into the dynamic status of signed code in the
     system.

     codesign requires exactly one operation option to determine what action
     is to be performed, as well as any number of other options to modify its
     behavior. It can act on any number of objects per invocation, but per-
     forms the same operation on all of them.

     codesign accepts single-character (classic) options, as well as GNU-style
     long options of the form --name and --name=value. Common options have
     both forms; less frequent and specialized options have only long form.
     Note that the form --name value (without equal sign) will not work as
     expected on options with optional values.


****productbuild****

DESCRIPTION:

     A product archive is a flat file with a .pkg extension.  productbuild
     creates a deployable product archive, which can be used with the OS X
     Installer, or submitted to the Mac App Store. It has 5 different modes,
     as shown in the SYNOPSIS above:

1.   Create a product archive from a bundle (e.g. for the Mac App Store). If you have a self-contained bundle (e.g. an app) that always gets installed to the same location (e.g.  /Applications), specify the bundle and install path using the --component option. You can spec- ify additional requirements using a PRE-INSTALL REQUIREMENTS PROPERTY LIST.  When you specify a bundle, productbuild automati- cally creates a component package, much like pkgbuild(1), and syn- thesizes a distribution file.
2.   Create a product archive for in-app content. Specify in-app content using the --content option.
3.   Create a product archive from a destination root. When you use xcodebuild(1) with the install action, the result is a destination root, either under /tmp, or in whatever location you specify with the Xcode DSTROOT setting. Use the productbuild --root option to specify that destination root directory and its install path.  You can specify additional requirements using a PRE-INSTALL REQUIREMENTS PROPERTY LIST.  When you specify a root, productbuild automatically creates a component package, much like pkgbuild(1), and synthesizes a distribution file.
4.   Create a product archive using a distribution file. If you have a distribution file, use the --distribution option to specify the path to it, and the --package-path option to specify the directory where the component packages are found (if they are not in the current working directory). All packages referenced by the distribution will be incorporated into the resulting product archive.
5.   Synthesize a distribution for one or more component packages. This also synthesizes a distribution (also using an optional PRE-INSTALL REQUIREMENTS PROPERTY LIST), but writes out the resulting distribution instead of incorporating it into a product archive.  This can serve as a starting point if a more sophisticated distribution is required.

When creating product archives for submission to the Mac App Store, use
only the --component mode of productbuild.  The other modes will create
product archives that are compatible with the OS X Installer, but are not
necessarily acceptable for the Mac App Store.

see also 
````bash 
man productbuild
````
