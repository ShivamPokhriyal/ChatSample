//
//  String+Extension.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func rectWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGRect {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = (self as NSString).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox
    }

    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        return rectWithConstrainedWidth(width, font: font).height.rounded(.up)
    }
}
