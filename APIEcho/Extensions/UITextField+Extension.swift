//
//  UITextField+Extension.swift
//  APIEcho
//
//  Created by Oleksandr Bardashevskyi on 09.03.2021.
//

import UIKit

extension UITextField {
    convenience init(tag: Int, returnButtonType: UIReturnKeyType, placeHolder: String, isSecurity: Bool) {
        self.init()
        
        self.tag = tag
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.clearButtonMode = .whileEditing
        self.returnKeyType = returnButtonType
        self.placeholder = placeHolder
        self.borderStyle = .roundedRect
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isSecureTextEntry = isSecurity
    }
}
