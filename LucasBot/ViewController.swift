//
//  ViewController.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/8/17.
//  Copyright © 2017 LB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var chatView:ChatView! = {
        let frame = UIScreen.main.bounds
        let v = ChatView(frame: frame)
        return v
    }()
    
    override func loadView() {
        super.loadView()
        self.view = self.chatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Utils.printFontNamesInSystem()
        
        BotMgr.sharedInstance.initBot()
        BotMgr.sharedInstance.onMessage = { [weak self] message in
            debugPrint("bot manager received message...")
            if message != nil {
                var messages:[Message]? = self?.chatView.messages
                messages?.append(message)
                self?.chatView.messages = messages
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

