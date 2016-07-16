//
//  UIKitExtensions.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/04/27.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    public func addChildViewControllerImmediately(_ childViewController: UIViewController) {
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
}

