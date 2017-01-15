#! /bin/bash
set -e errexit
set -o pipefail

#IOS_DEST="platform=iOS Simulator,name=iPhone 6,OS=latest"
IOS_DEST=id=`instruments -s devices | grep "iPhone" | grep "Simulator" | tail -1 | grep -o "\[.*\]" | tr -d "[]"`
xcodebuild -scheme EonilToolbox-iOS -destination "$IOS_DEST" -configuration Debug clean build test
xcodebuild -scheme EonilToolbox-iOS -destination "$IOS_DEST" -configuration Release clean build

xcodebuild -scheme EonilToolbox-OSX -configuration Debug clean build test
xcodebuild -scheme EonilToolbox-OSX -configuration Release clean build

