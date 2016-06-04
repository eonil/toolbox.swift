//
//  InternalUtilityFunctions.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

func assertMainThread() {
    assert(NSThread.isMainThread())
}