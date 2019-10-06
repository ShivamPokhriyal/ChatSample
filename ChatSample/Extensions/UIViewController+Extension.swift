//
//  UIViewController+Extension.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    var bottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.view.bottomAnchor
        }
    }

    var topAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.topAnchor
        } else {
            return self.view.topAnchor
        }
    }

    var leadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.leadingAnchor
        } else {
            return self.view.leadingAnchor
        }
    }

    var trailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.trailingAnchor
        } else {
            return self.view.trailingAnchor
        }
    }

}
