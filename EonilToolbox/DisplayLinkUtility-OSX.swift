//
//  DisplayLinkUtility.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/04/27.
//  Copyright © 2016 Eonil. All rights reserved.
//

#if os(OSX)
    import Foundation
    import AppKit
    import CoreGraphics
    import CoreVideo
    public enum DisplayLinkError: ErrorProtocol {
        case CannotCreateLink
        case CannotSetLinkCallback
        case CoreVideoError(CVReturn)
    }
    public struct DisplayLinkUtility {
        private typealias Error = DisplayLinkError
        private static var linkWrapper: CVDisplayLinkWrapper?
        private static var handlers = Dictionary<ObjectIdentifier, ()->()>()
        public static func installMainScreenHandler(id: ObjectIdentifier, f: ()->()) throws {
            assertMainThread()
            assert(handlers[id] == nil)

            if handlers.count == 0 {
                linkWrapper = try CVDisplayLinkWrapper()
                guard let linkWrapper = linkWrapper else { throw Error.CannotCreateLink }
                try linkWrapper.start()
            }
            handlers[id] = f
        }
        public static func deinstallMainScreenHandler(id: ObjectIdentifier) {
            assertMainThread()
            assert(handlers[id] != nil)
            handlers[id] = nil

            if handlers.count == 0 {
                assert(linkWrapper != nil)
                do {
                    try linkWrapper?.stop()
                }
                catch let error {
                    fatalError("No way to recover from this error... \(error)")
                }
                linkWrapper = nil
            }
        }
        private static func callback() {
            for (_, h) in handlers {
                h()
            }
        }
    }

    private final class CVDisplayLinkWrapper {
        typealias Error = DisplayLinkError
        let displayLink: CVDisplayLink
        init() throws {
            let displayID = CGMainDisplayID()
            var maybeDisplayLink: CVDisplayLink?
            let createLinkResult = CVDisplayLinkCreateWithCGDisplay(displayID, &maybeDisplayLink)
            guard createLinkResult == kCVReturnSuccess else { throw Error.CoreVideoError(createLinkResult) } // Anything else are treated as an error.
            guard let displayLink = maybeDisplayLink else { throw Error.CoreVideoError(createLinkResult) }
            let setCallbackResult = CVDisplayLinkSetOutputCallback(displayLink, displayLinkDidOutput, nil)
            guard setCallbackResult == kCVReturnSuccess else { throw Error.CoreVideoError(setCallbackResult) }
            self.displayLink = displayLink
        }
        deinit {
        }
        func start() throws {
            let result = CVDisplayLinkStart(displayLink)
            guard result == kCVReturnSuccess else { throw Error.CoreVideoError(result) }
        }
        func stop() throws {
            let result = CVDisplayLinkStop(displayLink)
            guard result == kCVReturnSuccess else { throw Error.CoreVideoError(result) }
        }
    }
    
    private func displayLinkDidOutput(displayLink: CVDisplayLink,
                                      _ inNow: UnsafePointer<CVTimeStamp>,
                                      _ inOutputTime: UnsafePointer<CVTimeStamp>,
                                      _ flagsIn: CVOptionFlags,
                                      _ flagsOut: UnsafeMutablePointer<CVOptionFlags>,
                                      _ displayLinkContext: UnsafeMutablePointer<Void>?) -> CVReturn {

        DisplayLinkUtility.callback()
        return kCVReturnSuccess
    }

#endif






