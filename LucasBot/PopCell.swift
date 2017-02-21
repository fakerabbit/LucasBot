//
//  PopCell.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/21/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class PopCell: UICollectionViewCell {
    
    var imgUrl:String! {
        didSet {
            if imgUrl != nil {
                //debugPrint("imgUrl: \(imgUrl)")
                self.iconView.sd_setImage(with: URL(string: imgUrl))
            }
            else {
                self.iconView.image = nil
            }
        }
    }
    
    var title:String! {
        didSet {
            //debugPrint("title: \(title)")
            self.titleLbl.text = title
            self.titleLbl.sizeToFit()
            self.layoutIfNeeded()
        }
    }
    
    internal lazy var iconView: UIImageView! = {
        let view = UIImageView(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        return view
    }()
    
    internal lazy var titleLbl: UILabel! = {
        let label = UILabel(frame: CGRect.zero)
        label.font = Utils.buttonFont()
        label.textColor = Utils.chatUserColor()
        return label
    }()
    
    internal lazy var line: UIView! = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = Utils.lineColor()
        return view
    }()
    
    private let pad: CGFloat = 10.0
    private let iconS: CGFloat = 15.0
    
    // MARK:- Init
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addSubview(iconView)
        self.addSubview(titleLbl)
        self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        let w:CGFloat = self.frame.size.width
        let h:CGFloat = self.frame.size.height
        
        iconView.frame = CGRect(x: 10, y: h/2 - iconS/2, width: iconS, height: iconS)
        titleLbl.frame = CGRect(x: iconView.frame.maxX + 10, y: 0, width: w - iconS, height: h)
        line.frame = CGRect(x: titleLbl.frame.origin.x, y: titleLbl.frame.maxY, width: titleLbl.frame.size.width, height: 1)
    }
}
