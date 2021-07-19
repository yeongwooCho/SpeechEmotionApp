//
//  ChatMessage.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/06.
//

import Foundation

// 말풍선 하나: 채팅앱에서 핵심이 되는 한 단위의 메세지를 담는데 사용된다.
struct ChatMessage {
    var fromUserId: String // 누가 보냈는지
    var text: String // 내용은 뭔지
    var timestamp: NSNumber // 언제 보냈는지
}
