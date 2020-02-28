//
//  HelperFile.swift
//  ChatApp
//
//  Created by TRIMECH on 27/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import Foundation
import UIKit
class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
enum MessageType {
    case photo
    case text
    case video
    case location

}

enum MessageOwner {
    case sender
    case receiver
}
