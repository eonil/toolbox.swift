//
//  AtomicUtilityTypes.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/05/26.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

public enum AtomicError: ErrorType {
    case SwappingFailureBecauseOldValueDoesNotMatch
}






public struct AtomicInt32 {
    private var memory: Int32
    public init(value: Int32) {
        self.memory = value
    }
    public var value: Int32 {
        get { return memory }
    }
    public mutating func compareAndSwapBarrier(newValue: Int32) throws {
        let ok = OSAtomicCompareAndSwap32Barrier(memory, newValue, &memory)
        guard ok else { throw AtomicError.SwappingFailureBecauseOldValueDoesNotMatch }
    }
    public mutating func increment() {
        OSAtomicIncrement32(&memory)
    }
    public mutating func decrement() {
        OSAtomicDecrement32(&memory)
    }
}
public func += (inout a: AtomicInt32, b: AtomicInt32) {
    OSAtomicAdd32Barrier(b.memory, &a.memory)
}
public func + (a: AtomicInt32, b: AtomicInt32) -> AtomicInt32 {
    var c = a
    c += b
    return c
}







public struct AtomicInt64 {
    private var memory: Int64
    public init(value: Int64) {
        self.memory = value
    }
    public var value: Int64 {
        get { return memory }
    }
    public mutating func compareAndSwapBarrier(newValue: Int64) throws {
        let ok = OSAtomicCompareAndSwap64Barrier(memory, newValue, &memory)
        guard ok else { throw AtomicError.SwappingFailureBecauseOldValueDoesNotMatch }
    }
    public mutating func increment() {
        OSAtomicIncrement64(&memory)
    }
    public mutating func decrement() {
        OSAtomicDecrement64(&memory)
    }
}
public func += (inout a: AtomicInt64, b: AtomicInt64) {
    OSAtomicAdd64Barrier(b.memory, &a.memory)
}
public func + (a: AtomicInt64, b: AtomicInt64) -> AtomicInt64 {
    var c = a
    c += b
    return c
}


