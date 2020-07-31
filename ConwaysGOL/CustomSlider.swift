//
//  CustomSlider.swift
//  ConwaysGOL
//
//  Created by scott harris on 7/30/20.
//

import UIKit

class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: 16))
    }
}
