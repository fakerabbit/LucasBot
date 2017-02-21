//
//  Reply.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/20/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class Reply: UIView {
    
    lazy var button: UIButton! = {
        let b = UIButton(type: .custom)
        return b
    }()
    
    lazy var textView: ChatTextView! = {
        let reply = ChatTextView(frame: CGRect.zero)
        reply.isUserInteractionEnabled = false
        reply.font = Utils.boldFont()
        reply.backgroundColor = Utils.userBubbleColor()
        reply.textColor = Utils.chatUserColor()
        reply.textAlignment = .center
        return reply
    }()
    
    // MARK:- Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Utils.userBubbleColor()
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = false;
        self.clipsToBounds = true
        
        self.addSubview(textView)
        self.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.frame.size.width
        let h = self.frame.size.height
        textView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        button.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
}
