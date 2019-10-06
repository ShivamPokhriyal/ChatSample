//
//  ImageUtil.swift
//  ChatSample
//
//  Created by Shivam Pokhriyal on 06/10/19.
//  Copyright © 2019 Shivam Pokhriyal. All rights reserved.
//

import Foundation
import UIKit

struct ImageUtil {

    func compress(image: UIImage) -> Data? {
        let compressRatio: CGFloat = 0.1
        var actualWidth = image.size.width
        var actualHeight = image.size.height
        let maxHeight: CGFloat = 150
        let maxWidth: CGFloat = 250

        var imgRatio = actualWidth / actualHeight
        let maxRatio = maxWidth / maxHeight

        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            } else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            } else {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }

        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let data = img?.jpegData(compressionQuality: compressRatio)
        UIGraphicsEndImageContext()
        return data
    }

}
