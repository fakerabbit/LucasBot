//
//  LoginTextField.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/1/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

let kLoginTextInset: CGFloat = 0

class LoginTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = Utils.chatUserColor()
        self.returnKeyType = .go
        self.backgroundColor = UIColor.clear
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.keyboardType = .asciiCapable
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + kChatTextInset, y: bounds.origin.y, width: bounds.size.width - kChatTextInset * 2, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + kChatTextInset, y: bounds.origin.y, width: bounds.size.width - kChatTextInset * 2, height: bounds.size.height)
    }
}
