//
//  BotMgr.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/9/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation

class BotMgr {
    
    /// sharedInstance: the BotMgr singleton
    static let sharedInstance = BotMgr()
    
    typealias BotMgrOnMessage = (Message) -> Void
    var onMessage: BotMgrOnMessage = { message in }
    
    func initBot() {
        
        NetworkMgr.sharedInstance.sendMessage(msg: "Hello") { message in
            if message != nil {
                self.onMessage(message!)
                /*DataMgr.sharedInstance.saveMessage(message: message!) { emessage in
                    debugPrint("saved message...")
                    self.onMessage(message!)
                }*/
            }
        }
    }
    
    func sendMessage(msg: String) {
        let message = Message(msgId: NSUUID().uuidString, intent: nil, text: msg, dateCreated: Date(), confidence: nil, type: "user", sessionId: NetworkMgr.sharedInstance.sessionId)
        self.onMessage(message)
    }
}
