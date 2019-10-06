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
    func addUser(_ user: User) -> Bool {
        guard let entity = DBHandler.shared.getUserEntity() else { return false }
        entity.id = user.id
        entity.displayName = user.displayName
        entity.imageUrl = user.imageUrl
        return DBHandler.shared.saveContext()
    }

    /// Returns all the users in local storage
    func getAllUsers() -> [User]? {
        let request = NSFetchRequest<DBUser>(entityName: DBHandler.Entity.user)
        request.returnsDistinctResults = true
        guard let result = DBHandler.shared.fetchRequest(request) else { return nil }
        var users = [User]()
        for dbUser in result {
            users.append(User(with: dbUser))
        }
        return users
    }

    /// Returns a user from local storage whose id matches.
    func getUserWithId(_ id: String) -> User? {
        let request = NSFetchRequest<DBUser>(entityName: DBHandler.Entity.user)
        request.returnsDistinctResults = true
        let predicate = NSPredicate(format: "id=%@", id)
        request.predicate = predicate
        request.fetchLimit = 1
        if let dbUsers = DBHandler.shared.fetchRequest(request), dbUsers.count > 0 {
            return User(with: dbUsers[0])
        } else {
            return nil
        }
    }
}
