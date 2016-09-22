//
//  SilentBox.swift
//  Editor3
//
//  Created by Hoon H. on 2016/01/01.
//  Copyright © 2016 Eonil. All rights reserved.
//

import CoreGraphics

public struct SilentBox: BoxType {
        public typealias Scalar = CGFloat
        public typealias Point = (x: Scalar, y: Scalar)
        fileprivate var box: Box

        public init(min: (x: Scalar, y: Scalar), max: (x: Scalar, y: Scalar)) {
                self.box = Box(min: min, max: max)
        }
        public var min: Point {
                get {
                        return box.min
                }
        }
        public var max: Point {
                get {
                        return box.max
                }
        }
}
// MARK: - Extensions
extension SilentBox {
	/// Returns a new resized box, that is only shrinken.
	/// Larger size input will be clipped to current size.
	public func shrinkenTo(_ newSize: (x: Scalar, y: Scalar)) -> SilentBox {
		let a = Swift.min(self.size.x, newSize.x)
		let b = Swift.min(self.size.y, newSize.y)
		return resizedTo((a,b))
	}
	public func shrinkenXTo(_ newSizeX: Scalar) -> SilentBox {
		return shrinkenTo((newSizeX, size.y))
	}
	public func shrinkenYTo(_ newSizeY: Scalar) -> SilentBox {
		return shrinkenTo((size.x, newSizeY))
	}
	/// Returns a new resized box, that is only grown.
	/// Smaller size input will be ceiled to current size.
	public func grownTo(_ newSize: (x: Scalar, y: Scalar)) -> SilentBox {
		let a = Swift.max(self.size.x, newSize.x)
		let b = Swift.max(self.size.y, newSize.y)
		return resizedTo((a,b))
	}
	public func grownXTo(_ newSizeX: Scalar) -> SilentBox {
		return grownTo((newSizeX, size.y))
	}
	public func grownYTo(_ newSizeY: Scalar) -> SilentBox {
		return grownTo((size.x, newSizeY))
	}
}
// MARK: - Overridins
extension SilentBox {
	public func splitAtX(_ x: Scalar) -> (min: SilentBox, max: SilentBox) {
		guard x >= min.x else { return splitAtX(min.x) }
		guard x <= max.x else { return splitAtX(max.x) }
		let (a,b) = box.splitAtX(x)
		return (a.toSilentBox(), b.toSilentBox())
	}
	public func splitAtY(_ y: Scalar) -> (min: SilentBox, max: SilentBox) {
		guard y >= min.y else { return splitAtY(min.y) }
		guard y <= max.y else { return splitAtY(max.y) }
		let (a,b) = box.splitAtY(y)
		return (a.toSilentBox(), b.toSilentBox())
	}
	public func minXDisplacedTo(_ x: Scalar) -> SilentBox {
		guard x <= max.x else { return minXDisplacedTo(max.x) }
		return box.minXDisplacedTo(x).toSilentBox()
	}
	public func maxXDisplacedTo(_ x: Scalar) -> SilentBox {
		guard x >= min.x else { return maxXDisplacedTo(min.x) }
		return box.maxXDisplacedTo(x).toSilentBox()
	}
	public func minYDisplacedTo(_ y: Scalar) -> SilentBox {
		guard y <= max.y else { return minYDisplacedTo(max.y) }
		return box.minYDisplacedTo(y).toSilentBox()
	}
	public func maxYDisplacedTo(_ y: Scalar) -> SilentBox {
		guard y >= min.y else { return maxYDisplacedTo(min.y) }
		return box.maxYDisplacedTo(y).toSilentBox()
	}
}
extension Box {
        public func toSilentBox() -> SilentBox {
                return SilentBox(min: min, max: max)
        }
}



















