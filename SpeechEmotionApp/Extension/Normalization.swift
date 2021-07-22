//
//  Normalization.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/22.
//

import Foundation

class Normalization {
    // 회원가입, 로그인 등 Normalization의 모든 검증을 하는 type method
    static func isValidRegEx(regExKinds: String?, objectString: String?) -> Bool {
        guard regExKinds != nil, objectString != nil else { return false }

        var regEx: String = ""
        switch regExKinds {
        case "nameRegEx": regEx = "^[가-힣]{2,10}$"
        case "emailRegEx": regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case "passwordRegEx": regEx = "[A-Za-z0-9!_@$%^&+=]{8,22}"
        default:
            return false
        }
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: objectString)
    }
}
