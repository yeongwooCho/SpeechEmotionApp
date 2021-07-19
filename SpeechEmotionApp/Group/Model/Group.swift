//
//  Group.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/06.
//

import Foundation

// 채팅방: 각각의 채팅방이 가지고 있는 기본 정보와 채팅방이 포함한 말풍선들을 참고하는 데이터를 담고있다.
struct Group {
    var key: String
    var name: String
    var messages: Dictionary<String, Int>
    
    init(key: String, name: String) {
        self.key = key
        self.name = name
        self.messages = [:]
    }
    
    init(key: String, data: Dictionary<String, AnyObject>) {
        self.key = key
        self.name = data["name"] as! String
        if let messages = data["messages"] as? Dictionary<String, Int> {
            self.messages = messages
        } else {
            self.messages = [:]
        }
    }
}
