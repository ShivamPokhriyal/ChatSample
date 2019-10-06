//
//  HomeViewModel.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation

protocol HomeViewModelDelegate: class {
    func chatLoaded()
    func loadingError()
}

class HomeViewModel {

    var chats = [ChatItem]()
    var messageService = MessageDBService()
    var userService = UserDBService()
    weak var delegate: HomeViewModelDelegate?

    func prepareController() {
        guard let messageList = messageService.getMessageList() else {
            delegate?.loadingError()
            return
        }
        for message in messageList {
            guard let user = userService.getUserWithId(message.userId) else { continue }
            chats.append(ChatItem(message: message, user: user))
        }
        delegate?.chatLoaded()
    }

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfRows(in section: Int) -> Int {
        guard section < numberOfSections() else { return 0 }
        return chats.count
    }

    func chatItem(at index: Int) -> ChatItem? {
        guard index < chats.count else { return nil }
        return chats[index]
    }

    // TODO: Use Diffing here to reload only updated rows
    func addMessage(_ message: Message) {
        for index in 0..<chats.count {
            var current = chats[index]
            if current.message.userId == message.userId {
                current.message = message
                delegate?.chatLoaded()
                return
            }
        }
        guard let user = userService.getUserWithId(message.userId) else { return }
        chats.append(ChatItem(message: message, user: user))
        chats.sort { return $0.message.time > $1.message.time }
        delegate?.chatLoaded()
    }

}
