//
//  Alert.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/6/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class Alert: UIView {
    
    var alert: String! {
        didSet {
            textView.text = alert
            textView.sizeToFit()
            self.sizeToFit()
            self.layoutIfNeeded()
        }
    }
    
    private lazy var textView: UITextView! = {
       let view = UITextView(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.font = Utils.chatFont()
        view.textColor = Utils.chatBotColor()
        view.isUserInteractionEnabled = false
        view.isScrollEnabled = false
        return view
    }()
    
    // MARK:- Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Utils.greenColor()
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = false;
        self.clipsToBounds = true
        
        self.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.frame.size.width
        let h = self.frame.size.height
        textView.frame = CGRect(x: 10, y: 10, width: w - 20, height: h - 20)
    }
    
    override func sizeToFit() {
        super.sizeToFit()
        let w = UIScreen.main.bounds.size.width
        let h = UIScreen.main.bounds.size.height
        var size = CGSize(width: w/1.8, height: 0)
        size = self.textView.sizeThatFits(CGSize(width: size.width - 20, height: CGFloat.greatestFiniteMagnitude))
        self.frame = CGRect(x: w/2 - size.width/2, y: h/2 - size.height/2, width: size.width, height: size.height + 20)
    }
}
