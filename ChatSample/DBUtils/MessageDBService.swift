//
//  MessageDBService.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import CoreData

class MessageDBService {

    /// Adds a message information into local storage
    ///
    /// - Parameters:
    ///   - id: Unique UserId
    ///   - displayName: Display name of user
    ///   - imageUrl: Display picture of user
    /// - Returns: A bool indicating whether the operation was successfull
    @discardableResult
    func addMessage(id: String,
                    userId: String,
                    type: Int16,
                    message: String?,
                    filePath: String?,
                    time: Int64) -> Bool {
        guard let entity = DBHandler.shared.getMessageEntity() else { return false }
        entity.id = id
        entity.userId = userId
        entity.type = type
        entity.message = message
        entity.filePath = filePath
        entity.time = time
        return DBHandler.shared.saveContext()
    }

    /// Returns list of latest messages for all the unique conversations.
    func getMessageList() -> [Message] {
        var messageList = [Message]()
        let request = NSFetchRequest<NSDictionary>(entityName: DBHandler.Entity.message)
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
        request.propertiesToFetch = ["userId"]
        let context = DBHandler.shared.persistentContainer.viewContext
        do {
            let result = try context.fetch(request)
            for dict in result {
                guard let userId = dict["userId"] as? String else { continue }
                let messageRequest = NSFetchRequest<Message>(entityName: DBHandler.Entity.message)
                messageRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
                messageRequest.predicate = NSPredicate(format: "userId=%@", userId)
                messageRequest.fetchLimit = 1
                if let messages = DBHandler.shared.fetchRequest(messageRequest), messages.count > 0 {
                    messageList.append(messages[0])
                }
            }
        } catch {
            print(error)
        }
        messageList.sort { return $0.time > $1.time }
        return messageList
    }

    /// Returns all the messages for a user from local storage.
    func getMessagesFor(userId: String) -> [Message]? {
        let request = NSFetchRequest<Message>(entityName: DBHandler.Entity.message)
        request.returnsDistinctResults = true
        let predicate = NSPredicate(format: "userId=%@", userId)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        return DBHandler.shared.fetchRequest(request)
    }
}
