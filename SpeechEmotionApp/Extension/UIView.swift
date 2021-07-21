//
//  UIView.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/20.
//

import Foundation
import UIKit

extension UIView {
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        return nil
     }
}
