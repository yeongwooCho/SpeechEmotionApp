//
//  UITextField.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/20.
//

import Foundation
import UIKit

extension UITextField {
    func underlined(viewSize: CGFloat, color: UIColor){
        let border = CALayer()
        let width = CGFloat(1)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height + 10, width: viewSize - 48, height: width)
        border.borderWidth = width
        self.layer.addSublayer(border)
    }
    
//    func passwordRuleAssignment() {
//        self.textContentType = .newPassword
//        self.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit; max-consecutive: 20; minlength: 0; maxlength: 22")
//    }
}

