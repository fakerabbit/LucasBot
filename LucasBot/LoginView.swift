//
//  LoginView.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/16/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class LoginView: UIView {
    
    typealias LoginViewCallback = (Bool) -> Void
    
    typealias LoginViewOnSignUp = (String?, String?) -> Void
    var onSignUp: LoginViewOnSignUp = { email in }
    
    lazy var name:UILabel! = {
        let label:UILabel = UILabel(frame: CGRect.zero)
        label.font = Utils.LucasFont()
        label.textColor = Utils.lucasColor()
        label.text = "TRIVIA"
        label.sizeToFit()
        return label
    }()
    
    lazy var bot:UILabel! = {
        let label:UILabel = UILabel(frame: CGRect.zero)
        label.font = Utils.BotFont()
        label.textColor = Utils.botColor()
        label.text = "BOT"
        label.sizeToFit()
        return label
    }()
    
    lazy var signUpInput: LoginInput! = {
        let input = LoginInput(frame: CGRect.zero)
        return input
    }()
    
    lazy var goBtn: UIButton! = {
        let button = UIButton(type: .custom)
        button.backgroundColor = Utils.greenColor()
        button.setTitle("GO", for: .normal)
        button.setTitleColor(Utils.botColor(), for: .normal)
        button.titleLabel?.font = Utils.buttonFont()
        button.layer.cornerRadius = 3.0;
        button.layer.masksToBounds = false;
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(onGo(_:)), for: .touchUpInside)
        return button
    }()
    
    /*
     * MARK:- Init
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Utils.darkBackgroundColor()
        
        self.addSubview(name)
        self.addSubview(bot)
        self.addSubview(signUpInput)
        self.addSubview(goBtn)
        
        signUpInput.onSend = { text in
            self.onSignUp(text, "1234567890")
        }
        
        //[rotationView setTransform:CGAffineTransformMakeScale(2.0, 2.0)];
        goBtn.transform = CGAffineTransform(scaleX: 0, y: 0)
        signUpInput.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let w: CGFloat = self.frame.size.width
        let top: CGFloat = 100.0
        //let h: CGFloat = self.frame.size.height
        let pad: CGFloat = 40.0
        let nameW: CGFloat = name.frame.size.width + bot.frame.size.width
        let inputW: CGFloat = w - pad * 2
        let goW: CGFloat = inputW / 3
        
        name.frame = CGRect(x: w/2 - nameW/2, y: top, width: name.frame.size.width, height: name.frame.size.height)
        bot.frame = CGRect(x: name.frame.maxX, y: top, width: bot.frame.size.width, height: bot.frame.size.height)
        signUpInput.frame = CGRect(x: pad, y: self.bot.frame.maxY + top/2, width: inputW, height:signUpInput.frame.size.height)
        goBtn.frame = CGRect(x: w - (goW + pad), y: signUpInput.frame.maxY + 20, width: goW, height: signUpInput.frame.size.height)
    }
    
    // MARK:- Private
    
    func onGo(_ sender : UIButton) {
        signUpInput.resignFirstResponder()
        if signUpInput.getText() != nil && (signUpInput.getText()?.characters.count)! > 1 {
            self.onSignUp(signUpInput.getText(), "0987654321")
        }
    }
    
    // MARK:- Public
    
    func animateSignUp() {
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.signUpInput.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { finished in
            UIView.animate(withDuration: 1.0, animations: {
                
                self.goBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        })
    }
    
    func animateLogin() {
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.goBtn.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { finished in
            UIView.animate(withDuration: 1.0, animations: {
                
            }, completion: nil)
        })
    }
}
