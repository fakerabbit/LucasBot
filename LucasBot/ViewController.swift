//
//  ViewController.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/8/17.
//  Copyright © 2017 LB. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: BotViewController {
    
    lazy var chatView:ChatView! = {
        let frame = UIScreen.main.bounds
        let v = ChatView(frame: frame)
        return v
    }()
    
    override func loadView() {
        super.loadView()
        BotMgr.sharedInstance.currentView = self.chatView
        self.view = self.chatView
        chatView.chatInput?.onMessage = { message in
            if message != nil {
                BotMgr.sharedInstance.sendMessage(msg: message!)
            }
        }
        chatView.onButton = { button in
            if button != nil {
                if button?.payload != nil {
                    BotMgr.sharedInstance.sendPayload(button: button!)
                }
                else if button?.url != nil {
                    //UIApplication.shared.open(URL(string: "http://www.stackoverflow.com")!, options: [:], completionHandler: nil)
                    if let requestUrl = NSURL(string: button!.url!) {
                        let svc = SFSafariViewController(url: requestUrl as URL)
                        self.present(svc, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        BotMgr.sharedInstance.initBot()
        chatView.animateView()
        BotMgr.sharedInstance.onMessage = { [weak self] message in
            //debugPrint("bot manager received message...")
            if message.typing == true || message.type == "user" {
                self?.chatView.newMessage = message
            }
            else {
                self?.chatView.newBotMessage = message
            }
            self?.chatView.animateTyping(anim: message.typing)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

