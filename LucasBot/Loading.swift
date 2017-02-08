//
//  Loading.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/6/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class Loading: UIView {
    
    let size: CGFloat = 50.0
    
    private lazy var loading: UIActivityIndicatorView! = {
        let load = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        load.startAnimating()
        load.hidesWhenStopped = true
        return load
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        self.backgroundColor = UIColor.clear
        //self.layer.cornerRadius = 6.0;
        //self.layer.masksToBounds = false;
        //self.clipsToBounds = true
        
        self.addSubview(loading)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.frame.size.width
        let h = self.frame.size.height
        loading.frame = CGRect(x: w/2 - loading.frame.size.width/2, y: h/2 - loading.frame.size.height/2, width: loading.frame.size.width, height: loading.frame.size.height)
    }
}
