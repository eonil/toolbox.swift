//
//  ReferenceSet.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/04/30.
//  Copyright © 2016 Eonil. All rights reserved.
//

public struct ReferenceSet<T: AnyObject>: Hashable {
    private var valueSet = Set<ReferenceEqualityBox<T>>()
    public init() {
    }
    public var count: Int {
        get { return valueSet.count }
    }
    public mutating func insert(member: T) {
        valueSet.insert(ReferenceEqualityBox(member))
    }
    public mutating func remove(member: T) -> T? {
        return valueSet.remove(ReferenceEqualityBox(member))?.reference
    }
    public var hashValue: Int {
        get { return valueSet.hashValue }
    }
}
public func == <T: AnyObject> (a: ReferenceSet<T>, b: ReferenceSet<T>) -> Bool {
    return a.valueSet == b.valueSet
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private struct ReferenceEqualityBox<T: AnyObject>: Hashable {
    var reference: T
    init(_ reference: T) {
        self.reference = reference
    }
    private var hashValue: Int {
        get { return ObjectIdentifier(reference).hashValue }
    }
}
private func == <T: AnyObject> (a: ReferenceEqualityBox<T>, b: ReferenceEqualityBox<T>) -> Bool {
    return a.reference === b.reference
}