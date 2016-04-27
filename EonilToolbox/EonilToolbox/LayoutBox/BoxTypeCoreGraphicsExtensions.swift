//
//  BoxTypeCoreGraphicsExtensions.swift
//  Editor3
//
//  Created by Hoon H. on 2016/01/01.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import CoreGraphics

extension BoxType where Scalar: CGFloatConvertibleBoxScalarType {
        public func toCGRect() -> CGRect {
                return CGRect(
                        x: min.x.toCGFloat(),
                        y: min.y.toCGFloat(),
                        width: size.x.toCGFloat(),
                        height: size.y.toCGFloat())
        }
}
public protocol CGFloatConvertibleBoxScalarType: BoxScalarType {
        init(_ value: CGFloat)
        func toCGFloat() -> CGFloat
}
extension CGFloat:CGFloatConvertibleBoxScalarType {
        public init(_ value: CGFloat) {
                self = value
        }
        public func toCGFloat() -> CGFloat {
                return self
        }
}
