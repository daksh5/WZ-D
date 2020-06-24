//
//  Utils.swift
//  WizeViewFramework
//
//  Created by Jay Thrash on 8/2/18.
//  Copyright © 2018 picEngn. All rights reserved.
//

import UIKit

public var episodeDateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE MMM d, yyyy"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}

// Rich Black: #000103
// Baby Powder (white): #fffffa
// Gray: #515052
// Green: 86CB92

extension UIColor {
    public static let wv_black = UIColor(red: 0, green: 0.004, blue: 0.012, alpha: 1)
    public static let wv_white = UIColor(red: 1, green: 1, blue: 0.98, alpha: 1)
    public static let wv_gray = UIColor(red: 0.318, green: 0.314, blue: 0.322, alpha: 1)
    public static let wv_lightGray = UIColor(white: 0.9, alpha: 1)
    public static let wv_orange = UIColor(red: 223.0/255.0, green: 77.0/255.0, blue: 51.0/255.0, alpha: 1)
    public static let wv_green = UIColor(red: 0.525, green: 0.796, blue: 0.573, alpha: 1)
}

extension UIImage {
    public static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}

extension UIFont {
    public var smallCaps: UIFont {
        let upperCaseFeature = [
            UIFontDescriptor.FeatureKey.featureIdentifier : kUpperCaseType,
            UIFontDescriptor.FeatureKey.typeIdentifier : kUpperCaseSmallCapsSelector
        ]
        let lowerCaseFeature = [
            UIFontDescriptor.FeatureKey.featureIdentifier : kLowerCaseType,
            UIFontDescriptor.FeatureKey.typeIdentifier : kLowerCaseSmallCapsSelector
        ]
        let features = [upperCaseFeature, lowerCaseFeature]
        let smallCapsDescriptor = self.fontDescriptor.addingAttributes([UIFontDescriptor.AttributeName.featureSettings : features])
        return UIFont(descriptor: smallCapsDescriptor, size: 0)
    }
    
    public var bolded: UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(.traitBold) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }
}

func wrapView(padding: UIEdgeInsets) -> (UIView) -> UIView {
    return { subview in
        let wrapper = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        wrapper.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(
                equalTo: wrapper.leadingAnchor, constant: padding.left
            ),
            subview.rightAnchor.constraint(
                equalTo: wrapper.rightAnchor, constant: -padding.right
            ),
            subview.topAnchor.constraint(
                equalTo: wrapper.topAnchor, constant: padding.top
            ),
            subview.bottomAnchor.constraint(
                equalTo: wrapper.bottomAnchor, constant: -padding.bottom
            ),
            ])
        return wrapper
    }
}

extension UILabel {
    func retrieveTextHeight () -> CGFloat {
        let attributedText = NSAttributedString(string: self.text!,
                                                attributes: [NSAttributedString.Key.font:self.font])
        
        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width,
                                                            height: CGFloat.greatestFiniteMagnitude),
                                               options: .usesLineFragmentOrigin,
                                               context: nil)
        return ceil(rect.size.height)
    }
}
