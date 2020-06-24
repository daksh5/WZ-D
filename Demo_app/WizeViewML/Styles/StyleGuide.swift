//
//  StyleGuide.swift
//  WizeViewFramework
//

import UIKit
import Overture

extension CGFloat {
    static func wv_grid(_ n: Int) -> CGFloat {
        return CGFloat(n) * 4
    }
}

let generousMargins =
    mut(\UIView.layoutMargins, .init(top: .wv_grid(6), left: .wv_grid(6), bottom: .wv_grid(6), right: .wv_grid(6)))

let tightMargins =
    mut(\UIView.layoutMargins, .init(top: .wv_grid(2), left: .wv_grid(2), bottom: .wv_grid(2), right: .wv_grid(2)))

let autoLayoutStyle = mut(\UIView.translatesAutoresizingMaskIntoConstraints, false)

let verticalStackView = mut(\UIStackView.axis, .vertical)

let baseStackViewStyle = concat(
    generousMargins,
    mut(\UIStackView.spacing, .wv_grid(3)),
    verticalStackView,
    mut(\.isLayoutMarginsRelativeArrangement, true),
    autoLayoutStyle
)

let tightStackViewStyle = concat(
    tightMargins,
    mut(\UIStackView.spacing, .wv_grid(3)),
    verticalStackView,
    mut(\.isLayoutMarginsRelativeArrangement, true),
    autoLayoutStyle
)

let embeddedStackViewStyle = concat(
    mut(\UIStackView.spacing, .wv_grid(3)),
    verticalStackView,
    mut(\.isLayoutMarginsRelativeArrangement, true),
    autoLayoutStyle
)


let bolded: (inout UIFont) -> Void = { $0 = $0.bolded }

let baseTextButtonStyle = concat(
    mut(\UIButton.titleLabel!.font, UIFont.preferredFont(forTextStyle: .subheadline)),
    mver(\UIButton.titleLabel!.font!, bolded)
)

extension UIButton {
    var normalTitleColor: UIColor? {
        get { return self.titleColor(for: .normal) }
        set { self.setTitleColor(newValue, for: .normal) }
    }
}

let secondaryTextButtonStyle = concat(
    baseTextButtonStyle,
    mut(\.normalTitleColor, .black)
)

let primaryTextButtonStyle = concat(
    baseTextButtonStyle,
    mut(\.normalTitleColor, .wv_orange)
)

let baseButtonStyle = concat(
    baseTextButtonStyle,
    mut(\.contentEdgeInsets, .init(top: .wv_grid(2), left: .wv_grid(4), bottom: .wv_grid(2), right: .wv_grid(4)))
)

func roundedStyle(cornerRadius: CGFloat) -> (UIView) -> Void {
    return concat(
        mut(\.layer.cornerRadius, cornerRadius),
        mut(\.layer.masksToBounds, true)
    )
}

let baseRoundedStyle = roundedStyle(cornerRadius: 6)

let baseFilledButtonStyle = concat(
    baseButtonStyle,
    baseRoundedStyle
)

extension UIButton {
    var normalBackgroundImage: UIImage? {
        get { return self.backgroundImage(for: .normal) }
        set { self.setBackgroundImage(newValue, for: .normal) }
    }
}

let primaryButtonStyle = concat(
    baseFilledButtonStyle,
    mut(\.normalBackgroundImage, .from(color: .wv_orange)),
    mut(\.normalTitleColor, .white)
)

let secondaryButtonStyle = concat(
    baseFilledButtonStyle,
    borderStyle(color: UIColor.wv_orange, width: 1),
    mut(\.normalBackgroundImage, .from(color: .wv_white)),
    mut(\.normalTitleColor, .wv_orange)
)

let primaryInvertedButtonStyle = concat(
    baseFilledButtonStyle,
    mut(\.normalBackgroundImage, .from(color: .wv_white)),
    mut(\.normalTitleColor, .wv_orange)
)

let smallCapsLabelStyle = mut(\UILabel.font, UIFont.preferredFont(forTextStyle: .caption1).smallCaps)

func borderStyle(color: UIColor, width: CGFloat) -> (UIView) -> Void {
    return {
        $0.layer.borderColor = color.cgColor
        $0.layer.borderWidth = width
    }
}

let baseTextFieldStyle = concat(
    baseRoundedStyle,
    borderStyle(color: UIColor.wv_white, width: 1)
)

