//
//  Message.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation

struct Message {
    
    enum MessageType: Int16 {
        case Sent
        case Received
    }

    var message: String?
    var filePath: String?
    var type: Int16
    var userId: String
    var id: String
    var time: Int64
}

extension Message {
    init(with dbMessage: DBMessage) {
        message = dbMessage.message
        filePath = dbMessage.filePath
        type = dbMessage.type
        userId = dbMessage.userId
        id = dbMessage.id
        time = dbMessage.time
    }
}
