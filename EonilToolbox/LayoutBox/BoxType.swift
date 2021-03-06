//
//  BoxType.swift
//  Editor3
//
//  Created by Hoon H. on 2016/01/01.
//  Copyright © 2016 Eonil. All rights reserved.
//

public protocol BoxType {
    associatedtype Scalar: BoxScalarType
    var min: (x: Scalar, y: Scalar) { get }
    var max: (x: Scalar, y: Scalar) { get }
    var center: (x: Scalar, y: Scalar) { get }
    var size: (x: Scalar, y: Scalar) { get }
    init(min: (x: Scalar, y: Scalar), max: (x: Scalar, y: Scalar))
    init(center: (x: Scalar, y: Scalar), size: (x: Scalar, y: Scalar))
}
public protocol BoxScalarType: FloatingPoint, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    static func + (a: Self, b: Self) -> Self
    static func - (a: Self, b: Self) -> Self
    static func * (a: Self, b: Self) -> Self
    static func / (a: Self, b: Self) -> Self
}
extension BoxType {
    public typealias Point = (x: Scalar, y: Scalar)
    public init(center: (x: Scalar, y: Scalar), size: (x: Scalar, y: Scalar)) {
        let minX = (center.x - size.x / 2)
        let minY = (center.y - size.y / 2)
        let maxX = (center.x + size.x / 2)
        let maxY = (center.y + size.y / 2)
        self = Self(min: (minX, minY), max: (maxX, maxY))
    }
    public var center: Point {
        get {
            return (midOf(min.x, max.x), midOf(min.y, max.y))
        }
    }
    public var size: Point {
        get {
            return (max.x - min.x, max.y - min.y)
        }
    }

    public func translatedBy(_ vector: (x: Scalar, y: Scalar)) -> Self {
        return Self(
            min: min + vector,
            max: max + vector)
    }
    public func translatedXBy(_ x: Scalar) -> Self {
        return translatedBy((x, 0))
    }
    public func translatedYBy(_ y: Scalar) -> Self {
        return translatedBy((0, y))
    }
    public func scaledBy(_ ratio: Scalar) -> Self {
        return Self(
            min: min * ratio,
            max: max * ratio)
    }
    /// Returns a new box with new size that resized around center.
    public func resizedTo(_ size: (x: Scalar, y: Scalar)) -> Self {
        return Self(center: center,
                    size: size)
    }
    public func resizedXTo(_ x: Scalar) -> Self {
        return resizedTo((x, size.y))
    }
    public func resizedYTo(_ y: Scalar) -> Self {
        return resizedTo((size.x, y))
    }
    public func splitAtX(_ x: Scalar) -> (min: Self, max: Self) {
        precondition(x >= min.x)
        precondition(x <= max.x)
        let a = Self(min: (min.x, min.y), max: (x, max.y))
        let b = Self(min: (x, min.y), max: (max.x, max.y))
        return (a,b)
    }
    public func splitAtY(_ y: Scalar) -> (min: Self, max: Self) {
        precondition(y >= min.y)
        precondition(y <= max.y)
        let a = Self(min: (min.x, min.y), max: (max.x, y))
        let b = Self(min: (min.x, y), max: (max.x, max.y))
        return (a,b)
    }
    public func splitAtCenterX() -> (min: Self, max: Self) {
        return splitAtX(center.x)
    }
    public func splitAtCenterY() -> (min: Self, max: Self) {
        return splitAtY(center.y)
    }
    public func minXDisplacedTo(_ x: Scalar) -> Self {
        precondition(x <= max.x)
        let a = (x, min.y)
        let b = max
        return Self(min: a, max: b)
    }
    public func maxXDisplacedTo(_ x: Scalar) -> Self {
        precondition(x >= min.x)
        let a = min
        let b = (x, max.y)
        return Self(min: a, max: b)
    }
    public func minYDisplacedTo(_ y: Scalar) -> Self {
        precondition(y <= max.y)
        let a = (min.x, y)
        let b = max
        return Self(min: a, max: b)
    }
    public func maxYDisplacedTo(_ y: Scalar) -> Self {
        precondition(y >= min.y)
        let a = min
        let b = (max.x, y)
        return Self(min: a, max: b)
    }
    public func minXDisplacedBy(_ x: Scalar) -> Self {
        return minXDisplacedTo(min.x + x)
    }
    public func maxXDisplacedBy(_ x: Scalar) -> Self {
        return maxXDisplacedTo(max.x + x)
    }
    public func minYDisplacedBy(_ y: Scalar) -> Self {
        return minYDisplacedTo(min.y + y)
    }
    public func maxYDisplacedBy(_ y: Scalar) -> Self {
        return maxYDisplacedTo(max.y + y)
    }
}
extension BoxType {
    public func minXEdge() -> Self {
        return splitAtX(min.x).min
    }
    public func maxXEdge() -> Self {
        return splitAtX(max.x).max
    }
    public func minYEdge() -> Self {
        return splitAtY(min.y).min
    }
    public func maxYEdge() -> Self {
        return splitAtY(max.y).max
    }
}

















////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
private func + <S: BoxScalarType>(a: (x: S, y: S), b: (x: S, y: S)) -> (x: S, y: S) {
    return (a.x + b.x, a.y + b.y)
}
private func - <S: BoxScalarType>(a: (x: S, y: S), b: (x: S, y: S)) -> (x: S, y: S) {
    return (a.x - b.x, a.y - b.y)
}
private func * <S: BoxScalarType>(a: (x: S, y: S), b: S) -> (x: S, y: S) {
    return (a.x * b, a.y * b)
}
private func / <S: BoxScalarType>(a: (x: S, y: S), b: S) -> (x: S, y: S) {
    return (a.x / b, a.y / b)
}
private func midOf<S: BoxScalarType>(_ a: S, _ b: S) -> S {
    return a + ((b - a) / 2)
}









