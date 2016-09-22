//
//  ViewInstaller.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/04/22.
//  Copyright © 2016 Eonil. All rights reserved.
//

enum ViewInstallerState {
    case deinstalling
    case uninstalled
    case installing
    case installed
}
public struct ViewInstaller {
    fileprivate(set) var state = ViewInstallerState.uninstalled
    public init() {
    }
    public mutating func installIfNeeded(_ f: ()->()) {
        guard state == .uninstalled else { return }
        state = .installing
        f()
        state = .installed
    }
    public mutating func deinstallIfNeeded(_ f: ()->()) {
        guard state == .installed else { return }
        state = .deinstalling
        f()
        state = .uninstalled
    }
}
