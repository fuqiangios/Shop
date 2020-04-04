//
//  NSAttributedString.swift
//  mapp
//
//  Created by Zlatna Nikolova on 11/12/2018.
//  Copyright © 2018 Home Credit Consumer Finance ltd. All rights reserved.
//

import UIKit

extension NSAttributedString {
    static func makeAttributedText(from image: UIImage) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageString = NSAttributedString(attachment: imageAttachment)
        return imageString
    }

    static func + (left: NSAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
        let left = NSMutableAttributedString(attributedString: left)
        left.append(right)
        let result = left
        return result
    }
}
