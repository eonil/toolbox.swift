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
    public typealias Color = UIColor
    public typealias Font = UIFont
#endif

#if os(macOS)
    import AppKit
    public typealias Color = NSColor
    public typealias Font = NSFont
#endif

public enum AttributionError: Swift.Error {
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
@available(iOS, introduced: 8.2)
@available(macOS, introduced: 10.11)
public enum FontWeight {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black

    #if os(iOS)
    fileprivate func getNumber() -> CGFloat {
        switch self {
        case .ultraLight:   return UIFontWeightUltraLight
        case .thin:         return UIFontWeightThin
        case .light:        return UIFontWeightLight
        case .regular:      return UIFontWeightRegular
        case .medium:       return UIFontWeightMedium
        case .semibold:     return UIFontWeightSemibold
        case .bold:         return UIFontWeightBold
        case .heavy:        return UIFontWeightHeavy
        case .black:        return UIFontWeightBlack
        }
    }
    #endif
    #if os(macOS)
    fileprivate func getNumber() -> CGFloat {
        switch self {
        case .ultraLight:   return NSFontWeightUltraLight
        case .thin:         return NSFontWeightThin
        case .light:        return NSFontWeightLight
        case .regular:      return NSFontWeightRegular
        case .medium:       return NSFontWeightMedium
        case .semibold:     return NSFontWeightSemibold
        case .bold:         return NSFontWeightBold
        case .heavy:        return NSFontWeightHeavy
        case .black:        return NSFontWeightBlack
        }
    }
    #endif
}



public extension NSAttributedString {
    public func fonted(_ font: Font) -> NSAttributedString {
        return attributed(name: NSFontAttributeName, value: font)
    }
    public func fonted(_ name: String, size: CGFloat) throws -> NSAttributedString {
        guard let font = Font(name: name, size: size) else { throw AttributionError.cannotFindFontFor(name: name, size: size) }
        return fonted(font)
    }
    public func fontedWithSystemFontOf(size: FontSize, bold: Bool = false) -> NSAttributedString {
        let font = bold ? Font.boldSystemFont(ofSize: size.getNumber()) : Font.systemFont(ofSize: size.getNumber())
        return fonted(font)
    }
    @available(iOS, introduced: 8.2)
    @available(macOS, introduced: 10.11)
    public func fontedWithSystemFont(ofSize: CGFloat, weight: CGFloat) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: ofSize, weight: weight)
        return fonted(font)
    }
    @available(iOS, introduced: 8.2)
    @available(macOS, introduced: 10.11)
    public func fontedWithSystemFont(ofSize: CGFloat, weight: FontWeight) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: ofSize, weight: weight.getNumber())
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









