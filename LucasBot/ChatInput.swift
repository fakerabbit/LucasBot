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
        textfield.textColor = Utils.chatUserColor()
        textfield.returnKeyType = .go
        textfield.placeholder = "Type here..."
        return textfield
    }()
    
    var isKeyboardShowing: Bool = false,
        keyboardFrame: CGRect = CGRect.zero
    
    lazy var lineIv: UIImageView! = {
        if let image = UIImage(named: "inputLine") {
            let imageView = UIImageView(image: image.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: image.size.width/2, bottom: 0, right: image.size.width/2), resizingMode: .tile))
            //imageView.contentMode = .scaleAspectFill
            //imageView.autoresizingMask = .flexibleWidth
            return imageView
        }
        return UIImageView()
    }()
    
    lazy var carot: UILabel! = {
       let label = UILabel(frame: CGRect.zero)
        label.textColor = Utils.chatBotColor()
        label.font = Utils.chatFont()
        label.text = ">"
        label.sizeToFit()
        return label
    }()
    
    typealias ChatInputOnMessage = (String?) -> Void
    var onMessage: ChatInputOnMessage = { message in }
    
    // MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kChatInputHeight))
        self.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidChangeStatusBarNotification(notification:)), name: .UIApplicationWillChangeStatusBarFrame, object: nil)
        
        self.addSubview(carot)
        self.addSubview(lineIv)
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
        let pad: CGFloat = 30.0
        let lineH: CGFloat = lineIv.frame.size.height
        input.frame = CGRect(x: 0, y: 0, width: w, height: h)
        carot.frame = CGRect(x: pad/2, y: h/2 - carot.frame.size.height/2, width: carot.frame.size.width, height: carot.frame.size.height)
        lineIv.frame = CGRect(x: pad, y: h - (10 + lineH), width: w - pad * 2, height: lineH)
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
        self.onMessage(textField.text)
        textField.text = ""
        return true
    }
}
