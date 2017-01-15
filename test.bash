#! /bin/bash
set -e errexit
set -o pipefail

xcodebuild -scheme EonilToolbox-iOS -configuration Debug -sdk iphonesimulator10.0 clean build test
xcodebuild -scheme EonilToolbox-iOS -configuration Release -sdk iphonesimulator10.0 clean build

xcodebuild -scheme EonilToolbox-OSX -configuration Debug clean build test
xcodebuild -scheme EonilToolbox-OSX -configuration Release clean build

