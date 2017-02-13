//
//  SplashView.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/8/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class SplashView: UIView {
    
    lazy var animationView:LOTAnimationView! = {
        let animView = LOTAnimationView.animationNamed("intro")
        animView?.contentMode = .scaleAspectFit
        return animView
    }()
    
    /*
     * MARK:- Init
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Utils.darkBackgroundColor()
        
        self.addSubview(animationView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.frame.size.width
        let h = self.frame.size.height
        animationView.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
}
