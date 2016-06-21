//
//  DivisionView.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/06/21.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import UIKit

public enum DivisionViewAxis {
    case horizontal
    case vertical
}
public enum DivisionAlignment {
    case center
    case fill
}
public enum DivisionViewPartitionMode {
    case rigid
    case soft
}

/// By default, all subviews will be treated as `rigid` box.
/// If you want to put a `soft` box, you have to use a `setPartitionMode` function.
/// 
/// Excludes hidden views from layout calculation.
public class DivisionView: UIView {
    private var partitionModeForSubviews = [DivisionViewPartitionMode]()
    public var axis = DivisionViewAxis.vertical {
        didSet {
            setNeedsLayout()
        }
    }
    public var alignment = DivisionAlignment.center {
        didSet {
            setNeedsLayout()
        }
    }

    private func getIndexOfSubview(subview: UIView) -> Int {
        guard let index = subviews.indexOf(subview) else { fatalError("The subview could not be found in `subviews` array.") }
        return index
    }
    public func partitionModeFor(subview subview: UIView) -> DivisionViewPartitionMode {
        precondition(subview.superview === self)
        return partitionModeForSubviews[getIndexOfSubview(subview)]
    }
    public func setPartitionMode(mode: DivisionViewPartitionMode, for subview: UIView) {
        precondition(subview.superview === self)
        partitionModeForSubviews[getIndexOfSubview(subview)] = mode
    }
    /// - Returns:
    ///     The smallest size that can contain all the subviews.
    /// - Note:
    ///     Implementation should avoid depending on *current state* of
    ///     this view. So it does not use `bounds`, `frame` or somthing 
    ///     like that at all to measure fitting size.
    public override func sizeThatFits(size: CGSize) -> CGSize {
        switch axis {
        case .horizontal:
            let sz = CGSize(width: CGFloat.max, height: size.height)
            var w = CGFloat(0)
            var h = CGFloat(0)
            for i in 0..<subviews.count {
                let sz1 = subviews[i].hidden ? CGSize.zero : subviews[i].sizeThatFits(sz)
                w += sz1.width
                h = max(sz1.height, h)
            }
            return CGSize(width: w, height: h)

        case .vertical:
            let sz = CGSize(width: size.width, height: CGFloat.max)
            var w = CGFloat(0)
            var h = CGFloat(0)
            for i in 0..<subviews.count {
                let sz1 = subviews[i].hidden ? CGSize.zero : subviews[i].sizeThatFits(sz)
                w = max(sz1.width, w)
                h += sz1.height
            }
            return CGSize(width: w, height: h)
        }
    }
    public override func didAddSubview(subview: UIView) {
        super.didAddSubview(subview)
        partitionModeForSubviews.insert(.rigid, atIndex: getIndexOfSubview(subview))
    }
    public override func willRemoveSubview(subview: UIView) {
        partitionModeForSubviews.removeAtIndex(getIndexOfSubview(subview))
        super.willRemoveSubview(subview)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        let box = bounds.toBox().toSilentBox()
        switch axis {
        case .horizontal:
            let fit = CGSize(width: CGFloat.max, height: bounds.height)
            var ps1 = [SilentBoxPartition](minimumCapacity: subviews.count)
            var fitszs = [CGSize](minimumCapacity: subviews.count)
            for i in 0..<subviews.count {
                let v = subviews[i]
                let p = partitionModeForSubviews[i]
                let fsz = v.sizeThatFits(fit)
                let w = fsz.width
                let p1 = {
                    guard v.hidden == false else { return .rigid(length: 0) }
                    switch p {
                    case .rigid:    return .rigid(length: w)
                    case .soft:     return .soft(proportion: w)
                    }
                }() as SilentBoxPartition
                ps1.append(p1)
                fitszs.append(fsz)
            }
            let boxes = box.splitInX(ps1)
            for i in 0..<boxes.count {
                var b = boxes[i]
                switch alignment {
                case .center:
                    b = b.shrinkenYTo(fitszs[i].height)
                case .fill:
                    break
                }
                subviews[i].frame = b.toCGRect()
            }

        case .vertical:
            let fit = CGSize(width: bounds.width, height: CGFloat.max)
            var ps1 = [SilentBoxPartition](minimumCapacity: subviews.count)
            var fitszs = [CGSize](minimumCapacity: subviews.count)
            ps1.reserveCapacity(subviews.count)
            fitszs.reserveCapacity(subviews.count)
            for i in 0..<subviews.count {
                let v = subviews[i]
                let p = partitionModeForSubviews[i]
                let fsz = v.sizeThatFits(fit)
                let h = fsz.height
                let p1 = {
                    guard v.hidden == false else { return .rigid(length: 0) }
                    switch p {
                    case .rigid:    return .rigid(length: h)
                    case .soft:     return .soft(proportion: h)
                    }
                }() as SilentBoxPartition
                ps1.append(p1)
                fitszs.append(fsz)
            }
            let boxes = box.splitInY(ps1)
            for i in 0..<boxes.count {
                var b = boxes[i]
                switch alignment {
                case .center:
                    b = b.shrinkenXTo(fitszs[i].width)
                case .fill:
                    break
                }
                subviews[i].frame = b.toCGRect()
            }
        }
    }
}

public final class DivisionPlaceholderView: UIView {
    /// We need to store explicit size to get reliable result
    /// because `frame` will be changed after layout.
    public var holdingSize: CGSize = CGSize.zero {
        didSet {
            setNeedsLayout()
        }
    }
    convenience init(holdingSize: CGSize) {
        self.init()
        self.holdingSize = holdingSize
    }
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return holdingSize
    }
}

public final class DivisionSpaceView: UIView {
    /// We need to store explicit size to get reliable result
    /// because `frame` will be changed after layout.
    let fittingSize: CGSize
    public init(fittingSize: CGSize) {
        self.fittingSize = fittingSize
        super.init(frame: CGRect.zero)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("IB/SB is not supported.")
    }
    public override func sizeThatFits(size: CGSize) -> CGSize {
        return fittingSize
    }
}

private extension Array {
    init(minimumCapacity: Int) {
        self = [Element]()
        reserveCapacity(minimumCapacity)
    }
}






