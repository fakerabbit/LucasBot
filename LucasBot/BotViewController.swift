//
//  BotViewController.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/16/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class BotViewController: UIViewController {
    
    var nav:NavController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if (self.navigationController?.isKind(of: NavController.classForCoder()))! {
            self.nav = self.navigationController as? NavController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
