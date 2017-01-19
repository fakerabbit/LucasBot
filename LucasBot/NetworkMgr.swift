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
    
    let MESSAGE_API_URL = "http://localhost:3000/bot/send?text="
    let SIGN_UP_URL = "http://localhost:3000/user"
    let POST_CLIENT_URL = "http://localhost:3000/clients"
    let AUTHORIZE_TRANSACTION_URL = "http://localhost:3000/oauth2/authorize?"
    let AUTHORIZE_ALLOW_URL = "http://localhost:3000/oauth2/authorize?allow=Allow"
    let TOKEN_URL = "http://localhost:3000/oauth2/token"
    
    /// sharedInstance: the NetworkMgr singleton
    static let sharedInstance = NetworkMgr()
    
    let sessionId: String = NSUUID().uuidString
    
    typealias NetworkMgrCallback = (Message?) -> Void
    typealias NetworkMgrReqCallback = (String?) -> Void
    typealias NetworkMgrResCallback = (DataResponse<Any>?) -> Void
    typealias NetworkMgrStringCallback = (DataResponse<String>?) -> Void
    
    /// sendMessage(msg: String): Sends a message to Wit
    func sendMessage(msg: String, callback: @escaping NetworkMgrCallback) {
        
        let msgUrl = MESSAGE_API_URL + msg.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: DataMgr.sharedInstance.getKey(key: Keys.email.rawValue)!, password: DataMgr.sharedInstance.getKey(key: Keys.password.rawValue)!) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(msgUrl, headers: headers).responseJSON { [weak self] response in
            debugPrint("got response from Wit:")
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
                //let dateCreated = Date()
                message = Message(msgId: msgId, text: text, type: type, sessionId: self?.sessionId)
            }
            callback(message)
        }
    }
    
    // MARK:- SIGN UP
    
    func postUser(email: String, password: String, callback: @escaping NetworkMgrReqCallback) {
        
        let parameters: Parameters = ["username": email, "password": password]
        
        Alamofire.request(SIGN_UP_URL, method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { response in
            
            if response.result.isSuccess {
                callback("good")
            }
            else {
                callback(nil)
            }
        }
    }
    
    func postClients(username: String, password: String, name: String, secret: String, idString: String, callback: @escaping NetworkMgrReqCallback) {
        
        let parameters: Parameters = ["name": name, "secret": secret, "id": idString]
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(POST_CLIENT_URL, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            
            if response.result.isSuccess {
                callback("success")
            }
            else {
                callback(nil)
            }
        }
    }
    
    func getTransactionId(username: String, password: String, clientId: String, callback: @escaping NetworkMgrResCallback) {
        
        let authUrl = AUTHORIZE_TRANSACTION_URL + "client_id=" + clientId.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)! + "&response_type=code&redirect_uri=allow"
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(authUrl, headers: headers).responseJSON { response in
            callback(response)
        }
    }
    
    func postAuthorizationTransaction(username: String, password: String, transactionId: String, callback: @escaping NetworkMgrResCallback) {
        
        let parameters: Parameters = ["transaction_id": transactionId]
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(AUTHORIZE_ALLOW_URL, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            debugPrint(response.result.value ?? "nada")
            callback(response)
        }
    }
    
    // MARK:- TOKEN
    
    func getToken(clientId: String, secret: String, code: String, callback: @escaping NetworkMgrResCallback) {
        
        let parameters: Parameters = ["code": code, "grant_type": "authorization_code", "redirect_uri": "allow"]
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: clientId, password: secret) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(TOKEN_URL, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            callback(response)
        }
    }
}
