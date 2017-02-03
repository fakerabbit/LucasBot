//
//  TypingView.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/2/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit
import SwiftyGif

class TypingView: UIView {
    
    private let s:CGFloat = 35.0
    private let pad: CGFloat = 20.0
    private let avatar = Avatar(frame: CGRect.zero)
    
    lazy var gifView:UIImageView! = {
        let gifmanager = SwiftyGifManager(memoryLimit:20)
        let gf = UIImage(gifName: Utils.kDefaultGif)
        let imageView = UIImageView(gifImage: gf, manager: gifmanager)
        imageView.contentMode = .scaleAspectFit
        imageView.startAnimatingGif()
        return imageView
    }()
    
    lazy var bubble: UIView! = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = Utils.botBubbleColor()
        view.layer.cornerRadius = 3.0;
        view.layer.masksToBounds = false;
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: s))
        self.backgroundColor = UIColor.clear
        //self.addSubview(bubble)
        avatar.isBot = true
        self.addSubview(avatar)
        self.addSubview(gifView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let h = self.frame.size.height
        let bubblePad: CGFloat = avatar.frame.maxX + pad + 10
        avatar.frame = CGRect(x: pad, y: 0, width: avatar.frame.size.width, height: avatar.frame.size.height)
        gifView.frame = CGRect(x: bubblePad, y: 0, width: 70, height: h)
        bubble.frame = CGRect(x: bubblePad, y: 0, width: 70, height: h)
    }
}
