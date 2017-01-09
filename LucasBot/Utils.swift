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
}
