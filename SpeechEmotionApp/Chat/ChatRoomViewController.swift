//
//  ChatRoomViewController.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/02.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    @IBOutlet weak var item: UINavigationItem! // 채팅방 navigation 아이템을 아무거나 지정해서 수정가능
    @IBOutlet weak var chatCollectionView: UICollectionView! // 채팅방 구조 컨트롤 및 reload 용
    @IBOutlet weak var sendButton: UIButton! // 메세지 보내기 버튼
    @IBOutlet weak var chatTextField: UITextField! // 메세지 넣을 곳
    
    // 현재 채팅창의 대화 목록
    var messages: [ChatMessage] = [ChatMessage(fromUserId: "", text: "", timestamp: 0)]
    
    // 채팅 목록 창에서 특정 채팅방을 선택하면 그 채팅방을 구별할 수 있는 그룹키를 가져와야한다. 채팅방 호수라고 생각하자.
    var groupKey: String? {
        didSet {
            if let key = groupKey {
                fetchMessages() // 호수 알았으면 정보를 들고온다.
                
                // 얘는 DB에서 이벤트 발생시 데이터 읽는 함수: group의 name key를 이용해서 유저이름을 방 제목으로 설정하는 것
                FirebaseDataService.instance.groupsRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let data = snapshot.value as? Dictionary<String, AnyObject> {
                        if let title = data["name"] as? String {
                            self.item.title = title
                        }
                    }
                })
            }
        }
    }
    
    // collectionView를 선택하면 키보드 내려가는 거임
    @IBAction func collectionViewTapped(_ sender: Any) {
        chatTextField.resignFirstResponder()
    }
    
    // 메세지 보내기 버튼: 메세지를 보내면 파이어베이스의 데이터베이스에 채팅메세지가 기록된다.
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        // messageRef table에서 시간순으로 자동정렬된 고유키를 만드는것, 메세지 기록하려고 만드는 값
        let ref = FirebaseDataService.instance.messagesRef.childByAutoId()
        
        // 현재 uid를 보면 등장한 메세지가 나인지 상대인지를 판단할 수 있다.
        // 현재 uid받아올 수 없다면 return 한다.
        guard let fromUserId = FirebaseDataService.instance.currentUserUid else {
            return
        }
        
        // 말풍선 하나를 위에서 시간순으로 정렬되는 row에 update시키기
        // ChatMessage struct
        let data: Dictionary<String, AnyObject> = [
            "fromUserId": fromUserId as AnyObject,
            "text": chatTextField.text! as AnyObject,
            "timestamp": NSNumber(value: Date().timeIntervalSince1970)
        ]
        // data를 정상적으로 업데이트 시켰으면 뒤의 클로져를 실행하는 함수이다.
        ref.updateChildValues(data) { (err, ref) in
            // 에러있으면 띄워라.
            guard err == nil else {
                print(err as Any)
                return
            }
            
            // textfield reset, 현재 채팅방의 table의 messages부분에
            self.chatTextField.text = nil
            if let groupId = self.groupKey {
                FirebaseDataService.instance.groupsRef.child(groupId).child("messages").updateChildValues([ref.key: 1]) // 근데 방호수가 왜 계속 1 이지??
            }
        }
    }
    
    // groupKey를 이용해서 해당 채팅방 데이터의 레버런스를 얻고, 이 레퍼런스를 활용하여 이 채팅방의 기본정보와 이 방안에서 이루어진 모든 채팅 메세지를 가져온다.
    func fetchMessages() {
        if let groupId = self.groupKey {
            let groupMessagesRef = FirebaseDataService.instance.groupsRef.child(groupId).child("messages")
            
            // 해당 groupId에 맞는 테이블을 가져오는 것이다.
            groupMessagesRef.observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                let messageRef = FirebaseDataService.instance.messagesRef.child(messageId)
                messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dict = snapshot.value as? Dictionary<String, AnyObject> else {
                        return
                    }
                    let message = ChatMessage(
                        fromUserId: dict["fromUserId"] as! String,
                        text: dict["text"] as! String,
                        timestamp: dict["timestamp"] as! NSNumber
                    )
                    self.messages.insert(message, at: self.messages.count - 1)
                    self.chatCollectionView.reloadData()
                    if self.messages.count >= 1 {
                        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                        self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition(), animated: true)
                    }
                })
            })
        }
    }
}

extension ChatRoomViewController: UICollectionViewDataSource {
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 메세지 갯수만큼 cell 보여주기
        return messages.count
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textLabel.text = message.text
        setupChatCell(cell: cell, message: message)
        
//        if message.text.characters.count > 0 {
        if message.text.count > 0 {
            cell.containerViewWidthAnchor?.constant = measuredFrameHeightForEachMessage(message: message.text).width + 32
        }
        return cell
    }
}

extension ChatRoomViewController: UICollectionViewDelegate {
    
}

extension ChatRoomViewController: UICollectionViewDelegateFlowLayout {
    // sizeForItemAt
    // 채팅 메세지가 포함한 정보중에 fromUserId라는 정보가 로그인한 유저와 동일하면 오른쪽, 아니면 왼쪽으로 붙힌다.
    func setupChatCell(cell: ChatMessageCell, message: ChatMessage) {
        if message.fromUserId == FirebaseDataService.instance.currentUserUid {
            cell.containerView.backgroundColor = UIColor.magenta
            cell.textLabel.textColor = UIColor.white
            cell.containerViewRightAnchor?.isActive = true
            cell.containerViewLeftAnchor?.isActive = false
        } else {
            cell.containerView.backgroundColor = UIColor.lightGray
            cell.textLabel.textColor = UIColor.black
            cell.containerViewRightAnchor?.isActive = false
            cell.containerViewLeftAnchor?.isActive = true
        }
    }
    
    private func measuredFrameHeightForEachMessage(message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}

extension ChatRoomViewController: UITextFieldDelegate {
    
}
