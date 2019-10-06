//
//  ChatDetailViewModel.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation

protocol ChatDetailDelegate: class {
    func messagesLoaded()
    func loadingError()
    func messageAdded(at position: Int)
}

class ChatDetailViewModel {

    var messages = [Message]()
    var userId: String
    weak var delegate: ChatDetailDelegate?
    var messageService = MessageDBService()
    var userService = UserDBService()

    var user: User? {
        return userService.getUserWithId(userId)
    }

    init(userId: String) {
        self.userId = userId
    }

    func prepareController() {
        guard let messageList = messageService.getMessagesFor(userId: userId) else {
            delegate?.loadingError()
            return
        }
        messages = messageList
        delegate?.messagesLoaded()
        return
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRows(in section: Int) -> Int {
        guard section < numberOfSections() else { return 0 }
        return messages.count
    }

    func message(at index: Int) -> Message? {
        guard index < messages.count else { return nil }
        return messages[index]
    }

    func sendText(_ text: String) {
        var message = getMessageTemplate()
        message.message = text
        sendMessage(message)
    }

    func sendAttachment(_ path: String) {
        var message = getMessageTemplate()
        message.filePath = path
        sendMessage(message)
    }

    private func sendMessage(_ message: Message) {
        if messageService.addMessage(message) {
            messages.append(message)
            delegate?.messageAdded(at: messages.count - 1)
            sendMessageNotification(message: message)
            reply()
        } else {
            /// Show error
        }
    }

    private func reply() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            var message = self.getMessageTemplate()
            message.type = Message.MessageType.received.rawValue
            message.message = "Any random text"
            if self.messageService.addMessage(message) {
                self.messages.append(message)
                self.delegate?.messageAdded(at: self.messages.count - 1)
                self.sendMessageNotification(message: message)
            }
        }
    }

    private func sendMessageNotification(message: Message) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendMessage"),
                                        object: message)
    }

    private func getMessageTemplate() -> Message {
        return Message(
            message: nil,
            filePath: nil,
            type: Message.MessageType.sent.rawValue,
            userId: userId, id: UUID().uuidString,
            time: Int64(Date().timeIntervalSince1970 * 1000)
        )
    }

}
