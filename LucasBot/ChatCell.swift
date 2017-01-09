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
    
    var text:String! {
        didSet {
            if text != nil {
                textView.text = "> " + text
                textView.sizeToFit()
            }
        }
    }
    
    private let textView: UITextView = UITextView(frame: CGRect.zero)
    
    // MARK:- Init
    override init(frame: CGRect){
        super.init(frame: frame)
        //self.contentView.backgroundColor = UIColor.brown
        
        text = ""
        
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor(colorLiteralRed: 119/255, green: 222/255, blue: 8/255, alpha: 1.0)
        textView.font = Utils.chatFont()
        textView.isScrollEnabled = false
        self.contentView.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = self.frame
    }
}
