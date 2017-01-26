//
//  EUser+CoreDataProperties.swift
//  
//
//  Created by Mirko Justiniano on 1/25/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension EUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EUser> {
        return NSFetchRequest<EUser>(entityName: "EUser");
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?

}
