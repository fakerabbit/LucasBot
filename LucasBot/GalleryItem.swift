//
//  GalleryItem.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/20/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class GalleryItem: UIView {
    
    var title: String! {
        didSet {
            if title != nil {
                //debugPrint("title: \(title)")
                self.titleLbl.text = title
                self.titleLbl.sizeToFit()
            }
            else {
                self.titleLbl.text = ""
                self.titleLbl.sizeToFit()
            }
            self.layoutIfNeeded()
        }
    }
    var imgUrl:String! {
        didSet {
            if imgUrl != nil {
                self.imageView.sd_setImage(with: URL(string: imgUrl))
            }
            else {
                self.imageView.image = nil
            }
        }
    }
    var payload: String?
    var url: String?
    
    lazy var button: UIButton! = {
        let b = UIButton(type: .custom)
        return b
    }()
    
    private lazy var imageView: UIImageView! = {
        let view = UIImageView(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.contentMode = .center
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLbl: UILabel! = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIColor.clear
        label.font = Utils.boldFont()
        label.textColor = Utils.chatUserColor()
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    // MARK:- Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Utils.userBubbleColor()
        self.layer.cornerRadius = 6.0;
        self.layer.masksToBounds = false;
        self.clipsToBounds = true
        
        self.addSubview(imageView)
        self.addSubview(titleLbl)
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
        titleLbl.frame = CGRect(x: 0, y: h - (h/3), width: w, height: h/3)
        imageView.frame = CGRect(x: 0, y: 0, width: w, height: h - titleLbl.frame.size.height)
        button.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
}
