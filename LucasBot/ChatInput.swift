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
    
    lazy var input: UITextField! = {
        let textfield = UITextField(frame: CGRect.zero)
        return textfield
    }()
    
    var isKeyboardShowing: Bool = false,
        keyboardFrame: CGRect = CGRect.zero
    
    // MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kChatInputHeight))
        self.backgroundColor = UIColor.yellow
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidChangeStatusBarNotification(notification:)), name: .UIApplicationWillChangeStatusBarFrame, object: nil)
        
        self.addSubview(input)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let w: CGFloat = self.frame.size.width
        let h: CGFloat = self.frame.size.height
        input.frame = CGRect(x: 0, y: 0, width: w, height: h)
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
}
