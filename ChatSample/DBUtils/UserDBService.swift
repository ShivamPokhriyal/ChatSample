//
//  UserDBService.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import CoreData

class UserDBService {

    /// Adds a user information into local storage
    ///
    /// - Parameters:
    ///   - id: Unique UserId
    ///   - displayName: Display name of user
    ///   - imageUrl: Display picture of user
    /// - Returns: A bool indicating whether the operation was successfull
    @discardableResult
    func addUser(id: String, displayName: String, imageUrl: String?) -> Bool {
        guard let entity = DBHandler.shared.getUserEntity() else { return false }
        entity.id = id
        entity.displayName = displayName
        entity.imageUrl = imageUrl
        return DBHandler.shared.saveContext()
    }

    /// Returns all the users in local storage
    func getAllUsers() -> [User]? {
        let request = NSFetchRequest<User>(entityName: DBHandler.Entity.user)
        request.returnsDistinctResults = true
        return DBHandler.shared.fetchRequest(request)
    }

    /// Returns a user from local storage whose id matches.
    func getUserWithId(_ id: String) -> User? {
        let request = NSFetchRequest<User>(entityName: DBHandler.Entity.user)
        request.returnsDistinctResults = true
        let predicate = NSPredicate(format: "id=%@", id)
        request.predicate = predicate
        if let users = DBHandler.shared.fetchRequest(request), users.count > 0 {
            return users[0]
        } else {
            return nil
        }
    }
}
