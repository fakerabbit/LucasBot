//
//  SplashVC.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/8/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class SplashVC: BotViewController {
    
    lazy var splashView:SplashView! = {
        let frame = UIScreen.main.bounds
        let v = SplashView(frame: frame)
        return v
    }()
    
    override func loadView() {
        super.loadView()
        self.view = self.splashView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        splashView.animationView?.play(completion: { [weak self] (finished) in
            // Do Something
            
            UIView.animate(withDuration: 1.0, animations: {
                
                self?.splashView.animationView?.frame.origin = CGPoint(x: 0, y: (self?.splashView.frame.size.height)!)
            }, completion: { finished in
                let vc = LoginVC()
                self?.nav?.viewControllers = [vc]
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
