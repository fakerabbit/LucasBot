//
//  ChatInput.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/9/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class ChatInput: UIView, UITextFieldDelegate {
    
    let kChatInputHeight:CGFloat = 50.0
    
    var containerView: UIView! {
        didSet {
            if containerView != nil {
                let tap = UITapGestureRecognizer(target: self, action: #selector(onContainerTap))
                tap.numberOfTapsRequired = 1
                tap.numberOfTouchesRequired = 1
                containerView.addGestureRecognizer(tap)
            }
        }
    }
    
    lazy var input: ChatTextField! = {
        let textfield = ChatTextField(frame: CGRect.zero)
        textfield.delegate = self
        textfield.backgroundColor = UIColor.white
        textfield.textColor = Utils.chatUserColor()
        textfield.returnKeyType = .go
        textfield.placeholder = "Ask bot..."
        textfield.layer.cornerRadius = 3.0;
        textfield.layer.masksToBounds = false;
        return textfield
    }()
    
    lazy var sendBtn: UIButton! = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "sendBtn"), for: .normal)
        button.addTarget(self, action: #selector(onSend(_:)), for: .touchUpInside)
        return button
    }()
    
    var isKeyboardShowing: Bool = false,
        keyboardFrame: CGRect = CGRect.zero
    
    typealias ChatInputOnMessage = (String?) -> Void
    var onMessage: ChatInputOnMessage = { message in }
    
    // MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kChatInputHeight))
        self.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidChangeStatusBarNotification(notification:)), name: .UIApplicationWillChangeStatusBarFrame, object: nil)
        
        self.addSubview(input)
        self.addSubview(sendBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let w: CGFloat = self.frame.size.width
        let h: CGFloat = self.frame.size.height
        let pad: CGFloat = 10.0
        let btnS: CGFloat = kChatInputHeight - pad * 2
        sendBtn.frame = CGRect(x: w - (pad + btnS), y: pad, width: btnS, height: btnS)
        input.frame = CGRect(x: pad, y: pad, width: w - (pad * 2 + btnS + 5), height: h - pad * 2)
    }
    
    // MARK:- Private
    
    func onSend(_ sender : UIButton) {
        input.resignFirstResponder()
        if input.text != nil && (input.text?.characters.count)! > 1 {
            self.onMessage(input.text)
            input.text = ""
        }
    }
    
    // MARK:- Keyboard notifications
    
    func keyboardWillShowNotification(notification: NSNotification) {
        
        isKeyboardShowing = !isKeyboardShowing
        
        if let userInfo = notification.userInfo {
            if let frame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardFrame = frame
            }
        }
        
        updateKeyboardPositions()
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        
        isKeyboardShowing = !isKeyboardShowing
        updateKeyboardPositions()
    }
    
    func applicationDidChangeStatusBarNotification(notification: NSNotification) {
        updateKeyboardPositions()
    }
    
    func onContainerTap() {
        if input.isFirstResponder {
            input.resignFirstResponder()
        }
    }
    
    // MARK:- Positioning
    
    func updateKeyboardPositions() {
        
        if isKeyboardShowing {
            self.frame.origin = CGPoint(x: 0, y: (self.superview?.frame.size.height)! - (keyboardFrame.size.height + kChatInputHeight))
        }
        else {
            self.frame.origin = CGPoint(x: 0, y: (self.superview?.frame.size.height)! - kChatInputHeight)
        }
        containerView.frame.size = CGSize(width: containerView.frame.size.width, height: self.frame.minY)
    }
    
    // MARK:- UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != nil && (textField.text?.characters.count)! > 1 {
            self.onMessage(textField.text)
            textField.text = ""
        }
        return true
    }
}
