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
                textView.textColor = Utils.chatUserColor()
                textView.textAlignment = .right
            }
            else {
                textView.textColor = Utils.chatBotColor()
                textView.textAlignment = .left
            }
            self.setNeedsLayout()
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
                self.imageView.image = nil
            }
        }
    }
    
    var imgUrl:String! {
        didSet {
            if imgUrl != nil {
                SDWebImageManager.shared().downloadImage(with: URL(string: imgUrl), options: .retryFailed, progress: nil) { [weak self] (image, error, cacheType, finished, imageUrl) in
                    if let s = self {
                        if let img = image {
                            s.imageView.image = img
                        }
                    }
                }
                self.textView.text = ""
            }
        }
    }
    
    private let textView: UITextView = UITextView(frame: CGRect.zero)
    private let imageView: UIImageView = UIImageView(frame: CGRect.zero)
    
    // MARK:- Init
    override init(frame: CGRect){
        super.init(frame: frame)
        //self.contentView.backgroundColor = UIColor.red
        
        textView.backgroundColor = UIColor.clear
        textView.textColor = Utils.chatBotColor()
        textView.font = Utils.chatFont()
        textView.isScrollEnabled = false
        textView.textAlignment = .left
        textView.isUserInteractionEnabled = false
        self.contentView.addSubview(textView)
        
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        self.contentView.addSubview(imageView)
        
        isUser = false
        text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let w:CGFloat = self.frame.size.width
        let h:CGFloat = self.frame.size.height
        textView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        imageView.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
}
