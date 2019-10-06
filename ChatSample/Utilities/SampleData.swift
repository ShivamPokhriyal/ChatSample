//
//  SampleData.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation

struct SampleData {

    let userService = UserDBService()
    let messageService = MessageDBService()

    private let key = "SAMPLE_DATA"

    func prepare() {
        guard !UserDefaults.standard.bool(forKey: key) else { return }
        insertSampleData(with: [
            "user1",
            "user2",
            "user3",
            "user4",
            "user5",
            "user6",
            "user7",
            "user8",
            "user9",
            "user10"
            ])
        UserDefaults.standard.setValue(true, forKey: key)
        UserDefaults.standard.synchronize()
    }


    private func insertSampleData(with ids: [String]) {
        for userID in ids {
            userService.addUser(User(id: userID, displayName: userID, imageUrl: nil))
            messageService.addMessage(Message(
                message: "Hello \(userID)",
                filePath: nil,
                type: Message.MessageType.sent.rawValue,
                userId: userID,
                id: UUID().uuidString,
                time: Int64(Date().timeIntervalSince1970*1000)))
        }
    }

}
