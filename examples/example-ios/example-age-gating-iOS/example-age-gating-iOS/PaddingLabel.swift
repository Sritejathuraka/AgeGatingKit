//
//  PaddingLabel.swift
//  example-age-gating-iOS
//
//  Created by Sriteja Thuraka on 8/19/26.
//

import UIKit

final class PaddingLabel: UILabel {

    var edgeInsets = UIEdgeInsets.zero

    override func drawText(in rect: CGRect) {
        super.drawText(
            in: rect.inset(by: edgeInsets)
        )
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize

        return CGSize(
            width:
                size.width +
                edgeInsets.left +
                edgeInsets.right,
            height:
                size.height +
                edgeInsets.top +
                edgeInsets.bottom
        )
    }
}
