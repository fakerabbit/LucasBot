//
//  ChatTextField.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/9/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

let kChatTextInset: CGFloat = 10

class ChatTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + kChatTextInset, y: bounds.origin.y, width: bounds.size.width - kChatTextInset * 2, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + kChatTextInset, y: bounds.origin.y, width: bounds.size.width - kChatTextInset * 2, height: bounds.size.height)
    }
}
