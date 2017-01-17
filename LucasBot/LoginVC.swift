//
//  LoginVC.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/16/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: BotViewController {
    
    lazy var loginView:LoginView! = {
        let frame = UIScreen.main.bounds
        let v = LoginView(frame: frame)
        return v
    }()
    
    override func loadView() {
        super.loadView()
        self.view = self.loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginView.animateLogo(callback: { [weak self] finished in
            self?.checkStore()
        })
        loginView.onSignUp = { email in
            
            if email != nil {
                let vc = ViewController()
                self.nav?.viewControllers = [vc]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Private
    
    private func checkStore() {
        
        if DataMgr.sharedInstance.initStore() {
            // sign up
            loginView.animateSignUp()
        }
        else {
            //chat room
            let vc = ViewController()
            self.nav?.viewControllers = [vc]
        }
    }
}
