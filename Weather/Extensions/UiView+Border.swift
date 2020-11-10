//
//  ExtensionUiView.swift
//  Weather
//
//  Created by Dmitry on 12.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addTopBorder(color: UIColor, thickness: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: thickness)
        addSubview(border)
    }

    func addBottomBorder(color: UIColor, thickness: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - thickness, width: frame.size.width, height: thickness)
        addSubview(border)
    }
}
