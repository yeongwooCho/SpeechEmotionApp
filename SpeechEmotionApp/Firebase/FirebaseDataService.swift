//
//  FirebaseDataService.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/02.
//

import Foundation
import Firebase

fileprivate let baseRef = Database.database().reference()

class FirebaseDataService {
    static let instance = FirebaseDataService()
    
    // 특정 데이터들이 저장되는 장소에 대한 레퍼런스
    // user : 특정 사용자
    let usersRef = baseRef.child("users")
    
    // group : 채팅방 하나 단위
    let groupsRef = baseRef.child("groups")
    
    // message : 채팅 말풍선 하나 단위
    let messagesRef = baseRef.child("messages")
    
    // 현재 접속중인 유저의 uid, 현재 어플리케이션에 로그인이 되어있는지를 확인할 수 있다.
    var currentUserUid: String? {
        get {
            guard let uid = Auth.auth().currentUser?.uid else {
                return nil
            }
            return uid
        }
    }
    
    // 신규 유저 만들기
    func createUserInfoFromAuth(uid:String, userData: Dictionary<String, String>) {
        usersRef.child(uid).updateChildValues(userData)
    }
    
    // 사용자 로그인 하기
    func signIn(email withEmail: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            guard error == nil else {
                print("Error Occurred during Sign In")
                return
            }
            completion() // self.signIn에 인자로 전달한 completion을 실행하는 것이다.
        })
    }
}
