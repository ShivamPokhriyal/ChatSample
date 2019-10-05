//
//  Message+CoreDataClass.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
//        return NSFetchRequest<Message>(entityName: "Message")
//    }

    @NSManaged public var message: String?
    @NSManaged public var filePath: String?
    @NSManaged public var type: Int16
    @NSManaged public var userId: String
    @NSManaged public var id: String

}
