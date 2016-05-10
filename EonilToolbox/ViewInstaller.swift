//
//  ViewInstaller.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/04/22.
//  Copyright © 2016 Eonil. All rights reserved.
//

enum ViewInstallerState {
    case Deinstalling
    case Uninstalled
    case Installing
    case Installed
}
public struct ViewInstaller {
    private(set) var state = ViewInstallerState.Uninstalled
    public init() {
    }
    public mutating func installIfNeeded(@noescape f: ()->()) {
        guard state == .Uninstalled else { return }
        state = .Installing
        f()
        state = .Installed
    }
    public mutating func deinstallIfNeeded(@noescape f: ()->()) {
        guard state == .Installed else { return }
        state = .Deinstalling
        f()
        state = .Uninstalled
    }
}