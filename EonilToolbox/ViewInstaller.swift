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
struct ViewInstaller {
    private(set) var state = ViewInstallerState.Uninstalled
    mutating func installerIfNeeded(@noescape f: ()->()) {
        guard state == .Uninstalled else { return }
        state = .Installing
        f()
        state = .Installed
    }
    mutating func deinstallIfNeeded(@noescape f: ()->()) {
        guard state == .Installed else { return }
        state = .Deinstalling
        f()
        state = .Uninstalled
    }
}