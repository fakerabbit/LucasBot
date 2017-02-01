//
//  LoginInput.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/1/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class LoginInput: UIView, UITextFieldDelegate {
    
    let defaultHeight: CGFloat = 40
    
    lazy var avatar:UIImageView! = {
        let img = UIImageView(image: UIImage(named: "loginAvatar"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    lazy var inputField: LoginTextField! = {
        let textfield = LoginTextField(frame: CGRect.zero)
        textfield.delegate = self
        textfield.placeholder = "Sign up with email"
        textfield.keyboardType = .emailAddress
        textfield.tag = 0
        return textfield
    }()
    
    typealias LoginInputOnSend = (String?) -> Void
    var onSend: LoginInputOnSend = { text in }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: defaultHeight))
        self.backgroundColor = Utils.backgroundColor()
        self.layer.cornerRadius = 3.0;
        self.layer.masksToBounds = false;
        self.clipsToBounds = true
        
        self.addSubview(avatar)
        self.addSubview(inputField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.frame.size.width
        let h = self.frame.size.height
        let pad: CGFloat = 5.0
        avatar.frame = CGRect(x: pad, y: pad, width: defaultHeight, height: h - pad * 2)
        inputField.frame = CGRect(x: defaultHeight, y: 0, width: w - defaultHeight, height: h)
    }
    
    // MARK:- UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        if textField.text != nil && (textField.text?.characters.count)! > 1 {
            self.onSend(textField.text)
        }
        
        return true
    }
    
    // MARK:- Public
    
    override func resignFirstResponder() -> Bool {
        inputField.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    func getText() -> String? {
        return inputField.text
    }
}
