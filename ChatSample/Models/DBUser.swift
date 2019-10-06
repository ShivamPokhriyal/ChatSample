//
//  User+CoreDataClass.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class DBUser: NSManagedObject {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
//        return NSFetchRequest<User>(entityName: "User")
//    }

    @NSManaged public var id: String
    @NSManaged public var displayName: String
    @NSManaged public var imageUrl: String?

}
