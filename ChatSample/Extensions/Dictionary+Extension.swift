//
//  Dictionary+Extension.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 08/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}
