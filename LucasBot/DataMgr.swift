//
//  DataMgr.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/8/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import CoreData

/// Message: the Message model
struct Message {
    
    var msgId: String = NSUUID().uuidString
    var intent: String?
    var text: String?
    var dateCreated: Date?
    var confidence: Float?
    var type: String?
    var sessionId: String?
}

class DataMgr {
    
    /// sharedInstance: the DataMgr singleton
    static let sharedInstance = DataMgr()
    
    static let kMessageEntityName = "EMessage"
    
    typealias DataMgrCallback = (EMessage?) -> Void
    
    func storeWitMessage(message: Message, callback: @escaping DataMgrCallback) {
        
        saveMessage(message: message, callback: callback)
    }
    
    // MARK: - Core Data stack
    
    func saveMessage(message: Message, callback: @escaping DataMgrCallback) {
        
        var eMessage: EMessage?
        eMessage = NSEntityDescription.insertNewObject(forEntityName: DataMgr.kMessageEntityName, into: self.managedObjectContext) as? EMessage
        if eMessage != nil {
            eMessage?.msgId = message.msgId
            eMessage?.dateCreated = message.dateCreated as NSDate?
            eMessage?.text = message.text
            eMessage?.intent = message.intent
            eMessage?.confidence = message.confidence!
            eMessage?.type = message.type
            eMessage?.sessionId = message.sessionId
        }
        callback(eMessage)
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
