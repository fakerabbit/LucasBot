//
//  NetworkMgr.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/8/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import Alamofire

class NetworkMgr {
    
    let MESSAGE_API_URL = "https://YOUR_APP_HERE.herokuapp.com/send?text="
    
    /// sharedInstance: the NetworkMgr singleton
    static let sharedInstance = NetworkMgr()
    
    let sessionId: String = NSUUID().uuidString
    
    typealias NetworkMgrCallback = (Message?) -> Void
    
    /// sendMessage(msg: String): Sends a message to Wit
    func sendMessage(msg: String, callback: @escaping NetworkMgrCallback) {
        
        let msgUrl = MESSAGE_API_URL + msg.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
        Alamofire.request(msgUrl).responseJSON { [weak self] response in
            debugPrint("got response from MarieBot:")
            debugPrint(response)
            var message: Message?
            if let value = response.result.value {
                debugPrint(value)
                let msgId: String = NSUUID().uuidString
                var type: String?
                if let tp:String = (value as! NSDictionary).object(forKey: "type") as! String? {
                    type = tp
                }
                var text: String?
                if let txt:String = (value as! NSDictionary).object(forKey: "msg") as! String? {
                    text = txt
                    type = "msg"
                }
                let dateCreated = Date()
                message = Message(msgId: msgId, intent: "", text: text, dateCreated: dateCreated, confidence: 1.0, type: type, sessionId: self?.sessionId)
            }
            callback(message)
        }
    }
}
