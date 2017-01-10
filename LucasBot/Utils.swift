//
//  Utils.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/9/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

struct Utils {
    
    static func printFontNamesInSystem() {
        for family in UIFont.familyNames {
            print("*", family);
            
            for name in UIFont.fontNames(forFamilyName: family ) {
                print(name);
            }
        }
    }
    
    static func chatFont() -> UIFont {
        return UIFont(name: "Courier", size: 16.0)!
    }
    
    static func chatBotColor() -> UIColor {
        return UIColor(colorLiteralRed: 119/255, green: 222/255, blue: 8/255, alpha: 1.0)
    }
    
    static func chatUserColor() -> UIColor {
        return UIColor.white
    }
}
