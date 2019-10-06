//
//  Bundle+Extension.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation

extension Bundle {
    static var chat: Bundle {
        return Bundle(for: HomeViewModel.self)
    }
}
