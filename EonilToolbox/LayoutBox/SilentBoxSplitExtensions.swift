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

postfix operator % 
public postfix func %(p: Int) -> SilentBoxPartition {
    return SilentBoxPartition.soft(proportion: CGFloat(p) / 100)
}

/// - TODO: Figure out why `SilentBox.Scalar` causes some error and
///         replace `CGFloat` to `SilentBox.Scalar`.
public enum SilentBoxPartition {
    case rigid(length: CGFloat)
    case soft(proportion: CGFloat)
}
extension SilentBoxPartition: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
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
    var rigidLength: SilentBox.Scalar? {
        switch self {
        case let .rigid(length):    return length
        default:                    return nil
        }
    }
    var softProportion: SilentBox.Scalar? {
        switch self {
        case let .soft(proportion): return proportion
        default:                    return nil
        }
    }
}
public extension SilentBox {
    fileprivate func splitInX<S: Sequence>(_ partitions: S) -> AnySequence<SilentBox> where S.Iterator.Element == CGFloat {
        assert(size.x - partitions.reduce(0, +) > -0.1)
        return AnySequence { () -> AnyIterator<SilentBox> in
            var pg = partitions.makeIterator()
            var budget = self
            return AnyIterator { () -> SilentBox? in
                guard let p = pg.next() else { return nil }
                let (a, b) = budget.splitAtX(budget.min.x + p)
                budget = b
                return a
            }
        }
    }
    fileprivate func splitInY<S: Sequence>(_ partitions: S) -> AnySequence<SilentBox> where S.Iterator.Element == CGFloat {
        assert(size.y - partitions.reduce(0, +) > -0.1)
        return AnySequence { () -> AnyIterator<SilentBox> in
            var pg = partitions.makeIterator()
            var budget = self
            return AnyIterator { () -> SilentBox? in
                guard let p = pg.next() else { return nil }
                let (a, b) = budget.splitAtY(budget.min.y + p)
                budget = b
                return a
            }
        }
    }
    public func splitInX(_ partitions: [SilentBoxPartition]) -> [SilentBox] {
        assert(size.x >= 0)
        let totalRigidLength = partitions.map({ $0.rigidLength ?? 0 }).reduce(0, +)
        let totalProportion = partitions.map({ $0.softProportion ?? 0 }).reduce(0, +)
        let finalTotalCompressedRigidLength = Swift.min(totalRigidLength, size.x)
        let finalRigidCompressionRatio = (finalTotalCompressedRigidLength == 0) ? 0 : (finalTotalCompressedRigidLength / totalRigidLength)
        let softAvailableLength = (totalProportion == 0) ? 0 : ((size.x - finalTotalCompressedRigidLength) / totalProportion)
        let partitionLengths = partitions.map({ (partition: SilentBoxPartition) -> CGFloat in
            switch partition {
            case let .rigid(length):        return length * finalRigidCompressionRatio
            case let .soft(proportion):     return proportion * softAvailableLength
            }
        })
        let occupyingLength = finalTotalCompressedRigidLength + softAvailableLength
        let startingPoint = min.x + (size.x - occupyingLength) / 2
        let budgetArea = splitAtX(startingPoint).max
        return Array(budgetArea.splitInX(partitionLengths))
    }
    public func splitInY(_ partitions: [SilentBoxPartition]) -> [SilentBox] {
        assert(size.y >= 0)
        let totalRigidLength = partitions.map({ $0.rigidLength ?? 0 }).reduce(0, +)
        let totalProportion = partitions.map({ $0.softProportion ?? 0 }).reduce(0, +)
        let finalTotalCompressedRigidLength = Swift.min(totalRigidLength, size.y)
        let finalRigidCompressionRatio = (finalTotalCompressedRigidLength == 0) ? 0 : (finalTotalCompressedRigidLength / totalRigidLength)
        let softAvailableLength = (totalProportion == 0) ? 0 : ((size.y - finalTotalCompressedRigidLength) / totalProportion)
        let partitionLengths = partitions.map({ (partition: SilentBoxPartition) -> CGFloat in
            switch partition {
            case let .rigid(length):        return length * finalRigidCompressionRatio
            case let .soft(proportion):     return proportion * softAvailableLength
            }
        })
        let occupyingLength = finalTotalCompressedRigidLength + softAvailableLength
        let startingPoint = min.y + (size.y - occupyingLength) / 2
        let budgetArea = splitAtY(startingPoint).max
        return Array(budgetArea.splitInY(partitionLengths))
    }
}
extension SilentBox {
    public func splitInX(_ min: SilentBoxPartition, _ mid: SilentBoxPartition, _ max: SilentBoxPartition) -> (min: SilentBox, mid: SilentBox, max: SilentBox) {
        let a = splitInX([min, mid, max])
        return (a[0], a[1], a[2])
    }
    public func splitInY(_ min: SilentBoxPartition, _ mid: SilentBoxPartition, _ max: SilentBoxPartition) -> (min: SilentBox, mid: SilentBox, max: SilentBox) {
        let a = splitInY([min, mid, max])
        return (a[0], a[1], a[2])
    }
//    public func splitInY(_ min: SilentBoxPartition, _ max: SilentBoxPartition) -> (min: SilentBox, max: SilentBox) {
//        let a = splitInY([min, max])
//        return (a[0], a[1])
//    }
}
extension SilentBox {
    public func splitInX<A: SilentBoxPartitionType, B: SilentBoxPartitionType, C: SilentBoxPartitionType>(_ min: A, _ mid: B, _ max: C) -> (min: SilentBox, mid: SilentBox, max: SilentBox) {
        return splitInX(min.toPartition(), mid.toPartition(), max.toPartition())
    }
    public func splitInY<A: SilentBoxPartitionType, B: SilentBoxPartitionType, C: SilentBoxPartitionType>(_ min: A, _ mid: B, _ max: C) -> (min: SilentBox, mid: SilentBox, max: SilentBox) {
        return splitInY(min.toPartition(), mid.toPartition(), max.toPartition())
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










