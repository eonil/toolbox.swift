//
//  VersionType.swift
//  Editor4
//
//  Created by Hoon H. on 2016/05/09.
//  Copyright © 2016 Eonil. All rights reserved.
//

/// Represents an unordered version.
public protocol VersionType: Equatable {
    /// Creates a new version that is globally unique in current process scope.
    init()
}
public protocol RevisableVersionType: VersionType {
    mutating func revise()
    func revised() -> Self
}

public protocol VersioningStateType {
    var version: Version { get }
}