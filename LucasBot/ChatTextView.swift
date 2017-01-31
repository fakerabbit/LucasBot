//
//  ChatTextView.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/30/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class ChatTextView: UITextView {
    
    private let pad:CGFloat = 10
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, textContainer: nil)
        self.backgroundColor = Utils.botBubbleColor()
        self.textColor = Utils.chatBotColor()
        self.font = Utils.chatFont()
        self.isScrollEnabled = false
        self.textAlignment = .center
        self.isUserInteractionEnabled = false
        self.textContainerInset = UIEdgeInsets(top: pad, left: pad, bottom: pad, right: pad)
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = false;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
