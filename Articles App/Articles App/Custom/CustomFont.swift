//
//  CustomFont.swift.swift
//  Articles App
//
//  Created by Kirit on 14/10/26.
//


import UIKit

extension UIFont {

    // MARK: - Roboto

    static func robotoRegular(size: CGFloat) -> UIFont {
        customFont("Roboto-Regular", size: size)
    }

    static func robotoBold(size: CGFloat) -> UIFont {
        customFont("Roboto-Bold", size: size)
    }

    static func robotoLight(size: CGFloat) -> UIFont {
        customFont("Roboto-Light", size: size)
    }

    static func robotoMedium(size: CGFloat) -> UIFont {
        customFont("Roboto-Medium", size: size)
    }

    static func robotoSemiBold(size: CGFloat) -> UIFont {
        customFont("Roboto-SemiBold", size: size)
    }

//    static func robotoCondensedBlack(size: CGFloat) -> UIFont {
//        customFont("Roboto_Condensed-Black", size: size)
//    }
    
    static func robotoCondensedBlack(size: CGFloat) -> UIFont {
        customFont("RobotoCondensed-Black", size: size)
    }

    // MARK: - Montserrat

    static func montserratRegular(size: CGFloat) -> UIFont {
        customFont("Montserrat-Regular", size: size)
    }

    static func montserratSemiBold(size: CGFloat) -> UIFont {
        customFont("Montserrat-SemiBold", size: size)
    }

    // MARK: - Private Helper

    private static func customFont(
        _ name: String,
        size: CGFloat
    ) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            assertionFailure(
                "Font '\(name)' not found. Check its registered PostScript name."
            )
            return .systemFont(ofSize: size)
        }

        return font
    }
}



import SwiftUI

extension Font {

    static func robotoRegular(size: CGFloat) -> Font {
        .custom("Roboto-Regular", size: size)
    }

    static func robotoBold(size: CGFloat) -> Font {
        .custom("Roboto-Bold", size: size)
    }

    static func robotoLight(size: CGFloat) -> Font {
        .custom("Roboto-Light", size: size)
    }

    static func robotoMedium(size: CGFloat) -> Font {
        .custom("Roboto-Medium", size: size)
    }

    static func robotoSemiBold(size: CGFloat) -> Font {
        .custom("Roboto-SemiBold", size: size)
    }

    static func robotoCondensedBlack(size: CGFloat) -> Font {
        .custom("RobotoCondensed-Black", size: size)
    }

    static func montserratRegular(size: CGFloat) -> Font {
        .custom("Montserrat-Regular", size: size)
    }

    static func montserratSemiBold(size: CGFloat) -> Font {
        .custom("Montserrat-SemiBold", size: size)
    }
}
