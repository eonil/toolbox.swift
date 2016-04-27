//
//  Box.swift
//  Editor3
//
//  Created by Hoon H. on 2016/01/01.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat: BoxScalarType {
}
public struct Box: BoxType {
        public typealias Scalar = CGFloat
        public typealias Point = (x: Scalar, y: Scalar)
        public init(min: Point, max: Point) {
                precondition(min.x <= max.x)
                precondition(min.y <= max.y)
                self.min = min
                self.max = max
        }
        public var min: Point
        public var max: Point
}
public extension CGRect {
        public func toBox() -> Box {
                return Box(center: (midX, midY), size: (width, height))
        }
}


