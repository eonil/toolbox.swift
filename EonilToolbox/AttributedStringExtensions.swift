//
//  AttributedStringExtensions.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/06/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

public extension String {
    func attributed() -> NSAttributedString {
        return NSAttributedString(string: self)
    }
}

public extension NSAttributedString {
    private func attributed(attributes: [String: AnyObject]) -> NSAttributedString {
        let newAttributedString = NSMutableAttributedString(attributedString: self)
        let wholeRange = NSRange(location: 0, length: length)
        newAttributedString.addAttributes(attributes, range: wholeRange)
        return NSAttributedString(attributedString: newAttributedString)
    }
    private func attributed(name name: String, value: AnyObject) -> NSAttributedString {
        return attributed([name: value])
    }
}

#if os(iOS)
    import UIKit
    public extension NSAttributedString {
        public enum Error: ErrorType {
            case CannotFindFontFor(name: String, size: CGFloat)
        }
        public enum FontSize {
            case System
            case SmallSystem
            case Label
            case Button

            private func getNumber() -> CGFloat {
                switch self {
                case .System:       return UIFont.systemFontSize()
                case .SmallSystem:  return UIFont.smallSystemFontSize()
                case .Label:        return UIFont.labelFontSize()
                case .Button:       return UIFont.buttonFontSize()
                }
            }
        }
        public func fonted(font: UIFont) -> NSAttributedString {
            return attributed(name: NSFontAttributeName, value: font)
        }
        public func fonted(name: String, size: CGFloat) throws -> NSAttributedString {
            guard let font = UIFont(name: name, size: size) else { throw Error.CannotFindFontFor(name: name, size: size) }
            return fonted(font)
        }
        public func fontedWithSystemFonrOf(size size: FontSize, bold: Bool = false) -> NSAttributedString {
            let font = bold ? UIFont.boldSystemFontOfSize(size.getNumber()) : UIFont.systemFontOfSize(size.getNumber())
            return fonted(font)
        }
        public func foregroundColored(color: UIColor) -> NSAttributedString {
            return attributed(name: NSForegroundColorAttributeName, value: color)
        }
        public func backgorundColored(color: UIColor) -> NSAttributedString {
            return attributed(name: NSBackgroundColorAttributeName, value: color)
        }
    }
#endif

#if os(OSX)
    import AppKit
#endif













