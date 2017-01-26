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
                self.gif.isHidden = true
                self.gif.stopLoading()
            }
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
                self.gif.isHidden = true
                self.gif.stopLoading()
            }
        }
    }
    
    var gifUrl:String! {
        didSet {
            if gifUrl != nil {
                self.gif.isHidden = false
                let secureUrl = gifUrl.replacingOccurrences(of: "http:", with: "https:")
                /*SDWebImageManager.shared().downloadImage(with: URL(string: secureUrl), options: .retryFailed, progress: nil) { [weak self] (image, error, cacheType, finished, imageUrl) in
                    if let s = self {
                        if let img = image {
                            /*if let imageData: Data = UIImageJPEGRepresentation(img, 1.0) {
                                s.gif.isHidden = true
                                s.gif.load(imageData, mimeType: "image/gif", textEncodingName: nil, baseURL: nil)
                            }*/
                            s.gif.isHidden = false
                            //s.gif.load(img, mimeType: "image/gif", textEncodingName: nil, baseURL: nil)
                            let imageData = Data(base64Encoded: UIImagePNGRepresentation(img)!)
                            let imageHTML = "<img src='data:image/png;base64,\(imageData)' />"
                            s.gif.loadHTMLString(imageHTML, baseURL: nil)
                        }
                    }
                }*/
                let request = URLRequest(url: URL(string: secureUrl)!)
                self.gif.loadRequest(request)
                self.textView.text = ""
                self.imageView.image = nil
            }
        }
    }
    
    var gifWidth:CGFloat! {
        didSet {
            if gifWidth != nil {
                self.layoutSubviews()
            }
        }
    }
    
    private let textView: UITextView = UITextView(frame: CGRect.zero)
    private let imageView: UIImageView = UIImageView(frame: CGRect.zero)
    private let gif: UIWebView = UIWebView(frame: CGRect.zero)
    
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
        
        gif.backgroundColor = UIColor.clear
        gif.contentMode = .scaleAspectFit
        gif.isUserInteractionEnabled = false
        gif.scalesPageToFit = true
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
        textView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        imageView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        gif.frame = CGRect(x: w/2 - gifWidth/2, y: 0, width: gifWidth, height: h)
    }
}
