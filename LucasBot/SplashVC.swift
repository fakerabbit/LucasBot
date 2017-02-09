//
//  SplashVC.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/8/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class SplashVC: UIViewController {
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
