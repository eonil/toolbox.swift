//
//  ObjectID.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/04/27.
//  Copyright © 2016 Eonil. All rights reserved.
//

public struct ObjectID: Hashable {
    private let dummy = Dummy()
    public init() {

    }
    public var hashValue: Int {
        get { return ObjectIdentifier(dummy).hashValue }
    }
}
extension ObjectID: CustomStringConvertible {
    public var description: String {
        get { return "0x" + String(format: "%X", ObjectIdentifier(dummy).uintValue) }
    }
}
extension ObjectID: CustomDebugStringConvertible {
    public var debugDescription: String {
        get { return description }
    }
}
public func ==(a: ObjectID, b: ObjectID) -> Bool {
    return a.dummy === b.dummy
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private final class Dummy: NonObjectiveCBase {
}