#! /bin/bash

xcodebuild -scheme EonilToolbox-iOS -sdk iphonesimulator10.0 build
xcodebuild -scheme EonilToolbox-OSX build test
