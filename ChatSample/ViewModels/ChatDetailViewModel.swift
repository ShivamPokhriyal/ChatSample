//
//  ChatDetailViewModel.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation

protocol ChatDetailDelegate {
    func messagesLoaded()
    func loadingError()
}

class ChatDetailViewModel {

    var messages = [Message]()
    var userId: String
    var delegate: ChatDetailDelegate?
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

    func sendMessage(text: String?, filePath: String?) {

    }

}
