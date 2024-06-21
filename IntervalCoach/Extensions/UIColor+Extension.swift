//
//  UIColor+Extension.swift
//  Coach
//
//  Created by 영현 on 6/18/24.
//

import UIKit

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    static var duringExerciseColor = UIColor(hexCode: "1C84FF")
    static var threeSecondBeforeCompleteExerciseColor = UIColor(hexCode: "6269FF")
    static var twoSecondBeforeCompleteExerciseColor = UIColor(hexCode: "9562FF")
    static var oneSecondBeforeCompleteExerciseColor = UIColor(hexCode: "CD62FF")
    static var duringBreakColor = UIColor(hexCode: "FF62AE")
    static var threeSecondBeforeCompleteBreakColor = oneSecondBeforeCompleteExerciseColor
    static var twoSecondBeforeCompleteBreakColor = twoSecondBeforeCompleteExerciseColor
    static var oneSecondBeforeCompleteBreakColor = threeSecondBeforeCompleteExerciseColor
    static var pauseButtonColor = UIColor(hexCode: "FFD753")
}

