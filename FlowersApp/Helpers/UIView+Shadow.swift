//
//  UIView+Shadow.swift
//  FlowersApp
//
//  Created by Fatima Hasanzade on 07.05.25.
//

import UIKit

extension UIView {
    func applyShadow(
        color: UIColor = .black,
        opacity: Float = 0.1,
        radius: CGFloat = 6,
        offset: CGSize = CGSize(width: 0, height: 4)
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
}
