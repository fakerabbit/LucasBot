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
        loginView.onSignUp = { email, password in
            
            if email != nil && password != nil {
                BotMgr.sharedInstance.signUp(email: email!, password: password!) { result in
                    
                    if result {
                        debugPrint("sign up SUCCESS")
                        let vc = ViewController()
                        self.nav?.viewControllers = [vc]
                    }
                    else {
                        //show error message to user
                        debugPrint("error occurred during sign up...")
                    }
                }
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
