//
//  AttributedStringExtensions.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/06/16.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation

public extension String {
    func attributed() -> AttributedString {
        return AttributedString(string: self)
    }
}

public extension AttributedString {
    private func attributed(_ attributes: [String: AnyObject]) -> AttributedString {
        let newAttributedString = NSMutableAttributedString(attributedString: self)
        let wholeRange = NSRange(location: 0, length: length)
        newAttributedString.addAttributes(attributes, range: wholeRange)
        return AttributedString(attributedString: newAttributedString)
    }
    private func attributed(name: String, value: AnyObject) -> AttributedString {
        return attributed([name: value])
    }
}

#if os(iOS)
    import UIKit
    public extension AttributedString {
        public enum Error: ErrorProtocol {
            case cannotFindFontFor(name: String, size: CGFloat)
        }
        public enum FontSize {
            case system
            case smallSystem
            case label
            case button

            private func getNumber() -> CGFloat {
                switch self {
                case .system:       return UIFont.systemFontSize()
                case .smallSystem:  return UIFont.smallSystemFontSize()
                case .label:        return UIFont.labelSize()
                case .button:       return UIFont.buttonFontSize()
                }
            }
        }
        public func fonted(_ font: UIFont) -> AttributedString {
            return attributed(name: NSFontAttributeName, value: font)
        }
        public func fonted(_ name: String, size: CGFloat) throws -> AttributedString {
            guard let font = UIFont(name: name, size: size) else { throw Error.cannotFindFontFor(name: name, size: size) }
            return fonted(font)
        }
        public func fontedWithSystemFonrOf(size: FontSize, bold: Bool = false) -> AttributedString {
            let font = bold ? UIFont.boldSystemFont(ofSize: size.getNumber()) : UIFont.systemFont(ofSize: size.getNumber())
            return fonted(font)
        }
        public func foregroundColored(_ color: UIColor) -> AttributedString {
            return attributed(name: NSForegroundColorAttributeName, value: color)
        }
        public func backgorundColored(_ color: UIColor) -> AttributedString {
            return attributed(name: NSBackgroundColorAttributeName, value: color)
        }
        public func paragraphStyled(_ paragraphStyle: NSParagraphStyle) -> AttributedString {
            return attributed(name: NSParagraphStyleAttributeName, value: (paragraphStyle.copy() as? NSParagraphStyle) ?? NSParagraphStyle())
        }
    }
#endif

#if os(OSX)
    import AppKit
#endif













