//
//  DivisionViewExtensions.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/06/21.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import UIKit

public extension DivisionView {
    public func addPlaceholderSubview(length: CGFloat) {
        let s = CGSize(width: length, height: length)
        let v = DivisionPlaceholderView(holdingSize: s)
        addSubview(v)
        setPartitionMode(.rigid, for: v)
    }
    public func addSpaceSubview(proportion: CGFloat) {
        let s = CGSize(width: proportion, height: proportion)
        let v = DivisionSpaceView(fittingSize: s)
        addSubview(v)
        setPartitionMode(.soft, for: v)
    }
}
