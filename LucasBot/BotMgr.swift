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
    
    typealias BotMgrSignUpCallback = (Bool) -> Void
    typealias BotMgrCallback = (Message?) -> Void
    typealias BotMgrOnMessage = (Message) -> Void
    var onMessage: BotMgrOnMessage = { message in }
    
    func initBot() {
        let message = Message(msgId: NSUUID().uuidString, text: "Calling bot...", type: "bot", sessionId: NetworkMgr.sharedInstance.sessionId, imgUrl: nil, giphy: nil, width: nil, height: nil)
        self.onMessage(message)
        NetworkMgr.sharedInstance.initSocket() { connected in
            if connected == true {
                self.sendMessageToBot(message: "Hello")
                //Wit.sharedInstance().interpretString("Hello", customData: nil)
            }
        }
    }
    
    func sendMessage(msg: String) {
        let message = Message(msgId: NSUUID().uuidString, text: msg, type: "user", sessionId: NetworkMgr.sharedInstance.sessionId, imgUrl: nil, giphy: nil, width: nil, height: nil)
        self.onMessage(message)
        self.sendMessageToBot(message: msg)
    }
    
    func sendSocketMessage(msg: String) {
        let message = Message(msgId: NSUUID().uuidString, text: msg, type: "bot", sessionId: NetworkMgr.sharedInstance.sessionId, imgUrl: nil, giphy: nil, width: nil, height: nil)
        self.onMessage(message)
    }
    
    func sendSocketImage(imgUrl: String) {
        let message = Message(msgId: NSUUID().uuidString, text: "", type: "bot", sessionId: NetworkMgr.sharedInstance.sessionId, imgUrl: imgUrl, giphy: nil, width: nil, height: nil)
        self.onMessage(message)
    }
    
    func sendSocketGif(url: String, width: String, height: String) {
        let message = Message(msgId: NSUUID().uuidString, text: "", type: "bot", sessionId: NetworkMgr.sharedInstance.sessionId, imgUrl: nil, giphy: url, width: width, height: height)
        self.onMessage(message)
    }
    
    func signUp(email: String, password: String, callback: @escaping BotMgrSignUpCallback) {
        
        NetworkMgr.sharedInstance.postUser(email: email, password: password) { response in
            
            if response != nil {
                DataMgr.sharedInstance.storeUser(email: email, password: password) { user in
                    if let _:EUser = user {
                        callback(true)
                    }
                    else {
                        debugPrint("store user failed")
                        callback(false)
                    }
                }
            }
            else {
                debugPrint("post user failed")
                callback(false)
            }
        }
    }
    
    // UNDER DEVELOPMENT
    func signUpBearer(email: String, password: String, callback: @escaping BotMgrSignUpCallback) {
        
        NetworkMgr.sharedInstance.postUser(email: email, password: password) { response in
            
            if response != nil {
                DataMgr.sharedInstance.storeUser(email: email, password: password) { user in
                    
                    if let _:EUser = user {
                        
                        NetworkMgr.sharedInstance.postClients(username: email, password: password, name: DataMgr.sharedInstance.getKey(key: Keys.name.rawValue)!, secret: DataMgr.sharedInstance.getKey(key: Keys.secret.rawValue)!, idString: DataMgr.sharedInstance.getKey(key: Keys.clientId.rawValue)!) { response in
                            
                            if response != nil {
                                
                                NetworkMgr.sharedInstance.getTransactionId(username: email, password: password, clientId: DataMgr.sharedInstance.getKey(key: Keys.clientId.rawValue)!) { response in
                                    
                                    if (response?.result.isSuccess)! {
                                        
                                        if let result:NSDictionary = response?.result.value as? NSDictionary {
                                            if let transactionID:String = result.object(forKey: "transactionID") as! String? {
                                                
                                                NetworkMgr.sharedInstance.postAuthorizationTransaction(username: email, password: password, transactionId: transactionID) { response in
                                                    
                                                    if (response?.result.isSuccess)! {
                                                        
                                                        if let result:NSDictionary = response?.result.value as? NSDictionary {
                                                            if let code:String = result.object(forKey: "code") as! String? {
                                                                debugPrint(code)
                                                                NetworkMgr.sharedInstance.getToken(clientId: DataMgr.sharedInstance.getKey(key: Keys.clientId.rawValue)!, secret: DataMgr.sharedInstance.getKey(key: Keys.secret.rawValue)!, code: code) { response in
                                                                    
                                                                    if (response?.result.isSuccess)! {
                                                                        
                                                                        if let result:NSDictionary = response?.result.value as? NSDictionary {
                                                                            if let accessToken:NSDictionary = result.object(forKey: "access_token") as? NSDictionary {
                                                                                if let token:String = accessToken.object(forKey: "value") as! String? {
                                                                                    debugPrint(token)
                                                                                    callback(DataMgr.sharedInstance.storeKey(key: Keys.token.rawValue, value: token))
                                                                                }
                                                                                else {
                                                                                    debugPrint("retrieve token failed")
                                                                                    callback(false)
                                                                                }
                                                                            }
                                                                            else {
                                                                                debugPrint("retrieve access token failed")
                                                                                callback(false)
                                                                            }
                                                                        }
                                                                        else {
                                                                            debugPrint("token value failed")
                                                                            callback(false)
                                                                        }
                                                                    }
                                                                    else {
                                                                        debugPrint("get token failed")
                                                                        callback(false)
                                                                    }
                                                                }
                                                            }
                                                            else {
                                                                debugPrint("retrieve code failed")
                                                                callback(false)
                                                            }
                                                        }
                                                        else {
                                                            debugPrint("auth transaction value failed")
                                                            callback(false)
                                                        }
                                                    }
                                                    else {
                                                        debugPrint("post auth transaction failed")
                                                        callback(false)
                                                    }
                                                }
                                            }
                                            else {
                                                debugPrint("retrieve transactionID failed")
                                                callback(false)
                                            }
                                        }
                                        else {
                                            debugPrint("transaction id value failed")
                                            callback(false)
                                        }
                                    }
                                    else {
                                        debugPrint("get transaction id failed")
                                        callback(false)
                                    }
                                }
                            }
                            else {
                                debugPrint("post clients failed")
                                callback(false)
                            }
                        }
                    }
                    else {
                        debugPrint("store user failed")
                        callback(false)
                    }
                }
            }
            else {
                debugPrint("post user failed")
                callback(false)
            }
        }
    }
    
    // MARK:- Private
    
    private func sendMessageToBot(message: String) {
        NetworkMgr.sharedInstance.sendMessage(msg: message) { message in
            if message != nil {
                //self.processBotResponse(message: message!)
                /*DataMgr.sharedInstance.saveMessage(message: message!) { emessage in
                 debugPrint("saved message...")
                 self.onMessage(message!)
                 }*/
            }
            else {
                debugPrint("failed sendMessageToBot")
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
