#! /bin/bash

xcodebuild -scheme EonilToolbox-iOS -sdk iphonesimulator build
xcodebuild -scheme EonilToolbox-OSX build test
