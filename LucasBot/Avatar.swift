//
//  Avatar.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/30/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class Avatar: UIView {
    
    var isBot: Bool! {
        didSet {
            if isBot == true {
                imageView.image = UIImage(named: "botAvatar")
            }
            else {
                imageView.image = UIImage(named: "userAvatar")
            }
        }
    }
    
    private let imageView = UIImageView(frame: CGRect.zero)
    
    private let s:CGFloat = 40.0
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: s, height: s))
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 19.0;
        self.layer.masksToBounds = false;
        self.clipsToBounds = true
        
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        //imageView.layer.cornerRadius = 18.0;
        //imageView.layer.masksToBounds = false;
        //imageView.clipsToBounds = true
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.frame.size.width
        let h = self.frame.size.height
        imageView.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
}
