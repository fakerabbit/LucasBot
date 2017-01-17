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
    
    /*
     * MARK:- FONTS
     */
    
    /*
     * custom:
     * AlphabetPony-Regular
     * Andrea-Normal
     */
    
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
    
    static func LucasFont() -> UIFont {
        return UIFont(name: "AlphabetPony-Regular", size: 75.0)!
    }
    
    static func BotFont() -> UIFont {
        return UIFont(name: "Andrea-Normal", size: 65.0)!
    }
    
    /*
     * MARK:- COLORS
     */
    
    static func backgroundColor() -> UIColor {
        return UIColor(colorLiteralRed: 28/255, green: 35/255, blue: 41/255, alpha: 1.0)
    }
    
    static func lucasColor() -> UIColor {
        return UIColor(colorLiteralRed: 40/255, green: 161/255, blue: 255/255, alpha: 1.0)
    }
    
    static func botColor() -> UIColor {
        return UIColor(colorLiteralRed: 119/255, green: 222/255, blue: 8/255, alpha: 1.0)
    }
    
    static func chatBotColor() -> UIColor {
        return UIColor(colorLiteralRed: 119/255, green: 222/255, blue: 8/255, alpha: 1.0)
    }
    
    static func chatUserColor() -> UIColor {
        return UIColor.white
    }
    
    static func redColor() -> UIColor {
        return UIColor(colorLiteralRed: 237/255, green: 20/255, blue: 91/255, alpha: 1.0)
    }
    
    /*
     * MARK:- IMAGES
     */
    
    static let kDefaultGif:String = "typing"
}
