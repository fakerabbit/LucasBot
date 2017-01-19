//
//  RedTextField.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/16/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

let kRedTextInset: CGFloat = 30

class RedTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = Utils.chatUserColor()
        self.returnKeyType = .go
        self.backgroundColor = Utils.redColor()
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.keyboardType = .asciiCapable
        self.layer.cornerRadius = 24.0;
        self.layer.masksToBounds = false;
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
