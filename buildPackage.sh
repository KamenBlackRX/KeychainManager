#!/bin/zsh

# ------------------------------------
# Configure variable for script
# ------------------------------------

## Common variables
TOOL=xcodebuild
PROJECT_NAME="KeychainManager"
PREFIX_FRAMEWORK="Products/Library/Frameworks"
SOURCE_PATH=$(pwd)

## Variables for build process.
ARCHIVE=archive
PATH_IOS="build/ios.xcarchive"
PATH_IOS_SIMULATOR="build/ios-sim.xcarchive"

## Variables for build process.
PACKAGE=-create-xcframework
PACKAGE_PATH_IOS="$SOURCE_PATH/$PATH_IOS/$PREFIX_FRAMEWORK/$PROJECT_NAME.framework"
PACKAGE_PATH_IOS_SIMULATOR="$SOURCE_PATH/$PATH_IOS_SIMULATOR/$PREFIX_FRAMEWORK/$PROJECT_NAME.framework"
## Output framework
PACKAGE_OUTPUT="build/framework/$PROJECT_NAME.xcframework"

## DEBUG INFO
debug() {
    echo "-- DEBUG --"
    echo ""
    echo "SOURCE_PATH -> $SOURCE_PATH"
    echo "PATH_IOS -> $PATH_IOS"
    echo "PATH_IOS_SIMULATOR -> $PATH_IOS_SIMULATOR"
    echo "PREFIX_FRAMEWORK -> $PREFIX_FRAMEWORK"
    echo "PACKAGE_PATH_IOS -> $PACKAGE_PATH_IOS"
    echo "PACKAGE_PATH_IOS_SIMULATOR -> $PACKAGE_PATH_IOS_SIMULATOR"
    echo ""
    echo "-- END DEBUG --"
}
# ------------------------------------------
# Methods for build framework to platforms.
# -----------------------------------------

##
# Clean build folder
clean_build() {
 rm -rf build
}

##
# Buid framework for work in device.
build_ios() {
     $TOOL $ARCHIVE \
     -scheme $PROJECT_NAME \
     -archivePath "$PATH_IOS" \
     -sdk iphoneos \
     SKIP_INSTALL=NO
}

##
#Buid framework for work in simulator.
build_simulator() { 
    $TOOL $ARCHIVE \
    -scheme $PROJECT_NAME \
    -archivePath "$PATH_IOS_SIMULATOR" \
    -sdk iphonesimulator \
    SKIP_INSTALL=NO
}

##
# Package xcframework for device.
package_ios() {
    $TOOL -create-xcframework \
    -framework $PACKAGE_PATH_IOS \
    -output $PACKAGE_OUTPUT
}
# Package xcframework for simulator.
package_ios_simulator() {
    $TOOL $PACKAGE \
    -framework $PACKAGE_PATH_IOS_SIMULATOR \
    -output $PACKAGE_OUTPUT
}

build_all(){
    build_ios
    build_simulator
}

package_all() {
    $TOOL -create-xcframework \
    -framework $PACKAGE_PATH_IOS \
    -framework $PACKAGE_PATH_IOS_SIMULATOR \
    -output $PACKAGE_OUTPUT
}

# ------------------------------------------
#  Entry point for script.
# -----------------------------------------

## Parse arguments and call responsible methods
case $1 in

"-build-all")
    build_ios
    build_simulator
    ;;

"-build-ios")
   build_ios
   ;;

"-build-simulator")
   build_simulator
   ;;

"-only-package-all")
   build_ios
   build_simulator
   ;;
"-only-package-ios")
   package_ios
   ;;
 "-debug")
   debug
   ;;
"-help")
   echo "Usage: $0 {-build-all|-build-ios|-build-simulator|-only-package-all|-only-package-ios|-only-package-simulator}"
   exit 1
   ;;
 
 *)
    clean_build
    build_all
    package_all
    ;;
esac
