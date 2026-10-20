//
//  UIColor+Custom.swift
//  Articles App
//
//  Created by Kirit on 14/10/26.
//

import UIKit

extension UIColor {
    
    static let Color969696 = UIColor(hex: "#969696")
    
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )

        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)

        let red = CGFloat((value >> 16) & 0xFF) / 255.0
        let green = CGFloat((value >> 8) & 0xFF) / 255.0
        let blue = CGFloat(value & 0xFF) / 255.0

        self.init(
            red: red,
            green: green,
            blue: blue,
            alpha: 1.0
        )
    }
}


import SwiftUI

extension Color {

    
    
    static let Color969696 = Color.hex("969696")
    static let Color8C8E98 = Color.hex("8C8E98")

    static func hex(_ hex: String) -> Color {
        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )

        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)

        return Color(
            red: Double((value >> 16) & 0xFF) / 255.0,
            green: Double((value >> 8) & 0xFF) / 255.0,
            blue: Double(value & 0xFF) / 255.0
        )
    }
}
