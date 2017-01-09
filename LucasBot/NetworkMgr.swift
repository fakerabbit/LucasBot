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
    
    let MESSAGE_API_URL = "https://api.wit.ai/converse?session_id="
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer YOUR_TOKEN_HERE",
        "Content-Type": "Content-Type",
        "Accept": "application/json"
    ]
    
    let sessionId: String = NSUUID().uuidString
    
    /// sharedInstance: the NetworkMgr singleton
    static let sharedInstance = NetworkMgr()
    
    typealias NetworkMgrCallback = (Message?) -> Void
    
    /// sendMessage(msg: String): Sends a message to Wit
    /// - Parameter msg: string of the message
    /// - Returns: an array of Message objects
    func sendMessage(msg: String, callback: @escaping NetworkMgrCallback) {
        
        let msgUrl = MESSAGE_API_URL + sessionId + "&q=" + msg.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        
        Alamofire.request(msgUrl, method: .post, headers: headers).responseJSON { [weak self] response in
            debugPrint("got response from Wit:")
            debugPrint(response)
            var message: Message?
            if let value = response.result.value {
                debugPrint(value)
                let msgId: String = NSUUID().uuidString
                var text: String?
                if let txt:String = (value as! NSDictionary).object(forKey: "msg") as! String? {
                    text = txt
                }
                var intent: String?
                var confidence: Float?
                if let entity:NSDictionary = (value as! NSDictionary).object(forKey: "entities") as! NSDictionary? {
                    if let i:[NSDictionary] = entity.object(forKey: "intent") as? [NSDictionary] {
                        for var j:NSDictionary in i {
                            if let x:String = j.object(forKey: "value") as? String {
                                intent = x
                                confidence = j.object(forKey: "confidence") as? Float
                                break
                            }
                        }
                    }

                }
                var type: String?
                if let tp:String = (value as! NSDictionary).object(forKey: "type") as! String? {
                    type = tp
                }
                let dateCreated = Date()
                message = Message(msgId: msgId, intent: intent, text: text, dateCreated: dateCreated, confidence: confidence, type: type, sessionId: self?.sessionId)
            }
            callback(message)
        }
    }
}
