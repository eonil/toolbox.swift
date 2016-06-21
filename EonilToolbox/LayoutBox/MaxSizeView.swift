//
//  MaxSizeView.swift
//  EonilToolbox
//
//  Created by Hoon H. on 2016/06/21.
//  Copyright © 2016 Eonil. All rights reserved.
//

import Foundation
import UIKit

/// Provides maximum size of all subviews separately in both axis.
/// Also stretches all subviews into size of this view.
public final class MaxSizeView: UIView {
    public var edgeInsets: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            setNeedsLayout()
        }
    }
    /// - Returns:
    ///     Maximum size of contained views separately in both axis.
    public override func sizeThatFits(size: CGSize) -> CGSize {
        let reducedSize = size.reduced(edgeInsets)
        let maxWidth = subviews.map { $0.sizeThatFits(reducedSize).width }.maxElement() ?? 0
        let maxHeight = subviews.map { $0.sizeThatFits(reducedSize).height }.maxElement() ?? 0
        let finalSize = CGSize(width: maxWidth + edgeInsets.width, height: maxHeight + edgeInsets.height)
        return finalSize
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        for v in subviews {
            v.frame = UIEdgeInsetsInsetRect(bounds, edgeInsets)
        }
    }
}

private extension CGSize {
    mutating func reduce(edgeInsets: UIEdgeInsets) {
        width = max(0, width - edgeInsets.width)
        height = max(0, height - edgeInsets.height)
    }
    func reduced(edgeInsets: UIEdgeInsets) -> CGSize {
        var copy = self
        copy.reduce(edgeInsets)
        return copy
    }
}

private extension UIEdgeInsets {
    var width: CGFloat {
        return left + right
    }
    var height: CGFloat {
        return top + bottom
    }
}