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
public enum DivisionViewPartitionMode {
    case rigid
    case soft
}

/// By default, all subviews will be treated as `rigid` box.
/// If you want to put a `soft` box, you have to use a `setPartitionMode` function.
public class DivisionView: UIView {
    private var partitionModeForSubviews = [DivisionViewPartitionMode]()
    private(set) var axis = DivisionViewAxis.vertical

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
                let sz1 = subviews[i].sizeThatFits(sz)
                w += sz1.width
                h = max(sz1.height, h)
            }
            return CGSize(width: w, height: h)

        case .vertical:
            let sz = CGSize(width: size.width, height: CGFloat.max)
            var w = CGFloat(0)
            var h = CGFloat(0)
            for i in 0..<subviews.count {
                let sz1 = subviews[i].sizeThatFits(sz)
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
            var ps1 = [SilentBoxPartition]()
            for i in 0..<subviews.count {
                let v = subviews[i]
                let p = partitionModeForSubviews[i]
                let sz = v.sizeThatFits(CGSize(width: CGFloat.max, height: bounds.height))
                let w = sz.width
                let p1 = {
                    switch p {
                    case .rigid:    return SilentBoxPartition.rigid(length: w)
                    case .soft:     return SilentBoxPartition.soft(proportion: w)
                    }
                }() as SilentBoxPartition
                ps1.append(p1)
            }
            let boxes = box.splitInX(ps1)
            for i in 0..<boxes.count {
                let b = boxes[i]
                subviews[i].frame = b.toCGRect()
            }

        case .vertical:
            var ps1 = [SilentBoxPartition]()
            for i in 0..<subviews.count {
                let v = subviews[i]
                let p = partitionModeForSubviews[i]
                let sz = v.sizeThatFits(CGSize(width: bounds.width, height: CGFloat.max))
                let h = sz.height
                let p1 = {
                    switch p {
                    case .rigid:    return SilentBoxPartition.rigid(length: h)
                    case .soft:     return SilentBoxPartition.soft(proportion: h)
                    }
                }() as SilentBoxPartition
                ps1.append(p1)
            }
            let boxes = box.splitInY(ps1)
            for i in 0..<boxes.count {
                let b = boxes[i]
                subviews[i].frame = b.toCGRect()
            }
        }
    }
}








