//
//  SilentBoxSplitExtensions.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/06/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import CoreGraphics

//postfix operator * {
//}
//postfix func *(p: Int) -> SilentBoxPartition {
//    return SilentBoxPartition.soft(proportion: CGFloat(p))
//}

postfix operator % {
}
public postfix func %(p: Int) -> SilentBoxPartition {
    return SilentBoxPartition.soft(proportion: CGFloat(p) / 100)
}

/// - TODO: Figure out why `SilentBox.Scalar` causes some error and
///         replace `CGFloat` to `SilentBox.Scalar`.
public enum SilentBoxPartition {
    case rigid(length: CGFloat)
    case soft(proportion: CGFloat)
}
extension SilentBoxPartition: IntegerLiteralConvertible, FloatLiteralConvertible {
    public typealias IntegerLiteralType = Int
    public typealias FloatLiteralType = Double
    public init(integerLiteral value: IntegerLiteralType) {
        self = .rigid(length: CGFloat(value))
    }
    public init(floatLiteral value: FloatLiteralType) {
        self = .rigid(length: CGFloat(value))
    }
}
private extension SilentBoxPartition {
    private var rigidLength: SilentBox.Scalar? {
        switch self {
        case let .rigid(length):    return length
        default:                    return nil
        }
    }
    private var softProportion: SilentBox.Scalar? {
        switch self {
        case let .soft(proportion): return proportion
        default:                    return nil
        }
    }
}
public extension SilentBox {
    private func splitInX<S: SequenceType where S.Generator.Element == CGFloat>(partitions: S) -> AnySequence<SilentBox> {
        assert(size.x - partitions.reduce(0, combine: +) > -0.1)
        return AnySequence { () -> AnyGenerator<SilentBox> in
            var pg = partitions.generate()
            var budget = self
            return AnyGenerator { () -> SilentBox? in
                guard let p = pg.next() else { return nil }
                let (a, b) = budget.splitAtX(budget.min.x + p)
                budget = b
                return a
            }
        }
    }
    private func splitInY<S: SequenceType where S.Generator.Element == CGFloat>(partitions: S) -> AnySequence<SilentBox> {
        assert(size.y - partitions.reduce(0, combine: +) > -0.1)
        return AnySequence { () -> AnyGenerator<SilentBox> in
            var pg = partitions.generate()
            var budget = self
            return AnyGenerator { () -> SilentBox? in
                guard let p = pg.next() else { return nil }
                let (a, b) = budget.splitAtY(budget.min.y + p)
                budget = b
                return a
            }
        }
    }
    public func splitInX(partitions: [SilentBoxPartition]) -> [SilentBox] {
        assert(size.x >= 0)
        let totalRigidLength = partitions.map({ $0.rigidLength ?? 0 }).reduce(0, combine: +)
        let totalProportion = partitions.map({ $0.softProportion ?? 0 }).reduce(0, combine: +)
        let finalTotalCompressedRigidLength = Swift.min(totalRigidLength, size.x)
        let finalRigidCompressionRatio = (finalTotalCompressedRigidLength == 0) ? 0 : (finalTotalCompressedRigidLength / totalRigidLength)
        let softAvailableLength = (totalProportion == 0) ? 0 : ((size.x - finalTotalCompressedRigidLength) / totalProportion)
        let partitionLengths = partitions.map({ (partition: SilentBoxPartition) -> CGFloat in
            switch partition {
            case let .rigid(length):        return length * finalRigidCompressionRatio
            case let .soft(proportion):     return proportion * softAvailableLength
            }
        })
        let startingPoint = (size.x - (finalTotalCompressedRigidLength + softAvailableLength)) / 2
        return Array(splitAtX(startingPoint).max.splitInX(partitionLengths))
    }
    public func splitInY(partitions: [SilentBoxPartition]) -> [SilentBox] {
        assert(size.y >= 0)
        let totalRigidLength = partitions.map({ $0.rigidLength ?? 0 }).reduce(0, combine: +)
        let totalProportion = partitions.map({ $0.softProportion ?? 0 }).reduce(0, combine: +)
        let finalTotalCompressedRigidLength = Swift.min(totalRigidLength, size.y)
        let finalRigidCompressionRatio = (finalTotalCompressedRigidLength == 0) ? 0 : (finalTotalCompressedRigidLength / totalRigidLength)
        let softAvailableLength = (totalProportion == 0) ? 0 : ((size.y - finalTotalCompressedRigidLength) / totalProportion)
        let partitionLengths = partitions.map({ (partition: SilentBoxPartition) -> CGFloat in
            switch partition {
            case let .rigid(length):        return length * finalRigidCompressionRatio
            case let .soft(proportion):     return proportion * softAvailableLength
            }
        })
        let startingPoint = (size.y - (finalTotalCompressedRigidLength + softAvailableLength)) / 2
        return Array(splitAtY(startingPoint).max.splitInY(partitionLengths))
    }
}
extension SilentBox {
    public func splitInX(min: SilentBoxPartition, _ center: SilentBoxPartition, _ max: SilentBoxPartition) -> (min: SilentBox, center: SilentBox, max: SilentBox) {
        let a = splitInX([min, center, max])
        return (a[0], a[1], a[2])
    }
    public func splitInY(min: SilentBoxPartition, _ center: SilentBoxPartition, _ max: SilentBoxPartition) -> (min: SilentBox, center: SilentBox, max: SilentBox) {
        let a = splitInY([min, center, max])
        return (a[0], a[1], a[2])
    }
}
extension SilentBox {
    public func splitInX<A: SilentBoxPartitionType, B: SilentBoxPartitionType, C: SilentBoxPartitionType>(min: A, _ center: B, _ max: C) -> (min: SilentBox, center: SilentBox, max: SilentBox) {
        return splitInX(min.toPartition(), center.toPartition(), max.toPartition())
    }
    public func splitInY<A: SilentBoxPartitionType, B: SilentBoxPartitionType, C: SilentBoxPartitionType>(min: A, _ center: B, _ max: C) -> (min: SilentBox, center: SilentBox, max: SilentBox) {
        return splitInY(min.toPartition(), center.toPartition(), max.toPartition())
    }
}





public protocol SilentBoxPartitionType {
    func toPartition() -> SilentBoxPartition
}
extension SilentBoxPartition: SilentBoxPartitionType {
    public func toPartition() -> SilentBoxPartition {
        return self
    }
}
extension CGFloat: SilentBoxPartitionType {
    public func toPartition() -> SilentBoxPartition {
        return .rigid(length: self)
    }
}










