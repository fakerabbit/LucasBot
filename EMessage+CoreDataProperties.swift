//
//  EMessage+CoreDataProperties.swift
//  
//
//  Created by Mirko Justiniano on 1/25/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension EMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EMessage> {
        return NSFetchRequest<EMessage>(entityName: "EMessage");
    }

    @NSManaged public var confidence: Float
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var intent: String?
    @NSManaged public var msgId: String?
    @NSManaged public var sessionId: String?
    @NSManaged public var text: String?
    @NSManaged public var type: String?

}
