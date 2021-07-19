//
//  User.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/06.
//

import Foundation

// 사용자: 기본적인 부가정보를 담아내는 데 사용한다.
struct User {
    var uid: String
    var email: String
    var username: String
    var group: Dictionary<String, String> // 추가되어 있는 채팅방들
    
    init(uid: String, email: String, username: String) {
        self.uid = uid
        self.email = email
        self.username = username
        self.group = [:]
    }
}
