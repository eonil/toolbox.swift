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
    public enum DisplayLinkError: Error {
        case cannotCreateLink
    }
    public struct DisplayLinkUtility {
        fileprivate typealias Error = DisplayLinkError
        fileprivate static var link: CADisplayLink?
        fileprivate static let proxy = TargetProxy()
        fileprivate static var handlers = Dictionary<ObjectIdentifier, ()->()>()
        public static func installMainScreenHandler(_ id: ObjectIdentifier, f: @escaping ()->()) throws {
            assertMainThread()
            assert(handlers[id] == nil)

            if handlers.count == 0 {
                // `CADisplayLink` retains `target`.
                // So we need a proxy to break retain cycle.
                link = CADisplayLink(target: proxy, selector: #selector(TargetProxy.TOOLBOX_onTick(_:)))
                guard let link = link else { throw Error.cannotCreateLink }
                link.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
                link.add(to: RunLoop.main, forMode: RunLoopMode.UITrackingRunLoopMode)
            }
            handlers[id] = f
        }
        public static func deinstallMainScreenHandler(_ id: ObjectIdentifier) {
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
                link.remove(from: RunLoop.main, forMode: RunLoopMode.UITrackingRunLoopMode)
                link.remove(from: RunLoop.main, forMode: RunLoopMode.commonModes)
            }
        }
        fileprivate static func callback() {
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






