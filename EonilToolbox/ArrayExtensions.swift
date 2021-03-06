//
//  ArrayExtensions.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/06/17.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// - Note: I'm not sure whether this interfaces are *ideal*.
public extension Array {
    public var entireRange: CountableRange<Index> {
        return startIndex..<endIndex
    }
    func splitFirst() -> (first: Element, ArraySlice<Element>) {
        return self[entireRange].splitFirst()
    }
    func splitLast() -> (ArraySlice<Element>, last: Element) {
        return self[entireRange].splitLast()
    }
}
extension ArraySlice {
    func splitFirst() -> (first: Element, ArraySlice<Element>) {
        switch count {
        case 0:     fatalError("You cannot split an array with no element.")
        default:    return (self[0], self[0..<(count - 1)])
        }
    }
    func splitLast() -> (ArraySlice<Element>, last: Element) {
        switch count {
        case 0:     fatalError("You cannot split an array with no element.")
        default:    return (self[0..<(count - 1)], self[(count - 1)])
        }
    }
}

