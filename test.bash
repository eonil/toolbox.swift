#! /bin/bash
set -e errexit
set -o pipefail

IOS_DEST="platform=iOS Simulator,name=iPhone 6,OS=10.2"
xcodebuild -scheme EonilToolbox-iOS -destination "$IOS_DEST" -configuration Debug clean build test
xcodebuild -scheme EonilToolbox-iOS -destination "$IOS_DEST" -configuration Release clean build

xcodebuild -scheme EonilToolbox-OSX -configuration Debug clean build test
xcodebuild -scheme EonilToolbox-OSX -configuration Release clean build

