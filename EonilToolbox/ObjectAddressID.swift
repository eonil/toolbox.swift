//
//  ObjectAddressID.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/04/27.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// An ID that is based on object address and unique in current process scope.
///
/// - Note:
///     Current implementation is kind of naive, consumes memory uselessly.
///
public struct ObjectAddressID: Hashable, Comparable {
    fileprivate let dummy = Dummy()
    public init() {}
    public var hashValue: Int {
        get { return ObjectIdentifier(dummy).hashValue }
    }
    /// Same ID always returns same pointer value.
    /// Nothing is guaranteed about what actually is at pointed address. 
    public func asObject() -> AnyObject {
        return dummy
    }
}
extension ObjectAddressID: CustomStringConvertible {
    public var description: String {
        get { return "(ObjectID: 0x" + String(format: "%X", UInt(bitPattern: ObjectIdentifier(dummy))) + ")" }
    }
}
extension ObjectAddressID: CustomDebugStringConvertible {
    public var debugDescription: String {
        get { return description }
    }
}
public func == (_ a: ObjectAddressID, _ b: ObjectAddressID) -> Bool {
    return a.dummy === b.dummy
}
public func < (_ a: ObjectAddressID, _ b: ObjectAddressID) -> Bool {
    return UInt(bitPattern: ObjectIdentifier(a.dummy)) < UInt(bitPattern: ObjectIdentifier(b.dummy))
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private final class Dummy {}
