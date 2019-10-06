//
//  User.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var displayName: String
    var imageUrl: String?
}

extension User {
    init(with dbUser: DBUser) {
        id = dbUser.id
        displayName = dbUser.displayName
        imageUrl = dbUser.imageUrl
    }
}
