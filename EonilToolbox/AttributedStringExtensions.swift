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
        public typealias Color = UIColor
        public typealias Font = UIFont
    }
#endif

#if os(macOS)
    import AppKit
    public extension NSAttributedString {
        public typealias Color = NSColor
        public typealias Font = NSFont
    }
#endif

public extension NSAttributedString {
    public enum Error: Swift.Error {
        case cannotFindFontFor(name: String, size: CGFloat)
    }
    public enum FontSize {
        #if os(iOS)
        case system
        case smallSystem
        case label
        case button
        fileprivate func getNumber() -> CGFloat {
            switch self {
            case .system:       return Font.systemFontSize
            case .smallSystem:  return Font.smallSystemFontSize
            case .label:        return Font.labelFontSize
            case .button:       return Font.buttonFontSize
            }
        }
        #endif
        #if os(macOS)
        case system
        case smallSystem
        case label
//        case button
        fileprivate func getNumber() -> CGFloat {
            switch self {
            case .system:       return Font.systemFontSize()
            case .smallSystem:  return Font.smallSystemFontSize()
            case .label:        return Font.labelFontSize()
//            case .button:       return Font.buttonFontSize
            }
        }
        #endif
    }
    public func fonted(_ font: Font) -> NSAttributedString {
        return attributed(name: NSFontAttributeName, value: font)
    }
    public func fonted(_ name: String, size: CGFloat) throws -> NSAttributedString {
        guard let font = Font(name: name, size: size) else { throw Error.cannotFindFontFor(name: name, size: size) }
        return fonted(font)
    }
    public func fontedWithSystemFonrOf(size: FontSize, bold: Bool = false) -> NSAttributedString {
        let font = bold ? Font.boldSystemFont(ofSize: size.getNumber()) : Font.systemFont(ofSize: size.getNumber())
        return fonted(font)
    }
    public func foregroundColored(_ color: Color) -> NSAttributedString {
        return attributed(name: NSForegroundColorAttributeName, value: color)
    }
    public func backgorundColored(_ color: Color) -> NSAttributedString {
        return attributed(name: NSBackgroundColorAttributeName, value: color)
    }
    public func paragraphStyled(_ paragraphStyle: NSParagraphStyle) -> NSAttributedString {
        return attributed(name: NSParagraphStyleAttributeName, value: (paragraphStyle.copy() as? NSParagraphStyle) ?? NSParagraphStyle())
    }
}









