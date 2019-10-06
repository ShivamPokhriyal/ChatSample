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
    func addMessage(_ message: Message) -> Bool {
        guard let entity = DBHandler.shared.getMessageEntity() else { return false }
        entity.id = message.id
        entity.userId = message.userId
        entity.type = message.type
        entity.message = message.message
        entity.filePath = message.filePath
        entity.time = message.time
        return DBHandler.shared.saveContext()
    }

    /// Returns list of latest messages for all the unique conversations.
    func getMessageList() -> [Message]? {
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
                let messageRequest = NSFetchRequest<DBMessage>(entityName: DBHandler.Entity.message)
                messageRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
                messageRequest.predicate = NSPredicate(format: "userId=%@", userId)
                messageRequest.fetchLimit = 1
                if let messages = DBHandler.shared.fetchRequest(messageRequest), messages.count > 0 {
                    messageList.append(Message(with: messages[0]))
                }
            }
        } catch {
            print(error)
            return nil
        }
        messageList.sort { return $0.time > $1.time }
        return messageList
    }

    /// Returns all the messages for a user from local storage.
    func getMessagesFor(userId: String) -> [Message]? {
        let request = NSFetchRequest<DBMessage>(entityName: DBHandler.Entity.message)
        request.returnsDistinctResults = true
        let predicate = NSPredicate(format: "userId=%@", userId)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        guard let result = DBHandler.shared.fetchRequest(request) else { return nil }
        var messages = [Message]()
        for dbMessage in result {
            messages.append(Message(with: dbMessage))
        }
        return messages
    }
}
