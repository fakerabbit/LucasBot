//
//  BotMgr.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/9/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import Wit

class BotMgr {
    
    /// sharedInstance: the BotMgr singleton
    static let sharedInstance = BotMgr()
    
    typealias BotMgrOnMessage = (Message) -> Void
    var onMessage: BotMgrOnMessage = { message in }
    
    func initBot() {
        self.sendMessageToBot(message: "Hello")
        //Wit.sharedInstance().interpretString("Hello", customData: nil)
    }
    
    func sendMessage(msg: String) {
        let message = Message(msgId: NSUUID().uuidString, intent: nil, text: msg, dateCreated: Date(), confidence: nil, type: "user", sessionId: NetworkMgr.sharedInstance.sessionId)
        self.onMessage(message)
        self.sendMessageToBot(message: msg)
    }
    
    private func sendMessageToBot(message: String) {
        NetworkMgr.sharedInstance.sendMessage(msg: message) { message in
            if message != nil {
                self.processBotResponse(message: message!)
                /*DataMgr.sharedInstance.saveMessage(message: message!) { emessage in
                 debugPrint("saved message...")
                 self.onMessage(message!)
                 }*/
            }
        }
    }
    
    private func processBotResponse(message: Message) {
        
        if let type:String = message.type {
            switch type {
                
            case "merge":
                debugPrint("merge type")
                
            case "action":
                debugPrint("action type")
                
            case "stop":
                debugPrint("stop action")
                
            case "msg":
                self.onMessage(message)
                
            default: break
            }
        }
    }
}
