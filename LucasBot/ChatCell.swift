//
//  ChatCell.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/8/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ChatCell: UICollectionViewCell {
    
    var isUser: Bool! {
        didSet {
            if isUser == true {
                textView.backgroundColor = Utils.userBubbleColor()
                textView.textColor = Utils.chatUserColor()
                textView.textAlignment = .right
            }
            else {
                textView.backgroundColor = Utils.botBubbleColor()
                textView.textColor = Utils.chatBotColor()
                textView.textAlignment = .left
            }
            avatar.isHidden = isUser
            self.setNeedsLayout()
        }
    }
    
    var text:String! {
        didSet {
            //debugPrint("text didSet: ", text)
            if text != nil {
                self.textView.isHidden = false
            }
            else {
                self.textView.isHidden = true
            }
            self.textView.text = text
            self.textView.sizeToFit()
            self.imageView.image = nil
            self.gif.isHidden = true
            self.gif.stopLoading()
            self.setNeedsLayout()
        }
    }
    
    var imgUrl:String! {
        didSet {
            if imgUrl != nil {
                let secureUrl = imgUrl.replacingOccurrences(of: "http:", with: "https:")
                SDWebImageManager.shared().downloadImage(with: URL(string: secureUrl), options: .retryFailed, progress: nil) { [weak self] (image, error, cacheType, finished, imageUrl) in
                    if let s = self {
                        if let img = image {
                            s.imageView.image = img
                        }
                    }
                }
                self.textView.text = ""
                self.textView.isHidden = true
                self.gif.isHidden = true
                self.gif.stopLoading()
            }
            else {
                self.imageView.image = nil
                self.textView.isHidden = false
            }
        }
    }
    
    var gifUrl:String! {
        didSet {
            if gifUrl != nil {
                //debugPrint("gifUrl....")
                self.gif.isHidden = false
                let secureUrl = gifUrl.replacingOccurrences(of: "http:", with: "https:")
                let request = URLRequest(url: URL(string: secureUrl)!)
                self.gif.loadRequest(request)
                self.textView.text = ""
                self.imageView.image = nil
                self.textView.isHidden = true
            }
            else {
                self.gif.isHidden = true
                self.gif.stopLoading()
            }
        }
    }
    
    var gifWidth:CGFloat! {
        didSet {
            self.layoutSubviews()
        }
    }
    
    private let textView: ChatTextView = ChatTextView(frame: CGRect.zero)
    private let imageView: UIImageView = UIImageView(frame: CGRect.zero)
    private let gif: UIWebView = UIWebView(frame: CGRect.zero)
    private let avatar = Avatar(frame: CGRect.zero)
    private let pad: CGFloat = 10.0
    
    // MARK:- Init
    override init(frame: CGRect){
        super.init(frame: frame)
        //self.contentView.backgroundColor = UIColor.red
        
        avatar.isBot = true
        self.contentView.addSubview(avatar)
        
        self.contentView.addSubview(textView)
        
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        //imageView.layer.cornerRadius = 6.0;
        //imageView.layer.masksToBounds = false;
        //imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
        
        gif.backgroundColor = UIColor.clear
        gif.contentMode = .scaleAspectFit
        gif.isUserInteractionEnabled = false
        gif.scalesPageToFit = true
        gif.layer.cornerRadius = 6.0;
        gif.layer.masksToBounds = false;
        gif.clipsToBounds = true
        self.contentView.addSubview(gif)
        
        isUser = false
        text = ""
        gifWidth = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let w:CGFloat = self.frame.size.width
        let h:CGFloat = self.frame.size.height
        let aPad:CGFloat = 10.0
        let tW:CGFloat = gifWidth + 20
        
        avatar.frame = CGRect(x: pad, y: 0, width: avatar.frame.size.width, height: avatar.frame.size.height)
        
        if self.isUser == true {
            textView.frame = CGRect(x: w - (pad + aPad + tW), y: 0, width: tW, height: h)
        }
        else {
            textView.frame = CGRect(x: avatar.frame.maxX + aPad, y: 0, width: tW, height: h)
        }
        
        imageView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        gif.frame = CGRect(x: avatar.frame.maxX + pad, y: 0, width: gifWidth, height: h)
    }
}
