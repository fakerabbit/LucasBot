//
//  DataMgr.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/8/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import CoreData
import SwiftKeychainWrapper

struct User {
    var email: String = ""
    var name: String?
}

struct Message {
    var msgId: String = NSUUID().uuidString
    var text: String?
    var type: String?
    var sessionId: String?
    var imgUrl: String?
    var giphy: String?
    var width: String?
    var height: String?
    var typing: Bool = false
    var menu: Menu?
    var gallery: Menu?
    var quickReply: Menu?
}

struct Menu {
    var title: String?
    var buttons: [MenuButton]?
}

struct MenuButton {
    var title: String?
    var payload: String?
    var url: String?
    var imgUrl: String?
}

enum Keys:String {
    case email
    case password
    case name
    case secret
    case clientId
    case token
}

class DataMgr {
    
    /// sharedInstance: the DataMgr singleton
    static let sharedInstance = DataMgr()
    
    static let kUserEntityName = "EUser"
    
    typealias DataMgrCallback = (EUser?) -> Void
    
    func initStore() -> Bool {
        var login:Bool = false
        let eUser:EUser? = self.getUser()
        if eUser == nil {
            login = true
        }
        return login
    }
    
    func storeUser(email: String, password: String, callback: @escaping DataMgrCallback) {
        
        if DataMgr.sharedInstance.storeKey(key: Keys.email.rawValue, value: email) &&
            DataMgr.sharedInstance.storeKey(key: Keys.password.rawValue, value: password) {
            let user:User = User(email: email, name: nil)
            saveUser(user: user, callback: callback)
        }
        else {
            callback(nil)
        }
    }
    
    func storeUserBearer(email: String, callback: @escaping DataMgrCallback) {
        if DataMgr.sharedInstance.storeKey(key: Keys.secret.rawValue, value: NSUUID().uuidString) &&
            DataMgr.sharedInstance.storeKey(key: Keys.clientId.rawValue, value: NSUUID().uuidString) &&
            DataMgr.sharedInstance.storeKey(key: Keys.name.rawValue, value: "iOS-" + NSUUID().uuidString) {
            let user:User = User(email: email, name: nil)
            saveUser(user: user, callback: callback)
        }
        else {
            callback(nil)
        }
    }
    
    // MARK:- Keychain
    
    func storeKey(key: String, value: String) -> Bool {
        return KeychainWrapper.standard.set(value, forKey: key)
    }
    
    func getKey(key: String) -> String? {
        return KeychainWrapper.standard.string(forKey: key)
    }
    
    func removeKey(key: String) -> Bool {
        return KeychainWrapper.standard.removeObject(forKey: key)
    }
    
    func removeAllKeys() -> Bool {
        return KeychainWrapper.standard.removeAllKeys()
    }
    
    // MARK: - Core Data stack
    
    func saveUser(user: User, callback: @escaping DataMgrCallback) {
        
        var eUser: EUser? = self.getUser()
        
        if eUser == nil {
            eUser = NSEntityDescription.insertNewObject(forEntityName: DataMgr.kUserEntityName, into: self.managedObjectContext) as? EUser
        }
        
        eUser?.email = user.email
        eUser?.name = user.name
        self.saveContext()
        
        callback(eUser)
    }
    
    func fetchUser() -> User? {
        
        var user:User?
        let eUser:EUser? = self.getUser()
        if eUser != nil && eUser?.email != nil {
            user = User(email: (eUser?.email)!, name: eUser?.name)
        }
        return user
    }
    
    private func getUser() -> EUser? {
        let request:NSFetchRequest<EUser> = EUser.fetchRequest()
        var eUser: EUser?
        var results:[EUser]?
        do {
            results = try self.managedObjectContext.fetch(request)
            if (results?.count)! > 0 {
                eUser = results?.first
            }
        } catch let error {
            debugPrint("error fetching user: \(error.localizedDescription)")
        }
        return eUser
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "LucasBot")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
