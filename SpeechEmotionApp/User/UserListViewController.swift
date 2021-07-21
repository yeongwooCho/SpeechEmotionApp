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
                            let user = User(uid: uid, email: email, username: userName)
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
        let ref = FirebaseDataService.instance.groupsRef.childByAutoId()
        ref.child("name").setValue(userList[indexPath.row].username as String)
//        dismiss(animated: true) {
//            if let chatGroupVC = self.chatGroupVC {
//                chatGroupVC.performSegue(withIdentifier: "chatting", sender: ref.key)
//            }
//        }
        dismiss(animated: true, completion: nil)
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

class UserCell: UICollectionViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    func updateUI(at index: User) {
        self.usernameLabel.text = index.username
        self.emailLabel.text = index.email
    }
}
