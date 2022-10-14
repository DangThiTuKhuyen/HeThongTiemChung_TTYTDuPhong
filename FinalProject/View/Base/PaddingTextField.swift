//
//  PaddingTextField.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 13/10/2022.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

@IBDesignable
class PaddingTextField: UITextField, UITextFieldDelegate {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 5, width: bounds.width, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 5, width: bounds.width, height: bounds.height)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
