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
    fileprivate func attributed(_ attributes: [String: AnyObject]) -> NSAttributedString {
        let newAttributedString = NSMutableAttributedString(attributedString: self)
        let wholeRange = NSRange(location: 0, length: length)
        newAttributedString.addAttributes(attributes, range: wholeRange)
        return NSAttributedString(attributedString: newAttributedString)
    }
    fileprivate func attributed(name: String, value: AnyObject) -> NSAttributedString {
        return attributed([name: value])
    }
}

#if os(iOS)
    import UIKit
    public extension NSAttributedString {
        public enum Error: Swift.Error {
            case cannotFindFontFor(name: String, size: CGFloat)
        }
        public enum FontSize {
            case system
            case smallSystem
            case label
            case button

            fileprivate func getNumber() -> CGFloat {
                switch self {
                case .system:       return UIFont.systemFontSize
                case .smallSystem:  return UIFont.smallSystemFontSize
                case .label:        return UIFont.labelFontSize
                case .button:       return UIFont.buttonFontSize
                }
            }
        }
        public func fonted(_ font: UIFont) -> NSAttributedString {
            return attributed(name: NSFontAttributeName, value: font)
        }
        public func fonted(_ name: String, size: CGFloat) throws -> NSAttributedString {
            guard let font = UIFont(name: name, size: size) else { throw Error.cannotFindFontFor(name: name, size: size) }
            return fonted(font)
        }
        public func fontedWithSystemFonrOf(size: FontSize, bold: Bool = false) -> NSAttributedString {
            let font = bold ? UIFont.boldSystemFont(ofSize: size.getNumber()) : UIFont.systemFont(ofSize: size.getNumber())
            return fonted(font)
        }
        public func foregroundColored(_ color: UIColor) -> NSAttributedString {
            return attributed(name: NSForegroundColorAttributeName, value: color)
        }
        public func backgorundColored(_ color: UIColor) -> NSAttributedString {
            return attributed(name: NSBackgroundColorAttributeName, value: color)
        }
        public func paragraphStyled(_ paragraphStyle: NSParagraphStyle) -> NSAttributedString {
            return attributed(name: NSParagraphStyleAttributeName, value: (paragraphStyle.copy() as? NSParagraphStyle) ?? NSParagraphStyle())
        }
    }
#endif

#if os(OSX)
    import AppKit
#endif













