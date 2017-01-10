//
//  ChatCell.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/8/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class ChatCell: UICollectionViewCell {
    
    var isUser: Bool! {
        didSet {
            if isUser == true {
                textView.textColor = Utils.chatUserColor()
                textView.textAlignment = .right
            }
            else {
                textView.textColor = Utils.chatBotColor()
                textView.textAlignment = .left
            }
        }
    }
    
    var text:String! {
        didSet {
            if text != nil {
                
                if isUser == true {
                    textView.text = text + " <"
                    textView.sizeToFit()
                }
                else {
                    textView.text = "> " + text
                    textView.sizeToFit()
                }
            }
        }
    }
    
    private let textView: UITextView = UITextView(frame: CGRect.zero)
    
    // MARK:- Init
    override init(frame: CGRect){
        super.init(frame: frame)
        //self.contentView.backgroundColor = UIColor.red
        
        textView.backgroundColor = UIColor.clear
        textView.textColor = Utils.chatBotColor()
        textView.font = Utils.chatFont()
        textView.isScrollEnabled = false
        textView.textAlignment = .left
        self.contentView.addSubview(textView)
        
        isUser = false
        text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
}
