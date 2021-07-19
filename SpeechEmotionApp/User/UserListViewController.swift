//
//  UserListViewController.swift
//  SpeechEmotionApp
//
//  Created by 조영우 on 2021/07/02.
//

import UIKit

class UserListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var chatGroupVC: ChatGroupViewController?
    var userList: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUserList()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUserList() {
        FirebaseDataService.instance.usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? Dictionary<String, AnyObject>, let uid = FirebaseDataService.instance.currentUserUid {
                for (key, data) in data {
                    if uid != key { // key가 current uid이다. 나랑나랑 대화하기는 쫌...
                        if let userData = data as? Dictionary<String, AnyObject> {
                            let userName = userData["userName"] as! String
                            let email = userData["email"] as! String
                            let user = User(uid: uid, email: email, userName: userName)
                            self.userList.append(user)
                            
                            DispatchQueue.main.async(execute: {
                                self.collectionView.reloadData()
                            })
                        }
                    }
                }
            }
        })
    }
}

extension UserListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UICollectionViewCell()
        }
        cell.updateUI(at: userList[indexPath.item])
        return cell
    }
}

extension UserListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let groupRef = FirebaseDataService.instance.groupsRef.childByAutoId()
        groupRef.child("groupName").setValue(userList[indexPath.item].userName as String)
        groupRef.key
        // 현재 uid를 판단한다
        // 현재 uid 데이터에 접근한다.
        // groups 에 group의 key 정보만 넣자
//        if let currentUserUid = FirebaseDataService.instance.currentUserUid {
//            FirebaseDataService.instance.usersRef.child(currentUserUid).child("groups").setValue(groupRef)
//        }
//        여기여기 여기서 userList에서 해당 cell을 클릭하면 userList에 추가되고 groups에 채팅방이 추가 되는데
//        users에 해당하는 currentUserUid에 group이 추가되지 않아서 ChatGroupViewController에서 데이터를 불러올수가 없음
        
        dismiss(animated: true) {
            if let chatGroupVC = self.chatGroupVC {
                chatGroupVC.performSegue(withIdentifier: "chatRoom", sender: groupRef.key)
            }
        }
        return
    }
}

extension UserListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.bounds.width
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
}
