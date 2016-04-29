//
//  ColorExtensions.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/04/29.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import CoreGraphics

protocol ColorUtility {
    associatedtype ColorType
    func darkenBy(ratio: CGFloat) -> ColorType
    func brightenBy(ratio: CGFloat) -> ColorType
    func getHSBA() -> (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat)
}

#if os(iOS)
    import UIKit
    extension UIColor: ColorUtility {
        typealias ColorType = UIColor
        func getHSBA() -> (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
            var (h, s, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
            getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            return (h, s, b, a)
        }
        func darkenBy(ratio: CGFloat) -> UIColor {
            let (h,s,b,a) = getHSBA()
            return UIColor(hue: h, saturation: s, brightness: b * (1-ratio), alpha: a)
        }
        func brightenBy(ratio: CGFloat) -> UIColor {
            let (h,s,b,a) = getHSBA()
            return UIColor(hue: h, saturation: s, brightness: b * (1+ratio), alpha: a)
        }
    }
#endif