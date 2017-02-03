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
     ** Avenir
     Avenir-Medium
     Avenir-HeavyOblique
     Avenir-Book
     Avenir-Light
     Avenir-Roman
     Avenir-BookOblique
     Avenir-MediumOblique
     Avenir-Black
     Avenir-BlackOblique
     Avenir-Heavy
     Avenir-LightOblique
     Avenir-Oblique
     
     ** San Francisco Display
     SanFranciscoDisplay-Regular
     SanFranciscoDisplay-Light
     SanFranciscoDisplay-Medium
     SanFranciscoDisplay-Bold
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
        return UIFont(name: "SanFranciscoDisplay-Regular", size: 18.0)!
    }
    
    static func LucasFont() -> UIFont {
        return UIFont(name: "Avenir-Roman", size: 50.0)!
    }
    
    static func BotFont() -> UIFont {
        return UIFont(name: "Avenir-Roman", size: 50.0)!
    }
    
    static func buttonFont() -> UIFont {
        return UIFont(name: "SanFranciscoDisplay-Medium", size: 18.0)!
    }
    
    /*
     * MARK:- COLORS
     */
    
    static func backgroundColor() -> UIColor {
        return UIColor(colorLiteralRed: 209/255, green: 225/255, blue: 232/255, alpha: 1.0)
    }
    
    static func darkBackgroundColor() -> UIColor {
        return UIColor(colorLiteralRed: 122/255, green: 178/255, blue: 206/255, alpha: 1.0)
    }
    
    static func lucasColor() -> UIColor {
        return UIColor(colorLiteralRed: 209/255, green: 225/255, blue: 232/255, alpha: 1.0)
    }
    
    static func botColor() -> UIColor {
        return UIColor(colorLiteralRed: 46/255, green: 62/255, blue: 70/255, alpha: 1.0)
    }
    
    static func chatBotColor() -> UIColor {
        return UIColor.white
    }
    
    static func chatUserColor() -> UIColor {
        return UIColor(colorLiteralRed: 47/255, green: 62/255, blue: 70/255, alpha: 1.0)
    }
    
    static func redColor() -> UIColor {
        return UIColor(colorLiteralRed: 237/255, green: 20/255, blue: 91/255, alpha: 1.0)
    }
    
    static func botBubbleColor() -> UIColor {
        return UIColor(colorLiteralRed: 177/255, green: 203/255, blue: 70/255, alpha: 1.0)
    }
    
    static func userBubbleColor() -> UIColor {
        return UIColor.white
    }
    
    static func greenColor() -> UIColor {
        return UIColor(colorLiteralRed: 177/255, green: 203/255, blue: 70/255, alpha: 1.0)
    }
    
    /*
     * MARK:- IMAGES
     */
    
    static let kDefaultGif:String = "wave-chat"
}
