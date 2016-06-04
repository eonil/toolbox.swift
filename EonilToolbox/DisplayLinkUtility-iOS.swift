//
//  DisplayLinkUtility-iOS.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/06/05.
//  Copyright © 2016 Eonil. All rights reserved.
//

#if os(iOS)
    import Foundation
    import UIKit
    import CoreGraphics
    import CoreVideo
    public enum DisplayLinkError: ErrorType {
        case CannotCreateLink
    }
    public struct DisplayLinkUtility {
        private typealias Error = DisplayLinkError
        private static var link: CADisplayLink?
        private static let proxy = TargetProxy()
        private static var handlers = Dictionary<ObjectIdentifier, ()->()>()
        public static func installMainScreenHandler(id: ObjectIdentifier, f: ()->()) throws {
            assertMainThread()
            assert(handlers[id] == nil)

            if handlers.count == 0 {
                // `CADisplayLink` retains `target`.
                // So we need a proxy to break retain cycle.
                link = CADisplayLink(target: proxy, selector: #selector(TargetProxy.TOOLBOX_onTick(_:)))
                guard let link = link else { throw Error.CannotCreateLink }
                link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
                link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: UITrackingRunLoopMode)
            }
            handlers[id] = f
        }
        public static func deinstallMainScreenHandler(id: ObjectIdentifier) {
            assertMainThread()
            assert(handlers[id] != nil)
            handlers[id] = nil

            if handlers.count == 0 {
                assert(link != nil)
                var moved: CADisplayLink?
                swap(&moved, &link)
                guard let link = moved else {
                    fatalError("Display-link is missing...")
                }
                link.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: UITrackingRunLoopMode)
                link.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
            }
        }
        private static func callback() {
            for (_, h) in handlers {
                h()
            }
        }
    }
    @objc
    private final class TargetProxy: NSObject {
        @objc
        func TOOLBOX_onTick(_: AnyObject?) {
            DisplayLinkUtility.callback()
        }
    }
#endif






