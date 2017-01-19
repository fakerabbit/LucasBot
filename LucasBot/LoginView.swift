//
//  LoginView.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/16/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit
import SwiftyGif

class LoginView: UIView, UITextFieldDelegate {
    
    typealias LoginViewCallback = (Bool) -> Void
    
    typealias LoginViewOnSignUp = (String?, String?) -> Void
    var onSignUp: LoginViewOnSignUp = { email in }
    
    lazy var lucas:UILabel! = {
        let label:UILabel = UILabel(frame: CGRect.zero)
        label.font = Utils.LucasFont()
        label.textColor = Utils.lucasColor()
        label.text = "Lucas"
        label.sizeToFit()
        return label
    }()
    
    lazy var bot:UILabel! = {
        let label:UILabel = UILabel(frame: CGRect.zero)
        label.font = Utils.BotFont()
        label.textColor = Utils.botColor()
        label.text = "Bot"
        label.sizeToFit()
        return label
    }()
    
    fileprivate lazy var gif:UIImageView! = {
        let gifmanager = SwiftyGifManager(memoryLimit:20)
        let gf = UIImage(gifName: Utils.kDefaultGif)
        let i:UIImageView = UIImageView(gifImage: gf, manager: gifmanager)
        i.frame = CGRect(x: 0, y: 0, width: 537, height: 360)
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    lazy var signUpInput: RedTextField! = {
        let textfield = RedTextField(frame: CGRect.zero)
        textfield.delegate = self
        textfield.placeholder = "Sign up with your email..."
        textfield.keyboardType = .emailAddress
        textfield.tag = 0
        return textfield
    }()
    
    lazy var passwordInput: RedTextField! = {
        let textfield = RedTextField(frame: CGRect.zero)
        textfield.delegate = self
        textfield.placeholder = "Enter a password..."
        textfield.tag = 1
        textfield.isSecureTextEntry = true
        return textfield
    }()
    
    /*
     * MARK:- Init
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Utils.backgroundColor()
        
        self.addSubview(lucas)
        self.addSubview(bot)
        self.addSubview(gif)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Public
    
    func animateLogo(callback: @escaping LoginViewCallback) {
        let w: CGFloat = self.frame.size.width
        let h: CGFloat = self.frame.size.height
        let top: CGFloat = 100.0
        self.gif.startAnimatingGif()
        lucas.frame = CGRect(x: -lucas.frame.size.width, y: top, width: lucas.frame.size.width, height: lucas.frame.size.height)
        bot.frame = CGRect(x: w/2, y: -bot.frame.size.height, width: bot.frame.size.width, height: bot.frame.size.height)
        gif.frame = CGRect(x: 0, y: h, width: w, height: gif.frame.size.height)
        
        UIView.animate(withDuration: 1.0, animations: {
            
            let top2: CGFloat = top + 10
            let pad: CGFloat = 30
            self.lucas.frame = CGRect(x: w/2 - self.lucas.frame.size.width, y: top, width: self.lucas.frame.size.width, height: self.lucas.frame.size.height)
            self.bot.frame = CGRect(x: w/2, y: top2, width: self.bot.frame.size.width, height: self.bot.frame.size.height)
            self.gif.frame = CGRect(x: 0, y: self.lucas.frame.maxY + pad, width: w, height: self.gif.frame.size.height)
            
        }, completion: { finished in
            callback(finished)
        })
    }
    
    func animateSignUp() {
        
        self.addSubview(signUpInput)
        self.addSubview(passwordInput)
        let w: CGFloat = self.frame.size.width
        let h: CGFloat = self.frame.size.height
        let pad: CGFloat = 20.0
        signUpInput.frame = CGRect(x: pad, y: h, width: w - pad * 2, height: 50)
        passwordInput.frame = CGRect(x: pad, y: h, width: w - pad * 2, height: 50)

        UIView.animate(withDuration: 2.0, animations: {
            
            self.gif.isHidden = true
            self.signUpInput.frame = CGRect(x: pad, y: self.bot.frame.maxY + 30, width: w - pad * 2, height: 50)
            
        }, completion: { finished in
            UIView.animate(withDuration: 1.0, animations: {
                
                self.passwordInput.frame = CGRect(x: pad, y: self.signUpInput.frame.maxY + 20, width: w - pad * 2, height: 50)
                
            }, completion: { finished in
            })
        })
    }
    
    // MARK:- UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField.tag == 0 {
            self.passwordInput.becomeFirstResponder()
        }
        else if textField.tag == 1 {
            self.onSignUp(self.signUpInput.text, self.passwordInput.text)
        }
        
        return true
    }
}
