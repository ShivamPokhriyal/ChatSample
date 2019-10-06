//
//  DBHandler.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import CoreData

class DBHandler {

    static let shared = DBHandler()
    struct Entity {
        static let user = "User"
        static let message = "Message"
    }

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ChatSample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    public func getUserEntity() -> DBUser? {
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: Entity.user, in: context) else {
            return nil
        }
        return NSManagedObject(entity: entity, insertInto: context) as? DBUser
    }

    public func getMessageEntity() -> DBMessage? {
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: Entity.message, in: context) else {
            return nil
        }
        return NSManagedObject(entity: entity, insertInto: context) as? DBMessage
    }

    /// Saves changes to persistent store
    ///
    /// - Returns: A bool indicating whether changes were saved successfully or not
    @discardableResult
    func saveContext() -> Bool {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                print("Error saving context :: \(error)")
                return false
            }
        }
        return false
    }

    func fetchRequest<T>(_ request: NSFetchRequest<T>) -> [T]? {
        let context = persistentContainer.viewContext
        do {
            return try context.fetch(request)
        } catch {
            print("Error while fetching contacts :: \(error)")
            return nil
        }
    }
}
