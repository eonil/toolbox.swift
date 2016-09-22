//
//  WeakReferenceSet.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/05/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// This supports removing of a refernce even in the object's `dealloc`.
public struct WeakReferenceSet<T: AnyObject>: Sequence {
    /// Intentionally a dictionary instead of set to support
    /// `remove` in `dealloc`.
    fileprivate var mappings = [ObjectIdentifier: WeakReferenceBox<T>]()
    public init() {
    }
    public var count: Int {
        get { return mappings.count }
    }
    public mutating func insert(_ member: T) {
        mappings[ObjectIdentifier(member)] = WeakReferenceBox(member)
    }
    public mutating func remove(_ member: T) {
        let removed = mappings.removeValue(forKey: ObjectIdentifier(member))
        precondition(removed != nil)
    }
    public func makeIterator() -> AnyIterator<T> {
        var g = mappings.values.makeIterator()
        return AnyIterator {
            if let value = g.next() {
                precondition(value.reference != nil, "Referenced object in a box has been disappeared. Possible logic bug.")
                return value.reference
            }
            return nil
        }
    }
}
//    /// - Returns:
//    ///     Returns removed object.
//    ///     Returns `nil` if you're calling this in `dealloc` of the object,
//    ///     but the removing itelf actually done properly.
//    public mutating func remove(member: T) -> T? {
//        return mappings.removeValueForKey(ObjectIdentifier(member))?.reference
//    }
//}
//public func == <T: AnyObject> (a: WeakReferenceSet<T>, b: WeakReferenceSet<T>) -> Bool {
//    return a.mappings.keys == b.mappings.keys
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private struct WeakReferenceBox<T: AnyObject>: Hashable {
    weak var reference: T?
    init(_ reference: T) {
        self.reference = reference
    }
    fileprivate var hashValue: Int {
        get {
            precondition(reference != nil, "Referenced object in a box has been disappeared. Possible logic bug.")
            return ObjectIdentifier(reference!).hashValue
        }
    }
}
private func == <T: AnyObject> (a: WeakReferenceBox<T>, b: WeakReferenceBox<T>) -> Bool {
    precondition(a.reference != nil, "Referenced object in left box has been disappeared. Possible logic bug.")
    precondition(b.reference != nil, "Referenced object in right box has been disappeared. Possible logic bug.")
    return a.reference! === b.reference!
}













